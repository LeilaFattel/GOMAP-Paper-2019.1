require "yaml"
require "json"
require "set"
require "fileutils"
require "csv"

require_relative "ontology_class"

def jaccard_distance(s1, s2)
  # 1 - length of intersect/length of union
  1.0 - (s1 & s2).size.to_f / (s1 | s2).size.to_f
end

def write_distance_matrix(annotation_sets, filepath, filemode="w")
  distances = {}
  species = annotation_sets.keys.sort

  species[0..-2].each_with_index do |n1, i1 |
    set1 = annotation_sets[n1]
    species[i1+1..-1].each do | n2 |
      set2 = annotation_sets[n2]
      distances[n1] = {} unless distances.keys.include? n1
      distances[n1][n2] = jaccard_distance(set1.to_set, set2.to_set)
    end
  end

  File.open(filepath, filemode) do |f|
    # Print distance matrix
    f.write("   #{annotation_sets.size}\n")
    species.each do | n1 |
      f.write(n1[0..9].ljust(12)) # names can only be 10 chars long and then need to be followed by 2 spaces for the neighbor program to work
      species.each do | n2 |
        if n1 == n2
          f.write("0.000000 ")
        elsif distances.keys.include?(n1) && distances[n1].keys.include?(n2)
          f.write("#{distances[n1][n2].round(6).to_s.ljust(8,'0')} ")
        else
          f.write("#{distances[n2][n1].round(6).to_s.ljust(8,'0')} ")
        end
      end
      f.write "\n"
    end
  end
end

def write_binary_matrix(annotation_sets, filepath, filemode="w")
  columns = annotation_sets.values.map(&:to_a).flatten.uniq
  File.open(filepath, filemode) do |f|
    f.write("     #{annotation_sets.length}   #{columns.length}\n")
    annotation_sets.each do |species, set|
      f.write species[0..9].ljust(12)
      f.write columns.map {|t| set.include?(t) ? 1 : 0 }.join("") + "\n"
    end
  end
end

def write_binary_csv(annotation_sets, filepath, taxon_map = nil)
  columns = annotation_sets.values.map(&:to_a).flatten.uniq
  CSV.open(filepath, "wb") do |csv|
    csv << ["taxon"] + columns
    annotation_sets.each do |species, set|
      if taxon_map
        csv << [taxon_map.key(species)] + columns.map {|t| set.include?(t) ? 1 : 0 }
      else
        csv << [species] + columns.map {|t| set.include?(t) ? 1 : 0 }
      end
    end
  end
end

def sample_from_set(set, percentage)
  terms_to_sample = (set.length * (1.0 - percentage.to_f/100)).floor
  set.to_a.sample(terms_to_sample).to_set
end

def run_phylip(tree_name, phylip_bin, outtree_name, script, taxon_map = nil)
  Dir.chdir("analyses/treebuilding/results/trees/#{tree_name}") do
    File.write("phylip.in", script)
    system("#{phylip_bin} < phylip.in")
    if taxon_map
      # Rename species back to original names
      newick = File.read("outtree")
      taxon_map.each do |species, id|
        newick.gsub!(id, species)
      end
      File.write(outtree_name, newick)
      FileUtils.rm("outtree")
    else
      FileUtils.mv("outtree", outtree_name)
    end
    FileUtils.rm("outfile")
    FileUtils.rm("phylip.in")
  end
end

ontology = Ontology.from_json_file("analyses/cleanup/results/GO.json")

ARGV.each do |desired_tree|
  name = desired_tree.split(".").first.split("/").last
  puts name

  # Delete directory if it exists to make sure we don't get overlapping jackknifing stuff
  FileUtils.rm_rf("analyses/treebuilding/results/trees/#{name}") if File.directory? "analyses/treebuilding/results/trees/#{name}"
  FileUtils.mkdir_p("analyses/treebuilding/results/trees/#{name}")

  yaml = YAML.load(File.read(desired_tree))

  # Map each species name to a unique id of the form !a3! which is later translated back in the final tree
  species_map = yaml["species"].map.with_index { |s, i| [s, "!#{i.to_s(36)}!"] }.to_h

  aspects = yaml.keys.include?("aspects") ? yaml["aspects"] : ["A", "F", "P", "C"] 

  aspects.each do |aspect|
    if yaml.keys.include?("exclude_terms")
      # Terms should be excluded from the original sets, so we need to re-do the ancestor adding
      ancestor_sets = yaml["species"].each_with_object({}) do |s, a|
        a[species_map[s]] = ontology.set_with_ancestors(JSON.parse(File.read("analyses/treebuilding/results/sets/original/#{s}.json"))[aspect].map(&:to_sym).to_set - yaml["exclude_terms"].map(&:to_sym).to_set)
      end
    else
      ancestor_sets = yaml["species"].each_with_object({}) do |s, a|
        a[species_map[s]] = JSON.parse(File.read("analyses/treebuilding/results/sets/with_ancestors/#{s}.json"))[aspect].map(&:to_sym).to_set
      end
    end

    if yaml["nj"] # Build a Neighbor-Joining tree
      puts "Building neighbor joining tree for aspect #{aspect}"
      write_distance_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/distance_matrix_#{aspect}.phy")
      run_phylip(name, "neighbor", "nj_#{aspect}.tree", "distance_matrix_#{aspect}.phy\nY", species_map)
    end

    if yaml["parsimony"] # Build parsimony tree
      puts "Building parsimony tree for aspect #{aspect}"
      write_binary_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/binary_matrix_#{aspect}.phy")
      write_binary_csv(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/binary_matrix_#{aspect}.csv", species_map)
      run_phylip(name, "pars", "parsimony_#{aspect}.tree", [
            "binary_matrix_#{aspect}.phy",
            "J",
            2*rand(1000)+1,
            2*Math.sqrt(yaml["species"].length).ceil, # number of times to jumble species
            "Y"
          ].join("\n"), species_map)
    end

    if yaml.keys.include? "jackknives"
      puts "Jackknifing trees for aspect #{aspect}..."
      original_sets = yaml["species"].each_with_object({}) do |s, a|
        a[species_map[s]] = JSON.parse(File.read("analyses/treebuilding/results/sets/original/#{s}.json"))[aspect].map(&:to_sym).to_set
      end

      original_set = original_set - yaml["exclude_terms"].map(&:to_sym).to_set if yaml.keys.include?("exclude_terms")

      yaml["jackknives"]["percentages"].each do |p|

        yaml["jackknives"]["n_trees"].times do |jackknife_index|
          puts " #{p}%, tree #{jackknife_index}"
          jackknifed_sets_original = original_sets.each_with_object({}) { |(name, set), a| a[name] = sample_from_set(set, p)}
          jackknifed_sets_with_ancestors = jackknifed_sets_original.each_with_object({}) { |(name, set), a | a[name] = ontology.set_with_ancestors(set)}

          if yaml["nj"]
            write_distance_matrix(jackknifed_sets_with_ancestors, "analyses/treebuilding/results/trees/#{name}/distance_matrix_jackknifed_#{aspect}_#{p}.phy", "a")
          end

          if yaml["parsimony"]
            write_binary_matrix(jackknifed_sets_with_ancestors, "analyses/treebuilding/results/trees/#{name}/binary_matrix_jackknifed_#{aspect}_#{p}.phy", "a")
          end
        end

        if yaml["nj"]
          run_phylip(name, "neighbor", "nj_jackknifed_#{aspect}_#{p}_all.tree", [
            "distance_matrix_jackknifed_#{aspect}_#{p}.phy",
            "M",
            yaml["jackknives"]["n_trees"],
            (2*rand(1000)+1).to_s,
            "Y"
          ].join("\n"))
          run_phylip(name, "consense", "nj_jackknifed_#{aspect}_#{p}.tree", "nj_jackknifed_#{aspect}_#{p}_all.tree\nY", species_map)
        end

        if yaml["parsimony"]
          run_phylip(name, "pars", "parsimony_jackknifed_#{aspect}_#{p}_all.tree", [
            "binary_matrix_jackknifed_#{aspect}_#{p}.phy",
            "M",
            "D",
            yaml["jackknives"]["n_trees"],
            (2*rand(1000)+1).to_s,
            2*Math.sqrt(yaml["species"].length).ceil, # number of times to jumble species
            "Y"
          ].join("\n"))
          run_phylip(name, "consense", "parsimony_jackknifed_#{aspect}_#{p}.tree", "parsimony_jackknifed_#{aspect}_#{p}_all.tree\nY", species_map)
        end

      end
    end
  end
end


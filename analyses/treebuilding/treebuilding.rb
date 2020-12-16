require "yaml"
require "json"
require "set"
require "pry"
require "fileutils"

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

def sample_from_set(set, percentage)
  terms_to_sample = (set.length * (1.0 - percentage.to_f/100)).floor
  set.to_a.sample(terms_to_sample).to_set
end

def add_ancestors_to_set(set, ontology)
  i = 0
  set.inject(Set.new) do |s, term| 
    if s.add? term # returns nil if term already present, then also all ancestors are already present
      s.merge(ontology.ancestors_of(term, s))
    else
      s
    end
  end
end

ontology = Ontology.from_json_file("analyses/cleanup/results/GO.json")

Dir.glob("data/desired_trees/*.yaml").each do |desired_tree|
  name = desired_tree.split(".").first.split("/").last
  puts name

  # Delete directory if it exists to make sure we don't get overlapping jackknifing stuff
  FileUtils.rm_rf("analyses/treebuilding/results/trees/#{name}") if File.directory? "analyses/treebuilding/results/trees/#{name}"
  FileUtils.mkdir_p("analyses/treebuilding/results/trees/#{name}")

  yaml = YAML.load(File.read(desired_tree))

  ancestor_sets = yaml["species"].each_with_object({}) do |s, a|
    a[s] = JSON.parse(File.read("analyses/treebuilding/results/sets/with_ancestors/#{s}.json")).map(&:to_sym).to_set
  end

  if yaml["nj"] # Build a Neighbor-Joining tree
    puts "Building neighbor joining tree"
    write_distance_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/distance_matrix.phy")
  end

  if yaml["parsimony"] # Build parsimony tree
    puts "Building parsimony tree"
    write_binary_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/binary_matrix.phy")
  end

  if yaml.keys.include? "jackknives"
    puts "Jackknifing trees..."
    original_sets = yaml["species"].each_with_object({}) do |s, a|
      a[s] = JSON.parse(File.read("analyses/treebuilding/results/sets/original/#{s}.json")).map(&:to_sym).to_set
    end

    yaml["jackknives"]["percentages"].each do |p|

      yaml["jackknives"]["n_trees"].times do |jackknife_index|
        puts " #{p}%, tree #{jackknife_index}"
        jackknifed_sets_original = original_sets.each_with_object({}) { |(name, set), a| a[name] = sample_from_set(set, p)}
        jackknifed_sets_with_ancestors = jackknifed_sets_original.each_with_object({}) { |(name, set), a | a[name] = add_ancestors_to_set(set, ontology)}

        write_distance_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/distance_matrix_jackknifed_#{p}.phy", "a") if yaml["nj"]
        write_binary_matrix(ancestor_sets, "analyses/treebuilding/results/trees/#{name}/binary_matrix_jackknifed_#{p}.phy", "a") if yaml["parsimony"]
      end

    end
  end
end


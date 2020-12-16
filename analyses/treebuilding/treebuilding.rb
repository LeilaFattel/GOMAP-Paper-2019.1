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

def write_distance_matrix(annotation_sets, filepath)
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

  File.open(filepath, "w") do |f|
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

def write_binary_matrix(annotation_sets, filepath)
  columns = annotation_sets.values.map(&:to_a).flatten.uniq
  File.open(filepath, "w") do |f|
    f.write("     #{annotation_sets.length}   #{columns.length}\n")
    annotation_sets.each do |species, set|
      f.write species[0..9].ljust(12)
      f.write columns.map {|t| set.include?(t) ? 1 : 0 }.join("") + "\n"
    end
  end
end

ontology = Ontology.from_json_file("analyses/cleanup/results/GO.json")

Dir.glob("data/desired_trees/*.yaml").each do |desired_tree|
  name = desired_tree.split(".").first.split("/").last
  FileUtils.mkdir_p("analyses/treebuilding/results/trees/#{name}") unless File.directory? "analyses/treebuilding/results/trees/#{name}"

  yaml = YAML.load(File.read(desired_tree))

  annotation_sets = yaml["species"].each_with_object({}) do |s, a|
    puts s
    a[s] = JSON.parse(File.read("analyses/treebuilding/results/sets/with_ancestors/#{s}.json")).map(&:to_sym).to_set
  end

  if yaml["nj"] # Build a Neighbor-Joining tree
    write_distance_matrix(annotation_sets, "analyses/treebuilding/results/trees/#{name}/distance_matrix.phy")
  end

  if yaml["parsimony"] # Build parsimony tree
    write_binary_matrix(annotation_sets, "analyses/treebuilding/results/trees/#{name}/binary_matrix.phy")
  end
end


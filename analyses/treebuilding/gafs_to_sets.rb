require "json"
require "csv"
require "set"
require "zlib"
require "fileutils"

require_relative "ontology_class"

ontology = Ontology.from_json_file("analyses/cleanup/results/GO.json")
gaf_files = Dir.glob("analyses/cleanup/results/*/GOMAP.gaf.gz")

FileUtils.mkdir_p("analyses/treebuilding/results/sets/original") unless File.directory? "analyses/treebuilding/results/sets/original"
FileUtils.mkdir_p("analyses/treebuilding/results/sets/with_ancestors") unless File.directory? "analyses/treebuilding/results/sets/with_ancestors"

gaf_files.each do |gaf_file|
  taxon_name = gaf_file.split("/")[-2]
  puts "Processing #{gaf_file}..."

  original_sets = {
    "F" => Set.new(),
    "P" => Set.new(),
    "C" => Set.new()
  }

  Zlib::GzipReader.open(gaf_file) do |gz|
    CSV.new(gz, col_sep: "\t", skip_lines: /^!/).each do |row|
      original_sets[row[8]].add(row[4].to_sym)
    end
  end

  original_sets["A"] = original_sets.values.inject(Set.new()){|s, t| s = s + t}

  with_ancestors = original_sets.map{ |a, t| [a, ontology.set_with_ancestors(t)]}.to_h

  File.write("analyses/treebuilding/results/sets/original/#{taxon_name}.json", original_sets.map{|a, t| [a, t.to_a.map(&:to_s)]}.to_h.to_json)
  File.write("analyses/treebuilding/results/sets/with_ancestors/#{taxon_name}.json", with_ancestors.map{|a, t| [a, t.to_a.map(&:to_s)]}.to_h.to_json)
end

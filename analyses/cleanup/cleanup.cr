require "csv"
require "gzip"
require "../shared/common_lib.cr"

abort "No arguments given" unless ARGV.size > 0

# Helper function that extracts the genome and dataset name from a file path.
# For example: data/go_annotation_sets/Oryza_sativa/GOMAP.gaf.gz -> [Oryza_sativa, GOMAP]
def filepath2genome_dataset(fp)
  dataset = File.basename(fp).chomp(".gz").chomp(".gaf").chomp(".mgaf") # Split into chomps so that also uncompressed files have their extension removed
  genome  = File.dirname(fp).split(File::SEPARATOR).last
  return [genome, dataset]
end

# Adds, updates, or removes an entry from the CSV file:
# - if obsolete or duplicates is nil (not 0), the entry is removed
# - otherwise, if the entry already exists, it is updated
# - if it does not, it is created
def update_csv(genome, dataset, obsolete, duplicates, modified)
  table = CSV.parse(File.open("analyses/cleanup/results/cleanup_table.csv")).to_a
  table.shift # Remove header
  if obsolete.nil? || duplicates.nil?
    table.reject! {|r| r[0] == genome && r[1] == dataset }
  else
    selected_elements = table.select {|r| r[0] == genome && r[1] == dataset }
    case selected_elements.size
    when 0
      table << [genome, dataset, obsolete.to_s, duplicates.to_s]
    when 1
      selected_elements.first[2] = obsolete.to_s
      selected_elements.first[3] = duplicates.to_s
      selected_elements.first[4] = modified.to_s
    else
      abort("Duplicate entry for #{genome}/#{dataset}")
    end
  end
  table = table.sort {|a,b| a[0]+a[1] <=> b[0]+b[1]} # Sort by Genome->Dataset
  File.open("analyses/cleanup/results/cleanup_table.csv", "w") do |f|
    CSV.build(f) do |writer|
      writer.row(["genome","dataset","obsolete","duplicates","modified"])
      table.each {|row| writer.row(row) }
    end
  end
end

if ARGV.first == "--delete"
  genome, dataset = filepath2genome_dataset(ARGV[1])
  File.delete("analyses/cleanup/results/#{genome}/#{dataset}.gaf.gz")
  update_csv(genome, dataset, nil, nil, nil)
else
  abort "File #{ARGV.first} not found" unless File.exists? ARGV.first
  genome, dataset = filepath2genome_dataset(ARGV.first)

  puts " Loading Ontology"
  go = File.open("analyses/cleanup/results/GO.json") do |gofile|
    Ontology.from_json(gofile)
  end

  # By supplying a map file you can make cleanup change the ids in the id column
  mapping_present = false
  object_id_map = Hash(String, String).new # Old id -> new id
  if File.exists? ARGV.first.chomp(".gz").chomp(".gaf") + ".map.gz"
    mapping_present = true
    Gzip::Reader.open(ARGV.first.chomp(".gz").chomp(".gaf") + ".map.gz") do |mapfile|
      reader = CSV.new(mapfile, separator:'\t')
      while reader.next
        row = reader.row.to_a
        object_id_map[row[0]] = row[1]
      end
    end
  end

  puts " Processing " + ARGV.first
  n_obsolete = 0
  n_duplicates = 0
  n_modifiers = 0
  Gzip::Reader.open(ARGV.first) do |infile|
    reader = CSV.new(infile, separator:'\t')
    Dir.mkdir_p("analyses/cleanup/results/#{genome}")
    Gzip::Writer.open("analyses/cleanup/results/#{genome}/#{dataset}.gaf.gz", Gzip::BEST_COMPRESSION) do |outfile|

      printed_tuples = Set(Tuple(String, String)).new

      CSV.build(outfile, separator:'\t') do |writer|
        # Write GAF headers
        2.times do
          reader.next
          writer.row reader.row.to_a
        end

        while reader.next
          row = reader.row.to_a
          unless row[3] == "" || row[3] == "0" # If modifier not empty or 0: skip this line
            n_modifiers += 1
            next
          end
          row[4] = go.main_id_of(row[4])
          if go.is_obsolete?(row[4])
            n_obsolete += 1
            next
          end
          if mapping_present && object_id_map.has_key?(row[1])
            row[1] = object_id_map[row[1]]
          end
          if printed_tuples.add?({row[1], row[4]}) # This returns false if the tuple is already present in the set
            writer.row row.to_a
          else
            n_duplicates += 1
          end
        end
      end
    end
  end
  update_csv(genome, dataset, n_obsolete, n_duplicates, n_modifiers)
end

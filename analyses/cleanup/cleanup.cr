KEEP_COLUMNS = [1,3,4,8]

require "json"
require "csv"
require "gzip"

class Ontology
  JSON.mapping(
    parents: Hash(String, Array(String)),
    main_id: Hash(String, String),
    obsolete: Array(String)
  )

  def ancestors_of(go_id)
    ancestors = Set.new [] of String
    if !@parents.keys.includes? go_id
      puts "WARNING: not in Ontology: #{go_id}"
      return ancestors
    end
    @parents[go_id].each do |p|
      ancestors.add(p)
      ancestors.concat(ancestors_of(p))
    end
    return ancestors
  end

  def is_obsolete?(go_id)
    return @obsolete.includes?(go_id)
  end

  def main_id_of(go_id)
    return @main_id.keys.includes?(go_id) ? @main_id[go_id] : go_id
  end

end

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
def update_csv(genome, dataset, obsolete, duplicates)
  table = CSV.parse(File.open("analyses/cleanup/results/cleanup_table.csv")).to_a
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
    else
      abort("Duplicate entry for #{genome}/#{dataset}")
    end
  end
  File.open("analyses/cleanup/results/cleanup_table.csv", "w") do |f|
    CSV.build(f) do |writer|
      table.each {|row| writer.row(row) }
    end
  end
end

if ARGV.first == "--delete"
  genome, dataset = filepath2genome_dataset(ARGV[1])
  File.delete("analyses/cleanup/results/#{genome}/#{dataset}.mgaf.gz")
  update_csv(genome, dataset, nil, nil)
else
  abort "File #{ARGV.first} not found" unless File.exists? ARGV.first
  genome, dataset = filepath2genome_dataset(ARGV.first)

  puts " Loading Ontology"
  go = File.open("analyses/cleanup/results/GO.json") do |gofile|
    Ontology.from_json(gofile)
  end

  puts " Processing " + ARGV.first
  n_obsolete = 0
  n_duplicates = 0
  Gzip::Reader.open(ARGV.first) do |infile|
    reader = CSV.new(infile, separator:'\t')
    Gzip::Writer.open("analyses/cleanup/results/#{genome}/#{dataset}.mgaf.gz", Gzip::BEST_COMPRESSION) do |outfile|

      printed_tuples = Set(Tuple(String, String)).new

      CSV.build(outfile, separator:'\t') do |writer|
        # Skip first GAF header
        reader.next
        # Write selected parts of second GAF header
        reader.next
        writer.row KEEP_COLUMNS.map { |i| reader.row[i] }

        while reader.next
          row = reader.row.to_a
          row[4] = go.main_id_of(row[4])
          if go.is_obsolete?(row[4])
            n_obsolete += 1
            next
          end
          if printed_tuples.add?({row[1], row[4]}) # This returns false if the tuple is already present in the sent
            writer.row KEEP_COLUMNS.map { |i| row[i] }
          else
            n_duplicates += 1
          end
        end
      end
    end
  end
  update_csv(genome, dataset, n_obsolete, n_duplicates)
end

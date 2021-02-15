# This file converts the TSV files downloaded from Gramene to the GAF 2 format
# Usage:
#  ruby phytozome2gaf.rb <TSV file> <db column string> <taxon id> <go aspect json>
# Example:
#  ruby phytozome2gaf.rb Oryza_sativa/Phytozome12.tsv "Phytozome12/Plant_Genomes/Oryza_sativa" 4530 ../../analyses/cleanup/results/GO_aspects.json > Oryza_sativa/Gramene61_IEA.gaf

require "csv"
require "json"

# Print GAF headers
puts "!gaf-version:2.0"
puts "!db	db_object_id	db_object_symbol	qualifier	term_accession	db_reference	evidence_code	with	aspect	db_object_name	db_object_synonym	db_object_type	taxon	date	assigned_by	annotation_extension	gene_product_form_id"

# Load GO aspects
go_aspects = JSON.parse(File.read(ARGV[3]))

CSV.open(ARGV[0], col_sep:"\t", headers:true).each do |row|
  if row[1]
    puts [ARGV[1], row[0], row[0], "", row[1], "", "IEA", "", go_aspects[row[1]], "", "", "protein", "taxon:#{ARGV[2]}", "", "", "", ""].join("\t")
  end
end

require "csv"

task :default => 'Paper.pdf'

desc 'Typeset the Paper'
file 'Paper.pdf' => ['analyses/quantity/results/quantity_table.csv', 'analyses/quality/quality_table.csv'] + FileList.new("text/*") do
  rm_f 'text/_main.Rmd'
  sh %q(R -e 'library("bookdown"); xfun::in_dir("text", render_book("index.Rmd", output_file="../../Paper.pdf", clean=T))')
end


# Cleanup
def cleanup
  rm_rf 'analyses/cleanup/results/*'
  sh 'python analyses/cleanup/cleanup.py'
end

## cleanup executable
file 'analyses/cleanup/cleanup' => 'analyses/cleanup/cleanup.cr' do
  sh 'crystal build --release --no-debug -o analyses/cleanup/cleanup analyses/cleanup/cleanup.cr'
end

## converted GO files
go_files = ['analyses/cleanup/results/GO.json', 'analyses/cleanup/results/GO_names.json']
go_files.each do |f|
  file f => ['analyses/cleanup/convert_obo.py', 'analyses/cleanup/go.obo.gz', 'analyses/cleanup/obo_parser.py'] do
    sh 'python analyses/cleanup/convert_obo.py'
  end
end

## Collect everything that needs to be up-to-date after cleanup
cleanup_targets = ['analyses/cleanup/results/cleanup_table.csv']

## For each raw dataset there should be an up-to-date cleaned one
FileList.new("data/go_annotation_sets/*/*.gaf.gz").to_a.each do |f|
  # Corresponding cleaned up file:
  target = "analyses/cleanup/results/" + ((f.split(".")[0..-3] + ["gaf.gz"]).join(".").split("/")[2..-1]).join("/")
  # The cleaned up file depends on its source file, the cleanup executable and the go_files
  file target => [f, 'analyses/cleanup/cleanup'] + go_files do
    sh "analyses/cleanup/cleanup #{f}"
  end
  # The cleanup_table also depends on each of these things (in the loop because it depends on all source files)
  file 'analyses/cleanup/results/cleanup_table.csv' => [f, 'analyses/cleanup/cleanup'] + go_files do
    sh "analyses/cleanup/cleanup #{f}"
  end
  cleanup_targets << target
end

## If there are any cleaned up files that do not have a source file anymore, remove them
(FileList.new("analyses/cleanup/results/*/*.gaf.gz").to_a - cleanup_targets).each do |f|
    sh "analyses/cleanup/cleanup --delete #{f}"
end

desc 'Clean up datasets'
# Cleanup depends on all cleanup target files
task :cleanup => cleanup_targets

desc 'Quantity analysis'
file 'analyses/quantity/results/quantity_table.csv' => cleanup_targets + ['data/n_genes_per_genome.csv', 'analyses/quantity/quantity.R'] do
  sh "Rscript analyses/quantity/quantity.R"
end

desc 'Run unit tests for analyses code'
task :test do
  sh 'crystal spec'
end

# Quality Evaluation
## For each Gold Standard there should be an ADS equivalent
quality_targets = []
FileList.new("analyses/cleanup/results/*/GoldStandard.gaf.gz").to_a.each do |f|
  genome = File.basename(File.dirname(f))
  # We're taking the corresponding ic.tab file as a representative for all files created by ADS
  file "analyses/quality/#{genome}/ic.tab" => f do
    Dir.chdir("analyses/quality/ads/") do # ADS requires to be run from the ads directory
      sh "gunzip -k ../../cleanup/results/#{genome}/GoldStandard.gaf.gz"
      sh "gunzip -k ../../cleanup/go.obo.gz"
      rm_f "../#{genome}/ic.* ../#{genome}/goparents.tab" # Remove old files to start from a clean slate
      sh "perl pipeline.pl --datadir ../#{genome}/ --obo ../../cleanup/go.obo --goa ../../cleanup/results/#{genome}/GoldStandard.gaf --pipev 1,2"
      sh "tail -n+3 ../../cleanup/results/#{genome}/GoldStandard.gaf | cut -f2,5 > ../#{genome}/GoldStandard.tsv"
      rm "../../cleanup/results/#{genome}/GoldStandard.gaf"
      rm "../../cleanup/go.obo"
    end
  end

  # For each of the genomes where a Gold Standard is present, all other datasets should also be evaluated
  FileList.new("analyses/cleanup/results/#{genome}/*.gaf.gz").to_a.each do |ds|
    dataset = File.basename(ds).split(".").first
    target = "analyses/quality/#{genome}/#{dataset}.SimGIC2"
    file target => [ds, "analyses/quality/#{genome}/ic.tab"] do
      Dir.chdir("analyses/quality/ads/") do # ADS requires to be run from the ads directory
        sh "gunzip -k ../../cleanup/go.obo.gz"
        sh "gunzip -k ../../cleanup/results/#{genome}/#{dataset}.gaf.gz"
        IO.write("../#{genome}/#{dataset}.predictions", "foobar\tGO:00000331\t0")
        sh "tail -n+3 ../../cleanup/results/#{genome}/#{dataset}.gaf | cut -f2,5 | awk '{print $0\"\\t1\"}' >> ../#{genome}/#{dataset}.predictions"
        sh "bin/goscores -p ../#{genome}/#{dataset}.predictions -t ../#{genome}/GoldStandard.tsv -g -b ../../cleanup/go.obo -i ../#{genome}/ic.tab ../#{genome}/goparents.tab -m 'SF=SimGIC2' > ../#{genome}/#{dataset}.SimGIC2"
        rm "../../cleanup/go.obo"
        rm "../../cleanup/results/#{genome}/#{dataset}.gaf"
      end
    end
    quality_targets << target
  end
end

# Collect all SimGIC2 scores in a table
file 'analyses/quality/quality_table.csv' => quality_targets do
  CSV.open("analyses/quality/quality_table.csv", "wb+") do |csv|
    csv << ["genome", "dataset", "SimGIC2"]
    quality_targets.each do |t|
      dataset = File.basename(t).split(".").first
      genome = File.basename(File.dirname(t))
      score = IO.read(t).chomp
      csv << [genome, dataset, score]
    end
  end
end

desc 'Perform Quality evaluation'
task :quality => 'analyses/quality/quality_table.csv'

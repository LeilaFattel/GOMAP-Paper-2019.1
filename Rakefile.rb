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
  file f => ['analyses/cleanup/convert_obo.py', 'data/go.obo.gz', 'analyses/cleanup/obo_parser.py'] do
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
# Stuff that needs to be created only once from the GOA/OBO
file "analyses/quality/ads_files/ic.tab" => ["data/go.obo.gz", "data/goa_arabidopsis.gaf.gz"] do
  sh "gunzip -k data/go.obo.gz"
  sh "gunzip -k data/goa_arabidopsis.gz"
  rm_rf "analyses/quality/ads_files/*" # make a clean slate
  Dir.chdir("analyses/shared/ads/") do # ADS requires to be run from the ads directory
    sh "perl pipeline.pl --datadir ../../quality/ads_files --obo ../../../data/go.obo --goa ../../../data/goa_arabidopsis.gaf --pipev 1,2"
  end
  rm "data/go.obo"
  rm "data/goa_arabidopsis.gaf"
end

quality_targets = []
## For each Gold Standard there should be an ADS equivalent
FileList.new("analyses/cleanup/results/*/GoldStandard.gaf.gz").to_a.each do |f|
  genome = File.basename(File.dirname(f))
  # Reformat the Gold Standard GAF to the format ADS requires
  file "analyses/quality/#{genome}/GoldStandard.tsv" => f do
    sh "mkdir -p analyses/quality/#{genome}"
    sh "gunzip -k analyses/cleanup/results/#{genome}/GoldStandard.gaf.gz"
    sh "tail -n+3 analyses/cleanup/results/#{genome}/GoldStandard.gaf | cut -f2,5 > analyses/quality/#{genome}/GoldStandard.tsv"
    rm "analyses/cleanup/results/#{genome}/GoldStandard.gaf"
  end

  # For each of the genomes where a Gold Standard is present, all other datasets should also be evaluated
  FileList.new("analyses/cleanup/results/#{genome}/*.gaf.gz").to_a.each do |ds|
    dataset = File.basename(ds).split(".").first
    next if dataset == "GoldStandard" # We don't need to evaluate the GoldStandard against itself.
    target = "analyses/quality/#{genome}/#{dataset}.SimGIC2"
    file target => [ds, "analyses/quality/ads_files/ic.tab", "analyses/quality/#{genome}/GoldStandard.tsv"] do
      # Reformat GAF to required format
      sh "gunzip -k analyses/cleanup/results/#{genome}/#{dataset}.gaf.gz"
      # @TODO ADS requires a score for each prediction and they can't all be 1, so I'm adding a dummy entry
      IO.write("analyses/quality/#{genome}/#{dataset}.predictions", "foobar\tGO:00000331\t0")
      sh "tail -n+3 analyses/cleanup/results/#{genome}/#{dataset}.gaf | cut -f2,5 | awk '{print $0\"\\t1\"}' >> analyses/quality/#{genome}/#{dataset}.predictions"
      rm "analyses/cleanup/results/#{genome}/#{dataset}.gaf"

      sh "gunzip -k data/go.obo.gz"
      Dir.chdir("analyses/shared/ads/") do # ADS requires to be run from the ads directory
        sh "bin/goscores -p ../../quality/#{genome}/#{dataset}.predictions -t ../../quality/#{genome}/GoldStandard.tsv -g -b ../../../data/go.obo -i ../../quality/ads_files/ic.tab ../../quality/ads_files/goparents.tab -m 'SF=SimGIC2' > ../../quality/#{genome}/#{dataset}.SimGIC2"
      end
      rm "data/go.obo"
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

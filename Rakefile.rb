require "csv"

task :default => ['analyses/cleanup/results/cleanup_table.csv', 'analyses/quantity/results/quantity_table.csv', 'analyses/quality/results/quality_table.csv']

# Cleanup
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
  # @TODO for some reason this causes all datasets to be cleaned up again when just one changes
  # file 'analyses/cleanup/results/cleanup_table.csv' => [f, 'analyses/cleanup/cleanup'] + go_files do
  #   sh "analyses/cleanup/cleanup #{f}"
  # end
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
file "analyses/quality/results/ads_files/ic.tab" => ["data/go.obo.gz", "data/goa_arabidopsis.gaf.gz"] do
  sh "gunzip -k data/go.obo.gz"
  sh "gunzip -k data/goa_arabidopsis.gaf.gz"
  rm_rf "analyses/quality/results/ads_files/*" # make a clean slate
  Dir.chdir("analyses/shared/ads/") do # ADS requires to be run from the ads directory
    sh "perl pipeline.pl --datadir ../../quality/results/ads_files --obo ../../../data/go.obo --goa ../../../data/goa_arabidopsis.gaf --pipev 1,2"
  end
  rm "data/go.obo"
  rm "data/goa_arabidopsis.gaf"
end

quality_targets = []
## For each Gold Standard there should be an ADS equivalent
FileList.new("analyses/cleanup/results/*/GoldStandard.gaf.gz").to_a.each do |f|
  genome = File.basename(File.dirname(f))
  # Reformat the Gold Standard GAF to the format ADS requires
  file "analyses/quality/results/#{genome}/GoldStandard.C.tsv" => f do # the C aspect will be used representatively for all aspects
    sh "mkdir -p analyses/quality/results/#{genome}"
    sh "gunzip -k analyses/cleanup/results/#{genome}/GoldStandard.gaf.gz"
    # All aspects of the GO are going to be evaluated individually
    ["C","F","P"].each do |aspect|
      sh "awk -F '\\t' 'BEGIN {OFS = FS}($9 == \"#{aspect}\")' analyses/cleanup/results/#{genome}/GoldStandard.gaf | cut -f 2,5 > analyses/quality/results/#{genome}/GoldStandard.#{aspect}.tsv"
    end
    rm "analyses/cleanup/results/#{genome}/GoldStandard.gaf"
  end

  # For each of the genomes where a Gold Standard is present, all other datasets should also be evaluated
  FileList.new("analyses/cleanup/results/#{genome}/*.gaf.gz").to_a.each do |ds|
    dataset = File.basename(ds).split(".").first
    next if dataset == "GoldStandard" # We don't need to evaluate the GoldStandard against itself.
    # Datasets
    target = "analyses/quality/results/#{genome}/#{dataset}.C.SimGIC2"
    file target => [ds, "analyses/quality/results/ads_files/ic.tab", "analyses/quality/results/#{genome}/GoldStandard.C.tsv"] do
      # Reformat GAF to required format
      sh "gunzip -k analyses/cleanup/results/#{genome}/#{dataset}.gaf.gz"
      # Again, all aspects of the GO are going to be evaluated individually
      ["C","F","P"].each do |aspect|
        # @TODO ADS requires a score for each prediction and they can't all be 1, so I'm adding a dummy entry
        IO.write("analyses/quality/results/#{genome}/#{dataset}.#{aspect}.tsv", "foobar\tGO:00000331\t0\n")
        sh "awk -F '\\t' 'BEGIN {OFS = FS}($9 == \"#{aspect}\")' analyses/cleanup/results/#{genome}/#{dataset}.gaf | cut -f 2,5 | awk '{print $0\"\\t1\"}' >> analyses/quality/results/#{genome}/#{dataset}.#{aspect}.tsv"
      end
      rm "analyses/cleanup/results/#{genome}/#{dataset}.gaf"

      sh "gunzip -k data/go.obo.gz"
      Dir.chdir("analyses/shared/ads/") do # ADS requires to be run from the ads directory
        ["C","F","P"].each do |aspect|
          sh "bin/goscores -p ../../quality/results/#{genome}/#{dataset}.#{aspect}.tsv -t ../../quality/results/#{genome}/GoldStandard.#{aspect}.tsv -g -b ../../../data/go.obo -i ../../quality/results/ads_files/ic.tab ../../quality/results/ads_files/goparents.tab -m 'SF=SimGIC2' > ../../quality/results/#{genome}/#{dataset}.#{aspect}.SimGIC2"
          sh "bin/goscores -p ../../quality/results/#{genome}/#{dataset}.#{aspect}.tsv -t ../../quality/results/#{genome}/GoldStandard.#{aspect}.tsv -g -b ../../../data/go.obo -m 'LIST=gene,TH=all,SUMF1=mean,SF=AUCPR' > ../../quality/results/#{genome}/#{dataset}.#{aspect}.TC_AUCPCR"
          sh "bin/goscores -p ../../quality/results/#{genome}/#{dataset}.#{aspect}.tsv -t ../../quality/results/#{genome}/GoldStandard.#{aspect}.tsv -g -b ../../../data/go.obo -m 'LIST=go,SF=Fmax' > ../../quality/results/#{genome}/#{dataset}.#{aspect}.Fmax"
        end
      end
      rm "data/go.obo"
    end
    quality_targets << target
  end
end

# Collect all scores in a table
file 'analyses/quality/results/quality_table.csv' => quality_targets do
  CSV.open("analyses/quality/results/quality_table.csv", "wb+") do |csv|
    metrics = ["SimGIC2", "TC_AUCPCR", "Fmax"]
    headers = ["genome", "dataset"]
    metrics.each do |metric|
      ["C", "F", "P"].each do |aspect|
        headers << "#{metric}.#{aspect}"
      end
    end
    csv << headers
    quality_targets.each do |t|
      dataset = File.basename(t).split(".").first
      genome = File.basename(File.dirname(t))
      row = [genome, dataset]
      metrics.each do |metric|
        ["C", "F", "P"].each do |aspect|
          row << IO.read("analyses/quality/results/#{genome}/#{dataset}.#{aspect}.#{metric}").chomp
        end
      end
      csv << row
    end
  end
end

desc 'Perform Quality evaluation'
task :quality => 'analyses/quality/results/quality_table.csv'

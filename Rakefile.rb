task :default => 'Paper.pdf'

desc 'Typeset the Paper'
file 'Paper.pdf' => ['analyses/quantity/results/quantity_table.csv', 'text/Paper.Rmd'] do
  sh %q(R -e 'library("rmarkdown"); render("text/Paper.Rmd", output_file="../Paper.pdf", knit_root_dir="../", clean=T)')
end


# Cleanup
def cleanup
  rm_rf 'analyses/cleanup/results/*'
  sh 'python analyses/cleanup/cleanup.py'
end

# converted GO files
['analyses/cleanup/results/GO.json', 'analyses/cleanup/results/GO_names.json'].each do |f|
  file f => ['analyses/cleanup/convert_obo.py', 'analyses/cleanup/go.obo.gz', 'analyses/cleanup/obo_parser.py'] do
    sh 'python analyses/cleanup/convert_obo.py'
  end
end

# Each individual cleaned up file depends on its non-cleaned source
cleanup_targets = ['analyses/cleanup/results/cleanup_table.csv']
file cleanup_targets.first do
  cleanup
end
FileList.new("data/go_annotation_sets/*/*.gaf.gz").to_a.each do |f|
  target = "analyses/cleanup/results/" + ((f.split(".")[0..-3] + ["mgaf.gz"]).join(".").split("/")[2..-1]).join("/")
  file target => [f, 'analyses/cleanup/cleanup.py', 'analyses/cleanup/go.obo.gz'] do
    cleanup
  end
  cleanup_targets << target
end

desc 'Clean up datasets'
# Cleanup depends on all cleanup target files
task :cleanup => cleanup_targets

desc 'Quantity analysis'
file 'analyses/quantity/results/quantity_table.csv' => cleanup_targets + ['data/n_genes_per_genome.csv', 'analyses/quantity/quantity.R'] do
  sh "Rscript analyses/quantity/quantity.R"
end

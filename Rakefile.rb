task :default => 'Paper.pdf'

desc 'Typeset the Paper'
file 'Paper.pdf' => ['analyses/quantity/results/quantity_table.csv', 'text/Paper.Rmd'] do
  sh %q(R -e 'library("rmarkdown"); render("text/Paper.Rmd", output_file="../Paper.pdf", knit_root_dir="../", clean=T)')
end

desc 'Quantity analysis'
file 'analyses/quantity/results/quantity_table.csv' => FileList['data/go_annotation_sets/*/*.gaf.gz'] + ['data/n_genes_per_genome.csv', 'analyses/quantity/quantity.R'] do
  sh "Rscript analyses/quantity/quantity.R"
end

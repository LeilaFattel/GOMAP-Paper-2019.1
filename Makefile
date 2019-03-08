manuscript/Manuscript.pdf: manuscript/Manuscript.Rmd $(wildcard data/results/*) $(wildcard figures/*)
	cd manuscript && R -e 'library(rmarkdown); render("Manuscript.Rmd")'

# @TODO the middle one is not working
data/results/quantity_table.csv: $(wildcard data/raw/go_annotation_sets/*.gaf) data/raw/n_genes_per_genome.csv
	Rscript src/data/create_quantity_table.R

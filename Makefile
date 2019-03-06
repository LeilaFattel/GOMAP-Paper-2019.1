src/manuscript/pandoc-frontiers-template/demo-manuscript.pdf: src/manuscript/pandoc-frontiers-template/demo-manuscript.Rmd reports/figures/annotation_quantities.pdf
	cd src/manuscript/pandoc-frontiers-template && R -e 'library(rmarkdown); render("demo-manuscript.Rmd")'

reports/figures/annotation_quantities.pdf: data/mocks/processed/annotation_quantities.csv src/data/count_annotations.R
	Rscript src/figures/quantity_barcharts.R

# @TODO the middle one is not working
data/mocks/processed/annotation_quantities.csv: $(wildcard data/mocks/raw/annotation_sets/*.gaf) $(wildcard data/mocks/external/annotation_sets/*/*.gaf) $(wildcard data/mocks/external/peptide_sequences/*.fa)
	Rscript src/data/count_annotations.R

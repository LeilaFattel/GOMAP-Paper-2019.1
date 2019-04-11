# This script takes each GOMAP annotation GAF file and creates a new one where all GO terms for all genes are merged onto
# a single made-up gene and duplicates removed. So it is a GAF file that describes what GO terms are assigned to the genome
# in general, irrespectively of what gene they are annotated to.
# This is needed to compare the GO terms genome-wide to build the phylogenetic tree.

# Helper function for the functions below: Checks if the argument passed is a data frame (which would indicate
# that the GAF file has already been read and the function was passed the GAF data) or a string (which would
# indicate that it's the path to the file to be opened) and does the appropriate thing, returns the GAF data frame.
possibly_read_gaf <- function(gaf_file) {
  if(is.data.frame(gaf_file))
    return(gaf_file)
  if(is.character(gaf_file))
    return(read.csv(gaf_file, skip=1, header=T, sep="\t"))
  # If neither dataframe nor string: something is wrong:
  stop("Passed argument is neither data frame nor path to GAF file!")
}

# Create directory for output GAF files if it doesn't exist yet:
dir.create("data/interim/phylogenetics/merged_go_annotations", recursive=T, showWarnings=F)

# Loop through all genomes and see if there's a GOMAP file.
genomes = list.dirs("data/raw/go_annotation_sets", recursive = F)
for(genome_path in genomes) {
  genome_name = basename(genome_path)
  print(genome_name)
  if(file.exists(paste(genome_path,"/GOMAP.gaf.gz", sep=""))) {
    gaf = possibly_read_gaf(paste(genome_path,"/GOMAP.gaf.gz", sep=""))
    merged_gaf = gaf[!duplicated(gaf[,c('qualifier','term_accession')]),] # Choose first row of each duplicate with same qualifier and GO term
    merged_gaf$db_object_id = "organism"
    merged_gaf$db_object_symbol = "organism"
    merged_gaf$taxon = "taxon:0000"
    merged_gaf$gene_product_form_id = "organism"
    
    outfile = paste("data/interim/phylogenetics/merged_go_annotations/", genome_name, ".gaf", sep="")
    writeLines("!gaf-version: 2.0\n!db\tdb_object_id\tdb_object_symbol\tqualifier\tterm_accession\tdb_reference\tevidence_code\twith\taspect\tdb_object_name\tdb_object_synonym\tdb_object_type\ttaxon\tdate\tassigned_by\tannotation_extension\tgene_product_form_id", 
               outfile)
    write.table(merged_gaf, outfile, sep="\t", row.names=F, col.names=F, quote=F, append=T)
  }
}

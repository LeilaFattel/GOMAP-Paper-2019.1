# Creates the file `data/results/quantity_table.csv` by evaluating GAF file quantities and information from `data/raw/n_genes_per_genome.csv`
library(tools)

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

# Pass the path/df of a GAF file and it will return a table of the aspect occurences
count_aspects <- function(gaf_file) {
  gaf_file = possibly_read_gaf(gaf_file)
  return(table(gaf_file$aspect))
}

# Pass the path/df of a GAF file and it will return how many genes have at least one annotation in each aspect (C,F,P) or any (A)
count_genes_annotated <- function(gaf_file) {
  gaf_file = possibly_read_gaf(gaf_file)
  return(c(
    "C" = length(unique(subset(gaf_file, aspect == "C")$db_object_id)),
    "F" = length(unique(subset(gaf_file, aspect == "F")$db_object_id)),
    "P" = length(unique(subset(gaf_file, aspect == "P")$db_object_id)),
    "A" = length(unique(gaf_file$db_object_id))
    ))
}

# Pass the path/df of a GAF file and get back the median number of annotations for each gene in the GAF
# in the C,F,P aspect and total median across all aspects (A)
count_median_annotations <- function(gaf_file) {
  gaf_file = possibly_read_gaf(gaf_file)
  t = table(gaf_file$db_object_id, gaf_file$aspect)
  return(c(
    "C" = median(t[,"C"]),
    "F" = median(t[,"F"]),
    "P" = median(t[,"P"]),
    "A" = median(t[,"C"]+t[,"F"]+t[,"P"])
  ))
}


# @TODO This way of creating the dataframe and building it row by row is supposed to be very inefficient -- make it more efficient?
csv = data.frame(
  genome = "",
  n_genes = 0,
  dataset = "",
  annotations_c = 0,
  annotations_f = 0,
  annotations_p = 0,
  annotations_a = 0,
  genes_annotated_c = 0,
  genes_annotated_f = 0,
  genes_annotated_p = 0,
  genes_annotated_a = 0,
  median_annotations_per_gene_c = 0,
  median_annotations_per_gene_f = 0,
  median_annotations_per_gene_p = 0,
  median_annotations_per_gene_a = 0
)

n_genes_per_genome = read.csv("data/raw/n_genes_per_genome.csv", header = T)
genomes = list.dirs("data/raw/go_annotation_sets", recursive = F)
for(genome_path in genomes) {
  genome_name = basename(genome_path)
  print(genome_name)
  for(gaf_file in list.files(genome_path, pattern = ".gaf", full.names = T)) {
    print(gaf_file)
    gaf_df = possibly_read_gaf(gaf_file)
    aspect_counts = count_aspects(gaf_df)
    genes_annotated = count_genes_annotated(gaf_df)
    medians = count_median_annotations(gaf_df)
    # Add row to csv object:
    csv <- rbind(csv, data.frame(
      genome = genome_name,
      n_genes = n_genes_per_genome[n_genes_per_genome$genome == genome_name,"n_genes"],
      dataset = strsplit(basename(gaf_file), "\\.")[[1]][1], # filename without extension
      annotations_c = aspect_counts[["C"]],
      annotations_f = aspect_counts[["F"]],
      annotations_p = aspect_counts[["P"]],
      annotations_a = sum(aspect_counts),
      genes_annotated_c = genes_annotated[["C"]],
      genes_annotated_f = genes_annotated[["F"]],
      genes_annotated_p = genes_annotated[["P"]],
      genes_annotated_a = genes_annotated[["A"]],
      median_annotations_per_gene_c = medians[["C"]],
      median_annotations_per_gene_f = medians[["F"]],
      median_annotations_per_gene_p = medians[["P"]],
      median_annotations_per_gene_a = medians[["A"]]
    ))
  }
}
csv <- csv[2:nrow(csv),] # Drop empty dummy row

write.csv(csv, 'data/results/quantity_table.csv', row.names = F)
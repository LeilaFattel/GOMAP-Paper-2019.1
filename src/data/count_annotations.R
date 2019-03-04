# Creates the file `annotation_quantities.csv` by evaluating GAF file quantities and corresponding fasta inputs
library(tools)

# Pass the path to a GAF file and it will return a table of the aspect occurences
count_aspects <- function(filepath) {
  gaf_file = read.csv(filepath, skip=1, header=T, sep="\t")
  return(table(gaf_file$aspect))
}

# Pass the path to a fasta file and it will return the number of sequences in there.
count_sequences <- function(fasta_filepath) {
  return(as.numeric(system(paste('grep -c ">"', fasta_filepath), intern=T)))
}

genome = list()
source = list()
n_c    = list()
n_f    = list()
n_p    = list()
n_genes= list()
list_index = 1

genomes = list.files("data/mocks/raw/annotation_sets", pattern=".gaf")
for(gomap_gaf in genomes) {
  genome_name = strsplit(gomap_gaf, "\\.")[[1]][1] # filename without extension
  print(genome_name)
  aspect_counts = count_aspects(paste("data/mocks/raw/annotation_sets/", gomap_gaf, sep=''))
  
  genome[[list_index]] = genome_name
  source[[list_index]] = "GOMAP"
  n_c[[list_index]]    = aspect_counts[["C"]]
  n_f[[list_index]]    = aspect_counts[["F"]]
  n_p[[list_index]]    = aspect_counts[["P"]]
  n_genes[[list_index]]= count_sequences(paste("data/mocks/external/peptide_sequences/", genome_name, ".fa", sep=''))
  list_index = list_index + 1
  
  if(dir.exists(paste('data/mocks/external/annotation_sets/', genome_name, sep=''))) {
    for(gaf_file in list.files(paste('data/mocks/external/annotation_sets/', genome_name, sep=''), pattern=".gaf", full.names = T)) {
      aspect_counts = count_aspects(gaf_file)
      genome[[list_index]] = genome_name
      source[[list_index]] = file_path_sans_ext(basename(gaf_file))
      n_c[[list_index]]    = aspect_counts[["C"]]
      n_f[[list_index]]    = aspect_counts[["F"]]
      n_p[[list_index]]    = aspect_counts[["P"]]
      n_genes[[list_index]]= count_sequences(paste("data/mocks/external/peptide_sequences/", genome_name, ".fa", sep=''))
      list_index = list_index + 1
    }
  }
}

write.csv(cbind(genome, source, n_c, n_f, n_p, n_genes), 'data/mocks/processed/annotation_quantities.csv', row.names = F)


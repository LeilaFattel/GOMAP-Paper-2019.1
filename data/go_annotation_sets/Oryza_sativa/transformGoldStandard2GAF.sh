# This file converts the GoldStandard TSV file downloaded from Gramene to the GAF 2 format
# so that we don't need to deal with different file formats in the following analyses.

# Print GAF headers
echo "!gaf-version:2.0" > GoldStandard.gaf
echo "!db	db_object_id	db_object_symbol	qualifier	term_accession	db_reference	evidence_code	with	aspect	db_object_name	db_object_synonym	db_object_type	taxon	date	assigned_by	annotation_extension	gene_product_form_id" >> GoldStandard.gaf

# Skip TSV header and rearrange/expand columns
tail -n +2 GoldStandard.tsv | awk -F $'\t' 'BEGIN {OFS = FS} 
 { print "Gramene/Plant_Genes_61/IRGSP-1.0", 
   $1, 
   $1,
   "",
   $2, 
   "", 
   $4,
   "",
   $3,
   "",
   "",
   "protein",
   "taxon:4530",
   "",
   "",
   "",
   ""
 }' >> GoldStandard.gaf

# Rename aspect names of the TSV to GAF codes
sed -i 's/cellular_component/C/' GoldStandard.gaf
sed -i 's/biological_process/P/' GoldStandard.gaf
sed -i 's/molecular_function/F/' GoldStandard.gaf

#!/bin/bash

# This file converts the TSV files downloaded from Gramene to the GAF 2 format
# Usage:
# gramene2gaf.sh <TSV file> <db column string> <taxon id>
# Example:
#  gramene2gaf.sh Oryza_sativa/Gramene61_IEA.tsv "Gramene/Plant_Genes_61/IRGSP-1.0" 4530 > Oryza_sativa/Gramene61_IEA.gaf

# Print GAF headers
echo "!gaf-version:2.0"
echo "!db	db_object_id	db_object_symbol	qualifier	term_accession	db_reference	evidence_code	with	aspect	db_object_name	db_object_synonym	db_object_type	taxon	date	assigned_by	annotation_extension	gene_product_form_id"

# Skip TSV header and rearrange/expand columns
tail -n +2 $1 | awk -F $'\t' 'BEGIN {OFS = FS} 
 { gsub("cellular_component","C",$4)
   gsub("biological_process","P",$4)
   gsub("molecular_function","F",$4)
   print "'"${2}"'", 
   $1, 
   $1,
   "",
   $2, 
   "", 
   $3,
   "",
   $4,
   "",
   "",
   "protein",
   "taxon:'"${3}"'",
   "",
   "",
   "",
   ""
 }'

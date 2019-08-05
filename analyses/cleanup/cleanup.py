# Cleans aggregated GAF file:
# 1. Removes obsolete Annotations
# 2. Merges GO terms to main term (alt_id->id)
# 3. (optional) Adds transcript variant to column 17
# 4. Changes assigned by and db columns to the following values:
keep_columns = [1,3,4,8]
# 5. Removes duplicates
# 
# Usage:
#   python 2_cleanup.py [input-gaf-file] [OBO-file] [gene-to-transcript-map (optional)]
#    - OBO-file: Gene ontology in obo format. Most recent version can be obtained from http://www.geneontology.org/page/download-ontology which might be good when using this script on your own results.
#    - gene-to-transcript-map: headerless space separated file of gene_name transcript_name , used to add correct transcript_name to column 17. See 2_cleanup_resources/gene_to_used_transcript_map.csv for an example
#  GAF output will be sent to STDOUT, status messages to STDERR. So if you want to save the cleaned up GAF you can redirect STDOUT
#   python 2_cleanup.py [input-gaf-file] [OBO-file] [gene-to-transcript-map (optional)] > [output-gaf-file]
# See README.md in this directory to see how to reproduce our results

# This script uses the obo_parser.py taken from https://github.com/mschubert/python-obo/blob/master/obo/parser.py

import obo_parser
import sys
import csv
import gzip
import os
import glob
from sets import Set

### Preparation ###
## Build list of obsolete ids and alt_ids

merge_to = {} # merge_to[goterm] == id to be merged to.
obsolete_ids = []

print >> sys.stderr, 'Parsing go.obo...'
with gzip.open('analyses/cleanup/go.obo.gz') as obofile:
  parser = obo_parser.Parser(obofile)
  for stanza in parser:
    if not stanza.name == "Term":
      continue

    go_id = stanza.tags["id"][0]

    if 'alt_id' in stanza.tags:
      for alt_id in stanza.tags['alt_id']:
        merge_to[alt_id] = go_id

    if 'is_obsolete' in stanza.tags and stanza.tags['is_obsolete'][0] == "true":
      obsolete_ids.append(go_id)


def process_gaf(genome, dataset):
  print("Processing " + genome + "/" + dataset)
  printed_tuples = Set()
  n_obsolete = 0
  n_duplicate = 0

  if not os.path.exists("analyses/cleanup/results/" + genome):
      os.makedirs("analyses/cleanup/results/" + genome)

  with gzip.open("data/go_annotation_sets/" + genome + "/" + dataset + ".gaf.gz") as infile, gzip.open("analyses/cleanup/results/" + genome + "/" + dataset + ".mgaf.gz", "wb") as outfile:
    reader = csv.reader(infile, delimiter="\t")
    writer = csv.writer(outfile, delimiter="\t")

    # Skip the first header
    reader.next()
    # Only keep columns that were defined above
    header = reader.next()
    writer.writerow([header[x] for x in keep_columns])

    for row in reader:
      if row[4] in merge_to:
        row[4] = merge_to[row[4]]
      if row[4] in obsolete_ids:
        n_obsolete += 1
        continue
      # Through merging with alt_ids some duplicates may have been created. Skip them!
      if (row[1], row[4]) in printed_tuples:
        n_duplicate += 1
        continue
      printed_tuples.add( (row[1], row[4]) )
      writer.writerow([row[x] for x in keep_columns])

  return [n_obsolete, n_duplicate]


stats_table = [ ["genome", "dataset", "obsolete", "duplicates"] ]
for genome in [x for x in os.listdir("data/go_annotation_sets") if os.path.isdir("data/go_annotation_sets/"+x)]:
  for dataset in glob.glob("data/go_annotation_sets/" + genome + "/*.gaf.gz"):
    dataset = ".".join(os.path.basename(dataset).split(".")[:-2])
    stats_table.append([genome, dataset] + process_gaf(genome, dataset))

# @TODO this doesn't work yet
puts stats_table
with open("analyses/cleanup/results/cleanup_table.csv", "w") as f:
  writer = csv.writer(f, delimiter=",")
  for r in stats_table:
    writer.writerow[r]

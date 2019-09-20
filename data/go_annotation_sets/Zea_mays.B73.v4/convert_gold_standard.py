# This is used to convert the B73.v3 gold standard to B73.v4
#  1. The gene name mapping from v3 to v4 is read
#  2. Columns 2 and 3 are populated with the new id if it exists
 
import sys
import csv

v3_to_v4 = {}
with open("maize.v3TOv4.geneIDhistory.txt") as mapfile:
  reader = csv.reader(mapfile, delimiter="\t")
  for row in reader:
    if row[1].startswith("Zm"):
      v3_to_v4[row[0]] = row[1]
  
with open(sys.argv[1]) as infile:
  reader = csv.reader(infile, delimiter="\t")
  writer = csv.writer(sys.stdout, delimiter="\t")
 
  # Write back two header lines unchanged
  writer.writerow(reader.next())
  writer.writerow(reader.next())
 
  for row in reader:
    if row[2] in v3_to_v4:
      row[2] = v3_to_v4[row[2]]
      row[1] = row[2]
      writer.writerow(row)

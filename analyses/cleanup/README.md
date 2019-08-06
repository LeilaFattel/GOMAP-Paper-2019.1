This step cleans up the GO annotation sets at `data/go_annotation_sets` by 

1. Removing obsolete annotations, and 
2. Merging all 'alternative ids' to the main id and removing duplicates discovered this way

Statistics about how many annotations were removed this way are saved to `./results/cleanup_table.csv`.

It also drops columns that are not needed for any further analyses to reduce file size and speed up analysis.

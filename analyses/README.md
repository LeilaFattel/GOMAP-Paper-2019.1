These are the analyses that were done for the paper.
If you want to re-run one of them or use them on your own data, access the singularity container as described in the main README and run the scripts by hand or use rake to resolve dependencies for you. All paths are relative to the root folder (`../` from here).
So, for example, to re-run the quantity analysis:
```bash
# Enter the container as described in ../README.md
Rscript analyses/quantity/quantity.R # OR
rake analyses/quantity/results/quantity_table.csv
```

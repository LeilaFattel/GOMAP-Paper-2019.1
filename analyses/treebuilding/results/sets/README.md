# GO Term Annotation Sets Used For Treebuilding
These JSON files are generated from the cleaned up GOMAP GAF files using the `gafs_to_sets.rb` Ruby script.
The `original` JSON files contain only the terms directly annotated by GOMAP pooled together across genes and with duplicates removed (set _T_ in the manuscript), the `with_ancestors` JSON files also contain the recursive parental terms for all of the terms in set _T_ (set _S_ in the manuscript).
These terms with added ancestors are used for cladogram construction in the `treebuilding.rb` script.
Each JSON file contains terms split up by aspect (Biological *P*rocess, Molecular *F*unction, Cellular *C*omponent) in order to make it easy to build trees for each aspect separately as well as all terms pooled together across aspects in an *A* list:

```
{
  "F": ["GO:0016835", "GO:0030976", ...],
  "P": ["GO:0006412", "GO:0009063", ...],
  "C": ["GO:0016021", "GO:0031969", ...],
  "A": ["GO:0016835", "GO:0006412", ...]
}
```

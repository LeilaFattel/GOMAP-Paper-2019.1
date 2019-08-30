---
title: "Article Title"
runtitle: "Short Title"
documentclass: frontiersSCNS  # or frontiersHLTH, or frontiersFPHY
author:
  - name: Dennis Psaroudakis
    affiliation: '1'
    etal: Psaroudakis # First author's last name. 
  - name: Ha Vu
    affiliation: '1'
  - name: Colleen Yanarella
    affiliation: '1'
  - name: Steven Cannon
    affiliation: '1'
  - name: Darwin Campbell
    affiliation: '1'
  - name: Parnal Joshi
    affiliation: '1'
  - name: Iddo Friedberg
    affiliation: '1,4'
  - name: Kokulapalan Wimalanathan
    affiliation: '1,2'
  - name: Carolyn J. Lawrence-Dill
    affiliation: '1,2,3'
    email: triffid@iastate.edu
    institution: Roy J. Carver Co-Lab, Iowa State University
    street: 1111 WOI Rd
    city: Ames
    state: State IA # only USA, Australia, Canada
    zip: 50011
    country: USA
affiliation:
  - id: '1'
    department: Bioinformatics and Computational Biology
    institution: Iowa State University
    city: Ames
    state: IA # only USA, Australia, Canada
    country: USA
  - id: '2'
    department: Department of Genetics, Development, and Cell Biology
    institution: Iowa State University
    city: Ames
    state: IA # only USA, Australia, Canada
    country: USA
  - id: '3'
    department: Department of Agronomy
    institution: Iowa State University
    city: Ames
    state: IA # only USA, Australia, Canada
    country: USA
  - id: '4'
    department: Department of Veterinary Microbiology
    institution: Iowa State University
    city: Ames
    state: IA # only USA, Australia, Canada
    country: USA
date: "Febcember 32nd 3023"
language: en-US
site: "bookdown::bookdown_site"
csl: frontiers.csl
link-citations: true
output:
  bookdown::pdf_book:
    keep_tex: true
    keep_md: true
    base_format: rticles::frontiers_article
    citation_package: natbib
    includes:
      in_header:
        preamble.tex
---





\begin{abstract}

Abstract length and content varies depending on article type. Refer to 
\url{http://www.frontiersin.org/about/AuthorGuidelines} for abstract requirement
and length according to article type.

%All article types: you may provide up to 8 keywords; at least 5 are mandatory.
\tiny
 \keyFont{ \section{Keywords:} Text Text Text Text Text Text Text Text } 

\end{abstract}

# Introduction
Hello, how are we doing?


<!--chapter:end:index.Rmd-->

# Methods

## Clean up
All functional annotation sets were cleaned up the following way (using definitions from the Gene Ontology version 2019-07-01):

1. Any annotations where the GO accession was marked as obsolete were removed.
2. Some terms in the GO have 'alternative ids'. When naively removing duplicates, two entries will not be recognized as duplicates if they have different accessions pointing to the same GO term. Therefore, all GO accessions were changed to their respecitve 'main id' and the dataset was again scanned for duplicates.

Table 1 provides information on the number of annotations that were removed this way from each dataset.
All further analyses were performed on the cleaned datasets since we assume the user will only be interested in still valid and non-redundant functional annotations.

## Choosing the right evaluation metric
A plethora of different metric to evaluate the quality of functional annotation predictions is available using different approaches and there seems to be no clear standard yet. `TODO: THIS IS WEAK`
Additionally, each of the metrics has a different focus and lalala so choosing a metric for quality evaluation is not trivial.
When we first published GOMAP [@Wimalanathan2018], we used a modified version of the hierarchical evaluation metrics originally introduced in [@Verspoor2006] because they were simple, clear, and part of an earlier attempt at unifying and standardizing GO annotation comparisons [@Defoin-Platel2011].
In the meantime, @Plyusnin2018 have published an approach for evaluating different metrics showing substantial differences within the robustness of different approaches.
`TODO DESCRIBE THEIR APPROACH`
We have applied their method on the Gold Standards available to us to determine which evaluation metric is the most appropriate in our case.
The results of this analysis can be seen in `TODO`.

We then evaluated our predictions and the other annotation sets using the best performing metrics as well as the one we previously used.
`TODO`

<!--chapter:end:02-methods.Rmd-->

# Results
... a quantitative comparison of the datasets in Table.

\begin{table}[t]

\caption{(\#tab:cleanup-table)Number of removed annotations during cleanup.}
\centering
\begin{tabular}{llrr}
\toprule
Genome & Dataset & Obsolete Annotations & Duplicates\\
\midrule
\rowcolor{gray!6}  \textit{Glycine max} & GOMAP & 203 & 0\\
\cmidrule{1-4}
\textit{Hordeum vulgarum} & GOMAP & 101 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Medicago truncatula} A17 & GOMAP & 0 & 0\\
\cmidrule{1-4}
\textit{Medicago truncatula} R108 & GOMAP & 0 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}   & GOMAP & 111 & 2\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & GoldStandard & 38 & 556\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Phaseolus vulgaris} & GOMAP & 0 & 0\\
\cmidrule{1-4}
\textit{Triticum aestivum} & GOMAP & 285 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Vigna unguiculata} & GOMAP & 0 & 0\\
\cmidrule{1-4}
\textit{Zea mays} B73.v4 & GOMAP & 752 & 83\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Zea mays} Mo17 & GOMAP & 726 & 77\\
\cmidrule{1-4}
\textit{Zea mays} PH207 & GOMAP & 798 & 76\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Zea mays} W22 & GOMAP & 754 & 82\\
\cmidrule{1-4}
\textit{Arachis hypogaea} & GOMAP & 0 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}   & GOMAP & 1107 & 70\\

 & GoldStandard & 1 & 0\\

\rowcolor{gray!6}   & Gramene49 & 94 & 2\\

\multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & Phytozome & 54 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}   & Gramene61-IEA & 10 & 14\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-all & 48 & 9565\\
\bottomrule
\end{tabular}
\end{table}

\begin{table}[t]

\caption{(\#tab:annotation-quantities)Quantitative metrics of the cleaned functional annotation sets. CC, BF, MP, and A refer to the aspects of the GO: Cellular Component, Biological Function, Molecular Process, and Any/All.}
\centering
\resizebox{\linewidth}{!}{
\begin{threeparttable}
\begin{tabular}{lrlrrr>{\bfseries}r|rrr>{\bfseries}r|rrr>{\bfseries}r}
\toprule
\multicolumn{3}{c}{ } & \multicolumn{4}{c}{Annotations\textsuperscript{a}} & \multicolumn{4}{c}{Annotated Genes [\%]\textsuperscript{b}} & \multicolumn{4}{c}{Median Ann. per G.\textsuperscript{c}} \\
\cmidrule(l{3pt}r{3pt}){4-7} \cmidrule(l{3pt}r{3pt}){8-11} \cmidrule(l{3pt}r{3pt}){12-15}
Genome & Genes & Dataset & CC & BF & MP & A & CC & BF & MP & A & CC & BF & MP & A\\
\midrule
\rowcolor{gray!6}  \textit{Arachis hypogaea} &  & GOMAP & 153433 & 132944 & 493799 & 780176 & 57667 & 56855 & 67123 & 67124 & 2 & 2 & 6 & 10\\

\textit{Glycine max} &  & GOMAP & 129215 & 113827 & 417555 & 660597 & 46020 & 47034 & 52871 & 52872 & 2 & 2 & 6 & 11\\

\rowcolor{gray!6}  \textit{Hordeum vulgarum} &  & GOMAP & 88130 & 80282 & 272823 & 441235 & 35237 & 36470 & 39733 & 39734 & 2 & 2 & 5 & 10\\

\textit{Medicago truncatula} A17 &  & GOMAP & 107362 & 99719 & 364065 & 571146 & 42325 & 43736 & 50443 & 50444 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}  \textit{Medicago truncatula} R108 &  & GOMAP & 112343 & 108031 & 382322 & 602696 & 40332 & 50220 & 55706 & 55706 & 1 & 2 & 5 & 9\\

 &  & GOMAP & 72780 & 64685 & 248700 & 386165 & 28619 & 29853 & 35824 & 35825 & 2 & 2 & 6 & 9\\

\rowcolor{gray!6}   &  & GoldStandard & 7730 & 11060 & 19378 & 38176 & 5725 & 7383 & 9031 & 11387 & 1 & 1 & 1 & 3\\

 &  & Gramene61-IEA & 14633 & 32787 & 39105 & 86529 & 10771 & 15537 & 16705 & 21446 & 1 & 1 & 1 & 3\\

\rowcolor{gray!6}  \multirow{-4}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} &  & Gramene61-all & 20622 & 40674 & 54402 & 115710 & 13272 & 16962 & 18513 & 22272 & 1 & 1 & 2 & 4\\

\textit{Phaseolus vulgaris} &  & GOMAP & 72005 & 64583 & 229630 & 366218 & 25934 & 25539 & 27432 & 27433 & 2 & 2 & 6 & 11\\

\rowcolor{gray!6}  \textit{Triticum aestivum} &  & GOMAP & 267741 & 218623 & 785960 & 1272324 & 95604 & 98187 & 107890 & 107891 & 2 & 2 & 6 & 10\\

\textit{Vigna unguiculata} &  & GOMAP & 75867 & 68313 & 243278 & 387458 & 27173 & 27124 & 29772 & 29773 & 2 & 2 & 6 & 11\\

\rowcolor{gray!6}   &  & GOMAP & 135211 & 87420 & 291251 & 513882 & 34866 & 38073 & 39468 & 39469 & 3 & 2 & 6 & 11\\

 &  & GoldStandard & 1565 & 65 & 299 & 1929 & 1548 & 60 & 151 & 1634 & 1 & 0 & 0 & 1\\

\rowcolor{gray!6}   &  & Gramene49 & 20072 & 31056 & 30089 & 81217 & 11834 & 17991 & 15800 & 21926 & 1 & 1 & 1 & 3\\

\multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} &  & Phytozome & 4787 & 19044 & 13100 & 36931 & 4524 & 13728 & 11365 & 16132 & 0 & 1 & 1 & 2\\

\rowcolor{gray!6}  \textit{Zea mays} B73.v4 &  & GOMAP & 88827 & 82251 & 278719 & 449797 & 36717 & 37337 & 39323 & 39324 & 2 & 2 & 6 & 10\\

\textit{Zea mays} Mo17 &  & GOMAP & 87567 & 79214 & 277787 & 444568 & 33618 & 35105 & 38619 & 38620 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}  \textit{Zea mays} PH207 &  & GOMAP & 90617 & 85500 & 288677 & 464794 & 35170 & 36762 & 40556 & 40557 & 2 & 2 & 6 & 10\\

\textit{Zea mays} W22 & \multirow{-20}{*}{\raggedleft\arraybackslash 100} & GOMAP & 95390 & 85039 & 289780 & 470209 & 36987 & 37685 & 40689 & 40690 & 2 & 2 & 6 & 10\\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item[a] How many annotations in the CC, BF, and MP aspect does this dataset contain? A = How many in total? $\textrm{A} = \textrm{CC} + \textrm{BF} + \textrm{MP}$
\item[b] How many genes in the genome have at least one GO term from the CC, BF, MP aspect annotated to them? A = How many at least one from any aspect? ($\textrm{A} = \textrm{CC} \cup \textrm{BF} \cup \textrm{MP}$)
\item[c] Take a typical gene that is present in the annotation set. How many annotations does it have in each aspect? A = How many in total? Ask your favorite statistician why $\textrm{A} \neq \textrm{CC} + \textrm{BF} +\textrm{MP}$
\end{tablenotes}
\end{threeparttable}}
\end{table}

## Quality Evaluation

`TODO` If it turns out that our predictions are good with hF but bad with more approriate metrics, explanation would be that score thresholds for the prediction tools used in the GOMAP pipeline have been chosen to maximize this hF value. It now seems reasonable to re-adjust these thresholds to maximize a different metric which will likely result in a drop in hF score but increase in other metrics. Again emphasizes the importance of choosing the right evaluation metric.


\begin{table}[t]

\caption{(\#tab:quality-table)Quality evaluation of the used GO annotation sets.}
\centering
\begin{tabular}{llr}
\toprule
Genome & Dataset & SimGIC2 score\\
\midrule
\rowcolor{gray!6}   & GOMAP & 0.241470\\

 & GoldStandard & 0.999971\\

\rowcolor{gray!6}   & Gramene61-IEA & 0.324831\\

\multirow{-4}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-all & 0.732289\\
\cmidrule{1-3}
\rowcolor{gray!6}   & GOMAP & 0.072971\\

 & GoldStandard & 0.998562\\

\rowcolor{gray!6}   & Gramene49 & 0.126450\\

\multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & Phytozome & 0.032693\\
\bottomrule
\end{tabular}
\end{table}

<!--chapter:end:03-results.Rmd-->

\bibliography{GOMAP-Paper-Used}

<!--chapter:end:06-backmatter.Rmd-->


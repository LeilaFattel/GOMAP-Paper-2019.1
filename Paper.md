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

## Generating Predictions
Used GOMAP on condo lalala. Input files are (usually) published along results.

## Clean up
All functional annotation sets were cleaned up the following way (using definitions from the Gene Ontology version 2019-07-01):

1. Any annotations where the GO accession was marked as obsolete were removed.
2. Some terms in the GO have 'alternative ids'. When naively removing duplicates, two entries will not be recognized as duplicates if they have different accessions pointing to the same GO term. Therefore, all GO accessions were changed to their respecitve 'main id' and the dataset was again scanned for duplicates.
3. Any annotations with modifiers (NOT, contributes_to...) were removed since no tool used in the further analysis can handle them.

Table 1 provides information on the number of annotations that were removed this way from each dataset.
All further analyses were performed on the cleaned datasets since we assume the user will only be interested in still valid and non-redundant functional annotations.

## Quantitative Evaluation
lalala lololo table xyz

## Quality Evaluation
Quality evaluation of gene function predictions is not trivial and usually done by comparing the set of predicted functions of a gene against a *gold standard* consisting of annotations that are assumed to be correct.
We used annotations that were created or in some way curated with human participation for gold standards.
There are a plethora of different metrics to perform the comparison of predictions against this gold standard.
When we first published GOMAP [@Wimalanathan2018], we used a modified version of the hierarchical evaluation metrics originally introduced in [@Verspoor2006] because they were simple, clear, and part of an earlier attempt at unifying and standardizing GO annotation comparisons [@Defoin-Platel2011].
In the meantime, @Plyusnin2019 have published an approach for evaluating different metrics showing substantial differences within the robustness of different approaches.
`TODO DESCRIBE THEIR APPROACH`
We have applied their method on the Gold Standards available to us to determine which evaluation metric is the most appropriate in our case.
The results of this analysis can be seen in `TODO`.

We then evaluated our predictions and the other annotation sets using the best performing metrics as well as the one we previously used (Table `TODO`).

## Phylogenetic Tree Construction
To demonstrate that a more top-level and holistic use of whole-genome functional predictions can still be useful we devised some simple ways of applying phylogenetic methods to our predictions.
### Distance Based
### Character Based

## Ensuring Reproducibility
containerization, github...

<!--chapter:end:02-methods.Rmd-->

# Results
... a quantitative comparison of the datasets in Table.

\begin{table}[t]

\caption{(\#tab:cleanup-table)Number of removed annotations during cleanup.}
\centering
\resizebox{\linewidth}{!}{
\begin{threeparttable}
\begin{tabular}{llrrr}
\toprule
Genome & Dataset & Obsolete Annotations & Duplicates & Annotations with Modifiers\\
\midrule
\rowcolor{gray!6}  \textit{Arachis hypogaea} & GOMAP & 0 & 0 & 912\\
\cmidrule{1-5}
\textit{Brachypodium distachyon} & GOMAP & 696 & 43 & 789\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Glycine max} & GOMAP & 203 & 0 & 930\\
\cmidrule{1-5}
\textit{Gossypium raimondii} & GOMAP & 184 & 0 & 822\\
\cmidrule{1-5}
\rowcolor{gray!6}   & GOMAP & 101 & 0 & 815\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Hordeum vulgarum}} & GoldStandard & 0 & 4 & 0\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Medicago truncatula} A17 & GOMAP & 0 & 0 & 798\\
\cmidrule{1-5}
\textit{Medicago truncatula} R108 & GOMAP & 0 & 0 & 803\\
\cmidrule{1-5}
\rowcolor{gray!6}   & GOMAP & 111 & 2 & 869\\

 & GoldStandard & 38 & 556 & 0\\

\rowcolor{gray!6}  \multirow{-3}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-IEA & 10 & 14 & 0\\
\cmidrule{1-5}
\textit{Phaseolus vulgaris} & GOMAP & 0 & 0 & 783\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Sorghum bicolor} & GOMAP & 690 & 59 & 783\\
\cmidrule{1-5}
 & GOMAP & 285 & 0 & 1132\\

\rowcolor{gray!6}   & GoldStandard & 0 & 10 & 0\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & Gramene61-IEA & 47 & 48 & 0\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Vigna unguiculata} & GOMAP & 0 & 0 & 811\\
\cmidrule{1-5}
 & GOMAP & 1106 & 70 & 709\\

\rowcolor{gray!6}   & GoldStandard & 1 & 11 & NA\\

 & Gramene49 & 94 & 2 & 0\\

\rowcolor{gray!6}  \multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & Phytozome & 54 & 0 & 0\\
\cmidrule{1-5}
 & GOMAP & 752 & 83 & 848\\

\rowcolor{gray!6}   & GoldStandard & 55 & 174 & 0\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & Gramene61-IEA & 99 & 157 & 0\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Zea mays} Mo17 & GOMAP & 726 & 77 & 823\\
\cmidrule{1-5}
\textit{Zea mays} PH207 & GOMAP & 798 & 76 & 830\\
\cmidrule{1-5}
\rowcolor{gray!6}  \textit{Zea mays} W22 & GOMAP & 754 & 82 & 840\\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item \href{https://raw.githubusercontent.com/Dill-PICL/GOMAP-Paper-2019.1/master/analyses/cleanup/results/cleanup_table.csv}{Download this table (CSV)}
\end{tablenotes}
\end{threeparttable}}
\end{table}

\begin{table}[t]

\caption{(\#tab:annotation-quantities)Quantitative metrics of the cleaned functional annotation sets. CC, BF, MP, and A refer to the aspects of the GO: Cellular Component, Biological Function, Molecular Process, and Any/All.}
\centering
\resizebox{\linewidth}{!}{
\begin{threeparttable}
\begin{tabular}{lrlrrr>{\bfseries}r|rrr>{\bfseries}r|rrr>{\bfseries}r}
\toprule
\multicolumn{3}{c}{ } & \multicolumn{4}{c}{Genes Annotated[\%]\textsuperscript{a}} & \multicolumn{4}{c}{Annotations\textsuperscript{b}} & \multicolumn{4}{c}{Median Ann. per G.\textsuperscript{c}} \\
\cmidrule(l{3pt}r{3pt}){4-7} \cmidrule(l{3pt}r{3pt}){8-11} \cmidrule(l{3pt}r{3pt}){12-15}
Genome & Genes & Dataset & CC & BF & MP & A & CC & BF & MP & A & CC & BF & MP & A\\
\midrule
\rowcolor{gray!6}  \textit{Arachis hypogaea} & 67,124 & GOMAP & 85.90 & 84.69 & 100.00 & 100.00 & 153,052 & 132,624 & 493,588 & 779,264 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Brachypodium distachyon} & 34,310 & GOMAP & 81.37 & 85.36 & 100.00 & 100.00 & 75,536 & 69,452 & 255,616 & 400,604 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Glycine max} & 52,872 & GOMAP & 87.02 & 88.93 & 100.00 & 100.00 & 128,836 & 113,491 & 417,340 & 659,667 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\textit{Gossypium raimondii} & 37,505 & GOMAP & 93.06 & 92.37 & 100.00 & 100.00 & 96,442 & 85,234 & 307,727 & 489,403 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\rowcolor{gray!6}   &  & GOMAP & 88.67 & 91.77 & 100.00 & 100.00 & 87,780 & 80,015 & 272,625 & 440,420 & 2 & 2 & 5 & 10\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Hordeum vulgarum}} & \multirow{-2}{*}{\raggedleft\arraybackslash 39,734} & GoldStandard & 0.02 & 0.05 & 0.05 & 0.07 & 7 & 23 & 45 & 75 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Medicago truncatula} A17 & 50,444 & GOMAP & 83.90 & 86.69 & 100.00 & 100.00 & 107,019 & 99,452 & 363,877 & 570,348 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Medicago truncatula} R108 & 55,706 & GOMAP & 72.39 & 90.14 & 100.00 & 100.00 & 111,991 & 107,769 & 382,133 & 601,893 & 1 & 2 & 5 & 9\\
\cmidrule{1-15}
\rowcolor{gray!6}   &  & GOMAP & 79.87 & 83.31 & 100.00 & 100.00 & 72,415 & 64,386 & 248,495 & 385,296 & 2 & 2 & 6 & 9\\

 &  & GoldStandard & 15.98 & 20.61 & 25.21 & 31.79 & 7,730 & 11,060 & 19,378 & 38,176 & 1 & 1 & 1 & 3\\

\rowcolor{gray!6}  \multirow{-3}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & \multirow{-3}{*}{\raggedleft\arraybackslash 35,825} & Gramene61-IEA & 30.07 & 43.37 & 46.63 & 59.86 & 14,633 & 32,787 & 39,105 & 86,529 & 1 & 1 & 1 & 3\\
\cmidrule{1-15}
\textit{Phaseolus vulgaris} & 27,433 & GOMAP & 94.52 & 93.07 & 100.00 & 100.00 & 71,658 & 64,328 & 229,449 & 365,435 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Sorghum bicolor} & 34,129 & GOMAP & 82.48 & 85.98 & 100.00 & 100.00 & 76,343 & 69,937 & 259,229 & 405,509 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
 &  & GOMAP & 88.60 & 90.98 & 100.00 & 100.00 & 267,317 & 218,186 & 785,689 & 1,271,192 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}   &  & GoldStandard & 0.89 & 0.57 & 1.54 & 1.73 & 1,590 & 923 & 4,807 & 7,323 & 1 & 0 & 2 & 3\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & \multirow{-3}{*}{\raggedleft\arraybackslash 107,891} & Gramene61-IEA & 26.74 & 55.24 & 48.72 & 70.24 & 38,975 & 109,319 & 109,518 & 257,832 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Vigna unguiculata} & 29,773 & GOMAP & 91.26 & 91.08 & 100.00 & 100.00 & 75,513 & 68,040 & 243,094 & 386,647 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
 &  & GOMAP & 88.33 & 96.42 & 99.99 & 100.00 & 134,917 & 87,166 & 291,091 & 513,174 & 3 & 2 & 6 & 11\\

\rowcolor{gray!6}   &  & GoldStandard & 3.89 & 0.15 & 0.38 & 4.10 & 1,554 & 65 & 299 & 1,918 & 1 & 0 & 0 & 1\\

 &  & Gramene49 & 29.98 & 45.58 & 40.03 & 55.55 & 20,072 & 31,056 & 30,089 & 81,217 & 1 & 1 & 1 & 3\\

\rowcolor{gray!6}  \multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & \multirow{-4}{*}{\raggedleft\arraybackslash 39,469} & Phytozome & 11.46 & 34.78 & 28.79 & 40.87 & 4,787 & 19,044 & 13,100 & 36,931 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
 &  & GOMAP & 93.36 & 94.93 & 100.00 & 100.00 & 88,468 & 81,963 & 278,518 & 448,949 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}   &  & GoldStandard & 21.23 & 25.60 & 30.82 & 38.07 & 11,510 & 15,019 & 25,737 & 52,428 & 1 & 1 & 1 & 3\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & \multirow{-3}{*}{\raggedleft\arraybackslash 39,324} & Gramene61-IEA & 37.57 & 56.11 & 60.94 & 74.13 & 20,265 & 47,657 & 58,110 & 126,525 & 1 & 1 & 2 & 3\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Zea mays} Mo17 & 38,620 & GOMAP & 87.04 & 90.88 & 100.00 & 100.00 & 87,221 & 78,938 & 277,586 & 443,745 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Zea mays} PH207 & 40,557 & GOMAP & 86.71 & 90.62 & 100.00 & 100.00 & 90,267 & 85,223 & 288,474 & 463,964 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Zea mays} W22 & 40,690 & GOMAP & 90.89 & 92.59 & 100.00 & 100.00 & 95,043 & 84,750 & 289,576 & 469,369 & 2 & 2 & 6 & 10\\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item \href{https://raw.githubusercontent.com/Dill-PICL/GOMAP-Paper-2019.1/master/analyses/quantity/results/quantity_table.csv}{Download this table (CSV)}
\item[a] How many genes in the genome have at least one GO term from the CC, BF, MP aspect annotated to them? A = How many at least one from any aspect? ($\textrm{A} = \textrm{CC} \cup \textrm{BF} \cup \textrm{MP}$)
\item[b] How many annotations in the CC, BF, and MP aspect does this dataset contain? A = How many in total? $\textrm{A} = \textrm{CC} + \textrm{BF} + \textrm{MP}$
\item[c] Take a typical gene that is present in the annotation set. How many annotations does it have in each aspect? A = How many in total? Please note that $\textrm{A} \neq \textrm{CC} + \textrm{BF} +\textrm{MP}$
\end{tablenotes}
\end{threeparttable}}
\end{table}

## Quality Evaluation
`TODO` If it turns out that our predictions are good with hF but bad with more approriate metrics, explanation would be that score thresholds for the prediction tools used in the GOMAP pipeline have been chosen to maximize this hF value. It now seems reasonable to re-adjust these thresholds to maximize a different metric which will likely result in a drop in hF score but increase in other metrics. Again emphasizes the importance of choosing the right evaluation metric.
Also shows how comparison between different pipelines/predictions can be difficult if chose different metric or optimized for different metric.
Also: if an annotation is not present in the gold standard, there is no way of knowing whether that gene truly doesn't have that function or whether it has just never been characterized/examined. So we cannot distinguish between a biologically true negative and an actually false negative in the gold standard.
This poses a problem when annotations are predicted that are not found in the gold standard: Is this truly a wrong prediction or is the gold standard incomplete? Especially in our case where the predictions not only contain more annotations than the gold standard, but are also more diverse.
In effect this means that a quality score as calculated above may not only describe the quality of the prediction, but to some extent also the completeness of the gold standard itself.
At least we can see here that gold standards with a median of 3 annotations per gene resulted in higher quality scores than gold standards with less annotations per gene, even though predictions were generated the same way in all cases.
`TODO maybe put a figure with regression quality score/median annotions per gene or something`
In conclusion this means that truly making a statement about the quality of a prediction set would require the ideal and complete gold standard.
The scores we can generate so far are by far not as meaningful.


\begin{table}[t]

\caption{(\#tab:quality-table)Quality evaluation of the used GO annotation sets.}
\centering
\resizebox{\linewidth}{!}{
\begin{threeparttable}
\begin{tabular}{llrr>{}r|rrr}
\toprule
\multicolumn{2}{c}{ } & \multicolumn{3}{c}{SimGIC2} & \multicolumn{3}{c}{TC-AUCPCR} \\
\cmidrule(l{3pt}r{3pt}){3-5} \cmidrule(l{3pt}r{3pt}){6-8}
Genome & Dataset & CC & BF & MP & CC & BF & MP\\
\midrule
\rowcolor{gray!6}  \textit{Hordeum vulgarum} & GOMAP & 0.309334 & 0.424286 & 0.180110 & NaN & 0.000493 & 0.000388\\
\cmidrule{1-8}
 & GOMAP & 0.499374 & 0.448762 & 0.213827 & 0.274482 & 0.261767 & 0.142014\\

\rowcolor{gray!6}  \multirow{-2}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-IEA & 0.416283 & 0.415342 & 0.324981 & 0.170662 & 0.257685 & 0.126104\\
\cmidrule{1-8}
 & GOMAP & 0.474972 & 0.418110 & 0.202528 & 0.014568 & 0.005485 & 0.009287\\

\rowcolor{gray!6}  \multirow{-2}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & Gramene61-IEA & 0.384973 & 0.346840 & 0.191962 & 0.004446 & 0.006115 & 0.004811\\
\cmidrule{1-8}
 & GOMAP & 0.235407 & 0.348389 & 0.096186 & 0.035907 & 0.001639 & 0.001017\\

\rowcolor{gray!6}   & Gramene49 & 0.299075 & 0.359259 & 0.164630 & 0.055498 & 0.003230 & 0.001965\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & Phytozome & 0.186238 & 0.347164 & 0.100965 & 0.014873 & 0.003058 & 0.000540\\
\cmidrule{1-8}
\rowcolor{gray!6}   & GOMAP & 0.498781 & 0.429594 & 0.212130 & 0.276072 & 0.245183 & 0.133683\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & Gramene61-IEA & 0.368491 & 0.411399 & 0.323139 & 0.159213 & 0.229186 & 0.130063\\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item \href{https://raw.githubusercontent.com/Dill-PICL/GOMAP-Paper-2019.1/master/analyses/quality/results/quality_table.csv}{Download this table (CSV)}
\end{tablenotes}
\end{threeparttable}}
\end{table}

<!--chapter:end:03-results.Rmd-->

\bibliography{GOMAP-Paper-Used}

<!--chapter:end:06-backmatter.Rmd-->


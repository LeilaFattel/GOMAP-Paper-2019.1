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

Table 1 provides information on the number of annotations that were removed this way from each dataset.
All further analyses were performed on the cleaned datasets since we assume the user will only be interested in still valid and non-redundant functional annotations.

## Quantitative Evaluation
lalala lololo table xyz

## Quality Evaluation
Quality evaluation of gene function predictions is not trivial and usually done by comparing the set of predicted functions of a gene against a *gold standard* consisting of annotations that are assumed to be correct.
We used annotations that were created or in some way curated with human participation for gold standards.
There are a plethora of different metrics to perform the comparison of predictions against this gold standard.
When we first published GOMAP [@Wimalanathan2018], we used a modified version of the hierarchical evaluation metrics originally introduced in [@Verspoor2006] because they were simple, clear, and part of an earlier attempt at unifying and standardizing GO annotation comparisons [@Defoin-Platel2011].
In the meantime, @Plyusnin2018 have published an approach for evaluating different metrics showing substantial differences within the robustness of different approaches.
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
\begin{threeparttable}
\begin{tabular}{llrr}
\toprule
Genome & Dataset & Obsolete Annotations & Duplicates\\
\midrule
\rowcolor{gray!6}  \textit{Brachypodium distachyon} & GOMAP & 696 & 43\\
\cmidrule{1-4}
\textit{Gossypium raimondii} & GOMAP & 184 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Hordeum vulgarum} & GoldStandard & 0 & 4\\
\cmidrule{1-4}
\textit{Medicago truncatula} A17 & GOMAP & 0 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Medicago truncatula} R108 & GOMAP & 0 & 0\\
\cmidrule{1-4}
 & GOMAP & 111 & 2\\

\rowcolor{gray!6}   & GoldStandard & 38 & 556\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-IEA & 10 & 14\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Phaseolus vulgaris} & GOMAP & 0 & 0\\
\cmidrule{1-4}
\textit{Sorghum bicolor} & GOMAP & 690 & 59\\
\cmidrule{1-4}
\rowcolor{gray!6}   & GOMAP & 285 & 0\\

 & GoldStandard & 0 & 10\\

\rowcolor{gray!6}  \multirow{-3}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & Gramene61-IEA & 47 & 48\\
\cmidrule{1-4}
\textit{Vigna unguiculata} & GOMAP & 0 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}   & GOMAP & 1107 & 70\\

 & GoldStandard-OFF & 1 & 0\\

\rowcolor{gray!6}   & Gramene49 & 94 & 2\\

\multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & Phytozome & 54 & 0\\
\cmidrule{1-4}
\rowcolor{gray!6}   & GOMAP & 752 & 83\\

 & GoldStandard & 55 & 174\\

\rowcolor{gray!6}  \multirow{-3}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & Gramene61-IEA & 99 & 157\\
\cmidrule{1-4}
\textit{Zea mays} Mo17 & GOMAP & 726 & 77\\
\cmidrule{1-4}
\rowcolor{gray!6}  \textit{Zea mays} PH207 & GOMAP & 798 & 76\\
\cmidrule{1-4}
\textit{Zea mays} W22 & GOMAP & 754 & 82\\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item \href{https://raw.githubusercontent.com/Dill-PICL/GOMAP-Paper-2019.1/master/analyses/cleanup/results/cleanup_table.csv}{Download this table (CSV)}
\end{tablenotes}
\end{threeparttable}
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
\rowcolor{gray!6}  \textit{Arachis hypogaea} & 67,124 & GOMAP & 85.91 & 84.70 & 100.00 & 100.00 & 153,433 & 132,944 & 493,799 & 780,176 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Brachypodium distachyon} & 34,310 & GOMAP & 81.38 & 85.37 & 100.00 & 100.00 & 75,877 & 69,709 & 255,807 & 401,393 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Glycine max} & 52,872 & GOMAP & 87.04 & 88.96 & 100.00 & 100.00 & 129,215 & 113,827 & 417,555 & 660,597 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\textit{Gossypium raimondii} & 37,505 & GOMAP & 93.08 & 92.39 & 100.00 & 100.00 & 96,793 & 85,511 & 307,921 & 490,225 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\rowcolor{gray!6}   &  & GOMAP & 88.68 & 91.79 & 100.00 & 100.00 & 88,130 & 80,282 & 272,823 & 441,235 & 2 & 2 & 5 & 10\\

\multirow{-2}{*}{\raggedright\arraybackslash \textit{Hordeum vulgarum}} & \multirow{-2}{*}{\raggedleft\arraybackslash 39,734} & GoldStandard & 0.02 & 0.05 & 0.05 & 0.07 & 7 & 23 & 45 & 75 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Medicago truncatula} A17 & 50,444 & GOMAP & 83.90 & 86.70 & 100.00 & 100.00 & 107,362 & 99,719 & 364,065 & 571,146 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Medicago truncatula} R108 & 55,706 & GOMAP & 72.40 & 90.15 & 100.00 & 100.00 & 112,343 & 108,031 & 382,322 & 602,696 & 1 & 2 & 5 & 9\\
\cmidrule{1-15}
\rowcolor{gray!6}   &  & GOMAP & 79.89 & 83.33 & 100.00 & 100.00 & 72,780 & 64,685 & 248,700 & 386,165 & 2 & 2 & 6 & 9\\

 &  & GoldStandard & 15.98 & 20.61 & 25.21 & 31.79 & 7,730 & 11,060 & 19,378 & 38,176 & 1 & 1 & 1 & 3\\

\rowcolor{gray!6}  \multirow{-3}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & \multirow{-3}{*}{\raggedleft\arraybackslash 35,825} & Gramene61-IEA & 30.07 & 43.37 & 46.63 & 59.86 & 14,633 & 32,787 & 39,105 & 86,529 & 1 & 1 & 1 & 3\\
\cmidrule{1-15}
\textit{Phaseolus vulgaris} & 27,433 & GOMAP & 94.54 & 93.10 & 100.00 & 100.00 & 72,005 & 64,583 & 229,630 & 366,218 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Sorghum bicolor} & 34,129 & GOMAP & 82.49 & 86.01 & 100.00 & 100.00 & 76,689 & 70,190 & 259,413 & 406,292 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
 &  & GOMAP & 88.61 & 91.01 & 100.00 & 100.00 & 267,741 & 218,623 & 785,960 & 1,272,324 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}   &  & GoldStandard & 0.89 & 0.57 & 1.54 & 1.73 & 1,590 & 923 & 4,807 & 7,323 & 1 & 0 & 2 & 3\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & \multirow{-3}{*}{\raggedleft\arraybackslash 107,891} & Gramene61-IEA & 26.74 & 55.24 & 48.72 & 70.24 & 38,975 & 109,319 & 109,518 & 257,832 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Vigna unguiculata} & 29,773 & GOMAP & 91.27 & 91.10 & 100.00 & 100.00 & 75,867 & 68,313 & 243,278 & 387,458 & 2 & 2 & 6 & 11\\
\cmidrule{1-15}
 &  & GOMAP & 88.34 & 96.46 & 100.00 & 100.00 & 135,211 & 87,420 & 291,251 & 513,882 & 3 & 2 & 6 & 11\\

\rowcolor{gray!6}   &  & GoldStandard-OFF & 3.92 & 0.15 & 0.38 & 4.14 & 1,565 & 65 & 299 & 1,929 & 1 & 0 & 0 & 1\\

 &  & Gramene49 & 29.98 & 45.58 & 40.03 & 55.55 & 20,072 & 31,056 & 30,089 & 81,217 & 1 & 1 & 1 & 3\\

\rowcolor{gray!6}  \multirow{-4}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v3} & \multirow{-4}{*}{\raggedleft\arraybackslash 39,469} & Phytozome & 11.46 & 34.78 & 28.79 & 40.87 & 4,787 & 19,044 & 13,100 & 36,931 & 0 & 1 & 1 & 2\\
\cmidrule{1-15}
 &  & GOMAP & 93.37 & 94.95 & 100.00 & 100.00 & 88,827 & 82,251 & 278,719 & 449,797 & 2 & 2 & 6 & 10\\

\rowcolor{gray!6}   &  & GoldStandard & 21.23 & 25.60 & 30.82 & 38.07 & 11,510 & 15,019 & 25,737 & 52,428 & 1 & 1 & 1 & 3\\

\multirow{-3}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & \multirow{-3}{*}{\raggedleft\arraybackslash 39,324} & Gramene61-IEA & 37.57 & 56.11 & 60.94 & 74.13 & 20,265 & 47,657 & 58,110 & 126,525 & 1 & 1 & 2 & 3\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Zea mays} Mo17 & 38,620 & GOMAP & 87.05 & 90.90 & 100.00 & 100.00 & 87,567 & 79,214 & 277,787 & 444,568 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\textit{Zea mays} PH207 & 40,557 & GOMAP & 86.72 & 90.64 & 100.00 & 100.00 & 90,617 & 85,500 & 288,677 & 464,794 & 2 & 2 & 6 & 10\\
\cmidrule{1-15}
\rowcolor{gray!6}  \textit{Zea mays} W22 & 40,690 & GOMAP & 90.90 & 92.61 & 100.00 & 100.00 & 95,390 & 85,039 & 289,780 & 470,209 & 2 & 2 & 6 & 10\\
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
Genome & Dataset & CC & MF & BP & CC & MF & BP\\
\midrule
\rowcolor{gray!6}  \textit{Hordeum vulgarum} & GOMAP & 0.309334 & 0.424286 & 0.180110 & NaN & 0.000492 & 0.000388\\
\cmidrule{1-8}
 & GOMAP & 0.498631 & 0.454389 & 0.213624 & 0.272899 & 0.268926 & 0.141812\\

\rowcolor{gray!6}  \multirow{-2}{*}{\raggedright\arraybackslash \textit{Oryza sativa}} & Gramene61-IEA & 0.416283 & 0.415342 & 0.324981 & 0.170662 & 0.257685 & 0.126104\\
\cmidrule{1-8}
 & GOMAP & 0.473080 & 0.417054 & 0.202375 & 0.014552 & 0.005456 & 0.009284\\

\rowcolor{gray!6}  \multirow{-2}{*}{\raggedright\arraybackslash \textit{Triticum aestivum}} & Gramene61-IEA & 0.384973 & 0.346840 & 0.191962 & 0.004446 & 0.006115 & 0.004811\\
\cmidrule{1-8}
 & GOMAP & 0.498574 & 0.434275 & 0.212010 & 0.274600 & 0.249346 & 0.133593\\

\rowcolor{gray!6}  \multirow{-2}{*}{\raggedright\arraybackslash \textit{Zea mays} B73.v4} & Gramene61-IEA & 0.368491 & 0.411399 & 0.323139 & 0.159213 & 0.229186 & 0.130063\\
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


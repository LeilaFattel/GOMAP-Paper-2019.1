library(ggplot2)

## Colorblind Palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

busco_plot <- function(df, filepath) {
  ## Treat Genomes as factor to maintain order of dataframe
  df$Genomes <- factor(df$Genomes, levels=unique(df$Genomes))
  
  df$Category <- factor(df$Category, levels = c("Complete & Single Copy", "Complete & Duplicate Copy", "Fragmented", "Missing"))
  
  ## mylabels (to italicize the labels)
  mylables <- c(expression(paste(italic("G. raimondii"))), expression(paste(italic("C. sativa"))), expression(paste(italic("A. hypogaea"))), expression(paste(italic("M. truncatula"), " ", "A17")), expression(paste(italic("M. truncatula"), " ", "R108")), expression(paste(italic("G. max"))), expression(paste(italic("P. vulgaris"))), expression(paste(italic("V. unguiculata"))), expression(paste(italic("O. sativa"))), expression(paste(italic("B. distachyon"))), expression(paste(italic("T. aestivum"))), expression(paste(italic("H. vulgare"))), expression(paste(italic("S. bicolor"))), expression(paste(italic("Z. mays"), " ", "B73")), expression(paste(italic("Z. mays"), " ","PH207")),expression(paste(italic("Z. mays")," ", "W22")),expression(paste(italic("Z. mays"), " ","Mo17")))
  
  ## Scatter Plot Script
  p1 <- ggplot(df, aes(fill=Category, y=BUSCO_Score, x=Genomes)) + geom_bar(position= position_stack(reverse = TRUE), stat="identity") + 
    xlab("Genomes") + ylab("Percentage of BUSCO Genes") + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 30 , size = 6, vjust = 0.95 , hjust = 0.95), legend.title = element_text( size=5), legend.text=element_text(size=5)) + 
    scale_fill_manual(values = cbPalette) + theme(panel.background = element_blank()) + guides(fill = guide_legend(reverse = TRUE)) + 
    scale_x_discrete("Genomes", labels=mylables)
  pdf(filepath, 9, 6)
  print(p1)
  dev.off()
}

busco_plot(read.csv("analyses/busco/results/assembly_scores.csv"), "figures/BUSCO_assembly.pdf")
busco_plot(read.csv("analyses/busco/results/annotation_scores.csv"), "figures/BUSCO_annotation.pdf")
#!/usr/bin/env Rscript
# Last updated: June 2025
# https://github.com/Keonapang/RovHer

# For a given protein-coding gene, retrieve all rare variants with RovHer scores
################################################

if (!requireNamespace("data.table", quietly = TRUE)) {
  install.packages("data.table")
}
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}

suppressMessages(library(data.table))
suppressMessages(library(tidyverse))

args <- commandArgs(trailingOnly = TRUE)
GENE <- args[1]
DIR_OUT <- args[2]

if (length(args) < 2) {
  stop("Usage: Rscript ./Scripts/get_scores_per_gene.r <GENE> <DIR_OUT>")
}

if (!dir.exists(DIR_OUT)) {
  stop(paste("Directory does not exist:", DIR_OUT))
}

cat("Selected gene:", GENE, "\n")
cat("Output directory:", DIR_OUT, "\n\n")

# Load
cat("Loading master score file...\n")
score_file <- fread("All_RovHer_Scores.txt.gz")

# Ensure that the input GENE is valid
if (!gene %in% unique(score_file$Gene)) {
  stop(paste(gene, "not found in the score file."))
}

gene_rows <- merged_data[Gene == GENE]

if (dim(gene_rows)[1] > 0) {
  cat(dim(gene_rows)[1], "rare variants found in", gene, "\n")
} else if (dim(gene_rows)[1] == 0) {
  stop(paste("No rare variants found for gene:", GENE))
}

# Save
outfile_gene <- paste0(DIR_OUT, "/output_",GENE,".txt")
fwrite(gene_rows, file = outfile_gene, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
cat("Done!\n\n")
cat("Results saved to:", outfile_gene, "\n")
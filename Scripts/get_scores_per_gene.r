#!/usr/bin/env Rscript
# Last updated: June 2025
# https://github.com/Keonapang/RovHer

# For a given protein-coding gene, retrieve all rare variants with RovHer scores
################################################

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("data.table", quietly = TRUE)) {
  install.packages("data.table")
}
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}

suppressMessages(library(data.table))
suppressMessages(library(dplyr))
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

# Check if "All_RovHer_Scores.txt.gz" is in the same directory as this script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
infile <- file.path(script_dir, "All_RovHer_Scores.txt.gz")

setwd(DIR_OUT)
cat("Selected GENE:", GENE, "\n")
cat("Output directory:", DIR_OUT, "\n\n")

# Load
cat("Loading master score file...\n")
score_file <- fread("All_RovHer_Scores.txt.gz")

# Ensure that the input GENE is valid
if (!gene %in% unique(score_file$Gene)) {
  stop(paste(gene, "not found in the score file."))
}

gene_rows <- merged_data[Gene == GENE]
print(dim(gene_rows))
cat(dim(gene_rows)[1], " rare variants found in", gene, ".\n")

# Save
outfile_gene <- paste0("output_scores_", GENE, ".txt")
fwrite(gene_rows, file = outfile_gene, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
cat("Done!\n\n")
cat("Results saved to:", outfile_gene, "\n")
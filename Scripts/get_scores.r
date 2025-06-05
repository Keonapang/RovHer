#!/usr/bin/env Rscript
# Last updated: June 2025

# Get Rovher scores for a list of input rare variants. 
#########################################################

# check if library is present
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
INFILE <- args[1]
DIR_OUT <- args[2]

if (length(args) < 3) {
  stop("Usage: Rscript ./Scripts/get_RovHer_scores.r <INFILE> <DIR_OUT>")
}

if (!dir.exists(DIR_OUT)) {
  stop(paste("Directory does not exist:", DIR_OUT))
}
if (!dir.exists(INFILE)) {
  stop(paste("Input file does not exist:", INFILE))
} 
if (file.info(INFILE)$size == 0) {
  stop(paste("Input file is empty:", INFILE))
}

# Check if "All_RovHer_Scores.txt.gz" is in the same directory as this script
script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
infile <- file.path(script_dir, "All_RovHer_Scores.txt.gz")

setwd(DIR_OUT)
cat("Input variant list:", INFILE, "\n\n")
cat("Output directory:", DIR_OUT, "\n\n")

# Load
data <- fread(INFILE)

score_file <- fread("All_RovHer_Scores.txt.gz")

# Check if data is formatted correctly
if (ncol(data) != 1) {
  stop("The input data does not consist of exactly one column.")
}
is_valid_variant <- grepl("^\\d+:\\d+:[A-Za-z]+:[A-Za-z]+$", data[[1]])
if (!all(is_valid_variant)) {
  stop("Not all values in the column are valid variant IDs.")
}

# Merge
data <- merge(data, score_file, by = "PLINK_SNP_NAME", all.x = TRUE)

# Save
outfile <- paste0("output_scores_", basename(INFILE), ".txt")
fwrite(merged_data, file = outfile_cleaned, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
cat("Saved to:", outfile_cleaned, "\n")
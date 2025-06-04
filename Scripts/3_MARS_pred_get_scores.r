#!/usr/bin/env Rscript
# June 2025
# Descrption: Training one 'universal' MARS model with height FDR (highest h2) 
#             using 5-fold CV (per chr region). Then saving FDR predictions on all ~ 3 million RVs.
#             This subset of RV will be the same across all cont' traits. 
#####################################################################################################################################################
# How to impute zeros in GENEBASS_AF?
# how to mean-impute missing values?
# how many rows to input into MARS?
suppressMessages(library(Metrics))
suppressMessages(library(data.table))
suppressMessages(library(dplyr))
suppressMessages(library(rsample))
suppressMessages(library(tidyverse))
suppressMessages(library(earth))

# Input Directory
dir_gene <-"/mnt/nfs/rigenenfs/shared_resources/biobanks/UKBIOBANK/pangk/RovHer_GitHub/gene"
dir_var <-"/mnt/nfs/rigenenfs/shared_resources/biobanks/UKBIOBANK/pangk/RovHer_GitHub"
model_dir <- "/mnt/nfs/rigenenfs/shared_resources/biobanks/UKBIOBANK/pangk/Training/height_FDR/GENEBASS_RV_train_RV_pred_Oct10"

# Output directory
OUTDIR <- paste0(dir_var, "/All_RV_predictions")
dir.create(OUTDIR, showWarnings = FALSE)

###################################################################
# 1)  Form MARS prediction matrix 
      # Outputs: a MARS prediction matrix with 11 predictors 
###################################################################

col_list <- c( # col_list <- fread("/UKBIOBANK/pangk/Training/height_FDR/9_variant_gene_FDR_height_vars_Jul31_predict.txt")
  "LOF_DISRUPTIVE", "GENEBASS_AF", "AlphaMissense_score", "BayesDel_noAF_score", "BayesDel_addAF_rankscore", "LRT_score", 
  "PrimateAI_score","Polyphen2_HDIV_score", "Polyphen2_HVAR_score", "gMVP_score", 
  "MPC_score", "MetaRNN_score", "MetaLR_score", "M-CAP_score","REVEL_score", 
  "CADD_raw", "CADD_phred", "MVP_score", "ClinPred_score", "H1-hESC_fitCons_score", 
  "GM12878_fitCons_score", "GERP_91_mammals", "phastCons470way_mammalian", "Eigen-PC-phred_coding", 
  "GenoCanyon_score", "fathmm-XF_coding_score", "fathmm-MKL_coding_score",
  "PHACTboost_score", "MutFormer_score", "DEOGEN2_score", "DANN_score", 
  "HUVEC_fitCons_score", "LINSIGHT", "PROVEAN_score", "FATHMM_score", "VEST4_score", 
  "phastCons17way_primate", "phyloP17way_primate", "phyloP100way_vertebrate",
  "phastCons100way_vertebrate", "MetaSVM_score","GERP++_RS", "MISTIC_score", "Roulette_MR", "PrimateAI_3D", "P(HI)", 
  "HIPred_score", "GHIS", "RVIS_EVS", "LoF-FDR_ExAC", "RVIS_ExAC", "ExAC_pLI", "ExAC_pRec", "ExAC_pNull", "gnomAD_pLI", 
  "gnomAD_pRec", "gnomAD_pNull", "GDI", "GDI-Phred","Gene_indispensability_score", 
  "obs_lof", "exp_lof", "UNEECON-G", "cpg_density", "promoter_phastcons", "exonic_phastcons", "PPI_degree", 
  "gene_expression_level", "tissue_specificity_tau", "h3k4me3", "h2az", "h3k27me3", "h3k9ac"
)

##############################################################################################################################
# Obtain MARS on 30 files 
##############################################################################################################################
# Load model
load(paste0(model_dir,"/noAF_nonCV_d3_np15_nv0.1_lowerAF3e-05_upperAF1e-02.RData"))

for (chunk in 1:30) {
  cat("------- File", chunk, "--------\n")
  
  outfile_scores <- paste0(OUTDIR, "/RovHer_scores_RV_", chunk, ".txt")
  # if (file.exists(outfile_scores)) {
  #   cat("Skipping chunk", chunk, "as output file exists.\n")
  #   next
  # }
  
  # Load variant and gene annotation matrices
  var_matrix <- paste0(dir_var, "/anno_matrix_", chunk, ".txt.gz")
  gene_matrix <- paste0(dir_gene, "/anno_matrix_", chunk, ".txt.gz")
  
  if (!file.exists(var_matrix) || !file.exists(gene_matrix)) {
    cat("Skipping chunk", chunk, "due to missing file(s).\n\n")
    next  # Skip the rest of the loop and move to the next iteration
  }
  
  # Read variant annotation matrix
  var_anno <- fread(var_matrix, select = c(
    "PLINK_SNP_NAME", "GENEBASS_AF", "AlphaMissense_score", 
    "BayesDel_addAF_rankscore", "DANN_score", "HIPred_score", 
    "fathmm-XF_coding_score"
  ))
  cat("'var_anno': ", dim(var_anno)[1], "x", dim(var_anno)[2], "\n")
  
  # Read gene annotation matrix and remove duplicates
  gene_anno <- fread(gene_matrix)
  gene_anno <- unique(gene_anno, by = "PLINK_SNP_NAME")
  cat("'gene_anno': ", dim(gene_anno)[1], "x", dim(gene_anno)[2], "\n")
  
  # Merge annotations
  annos <- merge(var_anno, gene_anno, by = "PLINK_SNP_NAME", all.x = TRUE)
  annos <- annos[GENEBASS_AF < 0.01, ]  # Filter rows
  cat("'annos': ", dim(annos)[1], "x", dim(annos)[2], "\n")
  
  # Keep only the PLINK_SNP_NAME column
  PLINK_SNP_NAME_Gene <- dplyr::select(annos, PLINK_SNP_NAME,Gene)
  
  # Add missing columns with value = 0
  new_cols <- setdiff(col_list, colnames(annos))
  annos[, (new_cols) := 0]
  annos <- annos[, ..col_list]
  cat("Final RV training matrix: ", dim(annos)[1], "x", dim(annos)[2], "\n\n") # 73 cols

  # Mean-impute missing values
  annos[, (names(annos)) := lapply(.SD, function(x) {
    if (is.numeric(x)) {
      x[is.na(x)] <- mean(x, na.rm = TRUE)
    }
    return(x)
  })]
  
  # Replace 0 values of GENEBASS_AF with the lowest non-zero value
  min_nonzero_genebass_af <- min(annos$GENEBASS_AF[annos$GENEBASS_AF > 0], na.rm = TRUE)
  max_nonzero_genebass_af <- max(annos$GENEBASS_AF, na.rm = TRUE)
  annos[GENEBASS_AF == 0, GENEBASS_AF := min_nonzero_genebass_af]
  cat("Min AF:", min_nonzero_genebass_af, "  max AF:", max_nonzero_genebass_af, "\n\n")
  
  # Get MARS predictions
  predictions <- predict(mars_model, newdata = annos)
  
  # Combine predictions with PLINK_SNP_NAME
  scores_df <- data.frame(RovHer_score = predictions)
  yhat_final <- cbind(PLINK_SNP_NAME_Gene, scores_df)

  # Rename third column to "RovHer_score"
  colnames(yhat_final)[3] <- "RovHer_score"
  cat("Final predictions: ", dim(yhat_final)[1], "x", dim(yhat_final)[2], "\n\n")
  fwrite(yhat_final, file = outfile_scores, sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)
}


##############################################################################################################################
# Analyze files
# Combine all scores into a single data frame
##############################################################################################################################
outfile_cleaned <- paste0(OUTDIR, "/All_RovHer_Scores.txt.gz")

# Step 1: Merge all score files by row
score_files <- list.files(OUTDIR, pattern = "^RovHer_scores_RV_\\d+\\.txt$", full.names = TRUE)
merged_data <- rbindlist(lapply(score_files, fread))

# Step 2: Extract chromosome and position from "PLINK_SNP_NAME" and filter out X/Y chromosomes
merged_data[, c("chr", "pos") := tstrsplit(PLINK_SNP_NAME, ":", fixed = TRUE)[1:2]]

# Convert "chr" and "pos" to numeric for sorting (exclude non-autosomal chromosomes like X/Y)
merged_data <- merged_data[!chr %in% c("X", "Y")]
merged_data[, `:=`(chr = as.numeric(chr), pos = as.numeric(pos))]

# Step 3: Sort data by chromosome and position
merged_data <- merged_data[order(chr, pos)]

# Step 4: Calculate mean, median, and mode of "RovHer_score"
mean_score <- mean(merged_data$RovHer_score, na.rm = TRUE)
median_score <- median(merged_data$RovHer_score, na.rm = TRUE)

# Function to calculate mode
calculate_mode <- function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}
mode_score <- calculate_mode(merged_data$RovHer_score)

cat("Mean RovHer_score:", mean_score, "\n")
cat("Median RovHer_score:", median_score, "\n")
cat("Mode RovHer_score:", mode_score, "\n")

# Minimum and maximum scores
min_score <- min(merged_data$RovHer_score, na.rm = TRUE)
max_score <- max(merged_data$RovHer_score, na.rm = TRUE)
cat("Minimum RovHer_score:", min_score, "\n")
cat("Maximum RovHer_score:", max_score, "\n")
print(dim(merged_data))

print(head(merged_data,5))
print(tail(merged_data,5))

# Coun the number of unique RovHer_score in merged_data
unique_scores <- length(unique(merged_data$RovHer_score))
cat("Number of unique RovHer_score:", unique_scores, "\n") # Number of unique RovHer_score: 53847397

# remove coluns "chr" and "pos"
merged_data[, c("chr", "pos") := NULL]
merged_data <- merged_data[, c("PLINK_SNP_NAME", "Gene", "RovHer_score"), with = FALSE]
fwrite(merged_data, file = outfile_cleaned, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
cat("Saved to:", outfile_cleaned, "\n")

##############################################################################################################################
# Prepare demo data (10 rows)
##############################################################################################################################
# Pick 10 random rows from merged_data, 3 of which have a RovHer_score less than 0.4

set.seed(42)  # For reproducibility
dir_github <-"/mnt/nfs/rigenenfs/shared_resources/biobanks/UKBIOBANK/pangk/RovHer_GitHub/RovHer/Demo"
# S Subset rows with RovHer_score < 0.4
low_score_rows <- merged_data[RovHer_score < 0.4]
high_score_rows <- merged_data[RovHer_score >= 0.4]
sampled_low <- low_score_rows[sample(.N, min(3, .N))]  # Ensure there are at least 3 rows
sampled_high <- high_score_rows[sample(.N, 10 - nrow(sampled_low))]  # Remaining rows
sampled_rows <- rbindlist(list(sampled_low, sampled_high))
# Step 6: Shuffle the final result to randomize order
sampled_rows <- sampled_rows[sample(.N)]
print(sampled_rows)
outfile_demo <- paste0(dir_github, "/output_scores.txt")
fwrite(random_rows, file = outfile_demo, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)


##############################################################################################################################
# PLOT: Distribution of Rovher scores 
##############################################################################################################################
suppressMessages({
  library(data.table)
  library(dplyr)
  library(ggplot2)
  library(rsample)
  library(tidyverse)
  library(gridExtra)
  library(discrim)
  library(scales)
  library(ggpubr)
  library(grid)
})

########### same as above, but log (count+1) transformed y axis for RV (MAF < 0.01) ###############
#  shift all y-values by 1. This allows zero values to be displayed as log(1) = 0 on the log scale:

font <- "Sans"
psize <- 15
p <- ggplot(data = merged_data, aes(x = RovHer_score)) +
  geom_histogram(aes(y = after_stat(count + 1)), binwidth = 0.0020, fill = "#CC6a66", color = "#CC6a66", boundary = 0) +
  scale_x_continuous(limits = c(-1.05, 0.88), breaks = seq(-1.05, 0.88, by = 0.1)) +
  scale_y_continuous(
    trans = 'log10', 
    breaks = c(1, 10, 100, 1000, 10000, 100000),  # Define breaks (log10(1) = 0, log10(10) = 1, ...)
    labels = c("0", expression(10^1), expression(10^2), expression(10^3), expression(10^4), expression(10^5))
  ) +
  labs(
    title = "Distribution of scores across all autosomal rare variants (MAF < 0.01)",
    x = "RovHer scores",
    y = expression(paste("Log"[10], "(Count + 1)"))
  ) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", colour = "white"),
    panel.background = element_rect(fill = "white", colour = "white"),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "#e1e0e0", linewidth = 0.5),
    axis.title = element_text(size = 19, family = font),
    axis.text.x = element_text(size = 20, family = font),
    axis.text.y = element_text(size = 20, family = font),
    axis.title.x = element_text(margin = margin(t = 15), family = font),
    axis.title.y = element_text(margin = margin(r = 15), family = font),
    plot.title = element_text(size = 21, hjust = 0.5, family = font)  # Center align title
  )
file_path <- paste0(OUTDIR, "/RV_RovHer_logscale.png")
ggsave(file_path, plot = p, width = 19, height = 10, dpi = 300)



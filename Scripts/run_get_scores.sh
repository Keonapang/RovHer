#!/usr/bin/bash
# Last updated: June 2025

# This script runs the RovHer script to retrieve 
# scores for a list of input variants.

# Inputs a .txt file with a list of variant PLINK IDs (formatted as "chr:pos:ref:alt")
# Outputs a .txt file with three tab-delimited columns: PLINK_SNP_NAME, Gene, RovHer_score

###################################################################

mydir="/my/working/dir" # modify 
INFILE="$mydir/RovHer/Demo/input_variants.txt" # modify
DIR_OUT="$mydir/RovHer/Demo" # modify

cd $mydir/RovHer
Rscript Scripts/get_scores.r $INFILE $DIR_OUT
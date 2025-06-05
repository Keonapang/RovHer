#!/usr/bin/bash
# Last updated: June 2025

# This script runs the RovHer script to retrieve 
# scores for a list of input variants.

# OUTPUTS: A `output_gene.txt` or `output_geneset.txt` with tab-delimited columns
###################################################################

mydir="/my/working/dir" # modify 
DIR_OUT="$mydir/RovHer/Demo"

GENE="gene" # modify 
# or
GENE="LDLR APOB BRCA1"

cd $mydir/RovHer
Rscript Scripts/get_scores_per_gene.r "$DIR_OUT" "$GENE"


#!/usr/bin/bash
# Last updated: June 2025

# This script runs the RovHer script to retrieve 
# scores for a list of input variants.
###################################################################

mydir="/my/working/dir" # modify 
GENE="gene" # modify 
DIR_OUT="$mydir/RovHer/Demo"

cd $mydir/RovHer
Rscript ./Scripts/get_scores_per_gene.r $GENE $DIR_OUT


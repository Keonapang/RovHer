#!/usr/bin/bash
# Last updated: June 2025

# This script runs the RovHer script to retrieve 
# scores for a list of input variants.
###################################################################

mydir="/my/working/dir" # modify 
INFILE="$mydir/RovHer/Demo/input_variants.txt" # modify
DIR_OUT="$mydir/RovHer/Demo" # modify

cd $mydir/RovHer
Rscript /Scripts/get_scores.r $INFILE $DIR_OUT
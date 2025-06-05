#!/usr/bin/bash
# Last updated: June 2025

# This script runs the RovHer script to retrieve 
# scores for a list of input variants.
###################################################################

INFILE="./RovHer/Demo/input_variants.txt"
DIR_OUT="./RovHer/Demo"

cd ./RovHer
Rscript ./Scripts/get_scores.r $INFILE $DIR_OUT


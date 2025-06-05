#!/usr/bin/bash
# This script runs the RovHer tool to calculate variant scores.

INFILE="./RovHer/Demo/input_variants.txt"
DIR_OUT="./RovHer/Demo"

cd ./RovHer
Rscript ./scripts/get_RovHer_scores.r $INFILE $DIR_OUT


#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -o GAGE.%j.out
#SBATCH -t 0-1
#SBATCH --mem=62G


source /app/Lmod/lmod/lmod/init/bash
#########################



# --partition=largenode
# --mem=62G
# -c 16 
#NOTE: Rscript does not load package methods. Need that in the submitted script to load library(methods).
module purge
ml R-bundle-Bioconductor/3.5-foss-2016b-R-3.4.0-fh1

# Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/CBFA2T3_GLIS2/gage_CBFA2T3.GLIS2.r
# Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/NUP98_KDM5A/gage_NUP98.KMD5A.r
Rscript $1

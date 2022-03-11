#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o fusanno.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org

source /app/Lmod/lmod/lmod/init/bash
#########################

#NOTE: Rscript does not load package methods. Need that in the submitted script to load library(methods).
module purge
ml R-bundle-Bioconductor/3.5-foss-2016b-R-3.4.0-fh1

# Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/CBFA2T3_GLIS2/gage_CBFA2T3.GLIS2.r
# Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/NUP98_KDM5A/gage_NUP98.KMD5A.r
Rscript $1

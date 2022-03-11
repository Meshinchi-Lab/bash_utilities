#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o R.%j.out
#SBATCH -t 0-1
#SBATCH --mem=30G


source /app/Lmod/lmod/lmod/init/bash
#########################


ml R-bundle-Bioconductor/3.5-foss-2016b-R-3.4.0-fh1

Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/gage_ETS.r

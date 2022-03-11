#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o DeMixT.%j.out
#SBATCH --time 168:00:00
#SBATCH --mem=30G


source /app/Lmod/lmod/lmod/init/bash
#########################


ml R-bundle-Bioconductor/3.5-foss-2016b-R-3.4.0-fh1

Rscript /home/jlsmith3/scripts/RNAseq_Analysis/DeMixT.r

#! /bin/bash
#SBATCH --mem=30G
#SBATCH -o  toil.%j.out
#SBATCH -t 0-1

source /app/Lmod/lmod/lmod/init/bash 
################



ml R-bundle-Bioconductor/3.5-foss-2016b-R-3.4.0-fh1

module list 

Rscript  ~/scripts/RNAseq_Analysis/filterDups_TOIL_dataset.r



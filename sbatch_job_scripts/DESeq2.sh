#! /bin/bash
#SBATCH -n 1
#SBATCH -o  DESeq2.%j.out


source /app/Lmod/lmod/lmod/init/bash

ml R/3.4.0-foss-2016b-fh1

echo module loaded 

cd  /home/jlsmith3/scripts/RNAseq_Analysis/DifferentialExpn_PathwayAnalysis/

Rscript DESEq2_DE_Function.r



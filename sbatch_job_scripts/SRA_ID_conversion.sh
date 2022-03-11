#! /bin/bash
#SBATCH -n 1
#SBATCH -o  SRA_ID_Convert.%j.out
#SBATCH -t 06:00:00

source /app/Lmod/lmod/lmod/init/bash

module load R/3.2.2

echo module loaded 

Rscript SRA_ID_conversion.r

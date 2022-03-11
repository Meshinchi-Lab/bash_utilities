#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e name.%j.stderr
#SBATCH -o name.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=BEGIN,END,FAIL 
#SBATCH --mail-user=''
source /app/Lmod/lmod/lmod/init/bash
################################

#ml stands for 'module load'
ml SAMtools/1.8-foss-2016b

# path="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_1031_Illumina_data"
path="/fh/fast/meshinchi_s/May2013"
cd $path

file=$1

echo $file 

done

 



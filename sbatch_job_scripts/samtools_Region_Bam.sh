#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e regions.%j.stderr
#SBATCH -o  regions.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#Set Flags
set -euo pipefail

# module load SAMtools/1.4.1-foss-2016b
ml SAMtools/1.8-foss-2016b

# path="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_1031_Illumina_data"
SCRATCH="/fh/scratch/delete90/meshinchi_s"
path="$SCRATCH/jlsmith3/CBL/BAMs"
cd $path


bam=$1
filename=$(basename $bam)
prefix=${filename%.bam}
sample=${filename%.srt.bam}_CBL.srt.bam

samtools view -h -b  $bam "11:119076752-119170491"  | samtools sort -@ 4 -o "$path/$sample" -O BAM -T $prefix -
samtools index -b "$path/$sample"

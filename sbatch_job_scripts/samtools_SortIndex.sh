#!/bin/bash
#
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e sortBAM.%j.stderr
#SBATCH -o  sortBAM.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

# module load SAMtools/1.4.1-foss-2016b
ml SAMtools/1.8-foss-2016b

# path="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_1031_Illumina_data"
path="/fh/scratch/delete30/meshinchi_s/jlsmith3/SRA/TCS"
cd $path


bam=$1
#Prefix for Target barcodes
# prefix=$(echo $bam | sed -E 's/^.+([A-Z0-9]{6,7})\-.+/\1/' )
prefix=${bam%.bam}

samtools sort -@ 4 -o ${bam%.bam}.srt.bam -O BAM -T $prefix "$path/$bam"
samtools index -b "$path/${bam%.bam}.srt.bam"


#wait

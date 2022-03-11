#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -e kallisto.%j.stderr
#SBATCH -o kallisto.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load SAMtools/1.4.1-foss-2016b
module load BEDTools/2.26.0-foss-2016b

sampleDir="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/test"
cd $sampleDir

bam=$1
sampleName=${bam%.bam}

samtools sort -n -@ 16 -O BAM -o ${sampleName}.qsrt.bam $bam

bedtools bamtofastq -i ${sampleName}.qsrt.bam \
                      -fq ${sampleName}.r1.fq \
                      -fq2 ${sampleName}.r2.fq




#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 0-1
#SBATCH --mem=33G
#SBATCH --mail-type=END 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load SAMtools/1.4.1-foss-2016b
module load BEDTools/2.26.0-foss-2016b
module load kallisto/0.43.1-foss-2016b
PATH=~/scripts/opt/bin:$PATH


#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"

#scratch directory
scratch="$SCRATCH/gizmo/$SLURM_JOB_ID"


#Location of samples 
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2016Apr_BCCA_AAML0531_Illumina_data"
cd $sampleDir


#BAM file to be processed. 
bam=$1
sampleName=${bam%.bam}
prefix=$(echo $bam | sed -E 's/^([A-Z]{6})\-.+/\1/' ) 

#Fastq file names 
r1="${sampleName}.r1.fq"
r2="${sampleName}.r2.fq"




#Sort BAMs by name for paired-end reads
#should be done on scratch 
samtools sort -n -@ 16 -O BAM -o "${sampleName}.qsrt.bam" -T "$prefix" "$bam" 


#Convert BAM to fastq
#can pipe into the kallisto or be done on scratch 
bedtools bamtofastq -i "${sampleName}.qsrt.bam" -fq $r1 -fq2 $r2







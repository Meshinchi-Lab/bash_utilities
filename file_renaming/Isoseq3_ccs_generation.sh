#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -o ccs.%j.out
#SBATCH -e ccs.%j.stderr
#SBATCH -t 0-3
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################



#Jenny Smith
#Run Isoseq3 CCS (consensus cluster sequence)


TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
dir="$SCRATCH/SMRTseq"

subread_bam=$1
samp=${subread_bam%.subreads.bam}

echo $subread_bam

ccs  $subread_bam ${samp}.css.bam -noPolish --minPasses 1 --numThreads 16

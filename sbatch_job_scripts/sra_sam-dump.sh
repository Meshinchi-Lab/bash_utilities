#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o sam-dump.%j.out
#SBATCH -e sam-dump.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

# Load Modules
ml SRA-Toolkit/2.9.2-ubuntu64
ml SAMtools/1.8-foss-2016b
#ml SRA-Toolkit/2.9.0-ubuntu64
#ml SRA-Toolkit/2.8.0-ubuntu64
#ml SAMtools/1.6-foss-2016b


#exit script if any commands return an error
set -e
set -x


#Protected directory
cd /fh/scratch/delete90/meshinchi_s/SRA/sra


#SRA file to be processed.Can have eithr SRR alone, or SRR.sra file.
SRR=$1
sampleName=${SRR%.sra}


#Convert sra to bam files
if sam-dump.2.9.2 -r -u "$SRR" | samtools view -@ 4 -b -o "${sampleName}.bam" 2> "${sampleName}_sam-dump.stderr"
then
  #USE PIPEFAIL. this doesnt work. but it has previously...
    echo "Successful $SRR"
else
    echo "Error in $SRR"
    exit 1
fi

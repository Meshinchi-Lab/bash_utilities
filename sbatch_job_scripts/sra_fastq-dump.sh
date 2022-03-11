#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 0-1
#SBATCH --mem 50G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


#NOTE: only use largenode when buffer error occurs - since it takes too long to wait for largenodes to be available
#most jobs can run on campus node.

#exit script if any commands return an error
set -ex

#Load Modules
module purge
ml SRA-Toolkit/2.9.2-ubuntu64
# module load SRA-Toolkit/2.8.0-ubuntu64

#main  protected directory
dbGaP="/fh/scratch/delete90/meshinchi_s/SRA/sra"

#scratch directory
scratch="/fh/scratch/delete90/meshinchi_s/jlsmith3"

#SRA to be processed.
SRR=$1
echo $SRR

#Fastq file names
sampleName=${SRR%.sra}
fq="${sampleName}.fq"

#cd to SRA protected directory
cd $dbGaP

#Convert to fastq
fastq-dump.2.9.2 --gzip --skip-technical  --readids --dumpbase --split-3 --read-filter pass -O $dbGaP $SRR

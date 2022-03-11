#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o Picard.%j.out
#SBATCH -t 0-1
#SBATCH --mem 30G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load picard/2.7.1-Java-1.8.0_92


#exit script if any commands return an error
set -e

#main directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#scratch directory
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"



#Location of samples
#sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_AAML1031_Illumina_data"
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/BCCA_Data_Downloads/2017July_BCCA_SOW.GSC1483__Illumina_Data"
cd $sampleDir


#BAM file to be processed.
file=$1
bam=$(basename $1)
sampleName=${bam%.bam}


#Fastq file names
r1="${sampleName}_r1.fq"
r2="${sampleName}_r2.fq"


#Convert BAM to fastq
#filenames with suffix .gz are automatically gzipped by Picard tools.
#Include all reads, whether pass filter (PF) or not. changing flag does not improve or take away from psuedoalignemnt performance.
if java -Xmx30G -Xms15G -jar ${EBROOTPICARD}/build/libs/picard.jar SamToFastq QUIET=true INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT MAX_RECORDS_IN_RAM=500000 I="$file" F="$scratch/$r1" F2="$scratch/$r2" 2> "$scratch/${sampleName}_picard.stderr"
then
	echo "Successful $bam"
else
	printf "Error in Picard Tools: $bam"
    exit 1
fi

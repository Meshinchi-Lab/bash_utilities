#!/bin/bash
#SBATCH --array=1-50
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=32G
#SBATCH --output=%A_%a_kallisto.out
#SBATCH --error=%A_%a_kallisto.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################

module load picard/2.6.0-Java-11
module load kallisto/0.45.0-foss-2018b
module load FastQC/0.11.9-Java-11

#set c=16, and --mem=33G or 50G when running on largenode
#exit script if any commands return an error
set -eou


#scratch directory
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3/"

#Kallisto Index file
indexLoc="$SCRATCH/gencode.v29_RepBase.v24.01.idx"
idxName="gencode.v29"

#Location of sample files
sampleDir="$SCRATCH/CBFGLIS"
cd $sampleDir

#location of files
files=$(ls -1 *.bam) #full file path needed from SR/ to the object name. no trailing slash /. Example: SR/BEAT_AML/RNAseq_Illumina_Data/starfusion/BA2000_45d7e245-365b-4ee3-bb6a-630445112c07_
file=$(echo "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
bamfile=$(basename $file)
sampleName=${bamfile%.bam}
echo $bamfile


#location of results
mkdir -p "picard"
mkdir -p "kallisto"
mkdir -p "QC"

#Fastq file names
r1="picard/${sampleName}_r1.fq.gz"
r2="picard/${sampleName}_r2.fq.gz"


#Convert BAM to fastq
#filenames with suffix .gz are automatically gzipped by Picard tools.
#Include all reads, whether pass filter (PF) or not. changing flag does not improve or take away from psuedoalignemnt performance.
# To execute picard run: java -jar $EBROOTPICARD/picard.jar
if java -Xmx30g -Xms2g -jar $EBROOTPICARD/picard.jar SamToFastq QUIET=true INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT I="$bamfile" F="$r1" F2="$r2" 2> "picard/${sampleName}_picard.out"
then
	#fastq
	fastqc -o QC -t 4 --noextract "$r1" "$r2" 2> "QC/${sampleName}_fastqc.out" &
	#Run Kallisto for transcript level abundance.
	kallisto quant -i $indexLoc -o "kallisto/${sampleName}" -t 4 -b 30 --fusion --rf-stranded "$r1" "$r2" 2> "kallisto/${sampleName}.kallisto.out"

else
	printf "Error in Picard Tools: $bam"
	exit 1
fi

wait

#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o kallisto.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load kallisto/0.43.1-foss-2016b

#set c=16, and --mem=33G or 50G when running on largenode
#exit script if any commands return an error
set -e 

#Kallisto Index file
indexLoc="$TARGET/Reference_Data/Hg19_Grch37/kallisto_index"
idxName="GRCh37.87.idx"


#Location of samples 
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2016Apr_BCCA_AAML0531_Illumina_data"
cd $sampleDir


#BAM file to be processed. 
bam=$1
sampleName=${bam%.bam}


#Run Kallisto for transcript level abundance.
kallisto quant -i "$indexLoc/$idxName" -o "$resTx/${sampleName}" -t 4 -b 30 --fusion --rf-stranded "$scratch/$r1" "$scratch/$r2" 2> "$resTx/${sampleName}.kallisto.out" 






#!/bin/bash


#Kallisto Index file
#indexLoc="$TARGET/Reference_Data/Hg19_Grch37/kallisto_index"
idxName="GRCh37.87.idx"

#scratch 
#find how to use S3 for scratch

#BAM file to be processed. 
bam=$1
sampleName=${bam%.bam}


#Fastq file names 
r1="${sampleName}_r1.fq.gz"
r2="${sampleName}_r2.fq.gz"


#Convert BAM to fastq
#filenames with suffix .gz are automatically gzipped by Picard tools. 
#Include all reads, whether pass filter (PF) or not. changing flag does not improve or take away from psuedoalignemnt performance. 
if java -jar ./picard.jar SamToFastq QUIET=true INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT I="$bam" F="$r1" F2="$r2" 2> "${sampleName}_picard.out"
then
	./kallisto quant -i "$idxName" -o "$sampleName" -b 30 --fusion --rf-stranded "$r1" "$r2" 2> "$sampleName.kallisto.out" 
else
	printf "Error in Picard Tools: $bam" 
	exit 1
fi


wait 





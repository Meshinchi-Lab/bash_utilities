#!/bin/bash


source .start_lmod 
ml picard/2.13.2-Java-1.8.0_92

#BAM file to be processed. 
sampleName=${SAMPLE_NAME}
bam="${SAMPLE_NAME}.bam"

#Fastq file names 
r1="${sampleName}_r1.fq.gz"
r2="${sampleName}_r2.fq.gz"
out="${sampleName}_picard.stderr"

#download bam
aws s3 cp --sse AES256 s3://fh-pi-meshininchi-s/SR/$bam /scratch/$bam    

#Convert BAM to fastq
#filenames with suffix .gz are automatically gzipped by Picard tools. 
#Include all reads, whether pass filter (PF) or not. changing flag does not improve or take away from psuedoalignemnt performance. 
java -jar ${EBROOTPICARD}/build/libs/picard.jar SamToFastq QUIET=true INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT I="/scratch/$bam" F="/scratch/$r1" F2="/scratch/$r2" #2> /scratch/$out 


#upload step 
aws s3 cp --sse AES256 "$r1" s3://fh-pi-meshinchi-s/SR/picard_fq/$r1
aws s3 cp --sse AES256 "$r2" s3://fh-pi-meshinchi-s/SR/picard_fq/$r2
#aws s3 cp --sse AES256 "$out" s3://fh-pi-meshinchi-s/SR/picard_fq/$out



#!/bin/bash

#Jenny Smith
#Utility script for creating a sample sheet from an AWS S3 bucket.
#INCLUDE is optional, but should be used in all instances for fastqs to filter for only R1 (read1) Fastqs.
#since the R2 column is created by using AWK on the filename of R1.

#exit script if any commands return an error
set -eoux pipefail

#Load Modules
ml awscli/1.16.122-foss-2016b-Python-3.6.6

#define variables
BUCKET=$1 #no trailing slash /
PREFIX=${2:-""} #prefix(s) for S3 bucket. can be a single, "SR" or compound "SR/Fastqs". No trailing slash
INCLUDE=${3:-"*"} #can be an  regex for a pattern

#Parse file names to create sample sheets
files=$(aws s3 ls --recursive $BUCKET/$PREFIX | tr -s ' ' | cut -f 4 -d " " | grep -E "$INCLUDE" )
echo "$files" | awk 'BEGIN{OFS="\t";print "Sample","BAM"}{f=$0; s=gensub(/.+-([MPR].+1R)_RBS.+/, "\\1","g", f); print s, $0}'

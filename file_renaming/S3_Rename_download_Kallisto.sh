#!/bin/bash
#Jenny Smith
#June 13, 2016
#Purpose: Copy results from Meshinchi bucket to present working directory.

#results are a text file with the the names of the files to be downloaded
#Example derived from `aws s3 ls --recursive s3://fh-pi-meshinchi-s/SR/kallisto_out/`

results=$1

#Bucket is the bucket
BUCKET="s3://fh-pi-meshinchi-s/"

for file in $(cat $results)
do  URI=$(echo $BUCKET$file)
      IFS="/" read -ra INFO <<< $URI
      name=$(echo ${INFO[5]}\_${INFO[6]})
      aws s3 cp $URI $PWD/$name
done

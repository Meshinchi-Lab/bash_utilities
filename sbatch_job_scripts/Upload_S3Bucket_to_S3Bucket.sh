#!/bin/bash
#SBATCH --array=1-7%3
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --output=%A_%a_S3_cp.out
#SBATCH --error=%A_%a_S3_cp.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
set -eou pipefail


#Load Modules
ml awscli/1.18.35-foss-2019b-Python-3.7.4

#Define S3 Bucket and Scratch Directory
# Bucket_Old="fh-pi-meshinchi-s"
BUCKET="s3://fh-pi-meshinchi-s-eco-public"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3/Sbatch_AWS_Reorg/"

#location of files
files=$1 # A text file of the filenames to upload. full S3 path for filenames to be uploaded.
prefix=${2:-""} #prefix for old S3 bucket. no trailing slash


#Select file for upload to S3 from the list of files
file=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)

echo $filename


#Determine the destination of the file
if [[ -z "$prefix" ]] #this is techinically looking for a string of zero length, which is the default for prefix
then
	DESTINATION="$BUCKET"
else
	DESTINATION="$BUCKET/$prefix"
fi

printf "The destination is:\t$DESTINATION\n"

#S3 copy command
#--sse AES256 #used for older awscli installations. encryption now default.
# Note - sleep 60 is added so as not to overload the S3 bucket with too many requests to upload
#in addition, the sbatch --array option uses % to indicate how many jobs to run in parellel at a time, also avoiding too many requests for upload.
aws s3 cp --recursive --only-show-errors --follow-symlinks "$file" $DESTINATION/$filename

printf "Upload of $file complete."

#!/bin/bash
#SBATCH --array=1-306%30
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --output=%A_%a_S3_upload.out
#SBATCH --error=%A_%a_S3_upload.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
set -eou pipefail


#Load Modules
ml awscli/1.18.35-foss-2019b-Python-3.7.4

#Define S3 Bucket and Scratch Directory
BUCKET="s3://fh-pi-meshinchi-s-eco-public"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3/Sbatch_AWS_Reorg/"


#location of files
files=$1 # A text file of the filenames to upload. full file  path for filenames to be uploaded.
prefix=${2:-""} #prefix for S3 bucket(not including SR). no trailing slash


#Select file for upload to S3 from the list of files
file=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)

echo $filename


#S3 copy command
#--sse AES256 #used for older awscli installations. encryption now default.
# Note - sleep 60 is added so as not to overload the S3 bucket with too many requests to upload
#in addition, the sbatch --array option uses % to indicate how many jobs to run in parellel at a time, also avoiding too many requests for upload.
if [[ -z "$prefix" ]]
then
	aws s3 cp --only-show-errors  "$file" $BUCKET/$filename
else
	aws s3 cp --only-show-errors  "$file" $BUCKET/$prefix/$filename
fi

echo "Upload Complete"

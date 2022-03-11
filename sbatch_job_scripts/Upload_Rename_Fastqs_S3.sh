#!/bin/bash
#SBATCH --array=1-114%30
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --output=%A_%a_S3_upload.out
#SBATCH --error=%A_%a_S3_upload.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
set -eou pipefail


#Load Modules
ml awscli/1.18.164-GCCcore-8.3.0-Python-3.7.4


#Define S3 Bucket and Scratch Directory
BUCKET="s3://fh-pi-meshinchi-s-eco-public"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3/Sbatch_AWS_Reorg/"


#location of files
files=$1 # A text file of the filenames to upload. full file  path for filenames to be uploaded.
newFilenames=$2 #A text file of the new names for the file when copied into the destination directory.
prefix=${3:-""} #prefix for destination S3 bucket, no trailing slash


#Select file for upload to S3 from the list of files
oldfile=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
newfilename=$(cat "$newFilenames" | sed -n "$SLURM_ARRAY_TASK_ID"p)

echo $oldfile
printf "Moving $oldfile to $BUCKET/$prefix/$newfilename\n"


#S3 copy command
if [[ -z "$prefix" ]]
then
	aws s3 cp --only-show-errors "$oldfile" $BUCKET/$newfilename
else
	aws s3 cp --only-show-errors "$oldfile" $BUCKET/$prefix/$newfilename
fi

echo "Upload Complete"

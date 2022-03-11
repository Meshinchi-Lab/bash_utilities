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
#https://sciwiki.fredhutch.org/compdemos/Economy-storage/
set -eou pipefail

#Define S3 Bucket and Scratch Directory

#location of files
files=$1 # A text file of the filenames to upload. full file  path for filenames to be uploaded.
prefix=${2:-""} #prefix for S3 bucket(not including SR). no trailing slash


#Select file for upload to S3 from the list of files
file=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)

echo $filename





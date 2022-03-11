#!/bin/bash
#SBATCH --array=1-5%30
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
SCRATCH="/fh/scratch/delete90/meshinchi_s"


#location of files
files=$1 # A text file of the filenames to upload. full file  path for filenames to be uploaded.
newFilenames=$2 #A text file of the new names for the file when copied into the destination directory.
prefix=${3:-""} #prefix for destination S3 bucket, no trailing slash


#Determine the destination of the file
if [[ -z "$prefix" ]] #this is techinically looking for a string of zero length, which is the default for prefix
then
	DESTINATION="$BUCKET"
else
	DESTINATION="$BUCKET/$prefix"
fi


#Select file for upload to S3 from the list of files
oldfile=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
newfilename=$(cat "$newFilenames" | sed -n "$SLURM_ARRAY_TASK_ID"p)

echo $oldfile
printf "Moving $oldfile to $DESTINATION/$newfilename\n"


#Make MD5 sum check before upload
re=".bam$|.fq.gz$|.fastq$|.fastq.gz$|.xlsx$"
if [[ $oldfile =~  $re ]]
then
	echo "Creating MD5sum checks"
	hashes="${newfilename%.*}_md5sum.txt"
	md5sum $oldfile > $hashes
	sed -Ei "s/^(.+\s\s).+$/\1$newfilename/" "$hashes"
fi


#S3 copy command
aws s3 cp --only-show-errors "$oldfile" $DESTINATION/$newfilename


#Upload the MD5sum hashes if they exist
if [[ -z "${hashes+x}" ]] #this is looking for a null value returned
then
	printf  "$newfilename Upload Complete.\n"
else
	aws s3 cp --only-show-errors --follow-symlinks "$hashes" $DESTINATION/$hashes
	printf "$newfilename Upload Complete and $hashes Upload Complete.\n"
fi

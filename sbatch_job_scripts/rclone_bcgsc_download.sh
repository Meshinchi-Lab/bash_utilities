#!/bin/bash
#SBATCH --array=1-2130%10
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --output=%A_%a_bcgsc.out
#SBATCH --error=%A_%a_bcgsc.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
#https://rclone.org/sftp/
set -eou pipefail


#location of files
server=$1 # the name of the remote server based on the `rclone config` values
path=${2:-""} # A base directory to list files from, example: DATA-428/downloads/
dest=${3:-"."} #the local output destination - absolute file path
pattern=${4:-"*"} #a regex or string, example: "ReadsPerGene.out.tab"

#List the directories to download
#rclone lsd $server:$path 

#Select file for upload to S3 from the list of files
#why are there duplicates?? the order changes for some reason over time??
if [[ ! -f "input.txt" ]]
then
    rclone lsf $server:$path -R --files-only | grep -E "$pattern" > $dest/input.txt 
fi

file=$(cat $dest/input.txt | sed -n "$SLURM_ARRAY_TASK_ID"p)
echo "The file is: " $file

#Copy the files to the destination 
rclone copy --progress $server:$path/$file $dest

echo "Copy to local complete"
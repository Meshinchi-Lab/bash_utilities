#!/bin/bash
#SBATCH --array=1-677%20
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --output=%A_%a_S3_download.out
#SBATCH --error=%A_%a_S3_download.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
set -eou pipefail

#Load Modules
ml awscli/2.1.37-GCCcore-10.2.0

#location of files
BUCKET="s3://fh-pi-meshinchi-s-eco-public"
files=$1 # a text file with the full filepaths needed from prefix/ to the object name. no trailing slash /. Example: SR/BEAT_AML/RNAseq_Illumina_Data/starfusion/BA2000_45d7e245-365b-4ee3-bb6a-630445112c07_
dest=${2:-"/fh/scratch/delete90/meshinchi_s/jlsmith3/"}
recursive=${3:-""} #if needed enter "recursive" to this positional argument



#Define Files
file=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)
echo $filename

#S3 copy command
#--sse AES256 #used for older awscli installations. encryption now default.
# Note - sleep 30 is added so as not to overload the S3 bucket with too many requests to download
#soo, now for some reason using --recursive flag will make any file into an empty directory??
if [[ -z "$recursive" ]]
then
  echo "not recursive"
  aws s3 cp --only-show-errors  $BUCKET/$file $dest/$filename
else
  echo "recusrive" $recursive
  aws s3 cp --only-show-errors --recursive $BUCKET/$file $dest/$filename #--recursive
fi

echo "completed download of $filename to $dest/$filename"

# if [[ -z "$pre" ]]
# then
# 	aws s3 cp --only-show-errors  $BUCKET/$filename $dest/$filename #--recursive
# else
# 	aws s3 cp --only-show-errors  $BUCKET/$prefix/$filename $dest/$filename #--recursive
# fi
#
# sleep 60

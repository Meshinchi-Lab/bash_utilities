#!/bin/bash
#SBATCH --array=1-1533%5
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --output=%A_%a_mv_bams.out
#SBATCH --error=%A_%a_mv_bams.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################


#exit script if any commands return an error
#DONT FORGET TO CHANGE THE ARRAY NUMBER BEFORE SUBMITTING SCRIPT!!!!!!!!
set -eou pipefail

#Define File Directories
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
DESTINATION="$SCRATCH/Sbatch_AWS_Reorg/2017July_BCCA_0531_1031_Ribodepletion_Illumina_data"


#location of files
files=$1 # A text file of the filenames to upload. full S3 path for filenames to be uploaded.


#Select file for upload to S3 from the list of files
cd $SCRATCH #for MD5sums
file=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)

echo $filename


#Determine the destination of the file
printf "The destination is:\t$DESTINATION\n"

#mv/copy command
mv --no-clobber --verbose "$file" $DESTINATION/$filename

printf "Moving of $file complete."

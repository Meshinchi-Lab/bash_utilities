#!/bin/bash
#SBATCH --array=1-2098
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -t 0-1
#SBATCH --mem=8G
#SBATCH --output=%A_%a_md5_checks.out
#SBATCH --error=%A_%a_md5_checks.err
#SBATCH --mail-type=END
#SBATCH --mail-user=jlsmith3@fredhutch.org
################################

#set script to exit 1 if any of the following are not met.
set -euo pipefail

#Define File Locations
SCRATCH="/fh/scratch/delete90/meshinchi_s"
DATA="$SCRATCH/jlsmith3/Meshinchi_GEO_DNAme"

#file pattern
# pattern="[0-9]*_M_*R2*fastq.gz"
# pattern="*[12].fq.gz"
pattern="*.gz$|*.csv$"

#Create list of all files
files=$(ls -1 $DATA | grep -E $pattern)

#select one file per array job
file=$(echo "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
echo $file

#Create md5 sums for the file
if [ ! -f ${file}.md5 ]
then
    echo "creating MD5 sum checks"
    md5sum $file > ${file}.md5
else
    echo "${file}.md5 exists"
fi

echo "completed ${file}.md5"

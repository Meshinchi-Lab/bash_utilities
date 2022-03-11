#!/bin/bash
#SBATCH --array=1-96
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --output=%A_%a_merge_fq.out
#SBATCH --error=%A_%a_merged_fq.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#Jenny Smith
#1/28/20

set -eou pipefail


#define file locations
dir="/fh/fast/stirewalt_d/SR/ngs/illumina/dstirewa/epogosov"
data=("180313_D00300_0532_ACCCN5ANXX" "180319_D00300_0534_ACCCREANXX"  "180319_D00300_0535_BCCCRPANXX")
fastq_data="Unaligned/Project_epogosov"


#Output destination
dest="/fh/scratch/delete90/meshinchi_s/jlsmith3/SWOG/Hiseq"
cd $dest


#Define Samples
samplesA=$(ls -1 $dir/"${data[0]}"/$fastq_data/)
samplesB=$(ls -1 $dir/"${data[1]}"/$fastq_data/)
samplesC=$(ls -1 $dir/"${data[2]}"/$fastq_data/)
all_samples=$(echo $samplesA $samplesB $samplesC | tr " " "\n" | sort | uniq )

#Define single file for the JOB ARRAY
sample=$(echo "$all_samples" | sed -n "$SLURM_ARRAY_TASK_ID"p)


#concatenate all fastq files
echo "Starting:" $sample
for dataset in ${data[*]}
do
	gunzip -c $dir/"$dataset"/$fastq_data/$sample/*_R1_* >> ${sample}_R1_merged.fastq
	gunzip -c $dir/"$dataset"/$fastq_data/$sample/*_R2_* >> ${sample}_R2_merged.fastq
done
echo "Finished Concatenation"

#gzip the merged fastq
gzip  ${sample}_R1_merged.fastq
gzip  ${sample}_R2_merged.fastq
echo "Done gzip:" $sample

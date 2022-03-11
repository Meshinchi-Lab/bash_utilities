#!/bin/bash
#SBATCH --array=1-1422
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH -o fusion_rscript.%A_%a.out
#SBATCH -e fusion_rscript.%A_%a.err
#SBATCH -t 0-1
#SBATCH --mem=40G
#########################

#Do I not need this any more?
#source /app/Lmod/lmod/lmod/init/bash


#exit script if conditions are not met 
set -eou

#load modules
ml fhR/4.0.2-foss-2019b 

#Set up directories
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
dir="$SCRATCH/Fusion_Breakpoints"
SCRIPT="/home/jlsmith3/scripts/RNAseq_Analysis/Analysis/Fusions_Analysis/sbatch_fusion_breakpoints.r"


#Define Samples
samples=$1
SAMPLE_ID=$(echo "$samples" | sed -n "$SLURM_ARRAY_TASK_ID"p)
export SAMPLE_ID
echo $SAMPLE_ID

#Run the script 
Rscript $SCRIPT

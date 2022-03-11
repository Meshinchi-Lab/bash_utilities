#!/bin/bash
#SBATCH --array=1-9
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH -o HOMER.%j.out
#SBATCH -e HOMER.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
################################


set -eou pipefail
module purge

#Load modules
ml Homer/4.11-Perl-5.30.0

#Set up directories
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
outdir="$TARGET/RNA/mRNAseq/analysis/2017.02.15_CBF-GLIS_DEG/2021.07.21_CutnTag/HOMER"

#Positional arguments
infiles=$1

#Define input files
peakfile=$(cat "$infiles" | sed -n "$SLURM_ARRAY_TASK_ID"p)
dir=$(basename $peakfile | sed -E 's/.bed//')

echo $dir

#Run HOMER motif analysis
findMotifsGenome.pl $peakfile hg19 $outdir/$dir -size 200 -mask -preparsedDir "$SCRATCH/cutntag/Js_HsEc/HOMER_Preparsed"

#Run HOMER peak annotation
annotatePeaks.pl $peakfile hg19   > $outdir/$dir/${dir}_peaks_annotated.txt

echo "Complete"

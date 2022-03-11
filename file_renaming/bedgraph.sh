#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o bed_intersect.%j.out
#SBATCH -e bed_intersect.%j.std.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


#Ensure All BAM files are sorted before using this script.
ml bedtools/2.21.0

findpath () {
	find $1 -type f -regex "^.+bam$" #coverage files end with .normalized
}


TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"

dir="$SCRATCH/ChipSeq/Demande_TM_181211/MO7e"
outdir="$SCRATCH/ChipSeq"

cd $dir
chromInfo="$TARGET/DNA/Cut_and_Run/metadata/scripts/hg19.chrom.sizes"

BAMs=$( findpath $dir )

echo $BAMs

# for sorted_bam in $(echo $BAMs)
# do
# 	name=${sorted_bam/\.bam/\.bedGraph}
# 	genomeCoverageBed -bg -ibam $sorted_bam -g $chromInfo > "$outdir/$name"
# done

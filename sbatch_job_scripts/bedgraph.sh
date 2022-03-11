#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o bedgraph.%j.out
#SBATCH -e bedgraph.%j.stderr
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

TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"

dir="$SCRATCH/SMRTseq/5_demux"
outdir="$SCRATCH/SMRTseq/5_demux"

cd $dir
# chromInfo="$TARGET/DNA/Cut_and_Run/metadata/scripts/hg19.chrom.sizes"
chromInfo="$TARGET/Reference_Data/GRCh38/fasta/genome/hg38.chrom.sizes"

BAMs=$( findpath $dir )

for sorted_bam in $(echo "$BAMs")
do
	name=${sorted_bam/\.bam/\.bedGraph}
	genomeCoverageBed -bg -ibam $sorted_bam -g $chromInfo > "$name" &
done

wait 

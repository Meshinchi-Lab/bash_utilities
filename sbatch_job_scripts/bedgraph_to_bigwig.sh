#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o bigwig.%j.out
#SBATCH -e bigwig.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


#set script to exit 1 if any of the following are not met.
set -euo pipefail


#From Mike Meers
#bedtools intersect –v –a [experimental peak bed file] -b [IgG peak bed file] > [IgG-excluded experimental bed file]
export PATH=/home/jlsmith3/scripts/opt/bin:$PATH
ml bedtools/2.21.0

#function to create list of the bedgraph files in the directory.
findpath () {
	find $1 -type f -regex "^.+bedGraph$" #coverage files end with .normalized
}

#Define File locations and reference data
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
chromInfo="$TARGET/Reference_Data/GRCh38/fasta/genome/Gencode_GRCh38.chrom.sizes"
# chromInfo="$TARGET/AML_TARGET/DNA/Cut_and_Run/metadata/scripts/hg19.chrom.sizes"

dir=$1
outdir=$2
cd $dir

#list all the bedgraphs to be converted
bdgs=$( findpath $dir )

#loop through each bedgraph, sort and convert to bigwig.
for file in $(echo "$bdgs" )
do
	name=$(echo $file | sed -E 's/.bedGraph/.srt.bedGraph/')

	if [[ $outdir != "" ]]
	then
		name="$outdir/$( basename $name)"
	fi

	LC_COLLATE=C sort -k1,1 -k2,2n $file > "$name"
	bedGraphToBigWig "$name" $chromInfo "${name/.srt.bedGraph/.bw}" &

done

wait

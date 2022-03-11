#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o bigwig.%j.out
#SBATCH -e bigwig.%j.std.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#From Mike Meers
#bedtools intersect –v –a [experimental peak bed file] -b [IgG peak bed file] > [IgG-excluded experimental bed file]
export PATH=/home/jlsmith3/scripts/downloaded_software:$PATH
ml bedtools/2.21.0

TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"

dir="$TARGET/DNA/Cut_and_Run/level3/peak_calls/2018June_J.Sarthy_Illumina_data/bedgraph"
outdir="$SCRATCH/CutnRun"
chromInfo="$TARGET/DNA/Cut_and_Run/metadata/scripts/hg19.chrom.sizes"

cd $dir


for file in $(ls -1 *bedGraph)
do
	name=$(echo $file | sed -E 's/.bedGraph/.srt.bedGraph/')
	sort -k1,1 -k2,2n $file > "$outdir/$name"
	bedGraphToBigWig "$outdir/$name" $chromInfo "$outdir/${name}.bw"
done

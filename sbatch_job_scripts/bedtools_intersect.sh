#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o bed_intersect.%j.out
#SBATCH -e bed_intersect.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#From Mike Meers
#bedtools intersect –v –a [experimental peak bed file] -b [IgG peak bed file] > [IgG-excluded experimental bed file]

ml bedtools/2.21.0

TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"

dir="$TARGET/DNA/Cut_and_Run/level3/peak_calls/2018June_J.Sarthy_Illumina_data/macs_peaks"
outdir="$SCRATCH/CutnRun"

cd $dir
echo $PWD

#For M07e
for file in $(ls *.M*[narrow,broad]Peak)
do
	name=$(echo $file | sed -E 's/_peaks/_IgGremoved/')
	bedtools intersect -v -a $file -b macs2Peaks.IgG.M_peaks.narrowPeak >  "$outdir/$name"
	# echo $name
done


#for K562
for file in $(ls *.K*[narrow,broad]Peak)
do
	name=$(echo $file | sed -E 's/_peaks/_IgGremoved/')
	bedtools intersect -v -a $file -b macs2Peaks.IgG.M_peaks.narrowPeak >  "$outdir/$name"
	# echo $name
done

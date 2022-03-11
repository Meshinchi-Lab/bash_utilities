#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -e kallisto.%j.stderr
#SBATCH -o kallisto.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#kallisto is installed in my home directory under scripts/opt/bin
PATH=~/scripts/opt/bin:$PATH

fasta="/fh/fast/meshinchi_s/workingDir/TARGET/Reference_Data/Hg19_Grch37/fasta/cdna/Homo_sapiens.GRCh37.cdna.all.fa.gz"

indexLoc="/fh/fast/meshinchi_s/workingDir/TARGET/Reference_Data/Hg19_Grch37/kallisto_index"
idxName="GRCh37.87.idx"

kallisto index -i "$indexLoc/$idxName" $fasta







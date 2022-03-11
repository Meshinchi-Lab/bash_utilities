#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o multiQC.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load python2/2.7.9 
PATH=~/.local/bin:$PATH



#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of fastq
qc="$DELETE30/meshinchi_s/2017July_BCCA_JSmith_Illumina_QC"

#location of counts
resGene="$TARGET/AML_TARGET/RNA/mRNAseq/level3/gene/2017July_BCCA_Illumina_data"
resExon="$TARGET/AML_TARGET/RNA/mRNAseq/level3/exon/2017July_BCCA_Illumina_data"
resTx="$TARGET/AML_TARGET/RNA/mRNAseq/level3/transcript/2017July_BCCA_Illumina_data"


#output location
output="$TARGET/AML_TARGET/RNA/mRNAseq/metadata"


#Run MultiQC 
multiqc -n resGene -m featureCounts -o "$output" $resGene &
multiqc -n resExon -m featureCounts -o "$output" $resExon &
multiqc -n resTx -m kallisto -o "$output" $resTx &
multiqc -n fastqc -m fastqc -o "$output" $qc &


wait 

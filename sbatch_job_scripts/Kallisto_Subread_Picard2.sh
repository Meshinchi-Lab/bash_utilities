#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -o kallisto_subread.%j.out
#SBATCH -t 0-1
#SBATCH --mem=50G
#SBATCH --mail-type=FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load picard/2.7.1-Java-1.8.0_92 
module load kallisto/0.43.1-foss-2016b
module load FastQC/0.11.5-Java-1.8.0_92
PATH=~/scripts/opt/bin:$PATH


#exit script if any commands return an error
set -e 

#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#scratch directory
scratch="$DELETE30/meshinchi_s/2017July_BCCA_JSmith_Illumina_data"
qc="$DELETE30/meshinchi_s/2017July_BCCA_JSmith_Illumina_QC"


#location of GTF file and Kallisto Index file
gtf="$TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87.gtf"
exonGTF="$TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87_collapsed.gtf"

indexLoc="$TARGET/Reference_Data/Hg19_Grch37/kallisto_index"
idxName="GRCh37.87.idx"


#Location of samples 
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_AAML1031_Illumina_data"
cd $sampleDir


#location of results 
resGene="$TARGET/AML_TARGET/RNA/mRNAseq/level3/gene/2017July_BCCA_Illumina_data"
resExon="$TARGET/AML_TARGET/RNA/mRNAseq/level3/exon/2017July_BCCA_Illumina_data"
resTx="$TARGET/AML_TARGET/RNA/mRNAseq/level3/transcript/2017July_BCCA_Illumina_data"

#BAM file to be processed. 
bam=$1
sampleName=${bam%.bam}
 

#Fastq file names 
r1="${sampleName}_r1.fq.gz"
r2="${sampleName}_r2.fq.gz"


#Count meta-features (genes)
#protocol uses dUTP methods for second strand cDNA synthesis. The second read dictates the strand.
#BAM files were already prepped with PICARD tools markDuplicates.  
featureCounts -p -B -s 2 -T 16 -Q 10 -a $gtf -t exon -g gene_id -o "$resGene/${sampleName}_stranded.gene.cts" "$bam" 2> "$resGene/${sampleName}.fcounts.out" &

#Count exons 
featureCounts -p -B -s 2 -T 16 -Q 10 -f -O -F GTF -a $exonGTF -t exon -g gene_id -o "$resExon/${sampleName}_stranded.exon.cts" "$bam" 2> "$resExon/${sampleName}.fcounts.out" &


#Convert BAM to fastq
#filenames with suffix .gz are automatically gzipped by Picard tools. 
#Include all reads, whether pass filter (PF) or not. changing flag does not improve or take away from psuedoalignemnt performance. 
if java -jar ${EBROOTPICARD}/build/libs/picard.jar SamToFastq QUIET=true INCLUDE_NON_PF_READS=true VALIDATION_STRINGENCY=SILENT I="$bam" F="$scratch/$r1" F2="$scratch/$r2" 2> "$scratch/${sampleName}_picard.out"
then
	#fastq
	fastqc -o $qc -t 16 --noextract "$scratch/$r1" "$scratch/$r2" 2> "$scratch/${sampleName}_fastqc.out" &  
	#Run Kallisto for transcript level abundance.
	kallisto quant -i "$indexLoc/$idxName" -o "$resTx/${sampleName}" -t 16 -b 30 --fusion --rf-stranded "$scratch/$r1" "$scratch/$r2" 2> "$resTx/${sampleName}.kallisto.out" 
	#pizzly 
else
	printf "Error in Picard Tools: ${bam}" 
	exit 1
fi


wait 





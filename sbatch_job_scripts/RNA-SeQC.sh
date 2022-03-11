#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o RNA-SeQC.%j.out
#SBATCH -t 0-1
#SBATCH --mem=8G
#SBATCH --mail-type=FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load Java/1.8.0_121 
module load BWA/0.7.15-foss-2016b
#PATH=~/scripts/opt/bin:$PATH


#exit script if any commands return an error
set -e 

#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#Location of reference files 
gtf="$TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87_RNASeQC.gtf"
gc="$TARGET/Reference_Data/Hg19_Grch37/gc_content/gencode.v7.gc.txt"
rRNA="$TARGET/Reference_Data/Hg19_Grch37/rRNA/human_all_rRNA.fasta"
genome="$TARGET/Reference_Data/Hg19_Grch37/Grch37-lite/GRCh37-lite.fa"


#BAM file to be processed. 
bam=$1
sampleName=${bam%.bam}


#Location of samples 
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2016Apr_BCCA_AAML0531_Illumina_data"
cd $sampleDir


#Location of results 
outdir="$TARGET/AML_TARGET/RNA/mRNAseq/metadata/RNA-SeQC"


#notes for -s option (?)
notes="polyA"


#Run RNA-SeQC from broad Institute
java -jar ~/scripts/RNA-SeQC_v1.1.8.jar -t $gtf -BWArRNA $rRNA -strat gc -gc $gc -r $genome  -s "$sampleName|$bam|$notes" -o $outdir 

#later use -corr which inputs a gct expression file (like gsea) and must be log transformed and ids match GTF
#-gld --transcriptDetails for more plots/info

#Pre-run Checklist
	#GTF file from ensembl must remove "gene" as a feature type, since all entries need transcript_id fields in their attributes (https://www.biostars.org/p/140034/). gene features do not. 
	#Are the contig names consistent between your BAM, Reference, and the GTF file?
	#Is your BAM indexed? (use samtools index)
	#Is your reference Indexed? (use samtools faidx)
	#Does your reference have a dict (dictionary) file? (use CreateSequenceDictionary.jar)

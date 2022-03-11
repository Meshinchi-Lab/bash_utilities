#!/bin/bash
#
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 0-1
#SBATCH --mem=33G
#SBATCH -e htseq.%j.stderr
#SBATCH -o  htseq.%j.out
#SBATCH --mail-type=END 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


module load python2/2.7.8
module load SAMtools/1.4.1-foss-2016b

path="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2016Apr_BCCA_HighDepth_NBM_Illumina_data"
cd $path

resultDirectory="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2016Apr_BCCA_HighDepth_NBM_Illumina_data/htseq"


bam=$1
sampleName=${bam%.bam} 
prefix=$(echo $bam | sed -E 's/^.+\-([A-Z0-9]{6})\-.+/\1/' ) 

echo $bam
echo $sampleName
echo $prefix

#gtfFile=/shared/biodata/ngs/Reference/iGenomes/Homo_sapiens/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf
gtffile="/fh/fast/meshinchi_s/workingDir/TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87.gtf"

samtools sort -n -@ 16 -O BAM -o ${sampleName}.qsrt.bam -T $prefix $bam

#samtools view -h ${bam} | htseq-count -r pos -s yes -i gene_id - ${gtfFile} > ${resultDirectory}/${sampleName}.HTSeqCts.txt
samtools view -h ${sampleName}.qsrt.bam | htseq-count -r name -s yes -i gene_id - ${gtffile} > ${resultDirectory}/${sampleName}.HTSeqCts
#takes almost 2 hours to run! 



#HTSeq-count options: -s for stranded. yes they are stranded. Should I use reverse strand interpretation?
#option -r for order. use sorted bams by position. 
#option -i for attribute. use gene_id for ENSG# identifiers 
#option -t featuretpye. the default is exon. Why use exon rather than gene for -t featuretype?  
#option -m mode. how to handle overlapping reads. default union. should investigate.


#It appears that you cannot sort and pipe into view. 
#samtools sort -@ 4 $bam | samtools view -h - | htseq-count -r pos -s yes -i gene_id - ${gtfFile} > ${resultDirectory}/${sampleName}.HTSeqCts.txt
#samtools sort -@ 4 -o ${bam%.bam}.srt.bam -O BAM -T $prefix "$path/$bam"

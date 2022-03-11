#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o subread.%j.out
#SBATCH -t 0-1
#SBATCH --mem=30G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
#source /app/Lmod/lmod/lmod/init/bash
################################

#Need to test why there appears to be a difference in my envio,
#where all BAMs run fine, versus sbatch where it fails due to "core dump" C++ error.
PATH=~/scripts/opt/bin:$PATH


#main directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of GTF files
gtf="$TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87.gtf"
exonGTF="$TARGET/Reference_Data/Hg19_Grch37/gtf/Homo_sapiens.GRCh37.87_collapsed.gtf"


#Location of samples
sampleDir="$TARGET/AML_TARGET/RNA/mRNAseq/level1/bam/2017July_BCCA_1031_Illumina_data"
cd $sampleDir


#location of results
resGene="$TARGET/AML_TARGET/RNA/mRNAseq/level3/gene/2017July_BCCA_1031_JSmith_Illumina_data"
resExon="$TARGET/AML_TARGET/RNA/mRNAseq/level3/exon/2017July_BCCA_1031_JSmith_Illumina_data"


#BAM file to be processed.
bam=$1
sampleName=${bam%.bam}


#Count meta-features (genes)
#protocol uses dUTP methods for second strand cDNA synthesis. The second read dictates the strand.
#BAM files were already prepped with PICARD tools markDuplicates.
featureCounts -p -B -s 2 -T 4 -Q 10 -a $gtf -t exon -g gene_id -o "$resGene/${sampleName}_stranded.gene.cts" "$bam" 2> "$resGene/${sampleName}.fcounts.out" #&

#Count exons
featureCounts -p -B -s 2 -T 4 -Q 10 -f -O -F GTF -a $exonGTF -t exon -g gene_id -o "$resExon/${sampleName}_stranded.exon.cts" "$bam" 2> "$resExon/${sampleName}.fcounts.out" #&



#wait

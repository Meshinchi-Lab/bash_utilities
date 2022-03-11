#!/bin/bash
#SBATCH --partition=largenode
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH -J FusInsp.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

set -e
set -x


#Modules to load
export PATH=~/scripts/downloaded_software/FusionInspector:~/scripts/opt/bin:$PATH
export TRINITY_HOME=~/scripts/downloaded_software/trinityrnaseq-Trinity-v2.5.1
ml HTSlib/1.8-foss-2016b
ml Perl/5.24.1-foss-2016b
ml awscli/1.14.2-foss-2016b-Python-2.7.12
ml SAMtools/1.8-foss-2016b


#TARGET AML Directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"

#Scratch directory
scratch="$DELETE30/meshinchi_s"
cd $scratch

#Amazon S3 bucket
bucket="s3://fh-pi-meshinchi-s/SR/picard_fq2"

#Location of Fusion file list
fusions="$TARGET/AML_TARGET/RNA/mRNAseq/analysis/2018.02.05_cat_TransAbyss_data/Reformatted_/CBFGLIS_FInspector_Input.txt"


#Location of Genome Libraries
genome="$TARGET/Reference_Data/GRCh37/Broad_CTAT_FusionInspector/GRCh37_gencode_v19_CTAT_lib_Nov012017/ctat_genome_lib_build_dir"


#Fastq files on S3
fq1="$1"
fq2="$2"
sample="${fq1/_*/}"
# echo $sample

#Copy Fastqs to current working directory
aws s3 cp "$bucket/$fq1" .
aws s3 cp "$bucket/$fq2" .


#Run Fusion inspector
FusionInspector --fusions $fusions \
 --genome_lib $genome  \
 --left_fq $fq1 \
 --right_fq $fq2 \
 --out_dir "$scratch/${sample}_fInspector" \
 --out_prefix $sample \
 --prep_for_IGV 2> $scratch/${sample}_FusInsp.stderr

#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o S3_Upload.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

# module load awscli/1.11.158-foss-2016b-Python-2.7.12
ml awscli/1.14.2-foss-2016b-Python-2.7.12


#exit script if any commands return an error
set -ex

#location of files
path="/fh/fast/meshinchi_s/workingDir/SRA/sra/TCS"
cd $path

#file to be processed.
file=$1

#Sample ID from SRA
SRR=${file%.bam}

#mapping file
idmap="/fh/fast/meshinchi_s/workingDir/SRA/associated_files/TARGET_AML_SRA_RunTable_TCS.txt"

#Find Target Barcode
id=$(cat "$idmap" | grep -E "$SRR"  | cut -f 25 -d "	")
name=${id}_${SRR}_TCS.bam
echo $name

#prefix
prefix="DNA/TCS"

#copy command
#--sse AES256 #used for older awscli installations. encryption now default.
aws s3 cp  $file s3://fh-pi-meshinchi-s/SR/$prefix/$name

#!/bin/bash
#SBATCH --array=1-1
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH -o HLA.%j.out
#SBATCH -e HLA.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

# export PATH=~/scripts/downloaded_software/seq2HLA:$PATH
#doesnt work.
#needs both bash at first to set up env, then to switch to python env
# so cant just add #!/usr/bin/python to the top of the script...

#NOTE: if using fastqs downloaded from SRA, the ID convention causes an error.
#Must convert the ID the illuminaReadID/1 and illuminaReadID/2 notation.
#example: zcat TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_r1.fq.gz | sed -E 's|\.1 |/1 |' > TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_r1.fq

set -eou pipefail
module purge

#Set up directories
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
outdir="$SCRATCH/Seq2HLA" #no outdir option?? grumble

#location of files
BUCKET="s3://fh-pi-meshinchi-s"
files=$1 #filenames from S3. tab delimeted for two columns, one for each fastq r1 and r2
PREFIX=${2:-""} #prefix for S3 bucket. no trailing slash
file_pairs=$(cat "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
echo $file_pairs


#download the fastq files
ml awscli/1.18.35-foss-2019b-Python-3.7.4
mkdir -p $SCRATCH/fastqs
r1=$(echo "$file_pairs" | sed -E "s/(^.+)\t.+$/\1/")
r2=$(echo "$file_pairs" | sed -E "s/^.+\t(.+$)/\1/")
samp=$(echo "$r1" | sed -E 's/_r[12].(fq.gz|fastq|fastq.gz)//')
printf "first fq: $r1\n second fq: $r2\n sample: $samp\n"
aws s3 cp  --only-show-errors  $BUCKET/$PREFIX/$r1 $SCRATCH/fastqs/$r1
aws s3 cp  --only-show-errors  $BUCKET/$PREFIX/$r2 $SCRATCH/fastqs/$r2


#Update environment (installations required in comments below)
module purge
ml  Bowtie/1.2.2-foss-2018b
ml R/3.6.2-foss-2019b
ml Python/2.7.15-foss-2018b
#import Bio # directory /home/jlsmith3/.local/lib/python2.7/site-packages/Bio
#pip install --user biopython==1.58
# PYTHONPATH="/home/jlsmith3/.local/lib/python2.7/site-packages/":"${PYTHONPATH}"
# export PYTHONPATH

#use /usr/bin/python (Python 2.7.6)
which python
python --version


#python program directory location
if [[ $2 =~ SRA ]]
then
	seq2HLA=~/scripts/downloaded_software/seq2HLA/seq2HLA_keyerror.py
else
	seq2HLA=~/scripts/downloaded_software/seq2HLA/seq2HLA.py
fi
echo $seq2HLA

#Run the program
mkdir -p $outdir/$samp
cd $outdir/$samp
python2 $seq2HLA -1 "$SCRATCH/fastqs/$r1" -2 "$SCRATCH/fastqs/$r2" -r $samp


#Remove the fastqs
rm $SCRATCH/fastqs/$r1 $SCRATCH/fastqs/$r2

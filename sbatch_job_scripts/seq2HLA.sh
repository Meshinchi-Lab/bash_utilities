#!/bin/bash
#SBATCH --array=1-2834
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 2
#SBATCH -o HLA.%j.out
#SBATCH -e HLA.%j.stderr
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL
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


#Load Modules
module purge
#ml bowtie/1.1.1
#ml R/3.5.0-foss-2016b-fh1
ml  Bowtie/1.2.2-foss-2018b
ml R/3.5.1-foss-2018b
ml Python/2.7.15-foss-2018b

#use /usr/bin/python (Python 2.7.6)
which python
python --version

#Set up directories
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET"
SCRATCH="/fh/scratch/delete90/meshinchi_s/jlsmith3"
dir="$SCRATCH/seq2HLA/fq"
outdir="$SCRATCH/seq2HLA" #no outdir option?? grumble

#change to working directory
mkdir -p $SCRATCH/fastqs

#location of files
BUCKET="s3://fh-pi-meshinchi-s"
files=$1 #full file path needed
pre=${2:-""} #prefix for S3 bucket
file=$(echo "$files" | sed -n "$SLURM_ARRAY_TASK_ID"p)
filename=$(basename $file)


#add gzipped file extension if necessary
if file $dir/$samp* | grep -E -q "gzip"
then
	r1=
	r2=${r2}.gz
fi

#python program directory location
if [[ $2 =~ SRA ]]
then
	seq2HLA="~/scripts/downloaded_software/seq2HLA/seq2HLA_keyerror.py"
else
	seq2HLA="~/scripts/downloaded_software/seq2HLA/seq2HLA.py"
fi


#Run the program
python $seq2HLA -1 $r1 -2 $r2 -r $samp

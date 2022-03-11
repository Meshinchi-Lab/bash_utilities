#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o Pizzly_Flat.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################


ml Python/3.6.4-foss-2016b-fh2

#results directory 
dir=$1

cd $dir 

#find the fusion file 
fusion=$(ls -1 *.json  | grep -E -v "unfiltered")

#sample name
samp=${fusion/.json/}

#python script 
python3 ~/scripts/opt/bin/flatten_json.py $fusion ${samp}.txt 







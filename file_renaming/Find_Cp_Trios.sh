#!/bin/bash
#SBATCH -o cp.%j.out

source /app/Lmod/lmod/lmod/init/bash
################################

#Jenny Smith
#Jan 4, 2017
#Purpose: Copy datafiles for T. Druley

#path should be the full path to the sequencing type of data (eg mRNAseq, miRNAseq, WGS)
path=$1
cd $path

#destination directory
dest="/fh/fast/meshinchi_s/workingDir/toShare"
#reference file and the patient USIs
ref1="/home/jlsmith3/reference_mapping-files/TARGET_AML_Dx_Rem_Relapse_trio_patient_list.csv"


#Select USIs
USIs=$(cat $ref1 | cut -f 2 -d "," | grep -v "USI" | uniq | sed -E 's/(.+)/\*\1\*/' )


#initialize a text file for output.
seqType=$(basename $path)
outfile=${seqType}_trios.txt


#Function to find the level2 and level3 paths
findpath () {
	find $1 -mindepth 3 -type d -path "*level3/*" -o -type d -path "*level2/*"
}

paths=$( findpath $path )

#datatypes to share. May need to change between datatypes to select what you want.
datatypes=$(ls $path/level{2,3} | grep -i -E "CNVs_somatic|SNVs|fusion_somatic" | sed '/^\s*$/d')


for dat in $(echo "$datatypes")
do
	#May need to customize (grep -v) which paths to ensure copying ones of need only
 	datpath=$(echo "$paths" | grep -E -i "$dat\/" | grep -v -E -i  "_IF_|missing")
	echo "$datpath"
	for dps in $(echo "$datpath")
	do
		# echo "$dps"
		for usi in $(echo "$USIs")
		do
			for f in $dps/$usi
			do
				finaldest="$dest/$seqType/$dat/$(basename $dps)"

				if [[ -e $f ]]
				then
					mkdir -p "$finaldest"
					cp  "$f" $finaldest
				fi

			done
		done
	done
done

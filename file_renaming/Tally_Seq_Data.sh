#!/bin/bash
#SBATCH -o tallySeq.%j.out

source /app/Lmod/lmod/lmod/init/bash
################################

#Jenny Smith
#August 18, 2017
#Purpose: Count the number of data files for each patient sample to determine which have not been sequenced.

#path should be the full path to the sequencing type of data (eg mRNAseq, miRNAseq, WGS)
path=$1
cd $path

#location for outfile
# loc="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/analysis/2017.08.18_RNAseq_TallyperPatient"
loc=$1

#reference file and the patient USIs
ref1="/home/jlsmith3/reference_mapping-files/TARGET_AML_CDEs_withFusionCols_11.16.2017.csv"
ref2="/home/jlsmith3/reference_mapping-files/TARGET_AML_AAML1031_merged_CDE_ONLY_TARGET.csv"
ref3="/home/jlsmith3/reference_mapping-files/Inventory_of_normal_bone_marrows.csv"

#Select USIs
USI1=$(cat $ref1 | cut -f 1 -d "," | grep -v "USI" )
USI2=$(cat $ref2 | cut -f 2 -d "," | grep -v "USI" )
USI3=$(cat $ref3 | cut -f 1 -d "," | grep -v "USI" )

USIs=$(printf "$USI1\n$USI2\n$USI3")
#USIs=$(printf "$USI1" )
#echo "$USIs"


#initialize a text file for output.
seqType=$(basename $path)
outfile=${seqType}.txt

##Define the datatypes in for the sequencing type (eg gene level expression, fusions, etc.)
datatypes=$(ls $path/level* | grep -E -v "$(basename $path)|.txt" | sed '/^\s*$/d')
#echo $datatypes

##Add column names to outfile based on datatypes (eg gene level expression, fusions, etc)
printf "USI\t$seqType\tRelapseSample\tRefractorySample\tTARGET21\t$(echo "$datatypes" | tr "\n" "\t")\n" > $outfile
echo "$USIs" >> $outfile

##Function to tally the datatypes for each patient.
pt_datatypes () {
	file=$1
	types=""
	for dat in $datatypes
	do
		if echo "$file" | grep -q "$dat"
		then
			types="$types 1"
		else
			types="$types 0"
		fi
	done

	echo $types | tr " " "\t"
}

##Function to determine if patient also has relapse(RL) or refractory/Induction Failure (IF) data
RL_IF_samples () {
	file=$1
	RLcode="\-04A\-|\-40A\-"
	IFcode="\-41A\-|\-42A\-"
	StudyCode="TARGET\-21\-"

	RL=$( if echo "$file" | grep -E -q "$RLcode"; then echo 1;else echo 0; fi)
	IF=$( if echo "$file" | grep -E -q "$IFcode"; then echo 1; else echo 0; fi)
	IFstudy=$( if echo "$file" | grep -q "$StudyCode"; then echo 1; else echo 0; fi)

	echo $RL $IF $IFstudy | tr " " "\t"
}



##Loop through the USIs and find all filetypes associated with it in the given path.
for USI in $USIs
do	#need glob at the end of the directories to skip searching these.
	files=$(find $path -type f -name "*$USI*" -not -path "$path/analysis*" -not -path "$path/BCCA_Data_Downloads*")
	N=$(echo "$files" | wc -w) #count the number of words, not lines. bc no match still has one empty line.
	#printf "$USI\n$N\n"


	if [[ $N -ge 1 ]] #if there were any files found at all - then yes, present.
	then
		dat=1
	else #else no
		dat=0
	fi

	patientdata=$( pt_datatypes "$files" )
	RL_IF_data=$( RL_IF_samples "$files" )
	#echo $RL_IF_data
	sed -i -E "s/($USI)/\1\t$dat\t$RL_IF_data\t$patientdata/" $outfile

done



#Save as CSV
cat "$outfile" | tr "	" "," > "$loc/TARGET_AML_0531_1031_${seqType}_DataAvailability.csv"

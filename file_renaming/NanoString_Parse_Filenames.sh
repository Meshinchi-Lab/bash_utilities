#!/bin/bash


#Jenny Smith

#May 3, 2017

#Purpose: Create a text file with the annotations for the RCC files from Nanostring. 

# Format
# 1.date
# 2.batch
# 3.id (reg,BM)
# 4. barcode
# 5.group/condition

 # printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt

cd ~/Nanostring_Analysis

mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_current_asof_june30_2016_FINAL.txt"
outfile="NanostringAnnotations_03May2017.txt" 

touch $outfile
printf "Data\tBatch\tID\tBarcode\tGroup_Condition\n" >> $outfile

 
for file in $(cat fileNames.txt)
do
	date=$( sed -E 's/^([0-9]{8})_.+/\1/' $file)
	batch=$( sed -E 's/\-([0-9]{2})_.+/\1/')
	reg=$(sed -E 's/_([0-9]{6})\-.+/\1/')
	BM=$(sed - E 's/_(BM[0-9]{4})_.+/\1/')
	echo $date $batch $reg $BM
	
	if grep -q "$reg" $mappingFile
	then
		# [[ "$file" =~ ^.+\.fq ]]
		# if [[ "$file" =~ DX ]] 
		# then 
		# group=$(sed -E 's/\-(DX)_/\1/' $file)
		# fi
		barcode=$(grep "$reg" $mappingFile | cut -f 5 -d '	' | tr -d '[:space:]')
		group=$(sed -E 's/^.+\-([[:alnum:]])_.+/\1/')
		echo $barcode $group
		# printf "$date\t$batch\t$reg\t$barcode\t$group" >> $outfile
		
	elif [[ -z "$BM" ]]
	then 
		barcode=$BM
		group="BM"
		echo $barcode $group
		# printf "$date\t$batch\t$reg\t$barcode\t$group" >> $outfile
	fi
done

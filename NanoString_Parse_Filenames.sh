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


# cd ~/Nanostring_Analysis

mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_current_asof_june30_2016_FINAL.txt"
outfile="NanostringAnnotations_04May2017.txt" 

touch $outfile
printf "Date\t\tFilename\tBatch\tID\tBarcode\tGroup_Condition\n" >> $outfile

 
for file in $(cat fileNames.txt)
do
	date=$( echo $file | sed -E 's/^([0-9]{8})_.+/\1/' )
	batch=$( echo $file | sed -E 's/^.+\-([0-9]{2})_.+/\1/')
	reg=$( echo $file | sed -E 's/^.+_([0-9]{6})\-.+/\1/' )
	# echo $date $batch $reg $BM
	
	if grep -q "$reg" $mappingFile
	then
		barcode=$(grep "$reg" $mappingFile | cut -f 5 -d '	' | tr -d '[:space:]')
		group=$(echo $file | sed -E 's/^.+-[0-9]{2}_[0-9]{6}-([A-Za-z0-9]+)[+_].+/\1/')
		# echo $barcode $group
		printf "$date\t$file\t$batch\t$reg\t$barcode\t$group\n" >> $outfile
	else 
		BM=$(echo $file | sed -E 's/^.+_(BM[0-9]{4})_.+/\1/')
		barcode=$BM
		group="BM"
		# echo $barcode $group
		printf "$date\t$file\t$batch\t$BM\t$barcode\t$group\n" >> $outfile
	fi
done

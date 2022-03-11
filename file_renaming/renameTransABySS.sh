#!/bin/bash


#Jenny Smith
#January 29, 2018
#purpose: rename all fusions from TransAbyss from BCCA.
# http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss

#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="~/scripts/bash/scripts"
scriptName="renameTransABySS.sh"

#initial directory. this is a positional argument - must type the filepath on the command line.
dir1="$1"


#directory with the reference mapping files.
mappingFile="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/analysis/2017.08.18_RNAseq_TallyperPatient/TARGET_AML_AAML1031_NGS_Data_Availability.csv"


#Destination directory for renamed files.
dir2="$2"

#move to original files directory
cd $dir1


#For loop to rename all files in the sub directories with the target barcode
for dir in $(ls -1d A*)
do
	lib="$dir"
	files=$(find $dir1/$dir -type f -name "*.tsv")

	for file in $(echo "$files" )
	do
		barcode=$(cat $mappingFile | grep -E "$lib" | cut -f 1 -d "," )
		fileName=$(basename $file)
		name=${barcode}_${lib}_${fileName}

		# Split the results by fusion or indel detection
		if echo $file | grep -q -E "indel"
		then
			finalDest="$dir2/indels/2017July_BCCA_1031_TransAbyss_Illumina_data"
		elif echo $file | grep -q -E "fusion"
		then
			finalDest="$dir2/fusion/2017July_BCCA_1031_TransAbyss_Illumina_data"
                fi
                    

		# create a README with input and output of files.
		if [ ! -e $finalDest/README.txt ]
		then
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $finalDest/README.txt
		fi

		#copy and rename the files
		if [ ! -e $finalDest/"$name" ] #copy the exression matrices "as is".
		then
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$finalDest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\n" >> $masterCopy
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$finalDest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\n" >> $finalDest/README.txt
			cp "$file" "$finalDest/$name"  #copy the summary files as is to the TARGET destination directory
		else
			duplicateLocation=$( grep "$name" $finalDest/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$finalDest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\t$duplicateLocation\n" >> $duplicates
		fi
    done
done


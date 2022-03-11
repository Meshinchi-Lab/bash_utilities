#!/bin/bash


#Jenny Smith
#January 24, 2017
#purpose: rename all expression files from RNAseq experiment with the target barcode.


#create documentation of the copied files with Desination for records. 
timeStamp=$(date)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/copiedFiles_destDirectories_MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"
scriptDir="${PWD}"
scriptName="$0"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#initial directory. this is a positional argument - must type the filepath on the command line. 
dir1="$1"
#/fh/fast/meshinchi_s/workingDir/originals/RNAseq_BCCA28Apr2016/gene_coverage_GSC-1367


#directory with the reference mapping files. 
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_SNP_Only_mapping_file.txt"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/RNAseq_BCCA28Apr2016_idMap_final.txt"

#Note: RNAseq_BCCA28Apr2016_idMap_final.txt was created by combining RNASeq_BCCA28Apr2016_idMap.txt and  TARGET_barcode_for_all_validation_expression_samples.txt
#using grep and uniq (a few samples are sequenced in two libraries).

#Destination directory for renamed files. 
dir2="$2"
#/fh/fast/meshinchi_s/workingDir/TARGET/RNA/mRNA

#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi


#move to original files directory
cd $dir1

#echo ${PWD}


#rename all mRNA-seq expression files. 
for file in $(ls -1 *.transcript.normalized)
do
	lib=$( echo $file | sed -E 's/([A][0-9]+).+/\1/') #pull out the registration number
	
	if grep "$lib" $mappingFile
	then
		id=$(grep "$lib" $mappingFile | cut -f 3 -d '	' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
		name=$(echo $file  |  sed -E "s/^[A].+\.(s.+)/$id-$lib-\1/") #new file name
		#echo $id $name
			
		if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
		then
			printf "$timeStamp\tmRNAseq_expression\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tmRNAseq_expression\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $dir2/README.txt
			cp "$file" $dir2/"$name"  #copy the file to the new file name and destination. 
		else
			printf "$timeStamp\tmRNAseq_expression\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $duplicates
		fi
	
	else
		printf "$timeStamp\tmRNAseq_expression\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\n" >> $dir2/notMatched_.txt
	
	fi
done














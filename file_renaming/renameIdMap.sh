#!/bin/bash

#Jenny Smith
#January 19, 2017
#Purpose: rename  idMap files produced by Complete Genomics (GCI) for the TARGET AML project. 


#create documentation of the copied files with Desination for records. 
timeStamp=$(date)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/copiedFiles_destDirectories_MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#directory with the idMap files. positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"


#destination directory to copy the files. Positional argument - must type the filepath on the command line. 
dir2="$2"


#change to the directory with the input files
cd  $dir1

#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi

#Iterate through all the idMap files with file extention .png  in the specified directory. 
for idMap in *.tsv
do
	gs=$( echo $idMap | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	usi=$( echo $idMap | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.{7}).+/\1/')
	#echo $gs $usi
	
	if grep "$gs" $mappingFile
	then 
		id=$(grep "$gs" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) into a variable.
		name=$( echo $idMap | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id-\1\2/") #regular expression to create new file name. 
		#echo $idMap	$gs	$id	$name 
		
		if [ ! -f $dir2/$name ] #only copy the file to the new location if it does not already exist
		then
			printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$gs\t$id\t$name\n" >> $dir2/README.txt
			cp "$idMap" $dir2/"$name"  #copy the file to the new file name and directory.
		else
			printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$gs\t$id\t$name\n" >> $duplicates
		fi
		
	else
	
		if grep "$usi" $mappingFile
		then
			id=$(grep "$usi" $mappingFile | cut -f 4 -d '	')
			newName=$(echo $idMap | sed -E "s/(^[a-zA-Z]+)[-_][A-Z]+_210.{7}(.+)/$id-\1\2/")
			
			if [ ! -f $dir2/$newName ]
			then
				printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$usi\t$id\t$newName\n" >> $masterCopy				
				printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$usi\t$id\t$newName\n" >> $dir2/README.txt
				cp "$idMap" $dir2/"$newName"  #copy the file to the new file name.
			else
				printf "$timeStamp\tidMap\t$dir\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$idMap\t$usi\t$id\t$newName\n" >> $duplicates
			fi
		fi
	fi

done











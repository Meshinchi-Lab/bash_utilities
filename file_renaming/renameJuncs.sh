#!/bin/bash

#Jenny Smith
#January 13, 2017
#Purpose: rename  junction files produced by Complete Genomics (GCI) for the TARGET AML project. 



#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#initial directory. this is a positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files. 
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_SNP_Only_mapping_file.txt"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"

#Destination directory for renamed files. 
dir2="$2"

#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi



#change to the directory with the input files
cd  $dir1


#Iterate through all the juncs files with file extention .png  in the specified directory. 
for juncs in *.tsv
do
	gs=$( echo $juncs | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	usi=$( echo $juncs | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.{10}).+/\1/')
	#echo $gs $usi
	
	if grep -q "$gs" $mappingFile
	then 
		id=$(grep "$gs" $mappingFile| cut -f 4 -d '	') #pull out the  targetID (feild 4) into a variable.
		name=$( echo $juncs | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id\_\1\2/") #regular expression to create new file name. 
		echo $gs $id	$name #$juncs
		
		if [ ! -f $dir2/$name ] #only copy the file to the new location if it does not already exist
		then
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$name\n" >> $dir2/README.txt
			cp "$juncs" $dir2/"$name"  #copy the file to the new file name and directory.
		else
			duplicateLocation=$(grep "$juncs" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	elif grep -q "$usi" $mappingFile
	then
		id=$(grep "$usi" $mappingFile| cut -f 4 -d '	')
		name=$(echo $juncs | sed -E "s/(^[a-zA-Z]+)[-_][A-Z]+_210.{10}(.+)/$id\_\1\2/")
		echo 	$usi $id	$name #$juncs
			
		if [ ! -f $dir2/$name ]
		then
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$usi\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$usi\t$id\t$name\n" >> $dir2/README.txt
			cp "$juncs" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$(grep "$juncs" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$usi\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	fi
done
	








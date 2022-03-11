#!/bin/bash

#Jenny Smith
#January 4, 2017
#Purpose: rename  circos plots produced by Complete Genomics (GCI) for the TARGET AML project. 
#Edited: Jan. 30, 2017 to include the additional information in README. 


#original code
#for circos in *.png; do gs=$( echo $circos | sed -E 's/somaticCircos-(GS[0-9]+.{10}).png/\1/');IFS=$'\n';for line in $(cat ~/reference_mapping-files/CGI_USI_file_mapping.txt | grep -v "USI"); do targetID=$(echo $line | cut -f 4,6 -d '       '); if [[ "$targetID" =~ "$gs" ]]; then id=$(echo $targetID | cut -f 1 -d '      '); name=$( echo $circos | sed -E "s/(somaticCircos)-GS[0-9]+.{10}(.png)/$id-\1\2/"); mv -- "$circos" "$name";fi;done;done


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#directory with the circos plots.
dir1="$1"

#directory with the reference mapping files
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"

#destination directory to copy the files
dir2="$2"

#change to the directory with the input files
cd  $dir1

#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi



#Iterate through all the circos plots with file extention .png  in the specified directory. 
for circos in *.png
do
	gs=$( echo $circos | sed -E 's/somaticCircos-(GS[0-9]+.{10}).png/\1/') #variable to pull out the gs# from the original file name. 
	usi=$( echo $circos | sed -E 's/somaticCircos-([A-Z]+_210.{10}).png/\1/')
	
	if grep -q "$gs" $mappingFile  
	then
		id=$(grep "$gs" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable.
		name=$( echo $circos | sed -E "s/(somaticCircos)-GS[0-9]+.{10}(.png)/$id-\1\2/") #regular expression to create new file name.
		echo $gs $id $name
	
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$circos" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	
	elif grep -q "$usi" $mappingFile  
	then
		id=$(grep "$usi" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable.
		name=$( echo $circos | sed -E "s/(somaticCircos)-[A-Z]+_210.{10}(.png)/$id-\1\2/") #regular expression to create new file name.
		echo $gs $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$circos" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	
	elif [[ "$circos" =~ ^.+NormalVs.+ ]]
	then
		id=$( echo $circos | sed -E 's/(somaticCircos)_([A-Z]+.{10}_[a-zA-Z]+)(\.png)/\2/')
		name=$( echo $circos | sed -E 's/(somaticCircos)_([A-Z]+.{10}_[a-zA-Z]+)(\.png)/\2-\1\3/')	
		echo $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$N/A\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$N/A\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$circos" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcircosPlot\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$circos\t$N/A\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
		
	fi
done










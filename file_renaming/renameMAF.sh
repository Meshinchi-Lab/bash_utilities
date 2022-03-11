#!/bin/bash

#Jenny Smith
#January 9, 2017
#Purpose: rename  maf files produced by Complete Genomics (GCI) for the TARGET AML project. 
#EDITED: January 15, 2013 to include an elif statement, and also copy all associated metadata to the new location without changing the name. 


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#directory with the maf files. positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/target_aml_cgi_germLineSummary_Target_Dec2014_mappingFile.txt"


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


#Iterate through all the maf files 
for maf in $(ls -1 *maf*) #change to tsv for geneVar summaries
do
	gs=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	usi=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.+1)_[a-z]+.+\.[a-z]+/\1/')
	#echo $gs $usi

	if grep -q "$gs" $mappingFile && [[ "$gs" =~ GS.+ ]]
	then 
		id=$(grep "$gs" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable. 
		name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id-\1\2/") #regular expression to create new file name.
		echo  $gs $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
		
	elif grep -q "$usi"  $mappingFile && [[ "$usi" =~ [A-Z]+_210.+ ]]
	then
		id=$(grep "$usi" $mappingFile | cut -f 4 -d '	')
		name=$(echo $maf |  sed -E "s/^([a-zA-Z]+)[-_][A-Z]+_210.+1(_[a-z]+.+\.[a-z]+)/$id-\1\2/")
		echo $usi $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\n" >> $dir2/README.txt
			cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	else
		printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$N/A\t$N/A\t$maf\n" >> $dir2/notMatched_MAFs.txt
	
	fi
done





#original code
#Iterate through all the maf files with file extention .png  in the specified directory. 
# for maf in *.tsv
# do
	# gs=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	# IFS=$'\n' #set field seperator to new line character
	# echo $gs $usi
	
	# for line in $(cat $mappingFile | grep -v "USI") #iterate through each line  of the mapping file. Grep -v is to remove the header
	# do
		# targetID=$(echo $line | cut -f 4,6 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable.
		# echo $targetID
		
		# if [[ "$targetID" =~ "$gs" ]] #if the targetID contains the same gs# 
		# then
			# echo insdie if statement 
			# id=$(echo $targetID | cut -f 1 -d '	') #pull out only the id (feild 1) from the targetID variable.
			# name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id-\1\2/") #regular expression to create new file name.
			# if [ ! -e $dir2/$name ]
			# then
				# echo this file exists $name 
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\t$duplicateLocation\n" >> $masterCopy				
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\t$duplicateLocation\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
				# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
			# else
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
			# fi
		# elif [[ "$targetID" =~ "$usi" ]]
		# then
			# id=$(echo $targetID | cut -f 1 -d '	')
			# name=$(echo $maf | sed -E "s/(^[a-zA-Z]+)[-_][A-Z]+_210.{10}(.+)/$id-\1\2/")
			# if [ ! -e $dir2/$name ]
			# then
				# echo this file exists $name
				# echo $maf	$usi	$id	$name 
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\t$duplicateLocation\n" >> $masterCopy				
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\t$duplicateLocation\n" >> $dir2/README.txt
				# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
			# else
				# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\t$duplicateLocation\n" >> $duplicates
			# fi
		# fi	
	# done
# done






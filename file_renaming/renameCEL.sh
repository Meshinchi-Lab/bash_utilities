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


#directory with the affy files. positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files. 
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_SNP_Only_mapping_file.txt"
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/MAGE-TAB_TARGET_AML_GEX_Affymetrix_20140203_FINAL.txt"
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/SNP_MappingFile_Affymetrix_noDups.txt"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/list_of_files_in_Partek_Dx_Rem_CEL_files_only.txt"

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


#Iterate through all the affy files with file extention .CEL  in the specified directory. 
for affy in *.CEL
do
	affyID=$( echo $affy | sed -E 's/([0-9]+.+)\.[A-Z]{3}/\1/') #variable to pull out the affyID# from the original file name. 
	#usi=$( echo $affy | sed -E 's/(^[A-Z]+.+)\.[A-Z]{3}/\1/')
	#echo $affyID $usi
	
	if grep "$affyID" $mappingFile > output
	then 
		#id=$(grep "$affyID" $mappingFile | cut -f 9 -d '	' | tr -d '[:space:]') #pull out the  targetID (feild 9) into a variable.
		#id=$(grep "$affyID" $mappingFile | cut -f 1 -d '	' | tr -d '[:space:]') #SNP_MappingFile_Affymetrix_noDups
		id=$(grep "$affyID" $mappingFile | cut -f 6 -d '	' | tr -d '[:space:]') #list_of_files_in_Partek_Dx_Rem_CEL_files_only
		name=$( echo $affy | sed -E "s/([0-9]+.+)(\.[A-Z]{3})/$id\_\1\2/") #regular expression to create new file name. 
		echo $affyID $id	$name 
		
		if [ ! -e $dir2/$name ] #only copy the file to the new location if it does not already exist.
		then
			printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\n" >> $dir2/README.txt
			cp "$affy" $dir2/"$name"  #copy the file to the new file name and directory.
		else
			duplicateLocation=$( grep "$affy" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
		
	else
		echo
		printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\n" >> $dir2/notMatched_Affy_CEL_files.txt
		
	fi
done



##########OLDER CODE BUT MIGHT USE WITH USI##############
# #Iterate through all the affy files with file extention .CEL  in the specified directory. 
# for affy in *.CEL
# do
	# affyID=$( echo $affy | sed -E 's/([0-9]+.+)\.[A-Z]{3}/\1/') #variable to pull out the affyID# from the original file name. 
	# usi=$( echo $affy | sed -E 's/(^[A-Z]+.+)\.[A-Z]{3}/\1/')
	# #echo $affyID $usi
	
	# if grep "$affyID" $mappingFile > output
	# then 
		# id=$(grep "$affyID" $mappingFile | cut -f 3 -d '	') #pull out the  targetID (feild 9) into a variable.
		# name=$( echo $affy | sed -E "s/([0-9]+.+)(\.[A-Z]{3})/$id-\1\2/") #regular expression to create new file name. 
		# echo $affy	$affyID	$id	$name 
		
		# if [ ! -e $dir2/$name ] #only copy the file to the new location if it does not already exist.
		# then
			# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\n" >> $masterCopy				
			# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\n" >> $dir2/README.txt
			# cp "$affy" $dir2/"$name"  #copy the file to the new file name and directory.
		# else
			# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$affyID\t$id\t$name\n" >> $duplicates
		# fi
		
	# else
	
		# if grep "$usi" $mappingFile
		# then
			# id=$(grep "$usi" $mappingFile | cut -f 9 -d '	')
			# newName=$(echo $affy | sed -E "s/(^[A-Z]+.+)(\.[A-Z]{3})/$id-\1\2/")
			
			# if [ ! -e $dir2/$newName ]
			# then
				# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$usi\t$id\t$newName\n" >> $masterCopy				
				# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$usi\t$id\t$newName\n" >> $dir2/README.txt
				# cp "$affy" $dir2/"$newName"  #copy the file to the new file name.
			# else
				# printf "$timeStamp\taffy\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$affy\t$usi\t$id\t$newName\n" >> $duplicates
			
			# fi
		# fi	
	# fi
# done







#!/bin/bash

#Jenny Smith
#January 16, 2016
#puprose: After copy/rename of files in TARGET directory, and possible duplicates are found in another directory. 


#directory that was already copyied/renamed
dir1="$1"

#directory that may have duplicates. 
dir2="$2"

#cd into the possible duplicates directory. 
cd $dir2

#use find command to create a list of all file names already copied/renamed previously.  
find $dir1 -type f -name "*.CEL" > $dir2/copied_fileNames.txt

#use find command to create a list of possible redundanct files. 
find $dir2 -type f -name "*.CEL" > $dir2/possible_dup_fileNames.txt



for line in $(cat possible_dup_fileNames.txt)
do
	#gs=$( echo $line | cut -f 2,3,4 -d "-") #cut with a dash delimiter to pull out GS#-ASM-T1-N1 identifiers
	#affyID=$( echo $line | cut -f 2 -d "/" | cut -f 1,2 -d "-")
	if grep "$affyID" copied_fileNames.txt
	then
		#echo "redundant"
		printf "$line\n" >> $dir2/duplicate_Files.txt
	else
		#echo "non-reducant"
		printf "$line\n" >> $dir2/not_yet_renamed_list.txt
 	fi
done



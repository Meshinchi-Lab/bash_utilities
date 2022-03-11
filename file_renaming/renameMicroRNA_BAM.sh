#!/bin/bash


#Jenny Smith
#January 18, 2017
#purpose: rename all bam files with the target barcode.


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
#mappingFile="N/A"

#Destination directory for renamed files. 
dir2="$2"


#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi


#move to original files directory
cd $dir1

#echo ${PWD}

#Must move the original files up one directory. There are too many subdirectories to go through each individually. 
# for dir in $(ls -1)
# do 
	# if [[ "$dir" =~ MX* ]] #only move the files in MX labeled directories
	# then 
		# echo $dir
		# find $dir -type f -exec mv -t $dir {} + #move all files directly into the MX labeled directory
	# fi
# done

#Create a list of directories to parse.
# for dir in $(ls -1)
# do 
	# echo $dir >> directories.txt
# done


#rename all files in the miRNA subdirectories
for dir in $(cat $dir1/directories.txt)
do
	if [[ "$dir" =~ BCCA* ]] #iterate through the BCCA_analysis directory
	then
		cd $dir1/$dir
		echo $dir
		
		for file in *.txt
		do
			name=$(echo $file | sed -E 's/([a-zA-Z]+.+)/BCCA_Analysis_\1/')
			echo $name
			
			if [ ! -e "$dir2/$name" ]
			then
				printf "$timeStamp\tBCCAanalysis\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$name\n" >> $masterCopy				
				printf "$timeStamp\tBCCAanalysis\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$name\n" >> $dir2/README.txt		
				cp "$file" $dir2/"$name"  #copy the summary files as is to the TARGET destination directory
			else
				printf "$timeStamp\tBCCAanalysis\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$name\n" >> $duplicates
			fi
		done
		
	elif [[ "$dir" =~ MX* ]] #iterate through the MX labeled directories
	then
		cd $dir1/$dir #cd into the MX labeled directory
		echo $dir 
		
		for file in $(ls -1)
		do
		
			if [[ "$file" =~ ^.+\.bam ]]
			then
				
				index=$( echo $file | sed -E 's/^MX.+_([A-Z]+)\..+/\1/') #pull out the sequence read index/barcode
				id=$(grep "$index" *library.summary | cut -f 9 -d ' ' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
				name=$(echo $file  |  sed -E "s/(^MX[0-9]+)_.+_([A-Z]+\..+)/$id\_\1_\2/") #new file name
				lib_index=$(echo $file  |  sed -E "s/(^MX[0-9]+)_.+_([A-Z]+)\..+/\1_\2/") #library and index of current file 
				mappingFile=$( echo $lib*.summary)
				echo $file $index $id $name
			
				if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
				then
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy				
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt
					cp "$file" $dir2/"$name"  #copy the file to the new file name and destination. 
				else
					duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\t$duplicateLocation\n" >> $duplicates
				fi
			
			
				# matchedAdapter=$( ls -1 $dir1/BCCA_analysis/graphs/adapter/*.jpg | grep "$lib_index" | sed -E 's/^.+(MX.+)/\1/') 
				# adapterName=$(echo $matchedAdapter | sed -E "s/(MX.+)/$id\_\1/")
				# echo $matchedAdapter $adapterName
				
				# # if [ ! -e "$dir2/$adapterName" ] #only copy files that do not already exist
				# # then
					# # printf "$timeStamp\tadapterJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$lib_index\t$id\t$adapterName\n" >> $masterCopy				
					# # printf "$timeStamp\tadapterJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$lib_index\t$id\t$adapterName\n" >> $dir2/README.txt
					# # cp $dir1/BCCA_analysis/graphs/adapter/$matchedAdapter $dir2/"$adapterName"   #copy the file to the new file name and destination. 
				# # else
					# # duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
					# # printf "$timeStamp\tadapterJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$lib_index\t$id\t$adapterName\t$duplicateLocation\n" >> $duplicates
				# # fi
			
				# matchedTags=$( ls -1 $dir1/BCCA_analysis/graphs/tags/*.jpg | grep "$lib_index" | sed -E 's/^.+(MX.+)/\1/') 
				# tagsName=$(echo $matchedTags | sed -E "s/(MX.+)/$id\_\1/")
				# echo $matchedTags $tagsName
				
				# # if [ ! -e "$dir2/$tagsName" ] #only copy files that do not already exist
				# # then
					# # printf "$timeStamp\ttagsJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedTags\t$lib_index\t$id\t$tagsName\n" >> $masterCopy				
					# # printf "$timeStamp\ttagsJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedTags\t$lib_index\t$id\t$tagsName\n" >> $dir2/README.txt
					# # cp $dir1/BCCA_analysis/graphs/adapter/$matchedTags $dir2/"$tagsName"   #copy the file to the new file name and destination. 
				# # else
					# # duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
					# # printf "$timeStamp\ttagsJpg\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedTags\t$lib_index\t$id\t$tagsName\t$duplicateLocation\n" >> $duplicates
				# # fi
			
			elif [[ "$file" =~ ^.+\.bai ]]
			then
				index=$( echo $file | sed -E 's/^MX.+_([A-Z]+)\..+/\1/') #pull out the sequence read index/barcode
				id=$(grep "$index" *library.summary | cut -f 9 -d ' ' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
				name=$(echo $file  |  sed -E "s/(^MX[0-9]+)_.+_([A-Z]+\..+)/$id\_\1_\2/") #new file name
				lib_index=$(echo $file  |  sed -E "s/(^MX[0-9]+)_.+_([A-Z]+)\..+/\1_\2/") #library and index of current file 
				mappingFile=$( echo $lib*.summary)
				echo $file $index $id $name
				
				if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
				then
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy				
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt
					cp "$file" $dir2/"$name"  #copy the file to the new file name and destination. 
				else
					duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
					printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\t$duplicateLocation\n" >> $duplicates
				fi
			
				
			elif [[ "$file" =~ ^.+\.summary ]] 
			then
				#echo $file
				printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $masterCopy				
				printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $dir2/README.txt		
				cp "$file" $dir2/"$file"  #copy the summary files as is to the TARGET destination directory
			else
				duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
				printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\t$duplicateLocation\n" >> $duplicates
			fi
		done

	fi
done














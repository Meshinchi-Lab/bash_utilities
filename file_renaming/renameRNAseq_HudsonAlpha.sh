#!/bin/bash


#Jenny Smith
#January 23, 2017
#purpose: rename all fastq and bam files from RNAseq experiment with the target barcode.


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
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_current_asof_june30_2016_FINAL.txt"

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


#Create a list of directories to parse.
# for dir in $(ls -1)
# do 

	# if [ -d $dir ]
	# then
		# echo $dir >> directories.txt
	# fi
	
# done

#rename all files in the RNAseq  subdirectories
# cd $dir1/batch
# echo ${PWD}


# for file in *.sh #copy the batch scripts as is. 
# do

	# if [[ ! "$file" =~ ^batch* && ! -e "$dir2/$file" ]]
	# then
		# printf "$timeStamp\tbatchScript\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $masterCopy				
		# printf "$timeStamp\tbatchScript\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $dir2/README.txt		
		# cp "$file" $dir2/"$file"  #copy the summary files as is to the TARGET destination directory
	
	# else
		# printf "$timeStamp\tbatchScript\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $duplicates
	# fi
# done
		

# cd $dir1/data/Fastq/ #cd into the fastq labeled directory
#echo ${PWD}


#loop through the fastq files and rename them. 		
# for file in $(ls -1)
# do
	# if [[ "$file" =~ ^.+\.fq.gz ]]
	# then
		# echo $file
		# reg=$( echo $file | sed -E 's/^[A-Z]+_([0-9]+).+r[1,2].+/\1/') #pull out the registration number
		# len=$( echo $reg | wc -m ) #do not use reg numbers that are very small
		
		# if grep -q "$reg" $mappingFile && [[ $len -gt 4 ]] 
		# then
			# id=$(grep "$reg" $mappingFile | cut -f 5 -d '	' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
			# name=$(echo $file  |  sed -E "s/^([A-Z]+_[0-9]+.+r[1,2].+)/$id-\1/") #new file name
			# echo $file $id $name
			
			# if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
			# then
				# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$reg\t$id\t$name\n" >> $masterCopy				
				# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$reg\t$id\t$name\n" >> $dir2/README.txt
				# cp "$file" $dir2/"$name"  #copy the file to the new file name and destination. 
			# else
				# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$reg\t$id\t$name\n" >> $duplicates
			# fi
	
		# elif [[ ! -e "$dir2/$file" ]] || [[ $len -lt 4  && ! -e "$dir2/$file" ]] #copy all fq files to the destination even if cannot be renamed.
		# then
			# echo NOT MATCHED IN MAPPING $file 
			# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $masterCopy				
			# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $dir2/README.txt					 
			# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\n" >> $dir2/notMatched_Fastq.txt
			# cp "$file" $dir2/"$file" 
				
		# else
			# printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $duplicates
		# fi 
	# fi
# done

# echo completed fastq copying


# cd $dir1/data/Samples/All_Bams_only
# echo ${PWD}

# echo Copying BAM files

#iterate through all the bam files and copy/rename them. 		
# for file in $(ls -1 *.bam* )
# do
	# reg=$( echo $file | sed -E 's/[A-Z]+_([0-9]+).+/\1/')
			
	# if grep -q "$reg" $mappingFile
	# then
		# id=$(grep "$reg" $mappingFile | cut -f 5 -d '	' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
		# name=$(echo $file  |  sed -E "s/^([A-Z]+_[0-9]+.+)/$id-\1/") #new file name
		# echo $file $id $name
				
		# if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
		# then
			# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$reg\t$id\t$name\n" >> $masterCopy				
			# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$reg\t$id\t$name\n" >> $dir2/README.txt
			# cp $file $dir2/"$name"   #copy the file to the new file name and destination. 
		# else
			# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$matchedAdapter\t$reg\t$id\t$name\n" >> $duplicates
		# fi

	# elif [ ! -e "$dir2/$file" ]  #copy all bam files to the destination even if cannot be renamed.
	# then
		# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $masterCopy				
		# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $dir2/README.txt					 
		# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\n" >> $dir2/notMatched_BAM.txt
		# cp "$file" $dir2/"$file" 

	# else
		# printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$N/A\t$N/A\t$file\n" >> $duplicates
			
	# fi
# done

######################## COMPARE AML_TARGET/RNA-seq/ with RNA_Seq_Fastq_Files/ #################
#loop through the fastq files and rename them. 		
for file in $(ls -1 )
do
	if [[ "$file" =~ ^.+\.fq ]]
	then

		id=$(echo $file  | sed -E 's/^(T.+R)\_.+/\1/') #new file name
		echo $file $id $reg
			
		echo its dup $file
		printf "$timeStamp\tfastq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $duplicates

	fi
done

##############################################









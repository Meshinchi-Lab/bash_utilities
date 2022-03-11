#!/bin/bash


#Jenny Smith
#August 4, 2017
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


#Destination directory for renamed files. 
dest="$2"


#create a README with input and output of files. 
if [ ! -e $dest/README.txt ]
then
	touch $dest/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dest/README.txt
fi


#move to original files directory
cd $dir1


findpath () {
	find $1 -type f -regex "^.+\.bam$"
}


#Loop through each IX labeled directory
for dir in $(ls -1)
do 	
	echo $dir
	mappingFile=$( find $dir -type f -regex "^.+library.summary" )
	len=$( echo ${mappingFile[*]} | wc -w )	#mappingFile is an array.using array notation. 
	#echo $dir $len #some directory have multiple subdirectories

	for mf in ${mappingFile[@]} 
	do
		idmap="$( cat $mf )" #read the ID mapping file
		subdir=$( echo $mf | cut -f 1,2 -d '/') #find only bams in the dir and one subdirectory at a time 	
		libpath=$( findpath $subdir ) #use find to get whole filepaths for each bam 
		#echo $libpath
	
		for lib in $libpath
		do
			file=$( basename $lib )
			index=$(echo $file | sed -E "s/^.+_([A-Z]{6})_.+/\1/")
			#echo $file $index
			#echo $lib

			id=$(echo "$idmap" | grep "$index" | cut -f 13 | uniq )
			original=$(echo "$idmap" | grep "$index" | cut -f 3 | uniq)
 
			name=$(echo $file | sed -E "s/^.+(w.+)/$id\_\1/")
			mappingFile=$( basename $mf ) #keep only the filename for printing purposes. 
		   	#echo $id $original 
		   
			if [ ! -e "$dest/$name" ]
		   	then
		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n" >> $masterCopy				
		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n" >> $dest/README.txt				
		   		cp "$lib" $dest/"$name"  #copy the summary files as is to the TARGET destination directory
		   	else
		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n" >> $duplicates			
		   	fi

		done
	done
done


#this loop is for the S.N Samples SOW GSC-1552
#this was done on nextseq so 4 lanes need to be merged. 
mappingFile=$( find $dir1 -type f -regex "^.+library.summary" | head -n 1) #only need 1 mapping file (there are 4)
libpath=$( findpath $dir1 )
for lib in $libpath
do 
	samtools sort -o ${bam%.bam}.srt.bam -O bam -T ${file/_*/} $bam
	samtools index -b ${bam%.bam}.srt.bam 
done


	





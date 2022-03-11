#!/bin/bash


#Jenny Smith
#August 9, 2017
#purpose: rename all coverage files with the target barcode.


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of script
scriptDir="/fh/fast/meshinchi_s/workingDir/scripts"
scriptName="renameRNAseqCoverageFiles.sh"


#location of results 
renamed="$TARGET/AML_TARGET/RNA/miRNAseq/BCCA_Data_Downloads/2017July_BCCA_SOW.GSC1483_MatureMiRNA_matrices/renamed"


#initial directory. this is a positional argument - must type the filepath on the command line. 
dir1="$1"


#Mapping File
mappingFile="BIOAPPS-7784_library.summary"



#move to original files directory
cd $dir1


findpath () {
	find $1 -type f -regex "^.+mimat.+txt$" #mature mirna == mimat
}



#Loop through each directory
for dir in $(ls -1 | grep "MX" )
do 	
	echo $dir
	path=$( findpath $dir ) #use find to get whole filepaths for each coverage file 
	#echo "$path"
	
	for lib in $(echo "$path")
	do
		file=$( basename $lib )
		libID=$(echo $file | sed -E "s/^.+_(m[0-9]+)\\.txt/\1/")
		#echo $file $libID
		#echo $lib

		id=$(cat $mappingFile | grep "$libID" | cut -f 13 | uniq )
		name=$(echo "${id}_$file")
		finaldest=$renamed
		#mappingFile=$( basename $mappingFile ) #keep only the filename for printing purposes. 
		#echo "$finaldest/$name"
		

		#create a README with input and output of files. 
		if [ ! -e $finaldest/README.txt ]
		then
			touch $finaldest/README.txt
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $finaldest/README.txt
		fi
		
		##copy and rename the files to the final destination directory
		if [ ! -e "$finaldest/$name" ]
		then
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $finaldest/README.txt				
			cp "$lib" $finaldest/"$name"  #copy the summary files as is to the TARGET destination directory
		else
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $duplicates			
		fi

	done
done



#!/bin/bash


#Jenny Smith
#Nov 11, 2017
#purpose: rename all coverage files with the target barcode.


#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#main directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of script
scriptDir="/fh/fast/meshinchi_s/workingDir/scripts"
scriptName="renameMiRNAseq_BAM.sh"

#initial directory. this is a positional argument - must type the filepath on the command line.
dir1="$1"


#location of results
# dest="$TARGET/AML_TARGET/RNA/miRNAseq/level1/bam/2017July_BCCA_1031_Illumina_data"
dest="$2"

#move to original files directory
cd $dir1


findpath () {
	find $1 -type f -regex "^.+\.bam$"
}




#Loop through each directory
for dir in $(ls -1 | grep "MX" )
do
	echo $dir
	path=$( findpath $dir ) #use find to get whole filepaths for each coverage file
  mappingFile=$(find $dir -type f -name "*library.summary")
	#echo "$path"
	#echo $mappingFile

	#Check the MD5sums
	lastDir=$(dirname $path | uniq)
	find  $lastDir -type f -name "*.md5sum" -exec cat {} \; > $lastDir/checklist.chk
	md5check=$(cd $lastDir; md5sum -c checklist.chk)

	#If any MD5 errors, save it to a text file in the destination directory
	if ! echo "$md5check" | grep -E -q "OK"
	then
		echo "$md5check" | grep -E -v "OK" > $dest/000_MD5_Errors.txt
	fi


	#Loop through each library (lib) in the MX labeled directory.
	for lib in $(echo "$path")
	do
		file=$( basename $lib )
		libID=$(echo $file | sed -E "s/^.+_([A-Z]{6})\\.bam/\1/")
		#echo $file $libID
		#echo $lib

		id=$(cat $mappingFile | grep "$libID" | cut -f 13 | uniq )
		name="${id}_${dir}.bam"
		#mappingFile=$( basename $mappingFile ) #keep only the filename for printing purposes.
		#echo "$dest/$name"

		#create a README with input and output of files.
		if [ ! -e $dest/README.txt ]
		then
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dest/README.txt
		fi

		##copy and rename the files to the final destination directory
		if [ ! -e "$dest/$name" ]
		then
			printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $masterCopy
			printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $dest/README.txt
			cp "$lib" $dest/"$name"  #copy the summary files as is to the TARGET destination directory
		else
			printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $duplicates
		fi

	done
done

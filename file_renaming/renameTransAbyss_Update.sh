#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o RenameTA.%j.out
#SBATCH -t 0-1


source /app/Lmod/lmod/lmod/init/bash
#########################

#Jenny Smith
#Feb 8, 2018
#purpose: rename all coverage files with the target barcode.


#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/jlsmith3/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/jlsmith3/duplicateFiles.txt"


#main directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of script
scriptDir="/fh/fast/meshinchi_s/workingDir/scripts"
scriptName="renameRNAseqCoverageFiles.sh"


#initial directory. this is a positional argument - must type the filepath on the command line.
#Must be full file path, not relative.
dir1="$1"


#location of results.
dest="$2"


# Mapping File
# mappingFile="BIOAPPS-7859_library.summary"
mappingFile="BIOAPPS-9418_library.summary"


#move to original files directory
cd $dir1


#Function to find the coverage files recursively. Since they are in nested directories.
findpath () {
	find $1 -type f -regex "^.+tsv$" #coverage files end with .normalized
}



#For loop to rename all files in the sub directories with the target barcode
for dir in $(ls -1d A*)
do
	lib="$dir"
	files=$( findpath $dir1/$dir )
	subdirs=$( dirname $files | uniq )
	echo $dir

	#Check  MD5sums. Note TransAbyss has original downloads in 2 different directories. so must do md5check in each directory.
	for subdir in $(echo "$subdirs")
	do
		find  $subdir -type f -name "*.md5sum" -exec cat {} \; > $subdir/checklist.chk
		md5check=$(cd $subdir; md5sum -c checklist.chk)

		#If any MD5 errors, save it to a text file in the destination directory
		if ! echo "$md5check" | grep -E -q "OK"
		then
			echo "$md5check" | grep -E -v "OK" >> $dest/000_MD5_Errors
		fi
	done


	for file in $(echo "$files" )
	do
		barcode=$(cat $mappingFile | grep -E "$lib" | cut -f 14 -d "	" | uniq)
		fileName=$(basename $file)
		name=${barcode}_${lib}_${fileName}

		# create a README with input and output of files.
		if [ ! -e $dest/README.txt ]
		then
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dest/README.txt
		fi

		#copy and rename the files
		if [ ! -e $dest/"$name" ] #copy the exression matrices "as is".
		then
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\n" >> $masterCopy
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\n" >> $dest/README.txt
			cp "$file" "$dest/$name"  #copy the summary files as is to the TARGET destination directory
		else
			duplicateLocation=$( grep "$name" $dest/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tmRNA_fusions\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$barcode\t$name\t$duplicateLocation\n" >> $duplicates
		fi
    done
done

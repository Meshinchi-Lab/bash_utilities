#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o RenameCoverageFiles.%j.out
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
scriptDir="~/scripts/bash/scripts/"
scriptName="renameRNAseqCoverageFiles.sh"


#location of results
resGene="$TARGET/AML_TARGET/RNA/mRNAseq/level3/gene/2018May_BCCA_Illumina_data"
resExon="$TARGET/AML_TARGET/RNA/mRNAseq/level3/exon/2018May_BCCA_Illumina_data"
resIntron="$TARGET/AML_TARGET/RNA/mRNAseq/level3/intron/2018May_BCCA_Illumina_data"
resTx="$TARGET/AML_TARGET/RNA/mRNAseq/level3/transcript/2018May_BCCA_Illumina_data"

#Create the directories
mkdir -p {$resGene,$resExon,$resIntron,$resTx}


#initial directory. this is a positional argument - must type the filepath on the command line.
#Must be full file path, not relative.
dir1="$1"

# Mapping File
# mappingFile="BIOAPPS-7859_library.summary"
mappingFile="BIOAPPS-9418_library.summary"


#move to original files directory
cd $dir1
echo $dir1
echo $PWD

#Function to find the coverage files recursively. Since they are in nested directories.
findpath () {
	find $1 -type f -regex "^.+normalized$" #coverage files end with .normalized
}

#Loop through each directory labeled with A[0-9]{5}, eg A88608
for dir in $(ls -1 A*)
do
	echo $dir
	path=$( findpath $dir ) #use find to get whole filepaths for each of the coverage files
	# echo "$path"

	#Check the MD5sums
	lastDir=$(dirname $path | uniq)
	find  $lastDir -type f -name "*.md5sum" -exec cat {} \; > $lastDir/checklist.chk
	md5check=$(cd $lastDir; md5sum -c checklist.chk)

	for lib in $path
	do
		file=$( basename $lib )
		libID=$(echo $file | sed -E "s/^(A[0-9]{5})[_\\.].+/\1/")
		# echo $file $libID
		#echo $lib

		id=$(cat $mappingFile | grep "$libID" | cut -f 14 | uniq )
		name=$(echo $file | sed -E "s/^.+(str.+)/$id\_\1/")
		# mappingFile=$( basename $mappingFile ) #keep only the filename for printing purposes.
		# echo $id $name

		#Determine which output directory for each file type.
		if [[ "$file" =~ ^.+intron ]]
		then
			finaldest=$resIntron
		elif [[ "$file" =~ ^.+exon ]]
		then
			finaldest=$resExon
		elif [[ "$file" =~ ^.+transcript ]]
		then
			finaldest=$resGene
		fi
		# echo $finaldest

		#If any MD5 errors, save it to a text file in the destination directory
		if ! echo "$md5check" | grep -E -q "OK"
		then
			echo "$md5check" | grep -E -v "OK" > $finaldest/000_MD5_Errors
		fi

		#create a README with input and output of files.
		if [ ! -e $finaldest/README.txt ]
		then
			touch $finaldest/README.txt
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $finaldest/README.txt
		fi

		#copy and rename the files to the final destination directory
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

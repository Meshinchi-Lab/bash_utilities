#!/bin/bash


#Jenny Smith
#January 19, 2017
#purpose: rename all microRNA analysis files with the target barcode.
#BCCA analysis miRNA pipeline: https://github.com/bcgsc/mirna


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
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files"

#Destination directory for renamed files. 
dir2="$2"



#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi


#Copy the reference mapping files to the miRNAv19 directory (*library.summary files)
#these match the library and index/barcode to the target ID
# find miRNA/ -type f -name "*library.summary" -exec cp -t miRNAv19/ {} +

#move the library.summary files into the correct subdirectories for reference. 
# for file in MX*
# do 
	# if [ -f $file ]
	# then 
		# lib=$(echo $file | sed -E 's/(^MX[0-9]+).+/\1/')
		# mv $file $lib/ 
	# fi
# done


#move to original files directory
cd $dir1


#Create a list of MX labeled directories to parse. 
# for dir in $(ls -1)
# do 
	# echo $dir >> directories.txt
# done



#rename all files in the MX labeled directories to include the library and index.
for dir in $(cat $dir1/directories.txt)
do 
	if [[ "$dir" =~ MX* ]] #only move the files in MX labeled directories
	then 
		echo $dir
		cd $dir1/$dir
		
		for subdir in $(ls -1d */) #list only the subdirectories in each MX directory
		do 
			lib_index=$(echo $subdir |  sed -E 's/(^MX[0-9]+_[A-Z]{6}).+/\1/')
			echo $lib_index $subdir
			find $subdir -type f -print0 | xargs --null -I{} cp {} {}_$lib_index  #rename each file with the library and index so it can be identified. 
		done
		
	fi
done


echo rename completed 


#Must move the original files up one directory. There are too many subdirectories to go through each individually. 
#move all files with lib_index into the main MX labeled directory.
#used "! - name" option b/c cannot move the isoform.txt because it is labeled identically in two locations. 
for dir in 	$(cat $dir1/directories.txt)
do
	if [[ "$dir" =~ MX* ]] #only move the files in MX labeled directories
	then 
		echo $dir
		cd $dir1/$dir 
		find $dir1/$dir -type f \( -name "*_MX*_*" ! -name "iso*" \) -exec mv -t $dir1/$dir {} +
	
		for subdir in $(ls -1d */)
		do
			currentDir=$(echo $subdir | tr -d "/")
			fileName=$(echo $currentDir/tcga/iso*_MX* | cut -f 3 -d "/" | cut -f 1 -d "	")
			newFileName=$(echo $fileName | sed -E 's/(^.+)/tcga_\1/')
			echo $dir1/$dir
			echo $currentDir/iso*_MX*
			echo $currentDir/tcga/iso*_MX*
			echo $fileName $newFileName
			mv $currentDir/tcga/iso*_MX* $dir1/$dir/$newFileName  
			mv $currentDir/iso*_MX* $dir1/$dir 
		done
	fi
done



# copy and rename files in miRNAv19/ directory to TARGET destination, such as epression matrices. 
for file in $(ls -1 $dir1)  
do

	if [[ -f $file ]] #rename the readme and expression matrices. 
	then
		name=$(echo $file | sed -E 's/(^.+)/BCCA_miRNAprofiling_\1/')
		echo $name

		if [ ! -e $dir2/"$name" ] #copy the exression matrices "as is". 
		then
			printf "$timeStamp\tmiRNA_expnMatrix\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $masterCopy				
			printf "$timeStamp\tmiRNA_expnMatrix\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $dir2/README.txt		
			cp $dir1/"$file" $dir2/"$name"  #copy the summary files as is to the TARGET destination directory
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tmiRNA_expnMatrix\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	fi
done

echo files are moved to one directory. 

# rename all files in the miRNA/ subdirectories (the MX labeled directories) to the target barcode. 
for dir in $(cat $dir1/directories.txt)
do

	if [[ "$dir" =~ MX* ]] #rename the files in MX labeled directories
	then 
		echo $dir
		cd $dir1/$dir
		

		for file in $(ls -1 *.*) #list only regular files in the MX labeled directory
		do
					
			if [[ "$file" =~ ^align.+\.csv ]] #this will only identify the alignment stats file for each library. 
			then
			
				lib=$(echo $dir | tr -d "/") 
				alignStatsName=$( echo $file |  sed -E "s/^([a-z]+.+)/$lib\_\1/")
				echo $lib $alignStatsName
				
				if [[ ! -e $dir2/"$alignStatsName" ]] #check that the file does not already exist. 
				then
					printf "$timeStamp\tmiRNA_alignmentStats\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\tN/A\t$alignStatsName\n" >> $masterCopy				
					printf "$timeStamp\tmiRNA_alignmentStats\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\tN/A\t$alignStatsName\n" >> $dir2/README.txt
					cp $file $dir2/"$alignStatsName"  #copy the file to the new file name and destination. 
				else
					duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
					printf "$timeStamp\tmiRNA_alignmentStats\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\tN/A\t$alignStatsName\t$duplicateLocation\n" >> $duplicates
				fi
			
			
			elif [[ "$file" =~ ^.+\.report ]]  #copy the report files 
			then
				lib=$(echo $dir | tr -d "/")
				lib_index=$( echo $file | sed -E 's/^(MX[0-9]+_[A-Z]+)_[a-z]+.+/\1/') 
				index=$( echo $file | sed -E 's/^MX[0-9]+_([A-Z]+)_[a-z]+.+/\1/') #pull out the sequence read index/barcode
				
				id=$(grep "$index" *library.summary | cut -f 9 -d ' ' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
				name=$( echo $file | sed -E "s/^MX[0-9]+_[A-Z]+_([a-z]+.+)/$id-\1/") #new file names
				mappingFile=$( echo $lib*.summary)
				echo $lib_index $name $mappingFile
				
				if [[ ! -e $dir2/"$name" ]] 
				then 
					printf "$timeStamp\miRNA_reportFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy				
					printf "$timeStamp\miRNA_reportFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt		
					cp "$file" $dir2/"$name"  #copy the report files as is to the TARGET destination directory
				else
					duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
					printf "$timeStamp\miRNA_reportFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\t$duplicateLocation\n" >> $duplicates
				fi
			
			
			elif [[ "$file" =~ ^.+\.[a-z]+_MX.+_[A-Z]{6} ]] #copy and rename the data files. 
			then
				lib=$(echo $dir | tr -d "/")
				lib_index=$( echo $file | sed -E 's/^.+\.[a-z]+_(MX.+_[A-Z]{6})/\1/')
				index=$( echo $file | sed -E 's/^.+\.[a-z]+_MX.+_([A-Z]{6})/\1/') #pull out the sequence read index/barcode
				
				id=$(grep "$index" *library.summary | cut -f 9 -d ' ' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
				name=$( echo $file | sed -E "s/(^.+\.[a-z]+)_MX.+_[A-Z]{6}/$id-\1/") #new file name
				mappingFile=$( echo $lib*.summary)
				echo $lib_index $name $mappingFile
				
				
				if [ ! -e $dir2/"$name" ] #only copy files that do not already exist
				then
					printf "$timeStamp\tmiRNA_profiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy				
					printf "$timeStamp\tmiRNA_profiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt
					mv "$file" $dir2/"$name"  #move the file to the new file name and isoform or express destination. 
				else
					duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
					printf "$timeStamp\tmiRNA_profiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib_index\t$id\t$name\t$duplicateLocation\n" >> $duplicates
				fi
			fi
		done			
	fi
done



			# elif [[ "$file" =~ ^.+\.summary ]]
			# then
				# echo summar
				# if [ ! -e $dir2/"$file" ] #copy the summary file "as is"
				# then
					# printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $masterCopy				
					# printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $dir2/README.txt		
					# cp "$file" $dir2/"$file"  #copy the summary files as is to the TARGET destination directory
				# else
					# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
					# printf "$timeStamp\tsummaryFile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\t$duplicateLocation\n" >> $duplicates
				# fi

# #change directory to the destination directory
# cd $dir2

# #http://askubuntu.com/questions/76785/how-to-escape-file-path-in-sed
# #move the isoform/miRNA epxression data to correct directories. 
# for file in $(ls -1 *.*) 
# do
	# #echo final rename and move
	
	# if [[ "$file" =~ ^TARGET.+[-_]iso.+ ]] #place the isoform count data into the correct directory.
	# then
		# echo isoforms $file 
		# # #sed -i.tmp -E 's|(^.+)('$dir2')(.+isoforms.txt)|\1\2\/level3\/isoform	\3|g' README.txt  #regex to update destination directory
		# # mv $file $dir2/level3/isoform  #copy the file to the isoform directory
	
	# # elif [[ "$file" =~ ^TARGET.+-mi[rnaRNA].+ ]] #miRNA count data
	# # then
		# # echo miRNA File $file
		# # #sed -i.tmp -E 's|(^.+)('$dir2')(.+TARGET.+mirna.+)|\1\2\/level3\/expression	\3|ig' README.txt
		# # mv $file $dir2/level3/expression  #copy the file to the new file name and isoform or express destination. 
	
	# elif [[ "$file" =~ ^.+exp.+ && ! "$file" =~ BCCA.+ ]] #expression matrices
	# then
		# echo expression matirx $file
		# #sed -i.tmp -E 's|(^.+)('$dir2')(.+exp.+)|\1\2\/level3\/expression	\3|g' README.txt 
		# mv $file $dir2/level3/expression  #copy the file to the new file name and isoform or express destination. 
	
	# # elif [[ "$file" =~ ^.+\.report ]] #adapter report files
	# # then	
		# # echo report files  $file 
		# # sed -i.tmp -E 's|(^.+)('$dir2')(        .+_adapter.+)|\1\2\/level1\/bam	\3|g' README.txt
		# # mv $file $dir2/level1/bam  #copy the file to the new file name and isoform or express destination.
	
	# # elif [[ "$file" =~ ^.+\.gz ]] #bed files and wig files
	# # then 
		# # echo .gz bed files $file
		# # sed -i.tmp -E 's|(^.+)('$dir2')(.+\.gz)|\1\2\/level1\/bed	\3|g' README.txt
		# # mv $file $dir2/level1/bed
	
	# # elif [[ "$file" =~ ^.+\.jpg || "$file" =~ ^.+\.csv ]] #QC graphs and library summaries
	# # then
		# # echo QC $file
		# # mv $file $dir2/metadata
	
	# elif [[ "$file" =~ ^.+crossmapped.+ ]] #crossmapped file is used for miRNA expression analysis.
	# then
		# echo crossmapped $file
		# mv $file $dir2/level3/expression
	
	# ###MUST CHECK THE DESCRIPTION AND OTHER FILES FOR REDUNCANCIES
	# elif [[ "$file" =~ BCCA.+  || "$file" =~ ^.+\.summary ||  "$file" =~ README.+ || "$file" =~ ^VERSION.+ ]] #temporary until it can be determined as identical
	# then
		# echo bcca $file
		# mv $file $dir2/metadata
		
	# else
		# echo other $file
		# mv $file $dir2/level3/repetitiveRNAs/
	
	# fi
# done


# #update the readme with the correct file destination. 
# #this includes the BAM files already copied over from miRNA/ 
# # for file in $(ls -1 *.*) 
# # do
	# # echo final rename and move
	
	# # if [[ "$file" =~ ^TARGET.+[-_]iso.+ ]] #place the isoform count data into the correct directory.
	# # then
		# # echo isoforms $file 
		# # sed -i.tmp -E 's|(^.+)('$dir2')(.+isoforms.txt)|\1\2\/level3\/isoform	\3|g' README.txt  #regex to update destination directory.
	
	# # elif [[ "$file" =~ ^TARGET.+-mi[rnaRNA].+ ]] #miRNA count data
	# # then
		# # echo miRNA File $file
		# # sed -i.tmp -E 's|(^.+)('$dir2')(.+TARGET.+mirna.+)|\1\2\/level3\/expression	\3|ig' README.txt

	# # elif [[ "$file" =~ ^exp.+ ]] #expression matrices
	# # then
		# # echo expression matirx $file
		# # sed -i.tmp -E 's|(^.+)('$dir2')(.+exp.+)|\1\2\/level3\/expression	\3|g' README.txt 

	# # elif [[ "$file" =~ ^.+\.report ]] #adapter report files
	# # then	
		# # echo report files  $file ###CHECK THIS SED expr
		# # sed -i.tmp -E 's|(^.+)('$dir2')(        .+_adapter.+)|\1\2\/level1\/bam	\3|g' README.txt

	# # elif [[ "$file" =~ ^.+\.gz ]] #bed files and wig files
	# # then 
		# # echo .gz bed files $file
		# # sed -i.tmp -E 's|(^.+)('$dir2')(.+\.gz)|\1\2\/level1\/bed	\3|g' README.txt

	# # elif [[ "$file" =~ ^.+\.jpg || "$file" =~ ^.+\.csv || ]] #"$file" =~ ^.+\.summary ]] #QC graphs and library summaries
	# # then
		# # echo QC $file
		
		
	# # fi
# # done









#!/bin/bash

#Jenny Smith
#January 26, 2017
#Purpose: rename  maf files produced by Complete Genomics (GCI) for the TARGET AML project. 
#EDITED: January 15, 2013 to include an elif statement, and also copy all associated metadata to the new location without changing the name. 


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#directory with the maf files. positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/target_aml_cgi_normal_mastervarbeta_Dec2014_mappingFile.txt"
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/target_aml_cgi_germLineSummary_Target_Dec2014_mappingFile.txt"


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

#Iterate through all the maf files with file extention .tsv in the specified directory. 
for maf in $(ls -1 *.tsv)
do
	#gsLong=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	#usiLong=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.{10}).+/\1/')
	
	usiLong=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.+)\.tsv/\1/')  #this expression is for TARGET_Dec2014/CGI/germlineSummaries
	gsLong=$( echo $maf | sed -E 's/^[a-zA-Z]+-(GS.+)\.tsv/\1/' ) #this expression is for TARGET_Dec2014/CGI/germlineSummaries
	
	len=$(echo $gsLong | wc -m )
	
	if grep -q "$gsLong" $mappingFile && [[ "$gsLong" =~ GS.+ ]] && [[ "$len" -le 25 ]]
	then
	
		#id=$(grep "$gsLong" $mappingFile | cut -f 11 -d '	')
		#name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id\_\1_germlineMaf\2/")
		
		id=$(grep "$gsLong" $mappingFile | cut -f 9 -d '	') #this is for TARGET_Dec2014/CGI/germlineSummaries
		name=$( echo $maf | sed -E "s/^([a-zA-Z]+)-GS.+(\.tsv)/$id\_\1_germlineSummary\2/") # this is for TARGET_Dec2014/CGI/germlineSummaries
		
		echo  $gsLong $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	elif grep -q "$gsLong" $mappingFile && [[ "$gsLong" =~ GS.+ ]] && [[ "$len" -ge 29 ]]
	then
		#id=$(grep "$gsLong" $mappingFile | cut -f 11 -d '	')
		id=$(grep "$gsLong" $mappingFile | cut -f 9 -d '	') #this is for TARGET_Dec2014/CGI/germlineSummaries
		name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id\_\1_$gsLong\_germlineSummary\2/")
		echo  $gsLong $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
			cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gsLong\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	elif grep -q "$usiLong"  $mappingFile && [[ "$usiLong" =~ [A-Z]+_210.+ ]]
	then

		#id=$(grep "$usiLong" $mappingFile | cut -f 11 -d '	')
		#name=$(echo $maf | sed -E "s/(^[a-zA-Z]+)[-_][A-Z]+_210.{10}(.+)/$id\_\1_germlineMaf\2/")
		id=$(grep "$usiLong" $mappingFile | cut -f 9 -d '	') #this is for TARGET_Dec2014/CGI/germlineSummaries
		name=$(echo $maf | sed -E "s/^([a-zA-Z]+)[-_][A-Z]+_210.+(\.tsv)/$id\_\1\_germlineSummary\2/") #this is for TARGET_Dec2014/CGI/germlineSummaries
		
		echo $usiLong $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usiLong\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usiLong\t$id\t$name\n" >> $dir2/README.txt
			cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usiLong\t$id\t$name$duplicateLocation\n" >> $duplicates
		fi
	
	else
		printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usiLong\tN/A\tN/A\n" >> $dir2/notMatched_MAFs.txt 
	fi
	
done








#############TWO-TUMOR IDS####################
# for maf in $(ls -1 *.tsv)
# do
	# gsLong=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/') #variable to pull out the gs# from the original file name. 
	# usiLong=$( echo $maf | sed -E 's/^[a-zA-Z]+[-_]([A-Z]+_210.{10}).+/\1/')
	# len=$(echo $gsLong | wc -m )
	# usi=$(echo $usiLong | sed -E 's/^([A-Z]+.+)-N1(-T1)/\1\2/')
	# ##echo $gsLong $usiLong
	
	# #echo $maf
	
	# if [[ $len -eq 25 ]]
	# then
		# ##echo inside lenght conditional
		# #gs1=$( echo $gsLong | sed -E 's/(GS.+)-N1(-T1)-T2/\1\2/')
		# #gs2=$( echo $gsLong | sed -E 's/(GS.+)-N1-T1(-T2)/\1\2/')

		# #CHECK ON -q OPTION
		# if grep  -q "$gs1" $mappingFile && grep -q "$gs2" $mappingFile 
		# then 
			# #echo 
			# id1=$(grep "$gs1" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable. 
			# id2=$(grep "$gs2" $mappingFile | cut -f 4 -d '	')
			# name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id1\_$id2-\1\2/") #regular expression to create new file name.
			# #echo longGS $id1 $id2 $name
			
			# if [ ! -e $dir2/$name ]
			# then
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t${gs_$gs2\t${id1}_$id2\t$name\n" >> $masterCopy				
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t${gs1}_$gs2\t${id1}_$id2\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
				# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
			# else
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t${gs1}_$gs2\t${id1}_$id2\t$name\n" >> $duplicates
			# fi
			
		# else
			# #ADDED CURLY BRACES TO THE gs1_gs2 CHECK THIS WORKS
			# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t${gs1}_gs2\tN/A\t$N/A\n" >> $dir2/notMatched_MAFs.txt
		# fi
	
	# elif [[ $len -lt 25 ]]
	# then
		# gs=$( echo $gsLong | sed -E 's/(GS.+)-N1(-T1)/\1\2/')
			
		# if grep -q "$gs" $mappingFile 
		# then
			# ##echo $gs
			# id=$(grep "$gs" $mappingFile | cut -f 4 -d '	')
			# name=$( echo $maf | sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id-\1\2/")
			# #echo short gs  $id $name
		
			# if [ ! -e $dir2/$name ]
			# then
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $masterCopy				
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name. 
				# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
			# else
				# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $duplicates
			# fi
			
		# else
			# #echo
			# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\tN/A\t$N/A\n" >> $dir2/notMatched_MAFs.txt
		# fi
	
	# elif grep -q "$usi"  $mappingFile
	# then
		# #echo $usi
		# id=$(grep "$usi" $mappingFile | cut -f 4 -d '	')
		# name=$(echo $maf | sed -E "s/(^[a-zA-Z]+)[-_][A-Z]+_210.{10}(.+)/$id-\1\2/")
		# #echo usi $id $name
		
		# if [ ! -e $dir2/$name ]
		# then
			# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\n" >> $masterCopy				
			# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\n" >> $dir2/README.txt
			# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
		# else
			# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\t$id\t$name\n" >> $duplicates
		# fi
	
	# else
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$usi\tN/A\tN/A\n" >> $dir2/notMatched_MAFs.txt 
	# fi
	
# done

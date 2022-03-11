#!/bin/bash


#Jenny Smith
#January 6, 2017
#purpose: create directores for the TARGET AML project data files.
#EDITED: Jan. 30, 2017 to be more accurate and updated with TCGA-like data levels. 



mkdir --parents TARGET/{DNA,RNA,Other}


#mkdir -p TARGET/DNA/{WGS,TCS,Microarray}
#mkdir -p TARGET/RNA/{Microaray,mRNAseq,miRNAseq}
cd TARGET

for dir in $(ls -1)
do 
	if [[ -d $dir && "$dir" =~ RNA ]]
	then
		#echo the directory is $dir
		mkdir -p $dir/{Microarray,mRNAseq,miRNAseq}/{level{1..4},metadata}
		mkdir -p $dir/{miRNAseq,mRNAseq}/level1/{bam,bed,fastq}
		mkdir -p $dir/miRNAseq/level3/{expression,isoform,repetitiveRNAs}
		mkdir -p $dir/mRNAseq/level3/{exonLevelExpn,geneLevelExpn,fusion,spliceIsoforms}
		
		
	elif [[ -d $dir && "$dir" =~ DNA ]]
	then
		#echo the direcotry is $dir
		mkdir -p $dir/{Microarray,WGS,TCS}/{level{1..4},metadata}
		mkdir -p $dir/{WGS,TCS}/{level2,level3}/{CNVs,SNVs,fusion,SVs,mobileElements}
		mkdir -p $dir/WGS/level4/circosPlots
	fi
done


#Orginial Code 
# for dir in $(ls -1 .)
# do 
	# echo the directories are $dir
	# if [[ "$dir" == "DNA" ]]
	# then
		# mkdir -p DNA/WGS_TCS
		# test -d WGS_TCS || continue
		# mkdir -p DNA/WGS_TCS/{SNVs,fusion,copyNumber}
	# else
		# mkdir -p RNA/{geneExpression,fusion,SpliceIsoforms,miRNA}
		# for directory in $(ls -1 RNA/)
		# do
			# if [[ "$directory" == "geneExpression" ]]
			# then
				# mkdir -p RNA/geneExpression/{exonExpression,geneLevelExpression}
			# else 
				# mkdir -p RNA/miRNA/{expression,isoform}
			# fi
		# done
	# fi
# done
#Jenny Smith
#January 18, 2017 
#purpose: count the number of reads in the 20 normal bone marrow SAM files


cd /fh/fast/meshinchi_s/workingDir/originals/20_Normal_BM_RNA_Seq_bam_files


#convert bam to sam files
for file in *.bam
do 
	echo $file
	samtools view -h $file > ${file/.bam/.sam}
done


#count the number of reads in the file
for file in *.sam
do
	numReads=$(grep -v "^@" $file | wc -l) #grep -v the header lines with @
	echo $file: $numReads
done


# IX4512_C9FWMANXX_5_TAATCG.sam: 195365776
# IX4512_C9FWMANXX_5_TACAGC.sam: 168143780
# IX4512_C9FWMANXX_5_TATAAT.sam: 237423910
# IX4513_C9FWMANXX_6_TCATTC.sam: 204709984
# IX4513_C9FWMANXX_6_TCCCGA.sam: 197818924
# IX4513_C9FWMANXX_6_TCGAAG.sam: 202691820
# IX4514_C9FWMANXX_7_TCGGCA.sam: 168200242
# IX4514_C9FWMANXX_7_TCTACC.sam: 235392866
# IX4514_C9FWMANXX_7_TGAATG.sam: 184853050
# IX4515_C9FWMANXX_8_TGCCAT.sam: 184837904
# IX4515_C9FWMANXX_8_TGCTGG.sam: 255898954
# IX4515_C9FWMANXX_8_TGGCGC.sam: 186176056
# IX4516_C9FD6ANXX_1_AGGTTT.sam: 234750568
# IX4516_C9FD6ANXX_1_TTCGAA.sam: 174575292
# IX4516_C9FD6ANXX_1_TTCTCC.sam: 190705312
# IX4517_C9FD6ANXX_2_AGTCAA.sam: 275101374
# IX4517_C9FD6ANXX_2_AGTTCC.sam: 83852432
# IX4517_C9FD6ANXX_2_ATGTCA.sam: 270621732
# IX4518_C9FD6ANXX_3_CCGTCC.sam: 289954262
# IX4518_C9FD6ANXX_3_GTAGAG.sam: 311370996



#Next step- check the quality scores and the mapping flag






#!/bin/bash


cd $1
echo $PWD

# Replicates were determined using the manifests in the SequencingDataMatrix/ directory.
replicates=(TARGET-20-PAXLDJ-09A-01R TARGET-20-PAXGYZ-03A-01R TARGET-20-PAXEBW-09A-01R TARGET-20-PAWTSD-09A-01R TARGET-20-PAWMHE-09A-01R TARGET-20-PAWKIW-03A-01R TARGET-20-PAWEYY-09A-01R TARGET-20-PAVWRI-09A-01R TARGET-20-PAVTRU-09A-01R TARGET-20-PAVHWK-09A-01R TARGET-20-PAVBVP-09A-01R TARGET-20-PAUVIB-09A-01R TARGET-20-PAUUTI-09A-01R TARGET-20-PATISD-09A-01R TARGET-20-PATGIG-03A-01R TARGET-20-PATESX-09A-01R TARGET-20-PASRLS-09A-01R TARGET-20-PASLTF-09A-01R TARGET-20-PASIEJ-09A-01R TARGET-20-PARVSF-09A-01R TARGET-20-PALHWN-09A-01R TARGET-00-BM5776-14A-01R TARGET-00-BM5759-14A-01R TARGET-00-BM5756-14A-01R TARGET-00-BM5751-14A-01R TARGET-00-BM5682-14A-01R TARGET-00-BM5233-14A-01R TARGET-00-BM5136-09A-01R TARGET-00-BM5108-09A-01R TARGET-00-BM4641-14A-01R TARGET-00-BM4616-14A-01R TARGET-00-BM4508-14A-01R TARGET-00-BM4473-14A-01R TARGET-00-BM4404-14A-01R TARGET-00-BM4203-14A-01R TARGET-00-BM3969-14A-01R TARGET-00-BM3897-14A-01R )

# #Rename the duplicate patient samples
# for usi in ${replicates[*]}
# do
#   files=$(ls -1 *.tsv)
#   dups=$(echo "$files" | grep -E "$usi")
#
#   for dup in $(echo "$dups")
#   do
#     mv -n $dup "${dup/_A/_replicate_A}"
#     # echo "${dup/_A/_replicate_A}"
#   done
#
# done
#
# echo "completed renaming replicates"


# #Next, move all the files to the July2017_*_illumina_data/ directories. To ensure that all Ribodepleted RNAseq is kept in the same directory.
destinations=$(echo /fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level2/indels/2017July_BCCA_0531_1031_TransAbyss_Illumina_data \
/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/level2/fusion/2017July_BCCA_0531_1031_TransAbyss_Illumina_data )

# mv -n *events_exons_novel.tsv $(echo $destinations | tr " " "\n" | head -1)
# mv -n *.tsv $(echo $destinations |  tr " " "\n" | tail -1 )


#Loop through each final directory and rename the NBMs and add "TARGET" to 1031.
for dest in $(echo $destinations)
do
  cd $dest
  echo $PWD

  #NBMs must be re-named to be the same as BCCA and for consistency with SRA upload that will happen in the future.
  NBM=$( ls -1 *.tsv | grep -E "BM[0-9]|RO[0-9]")
  # echo "$NBM"
  
  #For loop to rename the NBM files
  for file in $(echo "$NBM")
  do
    if ! echo "$file" | grep -E -q "TARGET"
    then
        # echo "TARGET-00-${file/09A/14A}"
        mv -n $file "TARGET-00-${file/09A/14A}"
    elif echo "$file" | grep -E -q "09A"
    then
        # echo "${file/09A/14A}"
        mv -n $file  "${file/09A/14A}"
    fi
  done

  echo "Completed NBM"

  #Final step to rename all 1031 samples with TARGET-20 barcode.
  for file in $(ls -1 *.tsv)
  do
    if ! echo "$file" | grep -E -q  "TARGET|^Kas|^MV4"
    then
      # echo "TARGET-20-${file}"
      mv -n $file "TARGET-20-${file}"
    fi
  done

  echo "Completed All Name Changes in" $dest

done

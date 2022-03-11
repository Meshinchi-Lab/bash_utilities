#!/bin/bash


cd $1
echo $PWD

# Replicates were determined using the manifests in the SequencingDataMatrix/ directory.
replicates=(TARGET-20-PAXLDJ-09A-01R TARGET-20-PAXGYZ-03A-01R TARGET-20-PAXEBW-09A-01R TARGET-20-PAWTSD-09A-01R TARGET-20-PAWMHE-09A-01R TARGET-20-PAWKIW-03A-01R TARGET-20-PAWEYY-09A-01R TARGET-20-PAVWRI-09A-01R TARGET-20-PAVTRU-09A-01R TARGET-20-PAVHWK-09A-01R TARGET-20-PAVBVP-09A-01R TARGET-20-PAUVIB-09A-01R TARGET-20-PAUUTI-09A-01R TARGET-20-PATISD-09A-01R TARGET-20-PATGIG-03A-01R TARGET-20-PATESX-09A-01R TARGET-20-PASRLS-09A-01R TARGET-20-PASLTF-09A-01R TARGET-20-PASIEJ-09A-01R TARGET-20-PARVSF-09A-01R TARGET-20-PALHWN-09A-01R TARGET-00-BM5776-14A-01R TARGET-00-BM5759-14A-01R TARGET-00-BM5756-14A-01R TARGET-00-BM5751-14A-01R TARGET-00-BM5682-14A-01R TARGET-00-BM5233-14A-01R TARGET-00-BM5136-09A-01R TARGET-00-BM5108-09A-01R TARGET-00-BM4641-14A-01R TARGET-00-BM4616-14A-01R TARGET-00-BM4508-14A-01R TARGET-00-BM4473-14A-01R TARGET-00-BM4404-14A-01R TARGET-00-BM4203-14A-01R TARGET-00-BM3969-14A-01R TARGET-00-BM3897-14A-01R )

#Rename the duplicate patient samples
for usi in ${replicates[*]}
do
  files=$(ls -1 *.normalized)
  dup=$(echo "$files" | grep -E "$usi")
  mv -n $dup "${dup/R_str/R_replicate_str}"
  # echo "${dup/R_str/R_replicate_str}"
done

echo "completed renaming replicates"


#Next, move all the files to the July2017_*_illumina_data/ directories. To ensure that all Ribodepleted RNAseq is kept in the same directory.
mv -n *.normalized ../2017July_BCCA_1031_Illumina_data
cd ../2017July_BCCA_1031_Illumina_data
echo $PWD

#NBMs must be re-named to be the same as BCCA and for consistency with SRA upload that will happen in the future.
NBM=$( ls -1 *.normalized | grep -E "BM[0-9]|RO[0-9]")
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
for file in $(ls -1 *.normalized)
do
  if ! echo "$file" | grep -E -q  "TARGET|^Kas|^MV4"
  then
    # echo "TARGET-20-${file}"
    mv -n $file "TARGET-20-${file}"
  fi
done

cd ..
mv -n 2017July_BCCA_1031_Illumina_data/ 2017July_BCCA_0531_1031_Ribodepletion_Illumina_data/

echo "Completed All Name Changes"

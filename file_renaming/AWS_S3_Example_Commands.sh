#Jenny Smith
#1/18/19
#Purpose: Example commands for deleting files off AWS S3 and renaming them.

BUCKET="s3://fh-pi-meshinchi-s"


# To Delete  (prefixes)
# 1. /SR/DNA/
# 2. /SR/GRCh37/
# 3. /SR/GRCh38/
# 4. /SR/dtenenba/
# 5. /SR/kallisto_out/
# 6. /SR/pizzly_out/
# 7. /SR/unsorted_1031/

#files to Delete
# SR/Picard-check-disk-space.sh
# SR/Picard_ForDocker-bad.sh
# SR/Picard_ForDocker-use-external-scratch.sh
# SR/Picard_ForDocker2.sh
# SR/Picard_ForDocker3.sh
# SR/Picard_ForDocker4.sh
# SR/Picard_ForDocker_addMemSettings-dtenenba.sh
# SR/Picard_ForDocker_addMemSettings.sh
# SR/Batch_Pipeline_Submission/submit_test.txt
# SR/JSmith_Upload_to_S3_5.31.18.txt
# 2018-04-02 18:11:10   28.7 KiB SR/picard_fq2/Kasumi-AZA-D11-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2018-04-02 18:08:03    3.3 GiB SR/picard_fq2/Kasumi-AZA-D11-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2018-04-02 18:08:54    3.4 GiB SR/picard_fq2/Kasumi-AZA-D11-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2018-04-02 18:04:35   25.9 KiB SR/picard_fq2/Kasumi-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2018-04-02 18:03:24    3.0 GiB SR/picard_fq2/Kasumi-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2018-04-02 18:03:59    3.1 GiB SR/picard_fq2/Kasumi-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2018-04-02 18:10:16   26.9 KiB SR/picard_fq2/Kasumi-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2018-04-02 18:08:49    3.3 GiB SR/picard_fq2/Kasumi-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2018-04-02 18:09:30    3.4 GiB SR/picard_fq2/Kasumi-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2018-04-02 18:02:19   24.7 KiB SR/picard_fq2/MV4-11-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2018-04-02 18:01:12    2.9 GiB SR/picard_fq2/MV4-11-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2018-04-02 18:01:46    3.0 GiB SR/picard_fq2/MV4-11-AZA-D5-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2018-04-02 18:05:16   26.1 KiB SR/picard_fq2/MV4-11-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2018-04-02 18:03:57    3.2 GiB SR/picard_fq2/MV4-11-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2018-04-02 18:04:34    3.3 GiB SR/picard_fq2/MV4-11-D1-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2017-12-15 20:31:16   29.7 KiB SR/picard_fq2/dtenenba-PAWZNG-03A-01R_withJunctionsOnGenome_dupsFlagged_picard.stderr
# 2017-12-15 19:43:30    3.9 GiB SR/picard_fq2/dtenenba-PAWZNG-03A-01R_withJunctionsOnGenome_dupsFlagged_r1.fq.gz
# 2017-12-15 19:43:29    4.1 GiB SR/picard_fq2/dtenenba-PAWZNG-03A-01R_withJunctionsOnGenome_dupsFlagged_r2.fq.gz
# 2017-12-14 12:33:57    1.5 KiB SR/picard_fq2/outq




# aws s3 ls --human-readable s3://fh-pi-meshinchi-s/SR/ | grep -E "PRE"
#                            PRE Batch_Pipeline_Submission/
#                            PRE ChipSeq/
#                            PRE DNA/
#                            PRE GRCh37.87/
#                            PRE GRCh37/
#                            PRE GRCh38.91/
#                            PRE GRCh38/
#                            PRE dtenenba-scripts/
#                            PRE dtenenba/
#                            PRE kallisto_out/
#                            PRE picard_fq2/
#                            PRE pizzly_out/
#                            PRE unsorted_1031/

#example
aws s3 ls --output table --color auto --human-readable --summarize  s3://fh-pi-meshinchi-s/SR/ChipSeq/

#example
aws s3 cp --recursive --dryrun --exclude "*" --include "TARGET-20-PAYKGB*" s3://fh-pi-meshinchi-s/SR/kallisto_out/ .

#check with dry run - should work for all prefixes that can be completely removes
aws s3 rm --recursive --dryrun $BUCKET/SR/DNA/

#works use this
aws s3 rm --recursive --dryrun --exclude "*" --include "*.bam" s3://fh-pi-meshinchi-s/SR/ #OK

#wait until the 28th of January before deleting any FQs
aws s3 cp --dryrun --recursive --exclude "*" --include "TARGET*.fq.gz" --exclude "*RBS*" s3://fh-pi-meshinchi-s/SR/picard_fq2/ .


#batch replicates
replicates=(TARGET-20-PAXLDJ-09A-01R TARGET-20-PAXGYZ-03A-01R TARGET-20-PAXEBW-09A-01R TARGET-20-PAWTSD-09A-01R TARGET-20-PAWMHE-09A-01R TARGET-20-PAWKIW-03A-01R TARGET-20-PAWEYY-09A-01R TARGET-20-PAVWRI-09A-01R TARGET-20-PAVTRU-09A-01R TARGET-20-PAVHWK-09A-01R TARGET-20-PAVBVP-09A-01R TARGET-20-PAUVIB-09A-01R TARGET-20-PAUUTI-09A-01R TARGET-20-PATISD-09A-01R TARGET-20-PATGIG-03A-01R TARGET-20-PATESX-09A-01R TARGET-20-PASRLS-09A-01R TARGET-20-PASLTF-09A-01R TARGET-20-PASIEJ-09A-01R TARGET-20-PARVSF-09A-01R TARGET-20-PALHWN-09A-01R TARGET-00-BM5776-14A-01R TARGET-00-BM5759-14A-01R TARGET-00-BM5756-14A-01R TARGET-00-BM5751-14A-01R TARGET-00-BM5682-14A-01R TARGET-00-BM5233-14A-01R TARGET-00-BM5136-09A-01R TARGET-00-BM5108-09A-01R TARGET-00-BM4641-14A-01R TARGET-00-BM4616-14A-01R TARGET-00-BM4508-14A-01R TARGET-00-BM4473-14A-01R TARGET-00-BM4404-14A-01R TARGET-00-BM4203-14A-01R TARGET-00-BM3969-14A-01R TARGET-00-BM3897-14A-01R )

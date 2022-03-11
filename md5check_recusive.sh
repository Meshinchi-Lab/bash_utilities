

findpath () {
	find $1 -type f -regex "^.+\.bam$"
}

#Loop through each directory
for dir in $(ls -1d *)
do
	echo $dir
	path=$( findpath $dir ) #use find to get whole filepaths for each coverage file
	#Check the MD5sums
	lastDir=$(dirname $path | uniq)
	find  $lastDir -type f -name "*md5sum*" -exec cat {} \; > $lastDir/checklist.chk
	md5check=$(cd $lastDir; md5sum -c checklist.chk)

	#If any MD5 errors, save it to a text file in the destination directory
	if ! echo "$md5check" | grep -E -q "OK"
	then
		echo "$md5check" | grep -E -v "OK" > 000_MD5_Errors.txt
	fi

done

#! bin/bash/

#remove blank lines usingg the sed  and the  regular expression
sed '/^\s*$/d' CGI_USI_file_mapping.txt > CGI_USI_file_mapping2.txt

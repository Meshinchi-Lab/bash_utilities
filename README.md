# General Bash Utility Scripts 
### for bash_utilities
Including file renaming, and running data processing on the HPC using SLURM job scheduler. 


#### BCCA Downloads

For BCCA Downloads from the FTP site use the bash script `sbatch_job_scripts/rclone_bcgsc_download.sh`. 

Rclone must be configured to include the BCCA FTP username and password on the command line prior to use this script. The instructions to configure the Rclone to connect to an FTP site are found at this [link](https://rclone.org/ftp/). An example is below of the BCCA Credentials to include in the Rclone config step. The username and password will be emailed from BCCA to retrieve the data. 

SERVER: servername.bcgsc.ca<br>
PROTOCOL: SFTP (SSH File Transfer Protocol)<br>
USERNAME: DATA-000<br>
PASSWORD: ABCdefGHI<br>
DIRECTORY: /DIR_NAME/<br>

On the commandline, you can interactively add username, password, and FTP server from the email.  Follow the initial prompts based on the documentation in the rclone website. When prompted for `host` enter `servername.bcgsc.ca`, `user` enter `DATA-000`, and `FTP password` enter `ABCdefGHI`. All other prompts, use the default. 

```
rclone config
```

Once that is completed, update the SBATCH array size in `sbatch_job_scripts/rclone_bcgsc_download.sh` to be the number of files hosted on the BCCA FTP server, for example this line `#SBATCH --array=1-2130%10` defines that there will be 2,130 jobs submitted to the Gizmos, and 10 jobs will be allowed to run at a time. For more details on SLURM job scheduler and job arrays can be found in the references.

Then follow the prompts 

#### AWS S3 Bucket 

Examples of copying and downloading data from the Meshinchi Lab S3 Bucket can be found at: 
* file_renaming/AWS_S3_Example_Commands.sh
* sbatch_job_scripts/Upload_Rename_Fastqs_S3.sh
* sbatch_job_scripts/Upload_Rename_MD5check_S3.sh
* sbatch_job_scripts/Upload_Rename_S3.sh
* sbatch_job_scripts/Upload_S3.sh
* sbatch_job_scripts/Upload_S3Bucket_to_S3Bucket.sh
* sbatch_job_scripts/Upload_and_MD5Check_S3.sh

It may also be beneficial to configure [Rclone to connect to AWS S3](https://rclone.org/s3/), or to use the [Boto3](https://aws.amazon.com/sdk-for-python/) python package. 


Author: Jenny Leopoldina Smith<br>
ORCID: [0000-0003-0402-2779](https://orcid.org/0000-0003-0402-2779)
<br>

### References

* [SLURM at Fred Hutch](https://sciwiki.fredhutch.org/scicomputing/compute_jobs/)
* [SLURM SBATCH commands](https://slurm.schedmd.com/sbatch.html)
* [Rclone at Fred Hutch](https://sciwiki.fredhutch.org/compdemos/Economy-storage/#rclone)
* [AWS S3 at Fred Hutch](https://sciwiki.fredhutch.org/compdemos/Economy-storage/#amazon-web-services-s3-compatibility-layer)

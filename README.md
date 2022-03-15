# General Bash Utility Scripts 
### for bash_utilities
Including file renaming, and running data processing on the HPC using SLURM job scheduler. 


#### BCCA Downloads
For BCCA Downloads from the FTP site use the bash script `sbatch_job_scripts/rclone_bcgsc_download.sh`. 

Rclone must be configured to include the BCCA FTP username and password on the command line prior to use this script. The instructions to configure the Rclone to connect to an FTP site are found at this [link](https://rclone.org/ftp/). 

Once that is completed, update the SBATCH array size to be the number of files hosted on the BCCA FTP server, for example this line `#SBATCH --array=1-2130%10` defines that there will be 2,130 jobs submitted to the Gizmos, and 10 jobs will be allowed to run at a time. For more details on SLURM job scheduler and job arrays can be found in the references.

Author: Jenny Leopoldina Smith<br>
ORCID: [0000-0003-0402-2779](https://orcid.org/0000-0003-0402-2779)
<br>

### References

* [SLURM at Fred Hutch](https://sciwiki.fredhutch.org/scicomputing/compute_jobs/)
* [SLURM SBATCH commands](https://slurm.schedmd.com/sbatch.html)

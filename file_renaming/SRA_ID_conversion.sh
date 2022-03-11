#! /bin/bash
#SBATCH -n 1
#SBATCH -o SRA_ID_Convert

source /app/Lmod/lmod/lmod/init/bash

module load R/3.2.2

echo module loaded 


#install the SRAdb package
source("https://bioconductor.org/biocLite.R")
biocLite("SRAdb")

#load the library
library(SRAdb)


getwd()
# setwd("X:/fast/meshinchi_s/dbGAP/BAM")
setwd("/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/miRNAseq/level3/")



#create a list of BAM file names
# files <- dir(pattern = "*.bam")
# 
# files
# 
# length(files)
#115 BAM files 


#create a list of the SRR accessions
# accessions <- unique(gsub("(SRR[0-9]+)\\.+b.+", "\\1", files))
accessions <- read.table("PRJNA89525_SRR_Acc_List_AML_TARGET_miRNAseq.txt", header = FALSE, sep = "\t")

accessions 

dim(accessions)


#download and unzip the SRAmetadb - the metadata SQL database
#this takes about 10 min. 
sqlfile <- getSRAdbFile()



#file Information
file.info('SRAmetadb.sqlite')


#create a connection to the database
sra_con <- dbConnect(SQLite(), sqlfile)

#List the tables
sra_tables <- dbListTables(sra_con)

sra_tables

#list the feilds of the table sra_ft
dbListFields(sra_con, "sra_ft")



# #Create a query to the sra database
res <- dbGetQuery(sra_con, "select * from sra_ft where run_accession='SRR1342654'")
# 
# #note these are TCS - BCCA data
# res
# 
# 
# #only request the necessary sample ID 
# #run_accession and sample_alias
# res_targetID <-  dbGetQuery(sra_con, "select sample_alias, run_accession from sra_ft where run_accession='SRR1342654'")
# 
# res_targetID



#create a function to query the database. 
# getSampleIDs <- function(accession, conndb) {
  # query <- sprintf("select sample_alias, run_accession from sra_ft where run_accession='%s'", accession )
  # result <- dbGetQuery(conndb, query)
  # return(result)
# }




# #request all SRR accessions from the database. This accessions must be a character vector. 
# #this output must be transposed since it has accession and run access 
# allRes <- sapply(accessions[,1], getSampleIDs, conndb=sra_con)

# # possible alternative to have a better formatted output. Not yet tested. 
# #allRes <- do.call(rbind, sapply(accessions, getSampleIDs, sra_con, simplify = FALSE))

# head(allRes)

# #transpose the allRes so that sample alias and run accession are column headers. 
# allRes.t <- t(allRes)

# head(allRes.t)
# dim(allRes.t)

# #delete an extra slash character. 
# allRes.t <- gsub("\"", "", allRes.t)
# head(allRes.t)

#write the results to a file. 
write.table(res, file = "miRNAseq_BCCA_BAM_IDmap_2017.03.08.txt", quote = FALSE, sep = "\t", row.names = FALSE)

save(res, file = "miRNAseq_BCCA_BAM_IDmap_2017.03.08.RData")

#disconnect from the database
dbDisconnect(sra_con)



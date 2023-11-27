#
# Main.R
# Module pulls out fields from ukbb and wites it to hdfs5 file
# Start: Initial basket ukbXXX
# 2) 2nd basket: ukbXXX.tab (blood assay)
#
# To do: update module to add compund fields
#
#---------------------------------------------
#
# Set relative path an source enviroment
#

rm(list= ls())
set.seed(42)
DIR <- system(intern=TRUE,ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")



# --------------------------------------------------
#
# source projec env.
#


# source main project env vairables
wd <- getwd();source("proj_env.R");setwd(wd)
if(wd  != getwd()) { print("ERROR: wrong working dir")}


# --------------------------------------------------
#
# inputs
#


args <- commandArgs(trailingOnly = TRUE)
ukbPheno.fn = args[1]
ukbMeta.fn = args[2]
initial = args[3] # TRUE/FALSE
ukbAdd.h5 = args[4] # None | <file name of h5 >

print(ukbPheno.fn)
print(ukbMeta.fn)
print(initial)
print(ukbAdd.h5)

# Test
#ukbMeta.fn <- "/unity/projects/0002_ZS/00017_UKBB/data/PHENOTYPE/ukb673220.html"
#ukbPheno.fn <- "/unity/projects/0002_ZS/00017_UKBB/data/PHENOTYPE/ukb673220.tab"
#initial <- "TRUE"
# ukbAdd.h5 = "..."

DIROUT <- dirname(ukbPheno.fn)

#stop("test")

#---------------------------------------------
#
# Load libs.
#   

source("binLoc/load.R")


# ---------------------------------------------
#
# Load and structure meta data
#   

source("binLoc/ukbFieldsloadMetadata.R")
source("binLoc/ukbFieldsloadMetadata_v2.R")



# ---------------------------------------------
#
# generate HDF5 
#   


if( initial == "TRUE")
    source("binLoc/reformatPhenoCreateH5.R")


# ---------------------------------------------
#
# add to existing HDF5 
#   


if( initial == "FALSE")
  source("binLoc/addUkbFieldsToH5.R")


# ---------------------------------------------
#
# End message
#   

if(initial == "TRUE") 
  print(paste("H5 file ",h5.fn, "created"))


if(initial == "FALSE") 
  print(paste("Data from ", ukbPheno.fn, "added to:", ukbAdd.h5))



###########################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF EOF #
###########################################################






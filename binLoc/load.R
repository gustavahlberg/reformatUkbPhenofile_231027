# source("https://bioconductor.org/biocLite.R")
# biocLite("HDF5Array")


library(rhdf5)
library(XML)
library(dplyr)
library(data.table)
library(lubridate)
## library(doMC)
## library(R.utils)
## library(HDF5Array)
## library(DelayedArray)
## library(devtools)


# source projectdir/lib
for(file in list.files(PROJ_LIB,full.names = T)) {
  source(file)
}



#
# Convenient functions for creating H5 
# phenotype file
#
# ---------------------------------
#
# write H5
#


writeH5 <-  function(group, name, tab) {
  subtab = as.matrix(tab[group, 1:dim(tab)[2]])
  h5write(subtab, gid, name = name, index = list(group, 1:dim(tab)[2]))
  return(NULL)
}

#h5writeDataset.array

# ---------------------------------
#
# make dataset and write
#

makeH5datasetNwrite <- function(gid, field, tab, dataType, block_size = 5000, level = 9 ) {
  
  if(is.vector(tab)) tab = as.matrix(tab)
  tab = as.matrix(tab)
  rows = dim(tab)[1]
  
  if(dataType == "character"){
  
    maxChar = max(sapply(1:dim(tab)[2],function(i) max(nchar(tab[,i]))))
    h5createDataset(gid,
                    dataset = field,
                    dims = dim(tab),
                    level=level,
                    chunk = c(block_size, dim(tab)[2]),
                    storage.mode= dataType,
                    size = maxChar + 1
    )
  } else{ 
    h5createDataset(gid,
                    dataset = field,
                    dims = dim(tab),
                    level=level,
                    chunk = c(block_size, dim(tab)[2]),
                    storage.mode= dataType
    )
  }
  
  if(dim(tab)[2] > 2) {
    grouped = split(1:rows,  (1:rows-1) %/% block_size)
    lapply(grouped, FUN = writeH5, name = field, tab = tab)

  } else {
    h5write(tab, gid, field)
  }

  return(paste("wrote H5 dataset:", field))

}


# gid <- H5Gopen(fid, "Test")
# makeH5datasetNwrite(gid = gid, 
#                     field = "test_8", 
#                     tab = tab,
#                     dataType = "character")
# 


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################

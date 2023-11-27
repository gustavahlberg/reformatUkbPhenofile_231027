#
# description: takes a ukb field h5 datset and vector of 
# data codings of interest. Returns index vector of 
# 
#
# input: did (h5 dataset), codes (e.g. icd codes)
#
# e.g. definePhenotype(h5read(h5.fn,"f.41202/f.41202") , c("I48","I48.0","I48.1","I48.2","I48.3","I48.4","I48.9"))
#
# -----------------------------------------------


defineUkbPhenotype = function(did, codes) {
  
  dMat <- DelayedArray(H5Dread(did))
  tmp <- sapply(1:dim(dMat)[2], function(i){
    list(which(as.vector.DelayedArray(dMat[,i])  %in% codes))
  })
  return(unique(unlist(tmp[lengths(tmp) > 0])))

}

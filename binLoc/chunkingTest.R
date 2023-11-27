writeH5 <-  function(group, name) {
  subtab = as.matrix(tab[group, 1:dim(tab)[2]])
  h5write(subtab, gid, name = name, index = list(group, 1:dim(tab)[2]))
  return(NULL)
}


dataType = "character"
rows = dim(tab)[1]

fid <- H5Fopen(h5.fn)
gid <- H5Gcreate(fid, "Test")

blocks = c(1000,5000, 50000,100000,200000)
maxChar =  max(sapply(1:dim(tab)[2],function(i) max(nchar(tab[,i]))))


for(i in 1:length(blocks)) {

  field = paste("test_",i,sep = "")
  block_size = blocks[i]
  
  print(paste("block size:", block_size))
  
  h5createDataset(gid, 
                  dataset = field,
                  dims = dim(tab),
                  level=9,
                  chunk = c(block_size, dim(tab)[2]),
                  storage.mode= dataType,
                  size = maxChar + 1
  )
  
  grouped = split(1:rows,  (1:rows-1) %/% block_size)
  lapply(grouped, FUN = writeH5, name = field)
    
}




H5close()
h5ls(h5.fn)


# ----------------------------------
# read all

systemTime <- list()
for(i in 1:length(blocks)) {
  
  field = paste("Test/test_",i,sep = "")
  systemTime[[i]] <- system.time(h5read(h5.fn, field))
  
}


do.call(rbind, systemTime)


# ----------------------------------
# index read


rows <- sample(x = seq_len(dim(tab)[1]), size = 100000, replace = FALSE) %>% sort()

rows <- sample(x = seq_len(dim(tab)[1]), size = 10000, replace = FALSE) %>% sort()


systemTime <- list()
for(i in 1:(length(blocks) - 2)) {
  
  block_size = 500
  rows_grouped <- split(rows,  (rows-1) %/% block_size)
  field = paste("Test/test_",i,sep = "")
  
  systemTime[[i]] <- system.time(lapply(rows_grouped, function(rg) {
    h5read(h5.fn, field, index = list(rg, NULL)) 
    }) %>% do.call('rbind', .))
    
  #h5read(h5.fn, field, index = list(rows, NULL))

  
}




do.call(rbind, systemTime)
head(res10)


grouped = split(1:rows,  (1:rows-1) %/% block_size)
lapply(grouped, FUN = writeH5, name = field)






####################################################


fid = H5Fopen(h5.fn)
gid = H5Gcreate(fid, "Test")
gid = H5Gopen(fid, "Test")

h5createGroup(file = h5.fn,
              group = field)


h5ls(h5.fn)

block_size = 5000
dataType = "character"
rows = dim(tab)[1]

if(dataType == "character"){
  
  maxChar = max(sapply(1:dim(tab)[2],function(i) max(nchar(tab[,i]))))
  h5createDataset(gid, 
                  dataset = field,
                  dims = dim(tab),
                  level=9,
                  chunk = c(block_size, dim(tab)[2]),
                  storage.mode= dataType,
                  size = maxChar + 1
  )
} else{
  h5createDataset(gid, 
                  dataset = field,
                  dims = dim(tab),
                  level=9,
                  chunk = c(block_size, dim(tab)[2]),
                  storage.mode= dataType
  )
}


system.time( 
  res10 <- h5read(file = h5.fn, name = "Test/f.4238")
  )

grouped = split(1:rows,  (1:rows-1) %/% block_size)


res10[group,]

group = grouped[[2]]

writeH5 <-  function(group, name) {
  subtab = as.matrix(tab[group, 1:dim(tab)[2]])
  h5write(subtab, gid, name = name, index = list(group, 1:dim(tab)[2]))
  return(NULL)
}

grouped = grouped[1:2]

lapply(grouped, FUN = writeH5, name = field)

for(group in grouped ) {
  writeH5(group, name = field)
}

lapply(grouped, FUN = writeH5, name = field)
  

subtab = as.matrix(tab[group, 1:dim(tab)[2]])
h5write(subtab, gid, name = "Error4", index = list(group, 1:dim(tab)[2]))
return(NULL)


h5Look.fn = "/Users/gustavahlberg/Projects_2/GeneticRiskUkBio/data/ukb9222.all_fields.h5"

table(h5ls(h5Look.fn)$dclass)




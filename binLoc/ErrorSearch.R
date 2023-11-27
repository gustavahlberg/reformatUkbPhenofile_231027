
h5createDataset(h5.fn, "Error4",
                dims = dim(tab),
                level=9,
                chunk = c(228,44),
                storage.mode='character',
                size = 115 + 1
)

h5ls(h5.fn)
h5read(h5.fn, "Error3")


h5write(as.matrix(tab[251269:dim(tab)[1],]), file = h5.fn, name = "Error4", index = list(251269:dim(tab)[1], 1:44))

i = 0

floor(dim(tab)[1]/228)

for(i in 1:floor(dim(tab)[1]/228)) {
  print(i)
  j = i*228 + 1 
  k = j + 228 - 1
  subtab = as.matrix(tab[j:k,1:44])
  h5write(subtab, file = h5.fn, name = "Error3", index = list(j:k, 1:44))
}


h5writeDataset.array(as.vector(tab[,1]), gid, field,level=9)


max(sapply(1:dim(tab)[2],function(i) max(nchar(tab[,i]))))

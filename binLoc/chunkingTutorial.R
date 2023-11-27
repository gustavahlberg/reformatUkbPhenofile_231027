#
# rhdf5 Practical Tips
#
# -----------------------------
#
# Reading subsets of data
#

m1 <- matrix(rep(1:20000, each = 100), ncol = 20000, byrow = FALSE)
ex_file <- tempfile(fileext = ".h5")
h5write(m1, file = ex_file, name = "counts", level = 6)

# ----------------
## 2.1 Using the index argument

system.time(
  res1 <- h5read(file = ex_file, name = "counts")
)

system.time(
  res1 <- h5read(file = ex_file, name = "counts", 
                 index = list(NULL, 1:10000))
)


index <- list(NULL, seq(from = 1, to = 20000, by = 2))
system.time(
  res2 <- h5read(file = ex_file, name = "counts", 
                 index = index)
)

# -----------------
## 2.2 Using hyperslab selections

start <- c(1,1)
stride <- c(1,2)
block <- c(100,1)
count <- c(1,10000)
system.time(
  res3 <- h5read(file = ex_file, name = "counts", start = start,
                 stride = stride, block = block, count = count)
)

identical(res2, res3)


# -----------------
## 2.3 Irregular selections

set.seed(1234)
columns <- sample(x = seq_len(20000), size = 10000, replace = FALSE) %>% sort()

f1 <- function(cols, name) { 
  h5read(file = ex_file, 
         name = name, 
         index = list(NULL, cols))
}


system.time(
  res4 <- vapply(X = columns, FUN = f1, 
                 FUN.VALUE = integer(length = 100), 
                 name = 'counts')
  )

dim(m1)

h5createDataset(file = ex_file, dataset = "counts_chunked", 
                dims = dim(m1), storage.mode = "integer", 
                chunk = c(100,100), level = 6)

h5write(obj = m1, file = ex_file, name = "counts_chunked")


system.time(res5 <- vapply(X = columns, FUN = f1, 
                           FUN.VALUE = integer(length = 100), 
                           name = 'counts_chunked'))


f2 <- function(block_size = 100) {
  cols_grouped <- split(columns,  (columns-1) %/% block_size)
  res <-  lapply(cols_grouped, f1, name = 'counts_chunked') %>% do.call('cbind', .)
}

system.time(f2(block_size = 1))

# shopt -s dotglob
#du -hs  "$HOME"/* | sort -hr | head -n3




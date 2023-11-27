#
# description: cut out columns in ukb phenotype file
# 
#
#
# -----------------------------------------------


cutNreadTable <- function(table.fn, idxCol, dataCode) {


  if(sum(grepl("TextCoded", dataCode)) > 0) {
      tab <- fread(table.fn,
                   select = idxCol,
                   sep="\t", 
                   header = T, 
                   quote = "",
                   tz="",
                   data.table = FALSE)
  } else {
      tab <- fread(table.fn,
                   select = idxCol,
                   sep="\t", 
                   header = T,         
                   tz="",
                   data.table = FALSE
                   )
  }
  
  return(tab)
  
}



cutNreadTableOld <- function(table.fn, idxCol, dataCode) {
  cmd = paste("cut -f", paste(idxCol,collapse = ","), table.fn)

  if(sum(grepl("TextCoded", dataCode)) > 0) {
    tab <- read.table(pipe(cmd), 
                      sep="\t", 
                      header = T, 
                      as.is = T, 
                      comment.char = '', 
                      quote = "")
  } else {
    tab <- read.table(pipe(cmd), 
               sep="\t",
               header = T, 
               as.is = T,
	       comment.char = '')
  }
  
  return(tab)
  
}

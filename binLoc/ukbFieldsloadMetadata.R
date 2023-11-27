#
# 
# Load ukb meta field description tables
#
# --------------------------------------------------
#
# 
#


##  set path
# local
catDir <- paste(PROJ_DIR,"/categories",sep = "")
# server 
#catDir <- "/home/projects/cu_10039/data/UKBB/fieldKeys"

fieldsTables.fn <-list.files(catDir,full.names = T)
fieldsTables.fn = fieldsTables.fn[grep("tsv",fieldsTables.fn)]

categoryList <- list()
for(i in 1:length(fieldsTables.fn)) {
  #i = 5
  fieldsTable.fn <- fieldsTables.fn[i]
  fieldsTable <- gsub(".tsv","",basename(fieldsTable.fn))
  categoryList <- c(categoryList, list(read.table(fieldsTable.fn, sep = "\t", header = T, as.is = T, quote = "", comment.char = '@')))
  
}

fieldsTables <- gsub(".tsv","",basename(fieldsTables.fn))
names(categoryList) <- fieldsTables


categories.df <- (do.call(rbind, categoryList))


###############################################################
# EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF #
###############################################################

#
#
# Create pheno fields with all fields
# except compund fields "3066"  "4205"  "10697" "40010"
#
# -------------------------------

print("Running script makeUkbAllFieldsH5.R")

# -------------------------------
#
# create h5
#


system(paste("rm ", h5.fn))
file.exists(h5.fn)

h5createFile(h5.fn)

# status message
print(date())
print(paste("created h5 file: ", h5.fn))

# -------------------------------
#
# add samples names
#


cmd <- paste("cut -f", 1, ukbPheno.fn)
tab <- read.table(pipe(cmd), sep="\t",header = TRUE, colClasses = "character")

h5createDataset(h5.fn, "sample.id",
                dims = dim(tab),
                level=9,
                storage.mode = storage.mode(tab$f.eid),
                chunk = c(10000, dim(tab)[2]),
                size = max(nchar(tab$f.eid)) + 1
                )

h5write(tab$f.eid, h5.fn, "sample.id")



# ---------------------------------
#
# Subset pheno file to fields and load
#

mainField <- gsub("f\\.(\\d+)\\.?\\.\\d+\\.\\d+","\\1", header, perl = TRUE)
icdFields <- unique(categories.df$Field.ID[grep("ICD", categories.df$Description)])
compoundFields <- categories.df$Field.ID[grep("CompundFields", rownames(categories.df))]

ids <- unique(mainField)
ids <- ids[!ids == "f.eid"]

# exclude compund fields
ids <- ids[!ids %in% compoundFields]




# ---- #


fid <- H5Fopen(h5.fn)

#### first loop here
for(id in ids) {
  
  #Test runs
  #id = ids[1]
  
  # reset dataCode  
  dataCode <- ""
  
  idxCol <- which(mainField %in% id)
  
  #skip compound fileds that are not in phenofile
  if(length(idxCol) == 0) {next}
  
  
  fields <- header[idxCol]
  field <- gsub("(f\\.\\d+)\\..+","\\1", fields[1])
  
  # create and open group
  gid <- H5Gcreate(fid, field)
  
  
  # ------------------------
  ## add attribute and get data type
  # attr. 1
  
  
  fD <- fieldData[gsub("(\\d+)\\-.+","\\1", fieldData$UDI) == id,][1,]

  
  attr.df <- data.frame(Field.ID = NA, Description= NA, Category=NA )
  # attr. 2
  if(sum(categories.df$Field.ID %in% id) > 0 ) {
    # get attributes from tables
    attr.df <- categories.df[categories.df$Field.ID %in% id,]
    dataCode <- rownames(categories.df[categories.df$Field.ID %in% id,])
  }
  
  # add attrb to field
  addAttributeData(gid = gid , type = fD$Type, field = id , 
                   description_1 = fD$Description, 
                   description_2 = attr.df$Description,
                   category = attr.df$Category )
  


  
  # ------------------------
  # extract data 

    tab <- cutNreadTable(ukbPheno.fn, 
                         idxCol, 
                         dataCode = dataCode
                         ) 


    # if date
    if(is.Date(tab[,1])) {
        tab <- apply(tab, 2, as.character)
    }
             
    tab[is.na(tab)] <- -9999
  

    dataType <- ifelse(is.numeric(tab[,1]), "double", "character")
  
  # ------------------------
  # write data to H5
  
  
  # if field is compound data coded
  if(id %in% compoundFields) {
    for(i in 1:length(fields)) {
      f <- fields[i]
      h5writeDataset(as.vector(tab[,i]), gid, f, level=9)
    }
  } else {
    #create not compund dataset 
    #if(dim(tab)[2] > 1) {
      
      makeH5datasetNwrite(gid = gid,
                          field = field,
                          tab = tab,
                          dataType = dataType,
                          level = 9,
                          block_size = 10000)
      
      #h5writeDataset.matrix(as.matrix(tab), gid, field,level=9)
    #} else{
    #  h5writeDataset.array(as.vector(tab[,1]), gid, field,level=9)
    
    #}
    
    #add colnames as attributes
    did <- H5Dopen(gid, field)
    h5writeAttribute(colnames(tab), did, field)
    H5Dclose(did)
  }
  
  #print status
  print(paste("Created field:", field))
  #close group
  H5Gclose(gid)
  
}

H5close()
print(paste("completed writting all fields in", h5.fn))
h5ls(h5.fn)

#h5read(h5.fn, "f.10697/f.10697.0.1")





#
# 
# Add fields to existing h5 phenotype file
#
#
# ----------------------------------


print("running script addUkbFieldsToH5.R")


# -------------------------------
#
# Set h5 file
# 

h5.fn = ukbAdd.h5

# -------------------------------
#
# open header
# 

#ukbPheno.fn = "/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb28609.tab"
#ukbPheno.fn = "/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb29359.tab"
#ukbPheno.fn = "/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb39514.tab"

header <- colnames(read.table(ukbPheno.fn, sep="\t",
                              nrows = 1, 
                              header = T, 
                              as.is = T)
)

# -------------------------------
#
# Get sample ids
# 


cmd = paste("cut -f", 1, ukbPheno.fn)
sample.id.nonorder <- read.table(pipe(cmd), sep="\t",header = T,colClasses = "character")$f.eid


# ---------------------------------------------
#
# Remove withdrawn samples
#

## h5.fn = "/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb41714.all_fields.h5"
## newF = (h5ls(h5.fn))
## new = data.frame(sample.id = h5read(h5.fn, "sample.id")[,1],
##            age = h5read(h5.fn, "f.21022/f.21022")[,1],
##            sex = h5read(h5.fn, "f.31/f.31")[,1],
##            rbc = h5read(h5.fn, "f.30010/f.30010")[,1],
##            albumin = h5read(h5.fn, "f.30600/f.30600")[,1],
##            stringsAsFactors = F)

## rownames(new) = new$sample.id

## h5.fn = "/home/projects/cu_10039/data/UKBB/phenotypeFn/ukb39513.all_fields.h5"
## oldF = (h5ls(h5.fn))
## old = data.frame(sample.id = h5read(h5.fn, "sample.id")[,1],
##            age = h5read(h5.fn, "f.21022/f.21022")[,1],
##            sex = h5read(h5.fn, "f.31/f.31")[,1],
##            rbc = h5read(h5.fn, "f.30010/f.30010")[,1],
##            albumin = h5read(h5.fn, "f.30600/f.30600")[,1],
##            stringsAsFactors = F)

## rownames(old) = old$sample.id

## old[!old$sample.id %in% new$sample.id,]
## new[!new$sample.id %in% old$sample.id,]
## samples.int = intersect(new$sample.id,old$sample.id)


## all(old[samples.int,]$albumin == new[samples.int,]$albumin)


# ---------------------------------------------
#
# Order based on sample ids.
#

sample.id.order = h5read(h5.fn, "sample.id")[,1]
idxOrder = match(sample.id.order, sample.id.nonorder)

# ---------------------------------------------
#
# Check that all sample names can match
#

#if(!all(sample.id.order == sample.id.nonorder[idxOrder]))
#    stop('sample ids not in right order')


# ---------------------------------
#
# Subset pheno file to fields and load
#

mainField <- gsub("f\\.(\\d+)\\.?\\.\\d+\\.\\d+","\\1",header,perl = T)
icdFields <- unique(categories.df$Field.ID[grep("ICD", categories.df$Description)])
compoundFields <- categories.df$Field.ID[grep("CompundFields", rownames(categories.df))]

ids <- unique(mainField)
ids = ids[!ids == "f.eid"]

# exclude compund fields
ids = ids[!ids %in% compoundFields]


# ---- #
fid <- H5Fopen(h5.fn)

#### first loop here
for(id in ids) {
  
  #Test runs
  #id = ids[1]

  # ----------------
  # check if group already exist
  if(any(id %in% gsub("f.","",h5ls(h5.fn)$name))) {next}
  
  # reset dataCode  
  dataCode = ""
  
  idxCol <- which(mainField %in% id)
  
  #skip compound fileds that are not in phenofile
  if(length(idxCol) == 0) { next}
  
  
  fields <- header[idxCol]
  field <- gsub("(f\\.\\d+)\\..+","\\1", fields[1])
  
  # create and open group
  gid <- H5Gcreate(fid, field)
  
  
  # ------------------------
  ## add attribute and get data type
  # attr. 1
  
  
  fD <- fieldData[gsub("(\\d+)\\-.+","\\1", fieldData$UDI) == id,][1,]
  
  
  attr.df = data.frame(Field.ID = NA, Description= NA, Category=NA )
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
  # add data
  
  tab <- cutNreadTable(ukbPheno.fn, 
                       idxCol, 
                       dataCode = dataCode
  )
  
  tab[is.na(tab)] <- -9999
  
  dataType = ifelse(is.numeric(tab[,1]), "double", "character")
  
  # ------------------------
  # sort data to match order of existing h5file
  

  if(dim(tab)[2] <= 1) {
      colname <- colnames(tab)
      tab = as.matrix(tab[idxOrder,])
      colnames(tab) <- colname
      } else { tab = tab[idxOrder,]}
  
  #colnames(tab) <- colname
  # precaution added 200504
  tab[is.na(tab)] <- -9999
    
  
  # ------------------------
  # write data to H5
  
  
  # if field is compound data coded
  if(id %in% compoundFields) {
    for(i in 1:length(fields)) {
      f = fields[i]
      h5writeDataset.array(as.vector(tab[,i]), gid, f, level=9)
    }
  } else{
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
    h5writeAttribute.character(colnames(tab), did, field)
    H5Dclose(did)
  }
  
  #print status
  print(paste("Created field:", field))
  
}

H5close()
print(paste("completed writting all fields in", h5.fn))
h5ls(h5.fn)

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
# 


# h5.fn = "/Users/gustavahlberg/Projects_2/GeneticRiskUkBio/data/ukb9222.all_fields.h5"
# h5.fn = "../../dataTest/test_27581.all_fields.h5"
# h5ls(h5.fn)
# 
# sample.id = h5read(h5.fn, "sample.id")[,1]
# 
# 
# 
# icd10 <- h5read(h5.fn,"f.41202/f.41202")
# 
# 
# 
# 
# idxRand = sample(length(sample.id))
# sample.id.disorder <- sample.id[idxRand]
# icd10Rand <- icd10[idxRand,]
# dim(icd10Rand)
# 
# idxOrder = match(sample.id, sample.id.disorder)
# head(sample.id.disorder[idxOrder],10)
# head(sample.id,10)
# 
# 
# tictoc::tic()
# rownames(icd10Rand) <- as.character(sample.id.disorder)
# icd10corr = icd10Rand[as.character(sample.id),]
# tictoc::toc()
# 
# head(icd10corr[,1:10])
# head(icd10[,1:10])
# 
# all(icd10[1,] == icd10corr[1,])
# 
# tictoc::tic()
# idxOrder = match(sample.id, sample.id.disorder)
# icd10corr = icd10Rand[idxOrder,]
# tictoc::toc()
# 
# all(icd10[1,] == icd10corr[1,])

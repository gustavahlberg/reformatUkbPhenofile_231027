#
#
# Create ICD.h5, ukbCompundData.h5, ukbFields.h5
#
# -------------------------------
#
# open header
# 


header <- colnames(read.table(ukbPheno.fn, sep="\t",
                              nrows = 1, 
                              header = T, 
                              as.is = T)
)



# -------------------------------
#
# All fields
#

h5.fn <- paste(DIROUT,basename(gsub("tab","all_fields.h5", ukbPheno.fn)), sep = "/")

source("binLoc/makeUkbAllFieldsH5.R")


# -------------------------------
#
# ICD h5
#

#source("binLoc/makeIcdH5.R")


# -------------------------------
#
# ukbFields.h5, all fields excpet ICD and compund categories
#


#source("binLoc/makeUkbFields.R")


# -------------------------------
#
# ukb Soft Fields, all fields that layes under the recommended categories:
# Cognitive function summary, Diet and alcohol summary,Early life, Education and employment,
# Geographical and location, Physical measure summary, Primary demographics,
# Self-reported medical conditions	
# 


#source("binLoc/makeUkbRecommendedCategoriesFields.R")



# -------------------------------
#
# Compund h5
#


#source("binLoc/makeUkbCompundH5.R")



###############################################################
# EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF ## EOF #
###############################################################

addAttributeData <- function(gid, type, field, description_1,description_2 = NULL,category = NA  ) {
  
  
  if(identical(description_1,description_2)) description_2 = NULL
  
  type.str = paste("type:", type)
  field.str = paste("Field:", field)
  desc.str1 = paste("Description_1:", description_1)
  desc.str2 = paste("Description_2:", description_2)
  category.str = paste("Category:", category )
  
  # write attribute
  #c(type.str, field.str, desc.str1, desc.str2, category.str)
  h5writeAttribute(c(type.str, field.str, desc.str1, desc.str2, category.str),gid, field)
  
}

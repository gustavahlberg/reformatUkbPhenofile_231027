#
#
# Load ukbb basket html table
#
# ---------------------------------------------



fieldData <- readHTMLTable(ukbMeta.fn, which = 2, trim = T, stringsAsFactors = FALSE)

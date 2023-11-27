merged.fn = "../../dataTest/test_27581.all_fields.h5"
h5ls(merged.fn)


org.fn = "../../dataTest/ukb27581.all_fields.h5"
h5ls(org.fn)


org.df <- data.frame(sample.id = h5read(org.fn,"sample.id"),
                     f.23171 = h5read(org.fn,"f.23171/f.23171"),
                     stringsAsFactors = F
)

head(org.df)

merged.df <- data.frame(sample.id = h5read(merged.fn,"sample.id"),
                     f.23171 = h5read(merged.fn,"f.23171/f.23171"),
                     stringsAsFactors = F
)


all(merged.df$sample.id[merged.df$f.23171 != -9999] %in% org.df$sample.id[org.df$f.23171 != -9999])

tmp = h5read(org.fn,"f.30600/f.30600")
tmp = h5read(merged.fn,"f.30600/f.30600")
h5readAttributes(merged.fn,"f.30600/f.30600")

h5.fn = "/Users/gustavahlberg/Projects_2/GeneticRiskUkBio/data/ukb9222.all_fields.h5"
h5ls(h5.fn)

tmp = h5read(h5.fn,"f.136")
h5readAttributes(h5.fn,"f.136/f.136")

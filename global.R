load("miEset.Rda")
#miEset is an object called ExpressionSet which stores expression and information about data
#download this package called affy (ExpressionSet is from package affy)
library(affy)
exp = t(exprs(miEset))
#rows are different cell lines and columns are miRNAs (they are like genes)
#cell lines are from different cancer types
# exp is expression value of miRNAs in these cell lines
rownames(exp)<-pData(miEset)$tissue.name
sortedgroup<-names(sort(table(pData(miEset)$tissue.name),dec=TRUE))
as.fumeric <- function(x,levels=unique(x)) as.numeric(factor(x,levels=levels))

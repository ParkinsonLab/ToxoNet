library(parmigene)
args<-commandArgs(trailingOnly = TRUE)
mi<-read.csv(file=args[1],sep="\t",head=TRUE)
mi<-mi[-1]
mi<-as.matrix(mi)
mi[is.nan(mi)]<-0
mi[is.na(mi)]<-0
clr_mi<-clr(mi)
write.table(clr_mi)

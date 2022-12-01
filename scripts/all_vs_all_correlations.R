args<-commandArgs(trailingOnly = TRUE)
f<-read.csv(file=args[1],sep=",",head=TRUE)
correlations<-cor(f,use="complete.obs",method="pearson")
write.csv(correlations,file=args[2])

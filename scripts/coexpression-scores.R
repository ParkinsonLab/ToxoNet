args<-commandArgs(trailingOnly = TRUE)
file<-read.csv(file=args[1],sep="\t",head=TRUE)
file<-file[-1]
t<-t(file)
cor_pearson<-cor(t,use="all.obs",method="pearson")
cor_spearman<-cor(t,use="all.obs",method="spearman")
write.table(cor_pearson,file=args[2])
write.table(cor_spearman,file=args[3])

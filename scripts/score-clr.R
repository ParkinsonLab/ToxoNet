library(parmigene)
args<-commandArgs(trailingOnly = TRUE)
score<-read.csv(file=args[1],sep="\t",head=TRUE)
score<-score[-1]
score<-score[-ncol(score)]
score<-as.matrix(score)
score[is.nan(score)]<-0
score[is.na(score)]<-0
clr_score<-clr(score)
write.table(clr_score,file=args[2])

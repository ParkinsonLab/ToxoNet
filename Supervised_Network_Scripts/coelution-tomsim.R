library("WGCNA")
args<-commandArgs(trailingOnly = TRUE)
score<-read.csv(file=args[1],sep="\t",head=TRUE)
score<-score[-1]
score<-score[-ncol(score)]
score<-as.matrix(score)
adjacency<-adjacency.fromSimilarity(score,type="signed",power=12)
TOM<-TOMsimilarity(adjacency)
write.table(adjacency,file=args[2])
write.table(TOM,file=args[3])

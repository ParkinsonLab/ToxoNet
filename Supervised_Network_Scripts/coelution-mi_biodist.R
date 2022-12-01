library(bioDist)
args<-commandArgs(trailingOnly = TRUE)
coelution<-read.csv(file=args[1],sep="\t",head=TRUE)
coelution<-coelution[-1]
for(i in 1:nrow(coelution)){
for(j in 1:nrow(coelution)){
if(i<j){
Z<-rbind(coelution[i,],coelution[j,])
Zmat<-as.matrix(Z)
v<-mutualInfo(Zmat)
write(v,file=args[2],append=TRUE)
}}}

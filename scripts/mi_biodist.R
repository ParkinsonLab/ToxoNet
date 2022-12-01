library(bioDist)
args<-commandArgs(trailingOnly = TRUE)
phyloprofiles<-read.csv(file=args[1],sep=",",head=FALSE)
for(i in 1:nrow(phyloprofiles)){
for(j in 1:nrow(phyloprofiles)){
if(i<j){
Z<-rbind(phyloprofiles[i,],phyloprofiles[j,])
Zmat<-as.matrix(Z)
v<-mutualInfo(Zmat)
write(v,file=args[2],append=TRUE)
}}}

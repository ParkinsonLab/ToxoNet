library(wccsom)
args<-commandArgs(trailingOnly = TRUE)
coelution<-read.csv(file=args[1],sep="\t",head=TRUE)
coelution<-coelution[-1]
for(i in 1:nrow(coelution)){
for(j in 1:nrow(coelution)){
if(i<j){
v<-wcc(coelution[i,],coelution[j,],2)
write(v,file=args[2],append=TRUE)
}}}

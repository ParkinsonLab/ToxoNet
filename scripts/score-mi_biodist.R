library(bioDist)
args<-commandArgs(trailingOnly = TRUE)
matrix_file<-read.csv(file=args[1],sep="\t",head=TRUE)
matrix_file<-matrix_file[-1]
for(i in 1:nrow(matrix_file)){
for(j in 1:nrow(matrix_file)){
if(i<j){
Z<-rbind(matrix_file[i,],matrix_file[j,])
Zmat<-as.matrix(Z)
v<-mutualInfo(Zmat)
write(v,file=args[2],append=TRUE)
}}}

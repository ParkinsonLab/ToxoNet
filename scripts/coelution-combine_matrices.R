#This script cleans raw coelution data by removing columns that do not contain a
#any spectral counts at all - as this will interfere with column normalization

###
args<-commandArgs(trailingOnly = TRUE)
coelution<-read.csv(file=args[1],sep="\t",head=TRUE,row.names=1)



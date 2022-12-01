#This script cleans raw coelution data by removing columns that do not contain
#any spectral counts at all - as this will interfere with column normalization


###
args<-commandArgs(trailingOnly = TRUE)
coelution<-read.csv(file=args[1],sep="\t",head=TRUE,row.names=1)
min_fractions=args[3]
tot_peptide_counts_per_fraction=args[4]

coelution<-coelution[,colSums(coelution>0)>tot_peptide_counts_per_fraction,] #Keep columns ie. fractions which have >0 peptide counts
coelution<-coelution[rowSums(coelution>0)>=min_fractions,] #Keep rows ie. proteins whose peptides are detected in atleast 2 fractions  

write.table(coelution,file=args[2],append="TRUE")


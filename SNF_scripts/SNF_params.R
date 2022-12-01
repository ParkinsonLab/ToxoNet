#Load SNF
library(SNFtool)
## First, set all the parameters:
args <- commandArgs(trailingOnly = TRUE)
K = as.integer(args[1]);         # number of neighbors, usually (10~30)
alpha = as.double(args[2]);      # hyperparameter, usually (0.3~0.8)
T = as.integer(args[3]);      # Number of Iterations, usually (10~20)

#print(args)
#print(K)
#print(alpha)
#print(T)
#Input the different matrices into R and convert them into matrices

wcc<-read.csv(file="SM_wcc_NOHEADER_noNA.tab",sep="\t",head=FALSE)
pcc<-read.csv(file="SM_pccnoisemodel_NOHEADER_noNA_noNAN.tab",sep="\t",head=FALSE)
coapex1<-read.csv(file="SM_overall-coapex-sc1_NOHEADER_noNA.tab",sep="\t",head=FALSE)
expr<-read.csv(file="SM_expr_NOHEADER.tab",sep="\t",head=FALSE)
pij<-read.csv(file="SM_pij_NOHEADER.tab",sep="\t",head=FALSE)

wcc_matrix<-as.matrix(wcc)
pcc_matrix<-as.matrix(pcc)
coapex1_matrix<-as.matrix(coapex1)
expr_matrix<-as.matrix(expr)
pij_matrix<-as.matrix(pij)

W1_wcc<-affinityMatrix(wcc_matrix,K,alpha)
W2_pcc<-affinityMatrix(pcc_matrix,K,alpha)
W3_coapex1<-affinityMatrix(coapex1_matrix,K,alpha)
W4_expr<-affinityMatrix(expr_matrix,K,alpha)
W5_pij<-affinityMatrix(pij_matrix,K,alpha)

W_5sm=SNF(list(W1_wcc,W2_pcc,W3_coapex1,W4_expr,W5_pij),K,T)

write.table(W_5sm,file=args[4]);

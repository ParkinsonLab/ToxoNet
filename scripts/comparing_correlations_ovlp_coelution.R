#For set of proteins overlapiing with coelution set only..

f<-read.csv(file="construct_matrix_non-ts_orig_ovlp_coelution.ep",sep=",",head=FALSE)
t<-t(f)
orig_cor_pearson<-cor(t,use="all.obs",method="pearson")
orig_cor_spearman<-cor(t,use="all.obs",method="spearman")
cor.test(c(orig_cor_pearson),c(orig_cor_spearman))

#	Pearson's product-moment correlation
#data:  c(orig_cor_pearson) and c(orig_cor_spearman)
#t = 1380.2, df = 2024900, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# 0.6955178 0.6969372
#sample estimates:
#      cor 
#0.6962282 

write.csv(orig_cor_pearson,file="R_orig_cor_pearson_ovlp_coeltution.csv")
write.csv(orig_cor_spearman,file="R_orig_cor_spearman_ovlp_coeltution.csv")


a<-read.csv(file="construct_matrix_non-ts_ovlp_coelution.ep",sep=",",head=FALSE)
b<-t(a)
cor_pearson<-cor(b,use="all.obs",method="pearson")
cor_spearman<-cor(b,use="all.obs",method="spearman")
cor.test(c(cor_pearson),c(cor_spearman))

#	Pearson's product-moment correlation
#data:  c(cor_pearson) and c(cor_spearman)
#t = 1871.4, df = 2024900, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# 0.7955060 0.7965153
#sample estimates:
#      cor 
#0.7960112 

write.csv(cor_pearson,file="R_cor_pearson_ovlp_coelution.csv")
write.csv(cor_spearman,file="R_cor_spearman_ovlp_coelution.csv")

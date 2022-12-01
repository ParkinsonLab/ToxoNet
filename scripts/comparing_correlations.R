f<-read.csv(file="construct_matrix_non-ts_orig.ep",sep=",",head=FALSE)
t<-f(t)
orig_cor_pearson<-cor(t,use="all.obs",method="pearson")
orig_cor_spearman<-cor(t,use="all.obs",method="spearman")
cor.test(c(orig_cor_pearson),c(orig_cor_spearman))

	Pearson's product-moment correlation

data:  c(orig_cor_pearson) and c(orig_cor_spearman)
t = 8925.6, df = 77616000, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.7115914 0.7118110
sample estimates:
      cor 
0.7117012 


> typeof(orig_cor_pearson)
[1] "double"
> typeof(orig_cor_spearman)
[1] "double"


> a<-read.csv(file="construct_matrix_non-ts.ep",sep=",",head=FALSE)
> b<-t(a)
> typeof(a)
[1] "list"
> typeof(b)
[1] "double"
> cor_pearson<-cor(b,use="all.obs",method="pearson")
> cor_spearman<-cor(b,use="all.obs",method="spearman")
> dim(cor_spearman)
[1] 8920 8920
> dim(cor_pearson)
[1] 8920 8920
> typeof(cor_spearman)
[1] "double"
> typeof(cor_pearson)
[1] "double"
> cor.test(c(cor_pearson),c(cor_spearman))

	Pearson's product-moment correlation

data:  c(cor_pearson) and c(cor_spearman)
t = 16656, df = 79566000, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.8814969 0.8815949
sample estimates:
      cor 
0.8815459 

> cor.test(c(orig_cor_pearson),c(cor_pearson))


	Pearson's product-moment correlation

data:  c(orig_cor_pearson) and c(cor_pearson)
t = 3080, df = 77616000, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.3298132 0.3302097
sample estimates:
      cor 
0.3300114 

> cor.test(c(orig_cor_spearman),c(cor_spearman))

	Pearson's product-moment correlation

data:  c(orig_cor_spearman) and c(cor_spearman)
t = 2400.6, df = 77616000, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.2626901 0.2631043
sample estimates:
      cor 
0.2628972

> cor.test(c(orig_cor_spearman),c(cor_spearman))

	Pearson's product-moment correlation

data:  c(orig_cor_spearman) and c(cor_spearman)
t = 2400.6, df = 77616000, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.2626901 0.2631043
sample estimates:
      cor 
0.2628972 

> write.csv(cor_pearson,file="R_cor_pearson.csv")
> write.csv(cor_spearman,file="R_cor_spearman.csv")
 

===========================================================================

For set of proteins overlapiing with coelution set only..


R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
Copyright (C) 2016 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

[Previously saved workspace restored]

> f<-read.csv(file="construct_matrix_non-ts_orig_ovlp_coelution.ep",sep=",",head=FALSE)
> t<-f(t)
Error: could not find function "f"
> t<-t(f)
> orig_cor_pearson<-cor(t,use="all.obs",method="pearson")
> orig_cor_spearman<-cor(t,use="all.obs",method="spearman")
> cor.test(c(orig_cor_pearson),c(orig_cor_spearman))

	Pearson's product-moment correlation

data:  c(orig_cor_pearson) and c(orig_cor_spearman)
t = 1380.2, df = 2024900, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.6955178 0.6969372
sample estimates:
      cor 
0.6962282 

> write.csv(orig_cor_pearson,file="R_orig_cor_pearson_ovlp_coeltution.csv")
> write.csv(orig_cor_spearman,file="R_orig_cor_spearman_ovlp_coeltution.csv")
> 
> 
> a<-read.csv(file="construct_matrix_non-ts_ovlp_coelution.ep",sep=",",head=FALSE)
> b<-t(a)
> cor_pearson<-cor(b,use="all.obs",method="pearson")
> cor_spearman<-cor(b,use="all.obs",method="spearman")
> cor.test(c(cor_pearson),c(cor_spearman))

	Pearson's product-moment correlation

data:  c(cor_pearson) and c(cor_spearman)
t = 1871.4, df = 2024900, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.7955060 0.7965153
sample estimates:
      cor 
0.7960112 

> write.csv(cor_pearson,file="R_cor_pearson_ovlp_coelution.csv")
> write.csv(cor_spearman,file="R_cor_spearman_ovlp_coelution.csv")

library(dplyr)
library(gplots)

IMC <- read.csv("C:/Users/Grant/Desktop/ClusterONEd030_Analysis/EssentialClusterComposition/EssentialClusterComposition/IMCProteins_Coelutionpcc_Description_NoZero.csv",sep=",", row.names=1)
data = as.matrix(IMC)
IMCwcc <- read.csv("C:/Users/Grant/Desktop/ClusterONEd030_Analysis/EssentialClusterComposition/EssentialClusterComposition/IMCProteins_Coelutionwcc_DescriptionShort_NoZero.csv",sep=",", row.names=1)
dataWCC = as.matrix(IMCwcc)
IMCcoa <- read.csv("C:/Users/Grant/Desktop/ClusterONEd030_Analysis/EssentialClusterComposition/EssentialClusterComposition/IMCProteins_CoelutionCoapex_DescriptionShort_ge5SpectralCounts.csv",sep=",", row.names=1)
dataCOA = as.matrix(IMCcoa)
IMCNet <- read.csv("C:/Users/Grant/Desktop/ClusterONEd030_Analysis/EssentialClusterComposition/EssentialClusterComposition/IMCProteins_NetworkScores_DescriptionShort_ge5SpectralCounts.csv",sep=",", row.names=1)
dataNET = as.matrix(IMCNet)

##This one is for PCC##

library(RColorBrewer)
dev.off()
col= colorRampPalette(rev(brewer.pal(9, "BuPu")))(100)
hmcols<-colorRampPalette(c("grey","red","green"))(256)
heatmap.2(data,
          #hclustfun=function(x) hclust(x, method="average"),
          trace="none",
          dendrogram="row",
          key="true",
          density.info="none",
          key.title=NA,
          col=col)

##This one is for WCC##

library(RColorBrewer)
dev.off()
col= colorRampPalette(rev(brewer.pal(9, "BuPu")))(100)
hmcols<-colorRampPalette(c("grey","red","green"))(256)
heatmap.2(dataWCC, 
          trace="none",
          dendrogram="row",
          key="true",
          density.info="none",
          key.title=NA,
          col=col)

##This one is for COAPEX##

library(RColorBrewer)
dev.off()
col= colorRampPalette(rev(brewer.pal(9, "BuPu")))(100)
hmcols<-colorRampPalette(c("grey","red","green"))(256)
heatmap.2(dataCOA, 
          hclustfun=function(x) hclust(x, method="single"),
          trace="none",
          dendrogram="row",
          key="true",
          density.info="none",
          key.title=NA,
          col=col)



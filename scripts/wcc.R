#Load WCC package
library("wccsom")

id<-read.csv(file="matches_latest_uniprot_both.elution_profiles.proteinids",sep=",",head=FALSE)
ep<-read.csv(file="matches_latest_uniprot_both.elution_profiles.data",sep=",",head=FALSE)
> val<--300
> wcc_list<-NULL
> ct<-1
> ct<1
[1] FALSE
> ct<-1
> for(i in 1:nrow(id)){
+ for(j in 1:nrow(id)){
+ val<-wcc(ep[i,],ep[j,],2)
+ wcc_list[ct]<-val
+ ct<-ct+1
+ }}
> wcc_list
>write.csv(wcc_list,"wcc_list.csv")


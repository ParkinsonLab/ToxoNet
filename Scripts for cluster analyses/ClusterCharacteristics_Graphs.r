library(ggplot2)
library(ggthemes)
library(extrafont)
library(plyr)
library(scales)
library(gridExtra)
library(dplyr)

Characteristics <- read.csv('Characteristic_ClusterSummary_FINAL.csv')

'''
EssentialInvasion <- as.vector(Characteristics$EssentialInvasion)
DispensableInvasion <- as.vector(Characteristics$DispensableInvasion)
EssentialApiLineage <- as.vector(Characteristics$EssentialApiLineage)
DispensableApiLineage <- as.vector(Characteristics$DispensableApiLineage)
EssentialHyp <- as.vector(Characteristics$EssentialHyp)
DispensableHyp <- as.vector(Characteristics$DispensableHyp)
'''

#INVASION
ggplot(Characteristics, aes(x=Essentiality, y=Invasion, fill=Essentiality)) + 
  geom_boxplot(notch=FALSE) +
  scale_fill_manual(values=c("blue3", "gray30")) +
  scale_color_manual(values=c("blue3", "gray30")) +
  theme_classic() +
  theme(legend.position="none") +
  theme(axis.title.x=element_blank()) +
  #theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) +
  #theme(axis.title.y=element_blank(),axis.text.y=element_blank()) +
  ggtitle("Invasion and IMC Protein Compoisition") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "",y = "")

#LINEAGE
ggplot(Characteristics, aes(x=Essentiality, y=Lineage, fill=Essentiality)) + 
  geom_boxplot(notch=FALSE) +
  scale_fill_manual(values=c("blue3", "gray30")) +
  theme_classic() +
  theme(legend.position="none") +
  theme(legend.title=element_blank()) +
  #theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) +
  #theme(axis.line.y=element_blank(),axis.title.y=element_blank(),axis.ticks.y=element_blank(),axis.text.y=element_blank()) + 
  ggtitle("Lineage") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  ylab("Fraction")

#HYPOTHETICAL
ggplot(Characteristics, aes(x=Essentiality, y=Hypothetical, fill=Essentiality)) + 
  geom_boxplot(notch=FALSE) +
  scale_fill_manual(values=c("blue3", "gray30")) +
  theme_classic() +
  theme(legend.position="none") +
  theme(axis.title.x=element_blank()) +
  #theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank()) +
  #theme(axis.line.y=element_blank(),axis.title.y=element_blank(),axis.ticks.y=element_blank(),axis.text.y=element_blank())
  ggtitle("Fraction of Hypothetical Proteins") +
  theme(plot.title = element_text(hjust = 0.5))
  #ylab("Fraction")


###MAKING BAR PLOTS

ggplot(data=Characteristics, aes(x=Essentiality, y=Invasion, fill=Essentiality)) +
  geom_bar(stat="identity")

##Try as Density Plot - for Eukaryotic fraction

EssentialEuk <- filter(Characteristics,Essentiality=="Essential") %>% select(Eukaryote) %>% unlist
DispensableEuk <- filter(Characteristics,Essentiality=="Dispensable") %>% select(Eukaryote) %>% unlist


fill <- c("blue","orange")
ggplot(Characteristics, aes(Eukaryote, fill = Essentiality)) + geom_density(alpha = 0.5) +
  theme_classic() +
  labs(x = "Fraction of Eukaryotic Proteins",y = "Density") +
  ggtitle("Fraction of Eukaryotic Protein Distribution") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position="bottom") + scale_fill_discrete("") +
  scale_fill_manual(values=fill) +
  theme(legend.title=element_blank()) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE))

##Histogram

ggplot(Characteristics, aes(Eukaryote, fill = Essentiality)) + 
  geom_histogram(alpha = 0.7, aes(y=2*(..density..)/sum(..density..)), position = 'identity',bins=10, colour="black") +
  scale_y_continuous(labels=percent_format()) +
  scale_fill_manual(values=fill) +
  theme_classic() +
  labs(x = "Fraction of Eukaryotic Proteins",y = "") +
  ggtitle("Fraction of Eukaryotic Proteins Distribution") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position="bottom") +
  theme(legend.title=element_blank())



library(ggplot2)
library(dplyr)

'''
Network Centrality Stats Graphs
'''

NodeTable =  read.delim("NodeTable_Cytoscape.csv", header=TRUE, sep=",", fill=TRUE, comment.char = "", quote = "",as.is=T)
NodeTable_E =  read.delim("NodeTable_Cytoscape_Essential.csv", header=TRUE, sep=",", fill=TRUE, comment.char = "", quote = "",as.is=T)

#Node Degree/Essential Chart

NodeTable_Essentiality <- NodeTable_E %>%
  group_by(Essentiality_OrthoMCL) %>%  
  summarise(mean_Degree = mean(Degree),  
            sd_Degree = sd(Degree), 
            n_Degree = n(), 
            SE_Degree = sd(Degree)/sqrt(n())) 

essential_Color <- c("blue3","darkorange")
EssentialDegreePlot <- ggplot(NodeTable_Essentiality, aes(Essentiality_OrthoMCL, mean_Degree)) + 
  geom_col(fill = essential_Color,color='black') +  
  geom_errorbar(aes(ymin = mean_Degree - SE_Degree, ymax = mean_Degree + SE_Degree), width=0.2)

EssentialDegreePlot + 
  labs(y="Degree", x = "") + 
  theme_classic()

#Node Betweenness/Essential Chart

NodeTable_Betweenness <- NodeTable_E %>% 
  group_by(Essentiality_OrthoMCL) %>%  
  summarise(mean_Betweenness = mean(BetweennessCentrality),  
            sd_Betweenness = sd(BetweennessCentrality), 
            n_Betweenness = n(), 
            SE_Betweenness = sd(BetweennessCentrality)/sqrt(n())) 

essential_Color <- c("blue3","darkorange")
EssentialBetweennessPlot <- ggplot(NodeTable_Betweenness, aes(Essentiality_OrthoMCL, mean_Betweenness)) + 
  geom_col(fill = essential_Color,color='black') +  
  geom_errorbar(aes(ymin = mean_Betweenness - SE_Betweenness, ymax = mean_Betweenness + SE_Betweenness), width=0.2)

EssentialBetweennessPlot + 
  labs(y="Betweenness Centrality", x = "") + 
  theme_classic()

#Node Degree/Lineage Chart

NodeTable$Lineage <- factor(NodeTable$Lineage,levels = c("Eukaryotes", "Apicomplexa", "Coccidia", "Toxoplasma"))

NodeTable_Lineage <- NodeTable %>%
  group_by(Lineage) %>% 
  summarise(mean_Degree = mean(Degree), 
            sd_Degree = sd(Degree),
            n_Degree = n(), 
            SE_Degree = sd(Degree)/sqrt(n()))

Lineage_Color <- c("blue3","deepskyblue1","forestgreen","firebrick3")
LineageDegreePlot <- ggplot(NodeTable_Lineage, aes(Lineage, mean_Degree)) + 
  geom_col(fill = Lineage_Color,color='black') +  
  geom_errorbar(aes(ymin = mean_Degree - SE_Degree, ymax = mean_Degree + SE_Degree), width=0.2)

LineageDegreePlot + 
  labs(y="Degree", x = "") + 
  theme_classic()

#NETWORK AVERAGE SHORTEST PATHLENGTH GRAPH

ShortestPathLength =  read.delim("NetworkShortestPathLength.csv", header=FALSE, sep=",", fill=TRUE, comment.char = "", quote = "",as.is=T)

spl_color <- c("darkorchid")
ggplot(data=ShortestPathLength, aes(ShortestPathLength$V1,fill="black")) + 
  geom_histogram(alpha = 1, aes(y = (..count..)/sum(..count..)), position = 'identity',bins=13,binwidth = 1, colour="black") +
  scale_x_continuous(breaks=seq(1,13, by = 1)) +
  theme_classic() +
  scale_fill_manual(values=spl_color) +
  labs(x = "Shortest Path Length",y="Fraction") +
  #ggtitle("Shortest Path Length Distribution") + 
  #theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position="") +
  theme(legend.title=element_blank())

#Node ClosenessCentrality/Essential Chart

NodeTable_Essentiality <- NodeTable_E %>% 
  group_by(Essentiality_OrthoMCL) %>% 
  summarise(mean_ClosenessCentrality = mean(ClosenessCentrality), 
            sd_ClosenessCentrality = sd(ClosenessCentrality), 
            n_ClosenessCentrality = n(),  
            SE_ClosenessCentrality = sd(ClosenessCentrality)/sqrt(n())) 

essential_Color <- c("blue3","darkorange")
EssentialClosenessCentralityPlot <- ggplot(NodeTable_Essentiality, aes(Essentiality_OrthoMCL, mean_ClosenessCentrality)) + 
  geom_col(fill = essential_Color,color='black') +  
  geom_errorbar(aes(ymin = mean_ClosenessCentrality - SE_ClosenessCentrality, ymax = mean_ClosenessCentrality + SE_ClosenessCentrality), width=0.2)

EssentialClosenessCentralityPlot + 
  labs(y="Closeness Centrality", x = "") + 
  theme_classic()


#Node Eccentricity/Essential Chart

NodeTable_Essentiality <- NodeTable_E %>%
  group_by(Essentiality_OrthoMCL) %>% 
  summarise(mean_Eccentricity = mean(Eccentricity),  
            sd_Eccentricity = sd(Eccentricity), 
            n_Eccentricity = n(),  
            SE_Eccentricity = sd(Eccentricity)/sqrt(n())) 

essential_Color <- c("blue3","darkorange")
EssentialEccentricityPlot <- ggplot(NodeTable_Essentiality, aes(Essentiality_OrthoMCL, mean_Eccentricity)) + 
  geom_col(fill = essential_Color,color='black') +  
  geom_errorbar(aes(ymin = mean_Eccentricity - SE_Eccentricity, ymax = mean_Eccentricity + SE_Eccentricity), width=0.2)

EssentialEccentricityPlot + 
  labs(y="Eccentricity", x = "") + 
  theme_classic()


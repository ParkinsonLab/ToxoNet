library("dplyr")
library("ggplot2")

ClusterExpression <- read.csv("ClusterExpressionSummary_FinalClusters.csv")

#PLOTS WITHOUT USING GGPLOT
ClusterAverage <- select(ClusterExpression,average_expression_correlation) %>% unlist
ClusterNetworkAverage <- select(ClusterExpression,average_random_expression_correlation) %>% unlist
pvalue <- select(ClusterExpression,p_value) %>% unlist
plot(ClusterNetworkAverage,ClusterAverage, col=ifelse(pvalue>0.05, "black", "red"), xlab = "Average Expression Correlation", ylab = "Average Random Correlation")
title("Cluster Expression")


ggplot(ClusterExpression, aes(average_random_expression_correlation,average_expression_correlation,color=factor(significant)))+geom_point() +
  theme_bw() +
  theme(legend.title=element_blank()) +
  scale_color_manual(values=c("black","red")) +
  labs(x = "Average Correlation with Network Proteins",y = "Average Correlation of Cluster") +
  ggtitle("Cluster Expression Correlation") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position="bottom") + scale_fill_discrete("") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  scale_x_continuous(limits = c(-0.1,1)) + 
  scale_y_continuous(limits = c(-0.1,1))


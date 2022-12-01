library(ggplot2)
library(ggthemes)
library(extrafont)
library(plyr)
library(scales)
library(gridExtra)

ExpressionDistribution <- read.csv("ExpressionPCC_FINAL.csv",header = FALSE)
ExpressionDistribution$type <- 'Network Interactions'
ExpressionDistributionList = as.vector(ExpressionDistribution$V3)

NetworkExpressionDistribution <- read.csv("ExpressionPCC_RANDOM_FINAL.csv",header = FALSE)
NetworkExpressionDistribution$type <- 'Network Non-Interacting Proteins'
NetworkExpressionDistributionList = as.vector(NetworkExpressionDistribution$V3)

ProteomeExpressionDistribution <- read.csv("ProteomeProteins_Reduced__Boothroyd_Gregory_Reid.csv",header = FALSE)
ProteomeExpressionDistribution$type <- 'Random Proteome'
ProteomeExpressionDistributionList = as.vector(ProteomeExpressionDistribution$V3)

FullProteomeDistribution <- rbind(ExpressionDistribution,NetworkExpressionDistribution,ProteomeExpressionDistribution)
FullProteomeDistribution$V1 <- NULL
FullProteomeDistribution$V2 <- NULL

ks.test(ExpressionDistributionList,NetworkExpressionDistributionList)
ks.test(ExpressionDistributionList,ProteomeExpressionDistributionList)

ExpressionDistributionList.ecdf = ecdf(ExpressionDistributionList)
NetworkExpressionDistributionList.ecdf = ecdf(NetworkExpressionDistributionList)
ProteomeExpressionDistributionList.ecdf = ecdf(ProteomeExpressionDistributionList)

plot(NetworkExpressionDistributionList.ecdf, xlab = 'Expression Correlation', ylab = '', main = 'Empirical Cumluative Distribution\nof Pairwise Coexpression Correlation')

#THIS GIVES THE DENSITY PLOT FOR ALL THREE

fill <- c("red","blue","green")
ggplot(FullProteomeDistribution, aes(V3, fill = type)) + geom_density(alpha = 0.2) +
  theme_classic() +
  labs(x = "Coexpression Correlation",y = "Density") +
  ggtitle("Pairwise Expression Correlation") + theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position="bottom") + scale_fill_discrete("") +
  scale_fill_manual(values=fill) +
  theme(legend.title=element_blank()) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE))


#THIS GIVES THE ECDF PLOT FOR ALL THREE

d <- data.frame(x = c(-1,1))
ll <- Map(f  = stat_function, colour = c('red', 'blue', 'green'),
          fun = list(ExpressionDistributionList.ecdf,NetworkExpressionDistributionList.ecdf,ProteomeExpressionDistributionList.ecdf), geom = 'step')
ggplot(data = d, aes(x = x)) + ll +
  theme_classic() +
  ggtitle("Empirical Cumulative Distribution") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "Coexpression Correlation",y = "Cumulative Fraction")
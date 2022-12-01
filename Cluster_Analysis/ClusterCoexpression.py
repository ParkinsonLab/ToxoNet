#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  4 18:01:37 2018

@author: grantstevens
"""

import numpy as np
import pandas as pd
import random
from pandas import DataFrame
import statistics as s
import math
from scipy import stats

def pcc(listx,listy):
    averagex = sum(listx)/len(listx)
    averagey = sum(listy)/len(listy)
    
    my_lists = [listx,listy]
    array = np.array(my_lists)
    col = array.shape[1]
    
    sum_x_minus_averagex_squared = 0
    sum_y_minus_averagey_squared = 0
    sum_x_minus_averagex_times_y_minus_averagey = 0
    
    for i in range(col):
        x_minus_averagex = array[0,i] - averagex
        x_minus_averagex_squared = (array[0,i] - averagex)**2
        sum_x_minus_averagex_squared += x_minus_averagex_squared    
        y_minus_averagey = array[1,i] - averagey
        y_minus_averagey_squared = (array[1,i] - averagey)**2
        sum_y_minus_averagey_squared += y_minus_averagey_squared
        x_times_y = x_minus_averagex * y_minus_averagey
        sum_x_minus_averagex_times_y_minus_averagey += x_times_y
        
    pcc = (sum_x_minus_averagex_times_y_minus_averagey)/(math.sqrt(((sum_x_minus_averagex_squared) * (sum_y_minus_averagey_squared))))
    return pcc

Cluster = np.array(pd.read_csv('/home/grantstevens/Desktop/ClusterONE_d30_Clusters/CoExpressionClusterDistribution/Cytoscape_ClusterONE_output_d030_score',header=None))
ClusterEdges = np.array(pd.read_csv('/home/grantstevens/Desktop/ClusterONE_d30_Clusters/CoExpressionClusterDistribution/Cytoscape_ClusterONE_output_d030_score.EdgeFile',header=None))
NetworkProteins = np.array(pd.read_csv('/home/grantstevens/Desktop/ClusterONE_d30_Clusters/CoExpressionClusterDistribution/ToxoProteinsInNetwork.txt',header=None))
expression = pd.read_csv('/home/grantstevens/Desktop/ClusterONE_d30_Clusters/CoExpressionClusterDistribution/Boothroyd_Gregory_Reid_Carruthers_White_MERGE.profiles.min.pct.csv',index_col=0)
expression.fillna(0,inplace=True)

cluster_names = []
cluster_means = []
fullpccvalues = []
#This part gives the average correlation value for each cluster
for i in range(75):    
    cluster_name = str("Cluster {a}".format(a=i+1))
    cluster = Cluster[i][0].split('\t')
    cluster_size = len(cluster)
    
    clusterpcc = []
    for a in range(cluster_size):
        source = str(cluster[a])
        for b in range(cluster_size):
            target = str(cluster[b])
            if target == source:
                pass
            else:
                source_list = [expression.loc[source,'Boothroyd_day 0'],expression.loc[source,'Boothroyd_day 4'],expression.loc[source,'Boothroyd_day 10'],expression.loc[source,'hour 2'],expression.loc[source,'hour 4'],expression.loc[source,'hour 8'],expression.loc[source,'hour 16'],expression.loc[source,'hour 36'],expression.loc[source,'hour 44'],expression.loc[source,'Reid_day 3'],expression.loc[source,'Reid_day 4'],expression.loc[source,'Extracellular'],expression.loc[source,'Intracellular_0hr'],expression.loc[source,'Intracellular_2hr'],expression.loc[source,'asynchronous'],expression.loc[source,'0 HR'],expression.loc[source,'1 HR'],expression.loc[source,'2 HR'],expression.loc[source,'3 HR'],expression.loc[source,'4 HR'],expression.loc[source,'5 HR'],expression.loc[source,'6 HR'],expression.loc[source,'7 HR'],expression.loc[source,'8 HR'],expression.loc[source,'9 HR'],expression.loc[source,'10 HR'],expression.loc[source,'11 HR'],expression.loc[source,'12 HR']]
                target_list = [expression.loc[target,'Boothroyd_day 0'],expression.loc[target,'Boothroyd_day 4'],expression.loc[target,'Boothroyd_day 10'],expression.loc[target,'hour 2'],expression.loc[target,'hour 4'],expression.loc[target,'hour 8'],expression.loc[target,'hour 16'],expression.loc[target,'hour 36'],expression.loc[target,'hour 44'],expression.loc[target,'Reid_day 3'],expression.loc[target,'Reid_day 4'],expression.loc[target,'Extracellular'],expression.loc[target,'Intracellular_0hr'],expression.loc[target,'Intracellular_2hr'],expression.loc[target,'asynchronous'],expression.loc[target,'0 HR'],expression.loc[target,'1 HR'],expression.loc[target,'2 HR'],expression.loc[target,'3 HR'],expression.loc[target,'4 HR'],expression.loc[target,'5 HR'],expression.loc[target,'6 HR'],expression.loc[target,'7 HR'],expression.loc[target,'8 HR'],expression.loc[target,'9 HR'],expression.loc[target,'10 HR'],expression.loc[target,'11 HR'],expression.loc[target,'12 HR']]
                score = pcc(source_list,target_list)
                clusterpcc.append(score)
    cluster_names.append(cluster_name)
    cluster_mean = s.mean(clusterpcc)
    cluster_means.append(cluster_mean)
    fullpccvalues.append(clusterpcc)
    print("{a},{b}".format(a=cluster_name,b=s.mean(clusterpcc)))


cluster_dictionary = {'cluster':cluster_names,'average expression correlation':cluster_means,'pcc values':fullpccvalues}
dataframe_cluster = DataFrame(cluster_dictionary,columns=['cluster','average expression correlation','pcc values'])
#dataframe_cluster.to_csv('Clusters_AverageExpressionCorrelation_withfullvalues.csv',index=False)

#NOW WITH EVERY OTHER PROTEIN IN NETWORK
networkproteins = []
for item in NetworkProteins:
    networkproteins.append(item[0])

fullpcclist = []
cluster_names = []
randomcluster_means = []
for i in range(75):    
    cluster_name = str("Cluster {a}".format(a=i+1))
    cluster = Cluster[i][0].split('\t')
    cluster_size = len(cluster)
    
    randomclusterpcc = []
    for a in range(cluster_size):
        source = str(cluster[a])
        for b in range(690):
            target = str(networkproteins[b])
            if target == source:
                pass
            else:
                source_list = [expression.loc[source,'Boothroyd_day 0'],expression.loc[source,'Boothroyd_day 4'],expression.loc[source,'Boothroyd_day 10'],expression.loc[source,'hour 2'],expression.loc[source,'hour 4'],expression.loc[source,'hour 8'],expression.loc[source,'hour 16'],expression.loc[source,'hour 36'],expression.loc[source,'hour 44'],expression.loc[source,'Reid_day 3'],expression.loc[source,'Reid_day 4'],expression.loc[source,'Extracellular'],expression.loc[source,'Intracellular_0hr'],expression.loc[source,'Intracellular_2hr'],expression.loc[source,'asynchronous'],expression.loc[source,'0 HR'],expression.loc[source,'1 HR'],expression.loc[source,'2 HR'],expression.loc[source,'3 HR'],expression.loc[source,'4 HR'],expression.loc[source,'5 HR'],expression.loc[source,'6 HR'],expression.loc[source,'7 HR'],expression.loc[source,'8 HR'],expression.loc[source,'9 HR'],expression.loc[source,'10 HR'],expression.loc[source,'11 HR'],expression.loc[source,'12 HR']]
                target_list = [expression.loc[target,'Boothroyd_day 0'],expression.loc[target,'Boothroyd_day 4'],expression.loc[target,'Boothroyd_day 10'],expression.loc[target,'hour 2'],expression.loc[target,'hour 4'],expression.loc[target,'hour 8'],expression.loc[target,'hour 16'],expression.loc[target,'hour 36'],expression.loc[target,'hour 44'],expression.loc[target,'Reid_day 3'],expression.loc[target,'Reid_day 4'],expression.loc[target,'Extracellular'],expression.loc[target,'Intracellular_0hr'],expression.loc[target,'Intracellular_2hr'],expression.loc[target,'asynchronous'],expression.loc[target,'0 HR'],expression.loc[target,'1 HR'],expression.loc[target,'2 HR'],expression.loc[target,'3 HR'],expression.loc[target,'4 HR'],expression.loc[target,'5 HR'],expression.loc[target,'6 HR'],expression.loc[target,'7 HR'],expression.loc[target,'8 HR'],expression.loc[target,'9 HR'],expression.loc[target,'10 HR'],expression.loc[target,'11 HR'],expression.loc[target,'12 HR']]
                score = pcc(source_list,target_list)
                randomclusterpcc.append(score)
    cluster_names.append(cluster_name)
    cluster_mean = s.mean(randomclusterpcc)
    randomcluster_means.append(cluster_mean)
    fullpcclist.append(randomclusterpcc)
    print("{a},{b}".format(a=cluster_name,b=s.mean(randomclusterpcc)))


cluster_dictionary = {'cluster':cluster_names,'average random expression correlation':randomcluster_means,'random pcc values':fullpcclist}
dataframe_cluster = DataFrame(cluster_dictionary,columns=['cluster','average random expression correlation','random pcc values'])
#dataframe_cluster.to_csv('Clusters_NetworkProteinsRANDOM_AverageExpressionCorrelation_withfullvalues.csv',index=False)

#THIS PART USES A WELCH'S T-TEST (Unequal Variance, Unequal Sample Size)
t_value = []
p_value = []
for i in range(75):
    ClusterMeans = np.array(fullpccvalues[i]) 
    RandomMeans = np.array(fullpcclist[i])
    t = stats.ttest_ind(ClusterMeans,RandomMeans,equal_var=False)
    t_value.append(t[0])
    p_value.append(t[1])
    
ultimate_dictionary = {'cluster':cluster_names,'average_expression_correlation':cluster_means,'average_random_expression_correlation':randomcluster_means,'t_value':t_value,'p_value':p_value}
dataframe_cluster = DataFrame(ultimate_dictionary,columns=['cluster','average_expression_correlation','average_random_expression_correlation','t_value','p_value'])

significant = []
for i in range(75):
    if dataframe_cluster.loc[i][4] < 0.05:
        significant.append('Yes')
    else:
        significant.append('No')
dataframe_cluster['significant'] = significant
dataframe_cluster.to_csv('ClusterExpressionSummary_withpvaluesPCT.csv',index=False)

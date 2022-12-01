#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  4 13:51:42 2018

@author: grantstevens
"""

import math
import random
import numpy as np
import pandas as pd
from pandas import Series,DataFrame

data = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CODE_Cytoscape_edgefile_combined_supervised_FS_weka_results_5spctscore_ge0.57_unsupervised_W_RS-MA_pij_params_K2_alpha0.2_I22_fp0.0001_coexpr_ge0.5_max_based_5p.tab',sep='\t')
network_proteins = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/PROTEINS.csv',header=None))
expression = pd.read_csv('D:/Cyrptospora/CoexpressionDistribution/RepeatingWithMergedDataSets/Boothroyd_Gregory_Reid_MERGE.profiles.min.csv')
#expression.fillna(0,inplace=True)

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

#This calculates the pearson correlation (PCC) for all interacting proteins in the network

sourcelist = []
targetlist = []
pcclist = []

for i in range(len(data)):
    source = data.loc[i,'source']
    target = data.loc[i,'target']
    source_list = [expression.loc[source,'Boothroyd_day 0'],expression.loc[source,'Boothroyd_day 4'],expression.loc[source,'Boothroyd_day 10'],expression.loc[source,'hour 2'],expression.loc[source,'hour 4'],expression.loc[source,'hour 8'],expression.loc[source,'hour 16'],expression.loc[source,'hour 36'],expression.loc[source,'hour 44'],expression.loc[source,'Reid_day 3'],expression.loc[source,'Reid_day 4']]
    target_list = [expression.loc[target,'Boothroyd_day 0'],expression.loc[target,'Boothroyd_day 4'],expression.loc[target,'Boothroyd_day 10'],expression.loc[target,'hour 2'],expression.loc[target,'hour 4'],expression.loc[target,'hour 8'],expression.loc[target,'hour 16'],expression.loc[target,'hour 36'],expression.loc[target,'hour 44'],expression.loc[target,'Reid_day 3'],expression.loc[target,'Reid_day 4']]
    score = pcc(source_list,target_list)
    sourcelist.append(source)
    targetlist.append(target)
    pcclist.append(score)
    #print("{a},{b},{c}".format(a=source,b=target,c=score))
    
NetworkPCC = DataFrame({'source':sourcelist,'target':targetlist,'pcc':pcclist})
NetworkPCC.to_csv('D:/HighLowConfidenceNetworks/ExpressionPCC_combined_supervised_FS_weka_results_5spctscore_ge0.63_unsupervised_W_RS-MA_pij_params_K2_alpha0.2_I22_fp0.0001_max_based_5p.csv',sep=',',index=False,header=None)

#This calcutes PCC values for non-interacting network proteins and the entire proteome

networkeome = []
proteome = []

for i in range(len(expression)):
    proteome.append(expression.loc[i,'ID'])

for i in range(len(network_proteins)):
    networkeome.append(network_proteins[i][0])

expression = pd.read_csv('D:/Cyrptospora/CoexpressionDistribution/RepeatingWithMergedDataSets/Boothroyd_Gregory_Reid_MERGE.profiles.min.csv',index_col=0)
#expression.fillna(0,inplace=True)

#Making The Networkeome DataFrame
source_list = []
target_list = []
score_list = []
for i in range(len(networkeome)):
    source = networkeome[i]
    for i in range(len(networkeome)):
        target = networkeome[i]
        if target == source:
            pass
        else:
            source_expression = [expression.loc[source,'Boothroyd_day 0'],expression.loc[source,'Boothroyd_day 4'],expression.loc[source,'Boothroyd_day 10'],expression.loc[source,'hour 2'],expression.loc[source,'hour 4'],expression.loc[source,'hour 8'],expression.loc[source,'hour 16'],expression.loc[source,'hour 36'],expression.loc[source,'hour 44'],expression.loc[source,'Reid_day 3'],expression.loc[source,'Reid_day 4']]
            target_expression = [expression.loc[target,'Boothroyd_day 0'],expression.loc[target,'Boothroyd_day 4'],expression.loc[target,'Boothroyd_day 10'],expression.loc[target,'hour 2'],expression.loc[target,'hour 4'],expression.loc[target,'hour 8'],expression.loc[target,'hour 16'],expression.loc[target,'hour 36'],expression.loc[target,'hour 44'],expression.loc[target,'Reid_day 3'],expression.loc[target,'Reid_day 4']]
            score = pcc(source_expression,target_expression)
            source_list.append(source)
            target_list.append(target)
            score_list.append(score)

data_dictionary = {'source':source_list,'target':target_list,'score':score_list}
dataframe_network = DataFrame(data_dictionary,columns=['source','target','score'])
dataframe_network.to_csv('D:/CoexpressionDistribution_ForNewNetworks/Original_RANDOM_NETWORK_PROTEINS_PCC.csv',index=False)

#Making The Proteome DataFrame
source_list = []
target_list = []
score_list = []
for i in range(len(proteome)):
    source = proteome[i]
    for i in range(len(proteome)):
        target = proteome[i]
        if target == source:
            pass
        else:
            source_expression = [expression.loc[source,'Boothroyd_day 0'],expression.loc[source,'Boothroyd_day 4'],expression.loc[source,'Boothroyd_day 10'],expression.loc[source,'hour 2'],expression.loc[source,'hour 4'],expression.loc[source,'hour 8'],expression.loc[source,'hour 16'],expression.loc[source,'hour 36'],expression.loc[source,'hour 44'],expression.loc[source,'Reid_day 3'],expression.loc[source,'Reid_day 4']]
            target_expression = [expression.loc[target,'Boothroyd_day 0'],expression.loc[target,'Boothroyd_day 4'],expression.loc[target,'Boothroyd_day 10'],expression.loc[target,'hour 2'],expression.loc[target,'hour 4'],expression.loc[target,'hour 8'],expression.loc[target,'hour 16'],expression.loc[target,'hour 36'],expression.loc[target,'hour 44'],expression.loc[target,'Reid_day 3'],expression.loc[target,'Reid_day 4']]
            score = pcc(source_expression,target_expression)
            source_list.append(source)
            target_list.append(target)
            score_list.append(score)

data_dictionary = {'source':source_list,'target':target_list,'score':score_list}
dataframe_proteome = DataFrame(data_dictionary,columns=['source','target','score'])
dataframe_proteome.to_csv('ProteomeProteins_FullExpressionCorrelation_Boothroyd_Gregory_Reid.csv',index=False)
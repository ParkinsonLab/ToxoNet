#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 21 18:09:10 2022

@author: grantstevens
"""

import random
import pandas as pd
from pandas import DataFrame
import numpy as np
import statistics as s

def countListValues(list1):
    uniqueList1 = list(set(list1))
    dic1 = {}
    for item in uniqueList1:
        dic1[item] = list1.count(item)/len(list1)
    return dic1

def topListValue(list1):
    uniqueList1 = list(set(list1))
    dic1 = {}
    for item in uniqueList1:
        dic1[item] = list1.count(item)/len(list1)
    optimalKey = ''
    optimalScore = 0
    for key in dic1:
        if dic1[key] > optimalScore:
            optimalScore = dic1[key]
            optimalKey = str(key)
        elif dic1[key] == optimalScore:
            optimalKey = optimalKey + "; " + str(key)
    return "{a}:{b}".format(a=optimalKey,b=optimalScore)

ToxoDB = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/SPARC_MS_031622/ToxoDB_ME49_FullSummary_040522.txt.txt',sep='\t',index_col='Gene ID')
CytoscapeEdge = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/Cytoscape_edgefile_combined_supervised_FS_weka_results_5spctscore_ge0.57_unsupervised_W_RS-MA_pij_params_K2_alpha0.2_I22_fp0.0001_coexpr_ge0.5_max_based_5p.tab',sep='\t')
CytoscapeEdge_LC = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/LowConfidence/EdgeFile_Cytoscape_LowConfidenceNetwork.tab',sep='\t')
Clusters = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab',sep='@',header=None))
ClusterTable = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/HyperLoppit/ClusterTable_SupplementalTable7.csv',sep=',',index_col='Cluster')


ClusterLocalizationFrame = DataFrame(columns=['Cluster','TAGM-MAP Prediction','TAG-MAP Percent','TAGM-MCMC Prediction','TAGM-MCMC Percent'])

for i in range(len(Clusters)):
    
    cluster = Clusters[i][0].split('\t')
    clusterName = "Cluster {a}".format(a=i+1)
    clusterMAP = []
    clusterMCMC = []
    
    for protein in cluster:
        clusterMAP.append(ToxoDB.loc[protein]['Predicted Location (TAGM-MAP)'])
        clusterMCMC.append(ToxoDB.loc[protein]['Top Predicted Location (TAGM-MCMC)'])
    
    ClusterLocalizationFrame.at[i,'Cluster'] = clusterName
    ClusterLocalizationFrame.at[i,'TAGM-MAP Prediction'] = topListValue(clusterMAP).split(':')[0]
    ClusterLocalizationFrame.at[i,'TAG-MAP Percent'] = round(float(topListValue(clusterMAP).split(':')[1])*100,1)
    ClusterLocalizationFrame.at[i,'TAGM-MCMC Prediction'] = topListValue(clusterMCMC).split(':')[0]
    ClusterLocalizationFrame.at[i,'TAGM-MCMC Percent'] = round(float(topListValue(clusterMCMC).split(':')[1])*100,1)
    
    ClusterTable.at[clusterName,'Localization'] = topListValue(clusterMAP).split(':')[0]
    
    if topListValue(clusterMAP).split(':')[0] != topListValue(clusterMCMC).split(':')[0]:
        print(clusterName)
    
ClusterLocalizationFrame.to_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/HyperLoppit/ClusterLocalization.csv",sep="\t",index=False)
ClusterTable.to_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/HyperLoppit/ClusterTable_SupplementalTable7_HyperLoppitLocalization.csv",sep=",")


    

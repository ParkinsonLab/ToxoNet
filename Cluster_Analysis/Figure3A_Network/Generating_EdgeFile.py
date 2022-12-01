#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 20 14:04:22 2017

@author: grantstevens
"""
import pandas as pd
import numpy as np
from pandas import DataFrame

def comp(list1,list2):
    c = 0
    for val in list1:
        if val in list2:
            c += 1
    return c

#Here your're making a matrix that contains the number of overlapping components between clusters

Clusters = np.array(pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab",header=None))

Cluster_list = []
for i in range(1,94):
    item = str("Cluster {a}".format(a=i))
    Cluster_list.append(item)
    
ClusterNetworkMatrix = DataFrame(index=Cluster_list,columns=Cluster_list)
ClusterNetworkMatrix_BH = DataFrame(index=Cluster_list,columns=Cluster_list)

c=1
for line in Clusters:
    cluster = list(line)    
    cluster = cluster[0].split('\t')
    cluster_size = len(cluster)
    cluster_name = str("Cluster {a}".format(a=c))

    x = 1
    for line2 in Clusters:
        cluster2 = list(line2)    
        cluster2 = cluster2[0].split('\t')
        cluster2_size = len(cluster2)
        cluster2_name = str("Cluster {a}".format(a=x))
        
        number_shared = comp(cluster,cluster2)
        bh = (number_shared*number_shared)/(cluster_size*cluster2_size)
        
        ClusterNetworkMatrix[cluster_name][cluster2_name] = number_shared 
        ClusterNetworkMatrix[cluster2_name][cluster_name] = number_shared
        ClusterNetworkMatrix_BH[cluster_name][cluster2_name] = bh 
        ClusterNetworkMatrix_BH[cluster2_name][cluster_name] = bh

        x+=1           
    
    c += 1

ClusterNetworkMatrix.fillna(0,inplace=True)
ClusterNetworkMatrix.to_csv("ClusterNetworkMatrix_OverlappingAttribute.csv")

#Making Attribute EdgeFile

EdgeFile = pd.read_csv("ClusterNetworkMatrix_Edgefile.csv")
Interactions = pd.read_csv("ClusterNetworkMatrix_Edgefile_Interactions.csv",header=None)

Interactions_list = []
for i in range(len(Interactions)):
    g = Interactions[2][i]
    Interactions_list.append(g)

number_of_overlap = []
overlap = []
bader_hogue = []
for i in range(len(EdgeFile)):
    source = EdgeFile['source'][i]
    target = EdgeFile['target'][i]
    numberoverlaps = ClusterNetworkMatrix[source][target]
    bh = ClusterNetworkMatrix_BH[source][target]
    number_of_overlap.append(numberoverlaps)
    bader_hogue.append(bh)
    if numberoverlaps == 0:
        overlap.append('No Overlap')
    else:   
        overlap.append('Overlapping')

EdgeFile['Number of Interactions Between Clusters'] = Interactions_list
EdgeFile['Overlapping'] = overlap
EdgeFile['Number of Overlapping Proteins'] = number_of_overlap
EdgeFile['Bader-Hogue Score'] = bader_hogue

EdgeFile.to_csv('ClusterNetworkMatrix_EdgeFileFINAL_WITHAttributes',index=False)
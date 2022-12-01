#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 15 20:44:29 2018

@author: grantstevens
"""
import numpy as np
import pandas as pd
from pandas import DataFrame
import seaborn as sns
import matplotlib as mpl
import matplotlib.pyplot as plt
import statistics as s
import math
from scipy import stats

Clusters = np.array(pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab",header=None))
Lineage_Data = pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/Super_Network/MakingNodeTable/LineageNodeTable.csv",index_col=0)
ClusterNodeTable = pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/Super_Network/MakingNodeTable/SuperNetwork_NodeTable.tab",sep='\t',index_col=0)
Invasion = pd.read_csv('GenesByTaxon_Summary_Modified.txt.computed_go_components_withInvasion_withHyp',sep=',',index_col=0)
NetworkProteins = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/PROTEINS.csv',header=None))

EssentialClusters = [21,31,40,70,72,81,85,3,33,35,18,60,24,44,12,47,1,2,39,4,42,66,37,53,11,6,49,54,56,92]
DispensableClusters = [73,38,67,89,30,23,25,61,62,65,78,88,59,93,22,48,83,26,16,46,69,75,76,77,82]

totalnetworkproteins = 0
Network_Proteins = []
for i in range(len(NetworkProteins)):
    Network_Proteins.append(NetworkProteins[i][0])
    totalnetworkproteins += 1

#Calculating properties of ALL network Proteins
totalnetworkinvasion = 0
totalnetworkapi = 0
totalnetworkhypothetical = 0
for i in range(len(Network_Proteins)):
    protein = Network_Proteins[i]
    if Invasion['Computed GO Components'][protein][0:8] == 'Invasion':
        totalnetworkinvasion += 1
    if Invasion['Computed GO Components'][protein] == 'Hypothetical':
        totalnetworkhypothetical += 1
    if Lineage_Data['Lineage'][protein] != 'Eukaryotes':
        totalnetworkapi += 1

#Calculating properties of Essential Cluster Proteins
ProteinsEssential = []
for item in EssentialClusters:
    x = item - 1
    cluster = Clusters[x][0].split('\t')
    for i in range(len(cluster)):
        ProteinsEssential.append(cluster[i])
        
UniqueProteinsEssential = list(set(ProteinsEssential))
totalessentialinvasion = 0
totalessentialapi = 0
totalessentialhyp = 0
totalessentialproteins = len(UniqueProteinsEssential)
for protein in UniqueProteinsEssential:
    if Invasion['Computed GO Components'][protein][0:8] == 'Invasion':
        totalessentialinvasion += 1
    if Lineage_Data['Lineage'][protein] != 'Eukaryotes':
        totalessentialapi += 1
    if Invasion['Computed GO Components'][protein] == 'Hypothetical':
        totalessentialhyp += 1

#Calculating properties of Dispensable Cluster Proteins
ProteinsDispensable = []
for item in DispensableClusters:
    x = item - 1
    cluster = Clusters[x][0].split('\t')
    for i in range(len(cluster)):
        ProteinsDispensable.append(cluster[i])
        
UniqueProteinsDispensable = list(set(ProteinsDispensable))
totaldispensableinvasion = 0
totaldispensableapi = 0
totaldispensablehyp = 0
totaldispensableproteins = len(UniqueProteinsDispensable)
for protein in UniqueProteinsDispensable:
    if Invasion['Computed GO Components'][protein][0:8] == 'Invasion':
        totaldispensableinvasion += 1
    if Lineage_Data['Lineage'][protein] != 'Eukaryotes':
        totaldispensableapi += 1
    if Invasion['Computed GO Components'][protein] == 'Hypothetical':
        totaldispensablehyp += 1

#TRYING TO COMPARE PERCENT

FractionEssentialApicomplexan = []
FractionEssentialEukaryote = []
FractionEssentialInvasion = []
FractionEssentialHypothetical = []        
for item in EssentialClusters:
    cluster = str('Cluster {a}'.format(a=item))
    Api = ClusterNodeTable['Apicomplexan'][cluster]
    Cock = ClusterNodeTable['Coccidian'][cluster]
    Toxo = ClusterNodeTable['Toxoplasma'][cluster]
    Euk = ClusterNodeTable['Eukaryote'][cluster]
    frac = Api + Cock + Toxo
    FractionEssentialApicomplexan.append(frac)
    FractionEssentialEukaryote.append(Euk)
    x = item - 1
    cluster = Clusters[x][0].split('\t')
    Proteins = []
    for i in range(len(cluster)):
        Proteins.append(cluster[i])
    totalinvasion = 0
    totalhyp = 0
    for protein in Proteins:
        if Invasion['Computed GO Components'][protein][0:8] == 'Invasion':
            totalinvasion += 1
        if Invasion['Computed GO Components'][protein] == 'Hypothetical':
            totalhyp += 1
    fracinvasion = totalinvasion/len(Proteins)
    FractionEssentialInvasion.append(fracinvasion)
    frachyp = totalhyp/len(Proteins)
    FractionEssentialHypothetical.append(frachyp)
    
FractionDispensableApicomplexan = []
FractionDispensableEukaryote = []
FractionDispensableInvasion = []
FractionDispensableHypothetical = []
for item in DispensableClusters:
    cluster = str('Cluster {a}'.format(a=item))
    Api = ClusterNodeTable['Apicomplexan'][cluster]
    Cock = ClusterNodeTable['Coccidian'][cluster]
    Toxo = ClusterNodeTable['Toxoplasma'][cluster]
    Euk = ClusterNodeTable['Eukaryote'][cluster]
    frac = Api + Cock + Toxo
    FractionDispensableApicomplexan.append(frac)
    FractionDispensableEukaryote.append(Euk)
    x = item - 1
    cluster = Clusters[x][0].split('\t')
    Proteins = []
    for i in range(len(cluster)):
        Proteins.append(cluster[i])
    totalinvasion = 0
    totalhyp = 0
    for protein in Proteins:
        if Invasion['Computed GO Components'][protein][0:8] == 'Invasion':
            totalinvasion += 1
        if Invasion['Computed GO Components'][protein] == 'Hypothetical':
            totalhyp += 1
    fracinvasion = totalinvasion/len(Proteins)
    FractionDispensableInvasion.append(fracinvasion)
    frachyp = totalhyp/len(Proteins)
    FractionDispensableHypothetical.append(frachyp)

EssentialApiMean = s.mean(FractionEssentialApicomplexan)
EssentialInvasionMean = s.mean(FractionEssentialInvasion)
EssentialHypMean = s.mean(FractionEssentialHypothetical)
DispensableApiMean = s.mean(FractionDispensableApicomplexan)
DispensableInvasionMean = s.mean(FractionDispensableInvasion)
DispensableHypMean = s.mean(FractionDispensableHypothetical)
    
    

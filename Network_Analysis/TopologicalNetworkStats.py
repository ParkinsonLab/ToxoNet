# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statistics as s
import math
from scipy import stats
import seaborn as sns

NodeTable = pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/NodeTable_Cytoscape.csv")
NodeTable_NoEmptyEssentiality = pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/NodeTable_Cytoscape_Essential.csv")

#Everything
All_Degree = []
All_Betweenness = []
All_ClosenessCentrality = []
All_Eccentricity = []

#Essentialility
Essential_Degree = []
Essential_Betweenness = []
Essential_ClosenessCentrality = []
Essential_Eccentricity = []
Dispensable_Degree = []
Dispensable_Betweenness = []
Dispensable_ClosenessCentrality = []
Dispensable_Eccentricity = []

#Lineage
Eukaryotic_Degree = []
Eukaryotic_Betweenness = []
Eukaryotic_ClosenessCentrality = []
Eukaryotic_Eccentricity = []
Apicomplexan_Degree = []
Apicomplexan_Betweenness = []
Apicomplexan_ClosenessCentrality = []
Apicomplexan_Eccentricity = []
Coccidian_Degree = []
Coccidian_Betweenness = []
Coccidian_ClosenessCentrality = []
Coccidian_Eccentricity = []
Toxoplasma_Degree = []
Toxoplasma_Betweenness = []
Toxoplasma_ClosenessCentrality = []
Toxoplasma_Eccentricity = []

for i in range(len(NodeTable)):
    All_Degree.append(NodeTable['Degree'][i])
    All_Betweenness.append(NodeTable['BetweennessCentrality'][i])
    All_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
    All_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Essentiality_OrthoMCL'][i] == "Essential":
        Essential_Degree.append(NodeTable['Degree'][i])
        Essential_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Essential_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Essential_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Essentiality_OrthoMCL'][i] == "Dispensable":
        Dispensable_Degree.append(NodeTable['Degree'][i])
        Dispensable_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Dispensable_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Dispensable_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Lineage'][i] == 'Eukaryotes':
        Eukaryotic_Degree.append(NodeTable['Degree'][i])
        Eukaryotic_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Eukaryotic_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Eukaryotic_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Lineage'][i] == 'Apicomplexa':
        Apicomplexan_Degree.append(NodeTable['Degree'][i])
        Apicomplexan_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Apicomplexan_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Apicomplexan_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Lineage'][i] == 'Coccidia':
        Coccidian_Degree.append(NodeTable['Degree'][i])
        Coccidian_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Coccidian_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Coccidian_Eccentricity.append(NodeTable['Eccentricity'][i])
    if NodeTable['Lineage'][i] == 'Toxoplasma':
        Toxoplasma_Degree.append(NodeTable['Degree'][i])
        Toxoplasma_Betweenness.append(NodeTable['BetweennessCentrality'][i])
        Toxoplasma_ClosenessCentrality.append(NodeTable['ClosenessCentrality'][i])
        Toxoplasma_Eccentricity.append(NodeTable['Eccentricity'][i])
        

#Essentiality   
EssentialDegree = sns.barplot(x="Essentiality_OrthoMCL",y="Degree",data=NodeTable_NoEmptyEssentiality, ci=68, capsize=.2)
stats.ttest_ind(Essential_Degree,Dispensable_Degree,equal_var=False)        
fig1 = EssentialDegree.get_figure()
fig1.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/EssentialDegree_BarPlot.svg", format="svg")

EssentialBetweennessCentrality = sns.barplot(x="Essentiality_OrthoMCL",y="BetweennessCentrality",data=NodeTable_NoEmptyEssentiality, ci=68, capsize=.2)
stats.ttest_ind(Essential_Betweenness,Dispensable_Betweenness,equal_var=False)
fig3 = EssentialBetweennessCentrality.get_figure()
fig3.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/EssentialBetweennessCentrality_BarPlot.svg", format="svg")


#Essential Centrality stats with no sig
EssentialEccentricity = sns.barplot(x="Essentiality",y="Eccentricity",data=NodeTable_NoEmptyEssentiality, ci=68, capsize=.2)
stats.ttest_ind(Essential_Eccentricity,Dispensable_Eccentricity,equal_var=False)
fig2 = EssentialEccentricity.get_figure()
fig2.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/EssentialEccentricity_BarPlot.svg", format="svg")

EssentialClosenessCentrality = sns.barplot(x="Essentiality",y="ClosenessCentrality",data=NodeTable_NoEmptyEssentiality, ci=68, capsize=.2)
stats.ttest_ind(Essential_ClosenessCentrality,Dispensable_ClosenessCentrality,equal_var=False)

#Lineage
LineageDegree = sns.barplot(x="Lineage",y="Degree",data=NodeTable, ci=68, capsize=.2, palette = "Set1")        
fig = LineageDegree.get_figure()        
fig.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/NetworkCentralityStats/LineageDegree_BarPlot.svg", format="svg")        
stats.ttest_ind(Toxoplasma_Degree,Eukaryotic_Degree,equal_var=False)
stats.ttest_ind(Eukaryotic_Degree,Apicomplexan_Degree,equal_var=False)
stats.ttest_ind(Eukaryotic_Degree,Coccidian_Degree,equal_var=False)      
stats.ttest_ind(Toxoplasma_Degree,Coccidian_Degree,equal_var=False)      
stats.ttest_ind(Toxoplasma_Degree,Apicomplexan_Degree,equal_var=False)      


#Lineage Betweennes doesn't appear to be significant
LineageBetweenness = sns.barplot(x="Lineage",y="BetweennessCentrality",data=NodeTable, ci=68, capsize=.2, palette = "Set1")        
stats.ttest_ind(Toxoplasma_Betweenness,Apicomplexan_Betweenness,equal_var=False)
stats.ttest_ind(Coccidian_Betweenness,Apicomplexan_Betweenness,equal_var=False)
stats.ttest_ind(Eukaryotic_Betweenness,Apicomplexan_Betweenness,equal_var=False)


LineageClosenessCentrality = sns.barplot(x="Lineage",y="ClosenessCentrality",data=NodeTable, ci=68, capsize=.2, palette = "Set1")        
stats.ttest_ind(Eukaryotic_ClosenessCentrality,Toxoplasma_ClosenessCentrality,equal_var=False)

LineageEccentricity = sns.barplot(x="Lineage",y="Eccentricity",data=NodeTable, ci=68, capsize=.2, palette = "Set1")        
stats.ttest_ind(Eukaryotic_Eccentricity,Toxoplasma_Eccentricity,equal_var=False)

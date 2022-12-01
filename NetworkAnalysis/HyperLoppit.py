#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 21 15:52:00 2022

@author: grantstevens
"""

import random
import pandas as pd
from pandas import DataFrame
import numpy as np
import statistics as s

def randomNetworkGenerator(CytoscapeEdge):

    sourceList = list(CytoscapeEdge['Source'])
    targetList = list(CytoscapeEdge['Target'])
    random.shuffle(sourceList)
    random.shuffle(targetList)
    selfInteract = True
    
    while selfInteract == True:
        c=0
        for i in range(len(sourceList)):
            if sourceList[i] == targetList[i]:
                target = targetList[i]
                randomIndex = random.choice(list(range(len(sourceList))))
                targetList[i] = targetList[randomIndex]
                targetList[randomIndex] = target
                c+=1
        
        if c == 0:
            selfInteract = False
    
    randomNetwork = DataFrame(columns = ['Source','Target'])
    randomNetwork['Source'] = sourceList
    randomNetwork['Target'] = targetList
    
    return randomNetwork

ToxoDB = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/SPARC_MS_031622/ToxoDB_ME49_FullSummary_040522.txt.txt',sep='\t',index_col='Gene ID')
CytoscapeEdge = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/Cytoscape_edgefile_combined_supervised_FS_weka_results_5spctscore_ge0.57_unsupervised_W_RS-MA_pij_params_K2_alpha0.2_I22_fp0.0001_coexpr_ge0.5_max_based_5p.tab',sep='\t')
CytoscapeEdge_LC = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/LowConfidence/EdgeFile_Cytoscape_LowConfidenceNetwork.tab',sep='\t')
Clusters = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab',sep='@'))

#Here I calcualte the number of interactions with Like Terms

NumberLikeTerm = 0
NumberUnlikeTerm = 0

for i in range(len(CytoscapeEdge)):
    
    target = CytoscapeEdge.loc[i]['Target'][0:13]
    source = CytoscapeEdge.loc[i]['Source'][0:13]

    targetHyperMAP = ToxoDB.loc[target]['Predicted Location (TAGM-MAP)']
    targetHyperMCMC = ToxoDB.loc[target]['Top Predicted Location (TAGM-MCMC)']
    sourceHyperMAP = ToxoDB.loc[source]['Predicted Location (TAGM-MAP)']
    sourceHyperMCMC = ToxoDB.loc[source]['Top Predicted Location (TAGM-MCMC)']

    if targetHyperMAP == sourceHyperMAP or targetHyperMAP == sourceHyperMCMC or targetHyperMCMC == sourceHyperMAP or targetHyperMCMC == sourceHyperMCMC:
        NumberLikeTerm += 1
    else:
        NumberUnlikeTerm += 1

fractionLike = NumberLikeTerm/(NumberLikeTerm+NumberUnlikeTerm)

#Here I calculate the average number of like terms in random networks

randomFractionLike = []

for iteration in range(1000):
    
    rNumberLikeTerm = 0
    rNumberUnlikeTerm = 0
    randomCytoscapeEdge = randomNetworkGenerator(CytoscapeEdge)
    
    for i in range(len(randomCytoscapeEdge)):
        
        target = randomCytoscapeEdge.loc[i]['Target'][0:13]
        source = randomCytoscapeEdge.loc[i]['Source'][0:13]
    
        targetHyperMAP = ToxoDB.loc[target]['Predicted Location (TAGM-MAP)']
        targetHyperMCMC = ToxoDB.loc[target]['Top Predicted Location (TAGM-MCMC)']
        sourceHyperMAP = ToxoDB.loc[source]['Predicted Location (TAGM-MAP)']
        sourceHyperMCMC = ToxoDB.loc[source]['Top Predicted Location (TAGM-MCMC)']
    
        if targetHyperMAP == sourceHyperMAP or targetHyperMAP == sourceHyperMCMC or targetHyperMCMC == sourceHyperMAP or targetHyperMCMC == sourceHyperMCMC:
            rNumberLikeTerm += 1
        else:
            rNumberUnlikeTerm += 1
        
    fraction = rNumberLikeTerm/(rNumberLikeTerm+rNumberUnlikeTerm)
    randomFractionLike.append(round(fraction,4))
    
    print(iteration)

textfile= open("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/HyperLoppit/HyperLoppit_FractionRandom_Distribution.txt","w")
for item in randomFractionLike:
    textfile.write(str(item) + "\n")
textfile.close()

textfile= open("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/HyperLoppit/HyperLoppit_Summary.txt","w")
textfile.write("ToxoNet Like Terms: {a}".format(a=NumberLikeTerm) + "\n")
textfile.write("ToxoNet Disparate Terms: {a}".format(a=NumberUnlikeTerm) + "\n")
textfile.write("ToxoNet Percent Interactions with Like Terms: {a}%".format(a=round(fractionLike*100,2)) + "\n" + "\n")
textfile.write("Average Percent Interactions with Like Terms in 1000 Random Networks: {a}%".format(a=round(s.mean(randomFractionLike)*100,2)) + "\n")
textfile.write("Standard Deviation (of Percentage) in 1000 Random Networks: {a}%".format(a=round(s.stdev(randomFractionLike)*100,2)) + "\n" + "\n")
textfile.write("See 'HyperLoppit_FractionRandom_Distribution.txt' for the distribution of the fraction of common terms in 1000 random networks.")
textfile.close()



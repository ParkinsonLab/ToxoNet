#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 28 19:41:50 2019

@author: grant
"""

import networkx as nx
import numpy as np
import pandas as pd
import statistics as s
import random
import seaborn as sns

def comp(list1,list2):
    c = 0
    for val in list1:
        if val in list2:
            c += 1
    return c

ToxoNet = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CODE_Cytoscape_edgefile_combined_supervised_FS_weka_results_5spctscore_ge0.57_unsupervised_W_RS-MA_pij_params_K2_alpha0.2_I22_fp0.0001_coexpr_ge0.5_max_based_5p.tab',sep='\t'))
NetworkProteins = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/PROTEINS.csv',header=None)
UnconnectedNodes = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/UnconnectedNodes.txt',header=None)

GRA17_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA17_BioID_Orthologs.csv')
GRA13_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA13_BioID_Orthologs.csv',encoding = "ISO-8859-1")
GRA25_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA25_BioID_Orthologs.csv',encoding = "ISO-8859-1")
MitoOverlap_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/MitochondrialBioID_APEXandBirAoverlap.csv',header=None)
ISP3_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/ISP3_BioID_Orthologs.csv',encoding = "ISO-8859-1")
AC2_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/AC2_BioID_Orthologs.csv',encoding = "ISO-8859-1")
GRA1_BioID = pd.read_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA1_BioID_Orthologs.csv')


'''
There's a problem in that you can't calculate the shortest path length between disconnected nodes.
So my solution is to not include the nodes that are not connected to the network (55 proteins).
Maybe there is a better way to deal with this?
'''
NetworkProt_Full = list(NetworkProteins[0])
NetworkProt = list(NetworkProteins[0])
UnconnectedNodes = list(UnconnectedNodes[0])
for i in range(len(UnconnectedNodes)):
    NetworkProt.remove(UnconnectedNodes[i])


ToxoNetwork = nx.Graph()
for i in range(len(ToxoNet)):
    ToxoNetwork.add_edge(ToxoNet[i][0],ToxoNet[i][1],weight=ToxoNet[i][2])
    
'''
GRA17
'''

GRA17_TGME49_Hits = GRA17_BioID['ME49_Ortholog'].dropna().unique().tolist()
GRA17_TGME49_TopHit = []
for i in range(len(GRA17_BioID)):
    if GRA17_BioID['X'][i] != '[-]group':
        GRA17_TGME49_TopHit.append(GRA17_BioID['ME49_Ortholog'][i])
GRA17_TGME49_TopHits = [x for x in GRA17_TGME49_TopHit if str(x) != 'nan']
GRA17_TGME49_TopHit = set(GRA17_TGME49_TopHits)
GRA17_TGME49_TopHits = list(GRA17_TGME49_TopHit)

GRA17_Network_TopHits = []
for val in GRA17_TGME49_TopHits:
    if val in NetworkProt:
        GRA17_Network_TopHits.append(val)

GRA17_Protein = []
GRA17_AverageShortestPathLength = []
GRA17_ShortestPaths = []
for i in range(len(GRA17_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(GRA17_Network_TopHits)):
        if GRA17_Network_TopHits[i] != GRA17_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA17_Network_TopHits[i], GRA17_Network_TopHits[x]))
    GRA17_Protein.append(GRA17_Network_TopHits[i])
    GRA17_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA17_ShortestPaths.append(ShortestPathLengths)

GRA17_RandomSubnetwork_ASPL = []
for i in range(1000):
    GRA17_Random = random.sample(NetworkProt, len(GRA17_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(GRA17_Random)):
        ShortestPathLengths = []
        for x  in range(len(GRA17_Random)):
            if GRA17_Random[i] != GRA17_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA17_Random[i], GRA17_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA17_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(GRA17_RandomSubnetwork_ASPL)
s.mean(GRA17_AverageShortestPathLength)    
sum(i < s.mean(GRA17_AverageShortestPathLength) for i in GRA17_RandomSubnetwork_ASPL)/len(GRA17_RandomSubnetwork_ASPL)

'''
GRA13
'''

GRA13_TGME49_Hits = GRA13_BioID['ME49_Ortholog'].dropna().unique().tolist()
GRA13_TGME49_TopHit = []
for i in range(len(GRA13_BioID)):
    if GRA13_BioID['X...group'][i] != '[-]group':
        GRA13_TGME49_TopHit.append(GRA13_BioID['ME49_Ortholog'][i])
GRA13_TGME49_TopHits = [x for x in GRA13_TGME49_TopHit if str(x) != 'nan']
GRA13_TGME49_TopHit = set(GRA13_TGME49_TopHits)
GRA13_TGME49_TopHits = list(GRA13_TGME49_TopHit)

GRA13_Network_TopHits = []
for val in GRA13_TGME49_TopHits:
    if val in NetworkProt:
        GRA13_Network_TopHits.append(val)

GRA13_Protein = []
GRA13_AverageShortestPathLength = []
GRA13_ShortestPaths = []
for i in range(len(GRA13_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(GRA13_Network_TopHits)):
        if GRA13_Network_TopHits[i] != GRA13_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA13_Network_TopHits[i], GRA13_Network_TopHits[x]))
    GRA13_Protein.append(GRA13_Network_TopHits[i])
    GRA13_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA13_ShortestPaths.append(ShortestPathLengths)

GRA13_RandomSubnetwork_ASPL = []
for i in range(1000):
    GRA13_Random = random.sample(NetworkProt, len(GRA13_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(GRA13_Random)):
        ShortestPathLengths = []
        for x  in range(len(GRA13_Random)):
            if GRA13_Random[i] != GRA13_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA13_Random[i], GRA13_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA13_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(GRA13_RandomSubnetwork_ASPL)
s.mean(GRA13_AverageShortestPathLength)    
sum(i < s.mean(GRA13_AverageShortestPathLength) for i in GRA13_RandomSubnetwork_ASPL)/len(GRA13_RandomSubnetwork_ASPL)


'''
GRA25
'''

GRA25_TGME49_Hits = GRA25_BioID['ME49_Ortholog'].dropna().unique().tolist()
GRA25_TGME49_TopHit = []
for i in range(len(GRA25_BioID)):
    if GRA25_BioID['X'][i] != '[-]group':
        GRA25_TGME49_TopHit.append(GRA25_BioID['ME49_Ortholog'][i])
GRA25_TGME49_TopHits = [x for x in GRA25_TGME49_TopHit if str(x) != 'nan']
GRA25_TGME49_TopHit = set(GRA25_TGME49_TopHits)
GRA25_TGME49_TopHits = list(GRA25_TGME49_TopHit)

GRA25_Network_TopHits = []
for val in GRA25_TGME49_TopHits:
    if val in NetworkProt:
        GRA25_Network_TopHits.append(val)

GRA25_Protein = []
GRA25_AverageShortestPathLength = []
GRA25_ShortestPaths = []
for i in range(len(GRA25_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(GRA25_Network_TopHits)):
        if GRA25_Network_TopHits[i] != GRA25_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA25_Network_TopHits[i], GRA25_Network_TopHits[x]))
    GRA25_Protein.append(GRA25_Network_TopHits[i])
    GRA25_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA25_ShortestPaths.append(ShortestPathLengths)

GRA25_RandomSubnetwork_ASPL = []
for i in range(1000):
    GRA25_Random = random.sample(NetworkProt, len(GRA25_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(GRA25_Random)):
        ShortestPathLengths = []
        for x  in range(len(GRA25_Random)):
            if GRA25_Random[i] != GRA25_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA25_Random[i], GRA25_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA25_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(GRA25_RandomSubnetwork_ASPL)
s.mean(GRA25_AverageShortestPathLength)    
sum(i < s.mean(GRA25_AverageShortestPathLength) for i in GRA25_RandomSubnetwork_ASPL)/len(GRA25_RandomSubnetwork_ASPL)

'''
Mitochondrial - these are the overlap between the BirA and APEX experiments
'''

MitoHits = list(MitoOverlap_BioID[0])

Mito_Network_TopHits = []
for val in MitoHits:
    if val in NetworkProt:
        Mito_Network_TopHits.append(val)

Mito_Protein = []
Mito_AverageShortestPathLength = []
Mito_ShortestPaths = []
for i in range(len(Mito_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(Mito_Network_TopHits)):
        if Mito_Network_TopHits[i] != Mito_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, Mito_Network_TopHits[i], Mito_Network_TopHits[x]))
    Mito_Protein.append(Mito_Network_TopHits[i])
    Mito_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    Mito_ShortestPaths.append(ShortestPathLengths)

Mito_RandomSubnetwork_ASPL = []
for i in range(1000):
    Mito_Random = random.sample(NetworkProt, len(Mito_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(Mito_Random)):
        ShortestPathLengths = []
        for x  in range(len(Mito_Random)):
            if Mito_Random[i] != Mito_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, Mito_Random[i], Mito_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    Mito_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
MitoPlot = sns.distplot(Mito_RandomSubnetwork_ASPL, color='gray')
MitoPlot.set_xlabel('Characteristic Path Length')
MitoPlot.set_ylabel('Density')
MitoPlot.set(xlim=(3.25, 5.75))
MitoPlot.set(xticks=(3.25,3.5,3.75,4,4.25,4.5,4.75,5,5.25,5.5,5.75))
MitoPlot.axvline(s.mean(Mito_RandomSubnetwork_ASPL),0,0.817,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) + s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.545,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) - s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.555,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) + 2*s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.140,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) - 2*s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.120,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) + 3*s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.005,color='gray',linestyle='dashed')
MitoPlot.axvline((s.mean(Mito_RandomSubnetwork_ASPL) - 3*s.stdev(Mito_RandomSubnetwork_ASPL)),0,0.005,color='gray',linestyle='dashed')
MitoPlot.axvline(s.mean(Mito_AverageShortestPathLength),0,1,color='red')

MitoGraph = MitoPlot.get_figure()
MitoGraph.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/MitoGraph_BioID.svg", format="svg")


sns.distplot(Mito_RandomSubnetwork_ASPL, color='r')
s.mean(Mito_AverageShortestPathLength)    
sum(i < s.mean(Mito_AverageShortestPathLength) for i in Mito_RandomSubnetwork_ASPL)/len(Mito_RandomSubnetwork_ASPL)

Mito_dictionary = {'Mito_RandomSubnetwork_ASPL':Mito_RandomSubnetwork_ASPL}
dataframe_Mito_RandomSubnetwork_ASPL = pd.DataFrame(Mito_dictionary,columns=['Mito_RandomSubnetwork_ASPL'])
dataframe_Mito_RandomSubnetwork_ASPL.to_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/Mito_RandomSubnetwork_ASPL.csv',index=False,header=None)

'''
ISP3
'''

ISP3_TGME49_Hits = ISP3_BioID['ME49_Ortholog'].dropna().unique().tolist()
ISP3_TGME49_TopHit = []
for i in range(len(ISP3_BioID)):
    if ISP3_BioID['X'][i] != '[-]group':
        ISP3_TGME49_TopHit.append(ISP3_BioID['ME49_Ortholog'][i])
ISP3_TGME49_TopHits = [x for x in ISP3_TGME49_TopHit if str(x) != 'nan']
ISP3_TGME49_TopHit = set(ISP3_TGME49_TopHits)
ISP3_TGME49_TopHits = list(ISP3_TGME49_TopHit)

ISP3_Network_TopHits = []
for val in ISP3_TGME49_TopHits:
    if val in NetworkProt:
        ISP3_Network_TopHits.append(val)

ISP3_Protein = []
ISP3_AverageShortestPathLength = []
ISP3_ShortestPaths = []
for i in range(len(ISP3_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(ISP3_Network_TopHits)):
        if ISP3_Network_TopHits[i] != ISP3_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, ISP3_Network_TopHits[i], ISP3_Network_TopHits[x]))
    ISP3_Protein.append(ISP3_Network_TopHits[i])
    ISP3_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    ISP3_ShortestPaths.append(ShortestPathLengths)

ISP3_RandomSubnetwork_ASPL = []
for i in range(1000):
    ISP3_Random = random.sample(NetworkProt, len(ISP3_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(ISP3_Random)):
        ShortestPathLengths = []
        for x  in range(len(ISP3_Random)):
            if ISP3_Random[i] != ISP3_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, ISP3_Random[i], ISP3_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    ISP3_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(ISP3_RandomSubnetwork_ASPL)
s.mean(ISP3_AverageShortestPathLength)    
sum(i < s.mean(ISP3_AverageShortestPathLength) for i in ISP3_RandomSubnetwork_ASPL)/len(ISP3_RandomSubnetwork_ASPL)

'''
AC2
'''

AC2_TGME49_Hits = AC2_BioID['ME49_Ortholog'].dropna().unique().tolist()
AC2_TGME49_TopHit = []
for i in range(len(AC2_BioID)):
    if AC2_BioID['In_Control'][i] == 'No':
        AC2_TGME49_TopHit.append(AC2_BioID['ME49_Ortholog'][i])
AC2_TGME49_TopHits = [x for x in AC2_TGME49_TopHit if str(x) != 'nan']
AC2_TGME49_TopHit = set(AC2_TGME49_TopHits)
AC2_TGME49_TopHits = list(AC2_TGME49_TopHit)

AC2_Network_TopHits = []
for val in AC2_TGME49_TopHits:
    if val in NetworkProt:
        AC2_Network_TopHits.append(val)

AC2_Protein = []
AC2_AverageShortestPathLength = []
AC2_ShortestPaths = []
for i in range(len(AC2_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(AC2_Network_TopHits)):
        if AC2_Network_TopHits[i] != AC2_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, AC2_Network_TopHits[i], AC2_Network_TopHits[x]))
    AC2_Protein.append(AC2_Network_TopHits[i])
    AC2_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    AC2_ShortestPaths.append(ShortestPathLengths)

AC2_RandomSubnetwork_ASPL = []
for i in range(1000):
    AC2_Random = random.sample(NetworkProt, len(AC2_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(AC2_Random)):
        ShortestPathLengths = []
        for x  in range(len(AC2_Random)):
            if AC2_Random[i] != AC2_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, AC2_Random[i], AC2_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    AC2_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(AC2_RandomSubnetwork_ASPL)
s.mean(AC2_AverageShortestPathLength)    
sum(i < s.mean(AC2_AverageShortestPathLength) for i in AC2_RandomSubnetwork_ASPL)/len(AC2_RandomSubnetwork_ASPL)

'''
GRA1
'''

GRA1_Hits = list(GRA1_BioID['ME49_Ortholog'])

GRA1_Network_TopHits = []
for val in GRA1_Hits:
    if val in NetworkProt:
        GRA1_Network_TopHits.append(val)

GRA1_Protein = []
GRA1_AverageShortestPathLength = []
GRA1_ShortestPaths = []
for i in range(len(GRA1_Network_TopHits)):
    ShortestPathLengths = []
    for x  in range(len(GRA1_Network_TopHits)):
        if GRA1_Network_TopHits[i] != GRA1_Network_TopHits[x]:
            ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA1_Network_TopHits[i], GRA1_Network_TopHits[x]))
    GRA1_Protein.append(GRA1_Network_TopHits[i])
    GRA1_AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA1_ShortestPaths.append(ShortestPathLengths)

GRA1_RandomSubnetwork_ASPL = []
for i in range(1000):
    GRA1_Random = random.sample(NetworkProt, len(GRA1_Network_TopHits))
    AverageShortestPathLength = []
    for i in range(len(GRA1_Random)):
        ShortestPathLengths = []
        for x  in range(len(GRA1_Random)):
            if GRA1_Random[i] != GRA1_Random[x]:
                ShortestPathLengths.append(nx.shortest_path_length(ToxoNetwork, GRA1_Random[i], GRA1_Random[x]))
        AverageShortestPathLength.append(s.mean(ShortestPathLengths))
    GRA1_RandomSubnetwork_ASPL.append(s.mean(AverageShortestPathLength))
    
sns.distplot(GRA1_RandomSubnetwork_ASPL)
s.mean(GRA1_AverageShortestPathLength)    
sum(i < s.mean(GRA1_AverageShortestPathLength) for i in GRA1_RandomSubnetwork_ASPL)/len(GRA1_RandomSubnetwork_ASPL)

GRA1_dictionary = {'GRA1_RandomSubnetwork_ASPL':GRA1_RandomSubnetwork_ASPL}
dataframe_GRA1_RandomSubnetwork_ASPL = pd.DataFrame(GRA1_dictionary,columns=['GRA1_RandomSubnetwork_ASPL'])
dataframe_GRA1_RandomSubnetwork_ASPL.to_csv('/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA1_RandomSubnetwork_ASPL.csv',index=False,header=None)

GRA1Plot = sns.distplot(GRA1_RandomSubnetwork_ASPL, color='gray')
GRA1Plot.set_xlabel('Characteristic Path Length')
GRA1Plot.set_ylabel('Density')
GRA1Plot.axvline(s.mean(GRA1_RandomSubnetwork_ASPL),0,0.860,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) + s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.445,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) - s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.485,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) + 2*s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.140,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) - 2*s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.140,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) + 3*s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.010,color='gray',linestyle='dashed')
GRA1Plot.axvline((s.mean(GRA1_RandomSubnetwork_ASPL) - 3*s.stdev(GRA1_RandomSubnetwork_ASPL)),0,0.005,color='gray',linestyle='dashed')
GRA1Plot.axvline(s.mean(GRA1_AverageShortestPathLength),0,1,color='red')

GRA1Graph = GRA1Plot.get_figure()
GRA1Graph.savefig("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/BioID/GRA1Graph_BioID.svg", format="svg")

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  5 16:26:02 2019

@author: grantstevens
"""

import numpy as np
import pandas as pd
from pandas import DataFrame

def comp(list1,list2):
    c = 0
    for val in list1:
        if val in list2:
            c += 1
    return c


IMCProteins =  np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/IMC_Proteins.txt',header=None))
CoelutionPCC = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/profiles_pcc_zero.csv'))
CoelutionWCC = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/profiles_wcc_zero.csv'))

IMC_Proteins = []
for i in range(len(IMCProteins)):
    IMC_Proteins.append(IMCProteins[i][0])

IMC_Coelution_proteins = []
IMC_pairs = []    
for i in range(len(CoelutionPCC)):
    pair = CoelutionPCC[i][0].split('-')
    if comp(pair,IMC_Proteins) == 2:
        IMC_pairs.append(CoelutionPCC[i])
        IMC_Coelution_proteins.append(pair[0])
        IMC_Coelution_proteins.append(pair[1])
        
IMC_Coelution_set = set(IMC_Coelution_proteins)
IMC_Coelution_proteins = list(IMC_Coelution_set)

IMCProteinMatrix = DataFrame(index=IMC_Coelution_proteins,columns=IMC_Coelution_proteins)

for i in range(len(IMC_pairs)):
    protein1 = IMC_pairs[i][0].split('-')[0]
    protein2 = IMC_pairs[i][0].split('-')[1]
    scores = []
    for x in range(len(IMC_pairs[i])):
        if type(IMC_pairs[i][x]) == float:
            scores.append(IMC_pairs[i][x])
    IMCProteinMatrix[protein1][protein2] = max(scores)
    IMCProteinMatrix[protein2][protein1] = max(scores)

IMCProteinMatrix.fillna(0, inplace=True)
IMCProteinMatrix.to_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/IMCProteins_Coelutionpcc.tab',sep='\t')

##Doing this for WCC
IMC_Coelution_proteins = []
IMC_wccpairs = []    
for i in range(len(CoelutionWCC)):
    pair = CoelutionWCC[i][0].split('-')
    if comp(pair,IMC_Proteins) == 2:
        IMC_wccpairs.append(CoelutionWCC[i])
        IMC_Coelution_proteins.append(pair[0])
        IMC_Coelution_proteins.append(pair[1])
        
IMC_Coelution_set = set(IMC_Coelution_proteins)
IMC_Coelution_proteins = list(IMC_Coelution_set)

IMCProteinWCCMatrix = DataFrame(index=IMC_Coelution_proteins,columns=IMC_Coelution_proteins)

for i in range(len(IMC_wccpairs)):
    protein1 = IMC_wccpairs[i][0].split('-')[0]
    protein2 = IMC_wccpairs[i][0].split('-')[1]
    scores = []
    for x in range(len(IMC_wccpairs[i])):
        if type(IMC_wccpairs[i][x]) == float:
            scores.append(IMC_wccpairs[i][x])
    IMCProteinWCCMatrix[protein1][protein2] = max(scores)
    IMCProteinWCCMatrix[protein2][protein1] = max(scores)

IMCProteinWCCMatrix.fillna(0, inplace=True)
IMCProteinWCCMatrix.to_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/IMCProteins_Coelutionwcc.tab',sep='\t')

##Coapex

CoelutionCoapex = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/profiles_coapex.csv'))

IMCProteinCoapexMatrix = DataFrame(index=IMC_Coelution_proteins,columns=IMC_Coelution_proteins)

IMC_coapexpairs = []    
for i in range(len(CoelutionCoapex)):
    pair = CoelutionCoapex[i][0].split('-')
    if comp(pair,IMC_Proteins) == 2:
        IMCProteinCoapexMatrix[pair[0]][pair[1]] = CoelutionCoapex[i][1]
        IMCProteinCoapexMatrix[pair[1]][pair[0]] = CoelutionCoapex[i][1]

IMCProteinCoapexMatrix.fillna(0, inplace=True)
IMCProteinCoapexMatrix.to_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/IMCProteins_CoelutionCoapex.tab',sep='\t')

##LOW CONFIDENCE NETWORK SCORES
LCNetwork = np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/EdgeFile_Codes_LowConfidenceNetwork.tab',header=None))
IMCProteinNetworkMatrix = DataFrame(index=IMC_Coelution_proteins,columns=IMC_Coelution_proteins)

IMC_coapexpairs = []    
for i in range(len(LCNetwork)):
    pair = LCNetwork[i][0].split('\t')[0:2]
    if comp(pair,IMC_Proteins) == 2:
        IMCProteinNetworkMatrix[pair[0]][pair[1]] = float(LCNetwork[i][0].split('\t')[2])
        IMCProteinNetworkMatrix[pair[1]][pair[0]] = float(LCNetwork[i][0].split('\t')[2])

IMCProteinNetworkMatrix.fillna(0, inplace=True)
IMCProteinNetworkMatrix.to_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/IMCProteins_NetworkScores.tab',sep='\t')


###Doing this for Ribosomes!!!

RibosomeProteins =  np.array(pd.read_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/RibosomeProteins.txt',header=None))

Ribosome_Proteins = []
for i in range(len(RibosomeProteins)):
    Ribosome_Proteins.append(RibosomeProteins[i][0])

Ribosome_Coelution_proteins = []
Ribosome_pairs = []    
for i in range(len(CoelutionPCC)):
    pair = CoelutionPCC[i][0].split('-')
    if comp(pair,Ribosome_Proteins) == 2:
        Ribosome_pairs.append(CoelutionPCC[i])
        Ribosome_Coelution_proteins.append(pair[0])
        Ribosome_Coelution_proteins.append(pair[1])
        
Ribosome_Coelution_set = set(Ribosome_Coelution_proteins)
Ribosome_Coelution_proteins = list(Ribosome_Coelution_set)

RibosomeProteinMatrix = DataFrame(index=Ribosome_Coelution_proteins,columns=Ribosome_Coelution_proteins)

for i in range(len(Ribosome_pairs)):
    protein1 = Ribosome_pairs[i][0].split('-')[0]
    protein2 = Ribosome_pairs[i][0].split('-')[1]
    scores = []
    for x in range(len(Ribosome_pairs[i])):
        if type(Ribosome_pairs[i][x]) == float:
            scores.append(Ribosome_pairs[i][x])
    RibosomeProteinMatrix[protein1][protein2] = max(scores)
    RibosomeProteinMatrix[protein2][protein1] = max(scores)

RibosomeProteinMatrix.fillna(0, inplace=True)
RibosomeProteinMatrix.to_csv('/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/IMC_Structure/RibosomeProteins_Coelutionpcc.tab',sep='\t')

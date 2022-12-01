#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 19 15:50:34 2017

@author: grantstevens
"""

import numpy as np
import pandas as pd
from pandas import DataFrame

#This section incorporates Cluster Members, Size and Density into NodeTable



#Cluster_Data = pd.read_csv("Clusters.csv")

Clusters = []
for i in range(1,94):
    cluster = str("Cluster {a}".format(a=i))
    Clusters.append(cluster)    

NodeTable = DataFrame(index=Clusters,columns = ["Components","Size","Density","Bader-Hogue_Complex","Bader-Hogue_Score","Apicomplexan","Eukaryote","Coccidian","Toxoplasma","Phosphorylated","Unphosphorylated","Essential","Dispensable","Average_Phenotype_Score","Localization","TargetP_M(%)","TargetP_S(%)","TargetP_O(%)","Average_Coexpression_pcc"])

'''
for i in range(93):
    cluster = str("Cluster {a}".format(a=(i+1)))
    size = Cluster_Data['Size'][i]
    density = Cluster_Data['Density'][i]
    members = Cluster_Data['Members'][i]
    NodeTable['Components'][cluster] = members
    NodeTable['Size'][cluster] = size
    NodeTable['Density'][cluster] = density

'''

#This section incorporates Lineage information into NodeTable AND TargetP predictions
    
Cluster_Data = np.array(pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab",header=None))
Lineage_Data = pd.read_csv("LineageNodeTable.csv",index_col=0)
#TargetP_Data = pd.read_csv("/home/grantstevens/Desktop/ToxoNet_FinalNetwork_011519/Super_Network/MakingNodeTable/TargetP_Predictions_NodeTable.csv",index_col=0)

c = 1
for line in Cluster_Data:
    cluster_name = str("Cluster {a}".format(a=c))
    cluster = list(line)    
    cluster = cluster[0].split('\t')
    cluster_size = len(cluster)
    Eukaryote_list = []
    Toxoplasma_list = []
    Coccidian_list = []
    Apicomplexan_list = []
    Target_M = []
    Target_S = []
    Target_O = []
    for item in cluster:
        if Lineage_Data['Lineage'][item] == "Eukaryotes":
            Eukaryote_list.append(item)
        elif Lineage_Data['Lineage'][item] == "Apicomplexa":
            Apicomplexan_list.append(item)
        elif Lineage_Data['Lineage'][item] == "Coccidia":
            Coccidian_list.append(item)
        else:
            Toxoplasma_list.append(item)
#        if TargetP_Data['Loc'][item] == 'M':
#            Target_M.append(item)
#        elif TargetP_Data['Loc'][item] == 'S':
#            Target_S.append(item)
#        else:
#            Target_O.append(item)
    Apicomplexan = (len(Apicomplexan_list))/cluster_size
    Eukaryote = (len(Eukaryote_list))/cluster_size
    Coccidian = (len(Coccidian_list))/cluster_size
    Toxoplasma = (len(Toxoplasma_list))/cluster_size
#    Mito_TargetP = (len(Target_M))/cluster_size
#    Sec_TargetP = (len(Target_S))/cluster_size
#    Other_TargetP = (len(Target_O))/cluster_size

    NodeTable['Apicomplexan'][cluster_name] = Apicomplexan
    NodeTable['Eukaryote'][cluster_name] = Eukaryote
    NodeTable['Coccidian'][cluster_name] = Coccidian
    NodeTable['Toxoplasma'][cluster_name] = Toxoplasma
#    NodeTable['TargetP_M(%)'][cluster_name] = Mito_TargetP
#    NodeTable['TargetP_S(%)'][cluster_name] = Sec_TargetP
#    NodeTable['TargetP_O(%)'][cluster_name] = Other_TargetP

    c += 1

#This section incorporates Phosphorylation/Essentiality information into NodeTable
    
Cluster_Data = np.array(pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab",header=None))
Phos_Data = pd.read_csv("PhosphoproteomeNodeTable.csv",index_col=0)
Essential_Data = pd.read_csv("EssentialityNodeTable.csv",index_col=0)
Essential_Data.fillna('Empty',inplace=True)

c = 1
for line in Cluster_Data:
    cluster_name = str("Cluster {a}".format(a=c))
    cluster = list(line)    
    cluster = cluster[0].split('\t')
    cluster_size = len(cluster)
    Phos_Yes_list = []
    Phos_No_list = []
    Essential_list = []
    Dispensable_list = []
    Phenotype_Score = []
    
    for item in cluster:
        if Phos_Data['Phosphorylation'][item] == "Yes":
            Phos_Yes_list.append(item)
        elif Phos_Data['Phosphorylation'][item] == "No":
            Phos_No_list.append(item)
        
        if Essential_Data['Essentiality'][item] == "Essential":
            Essential_list.append(item)
        elif Essential_Data['Essentiality'][item] == "Dispensable":
            Dispensable_list.append(item)
        
        phenotype_score = Essential_Data['Phenotype Score'][item]
        Phenotype_Score.append(phenotype_score)
          
    Phenotype_Score = [x for x in Phenotype_Score if x != 'Empty']
    average_phenotype_score = sum(Phenotype_Score)/len(Phenotype_Score)
    
    PhosphoYes = (len(Phos_Yes_list))/cluster_size
    PhosphoNo = (len(Phos_No_list))/cluster_size
    Essential = (len(Essential_list))/cluster_size
    Dispensable = (len(Dispensable_list))/cluster_size

    NodeTable['Phosphorylated'][cluster_name] = PhosphoYes
    NodeTable['Unphosphorylated'][cluster_name] = PhosphoNo
    NodeTable['Essential'][cluster_name] = Essential
    NodeTable['Dispensable'][cluster_name] = Dispensable
    NodeTable['Average_Phenotype_Score'][cluster_name] = average_phenotype_score

    c += 1

#I'm just going to manually add the Bader-Hogue Information

NodeTable['Bader-Hogue_Complex']['Cluster 72'] = 'protein_kinase_CK2_complex+UTP_C_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 33'] = 'U4/U6_x_U5_tri-snRNP_complex+U5_snRNP_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 54'] = 'reductive_TCA_cycle_I+TCA_cycle'
NodeTable['Bader-Hogue_Complex']['Cluster 56'] = 'C_complex_spliceosome+Exon_junction_complex+Exon_junction_complex_(F4A3-MLN51-UPF3B-MAGOH-Y14-PYM)+Spliceosome'
NodeTable['Bader-Hogue_Complex']['Cluster 77'] = 'formaldehyde_oxidation_I+heterolactic_fermentation+pentose_phosphate_pathway_(oxidative_branch)+superpathway_of_glycolysis_and_Entner-Doudoroff'
NodeTable['Bader-Hogue_Complex']['Cluster 81'] = 'Chz1p/Htz1p/Htb1p_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 7'] = '20S_proteasome'
NodeTable['Bader-Hogue_Complex']['Cluster 70'] = 'box_C/D_snoRNP_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 89'] = 'formaldehyde_oxidation_I+heterolactic_fermentation'
NodeTable['Bader-Hogue_Complex']['Cluster 11'] = 'sucrose_degradation_to_ethanol_and_lactate_(anaerobic)'
NodeTable['Bader-Hogue_Complex']['Cluster 53'] = 'H+-transporting_ATPase'
NodeTable['Bader-Hogue_Complex']['Cluster 44'] = 'eIF3_complex_(EIF3S6'
NodeTable['Bader-Hogue_Complex']['Cluster 6'] = 'Membrane_protein_complex_(VCP'
NodeTable['Bader-Hogue_Complex']['Cluster 36'] = 'Cofilin-actin-CAP1_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 47'] = 'Cofilin-actin-CAP1_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 92'] = 'Exon_junction_complex+Spliceosome'
NodeTable['Bader-Hogue_Complex']['Cluster 57'] = '17S_U2_snRNP+Spliceosome'
NodeTable['Bader-Hogue_Complex']['Cluster 50'] = 'snRNP-free_U1A_(SF-A)_complex+Spliceosome'
NodeTable['Bader-Hogue_Complex']['Cluster 82'] = 'cysteine_biosynthesis_II+serine_biosynthesis'
NodeTable['Bader-Hogue_Complex']['Cluster 3'] = '60S_ribosomal_subunit'
NodeTable['Bader-Hogue_Complex']['Cluster 35'] = 'HCF-1_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 31'] = 'eIF2+multi-eIF_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 52'] = 'Chz1p/Htz1p/Htb1p_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 66'] = 'U4/U6_x_U5_tri-snRNP_complex+U6_snRNP_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 13'] = 'prefoldin_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 34'] = 'pyrimidine_deoxyribonucleotides_de_novo_biosynthesis_I'
NodeTable['Bader-Hogue_Complex']['Cluster 45'] = 'HCF-1_complex+HSP70-BAG5-PARK2_complex'
NodeTable['Bader-Hogue_Complex']['Cluster 60'] = 'HCF-1_complex+HSP70-BAG5-PARK2_complex'
         
NodeTable['Bader-Hogue_Score']['Cluster 72'] = 1
NodeTable['Bader-Hogue_Score']['Cluster 33'] = 0.7901234568
NodeTable['Bader-Hogue_Score']['Cluster 54'] = 0.75
NodeTable['Bader-Hogue_Score']['Cluster 56'] = 0.75
NodeTable['Bader-Hogue_Score']['Cluster 77'] = 0.6666666667
NodeTable['Bader-Hogue_Score']['Cluster 81'] = 0.6666666667
NodeTable['Bader-Hogue_Score']['Cluster 7'] = 0.6363636364
NodeTable['Bader-Hogue_Score']['Cluster 70'] = 0.6
NodeTable['Bader-Hogue_Score']['Cluster 89'] = 0.6
NodeTable['Bader-Hogue_Score']['Cluster 11'] = 0.5833333333
NodeTable['Bader-Hogue_Score']['Cluster 53'] = 0.5555555556
NodeTable['Bader-Hogue_Score']['Cluster 44'] = 0.5102040816
NodeTable['Bader-Hogue_Score']['Cluster 6'] = 0.5
NodeTable['Bader-Hogue_Score']['Cluster 36'] = 0.5
NodeTable['Bader-Hogue_Score']['Cluster 47'] = 0.5
NodeTable['Bader-Hogue_Score']['Cluster 92'] = 0.5
NodeTable['Bader-Hogue_Score']['Cluster 57'] = 0.4464285714
NodeTable['Bader-Hogue_Score']['Cluster 50'] = 0.4
NodeTable['Bader-Hogue_Score']['Cluster 82'] = 0.4
NodeTable['Bader-Hogue_Score']['Cluster 3'] = 0.3743633277
NodeTable['Bader-Hogue_Score']['Cluster 35'] = 0.3555555556
NodeTable['Bader-Hogue_Score']['Cluster 31'] = 0.3333333333
NodeTable['Bader-Hogue_Score']['Cluster 52'] = 0.2857142857
NodeTable['Bader-Hogue_Score']['Cluster 66'] = 0.2666666667
NodeTable['Bader-Hogue_Score']['Cluster 13'] = 0.25
NodeTable['Bader-Hogue_Score']['Cluster 34'] = 0.25
NodeTable['Bader-Hogue_Score']['Cluster 45'] = 0.25
NodeTable['Bader-Hogue_Score']['Cluster 60'] = 0.25 

#Determining Predicted Localization

Cluster_Data = np.array(pd.read_csv("/home/grantstevens/Desktop/ToxoNet_Final_UnsupervisedCutoff0.5/CLUSTERS_coexpr_ge0.5_max_based_5p.tab.d0.25.tab",header=None))
Localization_Data = pd.read_csv('GenesByTaxon_Summary_Modified.txt.computed_go_components_withInvasion',index_col=0)
#Localization_Data.fillna('Empty',inplace=True)

c = 1
for line in Cluster_Data:
    cluster_name = str("Cluster {a}".format(a=c))
    cluster = list(line)    
    cluster = cluster[0].split('\t')
    cluster_size = len(cluster)
    Localization_list = []

    for item in cluster:
        localization = Localization_Data['Computed GO Components'][item]
        Localization_list.append(localization)
    
    #NodeTable['Localization'][cluster_name] = Localization_list
#Instead of adding all the Go Components, as it does above, I'm goign to add the count list.
    
    Localization_set = set(Localization_list)
    Localization_count = []
    for i in range(len(Localization_set)):
        count = Localization_list.count(list(Localization_set)[i])
        if count < 10:
            Localization_count.append(str("0{a}:{b}".format(a=count,b=list(Localization_set)[i])))
        else:
            Localization_count.append(str("{a}:{b}".format(a=count,b=list(Localization_set)[i])))
    Localization_count.sort(reverse=True)
    NodeTable['Localization'][cluster_name] = Localization_count
    
    c += 1

#Export this bad boy
    
NodeTable.to_csv("SuperNetwork_NodeTable.tab",sep="\t")
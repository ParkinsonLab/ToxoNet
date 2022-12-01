# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import pandas as pd
import sys

#Here I'm defining a function that can compare two lists and return an integer of the number of shared components
def comp(list1,list2):
    c = 0
    for val in list1:
        if val in list2:
            c += 1
    return c

infile = sys.argv[1]

data = np.array(pd.read_csv(infile,header=None))
complex_array = np.array(pd.read_csv('/home/grantstevens/Desktop/Bader-Hogue_Score/PythonScript/All_Final_Clusters/training_set_clusters_ordered.csv',header=None))

c=0
for line in data:
    cluster = list(line)    
    cluster = cluster[0].split('\t')
    cluster_size = len(cluster)
      
    if cluster_size >= 2:
        bader_hogue_score = 0
        complex_ID = 'complex'
        number_shared = 0
        
        for line2 in complex_array:
            complex = list(line2)
            complex_ID1 = complex[0]
            complex = [x for x in complex if str(x).startswith('TGME49_')]
            complex_size = len(complex)
            
            number_shared1 = comp(cluster,complex)
            bh1 = (number_shared1*number_shared1)/(cluster_size*complex_size)
            
            if bh1 > bader_hogue_score:
                bader_hogue_score = bh1
                complex_ID = complex_ID1
                number_shared = number_shared1
        
        c+=1
        print(c,"@",cluster,"@",complex_ID,"@",number_shared,"@",bader_hogue_score)

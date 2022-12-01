#!/usr/bin/env python

#This code creates a  phylogenetic profile based on BLASTP evalues for all the proteins in an organism vs. a set of organisms
#Currently it is for the format of a phylopro formatted BLASTP file for the organism of interest. eg. Tgondii-Celegans, Tgondi-Hsapiens etc.

#Input files: <File with all protein codes for the organism of interest> <File with location of all the BLASTP files for all organisms>
#Output files: 2 matrix files - matrix_evalue.csv and matrix_pij.csv, containing MxN matrix with 'M' organisms and 'N' proteins, containing the value of Evalueij and -1/log10(Evalueij) (truncated for all values beyond beyond Evalue >0.99, as log of 1 is 0)

#Example - python phylogenetic_profiles.py phylopro_id.txt files_location.lst

import sys
import re
import math

#Getting total number of proteins in the file
with open(sys.argv[1]) as fpid:
	ct_pid=sum(1 for _ in fpid)

#Storing all the protein ids in an array
with open(sys.argv[1]) as fid:
	pid_list=[]
	for line in fid:
		pid_list.append(line.strip())


#Getting total number of organisms in the file
with open(sys.argv[2]) as forg_all:
	ct_org=sum(1 for _ in forg_all)

with open(sys.argv[2]) as forg_all:
	org_list=[]
	for line in forg_all:
		org_list.append(line.strip())

print ct_pid , ct_org
print pid_list
print org_list

#Populating a ct_org * ct_pid matrix with evalue of 0.999

eval= [[0.999]*ct_pid for x in xrange(ct_org)]
pij= [[1.000]*ct_pid for x in xrange(ct_org)]

print eval[0][1]
print pij[0][1]

#Opening the files and uploading each Evalue to the correct entitty
print "Getting evalues"
with open(sys.argv[2]) as forg:
	j=0
	for lorg in forg:
		print lorg
		prev_code="TMP_VAR"
		lorg=lorg.strip()
		with open(lorg) as org:
			for line in org:
				#print line
				fields=line.split('\t')
				#cur_code=fields[0].strip()
				if prev_code != fields[0].strip():
					i=0
					for i in xrange(0,ct_pid-1):
						#print pid_list[i],fields[0]
						#cur=pid_list[i].strip()
						#if cur_code == cur:
						if fields[0].strip() == pid_list[i].strip():
							#print "In here"
							eval[j][i]=float(fields[3].strip())
							#if fields[3].strip()=="0":
							#	print "In here"
							#	eval[j][i]=1e-311
							#print i,j,eval[j][i],fields[0]
							pij[j][i]=-1/math.log10(eval[j][i] if eval[j][i]>0 else 1e-311) #1e-311 is the best evalue after 0 in my dataset
							#pij[j][i]=-1/math.log10(eval[j][i]) #1e-311 is the best evalue after 0 in my dataset
							#print i,j,eval[j][i],fields[0],pij[j][i]
							break
						i=i+1
				prev_code=fields[0].strip()			
		j=j+1

print "Printing matrix into output file"

outfile_evalue=open("matrix_evalue.csv","w")
outfile_evalue.write("Organism/Gene,")

for i in xrange(0,ct_pid):
	outfile_evalue.write(pid_list[i].strip())
	outfile_evalue.write(",")
outfile_evalue.write("\n")
 
for j in xrange(0,ct_org):
	outfile_evalue.write(org_list[j].strip())
	outfile_evalue.write(",")
        for i in xrange(0,ct_pid):
                outfile_evalue.write("%s," %eval[j][i])
	outfile_evalue.write("\n")

outfile_pij=open("matrix_pij.csv","w")
outfile_pij.write("Organism/Gene,")

for i in xrange(0,ct_pid):
        outfile_pij.write(pid_list[i].strip())
        outfile_pij.write(",")
outfile_pij.write("\n")

for j in xrange(0,ct_org):
        outfile_pij.write(org_list[j].strip())
        outfile_pij.write(",")
        for i in xrange(0,ct_pid):
                outfile_pij.write("%s," %pij[j][i])
        outfile_pij.write("\n")


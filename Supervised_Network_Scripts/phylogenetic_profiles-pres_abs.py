#!/usr/bin/env python

#This code creates a  phylogenetic profile based on presence/absence of an ortholog for all proteins in an organism vs. a set of organisms (only the main orthologs are considered - ie. the one with 1.000 score)
#This is based on the table.Tgondii-Celegans.fa etc eg. Tgondii-Celegans, Tgondi-Hsapiens etc.

#Input files: <File with all protein codes for the organism of interest> <File with location of all the inparanoid results for all organisms>
#Output files: 1 matrix files - matrix_presence_absence.csv, containing MxN matrix with 'M' organisms and 'N' proteins, containing the value of 1 (for presence) and 0(for absence))

#Example - python phylogenetic_profiles.py phylopro_id.txt files_location_table.lst

import sys
import re

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

#Populating a ct_org * ct_pid matrix with value of 0 (indicating absence - by default)
#Titbit: xrange is supposed to be a generator instead of range (a list) - so does not consume as much memory - better for performance
mat=[[0]*ct_pid for x in xrange(ct_org)]

print mat[0][1]

#Opening the files and capturing presence/absence correctly
print "Getting presence / absence of all proteins for each organism"
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
				if fields[2].split(' ') != 'OrtoA':
					orthologs=fields[2].split(' ')
					#print orthologs
					main_orthologs=[]
					for y in xrange(0,len(orthologs)):
						if orthologs[y].strip() == '1.000':
							#print "Here"
							main_orthologs.append(orthologs[y-1])
						y=y+1
					for z in xrange(0,len(main_orthologs)):
						#print main_orthologs[z]
						for i in xrange(0,ct_pid-1):
							#print pid_list[i],fields[0]
							#cur=pid_list[i].strip()
							#if cur_code == cur:
							if main_orthologs[z].strip() == pid_list[i].strip():
								#print "In here"
								mat[j][i]=1
								break
							i=i+1
						z=z+1
		j=j+1

print "Printing matrix into output file"

outfile_presabs=open("matrix_pres-abs.csv","w")
outfile_presabs.write("Organism/Gene,")

for i in xrange(0,ct_pid):
	outfile_presabs.write(pid_list[i].strip())
	outfile_presabs.write(",")
outfile_presabs.write("\n")
 
for j in xrange(0,ct_org):
	outfile_presabs.write(org_list[j].strip())
	outfile_presabs.write(",")
        for i in xrange(0,ct_pid):
                outfile_presabs.write("%d," %mat[j][i])
	outfile_presabs.write("\n")

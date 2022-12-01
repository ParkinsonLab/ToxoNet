#Calculate scores from "gene fusion", "text mining" and "experiments" from STRING database for the organism of interest 

sh string-gene_fusion.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_gene_fusion.tab

sh string-gene_fusion_detailed.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_gene_fusion_detailed.tab

sh string-textmining.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_textmining.tab

sh string-textmining_detailed.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_textmining_detailed.tab

sh string-experiments.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_experiments.tab

sh string-experiments_detailed.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_experiments_detailed.tab

#Retaining all pairs with atleast medium confidence STRING scores (ie. >=400)

awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_gene_fusion.tab > ../data/string/scores/string_v10.5_gene_fusion_mc.tab
awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_gene_fusion_detailed.tab > ../data/string/scores/string_v10.5_gene_fusion_detailed_mc.tab

awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_textmining.tab > ../data/string/scores/string_v10.5_textmining_mc.tab
awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_textmining_detailed.tab > ../data/string/scores/string_v10.5_textmining_detailed_mc.tab

awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_experiments.tab > ../data/string/scores/string_v10.5_experiments_mc.tab
awk '$NF>=400 {print $0}' ../data/string/scores/string_v10.5_experiments_detailed.tab > ../data/string/scores/string_v10.5_experiments_detailed_mc.tab

#Creating a "STRING medium confidence" and "STRING high confidence" set (since there is hardly any overlap among methods.. only 2 pairs overlap"
#NOTE: Experiments are all high confidence (800), gene fusion also has half as high confidence, text mining is all medium confidence 

for pair in `awk '{print $1","$2}' ../data/string/scores/string_v10.5_textmining_mc.tab ../data/string/scores/string_v10.5_gene_fusion_mc.tab ../data/string/scores/string_v10.5_experiments_mc.tab | sort -u`; do code1=`echo $pair | awk -F "," '{print $1}'`; code2=`echo $pair | awk -F "," '{print $2}'`; grep -h "$code1" ../data/string/scores/string_v10.5_textmining_mc.tab ../data/string/scores/string_v10.5_gene_fusion_mc.tab ../data/string/scores/string_v10.5_experiments_mc.tab | grep "$code2" | sort -k3gr | head -1; done > ../data/string/scores/string_v10.5_mc.tab

awk '$NF>=700 {print $0}' ../data/string/scores/string_v10.5_mc.tab > ../data/string/scores/string_v10.5_hc.tab 

for pair in `awk '{print $1","$2}' ../data/string/scores/string_v10.5_textmining.tab ../data/string/scores/string_v10.5_gene_fusion.tab ../data/string/scores/string_v10.5_experiments.tab | sort -u`; do code1=`echo $pair | awk -F "," '{print $1}'`; code2=`echo $pair | awk -F "," '{print $2}'`; grep -h "$code1" ../data/string/scores/string_v10.5_textmining.tab ../data/string/scores/string_v10.5_gene_fusion.tab ../data/string/scores/string_v10.5_experiments.tab | grep "$code2" | sort -k3gr | head -1; done > ../data/string/scores/string_v10.5.tab

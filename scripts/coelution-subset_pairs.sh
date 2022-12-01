#Generate set of all_pair combinations
awk '{print $1}' ../data/coelution/scores/wcc/wcc_all_expts_cleaned_mF1.tab | awk -F "_" '{print $1"_"$2}' > one
awk '{print $2}' ../data/coelution/scores/wcc/wcc_all_expts_cleaned_mF1.tab | awk -F "_" '{print $1"_"$2}' > two
paste -d , one two > three 
perl ~/workspace/scripts/perl/check_duplicates_2cols.pl three | sort -u > ../data/coelution/all_combos_coelution_mF1.csv  

awk '{print $1}' ../data/coelution/scores/wcc/wcc_all_expts_cleaned_mF2.tab | awk -F "_" '{print $1"_"$2}' > one
awk '{print $2}' ../data/coelution/scores/wcc/wcc_all_expts_cleaned_mF2.tab | awk -F "_" '{print $1"_"$2}' > two
paste -d , one two > three
perl ~/workspace/scripts/perl/check_duplicates_2cols.pl three | sort -u > ../data/coelution/all_combos_coelution_mF2.csv

#Generate set of all combinations with pccnm or wcc >= 0.5
perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF1 ../data/combos_with_pcc_or_wcc_ge0.5_mF1_raw_counts.csv 
perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF2 ../data/combos_with_pcc_or_wcc_ge0.5_mF2_raw_counts.csv


#Generate set of all combinations with pccnm_cn or wcc_cn >= 0.5

#!!! Note - this needs tweaking of the coelution-pairs_with_pcc_or_wcc_ge0.5.pl file in order to indicate correct input files
perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF1 ../data/combos_with_pcc_or_wcc_ge0.5_mF1_cn.csv

perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF2 ../data/combos_with_pcc_or_wcc_ge0.5_mF2_cn.csv

#Generate set of all combinations with pccnm_rn or wcc_rn >= 0.5
#!!! Note - this needs tweaking of the coelution-pairs_with_pcc_or_wcc_ge0.5.pl file in order to indicate correct input files
perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF1 ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv

perl coelution-pairs_with_pcc_or_wcc_ge0.5.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/pccnm/ ../data/coelution/scores/wcc/ mF2 ../data/combos_with_pcc_or_wcc_ge0.5_mF2_rn.csv

perl integrate_datasets-all_data_for_dataset.pl ../data/allscores_mF1/ ../data/allscores_mF1/pccnm_all_expts_cleaned_mF1.tab ../data/integrated_datasets_allscores_mF1.tab
out_file=`echo $3 | sed 's/.tab//g'`

#perl integrate_datasets-all_data_for_dataset.pl $1 $2 $3 

sed 's/\t$//g' ../data/integrated_datasets_allscores_mF1.tab  > chk

perl integrate_datasets-transpose_matrix.pl chk > chk.me 

awk -F "\t" '{print $0",yes"}' chk.me | sed 's/,TGME49/-TGME49/g' | sed 's/\t/,/g' | sed 's/,-,/,?,/g' | sed 's/-nan/0/g' | sed 's/.tab,yes/.tab,Outcome/' > ../data/integrated_datasets_allscores_mF1"_profiles.csv"

sed 's/NA/?/g' integrated_datasets_allscores_mF1"_profiles.csv" > integrated_datasets_allscores_mF1"_NA-to-0_profiles.csv"
#sed -i 's/\.\.\/data\/allscores_mF1\/\///g' ../data/integrated_datasets_allscores_mF1_profiles.csv
#sed -i 's/\.tab//g' ../data/integrated_datasets_allscores_mF1_profiles.csv

#awk -F "," '{$1="";print $0}' ../data/integrated_datasets_allscores_mF1_profiles.csv | sed 's/  //' | sed 's/ //' | sed 's/NA/0/g' | sed 's/?/0/g' | sed 's/,yes$//g' | sed 's/,Outcome$//' | sed 's/ /,/g' > ../data/integrated_datasets_allscores_mF1_profiles_NA-?-to-0.csv

#Author: Swapna Seshadri

#This script 
# 1) Cleans raw coelution data by removing columns that do not contain any spectral counts at all - as this will interfere with column normalization 
# 2) Generates row-normalized matrices and column-matrices for the cleaned data
# 3) Generates a combined - all beads matrix, combined - all beads + iex matrix 

echo "Step1... Cleaning, generating row-normalized and column-normalized matrices"
for file in `ls ../data/coelution/raw_data/*tab`
do
	new_file=`echo $file | awk -F "/" '{print $NF}'| sed 's/.tab//g' `

	#Keeping only those proteins whose peptides are found in a minimum of 2 fractions
	echo -n "Locus " > tmp_file	
	Rscript coelution-clean_data.R $file tmp_file 2 0 
	sed 's/ /\t/g' tmp_file | sed 's/"//g' > ../data/coelution/cleaned_data/$new_file"_cleaned_mF2.tab"
	rm -f ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_rn.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_cn.tab"
	./coelution-normalized_matrices ../data/coelution/cleaned_data/$new_file"_cleaned_mF2.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_rn.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_cn.tab"
	sed -i 's/\t$//g' ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_rn.tab"
	sed -i 's/\t$//g' ../data/coelution/cleaned_data/$new_file"_cleaned_mF2_cn.tab" 

	#Keeping only those proteins whose peptides are found in a minimum of 1 fractions
	echo -n "Locus " > tmp_file
	Rscript coelution-clean_data.R $file tmp_file 1 0 
	sed 's/ /\t/g' tmp_file | sed 's/"//g' > ../data/coelution/cleaned_data/$new_file"_cleaned_mF1.tab"
	rm -f ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_rn.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_cn.tab"
	./coelution-normalized_matrices ../data/coelution/cleaned_data/$new_file"_cleaned_mF1.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_rn.tab" ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_cn.tab" 
	sed -i 's/\t$//g' ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_rn.tab"
	sed -i 's/\t$//g' ../data/coelution/cleaned_data/$new_file"_cleaned_mF1_cn.tab" 
done

echo "Step2... Generating matrix of all beads... takes time!"
#Generating matrix of all beads
sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2 > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF2.tab
sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2_rn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF2_rn.tab
sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2_cn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF2_cn.tab

sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1 > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF1.tab
sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1_rn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF1_rn.tab
sh coelution-construct_matrix_all_beads_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1_cn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_beads_cleaned_mF1_cn.tab

echo "Step3... Generating matrix of all beads... takes time!!"
#Generating matrix of all experiments
sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2 > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF2.tab
sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2_rn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF2_rn.tab
sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF2_cn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF2_cn.tab

sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1 > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF1.tab
sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1_rn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF1_rn.tab
sh coelution-construct_matrix_all_expts_fractions.sh ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/ mF1_cn > ~/workspace/toxonet/Jan_2018_onwards/data/coelution/cleaned_data/all_expts_cleaned_mF1_cn.tab

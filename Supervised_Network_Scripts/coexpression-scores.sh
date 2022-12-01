#This code constructs a matrix of gene expression profiles - and calculates gene coexpression as pearson and spearman correlation coefficients (along with CLR)

#Calculate gene coexpression using pearson and spearman scores
echo "Calculating pearson, spearman.. and derived scores"

rm -f tmp_coexpression_pearson.csv tmp_coexpression_spearman.csv 
Rscript coexpression-scores.R ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab tmp_coexpression_pearson.csv tmp_coexpression_spearman.csv 

echo -n "Codes Index " > coexpression_header.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{printf "%s ",$1}' | sed 's/ $//' >> coexpression_header.tab
echo "" >> coexpression_header.tab

echo "Codes Index " > coexpression_column.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{print $1}' >> coexpression_column.tab

cat coexpression_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab
paste coexpression_column.tab tmp_coexpression_pearson.csv | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab 
rm -f ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_pearson.tab
perl matrix_2_pairwise_conversion.pl ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_pearson.tab

cat coexpression_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab 
paste coexpression_column.tab tmp_coexpression_spearman.csv | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab 
rm -f ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_spearman.tab
perl matrix_2_pairwise_conversion.pl ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_spearman.tab


#Calculate clr_pcc values

rm -f ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab
perl pairwise_2_matrix_conversion.pl ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_pearson.tab 1.00 ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab
perl pairwise_2_matrix_conversion.pl ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_spearman.tab 1.00 ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab 

rm -f tmp_expr_clr-pearson.tab tmp_expr_clr-spearman.tab
Rscript score-clr.R ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson.tab tmp_expr_clr-pearson.tab
Rscript score-clr.R ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman.tab tmp_expr_clr-spearman.tab

#Add protein codes to the matrix and convert it into pairwise fashion

echo -n "Codes Index " > coexpression_header.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{printf "%s ",$1}' | sed 's/ $//' >> coexpression_header.tab
echo "" >> coexpression_header.tab

echo "Codes Index " > coexpression_column.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{print $1}' >> coexpression_column.tab

cat coexpression_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson_clr.tab
paste coexpression_column.tab tmp_expr_clr-pearson.tab | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson_clr.tab
rm -f ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_pearson_clr.tab
perl matrix_2_pairwise_conversion.pl ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_pearson_clr.tab ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_pearson_clr.tab

cat coexpression_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman_clr.tab
paste coexpression_column.tab tmp_expr_clr-spearman.tab | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman_clr.tab
rm -f ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_spearman_clr.tab
perl matrix_2_pairwise_conversion.pl ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_spearman_clr.tab ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_spearman_clr.tab

#Calculate MI and clr_MI values
echo "Calulating MI.. and derived values"

sh coexpression-mi.sh

rm -f ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi.tab
perl pairwise_2_matrix_conversion.pl ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_mi.tab 1.00 ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi.tab

rm -f tmp_expr_clr-mi.tab
Rscript score-clr.R ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi.tab tmp_expr_clr-mi.tab

echo -n "Codes Index " > coexpression_header.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{printf "%s ",$1}' | sed 's/ $//' >> coexpression_header.tab
echo "" >> coexpression_header.tab

echo "Codes Index " > coexpression_column.tab
grep "TGME49" ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coelution.tab | awk '{print $1}' >> coexpression_column.tab

cat coexpression_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi_clr.tab
paste coexpression_column.tab tmp_expr_clr-mi.tab | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi_clr.tab
rm -f ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_mi_clr.tab
perl matrix_2_pairwise_conversion.pl ../data/coexpression/matrix_scores/matrix_coexpression_non-ts_ovlp_coelution_mi_clr.tab ../data/coexpression/scores/coexpression_non-ts_ovlp_coelution_mi_clr.tab

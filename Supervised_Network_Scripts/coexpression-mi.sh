rm -f tmp_mi_expr tmp_mi_id_expr
Rscript score-mi_biodist.R ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coexpression.tab tmp_mi_expr
perl get_pairwise_combos_codes.pl ../data/coexpression/raw_data/construct_matrix_non-ts_ovlp_coexpression.tab > tmp_mi_id_expr

size_id_file=`wc -l tmp_mi_id_expr | awk '{print $1}'`
size_score_file=`wc -l tmp_mi_expr | awk '{print $1}'`

if [ $size_id_file -ne $size_score_file ]
then
        echo "ERROR: Something wrong with file sizes for $file1: $size_id_file vs. $size_score_file"
else
        paste tmp_mi_id_expr tmp_mi_expr > ../data/coexpression/scores/coexpression_non-ts_ovlp_coexpression_mi.tab
fi

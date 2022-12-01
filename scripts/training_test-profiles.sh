mkdir ../data/test_set/

#Row normalized sets
echo "Row normalized sets"
perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv ../data/training_set/profiles_training_row_normalized_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_row_normalized_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_row_normalized_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_POS.csv ../data/training_set/profiles_training_row_normalized_NEGGO_orig.csv
perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_NEG.csv tmp_file 
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_row_normalized_NEGGO_orig.csv

perl training_test-profiles.pl ../data/sets_row_normalized_mF1_profiles_NA-to-0.csv ../data/test_set/test_NEGGO_orig_ovlp.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_row_normalized_NEGGO_orig_ovlp_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv


#Raw count sets
echo "Raw count sets"
perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv ../data/training_set/profiles_training_raw_counts_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_raw_counts_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_raw_counts_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_POS.csv ../data/training_set/profiles_training_raw_counts_NEGGO_orig.csv
perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_NEG.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_raw_counts_NEGGO_orig.csv

perl training_test-profiles.pl ../data/sets_raw_counts_mF1_profiles_NA-to-0.csv ../data/test_set/test_NEGGO_orig_ovlp.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_raw_counts_NEGGO_orig_ovlp_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

#Column normalized sets
echo "Column normalized sets"
perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv ../data/training_set/profiles_training_column_normalized_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_column_normalized_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_column_normalized_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_POS.csv ../data/training_set/profiles_training_column_normalized_NEGGO_orig.csv
perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_NEG.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_column_normalized_NEGGO_orig.csv

perl training_test-profiles.pl ../data/sets_column_normalized_mF1_profiles_NA-to-0.csv ../data/test_set/test_NEGGO_orig_ovlp.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_column_normalized_NEGGO_orig_ovlp_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

#Extra

echo "Row normalized sets with TOMsim"
perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv ../data/training_set/profiles_training_row_normalized_tomsim_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_row_normalized_tomsim_NEGGO_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_row_normalized_tomsim_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_POS.csv ../data/training_set/profiles_training_row_normalized_tomsim_NEGGO_orig.csv
perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/training_set/training_NEGGO_orig_NEG.csv tmp_file
sed 's/,yes/,no/g' tmp_file >> ../data/training_set/profiles_training_row_normalized_tomsim_NEGGO_orig.csv

perl training_test-profiles.pl ../data/sets_row_normalized_tomsim_mF1_profiles_NA-to-0.csv ../data/test_set/test_NEGGO_orig_ovlp.csv tmp_file
sed 's/,yes/,?/g' tmp_file > ../data/test_set/profiles_test_row_normalized_tomsim_NEGGO_orig_ovlp_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv

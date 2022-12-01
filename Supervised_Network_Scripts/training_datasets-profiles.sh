head -1 ../../test_dataset/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_transpose.csv
for pair in `sed 's/\t/-/g' ../data/training_set/*POS*noRIBO.csv`
do
        grep "$pair" ../../test_dataset/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_transpose.csv | sed 's/,?$/,yes/g'
done

head -1 ../../test_dataset/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_transpose.csv
for pair in `sed 's/\t/-/g' ../data/training_set/*NEG*noRIBO.csv`
do
        grep "$pair" ../../test_dataset/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_transpose.csv | sed 's/,?$/,no/g'
done

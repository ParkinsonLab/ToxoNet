rm -f ../data/training_set/training_set_integrated_datasets.csv
for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot_noRIBO.csv`
do
	code1=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
	code2=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

	grep "$code1" ../data/integrated_datasets_allscores_mF2_profiles_NA-\?-to-0.csv  | grep "$code2" | sed 's/?$/yes/g' >> ../data/training_set/training_set_integrated_datasets.csv 
done

for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot_noRIBO.csv`
do
        code1=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
        code2=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

        grep "$code1" ../data/integrated_datasets_allscores_mF2_profiles_NA-\?-to-0.csv  | grep "$code2" | sed 's/?$/no/g' >> ../data/training_set/training_set_integrated_datasets.csv
done

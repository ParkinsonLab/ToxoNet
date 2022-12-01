rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO.csv`
do
	one=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
	two=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

	is_present=`grep "$one" ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv | grep "$two" | wc -l`

	if [ $is_present -ge 1 ]
	then
		echo "$one-$two" >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv		
	fi

done

rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot_noRIBO.csv`
do
        one=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
        two=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

        is_present=`grep "$one" ../data/combos_with_pcc_or_wcc_ge0.5_mF2_rn.csv | grep "$two" | wc -l`

        if [ $is_present -ge 1 ]
        then
                echo "$one-$two" >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
        fi
done

rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO.csv`
do
        one=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
        two=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

        is_present=`grep "$one" ../data/combos_with_pcc_or_wcc_ge0.5_mF1_rn.csv | grep "$two" | wc -l`

        if [ $is_present -ge 1 ] 
        then
                echo "$one-$two" >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
        fi

done

rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
for pair in `sed 's/\t/@/g' ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot_noRIBO.csv`
do
        one=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
        two=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

        is_present=`grep "$one" ../data/combos_with_pcc_or_wcc_ge0.5_mF2_rn.csv | grep "$two" | wc -l`

        if [ $is_present -ge 1 ]
        then
                echo "$one-$two" >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot_noRIBO_combos_pcc_or_wcc_ge0.5.csv
        fi
done

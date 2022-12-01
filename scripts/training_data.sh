#This script generates training data corresponding to cleaned data

#For mF2
rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF2.csv
rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot.csv
for pair in `cat ../data/training_set/training_NEGGO_POS_ovlpCE.csv`
do
	code1=`echo $pair | awk -F "," '{print $1}'`
	code2=`echo $pair | awk -F "," '{print $2}'`

	is_present1=`grep "$code1" ../data/training_set/heatmap_training_NEGGO_POS_ovlpCE_mF2.tab | wc -l`
	is_present2=`grep "$code2" ../data/training_set/heatmap_training_NEGGO_POS_ovlpCE_mF2.tab | wc -l`

	if [ $is_present1 -gt 0 ] && [ $is_present2 -gt 0 ]
	then
		echo $pair >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF2.csv 

		code1_annot=`grep "$code1" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`
		code2_annot=`grep "$code2" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`

		echo "$code1_annot#$code2_annot" | sed 's/#/\t/g' >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF2_annot.csv
	fi 
done

rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2.csv
rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot.csv
for pair in `cat ../data/training_set/training_NEGGO_NEG_ovlpCE.csv`
do
        code1=`echo $pair | awk -F "," '{print $1}'`
        code2=`echo $pair | awk -F "," '{print $2}'`

        is_present1=`grep "$code1" ../data/training_set/heatmap_training_NEGGO_NEG_ovlpCE_mF2.tab | wc -l`
        is_present2=`grep "$code2" ../data/training_set/heatmap_training_NEGGO_NEG_ovlpCE_mF2.tab | wc -l`

        if [ $is_present1 -gt 0 ] && [ $is_present2 -gt 0 ]
        then
                echo $pair >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2.csv

                code1_annot=`grep "$code1" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`
                code2_annot=`grep "$code2" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`

                echo "$code1_annot#$code2_annot" | sed 's/#/\t/g' >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF2_annot.csv

        fi
done

#For mF1
rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF1.csv
rm -f ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot.csv
for pair in `cat ../data/training_set/training_NEGGO_POS_ovlpCE.csv`
do
        code1=`echo $pair | awk -F "," '{print $1}'`
        code2=`echo $pair | awk -F "," '{print $2}'`

        is_present1=`grep "$code1" ../data/training_set/heatmap_training_NEGGO_POS_ovlpCE_mF1.tab | wc -l`
        is_present2=`grep "$code2" ../data/training_set/heatmap_training_NEGGO_POS_ovlpCE_mF1.tab | wc -l`

        if [ $is_present1 -gt 0 ] && [ $is_present2 -gt 0 ]
        then
                echo $pair >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF1.csv

                code1_annot=`grep "$code1" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`
                code2_annot=`grep "$code2" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`

                echo "$code1_annot#$code2_annot" | sed 's/#/\t/g' >> ../data/training_set/training_NEGGO_POS_ovlpCE_mF1_annot.csv

        fi
done

rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1.csv
rm -f ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot.csv
for pair in `cat ../data/training_set/training_NEGGO_NEG_ovlpCE.csv`
do
        code1=`echo $pair | awk -F "," '{print $1}'`
        code2=`echo $pair | awk -F "," '{print $2}'`

        is_present1=`grep "$code1" ../data/training_set/heatmap_training_NEGGO_NEG_ovlpCE_mF1.tab | wc -l`
        is_present2=`grep "$code2" ../data/training_set/heatmap_training_NEGGO_NEG_ovlpCE_mF1.tab | wc -l`

        if [ $is_present1 -gt 0 ] && [ $is_present2 -gt 0 ]
        then
                echo $pair >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1.csv

                code1_annot=`grep "$code1" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`
                code2_annot=`grep "$code2" ../data/coelution/cleaned_data/all_expts_cleaned_mF1.tab | awk '{print $1}'`

                echo "$code1_annot#$code2_annot" | sed 's/#/\t/g' >> ../data/training_set/training_NEGGO_NEG_ovlpCE_mF1_annot.csv

        fi
done


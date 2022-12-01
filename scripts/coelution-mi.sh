rm -f log.coelution-mi
for file1 in `ls ../data/coelution/cleaned_data/ | grep "all_expts_cleaned"`
do
	echo $file1
        rm -f tmp_mi tmp_mi_id ../data/coelution/scores/mi/mi_$file1

        Rscript score-mi_biodist.R ../data/coelution/cleaned_data/$file1 tmp_mi
        perl get_pairwise_combos_codes.pl ../data/coelution/cleaned_data/$file1 > tmp_mi_id

        size_id_file=`wc -l tmp_mi_id | awk '{print $1}'`
        size_score_file=`wc -l tmp_mi | awk '{print $1}'`

        if [ $size_id_file -ne $size_score_file ]
        then
                echo "ERROR: Something wrong with file sizes for $file1: $size_id_file vs. $size_score_file" >> log.coelution-mi
        else
                paste tmp_mi_id tmp_mi > ../data/coelution/scores/mi/mi_$file1
        fi
done

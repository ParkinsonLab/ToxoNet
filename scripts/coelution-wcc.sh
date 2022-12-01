for file in `ls ../data/coelution/cleaned_data/`
do
        rm -f tmp_wcc tmp_wcc_id ../data/coelution/scores/wcc/wcc_$file

        Rscript coelution-wcc.R ../data/coelution/cleaned_data/$file tmp_wcc
        perl get_pairwise_combos_codes.pl ../data/coelution/cleaned_data/$file > tmp_wcc_id

        size_id_file=`wc -l tmp_wcc_id | awk '{print $1}'`
        size_score_file=`wc -l tmp_wcc | awk '{print $1}'`

        if [ $size_id_file -ne $size_score_file ]
        then
                echo "ERROR: Something wrong with file sizes for $file: $size_id_file vs. $size_score_file"
        else
                paste tmp_wcc_id tmp_wcc > ../data/coelution/scores/wcc/wcc_$file
        fi
done

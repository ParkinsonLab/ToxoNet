for file in `ls ../data/coelution/cleaned_data/ | sed 's/.tab//'`
do
	rm -f ../data/coelution/scores/pccnm/$file.tab

        is_file_rn=`echo $file | grep "_rn" | wc -l`
        is_file_cn=`echo $file | grep "_cn" | wc -l`


	if [ $is_file_rn -eq 0 ] && [ $is_file_cn -eq 0 ]
	then 
		for list in `ls ../data/coelution/scores/pccnm_split/$file*tab | awk -F "/" '{print $NF}'`
		do
		        is_rn=`ls ../data/coelution/scores/pccnm_split/$list | grep "_rn_" | wc -l`
		        is_cn=`ls ../data/coelution/scores/pccnm_split/$list | grep "_cn_" | wc -l`

			if [ $is_rn -eq 0 ] && [ $is_cn -eq 0 ]
			then
				cat ../data/coelution/scores/pccnm_split/$list >> ../data/coelution/scores/pccnm/$file.tab	
			fi
		done
	else
                for list in `ls ../data/coelution/scores/pccnm_split/$file*tab | awk -F "/" '{print $NF}'`
                do
			cat ../data/coelution/scores/pccnm_split/$list >> ../data/coelution/scores/pccnm/$file.tab
		done
	fi	
done

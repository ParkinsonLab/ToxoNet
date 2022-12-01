#Filtering the file based on
# a) Remove pairs where the peptides cannot be uniquely identified to one protein in the pair - eg:
# b) Remove pairs that do not have a pcc or wcc >=0.5 in any of the experiments individually - that is not available in the file ../../weka/refsets_round2/test_set/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_pij_transpose.csv

#Input - interactions file to be filtered - eg: W_5sm_SNF_fp0.10-5spct-0.3coexpr.tab

for line in `sed 's/\t/,/g' $1`
do
	code1=`echo $line | awk -F "," '{print $1}'`
	code2=`echo $line | awk -F "," '{print $2}'`
	
	#Check 1
	#chk1=`grep "$code1" $2 | grep "$code2" | awk -F "," '$6==0 || $7==0 {print $0}' | wc -l`

	#Check 2
	chk2=`grep "$code1" ../weka/refsets_round2/test_set/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_pij_transpose.csv | grep "$code2" | wc -l`

	if [ $chk1 -eq 0 ] && [ $chk2 -gt 0 ]
	then
		echo $line | sed 's/,/\t/g'
	fi
done

echo "Pair##Profile#old_pcc#old_pcc_rowfreq#old_pccnm_rowfreq#new_pcc#new_pcc_rowfreq#new_pccnm#new_pccnm_rowfreq#wcc#coapex1#coapex2#mi"
for pair in `cat old_pcc.tab | awk '{print $1"#"$2}'`
do
	code1=`echo $pair | awk -F "#" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
	code2=`echo $pair | awk -F "#" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

	profile1=`grep "$code1" chk.tab`
	profile2=`grep "$code2" chk.tab`

	old_pcc=`grep "$code1" old_pcc.tab | grep "$code2" | awk '{print $NF}'`
	old_pcc_rowfreq=`grep "$code1" old_pcc_rowfreq.tab | grep "$code2" | awk '{print $NF}'`
	old_pccnm_rowfreq=`grep "$code1" old_pccnm_rowfreq.tab | grep "$code2" | awk -F "#" '{print $NF}'`
	new_pcc=`grep "$code1" new_pcc.tab | grep "$code2" | awk '{print $NF}'`
	new_pcc_rowfreq=`grep "$code1" new_pcc_rowfreq.tab | grep "$code2" | awk '{print $NF}'`
	new_pccnm=`grep "$code1" new_pccnm.tab | grep "$code2" | awk '{print $NF}'`
	new_pccnm_rowfreq=`grep "$code1" new_pccnm_rowfreq.tab | grep "$code2" | awk '{print $NF}'`

	wcc=`grep "$code1" /home/swapna/workspace/toxonet/March_2017_onwards/data/toxo/coelution/wcc/all_420fractions_wcc_WITHIDs.tab | grep "$code2" | awk -F "#" '{print $NF}'`

	coapex1=`grep "$code1" /home/swapna/workspace/toxonet/March_2017_onwards/data/toxo/coelution/coapex/overall_coapex_sc1.tab | grep "$code2" | awk '{print $NF}'` 
	coapex2=`grep "$code1" /home/swapna/workspace/toxonet/March_2017_onwards/data/toxo/coelution/coapex/overall_coapex_sc2.tab | grep "$code2" | awk '{print $NF}'`

	mi=`grep "$code1" mi_biodist_results.out | grep "$code2" | awk '{print $NF}'` 



	echo "$pair"#"$profile1"#"$old_pcc"#"$old_pcc_rowfreq"#"$old_pccnm_rowfreq"#"$new_pcc"#"$new_pcc_rowfreq"#"$new_pccnm"#"$new_pccnm_rowfreq"#"$wcc"#"$coapex1"#"$coapex2"#"$mi"
	echo "$pair"#"$profile2"#"$old_pcc"#"$old_pcc_rowfreq"#"$old_pccnm_rowfreq"#"$new_pcc"#"$new_pcc_rowfreq"#"$new_pccnm"#"$new_pccnm_rowfreq"#"$wcc"#"$coapex1"#"$coapex2"#"$mi"

done

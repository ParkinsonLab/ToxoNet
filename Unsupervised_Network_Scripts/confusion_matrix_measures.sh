#Input - $1 = the pairwise SNF file eg. W_6sm_SNF_CODES_pairwise.tab

dir=`echo $1 | awk -F "/" '{$NF=""; print $0}' | sed 's/ /\//g'`
echo $dir
tot_tp=`wc -l training/training_positives_noR_SNFsim.tab | awk '{print $1}'`
tot_tn=`wc -l training/training_negatives_noR_SNFsim.tab | awk '{print $1}'`

min_snfval=`awk '{print $NF}' $1 | grep -v "SNFsim" | sort -g | head -1`
max_snfval=`awk '{print $NF}' $1 | grep -v "SNFsim" | sort -gr | head -1`

echo "Cutoff,Tot_proteins,Tot_interactions,True_Positives,True_Negatives,False_Positives,False_Negatives,True_Positive_Rate,False_Positive_Rate,F1_score"
for cutoff in $(seq $min_snfval 0.00001 $max_snfval)
do
	tot_found_cutoff=`awk '$NF>='$cutoff' {print $0}' $1 | wc -l`
	awk '$NF>='$cutoff' {print $1}' $1 > $dir/tmp_codes
	awk '$NF>='$cutoff' {print $2}' $1 >> $dir/tmp_codes
	sort -u $dir/tmp_codes -o $dir/tmp_codes
	tot_proteins_cutoff=`wc -l $dir/tmp_codes | awk '{print $1}'`

	tp_found_cutoff=`awk '$NF>='$cutoff' {print $0}' training/training_positives_noR_SNFsim.tab | wc -l`	
	tn_found_cutoff=`awk '$NF<'$cutoff' {print $0}' training/training_negatives_noR_SNFsim.tab | wc -l`
	fp_found_cutoff=`awk '$NF>='$cutoff' {print $0}' training/training_negatives_noR_SNFsim.tab | wc -l`
	fn_found_cutoff=`awk '$NF<'$cutoff' {print $0}' training/training_positives_noR_SNFsim.tab | wc -l`

	tpr_cutoff=`echo "$tp_found_cutoff,$fn_found_cutoff" | awk -F "," '{print $1/($1+$2)}'`
	fpr_cutoff=`echo "$fp_found_cutoff,$tn_found_cutoff" | awk -F "," '{print $1/($1+$2)}'`

	f1_score_cutoff=`echo "$tp_found_cutoff,$fp_found_cutoff,$fn_found_cutoff" | awk -F "," '{print $1/($1+$1+$2+$3)}'`

	echo "$cutoff,$tot_proteins_cutoff,$tot_found_cutoff,$tp_found_cutoff,$tn_found_cutoff,$fp_found_cutoff,$fn_found_cutoff,$tpr_cutoff,$fpr_cutoff,$f1_score_cutoff"
done


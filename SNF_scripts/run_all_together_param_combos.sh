#Input file - $1 = the SNF matrix output from R eg. W_6sm_SNF.tab

#Add protein codes to the matrix and convert it into pairwise fashion

echo -n "Codes Index " > header.tab
awk '{printf "%s ",$1}' common-codes_coelution-phylopropij-transexpr.csv | sed 's/ $//' >> header.tab
echo "" >> header.tab

echo "Codes Index" > column.tab
cat common-codes_coelution-phylopropij-transexpr.csv >> column.tab

dir=`echo $1 | awk -F "/" '{$NF="";print $0}' | sed 's/ /\//'g`
echo $dir
f=`echo $1 | sed 's/.tab$//g'`
cat header.tab | sed 's/ /\t/g' > $f"_CODES.tab"
paste column.tab $1 | sed 's/ /\t/g' >> $f"_CODES.tab"

perl SNF_matrix_2_pairwise_conversion.pl $f"_CODES.tab" > $f"_CODES_pairwise.tab"

#Add spectral count and coexpr details to the SNFsimilarity details
perl pairs_retrieve_spec-ct_TABdelimINPUT.pl $f"_CODES_pairwise.tab" > $f"_CODES_pairwise_spec-ct.csv"


#Generate confusion measures for various cutoffs - TPR, FPR at various cutoffs. Interested in looking at FPR of 0.05.
if [ ! -f "$dir/confusion_matrix_measures.csv" ]
then
	sh confusion_matrix_measures.sh $f"_CODES_pairwise.tab" > $dir/confusion_matrix_measures.csv
fi

#Getting the idea of known complexes - proteasomes, IMC, parasite complexes
if [ ! -f "$dir/known_pairs_enrichment.csv" ]
then
	sh known_pairs_enrichment.sh $f"_CODES_pairwise.tab" >  $dir/known_pairs_enrichment.csv
fi

#Getting a list of filtered interactions - at a false positive rate of 0.10, and >=spct
#echo "Based on proteasome enrichment, TPR, FPR values, protein:interaction ratios and number of interactions and proteins - shortlist your best interaction set."
#echo "Generate the interaction network file for the particular cutoff set for downward processing"
#echo "awk -F "," '$3>=0.000965227348690962 && $4>=5 && $5>=5 && $6>=0.3 {print $0}' W_5sm_SNF_CODES_pairwise_spec-ct_coexpr.csv | sed 's/,/\t/g' > W_5sm_SNF_fp0.10-5spct-0.3coexpr.tab"

cutoff=`awk -F "," '$9<='0.05' {print $0}' $dir/confusion_matrix_measures.csv | head -1 | awk -F "," '{print $1}'`
awk -F "," '$3>='$cutoff' && $4>=5 && $5>=5 {print $0}' $f"_CODES_pairwise_spec-ct.csv" | sed 's/,/\t/g' > $f"_fp0.10_5spct.tab"

#Filtering the file based on
# a) Remove pairs where the peptides cannot be uniquely identified to one protein in the pair - eg:
# b) Remove pairs that do not have a pcc or wcc >=0.5 in any of the experiments individually - that is not available in the file ../../weka/refsets_round2/test_set/test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_pij_transpose.csv

#if [ ! -f "$dir/needle_pairs.csv" ]
#then
#	sh needle_pairs.sh $f"_fp0.10_5spct.tab" > $dir/needle_pairs.csv
#fi

if [ ! -f $f"_fp0.10_5spct_filtered.tab" ]
then
	#sh filtering_interactions.sh $f"_fp0.10_5spct.tab" $dir/needle_pairs.csv > $f"_fp0.10_5spct_filtered.tab"
	sh filtering_interactions.sh $f"_fp0.10_5spct.tab" > $f"_fp0.10_5spct_filtered.tab"
fi

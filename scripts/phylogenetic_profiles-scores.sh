#Calculate MI for pij scores
rm -f tmp_pij_mi tmp_pij_idpairs
Rscript score-mi_biodist.R ../data/phylogenetic_profiles/pij/matrix_pij_atleast_1_homolog_OVERLAP_COELUTION_CORRECT_TGME49.tab tmp_pij_mi
perl get_pairwise_combos_codes.pl ../data/phylogenetic_profiles/pij/matrix_pij_atleast_1_homolog_OVERLAP_COELUTION_CORRECT_TGME49.tab > tmp_pij_idpairs
paste tmp_pij_idpairs tmp_pij_mi > ../data/phylogenetic_profiles/scores/phylogenetic_profiles_pij_ovlp_coelution_mi.tab 

#Calculate MI for pres-abs scores
rm -f tmp_pa_mi tmp_pa_idpairs
Rscript score-mi_biodist.R ../data/phylogenetic_profiles/presence_absence/matrix_pres-abs.atleast_1_ortholog_OVERLAP_COELUTION_TGME49.tab tmp_pa_mi
perl get_pairwise_combos_codes.pl ../data/phylogenetic_profiles/presence_absence/matrix_pres-abs.atleast_1_ortholog_OVERLAP_COELUTION_TGME49.tab > tmp_pa_idpairs
paste tmp_pa_idpairs tmp_pa_mi > ../data/phylogenetic_profiles/scores/phylogenetic_profiles_presabs_ovlp_coelution_mi.tab

#Calculate CLR scores for MI scores - PIJ
rm -f ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi.tab
perl pairwise_2_matrix_conversion.pl ../data/phylogenetic_profiles/scores/phylogenetic_profiles_pij_ovlp_coelution_mi.tab 1.00 ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi.tab

rm -f tmp_pp_clr-mi.tab
Rscript score-clr.R ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi.tab tmp_pp_clr-mi.tab

echo -n "Codes Index " > pp_header.tab
grep "TGME49" ../data/phylogenetic_profiles/pij/matrix_pij_atleast_1_homolog_OVERLAP_COELUTION_CORRECT_TGME49.tab | awk '{printf "%s ",$1}' | sed 's/ $//' >> pp_header.tab
echo "" >> pp_header.tab

echo "Codes Index " > pp_column.tab
grep "TGME49" ../data/phylogenetic_profiles/pij/matrix_pij_atleast_1_homolog_OVERLAP_COELUTION_CORRECT_TGME49.tab | awk '{print $1}' >> pp_column.tab

cat pp_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi_clr.tab 
paste pp_column.tab tmp_pp_clr-mi.tab | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi_clr.tab
rm -f ../data/pp/scores/pp_non-ts_ovlp_coelution_mi_clr.tab
perl matrix_2_pairwise_conversion.pl ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_pij_ovlp_coelution_mi_clr.tab ../data/phylogenetic_profiles/scores/phylogenetic_profiles_pij_ovlp_coelution_mi_clr.tab 

#Calculate CLR scores for MI scores - PRESABS
rm -f ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi.tab
perl pairwise_2_matrix_conversion.pl ../data/phylogenetic_profiles/scores/phylogenetic_profiles_presabs_ovlp_coelution_mi.tab 1.00 ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi.tab

rm -f tmp_pp_clr-mi.tab
Rscript score-clr.R ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi.tab tmp_pp_clr-mi.tab

echo -n "Codes Index " > pp_header.tab
grep "TGME49" ../data/phylogenetic_profiles/presence_absence/matrix_pres-abs.atleast_1_ortholog_OVERLAP_COELUTION_TGME49.tab | awk '{printf "%s ",$1}' | sed 's/ $//' >> pp_header.tab
echo "" >> pp_header.tab

echo "Codes Index " > pp_column.tab
grep "TGME49" ../data/phylogenetic_profiles/presence_absence/matrix_pres-abs.atleast_1_ortholog_OVERLAP_COELUTION_TGME49.tab | awk '{print $1}' >> pp_column.tab

cat pp_header.tab | sed 's/ /\t/g' | sed 's/,/\t/g'  > ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi_clr.tab 
paste pp_column.tab tmp_pp_clr-mi.tab | sed 's/ /\t/g' | sed 's/,/\t/g' >> ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi_clr.tab
rm -f ../data/pp/scores/pp_non-ts_ovlp_coelution_mi_clr.tab
perl matrix_2_pairwise_conversion.pl ../data/phylogenetic_profiles/matrix_scores/matrix_phylogenetic_profiles_presabs_ovlp_coelution_mi_clr.tab ../data/phylogenetic_profiles/scores/phylogenetic_profiles_presabs_ovlp_coelution_mi_clr.tab

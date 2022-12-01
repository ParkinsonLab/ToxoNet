echo "Step 1: Generate Coapex scores"
for file2 in `ls ../data/coelution/cleaned_data/ | grep -v "all"`
do
        ./coelution-coapex_one_expt ../data/coelution/cleaned_data/$file2 > ../data/coelution/scores/coapex/coapex_$file2
done

echo "Step 1: Generating overall coapex scores.."
perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/coapex/ mF2.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF2.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF2.tab
perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/coapex/ mF2_rn.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF2_rn.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF2_rn.tab
perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF2.csv ../data/coelution/scores/coapex/ mF2_cn.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF2_cn.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF2_cn.tab

perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/coapex/ mF1.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF1.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF1.tab
perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/coapex/ mF1_rn.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF1_rn.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF1_rn.tab
perl coelution-overall_coapex_scores.pl ../data/coelution/all_combos_coelution_mF1.csv ../data/coelution/scores/coapex/ mF1_cn.tab ../data/coelution/scores/coapex/overall_coapex_sc1_mF1_cn.tab ../data/coelution/scores/coapex/overall_coapex_sc2_mF1_cn.tab


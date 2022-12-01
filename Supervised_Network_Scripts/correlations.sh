for file in `ls ../data/correlations/`
do
	echo $file

        sh integrate_datasets-profiles.sh  (~42 mins)


#Step B: Generate a table of all-vs-all correlations for the features

        Rscript all_vs_all_correlations.R ../data/integrated_datasets_allscores_mF2_profiles_NA-\?-to-0.csv ../data/all_vs_all_correlations_mF2_profiles.csv
        sed 's/,/\t/g' ../data/all_vs_all_correlations_mF2_profiles.csv > ../data/all_vs_all_correlations_mF2_profiles.tab
        cluster3 -g 2 -e 2 -m a -f ../data/all_vs_all_correlations_mF2_profiles.tab

done

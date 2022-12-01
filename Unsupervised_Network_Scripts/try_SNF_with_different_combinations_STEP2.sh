# This script runs SNF for W_5sm by varying the parameters
# K -  number of neighbors, usually (10~30)
# alpha - hyperparameter, usually (0.3~0.8)
# I -  Number of Iterations, usually (10~20)

for K in `echo "2 4 6 8 10 12 14 16 18 20 22 24 26 28 30" | head -1`
do
	for alpha in `echo "0.2 0.4 0.6 0.8 1" | head -1`
	do
		for I in `echo "2 4 6 8 10 12 14 16 18 20 22 24 26 28 30" | head -2`
		do
			echo "W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/"
			sh run_all_together_param_combos.sh W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/W_5sm_params_K$K"_alpha"$alpha"_I"$I".tab"
		done
	done
done

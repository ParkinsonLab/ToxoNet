# This script runs SNF for W_5sm by varying the parameters
# K -  number of neighbors, usually (10~30)
# alpha - hyperparameter, usually (0.3~0.8)
# I -  Number of Iterations, usually (10~20)

mkdir W_5sm_params/
for K in `echo "2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"`
do
	for alpha in `echo "0.2 0.4 0.6 0.8 1"`
	do
		for I in `echo "2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"`
		do
			mkdir W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/
			echo "W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/"

			if [ ! -f W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/W_5sm_params_K$K"_alpha"$alpha"_I"$I".tab" ]
			then
				Rscript SNF_params.R $K $alpha $I W_5sm_params/W_5sm_params_K$K"_alpha"$alpha"_I"$I/W_5sm_params_K$K"_alpha"$alpha"_I"$I".tab"
			fi
		done
	done
done

#Author: Swapna Seshadri
#This script convert a file with pairwise list of scores into matrix form - feed it into TOMsimilarity calculation - and convert the output file back into pairwise form

#Example usage: sh coelution-clr_mi.sh ../data/coelution/scores/mi/ 1.00 ../data/coelution/scores/clr_mi_matrix/ ../data/coelution/scores/clr_mi/

#$1=directory containing clr_mi values for pairwise combinations - each experiment
#$2=default value to be entered for the same vs. same code 
#$3=directory where the matrices output files must be written to.
#$4=directory where the output pairwise file must be written to.

#$1=../data/coelution/scores/clr_mi/
#$2=1.00
#$3=../data/coelution/scores/clr_mi_matrix/
#$4=../data/coelution/scores/adjacency/
#$5=../data/coelution/scores/clr_mi/

for file in `ls $1/*.tab`
do
        expt=`echo $file | awk -F "/" '{print $NF}' | sed 's/.tab$//'`

        echo $file,$expt

        #Convert into matrix form
	rm -f $3/matrix_$expt".tab"
        perl pairwise_2_matrix_conversion.pl $file $2 $3/matrix_$expt".tab"


	#Calculate clr_mi values
	rm -f $3/tmp_clr-mi.tab
	Rscript score-clr.R $3/matrix_$expt".tab" $3/tmp_clr-mi.tab 

	#Add protein codes to the matrix and convert it into pairwise fashion

	awk '{print $1}' $3/matrix_$expt".tab" | grep -v "Codes" > $3/tmp_codes 
	echo -n "Codes Index " > $3/header.tab
	awk '{printf "%s ",$1}' $3/tmp_codes | sed 's/ $//' >> $3/header.tab
	echo "" >> $3/header.tab

	echo "Codes Index" > $3/column.tab
	cat $3/tmp_codes >> $3/column.tab

	cat $3/header.tab | sed 's/ /\t/g' > $3/matrix_$expt"_clr_mi.tab"
	paste $3/column.tab $3/tmp_clr-mi.tab | sed 's/ /\t/g' >> $3/matrix_$expt"_clr_mi.tab"

	rm -f $4/$expt"_clr_mi.tab"
	perl matrix_2_pairwise_conversion.pl $3/matrix_$expt"_clr_mi.tab"  $4/$expt"_clr_mi.tab"
done

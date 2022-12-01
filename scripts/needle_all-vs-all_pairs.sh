	ct1=0
for i in `grep ">" proteins_all_peptides_Tgme49.fasta_sl`
do
	grep -A1 "$i" proteins_all_peptides_Tgme49.fasta_sl > one.fa
	code1=`echo $i | sed 's/>//g'`

		ct2=0
	for j in `grep ">" proteins_all_peptides_Tgme49.fasta_sl`
	do
		if [ $ct2 -gt $ct1 ]
		then
			grep -A1 "$j" proteins_all_peptides_Tgme49.fasta_sl > two.fa
			code2=`echo $j | sed 's/>//g'`

			needle one.fa two.fa -gapopen 10 -gapextend 5 -outfile tmp.needle

			pid=`grep "# Identity:" tmp.needle | awk '{print $NF}' | sed 's/(//' | sed 's/)//'`
			echo "$code1,$code2,$pid"
		fi

		ct2=`expr $ct2 + 1`
	done
	ct1=`expr $ct1 + 1`
done

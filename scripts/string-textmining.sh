#This script extracts all pairs with a score > 0 in the STRING database - based on experimental evidence 
#$1 - String database file for the organism eg. 5811.protein.links.full.v10.5.txt
#$2 - id mapping file for the organism

#sh string-textmining.sh ../data/string/raw_data/5811.protein.links.full.v10.5.txt ../data/id_mapping/ToxoDBv35_1Dec2017.txt > ../data/string/scores/string_v10.5_textmining.tab

#for i in `awk '$10>0 {print $0}' 5811.protein.links.full.v10.txt | grep -v "protein1" | sed 's/ /#/g'`
awk '$14>0 {print $1","$2}' $1 | grep -v "protein1" > tmp_string
perl check_duplicates_2cols.pl tmp_string | sort -u > tmp_string_sorted
for i in `cat tmp_string_sorted`
do
	c1=`echo $i | awk -F "," '{print $1}' | awk -F "." '{print $2}'`
	c2=`echo $i | awk -F "," '{print $2}' | awk -F "." '{print $2}'`
	score=`grep "$c1" $1 | grep "$c2" | awk '{print $14}' | sort -u`

	ct1=`grep -Fw "$c1" $2 | awk -F "\t" '{print $1}' | wc -l`
	ct2=`grep -Fw "$c2" $2  | awk -F "\t" '{print $1}' | wc -l`

	if [ $ct1 -gt 0 ] && [ $ct2 -gt 0 ]
	then
		for code1 in `grep -Fw "$c1" $2 | awk -F "\t" '{print $1}' | sed 's/ /~/g'`
		do
			for code2 in `grep -Fw "$c2" $2 | awk -F "\t" '{print $1}' | sed 's/ /~/g'`
			do
				echo "$code1\t$code2\t$score"	
			done
		done
	fi
done

	echo -n "Gene_ID,"
                for k in `awk -F "," '{print $1}' non_time_series_datasets_orig.lst`
                do
                        echo -n "$k"
                        fields=`awk -F "\t" '{print NF}' $k | sort -u`
                        fields=`expr $fields - 1` #To account for the ID field
                                 x=1
                        while [ $x -lt $fields ]
                        do
                             echo -n "#" | sed 's/#/\t/g'
                             x=`expr $x + 1`
                        done
                             echo -n ","
                done
	echo ""

	echo -n ","
                for k in `awk -F "," '{print $1}' non_time_series_datasets_orig.lst`
                do
                        line=`head -1 $k | sed 's/ /_/g' | awk -F "\t" '{$1="";print $0}' | sed 's/ //' | sed 's/ /\t/g'`
                        echo -n "$line,"
                done
        echo ""


for i in `grep -v "\[Gene ID\]" ../all_ids_toxodb.txt | awk '{print $1}'`
do
	echo -n "$i,"
		for k in `awk -F "," '{print $1}' non_time_series_datasets_orig.lst`
		do
			#echo -n "$k #"
			ct=`grep -Fw "$i" $k | wc -l`

			if [ $ct -gt 0 ]
			then
				line=`grep -Fw "$i" $k | awk -F "\t" '{$1="";print $0}' | sed 's/ //' | sed 's/ /\t/g'`
				echo -n "$line,"
			else
				fields=`awk -F "\t" '{print NF}' $k | sort -u`
				fields=`expr $fields - 1` #To account for the ID field
					x=1		
				while [ $x -lt $fields ]
				do
					echo -n "0#" | sed 's/#/\t/g'	
					x=`expr $x + 1`
				done	
					echo -n "0,"
			fi
		done
	echo ""
done

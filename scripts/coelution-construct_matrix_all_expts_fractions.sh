#Columns - filtrations - first A, next C, next L, next R, next N, last prev
#Rows - proteins

#Headers
	beadA=`head -1 $1/toxo_beadsA*$2.tab | awk -F "\t" '{print $0}' | sed 's/ /\t/g'`
	echo -n "$beadA"	
	beadC=`head -1 $1/toxo_beadsC*$2.tab | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
	echo -n "$beadC"	
	beadL=`head -1 $1/toxo_beadsL*$2.tab | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
	echo -n "$beadL"	
	beadR=`head -1 $1/toxo_beadsR*$2.tab | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
	echo -n "$beadR"	
	beadN=`head -1 $1/toxo_beadsN*$2.tab | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
	echo -n "$beadN"	
	iex=`head -1 $1/toxo_IEX*$2.tab | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
	echo "$iex"	

#Combined elution profiles
for i in `grep -h "^TGME49_" $1/toxo_*$2.tab | awk -F "_" '{print $1"_"$2}' | sort -u`
do
	description=`grep  -h "$i" $1/toxo_*$2.tab | awk -F "\t" '{print $1}' | head -1`

	echo -n "$description" 

	ct=`grep "$i" $1/toxo_beadsA*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

	if [ $ct -gt 0 ]
	then
		#beadA=`grep  "$i" toxo_beadsA.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' | sed 's/  / /g' | sed 's/ /\t/g'`
		beadA=`grep  "$i" $1/toxo_beadsA*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
		echo -n "$beadA" 
	else
		num_columns=`awk -F "\t" '{print NF}' $1/toxo_beadsA*$2.tab | sort -u`
		num_columns=`expr $num_columns - 1`
		for j in `seq 1 $num_columns` 
		do	
			echo -n "@0" | sed 's/@/\t/g'
		done	
	fi

	ct=`grep  "$i" $1/toxo_beadsC*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

	if [ $ct -gt 0 ]
	then
		beadC=`grep   "$i" $1/toxo_beadsC*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' | sed 's/  / /' | sed 's/ /\t/g'`
		echo -n "$beadC" 
	else
                num_columns=`awk -F "\t" '{print NF}' $1/toxo_beadsC*$2.tab | sort -u`
		num_columns=`expr $num_columns - 1`
		for j in `seq 1 $num_columns` 
               	do 
                        echo -n "@0" | sed 's/@/\t/g'
                done 
	fi

	ct=`grep   "$i" $1/toxo_beadsL*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

	if [ $ct -gt 0 ]
	then
		beadL=`grep   "$i" $1/toxo_beadsL*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
		echo -n "$beadL" 
	else
                num_columns=`awk -F "\t" '{print NF}' $1/toxo_beadsL*$2.tab | sort -u`
		num_columns=`expr $num_columns - 1`
		for j in `seq 1 $num_columns` 
               	do 
                        echo -n "@0" | sed 's/@/\t/g'
                done 
	fi

        ct=`grep   "$i" $1/toxo_beadsR*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

        if [ $ct -gt 0 ]
        then
                beadR=`grep   "$i" $1/toxo_beadsR*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
		echo -n "$beadR" 
        else
                num_columns=`awk -F "\t" '{print NF}' $1/toxo_beadsR*$2.tab | sort -u`
		num_columns=`expr $num_columns - 1`
		for j in `seq 1 $num_columns` 
               	do 
                        echo -n "@0" | sed 's/@/\t/g'
                done
        fi

	ct=`grep   "$i" $1/toxo_beadsN*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

        if [ $ct -gt 0 ]
        then
                beadN=`grep   "$i" $1/toxo_beadsN*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' |  sed 's/  / /' | sed 's/ /\t/g'`
		echo -n "$beadN"
        else
                num_columns=`awk -F "\t" '{print NF}' $1/toxo_beadsN*$2.tab | sort -u`
		num_columns=`expr $num_columns - 1`
		for j in `seq 1 $num_columns` 
               	do 
                        echo -n "@0" | sed 's/@/\t/g'
                done
        fi

	ct=`grep   "$i" $1/toxo_IEX*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | wc -l`

        if [ $ct -gt 0 ]
        then
                iex=`grep   "$i" $1/toxo_IEX*$2.tab | awk -F "\t" '$1 ~ /'$i'/ {print $0}' | awk -F "\t" '{$1="";print $0}' |  sed 's/ /\t/g'`
                echo -n "$iex"
        else
                num_columns=`awk -F "\t" '{print NF}' $1/toxo_IEX*$2.tab | sort -u`
                num_columns=`expr $num_columns - 1`
                for j in `seq 1 $num_columns`
                do
                        echo -n "@0" | sed 's/@/\t/g'
                done
        fi

        echo ""

done

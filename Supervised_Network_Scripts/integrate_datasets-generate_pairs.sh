for pair in `awk '{print $1"@"$2}' $1`
do
	code1=`echo $pair | awk -F "@" '{print $1}' | awk -F "_" '{print $1"_"$2}'`
	code2=`echo $pair | awk -F "@" '{print $2}' | awk -F "_" '{print $1"_"$2}'`

	echo "$code1,$code2"
done

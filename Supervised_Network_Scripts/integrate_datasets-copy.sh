name=`echo $1 | awk -F "." '{print $1}'`
mkdir ../data/$name/
for file in `cat $1`
do
	cp $file ../data/$name/ 
done

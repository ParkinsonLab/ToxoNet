for i in `ls $1/*arff`
do
        sed -i 's/\r//g' $i
        sed -i 's/,yes$/,1/g' $i
        sed -i 's/,no$/,0/g' $i
        sed -i 's/{yes,no}/{1,0}/g' $i
done

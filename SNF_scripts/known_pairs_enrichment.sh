#Input - $1 = network interaction file containing codes
#Eg - pairs_RF_ChiSquared-sp2-xp01.csv

#Input - Interaction file - $1

sort -k3gr $1 > intx_sorted

# Proteasome proteins
		iters=0
		proteasome_pairs=0
		ct1=0
	for i in `awk -F "," '{print $2}' training/known_proteasome_subunits.csv`
	do
			ct2=0
		for j in `awk -F "," '{print $2}' training/known_proteasome_subunits.csv`
		do
			if [ $ct2 -gt $ct1 ]
			then

				chk=`grep -Fw "$i" intx_sorted | grep -Fw "$j" | wc -l`

				if [ $chk -gt 0 ]
				then
					grep -n "." intx_sorted | grep -Fw "$i" | grep -Fw "$j" 
					#srch=`grep -Fw "$i" tmp_pairs | grep -Fw "$j" | sed 's/\t/,/g'`
					#grep "$srch" W_6sm_SNF_CODES_pairwise_spec-ct_coexpr.csv 
					proteasome_pairs=`expr $proteasome_pairs + 1`
				fi

				iters=`expr $iters + 1`
			fi
			ct2=`expr $ct2 + 1`
		done
		ct1=`expr $ct1 + 1`
	done
	echo ">known_proteasome_proteins,$proteasome_pairs,$iters"


### IMC proteins
               iters=0
                proteasome_pairs=0
                ct1=0
        for i in `awk -F "," '{print $2}' training/known_IMC_proteins.csv`
        do
                        ct2=0
                for j in `awk -F "," '{print $2}' training/known_IMC_proteins.csv`
                do
                        if [ $ct2 -gt $ct1 ]
                        then

                                chk=`grep -Fw "$i" intx_sorted | grep -Fw "$j" | wc -l`

                                if [ $chk -gt 0 ]
                                then
                                        grep -n "." intx_sorted | grep -Fw "$i" | grep -Fw "$j"
                                        #srch=`grep -Fw "$i" tmp_pairs | grep -Fw "$j" | sed 's/\t/,/g'`
                                        #grep "$srch" W_6sm_SNF_CODES_pairwise_spec-ct_coexpr.csv 
                                        proteasome_pairs=`expr $proteasome_pairs + 1`
                                fi

                                iters=`expr $iters + 1`
                        fi
                        ct2=`expr $ct2 + 1`
                done
                ct1=`expr $ct1 + 1`
        done
        echo ">known_IMC_proteins,$proteasome_pairs,$iters"

#Known parasite interactions

               iters=0
               proteasome_pairs=0
	for i in `cat training/known_parasite_complexes.csv`
	do
		code1=`echo $i | awk -F "," '{print $1}' | awk -F "-" '{print $1}'`
		code2=`echo $i | awk -F "," '{print $1}' | awk -F "-" '{print $2}'`

		chk=`grep -Fw "$code1" intx_sorted | grep -Fw "$code2" | wc -l`

                if [ $chk -gt 0 ]
                then
			echo $i
	                grep -n "." intx_sorted | grep -Fw "$code1" | grep -Fw "$code2"
                        proteasome_pairs=`expr $proteasome_pairs + 1`
                fi
               
                iters=`expr $iters + 1`

	done

	echo ">known_parasite_complexes,$proteasome_pairs,$iters"

#Step 1: For raw matrix files

rm -f run_job_hcf*sh

	ct=1
	num=11

        echo "#!/bin/bash" >> run_job_hcf_pccnm_subset_$num.sh
        echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_subset_$num.sh
	echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_subset_$num.sh
	echo "module load gsl/1.16" >> run_job_hcf_pccnm_subset_$num.sh
	echo "module load gcc" >> run_job_hcf_pccnm_subset_$num.sh
        echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_subset_$num.sh

#for i in `ls ../../pfam/fasta/ | grep ".fa$" | sed 's/.fa//g'`
start_pos=0
end_pos=0
seq_ct=0

for file in `ls ../data/coelution/cleaned_data/*tab | grep -v "rn" | grep -v "cn"`
do
	file_size=`wc -l $file | awk '{print $1}'`
	file_size=`expr $file_size - 1`
	name=`echo $file | awk -F "/" '{print $NF}' | sed 's/.tab//'`

	chk_seq_ct=`expr $file_size / 100`
	chk_seq_ct=`expr $chk_seq_ct + 1`

	start_pos=0

	for (( i=1; i <= $chk_seq_ct; ++i ))
	do

	        chk=`expr $ct % 8`
        	if [ $chk -eq 0 ]
        	then
               		echo "wait" >> run_job_hcf_pccnm_subset_$num.sh
	                num=`expr $num + 1`
       	         	echo "#!/bin/bash" >> run_job_hcf_pccnm_subset_$num.sh
                	echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_subset_$num.sh
                	echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_subset_$num.sh
                	echo "module load gsl/1.16" >> run_job_hcf_pccnm_subset_$num.sh
                	echo "module load gcc" >> run_job_hcf_pccnm_subset_$num.sh
                	echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_subset_$num.sh
        	fi

		end_pos=`expr $start_pos + 100`
		if [ $end_pos -gt $file_size ]
		then
			end_pos=$file_size
		fi

		sed 's/file/'$name'/g' template_pccnm_subset_hcf | sed 's/start/'$start_pos'/g' | sed 's/end/'$end_pos'/g' >> run_job_hcf_pccnm_subset_$num.sh
		start_pos=$end_pos

		ct=`expr $ct + 1`
	done
done
	echo "wait" >> run_job_hcf_pccnm_subset_$num.sh


#Step 2: For column normalized matrix files

        ct=1
        num=11

        echo "#!/bin/bash" >> run_job_hcf_pccnm_cn_subset_$num.sh
        echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_cn_subset_$num.sh
        echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_cn_subset_$num.sh
        echo "module load gsl/1.16" >> run_job_hcf_pccnm_cn_subset_$num.sh
        echo "module load gcc" >> run_job_hcf_pccnm_cn_subset_$num.sh
        echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_cn_subset_$num.sh

#for i in `ls ../../pfam/fasta/ | grep ".fa$" | sed 's/.fa//g'`
start_pos=0
end_pos=0
seq_ct=0

for file in `ls ../data/coelution/cleaned_data/*tab | grep "cn"`
do
        file_size=`wc -l $file | awk '{print $1}'`
        file_size=`expr $file_size - 1`
        name=`echo $file | awk -F "/" '{print $NF}' | sed 's/.tab//'`

        chk_seq_ct=`expr $file_size / 100`
        chk_seq_ct=`expr $chk_seq_ct + 1`

        start_pos=0

        for (( i=1; i <= $chk_seq_ct; ++i ))
        do

                chk=`expr $ct % 8`
                if [ $chk -eq 0 ]
                then
                        echo "wait" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        num=`expr $num + 1`
                        echo "#!/bin/bash" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        echo "module load gsl/1.16" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        echo "module load gcc" >> run_job_hcf_pccnm_cn_subset_$num.sh
                        echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_cn_subset_$num.sh
                fi

                end_pos=`expr $start_pos + 100`
                if [ $end_pos -gt $file_size ]
                then
                        end_pos=$file_size
                fi

                sed 's/file/'$name'/g' template_pccnm_cn_subset_hcf | sed 's/start/'$start_pos'/g' | sed 's/end/'$end_pos'/g' >> run_job_hcf_pccnm_cn_subset_$num.sh
                start_pos=$end_pos

                ct=`expr $ct + 1`
        done
done
        echo "wait" >> run_job_hcf_pccnm_cn_subset_$num.sh

#Step 3: For row normalized matrix files

        ct=1
        num=11

        echo "#!/bin/bash" >> run_job_hcf_pccnm_rn_subset_$num.sh
        echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_rn_subset_$num.sh
        echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_rn_subset_$num.sh
        echo "module load gsl/1.16" >> run_job_hcf_pccnm_rn_subset_$num.sh
        echo "module load gcc" >> run_job_hcf_pccnm_rn_subset_$num.sh
        echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_rn_subset_$num.sh

#for i in `ls ../../pfam/fasta/ | grep ".fa$" | sed 's/.fa//g'`
start_pos=0
end_pos=0
seq_ct=0

for file in `ls ../data/coelution/cleaned_data/*tab | grep "rn"`
do
        file_size=`wc -l $file | awk '{print $1}'`
        file_size=`expr $file_size - 1`
        name=`echo $file | awk -F "/" '{print $NF}' | sed 's/.tab//'`

        chk_seq_ct=`expr $file_size / 100`
        chk_seq_ct=`expr $chk_seq_ct + 1`

        start_pos=0

        for (( i=1; i <= $chk_seq_ct; ++i ))
        do

                chk=`expr $ct % 8`
                if [ $chk -eq 0 ]
                then
                        echo "wait" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        num=`expr $num + 1`
                        echo "#!/bin/bash" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        echo "#PBS -l nodes=1:ppn=8,walltime=48:00:00" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        echo "#PBS -N serialx8-test" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        echo "module load gsl/1.16" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        echo "module load gcc" >> run_job_hcf_pccnm_rn_subset_$num.sh
                        echo "cd "\$"PBS_O_WORKDIR" >> run_job_hcf_pccnm_rn_subset_$num.sh
                fi

                end_pos=`expr $start_pos + 100`
                if [ $end_pos -gt $file_size ]
                then
                        end_pos=$file_size
                fi

                sed 's/file/'$name'/g' template_pccnm_rn_subset_hcf | sed 's/start/'$start_pos'/g' | sed 's/end/'$end_pos'/g' >> run_job_hcf_pccnm_rn_subset_$num.sh
                start_pos=$end_pos

                ct=`expr $ct + 1`
        done
done
        echo "wait" >> run_job_hcf_pccnm_rn_subset_$num.sh

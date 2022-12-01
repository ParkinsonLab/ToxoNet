#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program outputs the values for the subset present in a dataset
#Eg. of all the negative combinations, choose only those combinations which are found in coelution data
#Eg: perl ../../../../scripts/find_pairs_in_a_dataset.pl negative_combinations_only1ortholog_ME49codes.tab ../../../coelution/2/all_combos_coelution_ME49codes.csv > chk.me
#Eg: perl /home/swapna/workspace/toxonet/scripts/find_pairs_in_a_dataset.pl Complexes_only-TGO-Cyc2008-CORUMCore_NOribo.csv ../../../coelution/2/all_combos_coelution_ME49codes.csv > Complexes_only-TGO-Cyc2008-CORUMCore_NOribo_ovlpCE.csv

#negative_combinations_list file
open(STD,$ARGV[0]);

#all coelution data file
open(ID,$ARGV[1]);
my @id=<ID>;
my %ids;
foreach $id(@id)
{
	chomp($id);
        $ids{$id}=1;
}

	$ct=1;
while ($std=<STD>)
{
        chomp($std);

	#if ($ct == 0 )
	#{
		#Print first line as is - the header
	#	print "$std\n";
	#}
	#else
	#{
		#@fields=split('\t',$std);
        	#($c1,$c2)=split('-',$fields[0]);
        	($c1,$c2)=split(',',$std);

		$pair=join ",",$c1,$c2;
		if (exists($ids{$pair}))
		{
        		print "$std\n";
		}
		else
		{
			$pair=join ",",$c2,$c1;
			if(exists($ids{$pair}))
			{
				print "$std\n"; 
			}
		}
	#}

	$ct++;
}


#!/usr/bin/perl -w
use List::MoreUtils qw/uniq/;

#This is the dataset containing similarity information for all pairs.. we want to convert this into a matrix form

#open(DATASET,"../weka/refsets_round2/input/toxo_beadsA_pcc_noisemodel.tab");
#open(DATASET,"../weka/refsets_round2/input/toxo_beadsC_pcc_noisemodel.tab");
#open(DATASET,"../weka/refsets_round2/input/toxo_beadsL_pcc_noisemodel.tab");
#open(DATASET,"../weka/refsets_round2/input/toxo_beadsN_pcc_noisemodel.tab");
#open(DATASET,"../weka/refsets_round2/input/toxo_beadsR_pcc_noisemodel.tab");
#open(DATASET,"../weka/refsets_round2/input/toxo_IEX120_pcc_noisemodel.tab");
open(DATASET,$ARGV[0]);

#Building the hash for current dataset
#Also store all the protein codes

my %dataset;
%dataset=();
@codes=();
while(<DATASET>)
{
	chomp($_);
        ($c1,$c2,$score)=split('\t',$_);

        @c1=split('_',$c1);
        @c2=split('_',$c2);

        $code1=join "_",$c1[0],$c1[1];
        $code2=join "_",$c2[0],$c2[1];

        $pair=join ",",$code1,$code2;
	$dataset{$pair}=$score;

	push(@codes,$code1);
	push(@codes,$code2);
}

@codes=uniq sort @codes;

$default_value=$ARGV[1];

open(OUT_FILE,">$ARGV[2]");

print OUT_FILE "Codes\t";
foreach $_(@codes)
{
	chomp($_);
	print OUT_FILE "$_\t";	
}
print OUT_FILE "\n";

for($i=0;$i<=$#codes;$i++)
{
	chomp($codes[$i]);
	print OUT_FILE "$codes[$i]\t";
	for($j=0;$j<=$#codes;$j++)
	{
		chomp($codes[$j]);

		if($codes[$i] eq $codes[$j])
		{
			print OUT_FILE "$default_value\t";
			#print "1.00\t";
			#print "10\t"; #for overall_coapex_sc1 only -> the max between proteins is 6.. so setting it to 10 arbitrarily
			#print "0\t"; #for phylopro-MI - mutual information cases, and for (absolute difference in spectral counts)
		}
		else
		{
			$pair=join ",",$codes[$i],$codes[$j];

			if(exists($dataset{$pair}))
			{
				print OUT_FILE "$dataset{$pair}\t";
			}
			else
			{
				#Check if it is stored in the reverse order in the hash
				$pair=join ",",$codes[$j],$codes[$i];

				if(exists($dataset{$pair}))
				{
					print OUT_FILE "$dataset{$pair}\t";
				}
				else
				{
					#Data not available in this hash for this pair
					print OUT_FILE "NA\t";
				}
			}
	
		}
	}
	print OUT_FILE "\n";
}	

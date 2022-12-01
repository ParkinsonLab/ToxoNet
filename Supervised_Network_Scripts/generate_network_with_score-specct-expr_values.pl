#!/usr/bin/perl -w

#Author: Swapna Seshadri
#Usage: perl ~/workspace/toxonet/scripts/pairs_with_pcc_or_wcc_ge0.5.pl all_combos_coelution_ME49codes.csv pcc wcc combos_with_pcc_or_wcc_ge0.5.csv 0.8

#Main Network file from which combinations are to be generated
open(STD,$ARGV[0]);

#Spectral_ct file
open(SPECCT,"/scratch/j/jparkins/swapna/bkp_toxonet/toxo/weka/refsets_round2/shortlists_NOr-WITHqR-WITHhR-WITHrp/spectral_counts_pairs_test_profiles_latest_combos_with_pcc_or_wcc_ge0.5_pij.csv");

my %spec_ct={};

while ($line=<SPECCT>)
{
	chomp($line);
        ($codes,$spec_ct1,$spec_ct2,$dummy)=split(',',$line);
	($code1,$code2)=split('-',$codes);

        $pair=join ",",$code1,$code2;
	$spec_ct_pair=join ",",$spec_ct1,$spec_ct2;

	$spec_ct{$pair}=$spec_ct_pair;
}

#Transcript expression file
open(EXPR,"/scratch/j/jparkins/swapna/bkp_toxonet/toxo/weka/refsets_round2/input/transcript_expression_non-ts.tab");

my %expr_pcc={};

while($line=<EXPR>)
{
        chomp($line);
        ($code1,$code2,$te_expr)=split('\t',$line);

        $pair=join ",",$code1,$code2;

        $expr_pcc{$pair}=$te_expr;
}


while ($std=<STD>)
{
	#print "$std";
        chomp($std);

        ($c1,$c2,$c3,$score)=split("\t",$std);

	if($c1 eq "Source")
	{
		print "$std\tPCC_Expression\tSpectral_Ct1\tSpectral_Ct2\n";
		next;
	}

	@c1=split('_',$c1);
	@c3=split('_',$c3);
	$code1=join "_",$c1[0],$c1[1];
	$code2=join "_",$c3[0],$c3[1];

	#print "$code1,$code2,$c1[0],$c1[1],$c3[0],$c3[1]\n";
	#To get gene coexpression value
        $pair=join ",",$code1,$code2;
	if(exists($expr_pcc{$pair}))
	{
		$pcc_val=$expr_pcc{$pair};
	}
	else
	{
		$pair=join ",",$code2,$code1;

		if(exists($expr_pcc{$pair}))
		{
			$pcc_val=$expr_pcc{$pair};
		}
		else
		{
			$pcc_val="NA";
		}
	}

	#To get spectral count values
	$pair=join ",",$code1,$code2;
	if(exists($spec_ct{$pair}))
	{
		($spec_ct1,$spec_ct2)=split(',',$spec_ct{$pair});
	}
	else
	{
		$pair=join ",",$code2,$code1;
		if(exists($spec_ct{$pair}))
		{
			($spec_ct2,$spec_ct1)=split(',',$spec_ct{$pair});
		}
		else
		{
			$spec_ct1="NA";
			$spec_ct2="NA";
		}
	}

	print "$std\t$pcc_val\t$spec_ct1\t$spec_ct2\n";
}


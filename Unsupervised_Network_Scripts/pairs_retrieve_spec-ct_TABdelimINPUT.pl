#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program outputs the values for the subset present in a dataset

#Dataset of pairs - input eg: pairs_with_SNFsim_ge_0.00110.csv
open(STD,$ARGV[0]);
@std=<STD>;

#spectral counts of proteins
open(SPEC_CT,"../coelution/2/number_of_peptides_overall.csv");
#open(SPEC_CT,$ARGV[1]);
@spec_ct=<SPEC_CT>;
my %spec_cts;
foreach $spec_ct(@spec_ct)
{
	chomp($spec_ct);
	($code,$ct)=split(',',$spec_ct);
        $spec_cts{$code}=$ct;
}

foreach $std(@std)
{
        chomp($std);

	($c1,$c2,$snfval)=split('\t',$std);

	if (exists($spec_cts{$c1}))
	{
		$val_spec_ct_1=$spec_cts{$c1};
	}

	if (exists($spec_cts{$c2}))
	{
		$val_spec_ct_2=$spec_cts{$c2};
	}

	print "$c1,$c2,$snfval,$val_spec_ct_1,$val_spec_ct_2\n";
}


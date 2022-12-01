#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program the coelution scores for a subset of the pairs from a larger set

#Eg: perl find_subset_in_coelution_scores.pl ../toxo/coelution/2/expt_combos/one.tab ../toxo/coelution/2/all_420fractions_wcc.csv > ../toxo/coelution/2/expt_combos/equivalent_one.tab

#file containing list of pairs for which coelution codes need to be generated 
open(STD,$ARGV[0]);

#file containing scores for all the pairs
open(ID,$ARGV[1]);
my @id=<ID>;
my %coelution={};
foreach $id(@id)
{
	chomp($id);
        ($c1,$c2,$scores)=split('#',$id);

        @c1=split('_',$c1);
        @c2=split('_',$c2);

        $code1=join "_",$c1[0],$c1[1];
        $code2=join "_",$c2[0],$c2[1];

        $pair=join ",",$code1,$code2;

        $coelution{$pair}=$scores;

        #print "$fp-$pair;$pccnm{$fp}{$pair}\n";

}

while ($std=<STD>)
{
        chomp($std);

	($c1,$c2)=split(',',$std);

        @c1=split('_',$c1);
        @c2=split('_',$c2);

        $code1=join "_",$c1[0],$c1[1];
        $code2=join "_",$c2[0],$c2[1];

        $pair=join ",",$code1,$code2;

	if (exists($coelution{$pair}))
	{
		print "$c1#$c2#$coelution{$pair}\n"; 
	}
	else
	{
		$pair=join ",",$code2,$code1;
		if(exists($coelution{$pair}))
		{
			print "$c1#$c2#$coelution{$pair}\n"; 
		}
	}
}


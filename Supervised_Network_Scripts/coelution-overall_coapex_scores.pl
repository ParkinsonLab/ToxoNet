#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program calculates coapex scores across experiments
#Eg. Coapex_sc1 - is 2 if there are 2 experiments ie. beads or IEX expts which contain at least one fraction where both proteins show modal abundance ie. it is sum of all Coapex_sc1 from individual fractions
#Eg. Coapex_sc2 - is the sum of all Coapex_sc2 from individual fractions 
#Eg: Usage: perl coapex_scores_across_expts.pl ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/coapex overall_coapex_sc1.tab overall_coapex_sc2.tab
#where input files are -  ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/coapex (this is an input directory)
#output files are - overall_coapex_sc1.tab overall_coapex_sc2.tab

#all combinations list file
open(STD,$ARGV[0]);

#directory containing individual coelution data
my $dir=$ARGV[1];

#OUTPUT files
open(OUT_sc1,">$ARGV[2]");
open(OUT_sc2,">$ARGV[3]");

	my %coapex_frac={};
foreach my $fp (glob("$dir/*_coapex.csv"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        print "$fp\n";

        while(<$fh>)
        {
                ($c,$sc1,$sc2,$sc3)=split('\t',$_);

		($c1,$c2)=split('@',$c);

                @c1=split('_',$c1);
		@c2=split('_',$c2);

                $code1=join "_",$c1[0],$c1[1];
                $code2=join "_",$c2[0],$c2[1];

                $pair=join ",",$code1,$code2;

		$scores=join "_",$sc1,$sc2;

		$coapex_frac{$fp}{$pair}=$scores;

		#print "$fp-$pair;$coapex_frac{$fp}{$pair}\n";
        }
}

while ($std=<STD>)
{
        chomp($std);

        ($c1,$c2)=split(',',$std);

        $pair=join ",",$c1,$c2;

	$coapex_sc1=0;
	$coapex_sc2=0.0;

	foreach my $fp (glob("$dir/*_coapex.csv"))
	{
        	if (exists($coapex_frac{$fp}{$pair}))
        	{
			$scores=$coapex_frac{$fp}{$pair};
			($sc1,$sc2)=split('_',$scores);
			$coapex_sc1=$coapex_sc1+$sc1;
			$coapex_sc2=$coapex_sc2+$sc2;

			#print "Here,$sc1,$sc2,$scores\n";
        	}
        	else
        	{

             		$pair=join ",",$c2,$c1;
	             	if(exists($coapex_frac{$fp}{$pair}))
       	      		{
				$scores=$coapex_frac{$fp}{$pair};
				($sc1,$sc2)=split('_',$scores);
				$coapex_sc1=$coapex_sc1+$sc1;
				$coapex_sc2=$coapex_sc2+$sc2;
			
				#print "Next,$sc1,$sc2,$scores\n";
             		}
        	}
	}

	print OUT_sc1 "$c1\t$c2\t$coapex_sc1\n";
	print OUT_sc2 "$c1\t$c2\t$coapex_sc2\n";
}


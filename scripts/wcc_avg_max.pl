#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program calculates avg and max pcc_noisemodel across experiments 
#Eg: Usage: perl wcc_avg_max.pl ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/wcc overall_wcc_avg.tab overall_wcc_max.tab
#where input files are -  ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/coapex (this is an input directory)
#output files are - overall_wcc_avg.tab overall_wcc_max.tab

#all combinations list file
open(STD,$ARGV[0]);

#directory containing individual coelution data
my $dir=$ARGV[1];

#OUTPUT files
open(OUT_sc1,">$ARGV[2]");
open(OUT_sc2,">$ARGV[3]");

	my %wcc={};
foreach my $fp (glob("$dir/*_wcc_WITHIDs.csv"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        print "$fp\n";

        while(<$fh>)
        {
		chomp($_);
                ($c1,$c2,$scores)=split(',',$_);

                @c1=split('_',$c1);
		@c2=split('_',$c2);

                $code1=join "_",$c1[0],$c1[1];
                $code2=join "_",$c2[0],$c2[1];

                $pair=join ",",$code1,$code2;

		$wcc{$fp}{$pair}=$scores;

		#print "$fp-$pair;$wcc{$fp}{$pair}\n";
        }
}

while ($std=<STD>)
{
        chomp($std);

        ($c1,$c2)=split(',',$std);

        $pair=join ",",$c1,$c2;

	$wcc_avg=0.0;
	$wcc_max=0.0;
	$found_expts=0;

	foreach my $fp (glob("$dir/*_wcc_WITHIDs.csv"))
	{
        	if (exists($wcc{$fp}{$pair}))
        	{
			$scores=$wcc{$fp}{$pair};
		
			if($scores =~ /nan/)
			{
				$scores=0;
			}

			$wcc_avg=$wcc_avg+$scores;

			if($scores > $wcc_max)
			{
				$wcc_max=$scores;
			}
			$found_expts++;

			#print "Here,$sc1,$sc2,$scores\n";
        	}
        	else
        	{

             		$pair=join ",",$c2,$c1;
	             	if(exists($wcc{$fp}{$pair}))
       	      		{
				$scores=$wcc{$fp}{$pair};

	                        if($scores =~ /nan/)
        	                {
               	                	$scores=0;
               		        }

				$wcc_avg=$wcc_avg+$scores;

	                        if($scores > $wcc_max)
        	                {
               	                	$wcc_max=$scores;
                        	}
                        	$found_expts++;
			
				#print "Next,$sc1,$sc2,$scores\n";
             		}
        	}
	}

	$wcc_avg=$wcc_avg/$found_expts;
	print OUT_sc1 "$c1\t$c2\t$wcc_avg\n";
	print OUT_sc2 "$c1\t$c2\t$wcc_max\n";
}


#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program calculates avg and max pcc_noisemodel across experiments 
#Eg: Usage: perl pcc_noisemodel_avg_max.pl ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/pcc overall_pccnm_avg.tab overall_pccnm_max.tab
#where input files are -  ../toxo/coelution/2/all_combos_coelution_ME49codes.csv ../toxo/coelution/2/coapex (this is an input directory)
#output files are - overall_pccnm_avg.tab overall_pccnm_max.tab

#all combinations list file
open(STD,$ARGV[0]);

#directory containing individual coelution data
my $dir=$ARGV[1];

#OUTPUT files
open(OUT_sc1,">$ARGV[2]");
open(OUT_sc2,">$ARGV[3]");

	my %pccnm={};
foreach my $fp (glob("$dir/*_pcc_noisemodel.csv"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        print "$fp\n";

        while(<$fh>)
        {
		chomp($_);
                ($c1,$c2,$scores)=split('#',$_);

                @c1=split('_',$c1);
		@c2=split('_',$c2);

                $code1=join "_",$c1[0],$c1[1];
                $code2=join "_",$c2[0],$c2[1];

                $pair=join ",",$code1,$code2;

		$pccnm{$fp}{$pair}=$scores;

		#print "$fp-$pair;$pccnm{$fp}{$pair}\n";
        }
}

while ($std=<STD>)
{
        chomp($std);

        ($c1,$c2)=split(',',$std);

        $pair=join ",",$c1,$c2;

	$pccnm_avg=0.0;
	$pccnm_max=0.0;
	$found_expts=0;

	foreach my $fp (glob("$dir/*_pcc_noisemodel.csv"))
	{
        	if (exists($pccnm{$fp}{$pair}))
        	{
			$scores=$pccnm{$fp}{$pair};
		
			if($scores =~ /nan/)
			{
				$scores=0;
			}

			$pccnm_avg=$pccnm_avg+$scores;

			if($scores > $pccnm_max)
			{
				$pccnm_max=$scores;
			}
			$found_expts++;

			#print "Here,$sc1,$sc2,$scores\n";
        	}
        	else
        	{

             		$pair=join ",",$c2,$c1;
	             	if(exists($pccnm{$fp}{$pair}))
       	      		{
				$scores=$pccnm{$fp}{$pair};

	                        if($scores =~ /nan/)
        	                {
               	                	$scores=0;
               		        }

				$pccnm_avg=$pccnm_avg+$scores;

	                        if($scores > $pccnm_max)
        	                {
               	                	$pccnm_max=$scores;
                        	}
                        	$found_expts++;
			
				#print "Next,$sc1,$sc2,$scores\n";
             		}
        	}
	}

	$pccnm_avg=$pccnm_avg/$found_expts;
	print OUT_sc1 "$c1\t$c2\t$pccnm_avg\n";
	print OUT_sc2 "$c1\t$c2\t$pccnm_max\n";
}


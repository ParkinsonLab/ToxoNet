#!/usr/bin/perl -w

#Author: Swapna Seshadri
#Usage: perl ~/workspace/toxonet/scripts/pairs_with_pcc_or_wcc_ge0.5.pl all_combos_coelution_ME49codes.csv pcc wcc combos_with_pcc_or_wcc_ge0.5.csv 0.8

#all combinations list file
open(STD,$ARGV[0]);

#directory containing individual coelution data
#pcc
my $dir_pcc=$ARGV[1];
#wcc
my $dir_wcc=$ARGV[2];

#OUTPUT files
open(OUT,">$ARGV[3]");

	my %pccnm={};
foreach my $fp (glob("$dir_pcc/*_pcc_noisemodel.csv"))
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

        my %wcc={};
foreach my $fp (glob("$dir_wcc/*_wcc_WITHIDs.csv"))
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
	#print "$std";
        chomp($std);

        ($c1,$c2)=split(',',$std);

        $pair=join ",",$c1,$c2;

	$found=0;

	foreach my $fp (glob("$dir_pcc/*_pcc_noisemodel.csv"))
	{
		$pair=join ",",$c1,$c2;
		#print "Now $fp .. 1\n";
        	if (exists($pccnm{$fp}{$pair}))
        	{
			$scores=$pccnm{$fp}{$pair};
		
			if($scores >= $ARGV[4])
			{
		                foreach my $fp2 (glob("$dir_wcc/*_wcc_WITHIDs.csv"))
               			{
		                        $pair=join ",",$c1,$c2;
		                        #print "Now $fp .. 3\n";
               			        if (exists($wcc{$fp2}{$pair}))
                        		{
                                		$scores2=$wcc{$fp2}{$pair};

		                                if($scores2 >= $ARGV[4])
               			                {
                               			         #print "Here $fp .. 3\n";
		                                        print OUT "$c1\t$c2\t$scores\t$scores2\n";
		                                        last;
               			                }
                        		}
	                        	else
       		                	{
                                		#print "Now $fp .. 4\n";
	                                	$pair=join ",",$c2,$c1;
	        	                        if(exists($wcc{$fp2}{$pair}))
               		                	{
                                        		$scores2=$wcc{$fp2}{$pair};

		                                        if($scores2 >= $ARGV[4])
        		                                {
               			                                 #print "Here $fp .. 4\n";
               	        		                         print OUT "$c1\t$c2\t$scores\t$scores2\n";
               	                		                 last;
               		                         	}
               		                 	}
               		         	}
               	 		}
				last;
			}
        	}
        	else
        	{
			#print "Now $fp .. 2\n";
             		$pair=join ",",$c2,$c1;
	             	if(exists($pccnm{$fp}{$pair}))
       	      		{
				$scores=$pccnm{$fp}{$pair};

	                        if($scores >= $ARGV[4])
        	                {
	                                foreach my $fp2 (glob("$dir_wcc/*_wcc_WITHIDs.csv"))
       		                         {
               		                         $pair=join ",",$c1,$c2;
                       		                 #print "Now $fp .. 3\n";
                               		         if (exists($wcc{$fp2}{$pair}))
                                       		 {
                                               		 $scores2=$wcc{$fp2}{$pair};

	                                                if($scores2 >= $ARGV[4])
        	                                        {
                	                                         #print "Here $fp .. 3\n";
                       		                                 print OUT "$c1\t$c2\t$scores\t$scores2\n";
                               		                         last;
                                       		         }
                                        	}
	                                        else
       		                                {
                                                	#print "Now $fp .. 4\n";
	                                                $pair=join ",",$c2,$c1;
       		                                        if(exists($wcc{$fp2}{$pair}))
                                                	{
                                                        	$scores2=$wcc{$fp2}{$pair};

	                                                        if($scores2 >= $ARGV[4]) 
       		                                                 {
               		                                                  #print "Here $fp .. 4\n";
	                                                                 print OUT "$c1\t$c2\t$scores\t$scores2\n";
       		                                                          last;
               		                                         }
                       		                         }
                               		         }
                                	}
					last;
               		        }
             		}
        	}
	}


}


#!/usr/bin/perl -w

#Author: Swapna Seshadri
#Usage: perl ~/workspace/toxonet/scripts/pairs_with_pcc_or_wcc_ge0.5.pl all_combos_coelution_ME49codes.csv pcc wcc combos_with_pcc_or_wcc_ge0.5.csv

#all combinations list file
open(STD,$ARGV[0]);

#directory containing individual coelution data
#pcc
my $dir_pcc=$ARGV[1];
#wcc
my $dir_wcc=$ARGV[2];

#specified string to match within the set 
my $tag=$ARGV[3];

#OUTPUT files
open(OUT,">$ARGV[4]");

	my %pccnm={};
#foreach my $fp (glob("$dir_pcc/pccnm_cn_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_cn_toxo_IEX120_cleaned_$tag.tab"))
#foreach my $fp (glob("$dir_pcc/pccnm_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_toxo_IEX120_cleaned_$tag.tab"))
foreach my $fp (glob("$dir_pcc/pccnm_rn_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_rn_toxo_IEX120_cleaned_$tag.tab"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        print "$fp\n";

        while(<$fh>)
        {
		chomp($_);
                ($c1,$c2,$scores)=split('\t',$_);

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
#foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag*_cn.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag*_cn.tab"))
#foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag.tab"))
foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag*_rn.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag*_rn.tab"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        print "$fp\n";

        while(<$fh>)
        {
                chomp($_);
                ($c1,$c2,$scores)=split('\t',$_);

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

        ($s1,$s2,$val)=split(',',$std);

        @s1=split('_',$s1);
        @s2=split('_',$s2);

        $c1=join "_",$s1[0],$s1[1];
        $c2=join "_",$s2[0],$s2[1];


        $pair=join ",",$c1,$c2;

	$found=0;

	#foreach my $fp (glob("$dir_pcc/pccnm_cn_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_cn_toxo_IEX120_cleaned_$tag.tab"))
	#foreach my $fp (glob("$dir_pcc/pccnm_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_toxo_IEX120_cleaned_$tag.tab"))
	foreach my $fp (glob("$dir_pcc/pccnm_rn_toxo_beads?_cleaned_$tag.tab $dir_pcc/pccnm_rn_toxo_IEX120_cleaned_$tag.tab"))
	{
		$pair=join ",",$c1,$c2;
		#print "Now $fp .. 1\n";
        	if (exists($pccnm{$fp}{$pair}))
        	{
			$scores=$pccnm{$fp}{$pair};
		
			if($scores >= 0.5)
			{
				#print "Here $fp .. 1\n";
				print OUT "$c1\t$c2\t$scores\tpccnm_rn\n";
				$found=1;
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

	                        if($scores >= 0.5)
        	                {
					#print "Here $fp .. 2\n";
					print OUT "$c1\t$c2\t$scores\tpccnm_rn\n";
					$found=1;
					last;
               		        }
             		}
        	}
	}


	if($found == 0)
	{
        	#foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag*_cn.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag*_cn.tab"))
        	#foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag.tab"))
        	foreach my $fp (glob("$dir_wcc/wcc_toxo_beads?_cleaned_$tag*_rn.tab $dir_wcc/wcc_toxo_IEX120_cleaned_$tag*_rn.tab"))
        	{
			$pair=join ",",$c1,$c2;
                        #print "Now $fp .. 3\n";
                	if (exists($wcc{$fp}{$pair}))
                	{
				$scores=$wcc{$fp}{$pair};

	                        if($scores >= 0.5)
       		                {
					#print "Here $fp .. 3\n";
                                	print OUT "$c1\t$c2\t$scores\twcc\n";
                                	last;
                        	}
                	}
	                else
       		        {
                        	#print "Now $fp .. 4\n";
                        	$pair=join ",",$c2,$c1;
                        	if(exists($wcc{$fp}{$pair}))
                        	{
                                	$scores=$wcc{$fp}{$pair};

                                	if($scores >= 0.5)
                                	{
						#print "Here $fp .. 4\n";
                                        	print OUT "$c1\t$c2\t$scores\twcc\n";
                                        	last;
                                	}
                        	}
                	}
        	}
	}

}


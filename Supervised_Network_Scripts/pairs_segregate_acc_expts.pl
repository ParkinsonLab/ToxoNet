#!/usr/bin/perl -w
use List::MoreUtils qw/uniq/;

#Author: Swapna Seshadri
#This script identifies all the coelution expts that should be considered for scoring a protein pair
#eg. protein1-protein2 -> if protein1 found only in beadsA but protein2 found in beadsA and beads C -> both beadsA and beadsC should be considered - and not any of the other expts

#Usage: perl ~/workspace/toxonet/scripts/pairs_with_pcc_or_wcc_ge0.5.pl all_combos_coelution_ME49codes.csv pcc wcc combos_with_pcc_or_wcc_ge0.5.csv
#Input: <file containing protein pairs of all possible combinations> <directory containing individual coelution data> 
#Output: <protein1>-<protein2>-<expt1,expt2,etc>

#all combinations list file
#eg: ../toxo/coelution/2/all_420fractions_pcc_noisemodel.csv
open(STD,$ARGV[0]);

#directory containing individual coelution data
#pcc
my $dir_coelution=$ARGV[1];

	my %coel_expts={};
foreach my $fp (glob("$dir_coelution/toxo_beads*.csv"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        #print "$fp\n";

        while(<$fh>)
        {
		if($_ !~ /Locus/)
		{
			chomp($_);
			@cols=split('@',$_);

       		        @c1=split('_',$cols[0]);

       	         	$protein=join "_",$c1[0],$c1[1];

			$coel_expts{$fp}{$protein}=1;

			#print "$fp-$pair;$coel_expts{$fp}{$pair}\n";
		}
        }
}

foreach my $fp (glob("$dir_coelution/toxo_IEX*.csv"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

        #print "$fp\n";

        while(<$fh>)
        {
		if($_ !~ /Locus/)
		{
                	chomp($_);
                        @cols=split('@',$_);

                        @c1=split('_',$cols[0]);

                        $protein=join "_",$c1[0],$c1[1];

                        $coel_expts{$fp}{$protein}=1;

       	         	#print "$fp-$pair;$coel_expts{$fp}{$pair}\n";
		}
        }
}


while ($std=<STD>)
{
	#print "$std";
        chomp($std);

        ($code1,$code2,$score)=split('#',$std);
	@val1=split('_',$code1);
	@val2=split('_',$code2);

	$c1=join "_",$val1[0],$val1[1];
	$c2=join "_",$val2[0],$val2[1];

	@expts_holder_c1=();
	@expts_holder_c2=();

	foreach my $fp (glob("$dir_coelution/toxo_beads*.csv"))
	{
		#print "Now $fp .. 1\n";
        	if (exists($coel_expts{$fp}{$c1}))
        	{
			push(@expts_holder_c1,$fp);
        	}
		
		if (exists($coel_expts{$fp}{$c2}))
		{
			push(@expts_holder_c2,$fp);
		}
	}


        foreach my $fp (glob("$dir_coelution/toxo_IEX*.csv"))
        {
                #print "Now $fp .. 1\n";
                if (exists($coel_expts{$fp}{$c1}))
                {
                        push(@expts_holder_c1,$fp);
                }

                if (exists($coel_expts{$fp}{$c2}))
                {
                        push(@expts_holder_c2,$fp);
                }
        }

	@expts_c1=uniq sort @expts_holder_c1;
	@expts_c2=uniq sort @expts_holder_c2;

	$common_expts=0;

	foreach $expts_c1(@expts_c1)
	{
		foreach $expts_c2(@expts_c2)
		{
			if("$expts_c1" eq "$expts_c2")
			{
				$common_expts++;
			}
		}
	}

	if($common_expts > 0)
	{
		print "$c1,$c2#";

		@expts_all=();
		foreach $expt(@expts_c1)
		{
			push(@expts_all,$expt);
		}

		foreach $expt(@expts_c2)
		{
			push(@expts_all,$expt);
		}

		@expt=uniq sort @expts_all;

		foreach $expt(@expt)
		{
			print "$expt,";
		}
		print "\n";
	}
}


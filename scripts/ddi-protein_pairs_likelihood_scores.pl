#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program calculates likelihood scores for protein pairs, by summing up the likelihood scores for all possible domain combinations between 2 proteins (Likelihood scores taken from Lee et al. Supp 7 file.
#Input: 3 files
#proteins_domains.csv files - contains 2 comman-separated fields: Field1 - protein code (_STD format); Field2 - Set of Pfam domains assigned to it, separated by + ie. All PFxxxx, PBxxxx etc.
#overall_id_mapping.csv file - This contains the phylopro ID mapping file for the species of interest - tab separated columns - first column is _STD code, 3rd column is the actual protein code ie. for Tgondii TGME49_ codes.
#Lee_dataset_addnfile-s7.txt - This corresponds to the Supplementary table from the paper containing likelihood scores for combinations of Pfam domains. Space separated columns with Column2 and Column3 corresponding to Pfam scores and Column4 the likelihood score based on Bayesian approach.
#Output: 2 files - detailed and compact
#pp_likelihood_scores_detailed.csv and pp_likelihood_scores.csv
#proteins_domains.csv file

#Note: Modification at end

open(PD,$ARGV[0]);
my @pd=<PD>;

#overall_id_mapping.csv
open(ID,$ARGV[1]);
my @id=<ID>;
my %ids;
foreach $id(@id)
{
	chomp($id);
	@line=split('\t',$id);
	$ids{$line[0]}=$line[2];
}

#print "$ids{Tgondii_1003}\n";

#Lee_dataset_addnfile-s7.txt
open(LEE,$ARGV[2]);
my @lee=<LEE>;

#Hash of domain pairs and log_likelihood scores
my %dd_lls;
foreach $lee(@lee)
{
	if ($lee =~ /PF/)
	{
		@line=split(/\s+/,$lee);
		$dd_pair=join "",$line[1],$line[2];
		#print "$dd_pair,$line[3]\n";
		$dd_lls{$dd_pair}=$line[3];
	}
}

#print "$dd_lls{PF00400PF00009}\n";

#Output files: detailed and compact
open(DET,">$ARGV[3]/pp_likelihood_scores_detailed.csv");
open(CMPT,">$ARGV[3]/pp_likelihood_scores.tab");

for($i=0;$i<$#pd;$i=$i+1)
{
	($c1,$rest1)=split(',',$pd[$i]);
	chop($rest1); #to remove the trailing + at the end
	$code1=$ids{$c1};

	#print "$c1-$code1\n";
	for($j=$i+1;$j<=$#pd;$j=$j+1)
	{
		($c2,$rest2)=split(',',$pd[$j]);
		chop($rest2);	
	        $code2=$ids{$c2};

		print DET ">>$code1-$code2\n";
		print DET "$code1,$rest1\n";
		print DET "$code2,$rest2\n";

		@tmp_llsc=();
	

		@rest1=split('\+',$rest1);	
		@rest2=split('\+',$rest2);	

		foreach $r1(@rest1)
		{
			foreach $r2(@rest2)
			{
				if ($r1 eq $r2)
				{
					$srch=join "",$r1,$r2;
			

					if(exists $dd_lls{$srch})
					{
						$srch_lls=$dd_lls{$srch};
						print DET "$srch,$srch_lls\n";
						push @tmp_llsc, $srch_lls;
					}
					else
					{
						print DET "$srch,NOTFOUND\n";
					}
				}
				else
				{
					$srch=join "",$r1,$r2;


					if(exists $dd_lls{$srch})
					{
                                                $srch_lls=$dd_lls{$srch};
                                                print DET "$srch,$srch_lls\n";
                                                push @tmp_llsc, $srch_lls;
					}
					else
					{
						$srch=join "",$r2,$r1;


						if(exists $dd_lls{$srch})
						{
                                                	$srch_lls=$dd_lls{$srch};
                                                	print DET "$srch,$srch_lls\n";
                                                	push @tmp_llsc, $srch_lls;
						}
						else
						{
	                                                print DET "$srch,NOTFOUND\n";
						}
					}
				}
			}
		}

		if (@tmp_llsc)
		{
			$llscore=0.0;
			foreach $t(@tmp_llsc)	
			{
				$llscore=$llscore+$t;
			}
			print CMPT "$code1\t$code2\t$llscore\n";
		}
	
		#This section has been removed just to ensure that missing information about "domain-domain" likelihood information NOT found is NOT assigned an arbitrary value of zero

		#else
		#{
		#	print CMPT "$code1\t$code2\t0\n"
		#*/
	}
}

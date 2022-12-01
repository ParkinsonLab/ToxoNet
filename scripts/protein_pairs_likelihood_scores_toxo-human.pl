#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program calculates likelihood scores for protein pairs, by summing up the likelihood scores for all possible domain combinations between 2 proteins (Likelihood scores taken from Lee et al. Supp 7 file.
#Input: 4 files
#proteins_domains.csv files  for both pathogen and host eg. Toxo and human in this case - contains 2 comman-separated fields: Field1 - protein code (_STD format); Field2 - Set of Pfam domains assigned to it, separated by + ie. All PFxxxx, PBxxxx etc.
#overall_id_mapping.csv files for both pathogen and host eg. Toxo and human in this case - This contains the phylopro ID mapping file for the species of interest - tab separated columns - first column is _STD code, 3rd column is the actual protein code ie. for Tgondii TGME49_ codes.
#Lee_dataset_addnfile-s7.txt - This corresponds to the Supplementary table from the paper containing likelihood scores for combinations of Pfam domains. Space separated columns with Column2 and Column3 corresponding to Pfam scores and Column4 the likelihood score based on Bayesian approach.
#Output: 2 files - detailed and compact
#pp_likelihood_scores_detailed.csv and pp_likelihood_scores.csv
#proteins_domains.csv file - for pathogen
open(PD1,$ARGV[0]);
my @pd1=<PD1>;

#proteins_domains.csv file - for host
open(PD2,$ARGV[1]);
my @pd2=<PD2>;

#overall_id_mapping.csv - for pathogen
open(ID1,$ARGV[2]);
my @id1=<ID1>;
my %ids1;
foreach $id1(@id1)
{
	chomp($id1);
	@line=split('\t',$id1);
	$ids1{$line[0]}=$line[2];
}

#print "$ids{Tgondii_1003}\n";

#overall_id_mapping.csv - for host
open(ID2,$ARGV[3]);
my @id2=<ID2>;
my %ids2;
foreach $id2(@id2)
{
        chomp($id2);
        @line=split('\t',$id2);
        $ids2{$line[0]}=$line[2];
}

#Lee_dataset_addnfile-s7.txt
open(LEE,$ARGV[4]);
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
open(DET,">pp_likelihood_scores_detailed.csv");
open(CMPT,">pp_likelihood_scores.csv");

#Outer loop - pathogen
#Inner loop - host
for($i=0;$i<=$#pd1;$i=$i+1)
{
	($c1,$rest1)=split(',',$pd1[$i]);
	chop($rest1); #to remove the trailing + at the end
	$code1=$ids1{$c1};

	#print "$c1-$code1\n";
	for($j=0;$j<=$#pd2;$j=$j+1)
	{
		($c2,$rest2)=split(',',$pd2[$j]);
		chop($rest2);	
	        $code2=$ids2{$c2};

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
			print CMPT "$code1,$code2,$llscore\n";
		}
		else
		{
			print CMPT "$code1,$code2,0\n"
		}
	}
}

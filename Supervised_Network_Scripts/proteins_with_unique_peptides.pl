#!/usr/bin/perl -w
use List::MoreUtils qw/uniq/;

#Author: Swapna Seshadri
#This program identifies proteins with unique peptides from all co-elution data. It outputs both the total number of unique peptides for a protein from all fractions - and the peptides themselves.
#Usage: perl proteins_with_unique_peptides.pl ~/workspace/toxonet/zhongming/peptide_files/Toxo/ 

#directory containing the peptide files - outer directory
#eg: ~/workspace/toxonet/zhongming/peptide_files/Toxo/ 
my $dir_peptides=$ARGV[0];

open(OUT_all_peptides,">proteins_all_peptides.out");


#Step 1:  a) Generate unique list of codes in all peptide files b) Generate a hash of all experiments and proteins - with list of peptides associated with it

print "Step 1 ......................................\n";
	@list_codes=();
	my %peptides={};
foreach my $fp (glob("$dir_peptides/*/*/*_dta.stt"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";
	@fh=<$fh>;

        print "$fp\n";

        for($i=0;$i<=$#fh;$i++)
        {
		if($fh[$i] =~ /^>/)
		{
			chomp($fh[$i]);
			@cols=split('\t',$fh[$i]);
			$code=$cols[0];
	
			push(@list_codes,$code);

			$i++;
			@pep=();
			while($fh[$i] !~ /^>/ && $i<=$#fh)
			{
				chomp($fh[$i]);
				@cols=split('\t',$fh[$i]);
				push(@pep,$cols[8]);
				$i++;
			}

			$peptides{$fp}{$code}=[@pep];

			$i--;

			print ">>>>\n$fp\n$code\n@pep\n";
			@chk=@{$peptides{$fp}{$code}};
			print "@chk\n";	
		}
		print "@@@@@\n";
        }
}

@uniq_codes=uniq sort @list_codes;
print "$#list_codes - $#uniq_codes\n";

#Step 2 - Generate an overall hash - of all unique proteins - and all unique peptides associated with it (by pooling peptides from various experiments

print "Step 2 ......................................\n";

	%overall_uniq_peptides={};
foreach $uniq_code(@uniq_codes)
{
	@all_peptides=();
	foreach my $fp (glob("$dir_peptides/*/*/*_dta.stt"))
	{
		@expt=@{$peptides{$fp}{$uniq_code}};

		foreach $expt(@expt)
		{
			push(@all_peptides,$expt);
		}
	}
	@uniq_set=uniq sort @all_peptides;

	$overall_uniq_peptides{$uniq_code}=[@uniq_set];

	print ">>>> $uniq_code\n@all_peptides\n@uniq_set\n";
	$tot_uniq_peptides=$#uniq_set+1;
	print OUT_all_peptides "$uniq_code,$tot_uniq_peptides,@uniq_set\n";
}

#Step 3 - Generate only unique peptides for each protein - by comparing the peptides of the protein with peptides from all other proteins

print "Step 3 ......................................\n";

print "$#uniq_codes !!\n";
for ($i=0; $i<=2 ; $i++)
{
	@protein_pep=@{$overall_uniq_peptides{$uniq_codes[$i]}};

	print "@protein_pep\n";
	
	@all_other_peptides=();
	for($j=0; $j<=$#$uniq_codes; $j++)
	{
		print "One..\n";
		if($j!=$i)
		{
			print "Two..\n";
			@pep=@{$overall_uniq_peptides{$uniq_codes[$j]}};

			foreach $pep(@pep)
			{
				print "Inside - $pep\n";
				push(@all_other_peptides,$pep);
			}
		}
	}

	@uniq_all_other_peptides=uniq sort @all_other_peptides;

	print ">>>@protein_pep\n####@uniq_all_other_peptides\n";

	##Finding uniq_peptides for a protein - based on exact matches

		@uniq_pep_protein=();
	foreach $pep(@protein_pep)
	{
			$ct=0;
		foreach $others(@uniq_all_other_peptides) 
		{
			#Variation 1: Checking for equivalent peptides
			#if($pep eq $others)
			#{
			#	$ct++;
			#}

			#Variation 2: Checking for substring in peptides
			#$pep_ss = ~s/[^[A-Z]]//g;
			#$others_ss = ~s/[^[A-Z]]//g;

			#print "$pep_ss\n$others_ss\n";
			#Check if one is a substring of the other
			#if((index($pep_ss,$others_ss) != -1) || (index($others_ss,$pep_ss) != -1))
			#{
			#	$ct++;
			#}
		}

		if($ct == 0)
		{
			push(@uniq_pep_protein,$pep);
		}	
	}

	$tot_uniq_peptides=$#uniq_pep_protein+1;
	print "$uniq_codes[$i],$tot_uniq_peptides,@uniq_pep_protein\n";
}


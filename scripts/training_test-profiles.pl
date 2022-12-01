#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This script generates the list of profiles for training and test datasets from the integrated_profile sets 
#Usage:

#the main profiles file
open(PROFILES,$ARGV[0]);
@profiles=<PROFILES>;

#the file containing list of code pairs
open(PAIRS,$ARGV[1]);
@pairs=<PAIRS>;

#OUTPUT files
open(OUT,">$ARGV[2]");

print OUT $profiles[0];

	my %profiles_set={};
foreach $profiles(@profiles)
{
	chomp($profiles);
	@fields=split(',',$profiles);

	$code_pair=$fields[0];

	$profiles_set{$code_pair}=$profiles;
}

foreach $pairs(@pairs)
{
        chomp($pairs);

	@codes_set=split('\t',$pairs);

	#print "$pairs\n";
	$code_pair=join "-",$codes_set[0],$codes_set[1];		
	$code_pair=~s/-$//;

       	if (exists($profiles_set{$code_pair}))
       	{
		print OUT "$profiles_set{$code_pair}\n";
	}
	else
	{
		print OUT "$code_pair NOT FOUND\n";
	}
}

#!/usr/bin/perl -w
#Author: Swapna Seshadri
#This code takes a coelution matrix - and generates pairwise combinations of all protein codes from the matrix 

open(CODES,$ARGV[0]);
@codes=<CODES>;

#Take first column

#Bypass the first row - as it is header
for($i=1;$i<$#codes;$i++)
{
	@codes1=split('\t',$codes[$i]);
	for($j=$i+1;$j<=$#codes;$j++)
	{
		@codes2=split('\t',$codes[$j]);

		print "$codes1[0]\t$codes2[0]\n";
	}
}

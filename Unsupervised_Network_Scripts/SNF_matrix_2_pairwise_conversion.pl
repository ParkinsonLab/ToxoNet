#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program converts the SNF matrix details in a pairwise fashion

#SNF matrix file
open(SNF,$ARGV[0]);
my @SNF=<SNF>;
my %SNFs;
foreach $SNF(@SNF)
{
	chomp($SNF);
	@details=split(' ',$SNF);
        $SNFs{$details[0]}=$SNF;
}

#Getting all codes in SNF dissimilarity matrix file
chomp($SNF[0]);
@codes_all=split(' ',$SNF[0]);

print "Source\tTarget\tSNFsimilarity\n";
for($x=2;$x<$#codes_all;$x++)
{
        chomp($codes_all[$x]);

	@SNF_vals=split(' ',$SNFs{$codes_all[$x]});

	for($y=2;$y<=$#SNF_vals;$y++)
	{
		if($y>$x)
		{
			print "$codes_all[$x]\t$codes_all[$y]\t$SNF_vals[$y]\n";
		}
	}
}


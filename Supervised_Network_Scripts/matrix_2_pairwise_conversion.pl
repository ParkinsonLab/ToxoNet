#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program converts a matrix details in a pairwise fashion

#matrix file
open(MATRIX_FILE,$ARGV[0]);
open(OUT_FILE,">$ARGV[1]");

my @matrix=<MATRIX_FILE>;
my %matrix;
foreach $matrix(@matrix)
{
	chomp($matrix);
	@details=split('\t',$matrix);
        $matrix{$details[0]}=$matrix;
}

#Getting all codes in file
chomp($matrix[0]);
@codes_all=split('\t',$matrix[0]);

for($x=2;$x<$#codes_all;$x++)
{
        chomp($codes_all[$x]);

	@matrix_vals=split('\t',$matrix{$codes_all[$x]});

	for($y=2;$y<=$#matrix_vals;$y++)
	{
		if($y>$x)
		{
			print OUT_FILE "$codes_all[$x]\t$codes_all[$y]\t$matrix_vals[$y]\n";
		}
	}
}


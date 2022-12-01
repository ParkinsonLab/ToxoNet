#!/usr/bin/perl -w
use List::MoreUtils qw/uniq/;

open(mFILE,$ARGV[0]);
my @mfile=<mFILE>;

foreach $mfile(@mfile)
{
	chomp($mfile);
	($one,$two)=split(',',$mfile);
	@arr=();
	push @arr,$one;
	push @arr,$two;

	@sorted=uniq sort @arr;

	print "$sorted[0],$sorted[1]\n";

}

exit();


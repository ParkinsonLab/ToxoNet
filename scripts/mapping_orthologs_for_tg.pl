#!/usr/bin/perl -w

#Author: Swapna Seshadri
#This program maps an out put for

#MI_TG_STD codes
open(STD,$ARGV[0]);

#mapping file - overall_id_mapping.csv
open(ID,$ARGV[1]);
my @id=<ID>;
my %ids;
foreach $id(@id)
{
        @line=split('\t',$id);
        $ids{$line[0]}=$line[2];
}


while ($std=<STD>)
{
	chomp($std);

	($c1,$c2)=split(',',$std);

	$tg_code1=$ids{$c1};	
	$tg_code2=$ids{$c2};	

	print "$tg_code1,$tg_code2\n"
}

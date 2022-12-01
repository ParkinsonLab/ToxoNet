#!/usr/bin/perl -w

#Author: Swapna Seshadri

#Input file
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

	#Specify these two - based on the file - IMPORTANT

	#Set1
	@cols=split(',',$std);
	$tgstd=$cols[0];

	#Set2 - For sequence file
	#if($std =~ />/)
	#{	
		#$tgstd=$std;
		#$tgstd =~ s/>//;
		$tgme49=$ids{$tgstd};

		$std =~ s/$tgstd/$tgme49/;
		
		#If you want to show both the IDs - separated by a hyphen
		#$std =~ s/$tgstd/$tgstd-$tgme49/;
		print "$std\n";	
	#}
	#else
	#{
	#	print "$std\n";
	#}
}

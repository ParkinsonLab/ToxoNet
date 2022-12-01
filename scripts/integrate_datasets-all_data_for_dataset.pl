#!/usr/bin/perl -w
#use List::MoreUtils qw/uniq/;

#This program integrates all data pertaining to a set of protein pairs and reports it in a tab separated table for use in whatever manner
#It uses hashes to build the output file

#Input: requires the files to be processed in the input/ folder - tab separated - 3 columns 1st column - protein code1, 2nd column - protein code2, 3rd column -score
#In case there are additional info attached to the codes, they will be removed ie. only the first 2 columns of "_" will be taken - considering only those pairs found in COELUTION (all_expts) 
#Output: generates a large tab separated file consisting of all possible protein code combinations from the files in the input. In case a particular combination is not present in one of the files, it will be given a value of -. 

#Eg: perl all_data_for_dataset.pl input refset3_Cy_Togt3ECpwy.tab refset3_Cy_Togt3ECpwy_all_datasets.tab

my $dir = $ARGV[0];

=head1
This would work for cases where we dont know if any particular dataset has all the combinations under consideration
foreach my $fp (glob("$dir/*.tab"))
{
	open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

	print "$fp\n";

	while(<$fh>)
	{
		($c1,$c2,$score)=split('\t',$_);

		@c1=split('_',$c1);		
		@c2=split('_',$c2);	

		$code1=join "_",$c1[0],$c1[1];
		$code2=join "_",$c2[0],$c2[1];

		$pair=join ",",$code1,$code2;

		push @code_pairs, $pair;

	}
}
=cut

#Output file
open(OUT,">$ARGV[2]");

#In our case, we know that the all_expts coelution has all the pairwise codes.. so let us use that for list of all pairwise combinations

print OUT "Dataset\t";
open(TE,"$ARGV[1]");
while(<TE>)
{
	chomp($_);
	($c1,$c2,$val)=split('\t',$_);
        @c1=split('_',$c1);
        @c2=split('_',$c2);

        $code1=join "_",$c1[0],$c1[1];
        $code2=join "_",$c2[0],$c2[1];

	print OUT "$code1,$code2\t"
}
print OUT "\n";

foreach my $fp (glob("$dir/*.tab"))
{
        open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";

	#Building the hash for current dataset
	my %dataset;
	%dataset=();
        while(<$fh>)
        {
		chomp($_);
                ($c1,$c2,$score)=split('\t',$_);

                @c1=split('_',$c1);
                @c2=split('_',$c2);

                $code1=join "_",$c1[0],$c1[1];
                $code2=join "_",$c2[0],$c2[1];

                $pair=join ",",$code1,$code2;
		$dataset{$pair}=$score;

        }

	#Writing out a row for all possible pairwise combinations for the current dataset (the columns are - protein pair combinations)	
	open(TE,"$ARGV[1]");

	print OUT "$fp\t";
	while(<TE>)
	{
		chomp($_);
		($c1,$c2,$val)=split('\t',$_);

		@c1=split('_',$c1);
                @c2=split('_',$c2);

                $code1=join "_",$c1[0],$c1[1];
                $code2=join "_",$c2[0],$c2[1];

		$pair=join ",",$code1,$code2;

		if(exists($dataset{$pair}))
		{
			print OUT "$dataset{$pair}\t";
		}
		else
		{
			#Check if it is stored in the reverse order in the hash
			$pair=join ",",$code2,$code1;

			if(exists($dataset{$pair}))
			{
				print OUT "$dataset{$pair}\t";
			}
			else
			{
				#Data not available in this hash for this pair
				print OUT "-\t";
			}
		}
	}	
	print OUT "\n";
}

 



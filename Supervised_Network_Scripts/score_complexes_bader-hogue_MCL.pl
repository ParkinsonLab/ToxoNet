#!/usr/bin/perl -w
use List::MoreUtils qw/uniq/;
use List::Compare;


#This file is the cluster file - output of mcl clusters
open(mFILE,$ARGV[0]);
my @mfile=<mFILE>;

#This file is the list of training set complexes
open(bFILE,"/home/swapna/workspace/toxonet/toxo/weka/refsets_round2/starting_sets/training_set_clusters_ordered.csv");
#open(bFILE,"/home/swapna/workspace/toxonet/toxo/weka/refsets_round2/starting_sets/testing.csv");
my @bfile=<bFILE>;

	$ct=1;
foreach $mfile(@mfile)
{
	#print "$mfile";
	chomp($mfile);
	@cluster=split('\t',$mfile);
	$cluster_size=$#cluster + 1;

	if ($cluster_size >= 2)
	{
			@cluster_codes=();
		foreach $col(@cluster)
		{
			@a=split('_',$col);
			$code=join '_',$a[0],$a[1];
			push(@cluster_codes,$code);	
		}
		@sorted_cluster=uniq sort @cluster_codes;

			$top_cluster_match_name="NA";
			$top_cluster_num_common_elements=0;
			$top_cluster_match_bhscore=0;

		foreach $training(@bfile)
		{		
			chomp($training);
			#print ">>>\n$training\n";
			@fields=split('@',$training);
			@training_complex=split(',',$fields[1]);
			@sorted_training=uniq sort @training_complex;
			$complex_size=$#sorted_training + 1;

			#$lc=List::Compare->new(\@sorted_cluster,\@sorted_training);
			#@common=$lc->get_intersection;

			@common=();
			foreach $a(@sorted_cluster)
			{
				foreach $b(@sorted_training)
				{
					if ( "$a" eq "$b" )
					{
						push(@common,$a);
						last;
					}

				}
			}

			#Calculating Bader-Hogue score as: sqr(Num of common proteins between cluster and training_complex)   / (Total no proteins in cluster * Total no of proteins in training_complex)
			#print "~~~~\n";
			#print @sorted_cluster;
			#print "~~~~\n";
			#print @sorted_training;
			#print "###\n";
			#print @common;
			#print "~~~~\n";
			$num_common_elements=$#common + 1;
	
			$score_bh=($num_common_elements*$num_common_elements)/($cluster_size*$complex_size); 

			if ($score_bh >= $top_cluster_match_bhscore)
			{
				$top_cluster_match_name=$fields[0];
				$top_cluster_num_common_elements=$num_common_elements;
				$top_cluster_match_bhscore=$score_bh;
			}
		}
	
		print "$ct";
		print "@";
		print "$mfile";
		print "@";
		print  "$top_cluster_match_name";
		print "@";
		print "$top_cluster_num_common_elements";
		print "@";
		print "$top_cluster_match_bhscore\n";
	}

	$ct++;
}

exit();


#!/usr/bin/perl -w


open(CODES,$ARGV[0]);
@codes=<CODES>;

#Take first column

for($i=0;$i<=$#codes;$i++)
{
	@codes1=split(',',$codes[$i]);
	for($j=$i+1;$j<=$#codes;$j++)
	{
		@codes2=split(',',$codes[$j]);

		if($codes1[0] =~ /^TGME49/ && $codes2[0] =~ /^TGME49/)
		{
			@one=split('_',$codes1[0]);
			@two=split('_',$codes2[0]);
			print "$one[0]_$one[1]#$two[0]_$two[1]\n";
			#print "$codes1[0]#$codes2[0]\n";
		}
	}
}

#!/usr/bin/perl
use warnings;
use strict;

my $filename_1to1 = "Cor_1to1.ctb";
my $filename = "10254358.CTB";

open my $FILE, '<:raw', $filename or die;
binmode $FILE;


open my $FILE1TO1, '<:raw', $filename_1to1 or die;
binmode $FILE1TO1;


open my $FILEOUT, '>:raw', "result.ctb" or die;
binmode $FILEOUT;

my $data;
my $data_1to1;

my $cnt = 0;
my $cnt2 = 1;
my $bukva = "X";

printf("addr\t1to1\tfile\tdiffbits\tdiffmm\n");

while ((my $n = read $FILE, $data, 2) != 0) {
	my $n1 = read $FILE1TO1, $data_1to1, 2;
	my $hex = unpack 's*', $data; #makes string
	my $hex_1to1 = unpack 's*', $data_1to1; #makes string
	#my $uint16 = pack 'S', $data;
	my $diff = $hex_1to1-$hex;
	my $diffinmm = $diff/358;
	printf("%04x:\t%d\t%d\t%d\t%f\n", $cnt, $hex_1to1, $hex, $diff, $diffinmm);
	print $FILEOUT pack 's*', $hex-1;
	$cnt+=2;
	if ( ($cnt % 130) == 0 ) {
		print"== $bukva ========== ".$cnt2++."\n";
	}
	if ( ($cnt % 8450) == 0 ) {
                #print"## Y ########## ".$cnt2++."\n";
		$bukva = "Y";
        }
}

close($FILE1TO1);
close($FILEOUT);
close($FILE);

#!/usr/bin/perl
use warnings;
use strict;

my $filename_1to1 = "Cor_1to1.ctb";
#my $filename = "10254358.CTB";
my $filename = "50-1631-254-1.ctb";

open my $FILE, '<:raw', $filename or die;
binmode $FILE;


open my $FILE1TO1, '<:raw', $filename_1to1 or die;
binmode $FILE1TO1;


open my $FILEOUT, '>:raw', "result.ctb" or die;
binmode $FILEOUT;

my $data;
my $data_1to1;

my @arrX;
my @arrY;

my $cnt = 0;
my $cnt2 = 1;
my $bukva = "X";
my $nomer = 1;

my $y = 0;
my $x = 0;

printf("addr\tnum\t1to1\tfile\tdiffbits\tdiffmm\n");

while ((my $n = read $FILE, $data, 2) != 0) {
	my $n1 = read $FILE1TO1, $data_1to1, 2;
	my $hex = unpack 'S*', $data; #makes string
	my $hex_1to1 = unpack 'S*', $data_1to1; #makes string
	#my $uint16 = pack 'S', $data;
	my $diff = $hex_1to1-$hex;
	my $diffinmm = $diff/358;
	printf("%04x:\t%02d\t%d\t%d\t%d\t%f\n", $cnt, $nomer, $hex_1to1, $hex, $diff, $diffinmm);
	print $FILEOUT pack 's*', $hex; #the same as original

	if ($cnt < 8450) {
		$arrX[$y][$x] = $hex;
		#$arrX[$y][$x] = $hex_1to1;
		if ($x == 64) {	
			$y++;
			$x=0;
		} else {
			$x++;
		}
	} else {
		$arrY[$x][$y] = $hex;
		#$arrY[$x][$y] = $hex_1to1;
		if ($y == 64) {
			$x++;
			$y=0;
		} else {
			$y++;
		}
	}

	$cnt+=2;
	$nomer++;
	if ( ($cnt % 130) == 0 ) {
		print"== $bukva ========== ".$cnt2++."\n";
		$nomer = 1;
	}
	if ( ($cnt % 8450) == 0 ) {
                #print"## Y ########## ".$cnt2++."\n";
		$bukva = "Y";
		$cnt2 = 1;
		$y=0;
		$x=0;
        }
}
open my $F2, '>vgz.dat' or die;
	
	my $y1 = 0;

	for (my $y1=0; $y1<65;$y1++) {
		#print "X\t";
		for (my $x1=0;$x1<65;$x1++) {
			print $F2 $arrX[$y1][$x1]."\t".$arrY[$y1][$x1]."\n";
		}
		#print "\n";
	}
close($F2);
#	foreach my $row (@arrY) {
#		print "Y\t";
#		for (my $i=0;$i<65;$i++) {
#			print $row->[$i]."\t";
#		}
#		print "\n";
#	}


close($FILE1TO1);
close($FILEOUT);
close($FILE);

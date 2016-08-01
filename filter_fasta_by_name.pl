#!/usr/bin/perl
##################################################################
# 
# Author:
# Dimitar Kenanov - kenietz78@gmail.com
#
# Filters a fasta file by names(headers). Takes headers of the seqs
# to be kept and the Fasta to be filtered. Output filtered fasta.
#
##################################################################

use strict;
use warnings;
use Getopt::Long;

my ($opts, $HEADERS, $FAIN, $FAOUT);


$opts=GetOptions("h=s" => \$HEADERS, # headers text file
		 "fo=s" => \$FAOUT,  # fasta out
		 "fi=s" => \$FAIN    # fasta in
		 );

if((!$HEADERS && !$FAOUT && !$FAIN) || ! $HEADERS || !$FAOUT || !$FAIN){
	die "\n Usage: filter_fasta_by_name.pl -h HEADERS_TEXT_FILE -fo FAOUT -fi FAIN\n\n";
}

my ($fhi,$fho,@tmp);
my %headers;
# read HEADERS in hash
print "\n READING IN HEADERS\n";
open($fhi,'<',$HEADERS);

while(<$fhi>){
	chomp;
	$_=~s/^>//;
	$headers{$_}=1;
}

close $fhi;

# filtering the FASTA here
print "\n FILTERING FASTA WAIIIT..\n";
my ($strin,$strout);

open($fhi,'<',$FAIN);
open($fho,'>',$FAOUT);

local $/='>g';
(undef) = scalar <$fhi>;
while(my $seq=<$fhi>){
	chomp($seq);
	@tmp=split/\n/,$seq;
	$tmp[0]='g'.$tmp[0];
	if(exists $headers{$tmp[0]}){
		$seq='g'.$seq;
		print $fho ">$seq";
	}
}

print "\n DONE\n";
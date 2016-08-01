#!/usr/bin/perl
##################################################################
# 
# Author:
# Dimitar Kenanov - kenietz78@gmail.com
#
# Reads in file with headers and creates a Hash which is then
# stored in a file so can be loaded by the kaijuxReport.pl
#
##################################################################

use strict;
use warnings;
use Getopt::Long;
use Storable;

my ($opts, $HEADERST, $HEADERSH);


$opts=GetOptions("h=s" => \$HEADERST, # HEADERS TEXT FILE, input
		 "o=s" => \$HEADERSH    # HEADERS HASH FILE, output
		 );

if((!$HEADERST && !$HEADERSH) || ! $HEADERST || !$HEADERSH){
	die "\n Usage: create_HEADERS_HASH_FILE.pl -h HEADERS_TXT_FILE -o HEADERS_HASH_FILE\n\n";
}

my ($fhi,@tmp);
my (%HEAD,%REP);

# read HEADERS in hash 
print "\n READING IN HEADERS...\n";
my ($seqid,$seqdesc,$seqsp); # SEQ; ID, DESC, SPECIES
open($fhi,'<',$HEADERST);

while(<$fhi>){
	chomp;
	if($_ =~ /\|(\w{2}_\d+\.\d+)\|\s(.*?)\[(.*?)\]$/){
		$seqid=$1;
		$seqdesc=$2;
		$seqsp=$3;
		$seqdesc=~s/\s$//; 
		$seqsp=~s/[\[\]]//g;
	
#		print ":$seqid:$seqdesc:$seqsp:\n";
		$HEAD{$seqid}=[$seqdesc,$seqsp] if (!exists $HEAD{$seqid});
	}else{
		print STDERR "ERR:$_:\n";
	}
#	sleep(1);
}

close $fhi;

# STORIN the hash in a file
print "\n STORING THE HEADERS HASH IN: $HEADERSH\n";
store \%HEAD, $HEADERSH;

print "\n DONE\n";

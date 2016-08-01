#!/usr/bin/perl
##################################################################
# 
# Author:
# Dimitar Kenanov - kenietz78@gmail.com
# 
# Produce a KAIJUX REPORT
#
# INPUTS: 
#	1. KAIJUX output file
#	2. File with all sequence headers 
#
##################################################################

use strict;
use warnings;
use Getopt::Long;
use Storable;

my ($opts, $HEADERS, $KOUT);


$opts=GetOptions("h=s" => \$HEADERS, # HEADERS_HASH_FILE, input
		 "k=s" => \$KOUT     # KAIJUX OUTPUT, input
		 );

if((!$HEADERS && !$KOUT) || ! $HEADERS || !$KOUT){
	die "\n Usage: kaijuxReport.pl -h HEADERS_HASH_FILE -k KAIJUX_OUT > REPORT\n\n";
}

my ($fhi,@tmp,$sid,$sname,$spid);
my ($HEAD,%REP);

# read HEADERS in hash and store it in a file
print STDERR "\n READING IN HEADERS...\n";
$HEAD=retrieve($HEADERS);

# read KAIJUX in hash
print STDERR "\n CREATING KAIJUX REPORT...\n";
my ($clsfd,$uclsfd,$totr);
$clsfd=$uclsfd=0;

open($fhi,'<',$KOUT);

while(<$fhi>){
	chomp;
	if($_ =~ /^U\t/){
		$uclsfd++;
		next;
	}elsif($_ =~ /^C\t/){
		$clsfd++;
		@tmp=split/\t/,$_;
		for my $i(@tmp){
			if ($i =~ /^gi\|/){
				$i=~s/,$//;
				my @stmp=split/,/,$i;
			
				for my $s(@stmp){
					$s=~/\|(\w{2}_\d+\.\d+)\|/;
					$sid=$1;
					if(!exists $REP{$sid}){
						$REP{$sid}=[1,@{$$HEAD{$sid}}];
					}elsif(exists $REP{$sid}){
						$REP{$sid}[0]++;
					}
				}
			}
		}
		
	}
}

close $fhi;

# print stat
$totr=$uclsfd+$clsfd;

for my $k(keys %REP){
	my $perc=$REP{$k}[0]/$totr;
	push @{$REP{$k}},sprintf("%.2f",$perc);
}

print join("\t",'%','reads','id','desc','species'),"\n";
print "-------------------------------------------------------\n";

for my $k(reverse sort {$REP{$a}[0] <=> $REP{$b}[0]} keys %REP){
	print join("\t",@{$REP{$k}}[3,0],$k,@{$REP{$k}}[1,2]),"\n";
}

print "-------------------------------------------------------\n";
print "\nDET:S: ",scalar(keys %REP)," :\n"; # Detected seqs
print "TOT:R: $totr :\n";		    # Total Num Read/Contigs
print "TOT:C: $clsfd :\n";		    # Total Num Classifiled Reads/Contigs
print "TOT:U: $uclsfd :\n";		    # Total Num Unclassified Reads/Contigs
print STDERR "\n DONE\n";




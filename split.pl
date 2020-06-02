#!/usr/bin/perl-w
use strict;
use warnings;


my %hash =();
my $key = '';
open F, "pae981_v11_CDS.fasta", or die $!;
while(<F>){
    chomp;
    if($_ =~ /^(>.+)/){
        $key = $1;
    }else{
       push @{$hash{$key}}, $_ ;
    }   
}

foreach(keys %hash){
    my $key1 = $_;
    my $key2 ='';
    if($key1 =~ /^>(.+)/){
        $key2 = $1;
    }
    open MYOUTPUT, ">","$key2.fa", or die $!;
    print MYOUTPUT join("\n",$_,@{$hash{$_}}),"\n";
    close MYOUTPUT;
}

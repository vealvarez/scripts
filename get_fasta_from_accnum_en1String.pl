#!usr/bin/perl -w
#Apartir de un archivo con accession number genera un archivo fasta DONDE LA SECUENCIA ES UN SOLO STRING (no se corta con $ cada linea)
use Bio::Perl;
use Bio::SeqIO;
use strict;
use warnings;


 # my $seq_object = get_sequence('genbank',"AB759690");
 # print "Sequence name is ",$seq_object->display_id,"\n";
 # print "Sequence acc  is ",$seq_object->accession_number,"\n";
 # print "First 5 bases is ",$seq_object->subseq(1,5),"\n";
 # print OUTPUT ">",$seq_object->display_id,"\n";
 # print OUTPUT $seq_object->seq(),"\n";

 #open(INPUTFILE,"accnumber.txt");
 open(INPUTFILE,"an1");
 open(OUTPUT,">salidaFASTA");

 while (my $line = <INPUTFILE>)
 {
    my $seq_object = get_sequence('genbank',$line);
    print OUTPUT ">",$seq_object->display_id,"\n";
    print OUTPUT $seq_object->seq(),"\n"; 
 }

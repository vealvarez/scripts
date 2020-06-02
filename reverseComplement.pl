#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;

my $secuenciaOK = "";

my $seqin = Bio::SeqIO->new( -format => 'Fasta', -file => 'intI1TodasLasSeqs.fasta');
my $seqout= Bio::SeqIO->new( -format => 'Fasta', -file => '>intI1TodasLasSeqsOK.fasta');

while((my $seqobj = $seqin->next_seq())) 
{
   my $substring = $seqobj->subseq(1,3);

   if ($substring eq "CTA")
   {   
      $secuenciaOK = $seqobj->revcom;
   }
   else
   {
      $secuenciaOK = $seqobj;
   }
  
   $seqout->write_seq($secuenciaOK);
}


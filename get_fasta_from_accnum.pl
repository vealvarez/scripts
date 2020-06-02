#!usr/bin/perl -w
#Apartir de un archivo con accession number genera un archivo fasta con las secuencias
use strict;
use warnings;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Bio::SeqIO;

     open(INPUTFILE,"accnumberAnalizadasAlelos.txt");
     open(OUTPUTFILE,">seqs.fasta");

     while (my $line = <INPUTFILE>)
     {
       my $query = $line;
       my $query_obj = Bio::DB::Query::GenBank->new(-db => 'nucleotide', -query => $query);
       my $gb_obj = Bio::DB::GenBank->new(-format => 'fasta');
       my $stream_obj = $gb_obj->get_Stream_by_query($query_obj);
       my $seq_out = Bio::SeqIO->new(-file => ">>seqs.fasta", -format => 'fasta');
       my $archtest = Bio::SeqIO->new(-file => ">>test.fasta", -format => 'fasta');
       my $concat = Bio::Seq->new();

       while (my $seq_obj = $stream_obj->next_seq) 
       {
         #$seq_out->write_seq($seq_obj);

         print OUTPUTFILE ">",$seq_obj->display_id,"\n";
         print OUTPUTFILE $seq_obj->seq(),"\n";
         #$concat = $concat . $seq_obj; 
         #$archtest->write_seq($concat);
        
       }
    }
   
    #open(INPUTFILE,"accnumber.txt");
    #open(OUTPUTFILE,">>seqs.fasta");
    #my $db = Bio::DB::GenBank->new();

    #while (my $line = <INPUTFILE>)
    #{
    #  my $seqobj = $db->get_Seq_by_acc($line);
    #  print OUTPUTFILE ">".$line;
    #  print OUTPUTFILE $seqobj->sec();
    #}
    #close INPUTFILE;
    #close OUTPUTFILE;

   

   # print "forma 2:";
   # also don't want features, just sequence so let's save bandwith
    # and request Fasta sequence
   # my $gb = Bio::DB::GenBank->new(-retrievaltype => 'tempfile' , 
   # 			                      -format => 'Fasta');
   # my $seqio = $gb->get_Stream_by_acc(['AC013798'] );
   # while( my $clone =  $seqio->next_seq ) {
   #   print "cloneid is ", $clone->display_id, " ", 
   #          $clone->accession_number, "\n",
   #          $clone->sec(), "\n";
   # }
    # note that get_Stream_by_version is not implemented
  


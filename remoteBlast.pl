#EJECUTA UN BLAST REMOTO Y FILTRA LOS RESULTADOS SEGUN LO ESPECIFICADO EN QUERY COVER E IDENTIDAD
#DEVUELVE EL ARCHIVO ORIGINAL CON EL RESULTADO DEL BLAST HECHO, UN ARCHIVO CON EL RESUMEN DE LOS DATOS
# UN ARCHIVO PLANO CON ESTOS DATOS, y UN ARCHIVO GENBANK CON LOS DATOS DE CADA UNA DE LAS SECUENCIAS
#INPUT: ARCHIVO FASTA CON LA SECUENCIA QUERY
#!/usr/bin/perl -w
  use strict;
  use Bio::Tools::Run::RemoteBlast;
  use Bio::Search::Hit::Fasta;
  use Bio::DB::GenBank;
  use Bio::SeqIO;

  my $infile = shift or die "sintaxis: perl remoteBlast.pl sequenceFile.fasta\n";
  #my $prog = 'blastx';
  my $prog = 'blastn';
  #my $db   = 'swissprot';
  my $db   = 'nr';
  #my $e_val= '0';

  #my @params = ( '-prog' => $prog,
  #       '-data' => $db,
  #       '-expect' => $e_val);
  #       '-readmethod' => 'SearchIO' );

  my @params = ( '-prog' => $prog,
         '-data' => $db);

  my $factory = Bio::Tools::Run::RemoteBlast->new(@params);

  #change a paramter
  $Bio::Tools::Run::RemoteBlast::HEADER{'ALIGNMENTS'} = '20000';
  $Bio::Tools::Run::RemoteBlast::RETRIEVALHEADER{'ALIGNMENTS'} = '20000';
  #$Bio::Tools::Run::RemoteBlast::HEADER{'ENTREZ_QUERY'} = 'Homo sapiens [ORGN]';
  #$Bio::Tools::Run::RemoteBlast::HEADER{'ALIGNMENT_VIEW'} = 'FlatQueryAnchored'; 
  $Bio::Tools::Run::RemoteBlast::HEADER{'HITLIST_SIZE'} = '20000'; 

  #remove a parameter
  #delete $Bio::Tools::Run::RemoteBlast::HEADER{'FILTER'};

  my $v = 1;
  #$v is just to turn on and off the messages
  my $coverage_cutoff = 1.00;
  my $identity_cutoff = 1.00;
  my $linea = 1;

  
  #my $str = Bio::SeqIO->new(-file=>'amino.fa' , '-format' => 'fasta' );
  #my $str = Bio::SeqIO->new(-file=>$infile , '-format' => 'fasta' );

  #while (my $input = $str->next_seq()){
    #Blast a sequence against a database:

    #Alternatively, you could  pass in a file with many
    #sequences rather than loop through sequence one at a time
    #Remove the loop starting 'while (my $input = $str->next_seq())'
    #and swap the two lines below for an example of that.
    #my $r = $factory->submit_blast($input);
  my $r = $factory->submit_blast($infile);

  if( $v > 0 )
  {
    print STDERR "Searching hits...";
  }

  while ( my @rids = $factory->each_rid ) 
  {
      foreach my $rid ( @rids ) 
      {
        my $rc = $factory->retrieve_blast($rid);
        if( !ref($rc) ) 
        {
          if( $rc < 0 ) 
          {
            $factory->remove_rid($rid);
          }
          #print SALIDA STDERR "." if ( $v > 0 );
          if( $v > 0 )
          {
            print STDERR ".";
          }
          sleep 5;
        } 
        else 
        {
          my $result = $rc->next_result();
          #save the output
          #my $filename = $result->query_name()."\.out";
          my $filename = $infile."\.out";
          $factory->save_output($filename);
          $factory->remove_rid($rid);

          my $query_name = $result->query_name();
          open(SALIDA,">resultBLAST.txt");
          open(SALIDA2,">resultBLASTplano.txt");
          open(SALIDA3,">prueba.txt");
          #open(FASTA,">$query_name.fasta");
          #Objeto GenBank para buscar secuencias en la base
          my $gb = Bio::DB::GenBank->new( -retrievaltype => 'tempfile', -format => 'fasta' );
          my $salidaFASTA = new Bio::SeqIO( -file => ">resultado_query_GB.fas", -format => "fasta" );
          my $seqio; #para buscar fasta de secuencia

          print SALIDA "\nQuery Name: ", $result->query_name(), "\n";
          print SALIDA "\n";
          while ( my $hit = $result->next_hit ) 
          {
            ##next unless ( $v > 0);
            my $evalue = $hit->significance();
            my $identity = $hit->frac_identical('query');
            my $identity_hit = $hit->frac_identical('hit');

            ######Get amount of coverage for query and hit #######
            my $query_coverage = $hit->frac_aligned_query();
            my $hit_coverage = $hit->frac_aligned_hit();
            print SALIDA3 "AN: ",$hit->name,";QRY COV:",$query_coverage,";DENTITY:",$identity";IDE HIT:",$identity_hit;

            ###Filter based on evalue and coverage
            if ( ( $query_coverage >= $coverage_cutoff ) && ($identity >= $identity_cutoff))
            { 
              print SALIDA2 $linea,";",$hit->name,";",$hit_coverage,";",$query_coverage,";",$identity,";",$identity_hit,"\n";
              print SALIDA $linea ,"-","\n";
              print SALIDA "Accession Number:  ", $hit->name, "\n";
              print SALIDA "Name:  ", $hit->description, "\n";
              print SALIDA "Hit coverage (sobre la secuencia entera que se encontro en la base):", $hit_coverage,"\n";
              print SALIDA "Qry coverage (sobre el hit encontrado):", $query_coverage,"\n";
              print SALIDA "E-value:", $evalue,"\n";
              print SALIDA "Identity:", $identity,"\n";
              print SALIDA "\n";
              $linea++;
              $seqio = $gb->get_Stream_by_id( $hit->name );
              while ( my $clone = $seqio->next_seq )
              {
                  $salidaFASTA->write_seq($clone);
              }


              #print SALIDA "lenght: ", $hit->length, "\n";

              #print SALIDA "algorithm: ", $hit->algorithm(), "\n";

              #print SALIDA "raw_score: ", $hit->raw_score(),"\n";

              #print SALIDA "significance: ", $hit->significance(),"\n";

              #print SALIDA "rank: ",  $hit->rank(),"\n"; # the Nth hit for a specific query

              #while( my $hsp = $hit->next_hsp ) 
              #{

                #print SALIDA "pvalue: ", $hsp->pvalue(), "\n";

                #print SALIDA "evalue: ", $hsp->evalue(),"\n";

                #print SALIDA "frac identical:", $hsp->frac_identical( ['query'|'hit'|'total'] ),"\n";

                #print SALIDA "frac conserved:", $hsp->frac_conserved( ['query'|'hit'|'total'] ),"\n";

                #print SALIDA "gaps: ",$hsp->gaps( ['query'|'hit'|'total'] ),"\n";

                #print SALIDA "query string: ",$hsp->query_string,"\n";

                #print SALIDA "hit string: ",$hsp->hit_string,"\n";

                #print SALIDA "homology string: ", $hsp->homology_string,"\n";

                #print SALIDA "length: ", $hsp->length( ['query'|'hit'|'total'] ),"\n";

                #print SALIDA "rank: ", $hsp->rank,"\n";
              #}
            }
          }
        close(SALIDA);
        }
     }
  }

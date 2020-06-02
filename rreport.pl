use strict;
use Bio::SearchIO; 

my $archin = $ARGV[0];
open(ARCHSAL,">>matchs.out");
open(ARCHPLANO,">>matchs_plano.txt");

print ARCHPLANO "QUERY,SUBJECT,QRY LENGTH,SUBJECT LENGTH,SUBJECT BEGIN,SUBJECT END,QRY COVER,% IDENT,MATCH LENGTH,NUM IDENTICAL,NUM CONSERVED,GAPS,E-VALUE \n";

my $in = new Bio::SearchIO(-format => 'blast', 
                           -file   => $archin);
while( my $result = $in->next_result ) {
  ## $result is a Bio::Search::Result::ResultI compliant object
  while( my $hit = $result->next_hit ) {
    ## $hit is a Bio::Search::Hit::HitI compliant object
    while( my $hsp = $hit->next_hsp ) {
      ## $hsp is a Bio::Search::HSP::HSPI compliant object
      #if( $hsp->length('total') > 90 ) {
       # if ( $hsp->percent_identity >= 90 ) {
          print ARCHSAL "Query=",   $result->query_name,
            " Subject=",        $hit->name,
            #" Description=", $hit->description,
            " Query_Length=",     $result->query_length(),
            #" Subject_Length=",   $hsp->length('query'),
            " Subject_Length=",   $hit->length,
            " Qry_cover=", 100 * $hit->frac_aligned_query(), 
            " %_identity=", $hsp->percent_identity,
            " Match_Length=",     $hsp->length('hit'),
            " Num_identical=", $hsp->num_identical,
            " Num_conserved=", $hsp->num_conserved, 
            " Gaps=",     $hsp->gaps('hit'),
            " E-value=",    $hsp->evalue,"\n";

          print ARCHPLANO  $result->query_name,";",
                   $hit->name,";",
                 $result->query_length(),";",
               $hit->length,";",
               $hsp->start,";",
               $hsp->end,";",
            $hit->frac_aligned_query() * 100, ";",
            $hsp->percent_identity,";",
                $hsp->length('hit'),";",
             $hsp->num_identical,";",
             $hsp->num_conserved, ";",
                $hsp->gaps('hit'),";",
               $hsp->evalue,"\n";
       # }
     # }
    }  
  }
}
close(ARCHSAL);
close(ARCHPLANO);

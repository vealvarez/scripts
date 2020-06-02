#DADO UN ARCHIVO CON NUMEROS DE ACCESSION NUMBERS BUSCA EN LA
#BASE DE GENBANK Y DEVUELVE UN ARCHIVO .GB CON LA ENTRADA ENCONTRADA
#DE CADA UNO DE ELLOS
#ESTA VERSION NO USA UN VECTOR DE NUMEROS DE ACCESO COMO PARAMETRO DE GET_STREAM_BY_ID SINO QUE LEE DE A UNA LAS LINEAS
#DEL ARCHIVO DE NUMEROS DE ACCESO (INPUT)
#!/usr/bin/perl -w
use strict;
#use warnings;
use Bio::DB::GenBank;
use Bio::SeqIO;

sub parseaGB
{

#my $infile = shift or die "sintaxis: perl parserGB.pl archivo.gb \n";
my $infile = $_[0];
my $accessionNum = $infile;
my $seqio_object = Bio::SeqIO->new(-file => $infile);       
my $seq_obj = $seqio_object->next_seq;
my $aislamiento = "";
my $huesped = "";
my $country = "";
my $plasmid = "";

print ARCHSAL "Secuencia: ",$infile, "\n";

#Descripcion de la secuencia
print ARCHSAL "Definition: ", $seq_obj->desc(), "\n";
#if ((uc($seq_obj->desc()) !~ /INTEGRON/) && (uc($seq_obj->desc()) !~ /RESISTANCE/))
#{
  #EXTRACCION DE ANOTACIONES
  my $anno_collection = $seq_obj->annotation;
  for my $key ( $anno_collection->get_all_annotation_keys ) 
  {
    my @annotations = $anno_collection->get_Annotations($key);
    for my $value ( @annotations ) 
    {
      #print "value tagname:", $value->tagname, "\n";
      #if ($value->tagname eq "accession") {         
      if ($value->tagname eq "journal") {         
        print "accession: ",$value->journal(), "\n";       
      }
      #if ($value->tagname eq "reference") 
      #{         
        #if ((uc($value->title()) !~ /INTEGRON/) && (uc($value->title()) !~ /RESISTANCE/))
        #{
      #    print ARCHSAL "title: ",$value->title(), "\n";       
        #}
      #}
    }
  }

  #EXTRACCION DE FEATURES

  for my $feat_object ($seq_obj->get_SeqFeatures) 
  {          
    #print "primary tag: ", $feat_object->primary_tag, "\n";          
    if ($feat_object->primary_tag eq "source") 
    {
      for my $tag ($feat_object->get_all_tags) 
      {             
        #print "  tag: ", $tag, "\n";             
        for my $value ($feat_object->get_tag_values($tag)) 
        {                
          #print ARCHSAL $tag, ":", $value, "\n";             
          #if ($tag eq "organism")
          if ($tag eq "isolation_source")
          {
            #print ARCHSAL $tag, ":", $value, "\n";
            $aislamiento = $value;
          }

          if ($tag eq "host")
          {
            #print ARCHSAL $tag, ":", $value, "\n";
             $huesped = $value;
          }       

          #if ($tag eq "country")
          #{
          #  #print ARCHSAL $tag, ":", $value, "\n";
          #   $country = $value;
          #}       

          #if ($tag eq "plasmid")
          #{
          #  #print ARCHSAL $tag, ":", $value, "\n";
          #   $plasmid = $value;
          #}       
        } 
     }
     print ARCHSALplano $accessionNum, ":", $aislamiento, ":", $huesped, ":", $country,":", $plasmid, "\n";
    }
   }
print ARCHSAL "\n";

} #FIN DE LA FUNCION PARSEAGB

#INICIO DEL MAIN
my $infile = shift or die "sintaxis: perl generaYprocesaGB.pl archivoConAccessionNumbers \n";

open(ARCHACCNUM,$infile);
open(LOG,">ANprocesados.log");
open(ARCHSAL,">>ReporteGB.txt");
open(ARCHSALplano,">>ReporteGBPLANO.txt");

my $i = 0;

while (my $lineaAN = <ARCHACCNUM>)
{
   $i++;
   print LOG $i,"\n";
   my $gb = new Bio::DB::GenBank(-retrievaltype => 'tempfile' , -format => 'gb');
   #Busco la informacion de cada Accession Number en GenBank y genero un archivo .gb
   my $seqio_object = $gb->get_Stream_by_id($lineaAN);
   my $i = 0;
   while( my $seq = $seqio_object->next_seq ) {
     my $ext = '.gb';
     chomp $lineaAN;
     my $nombreArch = $lineaAN . $ext; 
     $i++;
     #Creo archivo GB correspondiente al numero de acceso
     my $salidaGB = new Bio::SeqIO(-file => ">$nombreArch", -format => 'genbank');
     $salidaGB->write_seq($seq);

     #Llamo a la funcion que parsea el archivo 
     parseaGB($nombreArch);

     $nombreArch = "";
   }
}

close(ARCHACCNUM);
close(LOG);
close ARCHSAL;
close ARCHSALplano;

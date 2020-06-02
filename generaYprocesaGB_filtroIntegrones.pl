#DADO UN ARCHIVO CON NUMEROS DE ACCESSION NUMBERS BUSCA EN LA
#BASE DE GENBANK Y DEVUELVE UN ARCHIVO .GB CON LA ENTRADA ENCONTRADA
#DE CADA UNO DE ELLOS
#ESTA VERSION NO USA UN VECTOR DE NUMEROS DE ACCESO COMO PARAMETRO DE GET_STREAM_BY_ID SINO QUE LEE DE A UNA LAS LINEAS
#DEL ARCHIVO DE NUMEROS DE ACCESO (INPUT)
#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::DB::GenBank;
use Bio::SeqIO;

sub parseaGB
{
#ESTA FUNCION PARSEA EL ARCHIVO GENBANK Y BUSCA ENTRE LAS ANOTACIONES Y LOS FEATURES
#CARACTERISTICAS DEFINIDAS POR EL USUARIO, POR EJEMPLO QUE EN EL NOMBRE DE LA SECUENCIA
#NO APAREZCA LA PALABRA "RESISTANCE"

   #my $infile = shift or die "sintaxis: perl parserGB.pl archivo.gb \n";
   my $infile = $_[0];
   my $seqio_object = Bio::SeqIO->new(-file => $infile);
   my $seq_obj = $seqio_object->next_seq;
   open(ARCHSAL,">>ReporteGB.txt");
   open(ARCHSAL2,">>ANFiltrados.txt");

   print ARCHSAL "Secuencia: ",$infile, "\n";
   my $imprimo = 0;

   #Descripcion de la secuencia
   #print ARCHSAL "Definition: ", $seq_obj->desc(), "\n";
   #if ((uc($seq_obj->desc()) !~ /INTEGRON/) && (uc($seq_obj->desc()) !~ /RESISTANCE/))
   #{
     #print ARCHSAL "Definition: ", $seq_obj->desc(), "\n";
     #EXTRACCION DE ANOTACIONES
     my $anno_collection = $seq_obj->annotation;
     for my $key ( $anno_collection->get_all_annotation_keys )
     {
       my @annotations = $anno_collection->get_Annotations($key);
       for my $value ( @annotations )
       {
         #print "value tagname:", $value->tagname, "\n";
         #if ($value->tagname eq "accession") {
         #  print "accession: ",$value->accession_number(), "\n";
         #}
         if ($value->tagname eq "reference")
         {
           if ((uc($value->title()) !~ /INTEGRON/) && (uc($value->title()) !~ /RESISTANCE/))
           {
             print ARCHSAL "title: ",$value->title(), "\n";
             $imprimo = 1;

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
                       if ($tag eq "organism")
                       {
                         print ARCHSAL $tag, ":", $value, "\n";
                       }
                     }
                   }
                }
              }
            }
          }
        }
      }
    #}
   #Imprimo el numero de acceso
   if ($imprimo == 1)
   {
     print ARCHSAL2 $infile, "\n";
   }
   close ARCHSAL2;
   print ARCHSAL "\n";
   close ARCHSAL;
} #FIN DE LA FUNCION PARSEAGB

#INICIO DEL MAIN
my $infile = shift or die "sintaxis: perl generaYprocesaGB.pl archivoConAccessionNumbers \n";

#Guardo el contenido del archivo en un vector para que lo lea get_Steam_by_id
#my $archAlelos = "ANAlelos.txt";
#my $archEntrada = $infile;
#open my $handle, '<', $archEntrada;
#chomp(my @ACCNUMS = <$handle>);
#close $handle;

open(ARCHACCNUM,$infile);
open(LOG,">ANprocesados.log");

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

     #Llamo a la funcion que parsea el archivo y busca palabras claves que definen si la
     #secuencia puede ser util, hace un filtro de los resultados obtenidos por blast
     parseaGB($nombreArch);

     $nombreArch = "";
   }
}

close(ARCHACCNUM);
close(LOG);

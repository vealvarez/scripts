#DADO UN ARCHIVO CON NUMEROS DE ACCESSION NUMBERS BUSCA EN LA
#BASE DE GENBANK Y DEVUELVE UN ARCHIVO .GB CON LA ENTRADA ENCONTRADA DE CADA UNO DE ELLOS
#ESTA VERSION NO USA UN VECTOR DE NUMEROS DE ACCESO COMO PARAMETRO DE GET_STREAM_BY_ID SINO QUE LEE DE A UNA LAS LINEAS
#DEL ARCHIVO DE NUMEROS DE ACCESO (INPUT)
#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::DB::GenBank;
use Bio::SeqIO;

my $infile = shift or die "sintaxis: perl getGB.pl archivoConAccessionNumbers \n";

#Guardo el contenido del archivo en un vector para que lo lea get_Steam_by_id
#my $archAlelos = "ANAlelos.txt";
#my $archEntrada = $infile;
#open my $handle, '<', $archEntrada;
#chomp(my @ACCNUMS = <$handle>);
#close $handle;

open(ARCHACCNUM,$infile);

while (my $lineaAN = <ARCHACCNUM>)
{
   my $gb = new Bio::DB::GenBank(-retrievaltype => 'tempfile' , -format => 'gb');
   #Busco la informacion de cada Accession Number en GenBank y genero un archivo .gb
   my $seqio_object = $gb->get_Stream_by_id($lineaAN);
   my $i = 0;
   while( my $seq = $seqio_object->next_seq ) {
    my $ext = '.gb';
    chomp $lineaAN;
    my $nombreArch = $lineaAN . $ext; 
    #print $nombreArch;
    $i++;
    #print $nombreArch;
    #open(ARCHSAL, ">$nombreArch");
    my $salidaGB = new Bio::SeqIO(-file => ">$nombreArch", -format => 'genbank');
    $salidaGB->write_seq($seq);
    #print ARCHSAL $seq;
    #print $seq->display_id;
    #close ARCHSAL;
    $nombreArch = "";
   }
}

close(ARCHACCNUM);

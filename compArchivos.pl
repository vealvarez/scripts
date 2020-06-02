use strict;
use warnings;
use Bio::Perl;


     #Dados dos archivos, uno de genomas y otro con el listado de las subsecuencias 
     #a generar (ACCNUM,desde,hasta) genera un archivo de subsecuencias

     open(RANGOS,"longSeqs.txt");
     open(SALIDA,">salida.txt");
     open(SALIDAT,">salidaTest.txt");

     my $desde="";
     my $hasta="";
     my @valores=""; 
     my $id="";

     while (my $lineaR = <RANGOS>)
     {
	@valores = split(',', $lineaR);
        $id = $valores[0];
        $desde = $valores[1];
        chomp($valores[2]);
        $hasta = $valores[2];
        my $offset = $hasta - $desde;
        my $idG;
        #print SALIDA "id ",$id,":","desde ",$desde,":","hasta ",$hasta,":","offset ",$offset,"\n"; 

        open(GENOMAS,"seqsAnalizadasIDcorto.fasta");
        #open(GENOMAS,"pp.txt");
        my $encontrado = 0;
        while ((my $lineaG = <GENOMAS>) and (not $encontrado))
        {
           my $car = substr $lineaG,0,1;
           #print SALIDAT $car,"\n";
           if ($car eq ">")
           {
              my $cuantos = length($lineaG) - 1;
              $idG = substr  $lineaG,1,$cuantos;
              #print SALIDAT "id:",$id,"idG:",$idG;
              print SALIDAT "es > \n";
              #$lineaG = <GENOMAS>;
           }
           else
           {
              #print SALIDAT " no es > \n";
              print SALIDAT "id:",$id,"idG:",$idG;
              chomp($idG);
              chomp($id);
              if ($idG eq $id)
              {
                #print SALIDAT "id:",$id,"idG:",$idG,"\n";
                $encontrado = 1;
                my $offset = $hasta - $desde + 1;
                my $lineaSalida = substr $lineaG,$desde,$offset;
                print SALIDA ">",$id,"\n";
                print SALIDA $lineaSalida,"\n"; 
              }
              #print SALIDA "id ",$id,":","desde ",$desde,":","hasta ",$hasta,":","offset ",$offset,"\n"; 
           }
         }  
         close(GENOMAS);
      }
     close(RANGOS);
     close(SALIDA);
     close(SALIDAT);

ARCHNOMBRES="attCs_con_nombres.txt"
ARCHFASTA="seqsAttcsRecortadas.fasta"

awk -vANOM=$ARCHNOMBRES '
BEGIN{
  FS="\t"
  OFS=" "
  
  while (getline < ANOM > 0 )
  {
    if ($3 > $4)
    {
      begin=$4
      end=$3
    }
    else
    {
      begin=$3
      end=$4
    }

    NOMBRES[$1":"begin":"end]=$2
  }

  for (i in NOMBRES)
    print i ":" NOMBRES[i] > "nombres"

}
{
  #>AP000342  FRAGMENT 13481:13534
  if (substr($0,1,1) == ">")
  {
    split($0,DESCRIP," ")
    gsub(/>/,"",DESCRIP[1])
    an = DESCRIP[1]
    
    split (DESCRIP[3],LOCUS,":")
    desde = LOCUS[1]
    hasta = LOCUS[2]

    #print an > "an"

    if (an":"desde":"hasta in NOMBRES)
    {
      #split(NOMBRES[an],DATOATCC,":")
      #desdeAttc = DATOATCC[1]
      #hastaAttc = DATOATCC[2]

      #print "desdeAtcc",desdeAttc,"hastaAttc",hastaAttc,"desdeFasta",desde,"hastaFasta",hasta > "test"
      
      
      #if ((desdeAttc == desde) && (hastaAttc == hasta))
      #{
         nombreAtcc = NOMBRES[an":"desde":"hasta] 
         #print "imprime"
         print ">"an, desde":"hasta, nombreAtcc > "seqsAttcsRecortadas_nombre.fasta"            
      #}

    }

  }
  else
  {
    print $0 > "seqsAttcsRecortadas_nombre.fasta"            
  }
 

}' "$ARCHFASTA" 

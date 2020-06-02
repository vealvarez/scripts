
    #Este AWK genera un archivo con ACC NUM y longitud de la subsecuencia
    #que se quiere extraer a partir del archivo HitTable que se bajo
    #de GenBank donde estan las posiciones de alineamiento entre query y subject
    #Toma el begin y end para cortar la subsecuencia segun el campo begin y end del subject
    #de esta tabla.
    #Luego, para poder usar el script de Python se necesita que el archivo fasta de los genomas
    #solo tenga el ACC NUM y la secuencia entonces se genera un archivo con este formato
    #Finalmente en el shell script se invoca al script de Python.
    #PROBLEMA: SI UN ACC NUM APARECE DOS VECES CON RANGOS DIFERENTES SE TOMA UNO SOLO !!!


#ESTA PARTE SIRVE SI USO EL ARCHIVO HITTABLE DE GENBANK PARA OBTENER
#LOS DESDE Y HASTA DE LAS SUBSECUENCIAS
#Y EN EL CUERPO DEL AWK SE GENERA EL ARCHIVO FASTA CON LOS AN SIN DESCRIPCION

awk -vARCHIN="HitTable.txt" '
BEGIN{
  FS=OFS=","

#  while ( (getline < ARCHIN) > 0)
#  {  
#    IDHits = $2
#    #longALN = $4
#    qryStart = $7
#    qryEnd = $8
#    sbjtStart = $9 + 0
#    sbjtEnd = $10 + 0
#    identidad = $3 + 0
#
#    if (sbjtStart > sbjtEnd)
#    {
#      start = sbjtEnd
#      end = sbjtStart + 1
#    }
#    else
#    {
#      start = sbjtStart
#      end = sbjtEnd + 1
#    }
#
#    #if (qryStart == 1 && qryEnd == 1014 && identidad > 80)
#    #if (qryStart == 1 && qryEnd == 1014 && identidad > 80)
#    #{
#      #formato:gb|AF313471.1|:203-1216,gi|767032702|gb|KM204147.1|,100.00,1014,0,0,1,1014,8035,7022,0.0,1829
#      split(IDHits,HITS,";")
#
#      #tomo solo el primer accession number (no gi)
#      IDS = HITS[1]
#      split(IDS,ACCESSION,"|")
#
#      #le quito la version (.1 por ejemplo)
#      split(ACCESSION[4],ACC,".")
#      AN = ACC[1] #Accession Number de la secuencia
#   
#      #LONGS[AN]=start"\t"end
#      #print AN,sbjtStart,sbjtEnd > "longSeqs.txt"
#      print AN "\t" start "\t" end > "longSeqs.txt"
#    #}
#  }
}
{
    #ESTA PARTE GENERA EL ARCHIVO FASTA SOLO CON LOS IDS(ACC. NUMBER) PARA PODER
    #USAR EL PROGRAMA PYTHON QUE GENERA LAS SUBSECUENCIAS

    #formato: >AP000342.1 Shigella flexneri 2b plasmid R100 DNA, complete sequence
    if (substr($0,1,1) == ">")
     {
       #split($0,REG,"|")
       split($0,REG," ")
       #split(REG[4],ACC,".")
       split(REG[1],ACC,".")
       id = ACC[1]
       #nombre=REG[4] REG[5]
       print  id > "seqsAttCsIdCorto.fasta"
     }
     else
     {
       print $0 > "seqsAttCsIdCorto.fasta"
       #print id > "id"
       #longitudes = LONGS[id] + 1
       #print longitudes > "l.txt"
       #split(longitudes,VALORES,":")
       #desde = VALORES[1]
       #hasta = VALORES[2]
       #subseq = substr($0,desde,hasta - desde + 1)
       #print ">" nombre "\n" > "subsecuencias.fasta"
       #print subseq > "subsecuencias.fasta"

     }
}' "attCs.fasta"
#ESTA PARTE SIRVE SI YA SE TIENE UN ARCHIVO CON LOS DESDE Y HASTA 
#DE LAS SUBSECUENCIAS:
#Separa en archivos diferentes los AN que se repiten en el
#archivo de longitudes porque el programa que hace los substrings
#no funciona con AN duplicados

ARCHIN="LongsAttCs"
sort "$ARCHIN" > "$ARCHIN".sort

awk '
BEGIN{
  FS=OFS="\t"
}
{
   split($0,LINEA,"\t")
   anAttC=LINEA[1]

   if (anAttC in AN)
   {
      AN[anAttC] = AN[anAttC] + 1
      print $0 > "LongsAttCs."AN[anAttC]
   }
   else
   {
     AN[anAttC] = 1
     print $0 > "LongsAttCs."AN[anAttC]
   }
} ' "$ARCHIN".sort


#dados dos archivos, uno de genomas y otro con el listado de las subsecuencias 
#a generar (ACCNUM,desde,hasta) genera un archivo de subsecuencias

for i in `ls LongsAttCs.[0-9]*` 
do
   count=`expr $count + 1`
   python seqs_subgroup_extr_012.py seqsAttCsIdCorto.fasta "seqsAttcsRecortadas.$count" "$i" RANGE
done

#agrupa todos los resultados en uno
cat seqsAttcsRecortadas.[0-9]* > seqsAttcsRecortadas.fasta

#les inserta el nombre del cassette al archivo fasta, para ello, se debe contar con un archivo 
#que contenga los locus y los nombres de cada uno

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

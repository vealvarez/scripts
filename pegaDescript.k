IN="an_y_nombreSeq_resu.txt"

awk -vARCHIN=$IN '
BEGIN{

    FS=";"
    OFS=" "
    while  ( (getline < ARCHIN) > 0) 
    {
       DESC[$1]=$2
       print $1,DESC[$1] > "test2.txt"
    }
}
{
   #print DESC["AB027715"] > "test3"
   if (substr($0,1,1) == ">")
   {
      id = substr($0,2,length($0)-2)
      #print id > "salidaProteinas.fasta"
      descrip = DESC[id]
      print descrip > "test.txt"
      print ">"id, descrip > "salidaProteinas.fasta"
   }
   else
   {
      print $0 > "salidaProteinas.fasta"
   }
} ' "todasLasSeqsSoloInt1_Proteinas.fas"

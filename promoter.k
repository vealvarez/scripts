IN="tablaProm"

awk -vARCHIN=$IN '
BEGIN{
   FS=":"
   OFS=","

   while ( (getline < ARCHIN) > 0)
   {
     PROM[$1":"$2]=$3
     #print $1,$2,PROM[$1":"$2] > "test"
   }
}
{


  #formato: >gi|537705843|dbj|AB472901.2| Pseudomonas aeruginosa
  if (substr($0,1,1) == ">")
  {
    id=(substr($0,2,length($0)-1))
    #print ">" id > "seqsAnalizadasIDcorto.fasta"
   }
   else
   {
     limite=length($0) -  29

     for(i=1;i<=limite;i++)
     {
       texto=substr($0,i,29)
       menos35 = substr(texto,1,6)
       menos10 = substr(texto,24,6)
       promotor=PROM[menos35":"menos10]
       #print menos35,menos10,promotor"\n" > "test"
    
       if (promotor != "")
       {
         print id,promotor,"posDesde:" i > "salidaPromotor"
       }
     }
   }

   #split($0,CAMPO,":")
   #menos35 = substr(CAMPO[2],1,6)
   #menos10 = substr(CAMPO[2],24,6)
   #promotor=PROM[menos35":"menos10]
   
   #print CAMPO[1],promotor,"-35: " menos35,"-10: " menos10 > "salidaPromotor"
   #print CAMPO[1],promotor > "salidaPromotor"

}' "salidaFASTA"

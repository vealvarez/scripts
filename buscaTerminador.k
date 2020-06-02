awk '
BEGIN{
   FS=OFS=" "
   id=0
   nombre=""
}
{
     split($0,LINEA," ")
     term = LINEA[1]

     print term > 1
     
     if (term == "TERM")
     { 
         enc = 1
         lineaAnt = $0
     }
     else
     { 
       if (enc == 1)
       {
         print ">" lineaAnt > "Terminadores.fasta"
         print $0 > "Terminadores.fasta"
         enc = 0
       }
     }

}' $1 

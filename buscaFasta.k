#A PARTIR DE UN ARCHIVO DE ACCESION NUMBERS (A LOS QUE SE LES QUIERE
#ASIGNAR SU SECUENCIA FASTA QUE SE ENCUENTRA EN EL ARCHIVO HITSINT.FASTA
#SE GENERA UN ARCHIVO DE SALIDA CON EL NUMERO DE ACCESO Y LA SECUENCIA
#FASTA CORRESPONIENTE

ARCHAN="hitsintI1.fasta"

awk -vARCHIN=$ARCHAN '
BEGIN{
   FS=OFS=","
   id=0
   nombre=""

   while ( (getline < ARCHIN) > 0)
    if (substr($0,1,1) == ">")
     {
       split($0,REG,"|")
       split(REG[4],ACC,".")
       id = ACC[1]
       nombre=REG[4] REG[5]
       #print accesion > "a.txt"
     }
     else
     {
        SEQ[id]=SEQ[id] $0 
        NOMBRE[id]=nombre
     }

}
{
     split($0,LINEA,"|")
     numero = LINEA[1]
     
     if (length(SEQ[numero]) == 1014)
     { 
       print ">" NOMBRE[numero] > "accnumconfasta.fasta"
       print  SEQ[numero] > "accnumconfasta.fasta"
     }
     else
     {
       print ">" NOMBRE[numero] > "accnumconfasta.fasta"
       print ">" NOMBRE[numero] ", long: " length(SEQ[numero]) > "sinsec.txt"
       print "FALTA SECUENCIA!!!!" > "accnumconfasta.fasta"
     }


}' "buscar.txt"

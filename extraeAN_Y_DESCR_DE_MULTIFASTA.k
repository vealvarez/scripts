#A partir de un archivo multifasta extrae el número de acceso y 
#la descripcion de la secuencia

#FORMATO:>gi|400752836|ref|NC_018180.1| Sinorhizobium fredii USDA 257 plasmid pUSDA257, complete sequence
#>AF047479_FRAGMENT_3300:3752

awk '
BEGIN{
   OFS=";"
   id=0
   nombre=""
}
{
    if (substr($0,1,1) == ">")
     {
       split($0,REG,"_")
       id=REG[1]
       split(REG[3],POS,":")
       ini=POS[1]
       fin=POS[2]
       print id, ini, fin > "an_y_nombreSeq_cassettes.txt"
     }
     #else
     #{
     #   SEQ[id]=SEQ[id] $0 
     #   NOMBRE[id]=nombre
     #}

}' "cassettes.fasta"

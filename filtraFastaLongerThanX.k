#A partir de un archivo multifasta genera dos archivos, uno con las secuencias con longitud menor a X y otra con las mayores a X

awk '
BEGIN{
   FS=OFS=";"
   id=0
   nombre=""
}
{
    if (substr($0,1,1) == ">")
    {
      nombre = $0
    }
    else
    {
       if (length($0) > 10000000
       {
          print $0 > "menores_a_X.txt"
          print nombre > "menores_a_X.txt"
       }
       else
       {
          print nombre > "mayores_o_iguales_a_X.txt"
          print $0 > "mayores_o_iguales_a_X.txt"
       }
    }

}' "1contigs.fasta"

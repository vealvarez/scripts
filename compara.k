awk -vARCHIN="ansubseq" '
BEGIN{
FS=OFS=","
 while ( (getline < ARCHIN) > 0)
 {
    AN[$1] = "SI"
    print $1, AN[$1] > "test"
 }
}
{
   campo = $1
   print campo > "c"
   if (AN[campo] != "SI")
   {
     print campo, "valor: " AN[campo] "fin" > "noestan"
   }
}' accnumber.txt

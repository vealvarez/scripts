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

ARCHIVOIN="$1"
ARCHIVOOUT="$2"

awk -vOUT="$ARCHIVOOUT" '
BEGIN{
  #RS=""
}
{
   gsub(/\n/,"",$0)
   gsub(/\r/,"",$0)

  
   if ($0 != "")
   {

      if (substr($0,1,1) == ">")
      {
        if (NR != 1)
        {
           print linea > OUT 
           linea = ""
        }
           linea = $0 ","
      }
      else
      {
         linea = linea $0
      }   
   }
}
END{
      print linea > OUT 
} ' "$ARCHIVOIN"

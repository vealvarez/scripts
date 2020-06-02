
#ORDENAR SEQS.TXT Y CONTAR CANTIDADES DE ALELOS DIFERENTES. Arma archivo fasta con los alelos unicos.

ARCHIN=$1
ARCHOUT=$1"_ORDENADO.txt"

cat $ARCHIN | sort -t"," -k2 > $ARCHOUT 

awk -v NOMARCH=$ARCHIN '
BEGIN{

   print "ALELOS ENCONTRADOS: \n" > NOMARCH"_ReporteCantAlelos.rtf"

   FS=OFS=","
   seqAnt=""
   cant=1
   cantTotal=1
   cantSeq=0
}
{
  seq = $2
  cantSeq++


  if (seq == seqAnt)
  {
    cant++
    SEQS[cant] = $1
    seqAnt = seq
  }
  else
  {
    if (NR != 1)
    {
      print cantTotal "- Cantidad de secuencias que comparten este alelo: " cant > NOMARCH"_ReporteCantAlelos.rtf"
      print seqAnt > NOMARCH"_ReporteCantAlelos.rtf"
      print "Secuencias: " > NOMARCH"_ReporteCantAlelos.rtf"

      #print ">"SEQS[1] > NOMARCH"_Alelos.fas"
      print SEQS[1] > NOMARCH"_Alelos.fas"
      print seqAnt > NOMARCH"_Alelos.fas"

      for (j in SEQS)
      {
        print SEQS[j] > NOMARCH"_ReporteCantAlelos.rtf"
      }
      cantTotal++
      delete SEQS
      cant=1
      print "\n" > NOMARCH"_ReporteCantAlelos.rtf" 
    }
      seqAnt = seq
      SEQS[cant] = $1
  }
}
END{
      print cantTotal "- Cantidad de secuencias que comparten este alelo: " cant > NOMARCH"_ReporteCantAlelos.rtf"
      print seqAnt > NOMARCH"_ReporteCantAlelos.rtf"
      print "Secuencias: " > NOMARCH"_ReporteCantAlelos.rtf"

      #print ">"SEQS[1] > NOMARCH"_Alelos.fas"
      print SEQS[1] > NOMARCH"_Alelos.fas"
      print seqAnt > NOMARCH"_Alelos.fas"

      for (j in SEQS)
      {
        print SEQS[j] > NOMARCH"_ReporteCantAlelos.rtf"
      }
      delete SEQS
      print "\n" > NOMARCH"_ReporteCantAlelos.rtf"
      print "Cantidad total de alelos: " cantTotal > NOMARCH"_ReporteCantAlelos.rtf"
      print "Cantidad total de secuencias procesadas: " cantSeq > NOMARCH"_ReporteCantAlelos.rtf"
}' $ARCHOUT 

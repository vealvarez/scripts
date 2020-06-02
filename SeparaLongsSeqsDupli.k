awk -v ARCHIN=$IN '
BEGIN{

    FS=OFS="\t"
    idant=""
    cant=1
}
{
    id=$1
    if (id == idant)
    {
      cant++
    }
    else
    {
      cant=1
    }

    print $0 > "idsDupli"cant".txt"
    idant=$1

}' Cassettes_Pos.2_ORD.txt 

$file=$ARGV[0];
$f_size=$ARGV[1];
chomp($file);
chomp($f_size);

if (!$file || !$f_size)
{
    die "\nUSAGE: perl fasta_per_line.pl <file_name> <Number>\n\n<file_name>- Multiple fasta file name\n<Number>- Number of fasta sequences to be put in each new file (Must be less than total number of sequnecs in input file)\n\n";
}

%seq_hash=();
open AA, "<$file";

foreach (<AA>)
{
    chomp($_);
    if ($_=~/^>(.*)/)
    {       
        $id=$1;
        push (@aaa, $id);
    }
    else
    {
        $seq_hash{$id} .=$_;
    }
}

$file_count=1;$seq_count=1;
open KK, ">$file.1";
foreach $a(@aaa)
{
    print KK ">".$a."\n", $seq_hash{$a}."\n";
    $seq_count++; 
    if ($seq_count>$f_size)
    {
        close(KK); $file_count++; $seq_count=1;
    }
    if ($seq_count == 1)
    {
        $name=$file_count.$file;
        open KK, ">$name";
    }
}
close(KK);

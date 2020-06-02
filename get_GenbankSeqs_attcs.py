#ARCHIVO DE ENTRADA: TEXTO PLANO CON 14 CAMPOS
#ID_integron:ID_replicon:element:pos_beg:pos_end:strand:evalue:type_elt:annotation:model:type:default:distance_2attC:considered_topology
#A PARTIR DE ESTE ARCHIVO DE ENTRADA, BUSCA EN GENBANK LA SECUENCIA
#GENERA UN ARCHIVO CON LA SECUENCIA COMPLETA Y OTRO ARCHIVO CON LA SUBSECUENCIA
import os
from Bio import SeqIO
from Bio import Entrez
from Bio.SeqRecord import SeqRecord

Entrez.email = "A.N.Other@example.com"  # Always tell NCBI who you are
#WORKDIR = "/home/valvarez/proy_clon1-A144/genome_assemblies_refseq_Aba_chromosome_040719"
WORKDIR = "/home/valvarez/proy_cassettes/anahi/attcs"
filenamePos = WORKDIR + "/" + "attcs.txt"

#Handle para el arhivo que contiene las posiciones
pos_handle = open(filenamePos, "r")
for line in pos_handle:
    campos = line.split(":")
    strand = campos[5]
    ID_REPLICON = campos[1]
    datoReplicon = ID_REPLICON.split("|") 
    longDatoReplicon = len(datoReplicon)
    #print(longDatoReplicon)

    if len(datoReplicon) == 5:
      AN = datoReplicon[3]
    elif len(datoReplicon) == 1:
      AN = datoReplicon[0]
      
    desde = int(campos[3])
    hasta = int(campos[4])
    if desde > hasta:
        aux = hasta
        hasta = desde
        desde = aux

    #print(AN + "," + str(desde) + "," + str(hasta))
     
    #Nombre del archivo donde guardaré la secuencia fasta
    filename = WORKDIR + "/" + AN + ".fasta"

    #Busca en NCBI la secuencia con el AN que le dimos
    if not os.path.isfile(filename):
        net_handle = Entrez.efetch(db="nucleotide", id=AN, rettype="fasta", retmode="text")
        #Crea y abre el archivo fasta
        out_handle = open(filename, "w")
        #Escribe la secuencia fasta que buscamos en NCBI
        out_handle.write(net_handle.read())
        #Cierra los archivos
        out_handle.close()
        net_handle.close()

    #Creo un archivo fasta con la subsecuencia contenida entre el desde y el hasta
   
    #leo la secuencia original completa
    record = SeqIO.read(filename, "fasta")
    secuencia = record.seq
    
    #armo la subsecuencia
    substring = secuencia[desde - 1:hasta]

    #si el strand es 1 entonces debo hacer la reversa complementaria de la subsecuencia
    if strand == "-1":
      substringPre = substring.reverse_complement()
    else:
      substringPre = substring

    substringPrint = substringPre[0:len(substringPre) - 6]

    #nombreArchSubseq = WORKDIR + "/" + AN + ":" + str(desde) + ":" + str(hasta) + "_attc.fasta"
    nombreArchSubseq = WORKDIR + "/" + ID_REPLICON + ":" + str(desde) + ":" + str(hasta) + "_attc.fasta"
    subout_handle = open(nombreArchSubseq, "w")
    archRegs = []
    registroParaArchivo = SeqRecord(substringPrint,ID_REPLICON + ":" + str(desde) + ":" + str(hasta), '', '')
    archRegs.append(registroParaArchivo) 
    SeqIO.write(archRegs,subout_handle, "fasta")
    subout_handle.close()

    shellCommand = 'rm ' + filename
    os.system(shellCommand)

pos_handle.close()

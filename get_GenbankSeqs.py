#ARCHIVO DE ENTRADA: TEXTO PLANO CON 3 CAMPOS
#AN:DESDE:HASTA (TAMBIEN PUEDE SER HASTA:DESDE)
#A PARTIR DE ESTE ARCHIVO DE ENTRADA, BUSCA EN GENBANK LA SECUENCIA
#GENERA UN ARCHIVO CON LA SECUENCIA COMPLETA Y OTRO ARCHIVO CON LA SUBSECUENCIA
import os
from Bio import SeqIO
from Bio import Entrez
from Bio.SeqRecord import SeqRecord
Entrez.email = "A.N.Other@example.com"  # Always tell NCBI who you are
#WORKDIR = "/home/valvarez/proy_clon1-A144/genome_assemblies_refseq_Aba_chromosome_040719"
WORKDIR = "/home/valvarez/proy_cassettes/anahi"
filenamePos = WORKDIR + "/" + "pos.txt"

#Handle para el arhivo que contiene las posiciones
pos_handle = open(filenamePos, "r")
for line in pos_handle:
    campos = line.split(":")
    AN = campos[0]
    desde = int(campos[1])
    hasta = int(campos[2])
    if desde > hasta:
        aux = hasta
        hasta = desde
        desde = aux
     
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
    record = SeqIO.read(filename, "fasta")
    secuencia = record.seq
    substring = secuencia[desde - 1:hasta]
    nombreArchSubseq = WORKDIR + "/" + AN + ":" + str(desde) + ":" + str(hasta) + ".fasta"
    subout_handle = open(nombreArchSubseq, "w")
    archRegs = []
    registroParaArchivo = SeqRecord(substring,AN + ":" + str(desde) + ":" + str(hasta), '', '')
    archRegs.append(registroParaArchivo) 
    SeqIO.write(archRegs,subout_handle, "fasta")
    subout_handle.close()

    shellCommand = 'rm ' + filename
    os.system(shellCommand)

pos_handle.close()

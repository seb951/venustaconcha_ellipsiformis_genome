#!/home/apps/Logiciels/R/2.15.2/bin/Rscript --verbose

setwd("/RQexec/renaut/sophie_breton/genome/abyss/results/dir_k41_B24G_H4_kc3")

#module load BEDTools
#module load EMBOSS
#module load BLAST+

#get the sequences in fasta format
system("bedtools getfasta -s -fi repmask-1000_06/vel_assembly-1000b.fasta.masked -bed annotation_quast_vMasked/predicted_genes/vel_assembly-1000b-fasta-masked_glimmer_genes.gff -fo temp_fasta 2>log")

#modify format to get rid of ":"
system("awk '{gsub(/:/,\"_\")}; 1' temp_fasta >repmask-1000_06/vel_assembly-1000b.fasta.masked_CDS")

#only keep the CDS according to the gff file...
#if(file.exists("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_glimmer_genes.gff.gz")) system("gunzip -cd annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_glimmer_genes.gff.gz >annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_glimmer_genes.gff")
gff = read.table("annotation_quast_vMasked/predicted_genes/vel_assembly-1000b-fasta-masked_glimmer_genes.gff",stringsAsFactors=F)
gff_temp = c(1:nrow(gff))[gff[,3] == "CDS"]
gff_cds_only = cbind((gff_temp*2) -1,(gff_temp*2))
gff_cds_only = as.vector(t(gff_cds_only))



#load the fasta file (not pretty, but simple...)
fasta = read.table("repmask-1000_06/vel_assembly-1000b.fasta.masked_CDS", stringsAsFactors = F, header = F)
fasta_phased = fasta

#chop the fasta accordin to the phase (reading frame, 0, 1,2)
for(i in 1:nrow(gff))
	{
		if(gff[i,8] != "0" & gff[i,8] != ".") fasta_phased[(i*2),1] = substring(fasta_phased[(i*2),1],as.numeric(gff[i,8])+1,nchar(fasta_phased[(i*2),1]))
		if(i %% 100000 == 0) print(paste(i," of ",nrow(gff),", The time is:",Sys.time(),sep = ""))
	}
assembly10_cds.fa = fasta_phased[gff_cds_only,]

#write it back
write.table(assembly10_cds.fa,"assembly10_cds.fa", row.names = F, col.names = F, quote = F)


###add columns for annotation and the orf name standard
gff_annotated = cbind(gff,0,0,0,0)
colnames(gff_annotated)[10:13] = c("orfname","definition","accession","evalue")
gff_annotated[,10] = fasta_phased[c(T,F),1]
gff_annotated[,10] = sub(">","",gff_annotated[,10])

#get that shit into proteins..
system("/home/apps/Logiciels/EMBOSS/6.6.0/bin/transeq -clean 1 -methionine 0 -sequence assembly10_cds.fa -frame 1 -outseq assembly10_cds.orf") 

assembly10_cds.orf = read.table("assembly10_cds.orf", stringsAsFactors = F, header = F)
assembly10_cds.orf_names = c(1:nrow(assembly10_cds.orf))[regexpr(">", assembly10_cds.orf[,1])>0]
assembly10_cds.orf_names = c(assembly10_cds.orf_names,nrow(assembly10_cds.orf))


#blastp the shit out of it... uniprot
a = Sys.time()
system("/home/apps/Logiciels/blast+/2.2.28/bin/blastp -query assembly10_cds.orf -db /RQexec/renaut/blast_database/uniprot_sprot/uniprot_sprot.fasta -evalue 1e-5 -num_threads 12 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' >repmask-1000_06/assembly10_cds_uniprot.orf.blast")
b = Sys.time()

print(paste("Done blast, it tooks:,",b-a," hours to run UNIPROT BLAST",sep = ""))

assembly10_cds.orf.blast = read.table("repmask-1000_06/assembly10_cds_uniprot.orf.blast", header =F, stringsAsFactors = F, sep = "\t", quote = "")

#remove the last two characters in the blast
assembly10_cds.orf.blast[,1] = gsub("..$","",assembly10_cds.orf.blast[,1])

for(o in 1:nrow(assembly10_cds.orf.blast))
	{
	gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],11:13] = assembly10_cds.orf.blast[o,c(13,2,11)]
	sd = sd(as.numeric(rownames(gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],])))
	if(!is.na(sd) && sd >10) print(o)
	if(o %% 1000 == 0) print(paste(o," of:",nrow(assembly10_cds.orf.blast)," Time is:",Sys.time(),sep =""))
	}

write.table(gff_annotated,"annotation_quast_vMasked/predicted_genes/vel_assembly-1000b-fasta-masked_glimmer_genes_annotated_uniprot.gff",col.names = T, row.names = F, quote = T,sep = "\t")



#!/home/apps/Logiciels/R/2.15.2/bin/Rscript --verbose

setwd("/RQexec/renaut/sophie_breton/genome/abyss/results/dir_k41_B24G_H4_kc3")

#module load BEDTools
#module load EMBOSS
#module load BLAST+

##modify format
if(file.exists("assembly_k41_B24G_H4_kc3-10_rr.fa")==F) system("awk '{gsub(/ /,\"_\")}; 1' assembly_k41_B24G_H4_kc3-10.fa|awk '{gsub(/:/,\"_\")}; 1'|awk '{gsub(/,/,\"_\")}; 1'|awk '{gsub(/+/,\"_\")}; 1' >assembly_k41_B24G_H4_kc3-10_rr.fa")

##modify format (because of the broken gffs...
gff = read.table("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff",stringsAsFactors=F)
gff_modified = gff[,1]
for(i in 1:nrow(gff))
{
	split = strsplit(gff_modified[i],"_")[[1]]
	temp = split[-length(split)]
	gff_modified[i] = paste(temp,collapse = "_")
	if(i %% 1000 == 0) print(paste("done ",i," of:",nrow(gff)," The time is:",Sys.time(),sep = ""))	

}
gff[,1] = gff_modified

write.table(gff,"temp", quote = F, sep = "\t",row.names = F, col.names = F)

system("head -1 annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff >head")
system("cat head temp >annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff")
system("rm head temp")


#get the sequences in fasta format
if(file.exists("assembly_k41_B24G_H4_kc3-10_rr_CDS.fa")==F) system("bedtools getfasta -s -fi assembly_k41_B24G_H4_kc3-10_rr.fa -bed annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff -fo assembly_k41_B24G_H4_kc3-10_rr_CDS.fa 2>log")

#only keep the CDS according to the gff file...
#if(file.exists("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff.gz")) system("gunzip -cd annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff.gz >annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff")
gff = read.table("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff",stringsAsFactors=F)
gff_temp = c(1:nrow(gff))[gff[,3] == "CDS"]
gff_cds_only = cbind((gff_temp*2) -1,(gff_temp*2))
gff_cds_only = as.vector(t(gff_cds_only))


#gsub("_....$","",y)

#load the fasta file (not pretty, but simple...)
fasta = read.table("assembly_k41_B24G_H4_kc3-10_rr_CDS.fa", stringsAsFactors = F, header = F)
fasta_phased = fasta

#chop the fasta accordin to the phase (reading frame, 0, 1,2)
for(i in 1:nrow(gff))
#for(i in 1:1000)
	{
		if(gff[i,8] != "0" & gff[i,8] != ".") fasta_phased[(i*2),1] = substring(fasta_phased[(i*2),1],as.numeric(gff[i,8])+1,nchar(fasta_phased[(i*2),1]))
		if(i %% 100000 == 0) print(paste(i," of ",nrow(gff),", The time is:",Sys.time(),sep = ""))
	}
assembly10_cds.fa = fasta_phased[gff_cds_only,]

###add columns for annotation and the orf name standard
gff_annotated = cbind(gff,0,0,0,0)
colnames(gff_annotated)[10:13] = c("orfname","definition","accession","evalue")
gff_annotated[,10] = paste(unlist(strsplit(fasta_phased[c(T,F),1],":"))[c(F,T)],"_1",sep = "")

#write it back 
write.table(assembly10_cds.fa,"assembly10_cds.fa", row.names = F, col.names = F, quote = F)

#get that shit into proteins..
system("/home/apps/Logiciels/EMBOSS/6.6.0/bin/transeq -clean 1 -methionine 0 -sequence assembly10_cds.fa -frame 1 -outseq assembly10_cds.orf") 

assembly10_cds.orf = read.table("assembly10_cds.orf", stringsAsFactors = F, header = F)
assembly10_cds.orf_names = c(1:nrow(assembly10_cds.orf))[regexpr(">", assembly10_cds.orf[,1])>0]
assembly10_cds.orf_names = c(assembly10_cds.orf_names,nrow(assembly10_cds.orf))

#blastp the shit out of it...
a = Sys.time()
system("/home/apps/Logiciels/blast+/2.2.28/bin/blastp -query assembly10_cds.orf -db /RQusagers/renaut/blast_database/swissprot/swissprot -evalue 1e-5 -num_threads 12 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' >assembly10_cds.orf.blast")
b = Sys.time()

print(paste("Done blast, it tooks:,",b-a," time",sep = ""))

assembly10_cds.orf.blast = read.table("assembly10_cds.orf.blast", header =F, stringsAsFactors = F, sep = "\t")

for(o in 1:nrow(assembly10_cds.orf.blast))
	{
	gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],11:13] = assembly10_cds.orf.blast[o,c(13,2,11)]
	}

write.table(gff_annotated,"annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes_annotated.gff",col.names = T, row.names = F, quote = T,sep = "\t")

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
	if(i %% 100000 == 0) print(paste("done ",i," of:",nrow(gff)," The time is:",Sys.time(),sep = ""))	

}
gff[,1] = gff_modified

write.table(gff,"temp", quote = F, sep = "\t",row.names = F, col.names = F)

system("head -1 annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff >head")
system("cat head temp >annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff")
system("rm head temp")


#get the sequences in fasta format
if(file.exists("assembly_k41_B24G_H4_kc3-10_rr_CDS_broken.fa")==F) system("bedtools getfasta -s -fi assembly_k41_B24G_H4_kc3-10_rr.fa -bed annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff -fo temp_fasta 2>log")

#modify format to get rid of ":"
if(file.exists("assembly_k41_B24G_H4_kc3-10_rr_CDS_broken.fa")==F) system("awk '{gsub(/:/,\"_\")}; 1' temp_fasta >assembly_k41_B24G_H4_kc3-10_rr_CDS_broken.fa")

#only keep the CDS according to the gff file...
#if(file.exists("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff.gz")) system("gunzip -cd annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff.gz >annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes.gff")
gff = read.table("annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff",stringsAsFactors=F)
system("rm annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes2.gff")
gff_temp = c(1:nrow(gff))[gff[,3] == "CDS"]
gff_cds_only = cbind((gff_temp*2) -1,(gff_temp*2))
gff_cds_only = as.vector(t(gff_cds_only))


#gsub("_....$","",y)

#load the fasta file (not pretty, but simple...)
fasta = read.table("assembly_k41_B24G_H4_kc3-10_rr_CDS_broken.fa", stringsAsFactors = F, header = F)
fasta_phased = fasta

#chop the fasta accordin to the phase (reading frame, 0, 1,2)
for(i in 1:nrow(gff))
#for(i in 1:10000)
	{
		if(gff[i,8] != "0" & gff[i,8] != ".") fasta_phased[(i*2),1] = substring(fasta_phased[(i*2),1],as.numeric(gff[i,8])+1,nchar(fasta_phased[(i*2),1]))
		if(i %% 100000 == 0) print(paste(i," of ",nrow(gff),", The time is:",Sys.time(),sep = ""))
	}
assembly10_cds.fa = fasta_phased[gff_cds_only,]

#write it back
write.table(assembly10_cds.fa,"assembly10_cds_broken.fa", row.names = F, col.names = F, quote = F)


###add columns for annotation and the orf name standard
gff_annotated = cbind(gff,0,0,0,0)
colnames(gff_annotated)[10:13] = c("orfname","definition","accession","evalue")
gff_annotated[,10] = fasta_phased[c(T,F),1]
gff_annotated[,10] = sub(">","",gff_annotated[,10])

#get that shit into proteins..
system("/home/apps/Logiciels/EMBOSS/6.6.0/bin/transeq -clean 1 -methionine 0 -sequence assembly10_cds_broken.fa -frame 1 -outseq assembly10_cds_broken.orf") 

assembly10_cds.orf = read.table("assembly10_cds_broken.orf", stringsAsFactors = F, header = F)
assembly10_cds.orf_names = c(1:nrow(assembly10_cds.orf))[regexpr(">", assembly10_cds.orf[,1])>0]
assembly10_cds.orf_names = c(assembly10_cds.orf_names,nrow(assembly10_cds.orf))


#blastp the shit out of it... uniprot
a = Sys.time()
system("/home/apps/Logiciels/blast+/2.2.28/bin/blastp -query assembly10_cds_broken.orf -db /RQexec/renaut/blast_database/uniprot_sprot/uniprot_sprot.fasta -evalue 1e-5 -num_threads 12 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' >assembly10_cds_uniprot.orf.blast_broken")
b = Sys.time()

print(paste("Done blast, it tooks:,",b-a," hours to run UNIPROT BLAST",sep = ""))

assembly10_cds.orf.blast = read.table("assembly10_cds_uniprot.orf.blast_broken", header =F, stringsAsFactors = F, sep = "\t", quote = "")

#remove the last two characters in the blast
assembly10_cds.orf.blast[,1] = gsub("..$","",assembly10_cds.orf.blast[,1])

for(o in 1:nrow(assembly10_cds.orf.blast))
	{
	gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],11:13] = assembly10_cds.orf.blast[o,c(13,2,11)]
	sd = sd(as.numeric(rownames(gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],])))
	if(!is.na(sd) && sd >10) print(o)
	if(o %% 1000 == 0) print(paste(o," of:",nrow(assembly10_cds.orf.blast)," Time is:",Sys.time(),sep =""))
	}

write.table(gff_annotated,"annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes_annotated_uniprot.gff",col.names = T, row.names = F, quote = T,sep = "\t")


###TREMBL
#blastp the shit out of it... trembl

if(1 ==2)
{
a = Sys.time()
system("/home/apps/Logiciels/blast+/2.2.28/bin/blastp -query assembly10_cds.orf -db /RQexec/renaut/blast_database/trembl/uniprot_trembl.fasta -evalue 1e-5 -num_threads 12 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' >assembly10_cds_trembl.orf.blast")
b = Sys.time()

print(paste("Done blast, it tooks:,",b-a," hours to run TREMBL blast",sep = ""))

assembly10_cds.orf.blast = read.table("assembly10_cds_trembl.orf.blast", header =F, stringsAsFactors = F, sep = "\t", quote = "")

#remove	the last two characters	in the blast
assembly10_cds.orf.blast[,1] = gsub("..$","",assembly10_cds.orf.blast[,1]) 

for(o in 1:nrow(assembly10_cds.orf.blast))
        {
	gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],11:13] = assembly10_cds.orf.blast[o,c(13,2,11)]
        sd = sd(as.numeric(rownames(gff_annotated[gff_annotated[,10] == assembly10_cds.orf.blast[o,1],])))
        if(!is.na(sd) && sd >10) print(o)
        if(o %% 1000 == 0) print(paste(o," of:",nrow(assembly10_cds.orf.blast)," Time is:",Sys.time(),sep =""))
        }

write.table(gff_annotated,"annotation_quast_v3/predicted_genes/assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes_annotated_trembl.gff",col.names = T, row.names = F, quote = T,sep = "\t")

}

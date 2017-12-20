#!/home/apps/Logiciels/R/3.0.0/bin/Rscript --verbose

setwd("/RQexec/renaut/sophie_breton/genome/")

###get sequences
system("ls -1 sequences/pairends/*R1.fastq.gz >names_pe") #pairends 
system("ls -1 sequences/matepairs/*R1.fastq.gz >>names_pe") #matepairs
#system("ls -1 sequences/pairends/*paired.fastq.gz >names_pe")

names_pe = read.table("names_pe",stringsAsFactors = F, header = F)
names_pe =cbind(names_pe,0,0,0,0,0)
adapters = "sequences/TruSeq3-PE.fa"

###trimommatic on the data
for(i in 1: nrow(names_pe))
#for(i in 3:3)
{
names_pe[i,2] = gsub("R1","R2",names_pe[i,1])
names_pe[i,3] = gsub(".fastq.gz","_paired.fastq ",names_pe[i,1])
names_pe[i,4] = gsub(".fastq.gz","_unpaired.fastq ", names_pe[i,1])
names_pe[i,5]= gsub("R1.fastq.gz","R2_paired.fastq ", names_pe[i,1])
names_pe[i,6] = gsub("R1.fastq.gz","R2_unpaired.fastq ", names_pe[i,1])
names_pe[i,7] = gsub("sequences/pairends/","",names_pe[i,1])
trimmo = paste("java -jar /home/apps/Logiciels/trinityrnaseq/2015-03-06/trinity-plugins/Trimmomatic-0.32/trimmomatic-0.32.jar PE -phred33 ",
names_pe[i,1]," ",names_pe[i,2]," ",names_pe[i,3]," ",names_pe[i,4]," ",names_pe[i,5]," ",names_pe[i,6]," ILLUMINACLIP:",
adapters,":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:6:10 MINLEN:36",sep =  "")
if(file.exists(gsub(" ","",names_pe[i,5])) == F) system(trimmo)#dont redo trimmo if file already exists.
#print(trimmo)
print(paste("Done Trimo on reads ",names_pe[i,2]," The time is:",Sys.time(),sep = ""))
}

###bfc on the data
#system("./sequences/pairends/bfc2.sh")

###abyss on the data



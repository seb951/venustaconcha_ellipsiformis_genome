setwd("Documents/Manuscripts/2018/39.Venustachonca_genome_paper/results")

#plot the results of figure 2 (data in found in table 2)
rep = read.table("size_repeat_het",header = F, stringsAsFactors = F)
dev.new()
col = c("blue","green",rep("orange",4),"purple","red","red","grey70")
pointlab = paste(substring(rep[,2],1,1),". ",rep[,3], sep = "")
plot(rep[,4],rep[,6], ylim = c(20,65),xlim= c(0.5,2.5),xlab = "Genome Size (Gb)", 
     ylab = "% repeats", col = col,pch = 21,lwd = 10)

#h = c(20,30,40,50,60)
#v= c(0.5,1,1.5,2,2.5)
#for(i in 1:5) {abline(h=h[i],lty = 5, col = "darkgrey",lwd = 0.5)}
#for(i in 1:5) {abline(v=v[i], lty = 5, col = "darkgrey",lwd = 0.5)}
abline(lm(rep[,6]~rep[,4]),lty = 2, lwd = 4)
abline(h= median(rep[,6]),lty = 5, col = "darkgrey",lwd = 0.7)
abline(v= median(rep[,4]),lty = 5, col = "darkgrey",lwd = 0.7) 
adj1 = c(-0.2,1.2)
text(rep[-4,4],rep[-4,6],pointlab[-4],cex = 0.7, col = col[-4],font = 4,pos = 4)
text(rep[4,4],rep[4,6],pointlab[4],cex = 0.7, col = col[4],font = 4,pos = 2)
legend(0.5,65,unique(rep[,1]),bg = "white", col = unique(col),fill = unique(col))

dev.print(device=pdf, "../figures/Figure_S2.1.pdf", onefile=FALSE)
dev.off()



mkdir ../../results/dir_k41_B24G_H4_kc3

###
time (abyss-bloom-dbg -k41 -q3 -v -b24G -H4 -j24 --kc=3  ../../../sequences/pairends/err_corrected_bfc_HI.0502.007.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.007.Index_10.H3412_9_R2_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.006.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.006.Index_10.H3412_9_R2_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.008.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.008.Index_10.H3412_9_R2_paired.fastq.gz > ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa 2>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log) 2>../../results/dir_k41_B24G_H4_kc3/abyss-bloom-dbg.time
AdjList -v   -k41 -m25 --dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-filtergraph -v --dot   -k41 -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.dot1 ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
MergeContigs -v  -k41 -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.dot -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.dot1 ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
PopBubbles -v --dot -j12 -k41  -p0.9  -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.dot >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
MergeContigs -v  -k41 -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
awk '!/^>/ {x[">" $1]=1; next} {getline s} $1 in x {print $0 "\n" s}' \
		../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-2.path ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-indel.fa 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
ln -sf ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-unitigs.fa 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-map  -j12 -l25    ../../../sequences/pairends/err_corrected_bfc_HI.0502.007.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.007.Index_10.H3412_9_R2_paired.fastq.gz ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa \
		|abyss-fixmate -v  -l25  -h lib6-3.hist \
		|sort -S1G -T /RQexec/renaut/sophie_breton/genome/abyss/tmp/dir_k41_B24G_H4_kc3/ -snk3 -k4 \
		|DistanceEst -v  -j12 -k41 -l25 -s100 -n2 -o lib6-3.dist lib6-3.hist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-map  -j12 -l25    ../../../sequences/pairends/err_corrected_bfc_HI.0502.006.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.006.Index_10.H3412_9_R2_paired.fastq.gz ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa \
		|abyss-fixmate -v  -l25  -h lib7-3.hist \
		|sort -S1G -T /RQexec/renaut/sophie_breton/genome/abyss/tmp/dir_k41_B24G_H4_kc3/ -snk3 -k4 \
		|DistanceEst -v  -j12 -k41 -l25 -s100 -n2 -o lib7-3.dist lib7-3.hist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-map  -j12 -l25    ../../../sequences/pairends/err_corrected_bfc_HI.0502.008.Index_10.H3412_9_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.0502.008.Index_10.H3412_9_R2_paired.fastq.gz ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa \
		|abyss-fixmate -v  -l25  -h lib8-3.hist \
		|sort -S1G -T /RQexec/renaut/sophie_breton/genome/abyss/tmp/dir_k41_B24G_H4_kc3/ -snk3 -k4 \
		|DistanceEst -v  -j12 -k41 -l25 -s100 -n2 -o lib8-3.dist lib8-3.hist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

###
abyss-todot -v --dist -e ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa lib6-3.dist lib7-3.dist lib8-3.dist >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.dist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
Overlap -v --dot   -k41 -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.dot -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.dist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
SimpleGraph -v   -j12 -k41 -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path1 ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.dist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-index -v --fai ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-index -v --fai ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.fa 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
cat ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa.fai ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.fa.fai|MergePaths -v  -j12 -k41  -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path2 - ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path1 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
PathOverlap --assemble -v  -k41  ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path2 >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path3 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
cat ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.fa|PathConsensus -v --dot -k41  -p0.9  -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.path -s ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.fa -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.dot - ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.path3 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
cat ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-4.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.fa |MergeContigs -v  -k41 -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa - ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

####
PathOverlap --overlap -v  -k41 --dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-5.path >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
ln -sf ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-contigs.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-map  -j12 -l25    ../../../sequences/matepairs//err_corrected_bfc_HI.0766.0012.H3412_12_R1_paired.fastq.gz ../../../sequences/matepairs//err_corrected_bfc_HI.0766.0012.H3412_12_R2_paired.fastq.gz ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa \
		|abyss-fixmate -v  -l25 -h mp1-6.hist \
		|sort -S1G -T /RQexec/renaut/sophie_breton/genome/abyss/tmp/dir_k41_B24G_H4_kc3/ -snk3 -k4 \
		|DistanceEst --dot --mean -v  -j12 -k41 -l25 -s100 -n2 -o mp1-6.dist.dot mp1-6.hist 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-scaffold -v   -k41 -s100-10000 -n2 -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.path.dot  ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.dot mp1-6.dist.dot >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
PathConsensus -v --dot -k41  -p0.9  -s ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.fa -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.dot -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.path ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
cat ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.fa|MergeContigs -v  -k41 -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa - ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

###
PathOverlap --overlap -v  -k41 --dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-7.path >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

/RQusagers/renaut/bwa-master/bwa index ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
/RQusagers/renaut/bwa-master/bwa mem -a -t12 -S -P -k41 ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa ../../../sequences/rnaseq/trinity_pacbio.fasta \
		|gzip >pactri-8.sam.gz 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-longseqdist -k41  pactri-8.sam.gz|grep -v "l=" >pactri-8.dist.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-scaffold -v   -k41 -s100-10000 -n1 -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.path.dot  ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.dot pactri-8.dist.dot >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
PathConsensus -v --dot -k41  -p0.9  -s ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.fa -g ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.dot -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.path ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
cat ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.fa \
		|MergeContigs -v  -k41 -o ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-10.fa - ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.path 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

###
PathOverlap --overlap -v  -k41 --dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.dot ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-9.path >../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-10.dot 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-fac -s 1000  ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-10.fa |tee ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-stats1000.tsv 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log
abyss-fac  ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-1.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-3.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-6.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-8.fa ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-10.fa |tee ../../results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-stats500.tsv 2>>../../results/dir_k41_B24G_H4_kc3/k41_B24G_H4_kc3-1.log

###extra commands I added to de-clutter a little.
cd /RQexec/renaut/sophie_breton/genome/abyss
cp pipeline/genome_abyss_v11.PBS results/dir_k41_B24G_H4_kc3/.
cp pipeline/genome_abyss_v11.sh results/dir_k41_B24G_H4_kc3/.
echo $'assembly\nraw\nunitigs\ncontigs\nscaffolds\nlongscafolds' >results/dir_k41_B24G_H4_kc3/names
paste results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-stats1000.tsv results/dir_k41_B24G_H4_kc3/names >>results/dir_k41_B24G_H4_kc3/assembly_stats.tab
rm results/dir_k41_B24G_H4_kc3/names
rm results/dir_k41_B24G_H4_kc3/assembly_k41_B24G_H4_kc3-stats1000.tsv
cat results/stats.info >>results/dir_k41_B24G_H4_kc3/assembly_stats.tab





#error corrected sequences (bfc)
#clean (trimo) sequences
#scaffolds: -s100-10000
#k =41
#abyss-map -l25 
#AdjList -m25
#DistanceEst -s100
#abyss-map remove -v option
#k41_B24G_H4_kc3
#removed the symbolic links
#april 6th 2017:
#add the new read  ../../../sequences/pairends/err_corrected_bfc_HI.3777.006.NS_Adaptor_2.Vell_11g_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.3777.006.NS_Adaptor_2.Vell_11g_R2_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.3777.006.NS_Adaptor_6.Vell_11p_pool_R1_paired.fastq.gz ../../../sequences/pairends/err_corrected_bfc_HI.3777.006.NS_Adaptor_6.Vell_11p_pool_R2_paired.fastq.gz
#add also the matepairs but only as unpaired reads in the initial assembly

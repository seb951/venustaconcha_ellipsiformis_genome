## *Venustaconcha ellipsiformis* genome
* This repo contains the scripts necessary to assemble and annotate the Venustaconcha ellipsiformis genome, in addition to the QUAST annotation files and some, along with some supplementary files (annotations, mitogenome analyses)  
* Raw sequencing files (3 Illumina Paired-end libraries, 2 Illumina Mate-pair libraries, 1 PacBio long read library) and sequenced genome (1 draft genome) are available from NCBI SRA under bioproject *PRJNA433387*   
* **FULL REFERENCE**: *Renaut, Sébastien, Davide Guerra, Walter R. Hoeh, Donald T. Stewart, Arthur E. Bogan, Fabrizio Ghiselli, Liliana Milani, Marco Passamonti, and Sophie Breton.* [Genome survey of the freshwater mussel Venustaconcha ellipsiformis (Bivalvia: Unionida) using a hybrid de novo assembly approach.](https://academic.oup.com/gbe/article/10/7/1637/5034436) **Genome biology and evolution** 10, no. 7 (2018): 1637-1646.

## A list of script present in this repository
* [bfc_mp.PBS](pipeline/bfc_mp.PBS): bfc error correction for mate-pairs  
* [bfc.PBS](pipeline/bfc.PBS): bfc error correction for paired ends  
* [trimmo.PBS](pipeline/trimmo.PBS) and [trimmo.R](pipeline/trimmo.R): trimming data using trimmomatic  
* [kmer_jelly_genomescope2.PBS](pipeline/kmer_jelly_genomescope2.PBS): kmer analysis with Jellyfish + genomescope  
* [genome_abyss_v11.PBS](pipeline/genome_abyss_v11.PBS) and [genome_abyss_v11.sh](pipeline/genome_abyss_v11.sh): This is the main genome assembly step  
* [busco.PBS](pipeline/busco.PBS) BUSCO analysis  
* [mito_genome.PBS](pipeline/mito_genome.PBS) mitochondrial genome analyses  
* [quast.PBS](pipeline/quast.PBS) quast statitics  
* [seqkit_statistics.PBS](pipeline/seqkit_statistics.PBS: genome assembly stats  
* [saving_data](pipeline/saving_data): saving the results into a tarball  
* [blast_contamination.PBS](pipeline/blast_contamination.PBS):  assessing contamination of the genome (raw reads + gene space)
* [figure_S2.R](pipeline/figure_S2.R): Script to plot figure S2 based on results from table 2.  


## Annotation files
* Three different versions, based on the final scaffold assembly, the final scaffold assembly broken down based on N, and the repetitive element masked genome assembly  
* [annotate_sequences.PBS](pipeline/annotate_sequences.PBS)
* [annotate_sequences_broken.R](pipeline/annotate_sequences_broken.R)
* [annotate_sequences_masked.R](pipeline/annotate_sequences_masked.R)
* [annotate_sequences.R](pipeline/annotate_sequences.R)


## Other files
* [mito_contigs_highstringency.blastout](mito_contigs_highstringency.blastout): 53 unique contigs blasting to the mt genome  
* [mito_female_venustaconcha.fasta.gz](mito_female_venustaconcha.fasta.gz) : mito_female_venustaconcha fasta file (mt reference from Breton et al.2009, denovo mt genome, mt genome consensus from realignment)  
* assembly_k41_B24G_H4_kc3-10.fa.gz : final assembled genome (all long scaffolds): Note that this file is actually stored on NCBI under "QKMX00000000" (with short contigs <1000bp and putative contamination removed)  
* [names_correspondance_ncbi_original.gz](names_correspondance_ncbi_original.gz): A correspondance file betweeen the contig names as originally labelled in the analysis and the names given by NCBI. Note that in the annotation files, the contigs have names such as **81_read_HWI-ST748_169_D1ANHACXX_7_1101_19871_3720**, but in the correspondance file, this would match to **>81** part of the name.


# QUAST annotation folder (annotation_quast_v3)
* This contains the report.html for a web browser friendly view of the genome statistics (annotation_quast_v3.tar.gz). The "predicted_genes" contains the gff files along with the blast annotations for the long_scaffolds ("assembly_k41_B24G_H4_kc3-10_glimmer_genes_annotated_uniprot.gff.gz""),	long_scaffolds (> 1 Kb scaffolds broken based on N streches,"assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes_annotated_uniprot.gff.gz"), and long_scaffolds (> 1 Kb scaffolds, masked assembly,"vel_assembly-1000b-fasta-masked_glimmer_genes_annotated_uniprot.gff.gz") (see Table 4)


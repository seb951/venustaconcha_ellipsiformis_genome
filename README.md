# Sequencing files
Raw sequencing data (3 Illumina Paired-end libraries, 2 Illumina Mate-pair libraries, 1 PacBio long read library) and sequenced genome (1 draft genome) are available from NCBI SRA under bioproject *PRJNA433387* 

# Venustaconcha_genome
This repo contains the scripts necessary to assemble and annotate the Venustaconcha ellipsiformis genome, in addition to the QUAST annotation files and some, along with some supplementary files (annotations, mitogenome analyses)

#All scripts (pipeline) used in the analyses are provided here: https://github.com/seb951/venustaconcha_ellipsiformis_genome

#bfc_mp.PBS
bfc error correction for mate-pairs

#bfc.PBS
bfc error correction for paired ends

#trimmo.PBS and trimmo.R
trimming data using trimmomatic

#kmer_jelly_genomescope2.PBS
kmer analysis with Jellyfish + genomescope

#genome_abyss_v11.PBS and genome_abyss_v11.sh
This is the main genome assembly step

#graveyard/
old script not usefull anymore

#busco.PBS
BUSCO analysis

#mito_genome.PBS
mitochondrial genome analyses

#quast.PBS
quast statitics

#annotate_sequences_broken.R
#annotate_sequences_masked.R
#annotate_sequences.PBS
#annotate_sequences.R
annotate the genome (three different versions, based on the final scaffold assembly, the final scaffold assembly broken down based on N, 
and the repetitive element masked genome assembly 

#seqkit_statistics.PBS
genome assembly stats

#saving_data
saving the results into a tarball

#blast_contamination.PBS
assessing contamination of the genome (raw reads + gene space)

#annotation_quast_v3.tar.gz
#QUAST annotation folder. This contains the report.html for a web browser friendly view of the genome statistics (annotation_quast_v3.tar.gz). The "predicted_genes" contains
the gff files along with the blast annotations  for the long_scaffolds ("assembly_k41_B24G_H4_kc3-10_glimmer_genes_annotated_uniprot.gff.gz""),	long_scaffolds (> 1 Kb scaffolds broken based on N streches,"assembly_k41_B24G_H4_kc3-10_broken_glimmer_genes_annotated_uniprot.gff.gz"), and long_scaffolds (> 1 Kb scaffolds, masked assembly,"vel_assembly-1000b-fasta-masked_glimmer_genes_annotated_uniprot.gff.gz") (see Table 4)

#figure_S2.R
Script to plot figure S2 based on results from table 2.

#53 unique contigs blasting to the mt genome
mito_contigs_highstringency.blastout

#final assembled genome (all long scaffolds): Note that this file is actually stored on NCBI under "QKMX00000000"
assembly_k41_B24G_H4_kc3-10.fa.gz

#mito_female_venustaconcha fasta file (mt reference from Breton et al.2009, denovo mt genome, mt genome consensus from realignment)
mito_female_venustaconcha.fasta.gz





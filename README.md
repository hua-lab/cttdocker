# cttdocker
This is a Docker application package of CTT designed for running in Docker container in multiple operating systems.  Before running the program in Docker, blastable databases and seed files of gene superfamilies need to be organized.

1. Clone this package under your home (~) directory.

         git clone https://github.com/hua-lab/cttdocker.git

2. Make one perl dependency file, pfam_scan.pl, executable. Under ~/cttdocker/dependencies directory, do

         chmod +x ./pfam_scan.pl
         
3. Organize genomes you want to annotate

   3.1. Collect genome and prior whole genome annotation (gff3 and protein sequence) databases and save them under "species_databases". You may collect these databases for as many genomes as you want if your space is allowed.

   3.2. Create a tab file, termed "organismal_genome_gff3_proteome_files.tab" to organize the genomes you want to annotate. On each new line, list the genome file name (ended with *.fa), gff3 file name (ended with *.gene.gff3), and protein annotation file name (ended with *.protein.fa). The files should be separated with "tab" but not space characters. You may use vim editor to create this file under the directory of "species_databases".

   3.3. Make both genome and proteome blast databases. This step requires you to install an NCBI-blast+ package (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download).   

For each genome file, do

          makeblastdb -in genome_file_name -dbtype nucl -out genome_file_name.db
 
          e.g. makeblastdb -in Athaliana_167_TAIR9.fa -dbtype nucl -out Athaliana_167_Tair9.fa.db

For each proteome file, do

          makeblastdb -in proteome_file_name -dbtype prot -out proteome_file_name.db

          e.g. makeblastdb -in Athaliana_167_TAIR10.protein.fa -dbtype prot -out Athaliana_167_TAIR10.protein.fa.db

4. Collect seed sequences for superfamilies in which you are interested under directory "seeds".

    This package uses the seed sequences collected at Pfam as a gold standard for superfamily annotation. Visit https://pfam.xfam.org, find the webpage of the superfamily of interest.  At the "Aligments" link of the superfamily (e.g. https://pfam.xfam.org/family/PF01466#tabview=tab3), generate and download a FASTA format file of the seed sequences without gaps and save it under "seeds" directory. For example, "SKP1_PF01466_seeds.txt". You may combine several seed files and annotate multiple superfamilies at the same time.

5. Make an empty directory to output the annotation results from Docker to host.

   Under ~/cttdocker directory, do
   
          mkdir ctt_output

6. Build mybio:cttdocker Docker image

   Under ~/cttdocker directory, do
  
          docker build -t mybio:cttdocker .
      
7. Run the program in a Docker container (using the Skp1 family as an example)

          docker run -i -v ~/cttdocker/seeds:/cttdocker/seeds:z \
                        -v ~/cttdocker/species_databases:/cttdocker/species_databases:z \
                        -v ~/cttdocker/ctt_output:/cttdocker/ctt_output:z \
                        --rm mybio:cttdocker \
                        --seed SKP1_PF01466_seed.txt \
                        --f Skp1 \
                        --superfamily SKP

The annotation results are saved in the ~/cttdocker/ctt_output directory.

8. References

    Hua Z, Zou C, Shiu SH, Vierstra RD: Phylogenetic comparison of F-Box (FBX) gene superfamily within the plant kingdom reveals divergent evolutionary histories indicative of genomic drift. PLoS One 2011, 6(1):e16219.

    Hua Z. Using CTT for comprehensive superfamily gene annotations. Protocols.io. 2019. doi: dx.doi.org/10.17504/protocols.io.zf4f3qw.

    Hua Z, Early JM: Closing Target Trimming: a Perl Package for Discovering Hidden Superfamily Loci in Genomes. PLoS One 2019, 14(7): e0209468. https://doi.org/10.1371/journal.pone.0209468


9. Acknowledgment

    This work is supported by a National Science Foundation CAREER award to Z.H. (MCB-1750361).
      


  





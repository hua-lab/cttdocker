# cttdocker
This is a Docker application package for CTT. Before running the program in Docker, blastable databases and seed files of gene superfamilies need to be organized

1. Organize genomes you want to annotate

1.1. Collect genome and prior whole genome annotation (gff3 and protein sequence) databases and save them under "species_databases". You may collect these databases for as many genomes as you want if your space is allowed.

1.2. Create a tab file, termed "organismal_genome_gff3_proteome_files.tab" to organize the genomes you want to annotate. On each new line, list the genome file name (ended with *.fa), gff3 file name (ended with *.gene.gff3), and protein annotation file name (ended with *.protein.fa). The files should be separated with "tab" but not space characters. You may use vim editor to create this file under the directory of "species_databases".

1.3. Make both genome and proteome blast databases. This step requires you to install an NCBI-blast+ package (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download).   

For each genome file, do

 makeblastdb -in genome_file_name -dbtype nucl -out genome_file_name.db
 
 e.g. makeblastdb -in Athaliana_167_TAIR9.fa -dbtype nucl -out Athaliana_167_Tair9.fa.db

For each proteome file, do

 makeblastdb -in proteome_file_name -dbtype prot -out proteome_file_name.db

 e.g. makeblastdb -in Athaliana_167_TAIR10.protein.fa -dbtype prot -out Athaliana_167_TAIR10.protein.fa.db

2. Collect seed sequences for superfamilies in which you are interested under directory "seeds".

This package uses the seed sequences collected at Pfam as a gold standard for superfamily annotation. Visit https://pfam.xfam.org, find the webpage of the superfamily of interest.  At the "Aligments" link of the superfamily (e.g. https://pfam.xfam.org/family/PF01466#tabview=tab3),download a FASTA file of the seed sequences without gaps and save it under "seeds" directory. For example, "SKP1_PF01466_seeds.txt". You may combine several seed files and annotate multiple superfamilies at the same time.

3. Make an empty directory to output the annotation results from Docker to host.

   Under ~/cttdocker directory, type
   
     mkdir ctt_output

3. Build mybio:cttdocker image

  Under ~/cttdocker directory, type
  
      docker build -t mybio:cttdocker .
      
4. Run the program in Docker (using Skp1 family as an example)

      docker run -i -v ~/ctt/seeds:/ctt/seeds \
-v ~/ctt/species_databases:/ctt/species_databases \
-v ~/ctt/ctt_output:/ctt/ctt_output \
--rm mybio:cttdocker \
--seed SKP1_PF01466_seed.txt \
--f Skp1 \
--superfamily SKP

The annotation results are saved in the ~/cttdocker/ctt_output directory.


      


  





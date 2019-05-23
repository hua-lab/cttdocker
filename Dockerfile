
FROM ubuntu:18.04

LABEL project="Bio_CTT_Docker_Image"
LABEL maintainer "Zhihua Hua <hua@ohio.edu>"
RUN apt-get update \
&& apt-get install -y --no-install-recommends apt-utils \
&& apt-get -qy --force-yes upgrade \
&& apt-get -qy --force-yes dist-upgrade \
&& apt-get install -qy --force-yes \
	perl \
	build-essential \
	bioperl \
	ncbi-blast+ \
	hmmer \
	cd-hit \
	wise \
	wget \
	libmoose-perl \
	gawk
	
RUN apt-get clean

RUN pwd

WORKDIR /
ADD dependencies/Pfam.tar.gz /usr/share/perl5/Bio/
COPY dependencies/pfam_scan.pl /usr/bin/pfam_scan.pl


RUN mkdir /ctt && mkdir -p /ctt/databases/pfam && mkdir -p /ctt/ctt_output

WORKDIR /ctt/databases/pfam

RUN wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz \
&& gunzip Pfam-A.hmm.gz \
&& wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.dat.gz \
&& gunzip Pfam-A.hmm.dat.gz \
&& wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/active_site.dat.gz \
&& gunzip active_site.dat.gz \
&& hmmpress Pfam-A.hmm

WORKDIR /ctt


ADD annotation_modules /ctt/annotation_modules
ADD lib /ctt/lib
ADD seeds /ctt/seeds
ADD species_databases /ctt/species_databases
#ADD step2_output /ctt/step2_output
#ADD step3_output /ctt/step3_output



COPY ctt.pl /ctt/ctt.pl




ENTRYPOINT ["perl","ctt.pl"]









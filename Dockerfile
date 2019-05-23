
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


RUN mkdir /cttdocker && mkdir -p /cttdocker/databases/pfam && mkdir -p /cttdocker/ctt_output

WORKDIR /cttdocker/databases/pfam

RUN wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz \
&& gunzip Pfam-A.hmm.gz \
&& wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.dat.gz \
&& gunzip Pfam-A.hmm.dat.gz \
&& wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/active_site.dat.gz \
&& gunzip active_site.dat.gz \
&& hmmpress Pfam-A.hmm

WORKDIR /cttdocker


ADD annotation_modules /cttdocker/annotation_modules
ADD lib /cttdocker/lib


COPY ctt.pl /cttdocker/ctt.pl

ENTRYPOINT ["perl","ctt.pl"]









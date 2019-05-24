#!/usr/bin/perl
use warnings;
use strict;
use Bio::PrimarySeq;

sub genewise_text_parse {

	my ($genewises0,$pro_gdna)=@_;

	my ($pro_id,$gdna_id,$gdna)=($pro_gdna=~/>(.*)\n\w+.*>(.*)\n(\w+|\n)/s);

	my ($fs,$fe)=($gdna_id=~/fs(.*)fe(.*)bac_fd/);
	#######################
	#
	#-diana function in genewise predicted several misc_features. The one with the best gw_score is selected each time
	my $genewises=join('',@$genewises0);
	$genewises=~s/(\"|\n|\/\/|FT   )//g;

	my @genewises=split /misc_feature/,$genewises;

	my @a=();
	my @b=();

	my @sorted_genewises=sort{

		@a=split /Score /,$a;
		@b=split /Score /,$b;

		$b[1]<=>$a[1]

			}@genewises;

	my $best_gw=shift @sorted_genewises;
	
	#parse gw result

	my $gw_transcript='';
	my @coordinates=();
 
	if($best_gw=~/join/){
		
		(my $exons)=($best_gw=~/\((.*)\)/);
		my @exons=split /\,/, $exons;

		foreach my $exon(@exons){

			my ($start,$end)=($exon=~/(\d+)\.\.(\d+)/);
			my $dna=substr($gdna,($start-1),($end-$start+1));
			$gw_transcript=$gw_transcript.$dna;
                        push(@coordinates,$start,$end);
					}
			}
	else{

		my ($start,$end)=($best_gw=~/ (\d+)\.\.(\d+)/);
		$gw_transcript=substr($gdna,($start-1),($end-$start+1));
                push(@coordinates,$start,$end);

		}


	my $gw_start=shift @coordinates;
	my $gw_end=pop @coordinates;

	my ($gw_score)=($best_gw=~/Score (\d+\.\d+)/);

	
	#translate the merged $gw_transcript into a protein sequence
	my $gw_pep_obj=new Bio::PrimarySeq(-seq=>$gw_transcript);
	my $gw_pep=$gw_pep_obj->translate->seq;


	#define a pseudogene and return the gw results
	my $wise_transcript_parse;

	if($gw_end<$fs or $gw_start>$fe){

		$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."no_match"."\t"."no_bac_hit_seq"."\t"."no_genewise_transcript"."\t"."no_genewise";
	
		return $wise_transcript_parse;

		}

	else {
		
		my $gdna_gw_seq=substr($gdna,($gw_start-1),($gw_end-$gw_start+1));

		if ($gw_pep=~/X/s){	
			$gw_transcript="no_transcript_available";
			$gw_pep="no_pep_available";
			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."pseudo"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;
	
			return $wise_transcript_parse;
			}

		elsif ($gw_pep=~/\*/) {

			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."estop"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;

			return $wise_transcript_parse;
			}	

		else {

			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."pep"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;

			return $wise_transcript_parse;

			}

		} #else


}

1;





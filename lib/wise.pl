#!/usr/bin/perl
use warnings;
use strict;
use Bio::PrimarySeq;

	open WISE,"<../genewise_out";
	my @genewises0=<WISE>;
	close WISE;
my $gdna="DNA";

	my $gw=join ('',@genewises0);

print $gw,"\n\n\n";

	my ($gw_score,$gw_start,$gw_end,$gw_transcript)=($gw=~/Score (\d+\.\d+) bits.*\.\[(\d+)\:(\d+)\]\.sp\n(.*)\/\/\n/s);

$gw_transcript=~s/\n//g;

print $gw_score,"\t",$gw_start,"\t",$gw_end,"\n",$gw_transcript,"\|\n";


	my ($pro_id)=($gw=~/.*Query protein:\s+(.*)\nComp.*/s);
	my ($gdna_id)=($gw=~/.*Target Sequence\s+(.*)\nStrand.*/s);
	my ($fs,$fe)=($gdna_id=~/fs(.*)fe(.*)bac_fd/);
	my $gw_pep_obj=new Bio::PrimarySeq(-seq=>$gw_transcript);
	my $gw_pep=$gw_pep_obj->translate->seq;


	print $fs,"\t",$fe,"\n";

	my $wise_transcript_parse;

	if($gw_end<$fs or $gw_start>$fe){

		$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."no_match"."\t"."no_bac_hit_seq"."\t"."no_genewise_transcript"."\t"."no_genewise";
	

		}

	else {
		
		my $gdna_gw_seq=substr($gdna,$gw_start,($gw_end-$gw_start+1));

		if ($gw=~/pseudo gene/s){	
			$gw_transcript="no_transcript_available";
			$gw_pep="no_pep_available";
			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."pseudo"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;
	
			}

		elsif ($gw_pep=~/\*/) {

			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."estop"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;

			}	

		else {

			$wise_transcript_parse=$gw_score."\t".$gdna_id." \| ".$pro_id." \| ".$gw_start."\-".$gw_end." \| gw_score ".$gw_score." \| "."pep"."\t".$gdna_gw_seq."\t".$gw_transcript."\t".$gw_pep;


			}

		} #else



print $wise_transcript_parse,"\n";



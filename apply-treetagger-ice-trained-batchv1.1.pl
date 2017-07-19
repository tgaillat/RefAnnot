# in coprus directory place the .tokens files 
# usage:  perl apply-treetagger-batch.pl corpus training.par
use strict;
use locale;

if ( $#ARGV != 1 ){ 
    die "Usage : ", $0, " REPERTOIRE\n";
}
my $repertoire = $ARGV[0];
my $par=$ARGV[1];

opendir ( REP, $repertoire ) or 
    die "Impossible d'ouvrir ", $repertoire, " : ", $!, "\n";
my @fichiers = grep( /\.*.tok$/, readdir(REP) );
closedir ( REP );
for my $f ( @fichiers ){
    my $r = $f ;
    $r =~ s/^(.*)\.tok$/$1.ttice/;
    print STDERR $r, "\n";
    open ( ENTREE, "<", $repertoire."/".$f) or 
		warn "Erreur d'ouverture de ",$f, " :" ,$!, "\n";
	open(SORTIE, ">", $repertoire."/".$r) or die "impossible d'ouvrir ", $r;
	
    `tree-tagger -token $par  $repertoire/$f  > $repertoire/$r`;
}
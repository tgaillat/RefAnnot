#!/usr/bin/perl
use strict;
use warnings;

#multi-file processing in one folder



if ( $#ARGV != 0 ) {
    die "Usage : ", $0, " enter directory name please\n";
}

my $repertoire = $ARGV[0];


opendir ( REP, $repertoire ) or 
    die "Impossible d'ouvrir ", $repertoire, " : ", $!, "\n";
my @fichiers = readdir( REP );
closedir ( REP );


my (@tokensttice, @tagsttice);
my (@idttptb, @tokensttptb, @tagsttptb, @casettptb);	

#place each file type in an array listing the corresponding files
my @fichiersttptb= grep (/\.ttptb$/, @fichiers);
my @fichiersttice = grep (/\.ttice$/, @fichiers);


#scan ttice file types. and create an output file with .annot extension in which all merged annotations will end up
foreach my $fichierttice ( sort @fichiersttice ) {
 	my $r = $fichierttice ;
	#$r =~ s/^(.*)\.ttice$/$1.annot/;
	#print STDERR $r, "\n";
   
	open ( INTTICE, "<", $repertoire."/".$fichierttice) or 
	warn "Erreur d'ouverture de ",$fichierttice, " :" ,$!, "\n";
	

	
#throw each token tag pair in separate arrays. 
while (my $line = <INTTICE>) {
chomp $line;
        my @arrayttice = split ( /\t/, $line );
	push ( @tokensttice, $arrayttice[0] );
	push ( @tagsttice, $arrayttice[1] );
}
}

foreach my $fichierttptb ( sort @fichiersttptb ) {
 	my $r = $fichierttptb ;
	#$r =~ s/^(.*)\.tti$/$1.annot/;
	print STDERR $r, "\n";
   
	open ( INTTI, "<", $repertoire."/".$fichierttptb) or 
		warn "Erreur d'ouverture de ",$fichierttptb, " :" ,$!, "\n";
	
	
#throw each ID token tag case quadrulet in separate arrays. 

while (my $line = <INTTI>) {
chomp $line;
        my @array = split ( /\t/, $line );
	push ( @idttptb, $array[0] );
	push ( @tokensttptb, $array[1] );
	push ( @tagsttptb, $array[2] );
	push ( @casettptb, $array[3] );
}
}

# merge data from each pair of files. and create a single .annot file.
open(OUT, ">", $repertoire."/"."final.annot") or die "impossible d'ouvrir ";
	
for (my $i=0; $i <= $#tokensttice; $i++){
	if (!defined($casettptb[$i])) {
	$casettptb[$i]="NA";
		}
		print OUT $idttptb[$i],"\t", $tokensttice[$i],"\t", $tagsttice[$i],"\t", $tokensttptb[$i], "\t",$tagsttptb[$i], "\t",$casettptb[$i],"\n";
}
 

close ( INTTI );
close (INTTICE);
close ( OUT );


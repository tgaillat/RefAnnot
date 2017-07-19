#Author Gaillat Thomas.University of Paris Diderot
#Inspired from Tangy and Hathout http://perl.linguistes.free.fr/
#usage perl script.pl directory
# directory is at the same level as the perl programme. It includes texts that have been tokenized an tagged. One token and POS tag per line. 

use strict;
use locale;

#multi-file processing in one folder

if ( $#ARGV != 0 ) {
    die "Usage : ", $0, " enter directory name please\n";
}

my $repertoire = $ARGV[0];


opendir ( REP, $repertoire ) or 
    die "Impossible d'ouvrir ", $repertoire, " : ", $!, "\n";
my @fichiers = readdir( REP );
closedir ( REP );

my @fichierstt = grep (/\.tt$/, @fichiers);

#takes each  .tt file of directory and creates new file of .tti extension to indicate that these files include the index.
foreach my $fichier ( sort @fichierstt ) {
 	my $r = $fichier ;
	$r =~ s/^(.*)\.tt$/$1.ttptb/;
	print STDERR $r, "\n";
   
	open ( ENTREE, "<", $repertoire."/".$fichier) or 
		warn "Erreur d'ouverture de ",$fichier, " :" ,$!, "\n";
	open(SORTIE, ">", $repertoire."/".$r) or die "impossible d'ouvrir ", $r;

#throw each token tag pair in arrays. 
my (@tokens, @tags, @context, @discourse);

while (my $line = <ENTREE>) {
chomp $line;
        my @array = split ( /\t/, $line );
	push ( @tokens, $array[0] );
	push ( @tags, $array[1] );
	push ( @context, $array[2] );
        push ( @discourse, $array[3] );
}

# traitement du fichier	

for (my $i=0; $i <= $#tokens; $i++){

if ( $tokens[$i]=~ /^(.*)$/ ){
	if (($tokens[$i] =~/^[T|t]his$/ ) or ($tokens[$i] =~/^[T|t]hat$/) or ($tokens[$i] =~/^[I|i]t$/) or ($tokens[$i] =~/^[T|t]hese$/) or /^[T|t]hose$/) {
		  my $position = "NA";    
		  # check if it is followed by a modal or a verb or by an adverb or repeated proform and a verb or modal.
		if ($tags[$i] =~ /TPRON|PRP/) {
			if (
				($tags[$i-1] =~ /MD/) 
				or (($tags[$i-1] =~ /^do$|^does$|^am$|^are$|^is$|^was$|^were$/) and (
						($tags[$i+1] =~ /^JJ$|^VB$|^VBG$/) 
						or (($tags[$i+1] =~ /^RB$/) and ($tags[$i+2] =~ /^|^VB$|^VBG$/))) 
				or ($tags[$i+1] =~ /V.*|MD|NNS|POS/) 
				or (($tags[$i+1] =~ /RB|TPRON|PRP/) and ($tags[$i+2] =~ /V.*|MD|NNS|POS/)
					)
				)
			) {   	      
			$position = "NOMI";                                                                             
			}
			else {
			$position="OBLI";
			}
		}
      #Check the form is a DT
		elsif (($tags[$i] =~ /DT/) and (($tags[$i+1] =~ /NN.*/) 
								or (($tags[$i+1] =~ /JJ|DT/) and ($tags[$i+2] =~ /NN.*/)))) {
			if (
				($tags[$i-1] =~ /MD/) 
				or (($tags[$i-1] =~ /^do$|^does$|^am$|^are$|^is$|^was$|^were$/) and (
						($tags[$i+1] =~ /^JJ$|^VB$|^VBG$/) 
						or (($tags[$i+2] =~ /^RB$/) and ($tags[$i+3] =~ /^|^VB$|^VBG$/))) 
				or ($tags[$i+2] =~ /V.*|MD|NNS|POS/) 
				or (($tags[$i+2] =~ /RB|TPRON|PRP/) and ($tags[$i+3] =~ /V.*|MD|NNS|POS/)
					)
				)
			) {   	      
			$position = "NOMI";                                                                             
			}
			else {
			$position="OBLI";
			}
		}
		
	#print all tags .Eliminated ENDO EXO tag
		print SORTIE $r."-".$i ,"\t", $tokens[$i],"\t", $tags[$i],"\t", $position,"\n";
		}
		
else {
		print SORTIE $r."-".$i ,"\t", $tokens[$i],"\t", $tags[$i],"\n";
		}
	}
	
	

}


close ( ENTREE );
        close ( SORTIE );
}
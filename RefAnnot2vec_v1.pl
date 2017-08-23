#Author Gaillat Thomas.University of Paris Diderot
#Inspired from Tangy and Hathout http://perl.linguistes.free.fr/
#usage perl TT2seq_feat_3grams.pl directory
# directory is at the same level as the perl programme. It includes texts that have been tokenized and tagged. One token and POS tag per line. 
#_3grams_context_position 
#usage perl RefAnnot2vec_v1.pl corpus
#place all annotated files in corpus directory
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

my @fichierstt = grep (/\.annot$/, @fichiers);

foreach my $fichier ( sort @fichierstt ) {
 	my $r = $fichier ;
	$r =~ s/^(.*)\.annot$/$1.vec/;
	print STDERR $r, "\n";
   
	open ( ENTREE, "<", $repertoire."/".$fichier) or 
		warn "Erreur d'ouverture de ",$fichier, " :" ,$!, "\n";
	open(SORTIE, ">", $repertoire."/".$r) or die "impossible d'ouvrir ", $r;
	print SORTIE "id",	"\t","tagsPTB","\t","tagsICE","\t",
	"tokens[-3]","\t", "tagsPTB[-3]","\t", "tagsICE[-3]", 		
	"\t", "tokens[-2]","\t", "tagsPTB[-2]","\t", "tagsICE[-2]",
	
	"\t","tokens[-1]",	"\t", "tagsPTB[-1]","\t", "tagsICE[-1]",
	"\t", "tokens[+1]","\t", "tagsPTB[+1]","\t","tagsICE[+1]",
	
	"\t", "tokens[+2]","\t", "tagsPTB[+2]","\t", "tagsICE[+2]",
	"\t", "tokens[+3]","\t", "tagsPTB[+3]","\t", "tagsICE[+3]",
	
	
	"\t", "tagsCASE",
	
	"\t", "featVBZ","\t", "featED","\t", "featNOT", "\t", "featCC", "\t", "featCAP", "\t", "featPUNC",
	"\t", "featREFNN", "\t","featREFPRON", "\t","featREFWH", "\t", "featPREPINT", "\t", "featPREPPOST",
	"\t","tokens",
	
	"\n";
#throw each token tag pair in arrays. 
my (@id, @tokens, @tagsICE, @tokens2,@tagsPTB, @tagsCASE);

while (my $line = <ENTREE>) {
chomp $line;
        my @array = split ( /\t/, $line );
	push ( @id, $array[0] );
	push ( @tokens, $array[1] );
	push ( @tagsICE, $array[2] );
	push ( @tokens2, $array[3] );
        push ( @tagsPTB, $array[4] );
	 push ( @tagsCASE, $array[5] );
	
}
#place features as n-3 and n+3 around each it this and that and also the ENDO/EXO feat and the positional feature OBLI or NOMI
for (my $i=0; $i <= $#tokens; $i++){
	
	my $featVBZ="-";
	my $featED = "-";
	my $featNOT = "-"; 
	my $featCC = "-";
	my $featPUNC = "-";
	my $featCAP = "-";
	my $featREFNN="-";
	my $featREFPRON="-";
	my $featREFWH="-";
	my $featPREPINT = "-";
	my $featPREPPOST = "-";
	
	if (!defined($tagsCASE[$i])) {
	$tagsCASE[$i]="-";
		}

	
	if (($tokens[$i] =~/^[T|t]his$/ ) or ($tokens[$i] =~/^[T|t]hat$/) or ($tokens[$i] =~/^[I|i]t$/) or ($tokens[$i] =~/^[T|t]hese$/) or  ($tokens[$i] =~/^[T|t]hose$/)) {
		  
		

		#If the form is a proform or a pronoun
		if ($tagsPTB[$i] =~ /TPRON|PRP/) {
			
			#Propriétés énonciatives. Rupture avec le plan de l'énonciation en utilisant le preterit. Non rupture avec l'usage du présent. Rejet émanant de l'énonciateur en utilisant la négation. Focus change/contrasting with "and"
			
			# if there is VBP or VBZ
			if (($tagsPTB[$i-3] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i-2] =~  /^VBP$|^VBZ$/) or ($tagsPTB[$i-1] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i+3] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i+2] =~  /^VBP$|^VBZ$/) or ($tagsPTB[$i+1] =~ /^VBP$|^VBZ$/)) {    
			$featVBZ = "VBZ";
			}
			
			#if there is an ED form in the close context
			
			if (($tagsPTB[$i-3] =~ /VBD/) or ($tagsPTB[$i-2] =~  /VBD/) or ($tagsPTB[$i-1] =~ /VBD/) or ($tagsPTB[$i+3] =~ /VBD/) or ($tagsPTB[$i+2] =~  /VBD/) or ($tagsPTB[$i+1] =~ /VBD/)) {    
			$featED = "ED";
			}
	
			# Negation in close context
			
			if (($tokens[$i-3] =~ /n\'t|[N|n]ot/) or ($tokens[$i-2] =~  /n\'t|[N|n]ot/) or ($tokens[$i-1] =~ /n\'t|[N|n]ot/) or ($tokens[$i+3] =~ /n't|[N|n]ot/) or ($tokens[$i+2] =~  /n\'t|[N|n]ot/) or ($tokens[$i+1] =~ /n\'t|[N|n]ot/)) {    
			$featNOT = "NOT";
			}
			
			if (($tagsPTB[$i-3] =~ /CC/) or ($tagsPTB[$i-2] =~  /CC/) or ($tagsPTB[$i-1] =~ /CC/) or ($tagsPTB[$i+3] =~ /CC/) or ($tagsPTB[$i+2] =~  /CC/) or ($tagsPTB[$i+1] =~ /CC/)) {    
			$featCC = "CC";
			}
			
			#Text properties. The start of a new utterance.
			# Capital letter on the token
			if  ($tokens[$i]=~/[A-Z]/){
			$featCAP= "CAP";
			}	
			
			# Close to start or end of sentence/utterance
			if (($tagsPTB[$i-3] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i-2] =~  /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i-1] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+3] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+2] =~  /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+1] =~ /"|\.|\.\.|\.\.\.|\?/)) {    
			$featPUNC = "PUNC";
			}
			
			
			#Endophora related properties.
			#The presence of other referential or endophoric items: Potential co-referentiality. 
			#NN NNS NNP TREL PRP TPRON
			if (($tagsPTB[$i-3] =~ /^NN[P|S]?$/) or ($tagsPTB[$i-2] =~  /^NN[P|S]?$/) or ($tagsPTB[$i-1] =~ /^NN[P|S]?$/) or ($tagsPTB[$i+3] =~ /^NN[P|S]?$/) or ($tagsPTB[$i+2] =~  /^NN[P|S]?$/) or ($tagsPTB[$i+1] =~ /^NN[P|S]?$/)) {    
			$featREFNN = "REFNN";
			}
			
			if (($tagsPTB[$i-3] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i-2] =~  /^PRP$|^TPRON$/) or ($tagsPTB[$i-1] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i+3] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i+2] =~  /^PRP$|^TPRON$/) or ($tagsPTB[$i+1] =~ /^PRP$|^TPRON$/)) {    
			$featREFPRON = "REFPRON";
			}
			
			if (($tagsPTB[$i-3] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i-2] =~  /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i-1] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+3] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+2] =~  /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+1] =~ /^TREL$|^WDT$|^WP.?$/)) {    
			$featREFWH = "REFWH";
			}
			
			#Positional properties around the form
			#Introductory preposition
			if ($tagsPTB[$i-1] =~ /^TO$|^IN$/) {    
			$featPREPINT = "PREPINT";
			}
			#Prep after the form
			if ($tagsPTB[$i+1] =~ /^TO$|^IN$/) {    
			$featPREPPOST = "PREPPOST";
			}
			
			
		}
		
		
		#OTHERWISE IF the form is a DT
		elsif (($tagsPTB[$i] =~ /DT/) and (($tagsPTB[$i+1] =~ /NN.*/) 
								or (($tagsPTB[$i+1] =~ /JJ|DT/) and ($tagsPTB[$i+2] =~ /NN.*/)))) {
			
			
			#Propriétés énonciatives. Rupture avec le plan de l'énonciation en utilisant le preterit. Non rupture avec l'usage du présent. Rejet émanant de l'énonciateur en utilisant la négation. 
			
			# if there is VB or VBZ
			if (($tagsPTB[$i-3] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i-2] =~  /^VBP$|^VBZ$/) or ($tagsPTB[$i-1] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i+4] =~ /^VBP$|^VBZ$/) or ($tagsPTB[$i+3] =~  /^VBP$|^VBZ$/) or ($tagsPTB[$i+2] =~ /^VBP$|^VBZ$/)) {    
			$featVBZ = "VBZ";
			}
			
			#if there is an ED form in the close context
			
			if (($tagsPTB[$i-3] =~ /VBD/) or ($tagsPTB[$i-2] =~  /VBD/) or ($tagsPTB[$i-1] =~ /VBD/) or ($tagsPTB[$i+4] =~ /VBD/) or ($tagsPTB[$i+3] =~  /VBD/) or ($tagsPTB[$i+2] =~ /VBD/)) {    
			$featED = "ED";
			}
	
			# Negation in close context
			
			if (($tokens[$i-3] =~ /n\'t|[N|n]ot/) or ($tokens[$i-2] =~  /n\'t|[N|n]ot/) or ($tokens[$i-1] =~ /n\'t|[N|n]ot/) or ($tokens[$i+4] =~ /n't|[N|n]ot/) or ($tokens[$i+3] =~  /n\'t|[N|n]ot/) or ($tokens[$i+2] =~ /n\'t|[N|n]ot/)) {    
			$featNOT = "NOT";
			}
			
			if (($tagsPTB[$i-3] =~ /CC/) or ($tagsPTB[$i-2] =~  /CC/) or ($tagsPTB[$i-1] =~ /CC/) or ($tagsPTB[$i+4] =~ /CC/) or ($tagsPTB[$i+3] =~  /CC/) or ($tagsPTB[$i+2] =~ /CC/)) {    
			$featCC = "CC";
			}
			
			#Text properties. The start of a new utterance.
			# Capital letter on the token
			if  ($tokens[$i]=~/[A-Z]/){
			$featCAP= "CAP";
			}	
			
			# Close to start or end of sentence/utterance
			if (($tagsPTB[$i-3] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i-2] =~  /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i-1] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+4] =~ /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+3] =~  /"|\.|\.\.|\.\.\.|\?/) or ($tagsPTB[$i+2] =~ /"|\.|\.\.|\.\.\.|\?/)) {    
			$featPUNC = "PUNC";
			}
			
			
			#Endophora related properties.
			#The presence of other referential or endophoric items: Potential co-referentiality. 
			#NN NNS NNP TREL PRP TPRON
			if (($tagsPTB[$i-3] =~ /^NN[P|S]?$/) or ($tagsPTB[$i-2] =~  /^NN[P|S]?$/) or ($tagsPTB[$i-1] =~ /^NN[P|S]?$/) or ($tagsPTB[$i+4] =~ /^NN[P|S]?$/) or ($tagsPTB[$i+3] =~  /^NN[P|S]?$/) or ($tagsPTB[$i+2] =~ /^NN[P|S]?$/)) {    
			$featREFNN = "REFNN";
			}
			
			if (($tagsPTB[$i-3] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i-2] =~  /^PRP$|^TPRON$/) or ($tagsPTB[$i-1] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i+4] =~ /^PRP$|^TPRON$/) or ($tagsPTB[$i+3] =~  /^PRP$|^TPRON$/) or ($tagsPTB[$i+2] =~ /^PRP$|^TPRON$/)) {    
			$featREFPRON = "REFPRON";
			}
			
			if (($tagsPTB[$i-3] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i-2] =~  /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i-1] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+4] =~ /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+3] =~  /^TREL$|^WDT$|^WP.?$/) or ($tagsPTB[$i+2] =~ /^TREL$|^WDT$|^WP.?$/)) {    
			$featREFWH = "REFWH";
			}
			
			#Positional properties  of the form
			#Introductory preposition
			if ($tagsPTB[$i-1] =~ /^TO$|^IN$/) {    
			$featPREPINT = "PREPINT";
			}
			# Prep after the use of the NP 
			if (($tagsPTB[$i+1] =~ /^TO$|^IN$/) or ($tagsPTB[$i+2] =~/^TO$|^IN$/)){    
			$featPREPPOST = "PREPPOST";
			}
			
					
		}
	print SORTIE $id[$i], 
	
	"\t",$tagsPTB[$i],
	"\t",$tagsICE[$i],
	
	"\t", $tokens[$i-3],
	"\t", $tagsPTB[$i-3], 
	"\t", $tagsICE[$i-3], 
		
	"\t", $tokens[$i-2],
	"\t", $tagsPTB[$i-2],
	"\t", $tagsICE[$i-2],
	
	"\t",$tokens[$i-1],
	"\t", $tagsPTB[$i-1],
	"\t", $tagsICE[$i-1],
	
	"\t", $tokens[$i+1],
	"\t", $tagsPTB[$i+1],
	"\t", $tagsICE[$i+1],
	
	"\t", $tokens[$i+2],
	"\t", $tagsPTB[$i+2],
	"\t", $tagsICE[$i+2],
	
	"\t", $tokens[$i+3],
	"\t", $tagsPTB[$i+3],
	"\t", $tagsICE[$i+3],
	
	
	"\t", $tagsCASE[$i],
	
	"\t", $featVBZ,"\t", $featED,"\t", $featNOT, "\t", $featCC, "\t", $featCAP, "\t", $featPUNC,
	"\t", $featREFNN, "\t",$featREFPRON, "\t",$featREFWH, "\t", $featPREPINT, "\t", $featPREPPOST,
	"\t",$tokens[$i],
	
	"\n";
	}
}
close ( ENTREE );
        close ( SORTIE );
}
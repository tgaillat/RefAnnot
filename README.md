# RefAnnot
RefAnnot is a bundle of PERL program to apply referential annotation and POS to any corpus of texts. It is deisgned to include learner-specific annotation for the treatment of this, that and it. They constitute a microsystem which poses problems to learners of English.
This qpp takes raw text as input and outputs column format files including the annotations.
Text files should not include ID names within text bodies. Use txt ID name as filename.
 
USAGE 
Create a "corpus" directory at the same level of all .pl programs
place all raw text files in corpus directory. give them extension .txt

To run type: perl runner.pl corpus in the command line

REQUIREMENT:
Linux systems with preinstalled treetagger program http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/
 
The sequence of programs is as follows:
Text normalisation (deals with hexadecimal characters) (. txtn files)
tokenise files (-> .toks files)
apply treetagger with modified PTB (.ttptb files)
index and apply case annotation 
apply treetagger with ICE tagset (-> .ttice files)
merge-files (creates one "final.annot" file)

The RefAnnot2vec_v1.pl program is an addon that converts annotated texts into vectors. All occurrences of it, this and that is extracted from all annotated texts and; for each one of them, a vector of features is constructed. the result is a vector matrix that can be used in Machine Learning analysis.

Copygight Thomas Gaillat 
University of Rennes
University of Sorbonne Paris Cité
Insight Centre for Data Analytics - National University of Ireland/NUIG Galway



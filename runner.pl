# runner.pl
#this script encapsulates all programs necessary to add referential annotation
use strict;
use warnings;
$| = 1;
my @scripts = ('normalize-batch.pl corpus', 
'batch-tokenize.pl -e corpus', 
'delete-first-line-per-file-batch.pl corpus',
'apply-treetagger-batchv1.1.pl corpus wsj.training.newtags.it_PNR.this.that.ldtags.par',
'index_and_caseannotate_TT.pl corpus', 
'apply-treetagger-ice-trained-batchv1.1.pl corpus icegb.par', 
'merge-files.pl corpus',
);
for my $scr (@scripts) {
    my $cmd = "$^X $scr";
    print "Run '$cmd'...";
    my $out = qx{$cmd};
    my $rc = $? >> 8;
    print "rc=$rc\n";
    print "Output:$out\n";
    if ($rc != 0) {
        print "Main script $0 exit $rc\n";
        exit $rc;
    }
}
print "All commands finished successfully.\n";

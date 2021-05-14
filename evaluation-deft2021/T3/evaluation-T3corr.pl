# Script d'évaluation DEFT 2021 pour la T3 (évaluation de réponses
# d'étudiants à partir de réponses déjà corrigées par l'enseignant)

# Trois fichiers :
# (pas dans cette version )  - le corpus fourni aux participants avec amorces et A_COMPLETER
# - la référence de ce fichier avec les notes au lieu de A_COMPLETER
# - la sortie d'un système
# On évalue uniquement les prédictions sur les lignes A_COMPLETER

# perl evaluation-T3.pl corpus-test.tab corpus-ref.tab sortie-systeme
# perl evaluation-T3.pl testT3-R.tab evalT3-R.tab sortie-systeme

use strict;
use Statistics::Basic::Correlation;
use Statistics::Basic qw(:all nofill);
# sudo cpan install  Statistics::Basic::Correlation

my ($fref,$fent)=@ARGV;
my @ALLE;
my @ALLR;
my $nent=0;
my $nref=0;

open(ENTREE,$fent) or die "Impossible d'ouvrir $fent\n";
while(my $ligne=<ENTREE>){
	chomp $ligne;
	my ($num,$note,$etud,$reponse)=split(/\t/,$ligne);
        $ALLE[$nent++]=$note;
}
close(ENTREE);

open(REF,$fref) or die "Impossible d'ouvrir $fref\n";
while(my $ligne=<REF>){
	chomp $ligne;
	my ($num,$note,$etud,$reponse)=split(/\t/,$ligne);
        $ALLR[$nref++]=$note;
}
close(REF);

print "$nent ~ $nref\n $#ALLE ~ $#ALLR \n";
my $correlation = correlation(\@ALLE, \@ALLR);
print $correlation, "\n";

my @T;
my @V;
$T[0]=1; $T[1]=2; $T[3]=3;
$V[0]=1; $V[1]=2; $V[3]=3;
my $cor = correlation(\@T, \@V);
print $cor, "\n";




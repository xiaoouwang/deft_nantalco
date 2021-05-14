# Script d'évaluation DEFT 2021 pour la T2 (évaluation de réponses
# d'étudiants à partir des corrections de l'enseignant)

# Deux fichiers :
# - le fichier avec les notes de référence
# - la sortie d'un système

# perl evaluation.pl Train/T2/trainT2-R.tab sortie-baseline


use strict;

my ($ref,$hyp)=@ARGV;
my (%noteR,%noteE,%allR,%allE,%Qcorr,%Qincorr,%Qall,%scoreE,%scoreNonE);


###
# Récupération des notes de référence
#
# 1001    0.5     student101      Ce sont les pages web accessible par tout navigateur.\n
# 1001    0       student108      Un réseau mondial   \n
# 1001    1       student3            C'est le systeme hypertexte qui sert à consulter des documents et des pages hébergés sur le réseau internet\n
# 1001    0       student49       NO_ANS

open(E,$ref);
while (my $ligne=<E>) {
    chomp $ligne;
    my ($num,$ref,$etud,$rep)=split(/\t/,$ligne);
    $noteR{"$num§$etud"}=$ref;
    $allR{"$num§$etud"}=$ligne;
    $Qall{$num}++;
}
close(E);


###
# Récupération des prédictions

open(E,$hyp);
while (my $ligne=<E>) {
    chomp $ligne;
    my ($num,$ref,$etud,$rep)=split(/\t/,$ligne);
    $noteE{"$num§$etud"}=$ref;
    $allE{"$num§$etud"}=$ligne;
}
close(E);

my ($corr,$incorr)=(0,0);
foreach my $ligne (sort keys %noteR) {
    my ($num,$etud)=split(/§/,$ligne);
    my @reponse=split(/\t/,$allR{$ligne});
    # Soit on décide de ne pas compter juste les NO_ANS
    #if (exists $noteE{$ligne} && $reponse[3] ne "NO_ANS") {
    # Soit on les prend en compte
    if (exists $noteE{$ligne}) {
	if ($noteR{$ligne}==$noteE{$ligne}) { $corr++; $Qcorr{$num}++; $scoreE{$etud}++; }
	else { $incorr++; $Qincorr{$num}++; $scoreNonE{$etud}++; }
    }
}


###
# Affichage

# Evaluation globale
my $precision=sprintf("%.3f",$corr/($corr+$incorr));
print "Il y a $corr évaluations correctes et $incorr évaluations incorrectes\n";
print "Soit une précision de $precision\n";

# Evaluation par question
print "\nListe des questions faciles :\n";
foreach my $num (sort keys %Qall) {
    my $precision=sprintf("%.3f",$Qcorr{$num}/($Qall{$num}));
    print "- Question $num\tP=$precision\n" if ($precision>=0.7);
}

# Y a t-il des étudiants plus faciles à corriger que d'autres ?
print "\nListe des étudiants pour lesquels il est difficile de corriger :\n";
foreach my $etud (sort keys %scoreE) {
    my $precision=sprintf("%.3f",$scoreE{$etud}/($scoreNonE{$etud}));
    print "- Etudiant $etud\t$scoreE{$etud} réponses correctement évaluées\n" if ($precision<=0.45);
}

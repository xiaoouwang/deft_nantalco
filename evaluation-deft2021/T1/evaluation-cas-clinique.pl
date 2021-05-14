# Prend en entrée la référence (classes-train-v2.txt) et l'hypothèse
# (sortie-system). Les deux fichiers sont au format tabulaire en trois
# colonnes : nom du fichier, nom simplifié du chapitre du MeSH, un
# exemple issu du texte pour ce chapitre et ce fichier

# perl evaluation-cas-clinique.pl classes-train-v2.txt sortie-systeme


my ($reference,$hypothese)=@ARGV;
my %ref;
my %hyp;
my %listeChapitres;


###
# Récupération de la référence

open(E,$reference) or die "Impossible d'ouvrir $reference\n";
while (my $ligne=<E>) {
    chomp $ligne;
    my ($fichier,$chapitre,$exemple)=split(/\t/,$ligne);
    $ref{"$fichier§$chapitre"}++;
}
close(E);


###
# Récupération de l'hypothèse

open(E,$hypothese) or die "Impossible d'ouvrir $hypothese\n";
while (my $ligne=<E>) {
    chomp $ligne;
    my ($fichier,$chapitre,$exemple)=split(/\t/,$ligne);
    $hyp{"$fichier§$chapitre"}++;
    $listeChapitres{$chapitre}++;
}
close(E);


###
# Evaluation
# - par chapitre sur l'ensemble des fichiers
# - par fichier : est-ce que tous les chapitres de ce fichier ont été trouvés, permet d'identifier les fichiers complexes

my (%vp,%fn,%fp,%precision,%total);

foreach my $ligne (sort keys %ref) {
    my ($fichier,$chapitre)=split(/§/,$ligne);
    # Vrai positif si trouvé dans l'hypothèse
    if (exists $hyp{$ligne}) { $vp{"$chapitre"}++; $precision{"$fichier"}++; $total{"$fichier"}++; }
    # Sinon, faux négatif
    else { $fn{"$chapitre"}++; $total{"$fichier"}++; }
}
foreach my $ligne (sort keys %hyp) {
    my ($fichier,$chapitre)=split(/§/,$ligne);
    # Faux positif si absent de la référence
    if (!exists $ref{$ligne}) { $fp{"$chapitre"}++; }
}

###
# Résultats

print "EVALUATION PAR FICHIER\n";
foreach my $fichier (sort keys %precision) {
    my $prec=0; if (($total{$fichier})>0) { $prec=sprintf("%.3f",($precision{$fichier}/$total{$fichier})); }
    my $j=""; for (my $i=length("$fichier");$i<25;$i++) { $j.="."; }
    print "- $fichier $j\tP=$prec\n";
}
print "\n";


print "EVALUATION PAR CHAPITRE\n";
my ($toutVP,$toutFP,$toutFN);
foreach my $chapitre (sort keys %listeChapitres) {
    my $rappel=0; if (($vp{"$chapitre"}+$fn{"$chapitre"})>0) { $rappel=sprintf("%.3f",($vp{"$chapitre"}/($vp{"$chapitre"}+$fn{"$chapitre"}))); }
    my $prec=0; if (($vp{"$chapitre"}+$fp{"$chapitre"})>0) { $prec=sprintf("%.3f",($vp{"$chapitre"}/($vp{"$chapitre"}+$fp{"$chapitre"}))); }
    my $fmes=0; if (($vp{"$chapitre"}+$fp{"$chapitre"}+$fn{"$chapitre"})>0) { $fmes=sprintf("%.3f",(2*$vp{"$chapitre"}/(2*$vp{"$chapitre"}+$fp{"$chapitre"}+$fn{"$chapitre"}))); }
    $toutVP+=$vp{"$chapitre"}; $toutFP+=$fp{"$chapitre"}; $toutFN+=$fn{"$chapitre"};
    # Affichage
    my $j=""; for (my $i=length($chapitre);$i<20;$i++) { $j.="."; }
    print "- $chapitre $j\tR=$rappel\tP=$prec\tF=$fmes\n";
}

my $rappel=0; if (($toutVP+$toutFN)>0) { $rappel=sprintf("%.3f",($toutVP/($toutVP+$toutFN))); }
my $prec=0; if (($toutVP+$toutFP)>0) { $prec=sprintf("%.3f",($toutVP/($toutVP+$toutFP))); }
my $fmes=0; if (($toutVP+$toutFP+$toutFN)>0) { $fmes=sprintf("%.3f",(2*$toutVP/(2*$toutVP+$toutFP+$toutFN))); }
# Affichage résultat global
my $j=""; for (my $i=length("EVALUATION GLOBALE");$i<22;$i++) { $j.="."; }
print "EVALUATION GLOBALE $j\tR=$rappel\tP=$prec\tF=$fmes\n\n";




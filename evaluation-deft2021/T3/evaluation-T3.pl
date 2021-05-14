# Script d'évaluation DEFT 2021 pour la T3 (évaluation de réponses
# d'étudiants à partir de réponses déjà corrigées par l'enseignant)

# Trois fichiers :
# - le corpus fourni aux participants avec amorces et A_COMPLETER
# - la référence de ce fichier avec les notes au lieu de A_COMPLETER
# - la sortie d'un système
# On évalue uniquement les prédictions sur les lignes A_COMPLETER

# Un fichier log est produit, en reprenant le contenu du fichier
# traité par le système, auquel sont ajoutées trois colonnes :
# correct/erreur, la note de référence, la note du système

# perl evaluation-T3.pl corpus-test.tab corpus-ref.tab sortie-systeme
# perl evaluation-T3.pl testT3-R.tab evalT3-R.tab sortie-systeme

use strict;

my ($entree,$ref,$hyp)=@ARGV;
my (%eval,%noteRef,%noteHyp,%Qall,%Qcorr,%Qincorr,%Nall,%Ncorr,%Nincorr,%out)=();
my ($corr,$incorr)=(0,0);

recuperationIdentifiants();
recuperationReference();
recuperationPredictions();
comparaisons();
evaluations();


###
# Routines

sub evaluations() {
    # Evaluation globale
    my $precision=sprintf("%.3f",$corr/($corr+$incorr));
    print "Evaluation globale :\tP=$precision \t($corr corrects, $incorr incorrects)\n";
    # Evaluation par question
    foreach my $num (sort keys %Qall) {
	$precision=sprintf("%.3f",$Qcorr{$num}/($Qcorr{$num}+$Qincorr{$num}));
	print "- Question $num :\tP=$precision \t($Qcorr{$num} corrects, $Qincorr{$num} incorrects)\n";
    }
    # Evaluation par note
    my $liste="";
    foreach my $note (sort keys %Nall) {
	$precision=sprintf("%.3f",$Ncorr{$note}/($Ncorr{$note}+$Nincorr{$note}));
	#print "- Note $note :\tP=$precision \t($Ncorr{$note} corrects, $Nincorr{$note} incorrects)\n";
	$liste.="$note\, " if ($precision==0);
    }
    chop $liste; chop $liste;
    print "Le système n'a pas été capable de prédire correctement les notes suivantes : $liste\n";
}

sub comparaisons() {
    my $log=$hyp.".log";
    open(S,">$log");
    foreach my $ligne (sort keys %noteRef) {
	my ($num,$etud)=split(/§/,$ligne);
	my $noteR=$noteRef{$ligne};
	my $noteH=$noteHyp{$ligne};
	#warn "Question $num, $etud\tref=$noteR\thyp=$noteH\n";
	print S "$out{$ligne}\t";
	if ($noteR==$noteH) { $corr++; $Qcorr{$num}++; $Ncorr{$noteR}++; print S "correct\t$noteR\t$noteH\n"; }
	else { $incorr++; $Qincorr{$num}++; $Nincorr{$noteR}++; print S "erreur\t$noteR\t$noteH\n"; }
    }
    close(S);
}

sub recuperationIdentifiants() {
    # Récupération des identifiants (numéro question et numéro
    # étudiant) des lignes à évaluer (celles dont les notes sont
    # A_COMPLETER) dans %eval, et récupération des numéros des
    # questions dans %Qall pour l'évaluation par question
    open(E,$entree) or die "Impossible d'ouvrir $entree\n";
    while (my $ligne=<E>) {
	chomp $ligne;
	my ($num,$note,$etud,$reponse)=split(/\t/,$ligne);
	if ($note eq "A_COMPLETER") { $eval{"$num§$etud"}++; }
	$Qall{$num}++;
	$out{"$num§$etud"}=$ligne;
    }
    close(E);
}

sub recuperationReference() {
    # Récupération des notes de référence pour les lignes à évaluer,
    # d'après la liste d'identifiants précédemment constituée
    open(E,$ref) or die "Impossible d'ouvrir $ref\n";
    while (my $ligne=<E>) {
	chomp $ligne;
	my ($num,$note,$etud,$reponse)=split(/\t/,$ligne);
	if (exists $eval{"$num§$etud"}) { $noteRef{"$num§$etud"}=$note; }
	$Nall{$note}++;
    }
    close(E);
}

sub recuperationPredictions() {
    # Récupération des notes de la prédiction pour les lignes à
    # évaluer, d'après la liste d'identifiants précédemment constituée
    open(E,$hyp) or die "Impossible d'ouvrir $hyp\n";
    while (my $ligne=<E>) {
	chomp $ligne;
	my ($num,$note,$etud,$reponse)=split(/\t/,$ligne);
	if (exists $eval{"$num§$etud"}) { $noteHyp{"$num§$etud"}=$note; }
    }
    close(E);
}

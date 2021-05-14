Le répertoire T2 contient les données pour la tâche T2 - Corriger à partir d'elément de correction

trainT2-Q
---------
Ce fichier contient les questions.
Colonnes :
numéroQ	noteMaxOri	nomQ	texteQuestion	EltCorrections

NB. la noteMax est juste là pour expliquer les divisions de barème étranges (s'il en reste)
les eltCorrections : contiennent souvent la réponses, suivi de réponses possible, ou moins bonne avec un barème. (Le format est libre, on notera que les \n, etc. font partie du formatage pas de la réponse)

trainT2-R
---------
Ce fichier contient les propositions des étudiants.
Colonnes :
numéroQ	noteObtenue	nomE	texteRep

NB. la noteObtenue estcomprise entre 0 et 1
les nom d'étudiants des question 1000 ne correspondent pas forcément à ceux des questions 2000

-----------------------------------------------------------------------------------------------------

Le répertoire T3 contient les données pour la tâche T3 - poursuivre une correction



trainT3-Q
---------
Ce fichier contient les questions.
Colonnes :
numéroQ	noteMaxOri	nomQ	texteQuestion	EltCorrections

NB. la noteMax est juste là pour expliquer les divisions de barème étranges (s'il en reste)
les eltCorrections : sont figés à NO_COR puisque vous devez supposer que vous en avez corrigé un certain nombre et corriger le reste en fonction...

trainT3-R
---------
Ce fichier contient les propositions des étudiants.
Colonnes :
numéroQ	noteObtenue	nomE	texteRep

NB. la noteObtenue estcomprise entre 0 et 1
les nom d'étudiants des questions 5000+ ne correspondent pas forcément à ceux des questions 2000+


Pour l'évaluation
-----------------

Tache 2 :
---------

vous receverez 2 fichiers testT2-Q testT2-R avec des A_COMPLETER
* le  testT2-Q aura le même format que précédemment à la place de la noteMaxOri vous devrez compléter en estimant le nombre de réponses minimales bien corrigées.
Un critère sera : vous viserez de ne pas avoir de réponses surnotées.

exemple (issu du train)

1009	A_COMPLETER	9	<p>En HTML5, dans quelle balise est-il souhaitable de placer le code d'un menu de navigation ?<br></p>	<p>nav<br></p>

* le  testT2-R aura le même format que précédemment à la place de la noteE vous devrez compléter en
estimant le nombre de réponses que vous êtes sûr d'avoir bien corrigées.
Un critère sera : vous viserez de ne pas avoir de réponses surnotées.


exemple (issu du train) il n'yaura que des A_COMPLETER dans la deuxième colonne

...
1009	A_COMPLETER	student13	    <nav></nav>\n
1009	A_COMPLETER	student3	     Dans une balise nav\n
1009	A_COMPLETER	student46	    On place ce menu dans la balise head.\n
...


Tache 3 :
---------

vous receverez 2 fichiers testT3-Q testT3-R avec des A_COMPLETER
* le  testT3-Q aura le même format que précédemment à la place de la noteMaxOri vous devrez compléter en estimant le nombre de réponses minimales bien corrigées.
Un critère d'évaluation sera : vous viserez de ne pas avoir de réponses surnotées.

exemple (issu du train)
5013	A_COMPLETER	Séparation contenu / présentation	<p>Indiquez trois outils qui peuvent être utilisés pour faire la séparation entre contenu et présentation et avoir une présentation

* le  testT3-R aura le même format que précédemment à la place de la noteE vous devrez compléter en
estimant le nombre de réponses que vous êtes sûr d'avoir bien corrigées.
Un critère sera : vous viserez de ne pas avoir de réponses surnotées.


exemple (issu du train) il y aura des A_COMPLETER et des notes (1 dans l'exemple ci-dessous) dans la deuxième colonne


...
1009	A_COMPLETER	student13	    <nav></nav>\n
1009	1	student3	     Dans une balise nav\n
1009	A_COMPLETER	student46	    On place ce menu dans la balise head.\n
...

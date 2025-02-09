---
title: Formules Excel ou LibreOffice pour prêts / Fonction LET
lang: fr
tags:
- Excel
- LibreOffice
categories:
- Informatique
modules: asciimath
toc: 'yes'
date: '2025-02-09 18:40:11'
image: files/2025/FonctionLet.jpg
---

J'ai découvert récemment une nouvelle fonction Excel / LibreOffice que je ne connaissais pas, et qui s'est révélée très pratique par exemple pour des simulations de prêts, et des analyses qui seraient un peu complexes avec un tableau d'amortissement complet.

# La fonction LET
La fonction LET est assez récente (LibreOffice > 24.8 et Excel 2021), mais très pratique pour éviter de dupliquer les références dans les formules complexes, mais également rendre plus lisibles les formules en donnant un nom explicite aux variables.

```Excel
=LET(
      Nom_1 ; Valeur_1 ;
      [ Nom_n ; Valeur_n ; ]
      Expression
    )
```

Le principe de la fonction LET  est assez simple :
 - Les premiers arguments vont par paire, le premier défini le nom de la variable, et le second la valeur ; la valeur peut être toute expression calculée faisant référence à d'autres cellules, des formules, ou des noms de variables définis précédemment
 - Le dernier argument correspond à la valeur renvoyée (et peut également être n'importe quelle expression, calcul, avec références vers des cellules, usages des variables définies dans le LET, et autres fonctions Excel)
 - À noter que les variables définies sont disponibles uniquement au sein de la fonction LET

Quelques exemples :
 - `=LET(valeur1 ; A1 ; valeur2 ; A2 ; valeur1 + valeur2)` fait la somme des cellules A1 et A2 (oui ça a assez peu d'intérêt dans cet exemple simpliste...)
 - `=LET(montant ; A1+A2 ; taux ; B1 ; interets ; montant*taux ; interets)` renvoie le montant des intérêts par rapport à un montant et un taux donné ; à noter qu'il n'est pas nécessaire de nommer la dernière valeur et qu'on pourrait utiliser directement `=LET(montant ; A1+A2 ; taux ; B1 ; montant*taux )` mais la version précédente permet d'être bien plus explicite et réutilisable
- On peut utiliser tout type de fonction `=LET(valeur ; A1 ; SI(valeur > 0; valeur + 10 ; "") )` pour n'appliquer une fonction que sur une cellule non vide par exemple

Documentation complète pour [LibreOffice](https://help.libreoffice.org/latest/fr/text/scalc/01/func_let.html?DbPAR=CALC) ou [Excel](https://support.microsoft.com/fr-fr/office/fonction-let-34842dd8-b92b-4d3f-b325-b8b8f9908999)



# Des formules pour les prêts immobiliers

Les formules classiques pour un prêt immobilier standard en France avec :
- Un taux fixe, qui calcule des intérêts sur le capital restant dû
- Des mensualités fixes (avec donc plus de paiement d'intérêts et moins de capital remboursé dans les premières échéances)
- Sans prise en compte de la partie assurance qui doit être ajoutée en plus

Formule pour calculer la **mensualité** :

$$`  "Mensualité" = ("Capital emprunté" * ("taux"/12)) / (1 - (1 + "taux"/12)^(-"Durée du prêt en mois"))  `$$
- Mensualité : la mensualité calculée, hors assurance, en euros
- Capital emprunté : en euros
- Taux : le taux annuel, en pourcentage
- Durée du prêt : en mois (soit par exemple 240 pour 20 ans)

Formule pour le **capital restant dû** *(c'est le montant qu'il faut payer à la banque pour un remboursement anticipé)* :

$$` "Capital restant du" = "Capital emprunté" * (1 + "taux"/12)^"nb payés" - ("Mensualité" / ("taux"/12)) * ((1 + "taux"/12)^"nb payés" - 1) `$$
- Nb payés : le nombre de mensualités payées au bout desquelles réaliser l'analyse
- Capital restant dû : le capital restant à rembourser à la banque
- Mensualité : la mensualité calculée précédemment


# La fonction LET universelle pour les prêts

La fonction ci-dessous permet de calculer les principales valeurs utiles pour un prêt ***(sans la partie assurance)***
- La mensualité
- Le capital restant dû au bout d'un certain nombre de paiements
- Le total des intérêts payés sur toute la durée du prêt

```
=LET(     
	capital_initial ; <capital> ;     
	taux_annuel ; <taux_annuel> ;    
	duree_annees ; <duree> ;     
	paiements_effectues ; <si utilisation du calcul du capital_restant_du, 0 sinon> ;     
	taux_mensuel ; taux_annuel / 12 ;     
	nombre_total_paiements ; duree_annees * 12 ;     
	mensualite ; capital_initial * (taux_mensuel / (1 - (1 + taux_mensuel) ^ -nombre_total_paiements));     
	capital_restant_du ; capital_initial * (1 + taux_mensuel) ^ paiements_effectues - (mensualite / taux_mensuel) * ((1 + taux_mensuel) ^ paiements_effectues - 1) ;     
	total_interets ; mensualite*duree_annees*12 - capital_initial ; 
	total_interets 
)
``` 
Pour passer d'une valeur à l'autre, il suffit de modifier la dernière ligne pour indiquer la valeur souhaitée. Certes, cela peut nécessiter parfois des calculs inutiles,  mais c'est tout à fait imperceptible sur les ordinateurs actuels et négligeable par rapport au confort d'utilisation que cela permet.



# Exemple d'analyse

L'intérêt d'avoir tout en une seule formule, c'est de pouvoir créer des tableaux d'analyse mono ou multi-dimensionnels, pour voir la variation d'une des valeurs suivant la variation des paramètres d'entrée ; par exemple ci-dessous, un exemple très simple pour voir l'impact du taux et de la durée sur le cout total des intérêts. Il suffit de coller la formule, de renseigner dans les paramètres les cellules en figeant au besoin la ligne ou la colonne (ou les deux), et en étendant la formule sur tout le tableau :

![]({{ 'files/2025/FormuleLetPret-ExempleAnalyse.png' | relative_url }}){: .img-center .mw80}

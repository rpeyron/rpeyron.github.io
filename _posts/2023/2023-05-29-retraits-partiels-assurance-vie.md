---
title: Retraits partiels assurance vie
lang: fr
tags:
- Assurance-Vie
- Impots
- Calculatrice
- Javascript
- GitHub
- Retrait
- Fiscalité
categories:
- Divers
toc: 'yes'
modules:
- asciimath
csp-frame-src: docs.google.com rpeyron.github.com www.lprp.fr
image: files/2023/calculatrice-impots.jpg
---

L'assurance-vie a une fiscalité particulière, notamment sur l'imposition des intérêts lors des retraits qui bénéficie d'un abattement de 4600 €, qu'il n'est pas forcément simple de calculer en cas de retraits partiels. C'est ce que nous allons voir dans cet article.

# Fiscalité de l'assurance vie

L'objet de cet article n'est pas de détailler le fonctionnement complet de l'assurance vie, plus ou moins bien expliqué dans les références sur le site [service-public.fr](https://www.service-public.fr/particuliers/vosdroits/F22414) ainsi que sur le site des [impôts](https://www.impots.gouv.fr/particulier/lassurance-vie-et-le-pea-0) ; les sites de banques ou de [courtiers](https://placement.meilleurtaux.com/assurance-vie/fiscalite-assurance-vie/) sont souvent plus simples à comprendre. D'autant plus que les règles dépendent de la date d'ouverture du contrat, de son ancienneté, et de la date de versement des primes...

Pour faire très simple :
- La fiscalité pour des retraits d'une assurance vie de moins de 8 ans est plus lourde ; il faut donc prévoir de garder une assurance vie au moins 8 ans
- La CSG est prélevée directement par l'assureur lors de l'inscription des intérêts sur l'assurance vie
- L'imposition des intérêts est réalisée lors de leur versement lors d'un retrait partiel ou total, et à inscrire sur la déclaration d'impôts sur le revenu de l'année du retrait. Il est possible de choisir entre une imposition au barème ou une imposition forfaitaire (dont l'avance a été prélevée par l'assureur lors du retrait ou lors de l'inscription des intérêts suivant le contrat, sauf si vous avez empressement justifié une dispense)
- Pour les versements récents, l'imposition forfaitaire est plus importante pour des contrats supérieurs à 150 000 €. Si c'est votre cas, sauf contrats particuliers ou besoin de retrait avant 8 ans, il est certainement plus intéressant d'ouvrir un nouveau contrat plutôt que de dépasser ce seuil sur un même contrat. 


# Abattement de 4600€

Une disposition importante à comprendre et concernant tous les contrats est la règle de l'abattement de 4 600 € d'intérêts par an ou 9 200 € pour un couple (défini par l'[article 125-0 A - I 1er du code général des impôts](https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000041464342/)). Cela signifie que chaque année, les premiers 4600€ d'intérêts retirés sont exonérés d'impôts (tous retraits et contrats confondus). Ce n'est pas une petite économie, car avec un prélèvement forfaitaire de 24.7% (voire 30%), cela représente 1136€ d'impôts économisés.

Il peut ainsi être intéressant pour des contrats anciens ayant des intérêts supérieurs à cet abattement de fractionner leur retrait sur plusieurs années pour bénéficier de cette exonération. Et pour les contrats d'assurance vie sans frais à l'entrée, il est même intéressant de procéder sur la même année à un retrait partiel pour encaisser des intérêts exonérés et les réinvestir immédiatement. À noter que ces contrats sans frais d'entrée sont rarement les plus performants, à prendre en compte au global...

Bref, pour optimiser l'utilisation de cet abattement de 4600€, il faut pouvoir calculer la somme correspondante à retirer, et ce n'est pas forcément simple, surtout en cas de retraits partiels multiples.

# Calcul de la quote-part d'intérêts d'un retrait partiel

Le site MoneyVox explique [la méthode](https://www.moneyvox.fr/assurance-vie/calcul-rachat.php) et fournit également [une calculatrice](https://www.moneyvox.fr/calculatrice/placement/rachats-assurance-vie.php). 

$$` "Intérêts" = "Rachat" – ("Capital" * "Rachat"/"Valorisation") `$$
{: .center}

La part des intérêts *(intérêts)* est égale au montant racheté *(rachat)* moins les versements effectués depuis l’ouverture du contrat *(capital)* multiplié par le montant racheté divisé par la valeur du contrat au moment du rachat *(valorisation)*.

Si on l'écrit différemment, on voit que c'est simplement une règle de trois entre la valeur du rachat et la valorisation du contrat (la valorisation moins le capital représente le total des intérêts), ce qui semble assez logique :

$$` "Intérêts" = "Rachat" / "Valorisation" * ( "Valorisation" - "Capital") `$$
{: .center}

Nous pouvons vérifier cette formule avec un rachat total, avec montant racheté = valeur du contrat au moment du rachat, on retrouve le fait que les intérêts correspondent à la valeur du contrat moins les versements effectués.

Sur certains sites, vous verrez utilisé le terme de "prime" au lieu de "versement". Comme à l'origine, le mécanisme de l'assurance vie est basé sur celui des assurances, on retrouve en effet les mêmes termes de "primes d'assurance" et d' "assureur", même au final si le produit est plus proche d'un produit bancaire que d'une assurance comme une assurance habitation ou de voiture...

Prenons par exemple le cas une assurance vie sur laquelle il y a eu 10 000 € de versés, avec 2 000 € d'intérêts, soit une valorisation totale de 12 000 €, sur laquelle on réalise un retrait partiel de 3 000 €. La formule ci-dessus indique que sur ces 3 000 € euros, il y a 500 euros qui correspondent à des intérêts, et donc 2 500 € de capital.

Ce dernier montant est important à prendre en compte pour les prochains rachats.

# Pour les retraits partiels suivants

Suivant votre assureur, il pourra faciliter votre travail en fournissant à tout instant sur votre compte, en plus de la valorisation du contrat, la part de capital ou la part d'intérêt. Si c'est le cas, vous pouvez directement utiliser la formule ci-dessus, avec :
- la valorisation donnée par votre assureur
- le total des versements = la valorisation - les intérêts

Malheureusement, ce n'est pas toujours le cas (par exemple la MACIF fournit seulement la valorisation sans aucun détail) ; dans ce cas, il faut refaire les calculs vous-même avec :
- la valorisation diminuée du rachat partiel précédent  (soit 3 000 € dans notre exemple précédent)
- le total des versements diminués de la part de capital du rachat partiel  (soit 2 500 € dans notre exemple précédent)

Ainsi pour un nouveau retrait partiel de 600 €, on fera le calcul de 600 (montant racheté) - 7500 (versements effectués depuis l'ouverture du contrat) * 600 (montant racheté) / 9000 (valorisation du contrat) = 100 €  d'intérêts   et donc 500 € de capital.

# Optimiser le montant à retirer pour atteindre l'abattement

Il suffit d'inverser la formule ci-dessus : 

$$`  "Rachat" =  "Intérêts" * ("Valorisation" / ("Valorisation" – "Capital") )   `$$
{: .center }
 
Le montant à racheter *(rachat)* est égal à la part des intérêts visés *(intérêts)* multipliée par la valeur du contrat au moment du rachat *(valorisation)* divisé par la différence entre valeur du contrat au moment du rachat *(valorisation)* et les versements effectués depuis l’ouverture du contrat *(capital)*  

# Autres calculs utiles pour s'y retrouver
Quand l'assureur ou la banque ne fournit pas les détails des calculs sur le compte, pour pouvoir vérifier ce qu'il  y a dans l'IFU :
* Retrouver les intérêts bruts (ceux imposables) à partir du montant net (celui versé sur le compte) 
  * Sans PFU (ex: intérêts assurance vie sur versements antérieurs à 2017) : 
    * $$` "Intérêts bruts" = "Intérêts net" / (1 - "taux CSG") `$$
    * $$`  "CSG" = "Intérêts bruts" * "taux CSG" `$$   *(17.20%)*
  * Avec PFU  (ex: comptes rémunérés classiques) : 
    * $$` "Intérêts bruts" = "Intérêts net" / (1 - "taux CSG" - "taux PFU")  `$$
    * $$` "CSG" = "Intérêts bruts" * "taux CSG" `$$   *(17.20%)*
    * $$` "PFU" = "Intérêts bruts" * "taux PFU"  `$$ *(24.7% pour une assurance vie de 8ans < 150k€ ou 30% pour un compte rémunéré classique)* 

# Calculatrice 

<iframe src="https://www.lprp.fr/calculatrice-assurancevie-retraitpartiel/" style="width: 80%; height: 70em; margin: auto; display: block;" ></iframe>

<br />



# Calculatrice Google Spreadsheet

[Click this link to create a copy and use the formula](https://docs.google.com/spreadsheets/d/11l4MOinDe0pJiInGvA4ysUvGV6DGrL8sGkXZkrnPH4M/copy)
{: .center}

<iframe src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQibBUH4-N7-0o7BCjUy4SGQpAU1VlmbEig1dMnzKvc_NfgGvHWselQY53NBZcKXA4JnksSEkrMwNxw/pubhtml?gid=0&amp;single=true&amp;widget=false&amp;headers=false&amp;chrome=false" style="margin: 0 auto ; width: 37em; height: 15em; "></iframe>
{: .img-center}

---
title: Lire les corrections de lunettes
post_id: 5679
date: '2022-02-27T22:10:40+01:00'
last_modified_at: '2024-08-14T13:03:52+01:00'
author: Rémi Peyronnet
layout: post
guid: "/?p=5679"
slug: lire-les-corrections-de-lunettes
permalink: "/2022/02/lire-les-corrections-de-lunettes/"
image: "/files/ophtalmologue-lunettes-correctrice-stockpack-adobe-stock.jpg"
categories:
- Divers
tags:
- AppScript
- Astigmatie
- Calculette
- GitHub
- Google
- Myopie
- Ophtalmologie
- Spreadsheets
- Yeux
lang: fr
csp-frame-src: rpeyron.github.io www.lprp.fr
featured: 240
---

Il existe plusieurs notations pour les verres de lunettes, et bien sûr les ophtalmologistes et les opticiens n’utilisent pas les mêmes. Pour s’y retrouver, il faut apprendre à lire et convertir les différentes écritures.


Je ne suis ni opticien, ni ophtalmologue, ni professionnel de la santé, les éléments ci-dessous sont issus de rapides recherches sur Internet et ne sauraient constituer une quelconque expertise médicale.
{: .notice-note title="Disclaimer" style="--notice-color: #91110c;"}


# Normaliser une correction

Voici un petit outil pour obtenir automatiquement une écriture normalisée qui correspond à celle utilisée par les opticiens.

<iframe allow="fullscreen" height="600" loading="lazy" src="https://rpeyron.github.io/verres/" width="600"></iframe>
{: .div-center}

Le code source de cette calculette est disponible sur [github](https://www.github.com/rpeyron/verres).

# Explications

La notation des verres est composée de plusieurs parties suivant votre correction :

- Pour tous : 
    - La sphère : il s’agit de la courbure principale du verre ; elle est exprimée en dioptries ; si elle est négative vous êtes myope (verres concaves) , si elle est positive vous êtes hypermétrope (verres convexes)
- Pour les astigmates seulement : 
    - Le cylindre : il s’agit de la correction du cylindre de correction de l’astigmatie, exprimée en dioptries
    - L’angle : l’angle de l’axe du cylindre dans le plan du verre, exprimé en degrés
- Pour les myopes (verres progressifs) : 
    - L’addition : il s’agit de la correction ajoutée à la sphère pour la zone de vision de près, exprimée en dioptries.

Pour une correction simple, seule la sphère est exprimée. Là encore, suivant les ophtalmologues, tous ne notent pas les dioptries de la même façon. Certains se passeront de la virgule pour noter la valeur multipliée par 100. Ainsi, 1.5 dioptrie sera noté 150.

C’est pour l’astigmatie que la variété est plus grande, ainsi pour une même correction, on peut trouver :

- -3.00 (+1.00 à 110°) dite notation à cylindre positif, fréquent chez les opticiens
- -2.00 (-1.00 à 20°) dite notation à cylindre négatif, fréquent chez les ophtalmologues
- (20° -1.00) -2.00 toujours une notation à cylindre négatif, mais avec le cylindre qui précède la sphère
- 20 -100 -200 également une notation à cylindre négatif avec le cylindre qui précède, mais sans les parenthèses et avec les dioptries multipliées par 100

Pour passer d’une notation à cylindre positif vers une notation à cylindre négatif, il faut faire la transposition suivante : ajouter le cylindre à la sphère, inverser le cylindre, ajouter 90° à l’angle (et on retranchera 180° si cela dépasse 180°) ; l’article en référence (1) explique plus en détail ce mécanisme de transposition. L’article (2) permet de comprendre pourquoi ces transpositions donnent la même correction optique.

Enfin avec l’astigmatie, il n’est pas évident de savoir si la myopie évolue globalement ou non suivant la répartition. Pour cela il est utile de regarder la valeur moyenne de la sphère en ajoutant la sphère et la moitié du cylindre.

Références :

- (1) <http://www.thomassinclairlabs.com/vue/transposition.html> ; pour savoir comment transposer un cylindre négatif en cylindre positif
- (2) <https://www.gatinel.com/recherche-formation/astigmatisme/astigmatisme-definitions-et-formulations/> et [https://www.gatinel.co m/recherche-formation/astigmatisme/astigmatisme-representation-trigonometrique/](https://www.gatinel.com/recherche-formation/astigmatisme/astigmatisme-representation-trigonometrique/) ; pour comprendre ce que ça veut dire et en quoi les écritures donnent un résultat identique (et plein d’autres articles intéressants)
- (3) <https://www.essiloracademy.eu/en/publications/ophthalmic-optics-files> ; les manuels de formation Essilor des opticiens en réfraction, accessibles librement, pour devenir un pro des lunettes

# Acuité visuelle
L'ordonnance peut également comporter des mentions de l['acuité visuelle](https://fr.wikipedia.org/wiki/Acuit%C3%A9_visuelle). Pour la vision de loin, l'acuité s'exprime souvent en dixièmes via l'[échelle de Monoyer](https://fr.wikipedia.org/wiki/%C3%89chelle_Monoyer) : la mention "10/10" indique que la correction des lunettes permet de retrouver une très bonne vue. Contrairement à ce que le "/10" laisse à penser, 10 n'est pas la mesure maximale, et si vous avez une très bonne vue, vous pouvez avoir une acuité de "12/10". Il s'agit en fait du nombre de lignes que vous arrivez à lire lors du test de vue (à noter que l'ophtalmologiste ne va pas forcément aller mesurer au-delà de 10/10).  Une acuité inférieure est signe qu'il existe un autre problème que l'ophtalmologiste doit investiguer (cataracte, DLMA, glaucome,...). L'acuité visuelle figurant sur l'ordonnance est l'acuité visuelle avec correction. Il existe une corrélation entre l'acuité visuelle sans correction et la correction à appliquer pour la myopie. Par exemple, une acuité sans lunettes entre 2 à 4/10 correspond à une correction à apporter de -1.5 dioptries (pour une myopie seule, sans astigmatisme). Ce test de vision avec les lignes, également appelé test de vision subjective, est souvent précédé d'un test de vision objective par un réfractomètre qui va mesurer la géométrie de l'œil et en déduire une correction de myopie et astigmatie. 

Il existe des échelles [sur écran ou à imprimer soi-même](https://www.opticien-lentilles.com/acuite/acuite_visuelle.html) pour faire le test. Attention à bien respecter les instructions pour avoir les bonnes échelles et distance, notamment sur la vue sur écran. Il existe également un biais cognitif qu'on finit par mémoriser les lettres à lire, et donc d'avoir plus de facilité à les reconnaitre.

L'acuité visuelle de près peut aussi être mesurée. L’échelle Parinaud est couramment employée, il s'agit d'une page avec des paragraphes de différentes tailles, à lire à une distance "proche", souvent 30cm. L'acuité est notée sous la forme "Px", avec x le numéro du paragraphe le plus petit pouvant être lu (1 pour le texte le plus petit), précédé de la lettre P pour Parinaud. L'équivalent du "10/10" pour la vision de loin est "P1". 

Un œil sain sait passer de la vision de loin à la vision de près en utilisant la souplesse du cristallin naturel sain via des muscles qui vont contracter le cristallin, et changer ainsi sa distance focale. Au fil du temps, le cristallin va perdre en souplesse, c'est la presbytie. Il faut alors compenser une partie de la modification de distance focale que le cristallin ne sait plus atteindre par des lunettes en vision de près. Lors d'une opération de la cataracte (opacification du cristallin), le cristallin artificiel n'est pas souple et par la distance focale sera fixe (pour un implant monofocal). Cette distance focale, qui va déterminer en gros à la distance à laquelle la vision est bonne, est choisie au moment de l'opération, et souvent définie pour voir correctement de loin sans lunettes. Par conséquent, l'intégralité de la différence entre vision de loin et vision de près doit être corrigé avec des lunettes. D'un point de vue purement optique, une distance focale de 33cm correspond à 3 dioptries (et 4 dioptries pour 25cm), il faudra donc des loupes de +3 dioptries en vision de près post opération. Il existe de nombreux facteurs complémentaires qui font que le médecin prescrira une correction différente, souvent inférieure.

Références :
- (4) <https://www.krys.com/sante/la-vision/controler-sa-vue> présentation des tests de vue
- (5) <https://www.ophtalmissimo.com/interpret.html> relation entre acuité visuelle et correction
- (6) <https://www.gatinel.com/recherche-formation/acuite-visuelle-definition/acuite-visuelle-resolution-et-pouvoir-separateur-de-loeil/> article plus complet par un professionnel
- (7) <https://www.cahiers-ophtalmologie.fr/media/63a2d37e0f334db31ac765bb84f08927.pdf> Les Cahiers d'Ophtalmologie 2018;n°218:20-4 - Bien mesurer l’acuité en vision de près. par Pascale Hamard et Jean-Pierre Meillon


# Fonctions dans Google Spreadsheets

Cette calculatrice est certes pratique, mais pas si vous souhaitez l’utiliser un grand nombre de fois. J’utilise d’habitude LibreOffice comme tableur, mais il ne semble pas qu’il permette d’intégrer facilement une nouvelle fonction en javascript. Or comme j’ai écrit le code ci-dessus en javascript, je n’ai pas envie de le réécrire en Basic de LibreOffice. Fort heureusement, Google Spreadsheet permet très simplement d’ajouter des fonctions en javascript.

Dans un nouveau document Google Spreadsheet, cliquez sur Extensions / AppScripts :

![](/files/GoogleSpreadsheetFonction-1.png){: .img-center}

Puis dans l’éditeur de script qui s’est ouvert, copier le fichier disponible à cette adresse : https://github.com/rpeyron/verres/blob/main/src/lens.js

![](/files/GoogleSpreadsheetFonction-2.png){: .img-center}

Et c’est tout ! Les fonctions sont maintenant disponibles dans votre tableur (voir exemple dans la 1ère image)

---
title: Faux Hubs USB 3.0 chinois
lang: fr
tags:
- USB
- AliExpress
- Elec
categories:
- Avis Conso
image: files/2026/vignette_faux_usb3.jpg
date: '2026-01-31 18:11:33'
---

Par curiosité j'ai ouvert un hub USB 3.0 qui a récemment cramé suite au branchement d'un dongle Wifi, et je n'ai pas été déçu, ce qui est vendu comme un hub à quatre ports USB 3.0 est en réalité un hub USB avec 4 ports USB 2.0, dont un qui peut fonctionner en USB 3.0. Tout dans son apparence laisse à penser que c'est bien un hub USB 3.0, et pourtant si on lit attentivement l'annonce, quelques incohérences permettent d'identifier cette "subtilité". Difficile alors de parler complètement d'arnaque, mais les formulations sont clairement a minima trompeuses.

# Exemple d'une annonce AliExpress
Il existe énormément d'annonces qui présente cette "particularité", prenons en exemple [cette annonce AliExpress](https://fr.aliexpress.com/item/1005006064840808.html) :

La présentation rapide parle d'un "Hub USB 3.0 à 4 ports haute vitesse" :

![]({{ 'files/2026/AliExpress_Example_Hub_USB3_2026-02-07 163819.png' | relative_url }}){: .img-center .mw80}

On voit bien une mention à la fin du titre mentionnant "4 ports USB 3.0, 2.0", mais à ce stade on peut comprendre que le titre veuille dire que les ports sont également compatibles USB 2.0

La présentation détaillée donne des indications plus précises, et contradictoires !

![]({{ 'files/2026/AliExpress_Example_Hub_USB3_Description_2026-02-07 163625.png' | relative_url }}){: .img-center .mw80}

Une première phrase dans la description (mis en évidence par le premier rectangle en rouge) mentionne sans équivoque possible 4 ports USB 3.0. Cette partie est fausse.
Mais un deuxième passage dans la description (mis en évidence par le premier rectangle en vert) donne quant à lui l'information exacte, à savoir un seul port en USB3.0 et les autres en USB2.0.

# Le "piège" des couleurs des ports

Je me suis rendu compte à cette occasion que je faisais un peu trop confiance à la couleur des ports USB. En effet, j'avais en tête "connecteur bleu = USB 3.0". Certain sites, comme [celui de Corsair](https://www.corsair.com/fr/fr/explorer/diy-builder/storage/usb-port-colors-explained/), mentionnent d'ailleurs toute une palette de couleurs de ports :

![]({{ 'files/2026/Corsair_Couleurs_USB_2026-02-07 170401.png' | relative_url }}){: .img-center .mw80}

Dans notre exemple, que ce soit les 4 connecteurs ou le câble, tout est bleu, impossible de se douteur que les 4 ports ne sont pas identiques : 

![]({{ 'files/2026/IMG_20260207_162256455_HDR.jpg' | relative_url }})

Cependant, j'ai cherché dans la norme USB, et je n'ai trouvé nulle part de norme portant sur la couleur des ports USB. Je ne sais pas si je n'ai pas bien cherché ou si ce n'est effectivement pas normé. Il est probable que ce ne soit qu'une convention, très répandue, mais que le fabricant ne soit pas réellement "non conforme" s'il ne suit pas la convention...

# La surprise au démontage

Le démontage du Hub est très instructif pour comprendre comment cela fonctionne :

![]({{ 'files/2026/IMG_20260125_212902786_HDR.jpg' | relative_url }}){: .img-center .mw80}

On voit effectivement assez clairement d'après le câblage que les 3 ports USB de gauches n'ont que 4 fils et plots (rectangle blanc), et ne peuvent donc pas physiquement aller au-delà de la compatibilité USB 2.0 (2 fils d'alimentation, et 2 fils pour les données).

Le premier connecteur quant à lui, comporte le bon nombre de fils, avec 2 fils provenant de la puce qui doit être un hub USB 2.0, et les 5 fils USB 3.0 relié en directe depuis le câble (rectangle bleu).

Je n'ai pas pu vérifier car le hub n'étant plus fonctionnel, les résultats ne seraient pas exacts, et je n'ai pas envie de cramer un port USB, mais il est probable que le firmware de la puce hub USB 2.0 soit modifié pour annoncer le premier port en USB 3.0.

# Les Hubs à 7 ou 10 ports

La norme USB permet des hubs de 4 ports. Lorsqu'il y a plus que 4 ports, c'est qu'il y a en réalité plusieurs hubs en cascade :
- 7 ports : un premier hub 4 ports, dont un des ports est utilisé par un autre hub, ce qui donne 7 ports disponibles ( 4 - 1 pour le premier hub, et 4 pour le deuxième)
- 10 ports : un premier hub 4 ports, dont deux des ports sont utilisés par deux autres hubs (4 - 2 + 2 x 4)

J'ai ainsi pu constater sur un Hub USB 3.0 à 7 ports, qu'en réalisé, seuls 3 ports supportent réellement l'USB 3.0, et les 4 ports restants sont seulement en USB 2.0. Comme il fonctionne encore, je ne l'ai pas démonté, mais il est certainement constitué d'un premier Hub 3.0, dont l'un des ports est ensuite utilisé par un second hub en cascade uniquement en 2.0.  Encore une fois, de l'extérieur rien de ne permet de distinguer les ports. C'est un peu dommage, ce format 3 USB 3.0 + 4 USB 2.0 est plutôt intéressante, on a rarement besoin de plus en USB 3.0, et si c'était le cas il y aurait probablement d'autres limitations de bande passante ou d'alimentation, mais c'est dommage qu'aucune indication visuelle ne permette de comprendre la différence entre les ports, pour brancher les bons périphériques sur les bons ports.

![]({{ 'files/2026/AliExpress_Exemple_Hub_7ports_2026-02-07 175813.png' | relative_url }}){: .img-center .mw80}

# Conclusion
En conclusion, méfiez-vous des hubs marqués USB 3.0 de marque inconnue (qu'ils ne soient pas chers ou non...) et ne faites pas une confiance aveugle à la couleur des connecteurs...

Dans la jungle des câbles USB, faîtes également très attention aux spécifications des câbles Type C, qui peuvent être très différentes sur la compatibilité avec le transport de vidéo, la bande passante disponible, ou encore la puissance maximum supportée.

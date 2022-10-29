---
post_id: 3976
title: 'Analyse de la qualité de service de ma ligne internet'
date: '2019-01-01T19:02:26+01:00'
last_modified_at: '2021-06-12T19:30:17+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=3976'
slug: analyse-de-la-qualite-de-service-de-ma-ligne-internet
permalink: /2019/01/analyse-de-la-qualite-de-service-de-ma-ligne-internet/
image: /files/2018/11/2018-QoS-Internet.jpg
categories:
    - 'Avis Conso'
    - Télécoms
tags:
    - Bouygues
    - Internet
    - SFR
lang: fr
term_language:
    - English
term_translations:
    - pll_5eb7178caeeac
---

Depuis 2013 j’ai un script qui mesure deux fois par jour la qualité de ma connexion internet avec [speedtest.net](http://www.speedtest.net/fr). Au bout de 5 ans, voici l’occasion d’une petite rétrospective entre la promesse commerciale et la réalité.

Le graphique et l’analyse résultante sont ci-dessous :[![](/files/2018/11/2018-QoS-Internet.jpg){: .img-center}](/files/2018/11/2018-QoS-Internet.jpg)

Quelques mots de présentation de mon installation pour mieux comprendre ces résultats :

- L’ordinateur qui effectue ce test est relié à la box internet en CPL : jusqu’à fin 2017 via un kit Devolo 200 de très bonne qualité, qui permettait d’atteindre un débit moyen de 80 Mbps. Entre l’offre théoriquement à 100 Mbps et ce kit, c’est donc le kit qui était limitant. En pratique, en étant branché en ethernet sur la box je n’atteignais pas les 100 Mbps, la limitation était donc faible, mais on voit nettement le changement du kit CPL en décembre 2017 par un kit Netgear PLP1000T qui arrive en pic dans les 220 Mbps, mais est souvent plutôt dans les 130 Mbps assez décevant par rapport aux 500 Mbps promis (1000 Mbps avec prise de terre). Cela s’explique sans doute par la faible qualité de mon réseau électrique un peu vieux, et aux 3 points de connexion utilisés désormais contre seulement 2 auparavant. Bref le CPL peut jouer un rôle important dans l’interprétation des résultats ci-dessus, même si en pratique je n’ai jamais constaté de débit supérieur quand je suis branché en filaire directement sur la box.
- Sur l’intégralité de la période je suis raccordé en FFTLa (le cable Numericable). Il s’agit d’un réseau à débit partagé, c’est-à-dire que le débit maximum disponible est partagé entre tous les abonnés raccordés sur la même boucle. En pratique, il y a très peu d’abonnés internet via le cable dans ma résidence, il est peu probable que ce point joue de manière importante.
- Ces tests sont évidemment également dépendants de l’activité sur ma ligne à ce moment (tests à 4h et 19h) ce qui explique sans doute une partie des variations observées, sans pour autant expliquer les niveaux très bas.
- Les tests dépendent également de la disponibilité des serveurs de speedtest.net. En l’absence d’éléments factuels sur ce point, j’ai pris le parti d’écarter l’hypothèse de défaillance chez eux.

On distingue assez clairement plusieurs périodes :

- Une première période chez Bouygues Telecom au fonctionnement parfait de 2013 à début 2015
- Une seconde période avec une très forte dégradation de service (dont une interruption totale de service en été 2015), à cause très probablement de la box, ce qui m’a conduit à décider de changer *(cela s’est remis à fonctionner à peu près normalement après que j’ai décidé de changer…)*
- Les débuts chez RED by SFR avec une qualité strictement identique à celle de Bouygues Telecom, ce qui est techniquement tout à fait logique puisque le réseau d’accès est identique, mais sur une offre 4x moins chère (10€ sur 12 mois)
- Le changement de kit CPL donne un peu de punch au download qui passe d’une moyenne de 75 Mbps à une moyenne de 90 Mbps ; à noter l’upload toujours stable à 5 Mbps
- C’est justement l’upload qui bénéficie le plus du passage à une première offre bonusée à 200Mbps/20Mbps. On voit très nettement l’augmentation sur l’upload (et le confort d’utilisation cloud s’en ressent immédiatement également), et également sur le download une augmentation des pics à 150 Mbps.
- Puis le passage à l’offre “Debit Plus” (commercialement jusqu’à 1 Gbps pour le FTTH, mais techniquement sur mon accès c’est 400 Mbps), avec une nouvelle augmentation de l’upload à 40 Mbps et des pics à 200 Mbps (certainement limité par le CPL sur ce graphique). On observe bizarrement des variations assez stables dans le débit de l’upload vers 30 Mbps.

Par ailleurs on observe une forte variabilité du débit mesuré, avec des débits descendants parfois très faibles, et qui correspondent bien au ressenti. Généralement un reboot de la box résout le problème, mais de temps en temps le problème semble être du côté du réseau opérateur.

En synthèse ce que l’on peut retenir de ces mesures :

- La confirmation de la qualité identique chez Bouygues Telecom
- L’observation réelle de gains sur les offres commerciales ‘Débit Plus’ (sans aller jusqu’au débit théorique bien sûr)
- La forte variabilité des débits
- L’importance du réseau local qui peut devenir limitant sur les offres haut débit
---
post_id: 4197
title: 'Ajouter un capteur de température à un Sonoff Basic'
date: '2020-01-02T21:57:58+01:00'
last_modified_at: '2020-01-02T21:57:58+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4197'
slug: ajouter-un-capteur-de-temperature-a-un-sonoff-basic
permalink: /2020/01/ajouter-un-capteur-de-temperature-a-un-sonoff-basic/
image: /files/2020/01/sonoff-basic-dht11.jpg
categories:
    - Domotique
tags:
    - Domoticz
    - Sonoff
lang: fr
---

Dans ce billet, on ajoute un capteur de température à un Sonoff Basic sous Tasmota, configuré dans le [billet précédent](/2019/12/sonoff-basic-sous-domoticz-avec-tasmota/). Outre le plaisir de customiser la bestiole, cela va permettre d’une part d’ajouter un capteur de température ambiante dans Domoticz, et surtout d’implémenter une règle de sécurité sur notre Sonoff Basic pour éteindre automatiquement l’appareil contrôlé si la température ambiante devient trop élevée.

La première chose est de bien choisir le capteur de température en piochant dans la [liste de capteurs supportés par Tasmota](https://tasmota.github.io/docs-7.1/#/Components). A noter que le bus I2C est supporté, et donc tous les capteurs compatibles avec ce bus pourront être utilisés également. Pour ma part j’ai choisi le BMP280 qui est très bon marché (&lt; 1€), très compact, et donne température, humidité et pression avec une précision qui est indiquée comme pas mauvaise. Mais le temps que ça arrive, j’ai un DHT11 en stock qui est supporté par Tasmota et qui rentre pile poil dans le boitier du Sonoff Basic. Il est indiqué que la précision de ce capteur est très mauvaise, mais pour l’usage que je vais en faire ce n’est pas bien grave.

L’étape suivante est de souder le capteur sur Sonoff. Le sonoff que j’utilise est un Sonoff Basic 2, pour lequel le GPIO14 a été remplacé par le GPIO2. La petite subtilité est que ce GPIO nécessite une résistance pour être actif au démarrage et ne pas être désactivé par la suite. il faut donc pouvoir souder le DHT11 sur les broches GND, 3V3 et IO2, une résistance de 10k Ohm entre 3V3 et IO2, et accessoirement pouvoir garder l’accès aux broches, d’une part si on a besoin de le brancher à nouveau sur le PC pour une mise à jour, et d’autre part pour permettre de l’alimenter avec le module FTDI utilisé dans l’article précédent pour pouvoir tout tester hors circuit 220V. Le plus simple pour tout ça est finalement de souder également un pin header (oui, après avoir tout fait pour configurer Tasmota sans le pin header je finis par en installer un quand même 🙂 ). La GPIO2 et disponible uniquement sur la face inférieure du circuit, j’ai donc utilisé une nappe de fils pour passer dans un trou et installer le DHT11 au dessus pour pouvoir le rentrer dans le boitier. Il y a de toutes façons la possibilité de sortir le DHT11 en dehors du boitier mais je préférais une solution la plus simple et compacte possible. Voici le résultat une fois les soudures effectuées :

![](/files/2020/01/20191230_200822-300x170.jpg) ![](/files/2020/01/20191230_201129-225x300.jpg) ![](/files/2020/01/20191230_201239-300x225.jpg)
{: .center}

A noter :

- la résistance est de 10 000 Ohm (1 = brun, 0 = noir, 0 = noir -&gt; 100 x multiplier 100 = rouge -&gt; 100 x 100 = 10 kOhm)
- le brochage du DHT11 est de gauche à droite : Vcc, Data, Unused, Gnd (lorsque vous regardez sa face percée et les pattes en bas)

Une fois branché en 3.3V il faut ensuite retourner dans l’interface web du Sonoff pour paramétrer le DHT11 sur la broche GPIO2 :

![](/files/2020/01/Sonoff-DHT11-conf-300x254.jpg){: .img-center}

Un reboot plus tard, le module va maintenant vous afficher la température :

![](/files/2020/01/Sonoff-DHT11-display-300x194.jpg){: .img-center}

Pour intégrer cet affichage dans Domoticz, rien de plus simple, il suffit de créer comme dans le billet précédent un capteur virtuel, mais de type temperature+humidity, puis de recopier son identifiant dans la configuration Domoticz et le tour est joué !

![](/files/2020/01/Sonoff-DHT11-domoticz-300x168.jpg){: .img-center}

Le capteur est effectivement très imprécis, et montre pour le mien un décalage de 3°C. Heureusement dans Domoticz on peut indiquer un offset de -3°C via le bouton modifier :

![](/files/2020/01/Sonoff-DHT11-domoticz-2-300x97.jpg){: .img-center}

A cette étape nous disposons donc d’un Sonoff avec un capteur de température fonctionnel. Je l’ai alors installé sur l’équipement cible. A noter que le Sonoff Basic ne dispose pas d’une borne pour le fil de masse. Comme mon équipement utilise la masse, il a fallu faire en sorte de faire passer la masse dans le boitier, ce qui n’a pas été simple vu la taille du boitier et ce d’autant plus qu’il y a déjà le capteur DHT11 qui prend de la place.

A l’usage j’ai constaté que le module chauffe un peu lorsqu’il est sous tension, et encore un peu plus lorsque l’équipement à commander est allumé. J’ai donc fait quelques petits trous dans le boitier pour “ventiler” un peu. Ca limite l’écart à quelques degrés mais ce n’est pas magique. Encore un fois pour mon usage ce n’est pas bien grave mais j’ai été un peu surpris que le Sonoff Basic chauffe un peu.![](/files/2020/01/20191231_161413-300x98.jpg){: .img-center}

Du coup j’ai mesuré sa consommation, à vide il ne consomme pourtant seulement que 0.3 W (environ car mon appareil de mesure n’est pas suffisamment précis pour mesurer des faibles consommations). Pour ceux qui pensent que c’est du à la résistance, la puissance consommée n’est que de 1 mW ( = ( 3.3 V) ^ 2 / 10 000 Ohm).

Il est maintenant temps de paramétrer la règle pour faire éteindre le Sonoff dès que la température devient trop importante. Avec la documentation de Tasmota on trouve assez facilement que la règle doit être :

```
ON DHT11#Temperature>32 DO POWER OFF ENDON
```

La température est ici réglée sur 32°C car c’est pratique pour tester car dans ma configuration c’est une valeur intermédiaire entre la température du Sonoff sous tension mais avec l’interrupteur éteint (28°C) et celle lorsque l’interrupteur est allumé (34°C). A noter que les températures sont à prendre sans l’application de l’offset de -3°C qui n’est pas connu du Sonoff. Cette valeur sera bien sûr à augmenter par la suite sinon ça va se déclencher un peu trop.

Petit problème, je n’ai trouvé (ou compris) nulle part dans la documentation de Tasmota la façon d’ajouter une règle ! En fouillant un peu, je suis tombé sur un logiciel très pratique pour Tasmota : [Tasmota Device Manager](https://github.com/jziolkowski/tdm). Il s’agit d’une interface graphique pour administrer ses équipements Tasmota. L’installation se fait très simplement depuis une instance fonctionnelle de python3 :

```
pip3 install tdmgr
tdmgr.py
```

Cette IHM est très bien faite, il y a une découverte automatique des équipements Tasmota basée sur MQTT, la console MQTT pour chaque équipement avec la possibilité de régler le niveau des informations de logs et de debug souhaitées (si leur émission est paramétrées dans Sonoff ce qui est le cas par défaut), et la possibilité d’éditer les règles et de les uploader !

![](/files/2020/01/Sonoff-DHT11-tdm0.jpg){: .img-center}

J’ai surligné ici la commande MQTT envoyée par TDM pour configurer une règle. C’est finalement très simple, sans doute possible depuis la console de l’interface Web et sans doute dans la documentation (mais je ne l’avais pas compris). Dans la console vous pouvez ne pas utiliser le préfixe MQTT pour simplement indiquer : (mais ça marche aussi avec)

```
Rule1 ON DHT11#Temperature>50 DO POWER OFF ENDON
```

Voici ensuite le log lorsque la température dépasse le seuil indiqué : on voit bien l’application de la règle et la commande de Power Off (ne pas tenir compte de l’affichage de température de la copie d’écran, j’ai réalisé cette copie d’écran après refroidissement). A noter que la commande Power Off est répété tant que la température n’est pas redescendue. Ce n’est pas bien grave pour le Sonoff, ça va juste polluer vos logs MQTT. Tasmota dispose d’un support d’exécution conditionnelle qui permettrait d’indiquer de ne envoyer la commande Power Off seulement si l’équipement est allumé, mais c’est un module optionnel qui n’est pas inclus dans la distribution binaire et qu’il faut donc compiler soi-même.

![](/files/2020/01/Sonoff-DHT11-tdm1.jpg){: .img-center}

Il ne reste plus qu’à remplacer la valeur de 32°C par celle voulue, 50°C dans mon cas, et le module final est maintenant fonctionnel !

Le résultat est donc au final un équipement piloté via Domoticz (et via Google Home / Alexa [au travers de OpenHAB, voir mon article sur ce sujet](/2019/03/domotique-avec-google-home/)) et protégé contre les surchauffes via avec un capteur de température / humidité intégré (et disponible sous Domoticz).
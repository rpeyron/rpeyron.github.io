---
post_id: 5495
title: 'Une règle Tasmota pour rebooter un BMP280 problématique'
date: '2021-06-25T19:15:48+02:00'
last_modified_at: '2021-06-25T19:17:35+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5495'
slug: une-regle-tasmota-pour-rebooter-un-bmp280-problematique
permalink: /2021/06/une-regle-tasmota-pour-rebooter-un-bmp280-problematique/
image: /files/2019/12/sonoff-basic-r2.jpg
categories:
    - Domotique
tags:
    - Sonoff
    - Tasmota
    - regle
lang: fr
---

Dans mon article sur la [création d’une multiprise Sonoff sous Tasmota](/2021/02/une-multiprise-sonoff-basic-sous-tasmota-allumee-avec-le-pc/) j’avais ajouté au Sonoff Basic un capteur de pression et de température BMP280. J’ai opté pour ce capteur notamment car Tasmota déconseille l’utilisation du DHT11 que j’avais utilisé [précédemment](/2020/01/ajouter-un-capteur-de-temperature-a-un-sonoff-basic/) (et qui manque effectivement de précision) au profit du BME280 qui est le grand frère du BMP280 en lui ajoutant le capteur d’humidité, mais également quelques euros. Je regrette un peu ce choix, car le modèle que j’ai pris dispose d’un régulateur qui chauffe, ce qui est un peu fâcheux pour la précision du capteur de température (un commentaire a d’ailleurs été ajouté pour alerter sur [la page Tasmota](https://tasmota.github.io/docs/BME280/) pour déconseiller les modèles avec régulateur). Cela ne semble cependant pas trop impacter le capteur de pression qui donne des résultats cohérents avec la météo. Sauf que de temps en temps, le capteur part en live et donne des températures de -148°C et une pression de 1.292 MPa… Un reboot permet de remettre le capteur en ordre, mais je mets souvent un peu de temps à m’en rendre compte.

C’est ici que les règles Tasmota interviennent, car on peut alors faire un reboot automatique lorsque la valeur lue est manifestement incorrecte. Même si [la documentation de Tasmota sur les règles](https://tasmota.github.io/docs/Rules/) est très bien faite, il faut s’y plonger un peu pour pouvoir assembler tous les morceaux. La syntaxe de base est assez simple :

```
ON <condition> DO <action> ENDON
```

Il existe de nombreuses conditions possibles ; pour la température de mon BMP280, la condition à utiliser est `BMP280#Temperature<0`  
Il existe également une action pour redémarrer le Sonoff : `Restart 1`

Ce qui nous donne donc :

```
ON BMP280#Temperature<0 DO Restart 1  ENDON
```

Je souhaite pouvoir aussi mettre une règle si la valeur est manifestement trop haute. Cependant, il faut compiler une option particulière pour pouvoir utiliser des expressions. Même si ça se fait beaucoup plus simplement que ce qu’on pourrait imaginer grâce à [TasmotaCompiler](https://github.com/benzino77/tasmocompiler) il existe également l’option plus simple d’ajouter une autre clause ON, car on peut en ajouter autant qu’on veut au sein d’une règle, dans la limite de 1000 caractères.

Enfin, pour pouvoir enregistrer la règle, il faut la déclarer sur Tasmota via la commande Rule&lt;x&gt; ce qui nous donne la règle suivante :

```
Rule 1
   ON BMP280#Temperature<0 DO Restart 1  ENDON
   ON BMP280#Temperature>70 DO Restart 1  ENDON
```

Pour la déclarer, nous allons passer par la console de Tasmota, qui est accessible via le bouton “Console” en se connectant avec un navigateur sur l’adresse IP du Tasmota. Vous pouvez aussi utiliser le [Tasmota Device Manager](https://github.com/jziolkowski/tdm) qui remplacera avantageusement la console de Tasmota par une interface plus pratique à utiliser.

La première chose est de vérifier qu’il n’existe pas de règle déjà déclarée ce qui est peu probable si vous lisez cette page, mais il vaut mieux toujours vérifier, via la commande `Rule` :

![](/files/Tasmota-Rule-Check.png){: .img-center}

Copier la règle dans la console et validez :

![](/files/Tasmota-Rule-Result.png){: .img-center}

A ce stade la règle est bien enregistrée dans Tasmota mais n’est pas activée, comme vous pouvez le voir par `“Rule1″:”OFF”` ; pour l’activer nous allons simplement entrer la commande `Rule1 1` ; si vous voulez plus tard la désactiver un simple `Rule1 0` suffira.

![](/files/Tasmota-Rule-Activate.png){: .img-center}

Ce n’est pas forcément très facile de tester les règles sous Tasmota… Le plus simple est d’abaisser les seuils pour voir si ça se comporte correctement, mais là en l’occurrence il y a le risque de partir en boucle de reboot. Donc je vais simplement patienter et voir si ça supprime bien mes lectures incorrectes.
---
post_id: 5433
title: 'Flashage Sonoff Mini DIY sous Tasmota avec Freebox (ou plutôt sans)'
date: '2021-05-24T19:32:57+02:00'
last_modified_at: '2021-06-12T20:33:22+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5433'
slug: flashage-sonoff-mini-diy-sous-tasmota-avec-freebox-ou-plutot-sans
permalink: /2021/05/flashage-sonoff-mini-diy-sous-tasmota-avec-freebox-ou-plutot-sans/
image: /files/sonoffmini.png
categories:
    - Domotique
tags:
    - Domoticz
    - Sonoff
    - Tasmota
    - flashage
    - freebox
lang: fr
---

Souhaitant étendre mon installation domotique tout en conservant la commande actuelle par interrupteur, je me suis équipé d’un Sonoff Mini DIY. Outre sa taille réduite, il possède deux bornes supplémentaires pour connecter un interrupteur. Le Sonoff Mini pourra ainsi réagir selon que le contact entre ces deux bornes est passant (interrupteur allumé ou pressé) ou non.

![](/files/sonoffmini.png){: .img-center}

Attention, il ne pourra pas s’adapter à toutes les installations d’interrupteur, car il doit impérativement être alimenté en 220 V, c’est-à-dire avec un fil de phase et un fil de neutre. Nombreuses sont les installations d’interrupteur qui ne reçoivent et coupent seulement le fil de phase. Il existe d’autre équipement pour ce genre d’installation qui s’alimentent en série et n’ont donc pas besoin du neutre, mais actuellement, c’est assez peu répandu et clairement pas la même gamme de prix. Par ailleurs même s’il est mini, certains boitiers d’anciennes installations ne sont pas assez grand pour l’accueillir.

Pour intégrer ce nouvel interrupteur à mon installation domotique, et comme j’en ai maintenant l’habitude, je flashe Tasmota pour remplacer le firmware Sonoff.

La mention DIY sur le Sonoff Mini DIY signifie qu’il dispose des nouvelles fonctionnalités Sonoff pour intégrer l’interrupteur sans forcément passer par l’application et le serveur central Sonoff. Le principe est assez simple, il y a un jumper à l’intérieur qui permet de switcher sur ce mode ; suivant la version de firmware du Sonoff il est également possible de passer en mode DIY avec un appui long sur le bouton sans avoir à ouvrir pour mettre le jumper. Une fois en mode DIY, Le Sonoff Mini DIY ouvre un mini serveur web pour permettre d’allumer et éteindre l’interrupteur. Ce serveur web permet également de flasher l’interrupteur en OTA, ce qui évite d’avoir à procéder à un flashage physique sur les broches de la carte, ce qui est particulièrement délicat dans le cas du Sonoff Mini, car les connecteurs sont très petits.

Il y a plusieurs procédures disponibles sur internet pour procéder de la sorte :

- La [documentation officielle de Tasmota](https://tasmota.github.io/docs/Sonoff-DIY/)
- Un [tutoriel en français très complet avec l’outil Sonoff](https://www.nextdom.org/forum/projets-divers/tuto-flash-sonoff-mini-sous-tasmota/)
- Un [post sur le forum jeedom qui précise le fonctionnement du firmware 3.6.0](http://jeedom.sigalou-domotique.fr/sonoff-diy-depuis-firmware-3-6-0)

Et le protocole est plutôt bien documenté par Sonoff [sur son site](http://developers.sonoff.tech/sonoff-diy-mode-api-protocol.html#Device-mDNS-Service-Info-Publish-Process) ou [sur son GitHub](https://github.com/itead/Sonoff_Devices_DIY_Tools/blob/master/SONOFF%20DIY%20MODE%20Protocol%20Doc%20v2.0%20Doc.pdf). Vous pouvez aussi savoir dans quel mode est votre Sonoff via sa déclaration mDNS que vous pouvez consulter via une application comme [Service Browser](https://play.google.com/store/apps/details?id=com.druk.servicebrowser&hl=fr&gl=US) ; si vous voyez la valeur “diy\_plug” sur le type c’est que le bon mode est activé, sinon il faut retenter les appuis longs et vérifier les clignotements.

En l’occurrence la méthode n’est pas bien compliquée, il faut appuyer 2 fois plus de 5 secondes sur le bouton pour que le Sonoff Mini créée un réseau Wifi, sur lequel on peut se connecter pour rentrer les identifiants du réseau sur lequel le Sonoff Mini va se connecter en mode DIY. Il y a ensuite un outil proposé par Sonoff sur PC, le [Sonoff DIY Tool](https://github.com/itead/Sonoff_Devices_DIY_Tools/tree/master/tool), qui va permettre de faire la mise à jour de firmware.

Mais ça ne marche pas, malgré de nombreuses tentatives, l’outil Sonoff reste bloqué à 0%, et le Sonoff ne répond jamais aux commandes REST envoyées en curl.

L’explication m’a été donnée par plusieurs articles :

- [Cet article](https://www.reddit.com/r/homeassistant/comments/di4mrk/guide_howto_flash_the_sonoff_mini_with_tasmota/) mentionne que le Sonoff Mini doit avoir accès à internet “If the firmware update gets stuck at 0%, the Sonoff device could not reach the manufacturer server because your mobile hotspot does not share the Internet connection”
- Puis [un autre article](https://support.itead.cc/support/discussions/topics/11000033736) mentionne des Sonoff qui ne répondent pas aux commandes REST derrière une Freebox (ce qui est aussi mon cas)

Donc pour résumer :

- Sonoff a ouvert ses équipements avec le mode DIY, mais a inclus une requête bloquante sur ses serveurs avant toute action, sans doute pour avoir des statistiques sur ce mode DIY
- Pour une raison inconnue, la Freebox filtre ces requêtes

La solution est très simple et consiste à faire un partage de connexion via un téléphone mobile (qui ne filtre par ces requêtes, au moins lorsque j’ai eu à faire les opérations). Pour éviter l’opération du réglage du réseau Wifi, vous pouvez utiliser comme SSID sur le partage de connexion de votre téléphone le SSID “sonoffDiy” et comme mot de passe “20170618sn” ; ce sont des identifiants préenregistrés dans le Sonoff Mini.

Une fois connecté via ce moyen, le Sonoff répond immédiatement aux commandes REST et la mise à jour se déroule sans problème :

![](/files/2021-05-24-141708-Sonoff-Mini-Flashage-Tasmota-3.png){: .img-center .mw80}

Certains forums mentionnent une limitation du firmware à 503 kb, ce qui est peut-être le cas pour le premier flashage, mais aucun problème en passant d’abord par le tasmota-minimal avant d’installer la version classique.

Pour finir, le template pour le Sonoff Mini dans Tasmota `{“NAME”:”Sonoff Mini”,”GPIO”:[17,0,0,0,9,0,0,0,21,56,0,0,255],”FLAG”:0,”BASE”:1}` est disponible dans la [documentation Tasmota](https://templates.blakadder.com/sonoff_mini.html) ainsi que les [commandes à utiliser](https://tasmota.github.io/docs/Buttons-and-Switches/) si vous voulez changer le comportement des boutons. En l’occurrence celui par défaut qui prend en compte toute modification de l’état du bouton me convient parfaitement.
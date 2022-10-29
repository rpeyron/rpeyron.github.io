---
post_id: 4417
title: 'FireTV &#8211; TV Android pas chère'
date: '2020-07-11T16:47:26+02:00'
last_modified_at: '2021-07-04T21:28:41+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4417'
slug: firetv-tv-android-pas-chere
permalink: /2020/07/firetv-tv-android-pas-chere/
image: /files/2020/07/AmazonFireStick.jpg
categories:
    - 'Avis Conso'
    - Informatique
tags:
    - Android
    - Chromecast
    - 'Fire TV'
lang: fr
modules:
  - gallery
---

Normalement proposée à 39.99€, Amazon propose de plus en plus régulièrement la [Fire TV Stick](https://www.amazon.fr/gp/product/B07PVCVBN7) à 24.99 €. Utilisateur très régulier de Google Chromecast mais regrettant à ce dernier l’absence de télécommande et l’obligation d’utiliser un téléphone ou une tablette, c’est l’occasion d’essayer.

![](/files/2020/07/AmazonFireStick.jpg){: .img-center .mw60}


**Edit 31/08/2020 :** le nouveau firmware rend impossible la réaffectation de la touche home décrite ci-dessous.

**Edit 17/12/2020 :** depuis ce jour l’application myCanal est disponible depuis Amazon Store de la Fire TV ; plus besoin de passer par aptoide et une application plus stable !

# En standard, sans Amazon Premium ou Netflix, assez peu utile

Effet wahou garanti au déballage : l’emballage et le matériel sont très qualitatifs. La télécommande en particulier bénéficie d’une ergonomie parfaite et d’une finition sobre et élégante, avec un très bon toucher, ce qui est très appréciable car ce sera le seul contact quotidien avec le produit.

L’installation quant à elle est plus laborieuse que son concurrent Google Chromecast :

- à peine branché l’appareil vous demandera 10 longues minutes pour optimiser les programmes ; on se retrouve bloqué et impatient devant cette opération dont on se demande vraiment pourquoi elle n’a pas été réalisée avant le déballage…
- l’ensemble de la configuration est effectuée à la télécommande, ce qui est notamment assez peu pratique lorsque vient le temps de la saisie des mots de passe wifi et amazon avec le clavier virtuel ; la solution de Google Chromecast via une application mobile à connexion de proximité et par autoconfiguration des mots de passe est bien plus facile pour la prise en main

Une fois ce paramétrage effectué on arrive enfin sur l’interface principale du Fire TV Stick :

- ![Interface par défaut](/files/2020/07/FireTV-Interface-ParDefaut.png) 
- ![Applications](/files/2020/07/FireTV-Interface-ParDefaut-Apps.png)
- ![Series](/files/2020/07/FireTV-Interface-ParDefaut-Series.png)
{: .gallery .slide .gallery-thumbs .img-center .mw80 }


La navigation est fluide et l’interface est très agréable, avec beaucoup d’animation, d’extraits vidéos. Tout le système est construit autour des contenus Amazon Premium : dans les entrées Films et Séries on voit sans arrêt le contenu Amazon Prime avec incitation à y souscrire. Le catalogue d’applications est assez limité, on y retrouve notamment Netflix, Disney+, YouTube, Twitch, AppleTV, Molotov et Plex, ainsi que quelques jeux.

Bref, sans Amazon Premium, et sauf à utiliser un des fournisseur listé, le Fire TV Stick est peu intéressant.

# Mais une TV sous Android bien plus intéressante en bidouillant un peu

Heureusement, Amazon a eu la bonne idée de laisser le Fire TV Stick assez ouvert, très certainement essentiellement pour que les développeurs puissent développer des applications pour son écosystème, mais cela permet ainsi de pouvoir bénéficier d’une TV sous Android tout à fait intéressante.

## Connecter ADB

Pour ce faire il faut activer depuis le menu Paramètres / Ma Fire TV / Options pour les développeurs deux options :

- l’installation d’applications de sources inconnues pour installer des applications qui ne sont pas dans le store Amazon
- et éventuellement le débogage ADB pour pouvoir se connecter depuis un PC pour installer l’application / paramétrer la Fire TV depuis son PC

![](/files/2020/07/FireTV-Interface-ParametresOptionsDebug.png){: .img-center .mw80}

Nous allons ensuite installer [Aptoide](https://fr.aptoide.com/) qui est un store alternatif permettant d’installer des applications Android qui ne sont pas au catalogue Amazon Fire TV. Il a l’avantage d’une part d’être très pratique à utiliser depuis l’interface de la FireTV (la version normale nécessite l’usage de la souris mais il existe une version spécifique pour les TV), et d’autre part d’être assez utilisé, on peut donc imaginer lui faire un peu plus confiance qu’aux innombrables sites plus ou moins recommandables qui proposent de télécharger les apk. Même si on n’imagine pas spécialement d’usages professionnels ou avec données sensibles sur une Fire TV, cette dernière peut tout de même constituer une porte d’accès à votre réseau local. Il vaut donc mieux éviter d’y installer n’importe quoi.

La méthode la plus simple est sans doute de se rendre à l’adresse <https://fr.aptoide.com/> en recherchant aptoide depuis un navigateur du store Amazon (comme Firefox), de télécharger et d’installer l’application depuis le Fire TV. Cependant comme nous aurons spécifiquement besoin d’ADB pour la configuration du launcher, je trouve plus simple d’utiliser ADB pour l’ensemble.

La première chose à faire est de prendre le contrôle de votre Fire TV depuis votre PC. Pour ce faire, il vous faut ADB (Android Debug Bridge). Il existe de multiples façons de l’installer, et notamment celle d’installer Android SDK, ce qui est peut être un peu beaucoup simplement pour ce que nous voulons faire. Sous Linux votre distribution devrait intégrer directement le package adb. Sous Windows, j’aime bien utiliser l’installeur [scoop.sh](https://scoop.sh/) qui facilite grandement les installations et mises à jour de logiciel de ce type. Une fois scoop.sh installé en suivant le guide sur leur page, il vous suffira d’une commande `scoop install adb` pour installer ADB.

Une fois ADB installé, vous devez identifier l’adresse IP de la FireTV. Vous pourrez la trouver depuis l’interface de la FireTV dans Paramètres / Ma Fire TV / A propos / Réseau. Dans la suite de cet article j’utiliserai l’adresse 192.168.0.53 qu’il vous faudra remplacer par votre IP. Pour connecter votre FireTV à votre PC, il vous faudra depuis une ligne de commande avec ADB (PowerShell si vous avez installé via scoop.sh) :

```shell
adb connect 192.168.0.53
```

Cette commande lancera l’association de votre FireTV à votre PC. Il vous faudra aller confirmer la connexion sur l’interface de la Fire TV. Une fois la connexion établie, vous pouvez vérifier qu’elle fonctionne via la commande :

```shell 
adb devices
```

Vous devriez voir quelque chose comme :

```
List of devices attached
192.168.0.53:5555       device
```

Si jamais cet affichage vous signale le device comme `offline` , notamment si vous souhaitez utiliser à nouveau ADB quelques jours après l’appairage initial, alors relancez le serveur ADB et la connexion avec ces commandes :

```shell
adb kill-server
adb start-server
adb devices
adb connect 192.168.0.53
```

## Contrôle total depuis PC avec scrcpy

Une fois votre Fire TV Stick associée à votre PC, vous pouvez en prendre complètement le contrôle avec l’application [scrcpy](https://github.com/Genymobile/scrcpy) à télécharger directement depuis leur page GitHub (<https://github.com/Genymobile/scrcpy>). Une fois téléchargée et décompressée, lancez l’application directement en double cliquant sur scrcpy.exe, vous devriez voir apparaître alors l’écran de votre Fire TV Stick comme sur votre télévision, et vous pouvez utiliser le clavier et la souris pour contrôler l’écran, ce qui devrait nettement vous faciliter la vie pour les étapes de configuration ci-dessous.

## Installation de base : Aptoide, FTVLaunchX, MouseToggle

Après avoir téléchargé aptoide depuis <https://tv.aptoide.com/howtoinstall.html> ou <https://fr.aptoide.com/download> , installez le avec la commande, lancée depuis le répertoire contenant le fichier téléchargé :

```shell
adb install aptoide-lastest.apk
```

A la fin de l’opération, qui peut durer quelques minutes, vous devriez voir apparaître l’application Aptoide dans le menu Applications de votre FireTV.

Nous allons installer deux applications supplémentaires :

- Une application pour remplacer la page d’accueil par un lanceur plus adapté pour un usage essentiellement d’applications Android : [FTVLaunchX](https://github.com/codefaktor/FTVLaunchX)
- Le lanceur [TVLauncher](https://tvlauncher.en.aptoide.com/app) (que je trouve très pratique, mais il en existe plein d’autres)
- Un émulateur de souris pour les applications qui ne sont pas compatibles avec l’usage seul de la télécommande : [Mouse Toggle Firestick](https://www.firesticktricks.com/mouse-toggle-firestick.html)

Pour le premier, il faut bien sûr l’installer comme d’habitude, mais également lui donner l’autorisation de remplacer la page d’accueil, au démarrage ou lorsque d’un appui sur la touche accueil sur la télécommande. Il a pour cela besoin d’une autorisation spéciale d’écriture. Après avoir téléchargé le fichier APK depuis leur page Github <https://github.com/codefaktor/FTVLaunchX> :

```shell
adb install .\FTVLaunchX-1.0.1.apk
adb shell pm grant de.codefaktor.ftvlaunchx android.permission.WRITE_SECURE_SETTINGS
```

Il faut ensuite installer un lanceur, par exemple [TVLauncher](https://tvlauncher.en.aptoide.com/app) (que vous pouvez installer via Aptoide directement), puis lancer depuis le Fire TV Stick le programme FTVLaunchX. il vous permettra alors de choisir depuis une liste déroulante des applications installées celle à utiliser en page d’accueil :

![](/files/2020/07/FireTV-Interface-LauncherX.png){: .img-center .mw60}

Vous pouvez ensuite personnaliser votre page d’accueil avec un résultat très lisible et clair :

![](/files/2020/07/FireTV-Interface-TVLaunch.png){: .img-center .mw60}

L’émulateur de souris s’installe très simplement via l’apk téléchargeable depuis <https://www.firesticktricks.com/mouse-toggle-firestick.html> . La souris s’active via un double appui sur la touche Play/Pause. Vous verrez apparaitre un curseur qu’il est possible de déplacer avec les touches de direction. Lors de l’installation il est potentiellement nécessaire de lancer l’application et demander l’arrêt / démarrage du service pour qu’il devienne complètement fonctionnel.

## Installation de vos applications

C’est maintenant à vous d’installer les applications Android que vous souhaitez utiliser sur votre FireTV.

Pour ma part j’utilise principalement **myCanal**, encore plus pratique à utiliser sur FireTV que sur Chromecast et **KODI**  dont l’installation est décrite un peu plus en détail ci-dessous.

J’ai également installé :

- VLC (depuis le store Amazon) et DG UPnP Player, qui fonctionnent mieux que Kodi pour l’ UPNP / DLNA
- YouTube (depuis le store Amazon), mais ma TV intégrant nativement YouTube je n’ai pas vraiment d’intérêt d’utiliser l’application depuis le FireTV
- OrangeTV pour accéder au bouquet OrangeTV sur la TV sans avoir à payer le boitier ; en pratique l’abonnement mycanal fait bien mieux, et en gratuit Kodi fait aussi bien et l’interface Orange est infestée de publicité (parfois 7 publicités avant de lancer un programme !). L’application ne fonctionne pas très bien avec la télécommande donc il sera nécessaire de recourir parfois à l’émulation de la souris. Pour entrer l’utilisateur et le mot de passe il est indispensable de passer par scrcpy sur PC. Passée l’opération de configuration l’application fonctionne raisonnablement bien.
- ES Explorateur (depuis le store Amazon)

# Installation de Kodi

Kodi est un MediaPlayer très performant et très configurable. Disponible sur de nombreuses plateformes il fonctionne également sur Fire TV Stick. Vous pouvez l’installer depuis Aptoide : <https://kodi.en.aptoide.com/app> ou via l’APK du site officiel via la procédure que vous connaissez bien maintenant.

J’ai suivi pour la configuration l’article suivant de 01net : <https://www.01net.com/astuces/creez-facilement-votre-propre-box-tv-grace-au-raspberrypi-1927083.html>

Pour accéder aux chaînes TV, il vous faudra ajouter les extensions :

- Catch Up TV &amp; More
- PVR IPTV Simple Client (IPTVREcorder) ; pour ce dernier deux petites subtilités sous FireTVStick par rapport à ce qui est décrit dans l’article de 01net pour raspberry : 
    - Il faut activer les fichiers cachés dans le menu Parametres / Medias de Kodi (sinon le répertoire .kodi n’est pas visible)
    - L’emplacement du fichier des chaines est un peu différents ; dans les paramètres IPTVREcorder : 
        - Channel : `/sdcard/Android/.kodi/addons/plugin.video.catchupandmore/resources/m3u/live\_tv\_all.m3u`
        - TVGuide : `http://bit.ly/tvguidefr`

Pour voir des contenus depuis des serveurs UPnP / DLNA il faudra ajouter une source vidéo `upnp://` pour la découverture automatique. Une fois un serveur trouvé, vous pourrez également l’ajouter directement comme source. Le fonctionnement est parfois étrange et les premiers temps Kodi ne trouvait aucun serveur DLNA alors que VLC et DG UPnP Player arrivait bien à les trouver. Il fonctionne par contre parfaitement bien avec des partages réseau Windows, ce que j’utilise donc prioritairement.

Je trouve l’interface par défaut très agréable à utiliser, mais elle a le gros défaut de ne pas avoir un menu configurable. Il existe pour cela un certain nombre d’autres “Habillages” (Skins) entièrement configurables, mais que je trouve pour l’instant moins aboutis que l’interface par défaut.

Il existe un nombre impressionnant d’extensions pour faire un peu tout ce à quoi vous pourriez penser, et même un peu plus. Attention cependant à la place disponible sur le Fire TV Stick dont la place mémoire n’est pas infinie 🙂

# Pour aller encore plus loin…

Voici quelques autres ressources utiles autour de la personnalisation du Fire TV Stick :

- <https://forum.xda-developers.com/fire-tv>
- <https://www.firesticktricks.com/>
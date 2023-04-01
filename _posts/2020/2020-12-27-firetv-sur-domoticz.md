---
post_id: 5199
title: 'FireTV sur Domoticz'
date: '2020-12-27T18:03:37+01:00'
last_modified_at: '2020-12-27T18:03:37+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5199'
slug: firetv-sur-domoticz
permalink: /2020/12/firetv-sur-domoticz/
image: /files/2020/07/AmazonFireStick.jpg
categories:
    - Domotique
tags:
    - Domoticz
    - FireTV
    - TV
    - adb
    - allumer
    - Domotique
    - remote
    - télécommande
lang: fr
---

À la suite des articles sur ma clé [Amazon Fire TV](/2020/07/firetv-tv-android-pas-chere/) et ma [TV Panasonic sur Domoticz](/2020/12/domoticz-panasonic-remote-buttons-and-custom-urls/) il était logique que je m’intéresse à la Fire TV sur Domoticz, d’autant plus que cette dernière permet d’allumer la TV via HDMI CEC, ce qui permettrait de pallier le fait que ma TV ne s’allume pas avec le Wake On LAN.

On a déjà vu dans l’article précédent qu’il est facile de commander la Fire TV depuis un ordinateur via adb et on va continuer à utiliser cette technique. Pour se connecter via adb il faut :

- Installer ADB : pour Debian : `apt install adb`
- Autoriser les connexions ADB sur la FireTV via l’option “Debogage ADB” dans le menu Options pour les développeurs
- Connecter le device avec la commande suivante : `adb connect 192.168.0.95` (en remplaçant 192.168.0.95 avec l’adresse de votre FireTV)
- Suivre à l’écran de la Fire TV la procédure d’authentification pour la première connexion (ne sera pas demandé pour les connexions suivantes)
- Si la connection avec adb est perdue : `adb kill-server ; adb start-server ; adb connect 192.168.0.95 ; adb devices` ; cette dernière commande doit lister l’adresse IP de votre FireTV avec la mention device

Ce qui m’a pris le plus de temps est de trouver le moyen d’allumer la TV via des commandes adb. En effet, on pense assez naturellement qu’il suffit d’émuler un appui sur la touche POWER, ce qui se fait simplement avec `adb shell input keyevent KEYCODE_POWER` (ou 26). Malheureusement ça ne fonctionne pas pour moi. En fait en testant un peu plus ma télécommande, les boutons Power et de volume ne passent pas par la Fire TV, mais par infrarouge directement sur la TV (c’est pour cela qu’il y a plusieurs profils de TV réglables dans la FireTV pour que la télécommande soit paramétrée avec les bons codes infrarouge). En cherchant un peu plus, il se trouve que l’appui sur la touche HOME permet également d’allumer la TV, et cette fois-ci en passant bien par le CEC. Malheureusement, même problème `adb shell input keyevent KEYCODE_HOME` (ou 3) ne réveille pas la TV. J’ai alors voulu investiguer sans succès d’autres pistes, en cherchant un binaire sur la FireTV qui permette de controler directement l’interface CEC (j’ai trouvé mt8127\_hdmi qui semble pouvoir envoyer des commandes CEC mais impossible de le faire fonctionner, cela nécessite sans doutes les droits root nécessaire pour les autres méthodes telles que la command hdmi ou l’envoi de commandes directement aux interfaces), ou via [Whisperplay](https://developer.amazon.com/fr/docs/fire-tv/dial-integration.html) (qui implémente le protocole [DIAL](http://www.dial-multiscreen.org/) de Netflix) ou encore en essayant de comprendre le protocole de la télécommande de l’application [Amazon Fire TV](https://play.google.com/store/apps/details?id=com.amazon.storm.lightning.client.aosp&hl=fr&gl=US), ou encore en observant les logs de la FireTV avec logcat pour essayer d’émuler un appui sur la télécommande. Malheureusement aucune de ces méthodes ne s’est révélée payante, bien que chacune soit intéressante pour apprendre de nouveaux protocoles et connaître les possibilités de la FireTV.

Et puis je suis tombé sur le dépôt de [python-firetv](https://github.com/happyleavesaoc/python-firetv) dans lequel une méthode comportant l’appui de la touche POWER et HOME est utilisée. Je tente en désespoir de cause, et hourra, ça marche !

```
adb shell 'input keyevent 26 && input keyevent 3'
```

On va maintenant pouvoir intégrer l’allumage dans Domoticz. Pour cela on va créer un script pour permettre d’envoyer des commandes via adb, placé dans domoticz/scripts :

```
#!/bin/sh -x
adb $*

```

Puis `chmod +x adb` pour rendre le script exécutable. Comme le script est prévu pour passer tous les arguments ce n’est pas forcément très sécurisé, et si votre server domoticz est exposé sur internet il faudra mieux créer un script par action à lancer avec l’ensemble des paramètres déjà renseignés dans le script, par exemple pour allumer : adb-on

```
#!/bin/sh -x
adb shell 'input keyevent 26 && input keyevent 3'

```

Ensuite dans domoticz, sur l’appareil que vous voulez allumer, dans l’action ‘On’ ajouter le script :  
![](/files/2020/12/firetv_adbon.png){: .img-center}

Pour contrôler un peu plus la FireTV j’ai créé un device “Dummy”. Il faut aller dans Hardware, sur le composant “Dummy” et cliquer sur “Créer un capteur virtuel” (si “Dummy” n’existe pas, il faut l’ajouter depuis la liste déroulante en bas de ce même écran). J’ai sélectionné un interrupteur avec sélecteur.![](/files/2020/12/domoticz_creer_capter_virtuel.png){: .img-center}

Sur la page Interrupteur, on peut alors cliquer sur modifier pour paramétrer les actions pour ce capteur virtuel :

![](/files/2020/12/firetv_domoticz.png){: .img-center}

Ce qui va donner :

![](/files/2020/12/firetv_domoticz_bouton.png){: .img-center}

J’ai fait le choix de mettre l’action On / Off sur la TV, mais sinon on peut tout à fait ajouter une action “On” du sélecteur avec notre script (et une action “Off”). J’ai par ailleurs déclaré cet équipement “FireTV” comme esclave de l’équipement “TV” (permet d’éteindre automatiquement l’un avec l’autre).

La commande `adm am start` permet de démarrer n’importe quel application installée sur la Fire TV. Pour rechercher la chaine à indiquer, il suffit de chercher dans la liste des paquets installés avec la commande `adb shell ‘pm list packages -f’` :

```
$> adb shell 'pm list packages -f' | grep -i youtube
package:/data/app/com.amazon.firetv.youtube-2/base.apk=com.amazon.firetv.youtube

```

Il est même possible possible de lancer une page particulière de l’application si l’application le permet. Il faut pour cela repérer l’identifiant de l’activité avec une application comme [Package Browser](https://play.google.com/store/apps/details?id=by4a.reflect&hl=fr&gl=US) puis de l’ajouter à la commande start sous la forme ‘application/activity’. Malheureusement très peu d’applications rendent publiques leur activité ce qui limite cet usage.
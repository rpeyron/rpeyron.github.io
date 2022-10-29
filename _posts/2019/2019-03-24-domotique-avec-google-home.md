---
post_id: 4018
title: 'Domotique avec Google Home'
date: '2019-03-24T20:41:22+01:00'
last_modified_at: '2021-06-12T19:30:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4018'
slug: domotique-avec-google-home
permalink: /2019/03/domotique-avec-google-home/
image: /files/2018/11/domotique_1553451979.jpg
categories:
    - Domotique
lang: fr
---

J’ai acheté un Google Home Mini récemment, il fonctionne très bien pour ce pour quoi je l’ai acheté, à savoir la lecture de Spotify, le controle du chromecast, et les autres détails pratiques (réveil, météo, minuteur,…). Vous pouvez tester la majorité des fonctions sur le Google Assistant sur android, mais bien que j’ai un téléphone haut de gamme, le Google Home Mini est bien plus fluide. Compte-tenu des fonctions domotique de Google Home j’ai voulu alors le tester le raccordement avec ma solution de domotique actuelle.

Ma solution domotique existante est assez simple :

- 3 prises connectées Sonoff S20 (maintenant remplacées par le [modèle S26](https://fr.aliexpress.com/item/2-pi-ces-Sonoff-S26-WiFi-prise-intelligente-US-EU-UK-prise-sans-fil-Prise-de/32972099297.html?spm=a2g0w.search0604.3.62.51cd1967wADCIl&transAbTest=ae803_3&ws_ab_test=searchweb0_0%2Csearchweb201602_7_10065_10068_319_10892_317_10696_10084_453_454_10083_10618_10304_10307_10820_10821_537_10302_536_10902_10843_10059_10884_10887_321_322_10103%2Csearchweb201603_57%2CppcSwitch_0&algo_pvid=127a8464-eae2-4b8a-992c-f32f0122f963&algo_expid=127a8464-eae2-4b8a-992c-f32f0122f963-8), bien prendre les prises EU Type E pour la France), flashées avec le firmware [Tasmota](https://github.com/arendst/Sonoff-Tasmota) pour pouvoir utiliser dans d’autres outils que la solution propriétaire fournie par défaut.
- 1 thermomètre externe [La Crosse WS-9160IT](http://www.lacrossetechnology.fr/P-7-A1-WS9160.html) plutôt basique mais qui est bon marché et mesure correctement la température extérieure (ce modèle émet en 838MHz)
- un serveur [Domoticz](http://www.domoticz.com/) sous debian, avec un serveur MQTT mosquitto, et [rtl_433](https://github.com/merbanan/rtl_433) et une clé USB DVB-T [RTL2832](https://www.rtl-sdr.com/buy-rtl-sdr-dvb-t-dongles/) pour capter les signaux 433Mhz et 838 MHz

L’ensemble a été plutôt facile à mettre en place à l’époque en suivant les indications des sites. Pour que rtl_433 puisse également capter les signaux 838, j’ai utilisé les paramètres suivants dans Domoticz : “-f 433.92e6 -f 868.34e6 -H 60” (cela dit en gros de regarder 60s sur la fréquence 433 MHz, puis 60s sur 868 MHz). Le flashage des Sonoff est le plus compliqué car il faut démonter la prise et se connecter avec un dongle série pour pouvoir flasher, puis arriver à se connecter sur le Wifi.

Le paramétrage du Google Home Mini lui même est super simple est super bien fait. Le raccordement à ma solution existante s’est révélée beaucoup plus compliquée. A noter que ce ne sont pas des produits certifiés Google Home, ce n’est donc pas anormal.

Domoticz n’est pas nativement compatible avec Google Home : un service cloud tiers Connecticz, rend ce service de manière payante. J’ai donc regardé pour changer ma solution Domoticz par autre chose. Il y a deux concurrents majeurs opensouce. Home Assistant et OpenHAB :

- Home Assistant est visuellement très réussi et assez simple. Il dispose d’une intégration avec Google Home dont le logiciel est open source et peut être configuré chez soi, ou une instance cloud préconfigurée payante. S’il met à disposition de nombreuses images pour Raspberry et autres, il ne dispose pas de paquet pour debian. L’installation via pip3 install ne fonctionne pas sauf à faire tourner la solution en root ce qui est vraiment à éviter pour ce genre de produits ; l’alternative est une image docker de plus de 2 Go ! Je suis donc passé à l’autre produit compte tenu de l’installation trop complexe sur debian.
- OpenHAB pour sa part s’installe très simplement avec des packages debian. Il est cependant plus complexe dans son interface (plusieurs interfaces à utiliser), et encore plus dans son paramétrage : les écrans de paramétrage ne sont pas encore tous implémentés et il faut paramétrer la majorité via édition de fichiers de paramétrage. L’ensemble est très puissant, avec de nombreuses intégrations disponibles et fonctions, mais qu’il n’est pas forcément facile à comprendre.

Malgré tous les connecteurs disponibles avec OpenHAB il n’y a cependant pas ce qui faut pour les deux fonctions que j’utilise, à savoir les Sonoff Tasmota et rtl_433 :

- Pour les Sonoff Tasmota je suis passé par l’intégration via MQTT, ce n’est pas super intuitif mais ça se fait bien : après avoir activé le binding MQTT, il faut installer un “MQTT Broker” pour établir la connexion avec mon serveur mosquitto, puis ensuite un “Generic MQTT Thing” sur lequel on va pouvoir ajouter les topics des switch tasmota (les mêmes que ceux configurés dans les écrans de configuration de tasmota, par ex : sonoff/cmnd/power et sonoff/stat)
- Pour les températures en provenance de rtl_433 c’est plus galère, mais la solution est également via MQTT. Le plus simple est via l’injection des commandes rtl_433 dans MQTT, via un daemon hyper simple comme [`rtl_433 -q -F json | mosquitto\_pub -h localhost -i rtl_433 -l -t rtl_433/JSON`](https://tech.sid3windr.be/2017/03/getting-your-currentcost-433mhz-data-into-openhab-using-an-rtl-sdr-dongle-and-mqtt/) , mais comme OpenHAB n’est pas encore complètement au point j’ai opté pour conserver Domoticz qui a l’énorme avantage d’avoir un discovery automatique des devices rtl_433, et de le faire publier sur le MQTT (dans un topic domoticz/out).

Il faut ensuite paramétrer a minima les items et sitemap pour OpenHAB:

```
Switch Switch1 "Switch 1" <switch> ["Switchable"] { channel = "mqtt:topic:d6a7c910:switch1" } 
Switch Switch3 "Anet" <switch> ["Switchable"] { channel = "mqtt:topic:0091c093:4562" } 
Number Cuisine_Ext_Temperature "Temperature [%.1f Â°C]" ["CurrentTemperature"] { channel="mqtt:topic:0091c093:1242", mqtt="<[broker:domoticz/out:state:JSONPATH($.svalue1):.*\"idx\" \\: 136,.*]" }
```

```
sitemap default label="Principal"
{
   Switch item=Switch1 label="Switch 1"
   Text item=Cuisine_Ext_Temperature label="Cuisine Ext [%.1f Â°C]"
}
```

A noter les tags \[“Switchable”\] et \[“CurrentTemperature”\] qui vont permettre de rendre disponibles ces items sur Google Home. Pour ce faire, il faut configurer un compte sur myopenhab.org et le raccorder à votre installation OpenHAB2 via les codes de votre instance (UUID et secret) et le binding “openHAB Cloud”. Pas besoin d’ouvrir de port dans votre firewall c’est votre serveur qui va ouvrir la connexion au serveur cloud. Puis depuis l’application Google Home sur un smartphone, ajouter le service “openHAB” en renseignant vos identifiants. Vous verrez alors apparaître les items paramétrés !

Il est alors désormais possible de les lancer depuis l’interface Google Home, ou de demander à l’assisant “Allumer Switch 1”, “Eteindre Switch 1” ! Ok c’est clairement plus galère que d’acheter la prise directement compatible Google Home, ou de laisser le firmware par défaut des Sonoff, mais ça permet d’avoir une solution ouverte et de mieux comprendre comment cela fonctionne !
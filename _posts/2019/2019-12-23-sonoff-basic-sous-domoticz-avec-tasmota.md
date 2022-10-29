---
post_id: 4170
title: 'Sonoff Basic sous Domoticz avec Tasmota'
date: '2019-12-23T14:05:37+01:00'
last_modified_at: '2020-04-06T21:18:46+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4170'
slug: sonoff-basic-sous-domoticz-avec-tasmota
permalink: /2019/12/sonoff-basic-sous-domoticz-avec-tasmota/
post_grid_post_settings: 'a:14:{s:9:"post_skin";s:4:"flat";s:19:"custom_thumb_source";s:91:"/wp-content/plugins/post-grid/assets/frontend/css/images/placeholder.png";s:16:"thumb_custom_url";s:0:"";s:17:"font_awesome_icon";s:0:"";s:23:"font_awesome_icon_color";s:0:"";s:22:"font_awesome_icon_size";s:0:"";s:17:"custom_youtube_id";s:0:"";s:15:"custom_vimeo_id";s:0:"";s:21:"custom_dailymotion_id";s:0:"";s:14:"custom_mp3_url";s:0:"";s:20:"custom_soundcloud_id";s:0:"";s:16:"custom_video_MP4";s:0:"";s:16:"custom_video_OGV";s:0:"";s:17:"custom_video_WEBM";s:0:"";}'
image: /files/2019/12/sonoff-basic-r2.jpg
categories:
    - Domotique
tags:
    - Domoticz
    - Tasmota
lang: fr
---

Les dispositifs Sonoff Basic sont une solution très économiques pour controller en wifi l’alimentation électrique d’un appareil.   
J’avais déjà eu l’occasion d’utiliser des produits Sonoff S20 qui prennent la forme d’une prise gigogne électrique. On en trouve entre 10 et 20 euros. Ils fonctionnent très bien, avec deux petits défauts : l’emplacement important sur une prise multiple qui condamne facilement 2 ou 3 emplacements de prise, et le branchement des fils pour le flashage qui n’est pas facile. Sonoff a récemment sorti un mode “DIY” (Do It Yourself) qui permet en principe si j’ai bien compris une interface REST pour commander le Sonoff et la possibilité de flasher en OTA sans avec à brancher. Les Sonoff Basic sont très économiques, et j’en ai trouvé à moins de 4 € pièce ! Cependant la mention “DIY” s’est révélée inexacte et j’ai été livré de Sonoff Basic R2 qui ne dispose pas de cette fonctionnalité. Néanmoins, ces produits se sont révélés très faciles à utiliser, et parfaits pour mon usage.

Les produits Sonoff arrivent avec un firmware propriétaire qui permet de les utiliser avec la solution cloud propriétaire Sonoff, et l’application mobile eWeLink. Cette solution fonctionne très bien pour un usage basique et s’intègre nativement à Google Home et Alexa. Cependant elle nécessite une connexion extérieure, de faire confiance à cette plateforme externe et ne permet pas de s’intégrer au logiciel [Domoticz](https://www.domoticz.com/) que j’utilise par ailleurs. Comme ces dispositifs sont basés sur une puce ESP8266, il existe de nombreux firmwares alternatifs pour ouvrir la solution et la rendre compatible avec Domoticz. Ce faisant vous perdrez l’usage du cloud eWeLink (application eWeLink, lien avec Google Home / Alexa), mais si vous changez d’avis vous pourrez toujours rétablir le firmware précédent. J’ai pour ma part choisi le firmware [Tasmota](https://tasmota.github.io/docs/#/Home) qui est un projet très actif, dispose d’un excellent support et de nombreuses fonctionnalités.

Il vous faudra pour cela un [adaptateur FTDI USB TTL](https://www.amazon.fr/s?k=ftdi+usb+ttl&__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&ref=nb_sb_noss_2) qui se trouve très facilement pour quelques euros. Prenez de préférence un modèle que vous pouvez régler en 5V ou en 3.3V qui pourra vous être utile dans plus de situations. Prévoyez également [4 cables Dupont male-femelle](https://www.amazon.fr/s?k=cables+dupont+male+femelle&__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&ref=nb_sb_noss_2) pour relier l’adaptateur à votre Sonoff.

La première étape est d’ouvrir le Sonoff. Pour que ce soit plus facile, je vous recommande de flasher le firmware et de faire tous vos réglages avant installation sur votre appareil. L’alimentation de l’adaptateur FTDI sera suffisante pour faire fonctionner l’appareil sans branchement (et au contraire, ne procédez surtout pas au flashage alors que l’appareil est branché au 220V !). En l’absence des vis pour fixer le cable secteur, le Sonoff se déboîte très simplement :

![](/files/2019/12/20191221_181123.jpg){: .img-center}

On repère aisément les connecteurs série au milieu du circuit imprimé. Pour la qualité des connections, il est recommandé de souder les fils ou un ensemble de broches (“pin header”). Cependant pour ma part, comme je suis flemmard j’ai essayé de simplement enfoncer les cables dupont dans les trous et cela a plutôt bien marché. Il faut juste faire attention de ne pas toucher le dispositif lors du flashage pour éviter une déconnexion intempestive. Il faudra croiser les connecteurs TX/RX, c’est à dire brancher la broche TX (émetteur) du FTDI sur la borne RX (récepteur) du Sonoff, et le RX du FTDI sur le TX du Sonoff.

![](/files/2019/12/20191221_201805-300x225.jpg) ![](/files/2019/12/20191221_212848-300x225.jpg) ![](/files/2019/12/20191221_212834-225x300.jpg)
{: .center}

Deux petites précautions à prendre :

- Faites les branchements initiaux alors que le FTDI n’est pas encore branché en USB pour éviter toute erreur de manipulation
- Le driver des FTDI peut être parfois capricieux et des branchements trop fréquents peuvent conduire à un écran bleu : préférez donc pour réinitialiser le Sonoff ou la connexion de débrancher et rebrancher le fil 5V ou GND depuis le FTDI.

Une fois le branchement réalisé, il faut flasher ! Pour ce faire je vous conseille le logiciel [Tasmotizer](https://github.com/tasmota/tasmotizer) qui est d’une simplicité remarquable. Si vous préférez la ligne de commande j’indique plus bas les lignes de commande à utiliser.

![](/files/2019/12/sonoff_domoticz_0_flash-300x233.jpg) ![](/files/2019/12/sonoff_domoticz_1_config-300x176.jpg)
{: .center}

Pour pouvoir interagir avec le firmware, l’appareil doit être mis en position programmation. Pour ce faire, il suffit de maintenir le bouton du Sonoff appuyé lors de sa mise sous tension. A noter que ce statut est réinitialisé à la fin de chaque opération, il vous faudra potentiellement renouveler l’opération, par exemple entre le backup du firmware précédent et le flashage du nouveau. Voici les étapes à suivre pour flasher le firmware :

1. Mettre le Sonoff en mode programmation (mise sous tension du Sonoff tout en maintenant le bouton du Sonoff appuyé)
2. Faire un backup du firmware précédent (pour pouvoir le réinstaller si vous changez d’avis) en cochant “Backup original firmware”. Comme l’état de programmation est remis à zéro suite au backup, le flashage va échouer, pas de panique, il suffit de recommencer :
3. Mettre le Sonoff en mode programmation (mise sous tension du Sonoff tout en maintenant le bouton du Sonoff appuyé)
4. Lancer le flashage, sans l’option “Backup original firmware”
5. Rebooter le Sonoff (en débranchant &amp; rebranchant la broche d’alimentation depuis le FTDI)
6. Puis paramétrez votre firmware Tasmota via le bouton Send config, en indiquant votre Wifi, et éventuellement d’autres paramètres comme votre serveur MQTT (voir ci-dessous si vous n’en avez pas déjà installé). Tasmota permet d’autres modes de paramétrage initial, mais celui-ci est pour moi le plus facile.

Avec cette dernière étape, le Sonoff devrait rebooter et se connecter à votre Wifi. Identifiez son adresse IP via l’interface de votre box et connectez vous à l’interface web du Sonoff pour finaliser la configuration Domoticz.

En ligne de commande :

<details markdown="1"><summary>En ligne de commande</summary>

Pré-requis : disposer d'une installation python fonctionnelle

1\. Installez esptool :

```
C:\Users\remip\Downloads\Sonoff>pip install esptool
```

2\. Identifiez / Vérifiez votre composant :

```
C:\Users\remip\Downloads\Sonoff>esptool.py flash_id
esptool.py v2.8
Found 1 serial ports
Serial port COM2
Connecting....
Detecting chip type... ESP8266
Chip is ESP8285
Features: WiFi, Embedded Flash
Crystal is 26MHz
MAC: dc:4f:22:b0:85:65
Uploading stub...
Running stub...
Stub running...
Manufacturer: 51
Device: 4014
Detected flash size: 1MB
Hard resetting via RTS pin...
```

L'information importante à repérer ici est la taille de la mémoire flash. Normalement, elle devrait être de 1MB. Si ce n'est pas le cas, il faut modifier les commandes suivantes pour refléter la bonne taille de flash.

A noter que pour réaliser cette opération, vous devez être en mode programmation, obtenu en mettant sous tension le Sonoff tout en appuyant sur son bouton. Si ce n'est pas le cas, vous verrez le message suivant :

```
C:\Users\remip\Downloads\Sonoff>esptool.py flash_id
esptool.py v2.8
Found 1 serial ports
Serial port COM2
Connecting........_____....._____....._____....._____....._____....._____....._____
COM2 failed to connect: Failed to connect to Espressif device: Timed out waiting for packet header

A fatal error occurred: Could not connect to an Espressif device on any of the 1 available serial ports.
```

Suite à chaque opération avec esptool, ce mode programmation est réinitialisé. Vous devrez donc remettre le Sonoff en mode programmation avant toute nouvelle opération.

3\. Sauvegardez votre firmware actuel :

```
C:\Users\remip\Downloads\Sonoff>esptool.py read_flash 0x00000 0x100000 image1M.bin
esptool.py v2.8
Found 1 serial ports
Serial port COM2
Connecting....
Detecting chip type... ESP8266
Chip is ESP8285
Features: WiFi, Embedded Flash
Crystal is 26MHz
MAC: dc:4f:22:b0:85:65
Uploading stub...
Running stub...
Stub running...
1048576 (100 %)
1048576 (100 %)
Read 1048576 bytes at 0x0 in 95.5 seconds (87.8 kbit/s)...
Hard resetting via RTS pin...
```

4\. Flashez avec le firmware Tasmota :

```
C:\Users\remip\Downloads\Sonoff>esptool.py write_flash -fs 1MB -fm dout 0x0 tasmota.bin
esptool.py v2.8
Found 1 serial ports
Serial port COM2
Connecting....
Detecting chip type... ESP8266
Chip is ESP8285
Features: WiFi, Embedded Flash
Crystal is 26MHz
MAC: dc:4f:22:b0:85:65
Uploading stub...
Running stub...
Stub running...
Configuring flash size...
Compressed 1048576 bytes to 626120...
Wrote 1048576 bytes (626120 compressed) at 0x00000000 in 55.5 seconds (effective 151.3 kbit/s)...
Hash of data verified.

Leaving...
Hard resetting via RTS pin...
```

Rebootez votre équipement, vous devriez maintenant pouvoir le configurer. Le Sonoff va alors créer un réseau wifi sur lequel vous allez devoir vous connecter, puis vous connecter sur la page de configuration pour entrer vos paramètres wifi (pour plus de détails, suivez les instructions sur la page [Tasmota / Initial configuration](https://github.com/arendst/Tasmota/wiki/initial-configuration))

Configurez également sur votre Tasmota votre serveur MQTT (voir ci-dessous si vous n'en avez pas déjà un d'installé)

![](/files/2020/04/Tasmota_MQTT-200x300.jpg){: .img-center}

</details><br>

Pour inclure le dispositif dans la configuration Domoticz il faut que le dispositif Sonoff et Domoticz soit en mesure de communiquer en MQTT. Pour ce faire il est nécessaire de configurer un broker MQTT. Vous pouvez passer cette étape si vous disposez déjà d’un serveur MQTT configuré pour Domoticz, sinon dépliez la section suivante.

<details markdown="1"><summary>Configurer MQTT pour Domoticz</summary>

1. Installer un serveur MQTT, par exemple mosquitto : sous Debian/Ubuntu : `sudo apt install mosquitto mosquitto-clients` (le premier paquet est le composant serveur, le second les clients en ligne de commande pour tester)
2. Par défaut le serveur est directement fonctionnel. Gardez en tête que la configuration par défaut ne sécurise pas votre serveur MQTT, ce qui n'est pas dérangeant tant que celui-ci reste bien limité à votre réseau local. N'ouvrez surtout pas le port MQTT sur votre routeur !
3. Il faut ensuite configurer Domoticz pour le lier au server MQTT : dans l'écran Matériel, ajouter un matériel de type "MQTT Client Gateway", et renseignez l'adresse IP et le port de votre serveur MQTT (localhost s'il est sur la même machine, et sur le port 1883 par défaut)  
    ![](/files/2020/04/Domoticz_MQTT.jpg){: .img-center}
4. Désormais Domoticz va publier les évènements sur la file `domoticz/out` et s'abonner `domoticz/in` (suivant le paramètre "publish\_topic", conserver "out +/" par défaut)
5. Vous pouvez tester via la commande `mosquitto_sub -t "domoticz/out"` qui va afficher tous les évènements MQTT sortant de domoticz (si vous ne voyez rien, assurez vous qu'il y a bien des évènements dans Domoticz !)
6. Il vous faudra ensuite indiquer l'adresse de votre serveur MQTT sur chaque device Tasmota. Pour éviter tout ennui avec des adresses IP qui changent, des entrées DNS qui sont mal mises à jour dans les box des opérateurs internet, les adresses IP sauvages, je vous conseille de paramétrer votre serveur avec une IP statique définie dans les paramètres DHCP de votre box (consulter la documentation de votre opérateur, [ici pour une livebox 4 chez orange](https://assistance.orange.fr/livebox-modem/toutes-les-livebox-et-modems/installer-et-utiliser/piloter-et-parametrer-votre-materiel/le-parametrage-avance-reseau-nat-pat-ip/creer-un-reseau-local-a-votre-domicile/livebox-4-attribuer-une-ip-fixe-a-un-equipement_188821-730602)). Dans les copies d'écrans de cette page, l'adresse de mon serveur est 192.168.0.1, veillez à bien adapter cette valeur à votre configuration.

</details><br>

Il est nécessaire maintenant d’inclure ce nouveau dispositif dans la configuration Domoticz. Depuis votre interface Domoticz, on va créer un nouveau capteur :

1. S’il n’existe pas, créez un matériel “Sonoff” de type “Dummy” depuis Réglages / Matériel
2. Vous voyez alors un nouveau matériel dans la liste, avec un bouton “Create un capteur virtuel”:![](/files/2019/12/sonoff_domoticz_2_create_virtual.jpg)
3. Appuyez sur ce bouton et nommez votre nouveau dispositif : ![](/files/2019/12/sonoff_domoticz_2_create_virtual_name-300x173.jpg)
4. Vous retrouverez alors votre nouveau capteur dans la liste Réglages / Dispositifs :![](/files/2019/12/sonoff_domoticz_3_device_list.jpg)  
    Notez bien l’identifiant Domoticz du capteur (ici : 228)

Puis depuis l’interface du Sonoff, cliquez sur Configuration, puis Domoticz, et renseignez l’identifiant du capteur dans le champ Idx :

![](/files/2019/12/sonoff_domoticz_4_http_config-220x300.jpg) ![](/files/2019/12/sonoff_domoticz_4_http_domoticz_config-300x195.jpg)
{: .center}

Validez, le Sonoff va rebooter et être connecté à votre logiciel Domoticz. Un appui dans l’interface devait maintenant allumer ou éteindre votre appareil. Si c’est bien le cas, vous être maintenant prêt pour refermer le Sonoff et l’installer sur votre équipement !

Il existe de nombreuses ressources pour aller plus loin sur l’utilisation de Domoticz et de Tasmota, par exemple :

- [Tasmoticz](https://github.com/joba-1/Tasmoticz) : permet la découverte automatique des équipements sous Tasmota dans Domoticz (et donc simplifier les étapes de configuration ci-dessus)
- Intégrer des composants à votre Sonoff, comme par exemple un capteur de température, de luminosité,…. ; j’en ferai certainement un prochain article, en attendant : [documentation Tasmota](https://tasmota.github.io/docs/#/Components?id=assigning-components), [tutoriel](https://captain-slow.dk/2016/05/24/adding-a-dht22-temperature-and-humidity-sensor-to-the-sonoff/), et [video](https://www.youtube.com/watch?v=VixBNNKykIg)
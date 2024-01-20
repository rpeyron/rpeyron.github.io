---
post_id: 5818
title: 'Piloter votre domotique avec Alexa grâce à ha-bridge + Domoticz ou Tasmota'
date: '2022-08-07T22:04:11+02:00'
last_modified_at: '2022-09-05T19:51:35+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5818'
slug: piloter-votre-domotique-avec-alexa-grace-a-ha-bridge-domoticz-ou-tasmota
permalink: /2022/08/piloter-votre-domotique-via-alexa-grace-a-ha-bridge-domoticz-ou-tasmota/
image: /files/rio-de-janeiro-brazil-august-4-2021-amazon-echo-dot-smart-speaker-with-built-in-alexa-voice-assistant-home-office-stockpack-adobe-stock.jpg
categories:
    - Domotique
tags:
    - Alexa
    - Domoticz
    - habridge
lang: fr
featured: 200
---

Depuis l’arrêt de la version gratuite du plugin [homebridge-alexa](https://github.com/NorthernMan54/homebridge-alexa) dont j’avais décrit l’installation dans [cet article](/2021/01/domoticz-scenarios-par-google-home-ou-alexa-avec-homebridge/), je restais à la recherche d’une solution de remplacement gratuite compte tenu de mon usage anecdotique. J’ai trouvé ha-bridge qui remplace avantageusement la solution précédente.

# Alexa et les dispositifs locaux

Alexa a une particularité très intéressante, c’est qu’il peut découvrir et piloter des équipements domotiques sans devoir obligatoirement passer par les serveurs d’Amazon. Ainsi, il existe plusieurs protocoles fonctionnant uniquement sur votre réseau local avec lesquels Alexa sait s’interfacer, dont le protocole WeMo (Belkin) et le protocole Hue (Philips). Ce dernier est celui qui offre le plus de possibilités, car un même contrôleur permet de commander plusieurs appareils contrairement au premier qui ne permet qu’un seul appareil par contrôleur. Chaque contrôleur expose ainsi un service qui est découvrable via UPnP et qui permet d’allumer, d’éteindre ou de régler l’intensité des ampoules correspondantes.

Le principe des solutions décrites ci-dessous est donc simplement d’émuler ce protocole pour exposer à Alexa les équipements et fonctions domotiques gérées par ailleurs.

L’avantage de cette solution est que les ordres d’allumage et d’extinction des appareils ne transitera pas par internet en passant par des serveurs tiers plus ou moins bien sécurisés. Il n’est pas dit cependant que cela suffisant pour que cela fonctionne sans Internet car il faut que la reconnaissance vocale des dispositifs Alexa puisse fonctionner. Également, il est nécessaire d’avoir un appareil type Echo ou Echo Dot pour faire passerelle. L’application mobile seule ou une Fire TV ne seront pas suffisantes et auront besoin d’un appareil Echo pour fonctionner. En l’occurrence, cela marche parfaitement avec mon Echo Dot 3.

Si vous utilisiez comme moi une autre solution avec celles décrites ci-dessous, n’oubliez pas de désactiver les skills Alexa correspondantes et de supprimer les équipements associés pour éviter tout conflit dans les noms d’appareils. Attention, avec Alexa la suppression d’une skill n’entraine pas la suppression automatique des équipements contrôlés par cette skill, et il vous faudra aller supprimer manuellement chaque équipement un par un.

# Émulation directe avec Tasmota

Si vous utilisez des équipements sous Tasmota, il n’est pas nécessaire d’utiliser autre chose, l’émulation est directement prise en charge par Tasmota et il suffit de l’activer dans les paramètres, dans le menu “Configuration” / “Autre configuration”, activer le mode “Hue Bridge” (vous pouvez également utiliser “Belkin WeMo” si vous avez une seule action à commander via Tasmota sur cet équipement, mais ça n’apporte rien de particulier)

![](/files/alexa-tasmota.png){: .img-center}

L’appareil va redémarrer, et si vous lancez une recherche de nouveau équipement dans l’application Alexa, vous allez voir apparaitre le nouvel équipement !

Pour tous les équipements offrant la possibilité directe d’émuler un de ces deux protocoles, c’est assurément la solution la plus simple et directe.

# Émulation via ha-bridge

Si vous souhaitez exposer des équipements gérés par un logiciel domotique et qui n’offrent pas eux-mêmes la possibilité d’émuler Hue ou WeMo (comme dans mon cas les commandes personnalisées de ma Fire TV [à découvrir dans cet article](/2020/12/firetv-sur-domoticz/)), tout n’est pas perdu, il existe une autre solution bien plus puissante qui s’appelle [ha-bridge](https://github.com/bwssytems/ha-bridge). Comme son nom le laisse à penser, il s’agit d’une passerelle qui permettra de relier Alexa à différents serveurs domotiques, comme Domoticz, Home Assistant, OpenHAB, HomeWiz ou encore un serveur MQTT en exposant les appareils correspondant avec le protocole Hue.

Vous pouvez l’installer via docker ou directement. Comme il s’agit d’un programme en java assez simple, j’ai plutôt opté pour l’installation directe. Ci-dessous les commandes que j’ai utilisée pour l’installer dans /opt sous un serveur debian. Java 8 doit être installé. Il y a également une version java 11.

```sh
mkdir -p /opt/habridge
cd /opt/habridge
wget https://github.com/bwssytems/ha-bridge/releases/download/v5.4.1/ha-bridge-5.4.1.jar
mkdir -p /etc/habridge
ln -sf /etc/habridge /opt/habridge/data
```

Pour toute la configuration, qu’il s’agisse du fichier de configuration ou de la base de données habridge qui contient la configuration des équipements, je préfère les positionner dans /etc (en particulier car je le sauvegarde automatiquement). Le lien symbolique dans /opt/habridge/data n’est pas nécessaire, mais comme c’est le répertoire par défaut de habridge il ira ranger tout seul les fichier où il faut.

Il est nécessaire ensuite de créer le script de démarrage automatique. debian utilise maintenant (malheureusement) systemd et le github de ha-bridge donne un fichier systemd qu’il suffit de reprendre. Vous pouvez soit le mettre directement dans /etc/systemd/system/ soit le ranger dans /etc/habridge et créer le lien symbolique ensuite.

```sh
[Unit]
Description=HA Bridge

Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/habridge
ExecStart=/usr/bin/java -jar -Dconfig.file=/etc/habridge/habridge.config -Dserver.port=9098 /opt/habridge/ha-bridge-5.4.1.jar
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
```

À noter et ajuster suivant votre configuration au besoin :

- le répertoire et le path vers le fichier jar ha-bridge.jar
- l’emplacement du fichier de configuration (même s’il n’existe pas encore à ce stade)
- le port que devra utiliser le server web de habridge, que j’ai pris chez moi à 9098

Une bizarrerie d’Alexa est qu’il faut a priori que l’API exposée par ha-proxy soit exposée sur le port 80. Ce n’est pas très clairement décrit dans la doc de ha-bridge ce qui m’a valu de perdre quelque temps à essayer sans avoir mis la configuration pour le port 80 indiqué, mais ce [tutoriel de Jean Michault](https://jmichault.github.io/2021/08/14/_ha-bridge_/) indique que c’est nécessaire. Effectivement avec cela marche, et sans cela ne marche pas, et même si je trouve ça plutôt étrange comme contrainte, je n’ai pas cherché plus loin à ce stade. Par ailleurs, si votre serveur web utilise déjà /api pour autre chose, je vous conseille de trouver une autre option et de faire héberger habridge par un autre système, comme un raspberry dédié par exemple.

Bref, si vous n’avez pas d’autre service tournant sur le port 80 et qu’il n’est pas exposé sur internet, vous pouvez mettre directement 80 comme port dans le fichier de configuration ci-dessus (au lieu de 9098), mais si vous avez un serveur domotique et que vous lisez cet article, ce n’est probablement pas le cas et il vous faudra faire une redirection sur votre serveur web. L’exemple ci-dessous est pour apache mais la configuration pour d’autres serveurs web est également disponible sur le github de habridge. Il vous faudra donc ajouter les lignes suivantes entre les balises VirtualHost du port 80 (lignes à ajouter à la fin de la section `<VirtualHost *:80>` )

```
	#Conf for ha-proxy (https://jmichault.github.io/2021/08/14/_ha-bridge_/)
	ProxyPass         /api  http://localhost:9098/api nocanon
        ProxyPassReverse  /api  http://localhost:9098/api
        ProxyRequests     Off
        AllowEncodedSlashes NoDecode

        # Local reverse proxy authorization override
        # Most unix distribution deny proxy by default (ie /etc/apache2/mods-enabled/proxy.conf in Ubuntu)
        <Proxy http://localhost:9098/api*>
                  Order deny,allow
                  # Allow from all  
		  Deny from all
		  Allow from 127.0.0.1 ::1
		  Allow from localhost
		  Allow from 192.168
		  Allow from 10
		  Satisfy Any
        </Proxy>
```

L’exemple donné sur le github utilise `Allow from all` mais je vous déconseille fortement cette option si votre serveur est exposé sur internet et recommande de restreindre l’accès uniquement aux adresses locales comme ci-dessus.

Il convient maintenant de relancer apache pour qu’il prenne en compte le nouveau paramétrage et d’activer le nouveau service systemd:

```sh
# Restart apache
sudo systemctl restart apache2

# Load the new habridge.service file and activate it
sudo systemctl daemon-reload
sudo systemctl enable habridge
sudo systemctl start habridge
```

Voilà le serveur est démarré et vous devriez pouvoir vous y connecter via http://localhost/9098

![](/files/alexa-habridge.png){: .img-center}

Il faut commencer par finir la configuration dans “Bridge Control”:

- dans Domoticz (ou votre serveur domotique) : entrez l’adresse, le port, et l’éventuel login/password associé (obligatoire si vous n’êtes pas en local)
- et dans mes tentatives, j’ai suivi le paramétrage proposé par [le tutoriel de Jean Michault](https://jmichault.github.io/2021/08/14/_ha-bridge_/) (et même si je ne suis pas sûr que ce soit complètement obligatoire, ça ne peut pas faire de mal) 
    - renumérotation sur 9 digits (option Unique ID to use 9 Octets)
    - et l’option “Use Link Button” dans la configuration accessible via le bouton “Update Security Settings”

À partir de cette étape, si vous changez d’onglet devrait apparaitre un nouvel onglet “Domoticz Devices” (voir copie d’écran ci-dessus), avec tous les devices gérés par Domoticz. Cochez tous ceux que vous voulez utiliser avec Alexa (en retirant le cas échéant ceux qui proposent déjà une émulation Hue comme les dispositifs Tasmota si vous avez utilisé la première méthode décrite dans cet article) puis cliquez sur le bouton en bas “Bulk Add”. Ces appareils sont maintenant aussi exposés par ha-bridge et vous pouvez les retrouver et modifier au besoin leur configuration dans l’onglet “Bridge Devices”. Vous pouvez tester le bon fonctionnement du lien entre ha-bridge et votre serveur domotique via les bouton “Test On” / “Test Off”. Chez moi le premier usage après un démarrage de ha-bridge tombe en erreur mais les appels suivant fonctionnent.

Vous pouvez à présent lancer la détection. Si vous avez activé l’option “Use Link Button” comme décrit plus haut, il faut cliquer sur le bouton “Link” de l’onglet “Bridge Devices” avant de lancer la détection soit directement à partir de l’application Alexa, via Alexa Echo, ou encore via le bouton “My Echo” de l’interface ha-bridge qui redirige vers votre compte Amazon, qui permettra de lancer une recherche à partir du bouton “Detecter” de l’écran “Maison connectée” / “Vos appareils”

![](/files/alexa-habridge-link.png){: .img-center}

Et voilà vos appareils sont maintenant visibles de Alexa ! Vous pouvez maintenant les commander avec “Alexa, allume xxx” ou “Alexa, éteinds xxx” ; vous pouvez également les renommer dans l’application, les attribuer à une pièce, les inclure dans un groupe, définir des routines, etc.
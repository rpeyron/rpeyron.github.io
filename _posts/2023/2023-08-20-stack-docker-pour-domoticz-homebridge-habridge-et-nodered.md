---
title: Stack docker pour domoticz, homebridge, habridge et nodered
lang: fr
tags:
- Domoticz
- habridge
- Docker
categories:
- Domotique
date: '2023-08-20 11:22:39'
image: files/2023/stack-docker-domotique.png
---

Avec ma nouvelle installation, j'ai décidé de déployer mon setup domotique via containers sur une stack Docker Compose.

# Stack

La stack est constituée de :
- domoticz pour la box domotique (voir [ces articles]({{ '/tag/domoticz' | relative_url }}))
- node-red pour les automatisations (voir [ces articles]({{ '/tag/node-red/' | relative_url }}))
- homebridge pour le lien avec Alexa et Google Home (voir [ces articles]({{ '/tag/homebridge/' | relative_url }}))
- ha_bridge pour une alternative avec Alexa (voir [ces articles]({{ '/tag/habridge/' | relative_url }}))

Cette stack peut également être déplacée facilement sur un raspberry (sans doute un peu limité sur un Pi Zero 2, viser à partir d'un Pi 4)

Pour être complète, il faudrait également lui ajouter MQTT ; par simplicité, j'ai également utilisé le mode `network_mode: host` mais il serait sans doute plus propre d'utiliser un réseau dédié. Compte tenu de [ma migration sur Home Assistant]({{ '/2025/06/homeassistant-installation/' | relative_url }}) je n'ai finalement pas été au bout de l'exercice.

```yaml
version: '3.3'
services:
  domoticz:
    image: domoticz/domoticz:stable
    restart: unless-stopped
    network_mode: host
    devices:
      - /dev/bus/usb
    volumes:
      - /data/domoticz/config:/opt/domoticz/userdata
      - /data/domoticz/rtl_433:/etc/rtl_433
      - /data/domoticz/www-templates:/opt/domoticz/www/templates
    environment:
      - TZ=Europe/Paris
      - WWW_PORT=9090
      - SSL_PORT=9433
  node-red:
    image: nodered/node-red:latest
    environment:
      - TZ=Europe/Paris
    network_mode: host
    devices:
      - /dev/bus/usb
    volumes:
      - /data/nodered/data:/data      
  homebridge:
    image: homebridge/homebridge:latest
    restart: always
    network_mode: host
    volumes:
      - /data/homebridge:/homebridge
    logging:
      driver: json-file
      options:
        max-size: "10mb"
        max-file: "1"
  habridge:
    image: eclipse-temurin:11-jre-alpine
    restart: unless-stopped
    network_mode: host
    volumes:
      - /data/habridge:/habridge
    entrypoint: /habridge/start.sh
    environment:
      - TZ=Europe/Paris  
```


# Domoticz
Domoticz fournit directement les [images docker dokuwiki](https://hub.docker.com/r/domoticz/domoticz) prêtes à l'emploi et la documentation associée. 

Il suffit de copier dans les nouveaux répertoires la base de donnée précédente `domoticz.db`et toute la configuration est récupérée.

Dans le cas d'utilisation de hardware ou plugins particuliers, il peut être nécessaire de compléter la configuration.

- Pour ajouter rtl_433, on peut ajouter l'installation avec un script custom start au démarrage du container

./customstart.sh
```
apt update
apt install -y rtl-433 
apt install -y speedtest-cli
```

- Et copier les custom url www-templates


# Node-red

Node-red fournit également un [container docker](https://github.com/node-red/node-red-docker), l'utilisation est donc assez facile. La seule petite subtilité est de changer le propriétaire des data si vous montez des data existante, via la commande :
```sh
sudo chown -R 1000:1000 <path/to/your/node-red/data>
``` 

# ha-bridge

ha-bridge ne fournit pas de container docker, c'est distribué uniquement sous forme d'un jar java. Il suffit donc d'utiliser un docker java et d'ajouter un script de lancement:

La partie docker, avec utilisation d'une image java et le lancement du script :
```yaml
  habridge:
    image: eclipse-temurin:11-jre-alpine
    restart: unless-stopped
    network_mode: host
    volumes:
      - /data/habridge:/habridge
    entrypoint: /habridge/start.sh
    environment:
      - TZ=Europe/Paris
``` 

Le script de lancement
```sh
#!/bin/sh
cd /habridge
SERVERIP=127.0.0.1
SERVERPORT=9098 
java -jar \
	-Dupnp.config.address=$SERVERIP \
 	-Dserver.port=$SERVERPORT \
	-Dconfig.file=/habridge/habridge.config \
	-Djava.net.preferIPv4Stack=true \
	ha-bridge-5.4.1-java11.jar 
```

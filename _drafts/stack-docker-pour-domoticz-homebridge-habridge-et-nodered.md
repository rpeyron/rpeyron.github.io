---
title: Stack docker pour domoticz, homebridge, habridge et nodered
lang: fr
tags: []
categories: []
---

En attente de:
-  transfert du mqtt dan la stack 
-  proxy mqtt (http://www.steves-internet-guide.com/mosquitto-bridge-configuration/)
-  déplacement de la stack sur raspberry

nodered : sudo chown -R 1000:1000 path/to/your/node-red/data (https://github.com/node-red/node-red-docker )

---

Avec ma nouvelle installation, j'ai décidé de déployer mon setup domotique via containers sur une stack Docker Compose.

# Domoticz
Domoticz fournit directement les [images docker dokuwiki](https://hub.docker.com/r/domoticz/domoticz) prêtes à l'emploi et la documentation associée. 

Il suffit de copier dans les nouveaux répertoires la base de donnée précédente `domoticz.db`et toute la configuration est récupérée.

Dans le cas d'utilisation de hardware ou plugins particuliers, il peut être nécessaire de compléter la configuration.
- rtl_433 avec usb  custom start
- custom url www-templates

./customstart.sh
```
apt update
apt install -y rtl-433 
apt install -y speedtest-cli
```

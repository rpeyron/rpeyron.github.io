---
title: Migration vers Home Assistant
lang: fr
tags:
- Home Assistant
categories:
- Domotique
image: files/2025/migration-home-assistant.png
date: '2025-06-14 12:55:11'
---

Cela fait maintenant des années que j'utilise Domoticz, depuis mes débuts en domotique vers 2017. J'apprécie sa légèreté et sa simplicité. Mais il faut reconnaitre maintenant que Home Assistant a pris largement le dessus sur toutes les solutions domotiques, avec notamment une communauté très importante et un écosystème qui marche tout seul. J'ai pu le constater à l'occasion de [cet article sur l'intégration d'un capteur de température Xiaomi]({{ '/2024/08/domotique-avec-xiaomi-temperature-and-humidity-monitor-clock/' | relative_url }}). La méthode mise en œuvre pour Domoticz est plutôt longue et périlleuse (mais très instructive), et sous Home Assistant, ça marche quasiment sans rien faire.

Mais une migration d'un système existant, à iso-fonctionnalité et migration de données n'est pas si simple lorsque l'on a customisé la solution depuis des années. Cet ensemble d'article vise à retracer ce parcours, et les différents éléments qui peuvent être utiles à d'autres.

# Checklist avec Domoticz

Le tableau ci-dessous ne constitue nullement un comparatif, mais une checklist de ce qui était nécessaire pour moi pour décider de migrer.

| Fonction | Domoticz | Home Assistant |
| --- | :---: | :---: |
| Supporté sous Linux |  ✅  |   ✅  |
| LED MagicHome |  ✅ (via IP)  |   ✅  (auto-détecté)  |
| Intégration Tasmota |  ✅  |   ✅ (ou remplacement avec ESPHome)  |
| Google Home |  ✅ (via [homebridge]({{ '/2021/01/domoticz-scenarios-par-google-home-ou-alexa-avec-homebridge/' | relative_url }})) |   ✅ (via Matter) |
| Alexa |  ✅ (via [ha_bridge]({{ '/2022/08/piloter-votre-domotique-via-alexa-grace-a-ha-bridge-domoticz-ou-tasmota/' | relative_url }}) ) |   ✅ (via Matter) |
| rtl_433 |  ✅ (natif)  |   ✅ (via MQTT)  |

A noter que l'interfaçage avec Google Home est ce qui m'a bloqué le plus longtemps à migrer, car je l'utilise régulièrement pour commander mes prises sous Tasmota, et l'émulation Hue qui fonctionne avec Alexa ne fonctionne par pour Google Home qui ne permettait pas de fonctionnement local jusqu'à l'arrivée de Matter.

Les principaux gains attendus :
- le support de nombreuses intégrations non disponibles sur Domoticz, comme Xiaomi, Tapo, Bbox,...
- les tableaux de bords jolis et configurables simplement
- la souplesse de ESPHome pour des capteurscustom
- le support de Matter
- la facilité d'extension et customisation (python & plugins, vs essentiellement du code C à recompiler pour Domoticz)
- une interface moderne


# Mode d'installation 

Il y a plusieurs méthodes pour installer Home Assistant.

Comme la configuration de mon serveur est ancienne et avec seulement 4 CPUs, j'étais initialement parti pour une installation sous docker. Ci-dessous un docker-compose pour une version docker avec esphome et le support SSL.

<p><details markdown="1"><summary>Voir docker-compose.yml pour HomeAssistant + ESPHome en SSL</summary>

```yaml
services:
  homeassistant:
    container_name: ha_homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /data/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
    ports:
      - 8123:8123    
    labels:
      - traefik.enable=true
      - traefik.http.routers.ha.tls=true
      - traefik.http.routers.ha.rule=Host(`ha.local`)
      - traefik.http.routers.ha.middlewares=securityHeaders@file
      - traefik.http.services.ha.loadbalancer.server.port=8123
  esphome:
    container_name: ha_esphome
    image: ghcr.io/esphome/esphome
    volumes:
      - /data/homeassistant/esphome/config:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    #network_mode: host
    environment:
      - USERNAME=esp
      - PASSWORD=home
      - ESPHOME_DASHBOARD_USE_PING=true
    ports:
      - 6052:6052    
    labels:
      - traefik.enable=true
      - traefik.http.routers.esphome.tls=true
      - traefik.http.routers.esphome.rule=Host(`esphome.local`)
  esphome-traefik:
    container_name: ha_esphome_traefik
    image: traefik
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - /data/proxy/traefik/dynamic_conf:/etc/traefik/dynamic_conf:ro
      - /data/proxy/certs:/etc/certs:ro      
    restart: unless-stopped
    #network_mode: host
    ports:
      - "6050:6050"
      - "6080:6080"
      - "6060:6060"
    command:
      - "--api.dashboard=true"
      - "--entrypoints.web.address=:6080"
      - "--entrypoints.websecure.address=:6050"
      - "--providers.docker.exposedbydefault=false"
      - "--providers.file.directory=/etc/traefik/dynamic_conf"
    labels:
      - traefik.enable=true
      - traefik.http.routers.traefik-dashboard.rule=Host(`traefik.local.lprp.fr`)
      - traefik.http.routers.traefik-dashboard.entrypoints=web
      - traefik.http.routers.traefik-dashboard.service=api@internal
    extra_hosts: 
      - host.docker.internal:172.17.0.1
  rtl_433_autodiscovery:
    container_name: ha_rtl433autodiscovery
    image: ghcr.io/pbkhrv/rtl_433-hass-addons-rtl_433_mqtt_autodiscovery-amd64 # On Raspberry Pi replace `amd64` with the appropriate architecture.
    network_mode: host
    command: "python3 -u /rtl_433_mqtt_hass.py -H 192.168.0.1"
    environment:
      - MQTT_HOST=192.168.0.1
```

Il faudra également ajouter dans la configuration HomeAssistant `configuration.yaml` :
```yaml
http:
 use_x_forwarded_for: true
 trusted_proxies:
   - 127.0.0.1
   - 192.168.86.114 # Server IP
   - 172.18.0.0/16 # traefik proxy subnet
```

Source: [Reddit](https://www.reddit.com/r/docker/comments/zy1v0q/enabling_home_assistant_remote_access_via_traefik/)

</details></p>

Cependant, compte tenu des limitations concernant les addons (notamment ESPHome Dashboard) et du paramétrage supplémentaire nécessaire si on veut les installer manuellement avec docker, et de mon choix de basculer le serveur sur Proxmox, j'ai finalement opté pour le déploiement en VM avec Home Assistant OS, et c'est vraiment le plus simple. Je ne détaille pas la procédure car elle est d'une part très facile et d'autre part bien décrite sur le site. 

Pour Proxmox il existe un script tout fait pour installer ([tteck.github.io/Proxmox](https://tteck.github.io/Proxmox/#home-assistant-os-vm)), car on ne peut pas utiliser directement le qcow2 fourni sur le site.
```sh
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm.sh)"
```

Par défaut le script créé un disque de 32Go, ce qui est une taille très confortable. Le plus simple est de modifier la taille directement dans le script, mais sinon dans un des articles ci-dessous les étapes pour soit pour réduire le disque, soit pour l'augmenter.

# Dépanner un Home Assistant qui ne redémarre plus

Home Assistant intègre de plus en plus de sécurité pour ne pas pouvoir casser la configuration et se retrouver avec un système Home Assistant qui ne démarre pas. Cependant, sur des usages un peu avancés, comme l'installation de HACS, ou l'activation du SSL, vous pouvez faire une erreur qui empêche le système de démarrer. Ci-dessous les étapes que j'ai suivies pour corriger les problèmes :
- se connecter sur la VM (par exemple via le menu `Console` sous Proxmox)
- à l’invite `ha >`, taper `login`
- à cette étape vous êtes dans la partie supervisor de Home Assistant OS, mais pas dans Home Assistant qui tourne dans un service docker distinct, pour modifier la configuration, vous pouvez donc soit aller chercher le fichier directement dans `/mnt/data/supervisor/homeassistant`  mais comme il n'y a pas d'éditeur dans la partie supervisor c'est plus pratique de lancer une commande dans le docker homeassistant: `docker exec -it homeassistant vi configuration.yaml` ; attention le clavier est en qwerty, donc utiliser `Shift+m` pour `:`, `Shift+3` pour `#`, et `Esc, Shift+m+‘za’` pour `:wq`)
- enfin, redémarrer la VM

Cette méthode est également utile pour pouvoir faire un peu le ménage dans les caches des addons, par exemple pour ESPHome : ` rm -rf /mnt/data/supervisor/addons/data/5c53de3b_esphome/build && rm -rf /mnt/data/supervisor/addons/data/5c53de3b_esphome/cache`


# La suite en articles

Voici les articles en lien avec cette migration et détaillant un point particulier de la migration:

- [Migrer des données historiques de Domoticz vers Home Asssistant]({{ '/2025/06/home-assistant-migration-donnees-domoticz/' | relative_url }})
- [Migrer des données historiques entre deux instances Home Asssistant]({{ '/2025/06/home-assistant-migration-donnees/' | relative_url }})
- [Custom card Home Assistant pour des liens web (migration homer)]({{ '/2025/06/home-assistant-custom-card-links/' | relative_url }})
- [Intégration de statistiques Piwik Pro (Custom card et sensor command_line)]({{ '/2025/06/home-assistant-piwik/' | relative_url }})
- [Zigbee sous Home Assistant avec la box LIDL (Silvercrest TYGWZ-01)]({{ '/2025/06/hack-Silvercrest-TYGWZ-01/' | relative_url }})

A venir:
- Matter dans Google Home et Alexa avec Home Assistant et Tasmota
- rtl_433 avec Home Assistant (OpenMQTTGateway, ESPHome ou RTL USB)
- Une automatisation Home Assistant pour allumer lors du passage, et permettre de forcer
- ESPHome & ESPHome Dashboard
- Informations systèmes avec psmqtt
- Réduire ou augmenter la taille d'un disque sous Proxmox

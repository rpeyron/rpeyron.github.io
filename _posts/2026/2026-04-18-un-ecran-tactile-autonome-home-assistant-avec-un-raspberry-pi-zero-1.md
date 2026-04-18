---
title: Un écran tactile autonome Home Assistant avec un Raspberry Pi Zero 1
lang: fr
tags:
- Home Assistant
- Linux
- Raspberry
- VNC
categories:
- Domotique
toc: 2
date: '2026-04-18 15:23:00'
image: files/2026/vnc_homeassistant.jpg
---

Je souhaitais un moniteur Home Assistant indépendant et tactile. Il existe de nombreuses méthodes plus ou moins simples. Les méthodes qui semblent les plus simples passent par l'utilisation d'une tablette Android et d'un navigateur en mode Kiosque ([exemple sur cet article avec la tablette Blackview Tab90, 140€ pour 11 pouces](https://www.domo-blog.fr/pilotage-home-assistant-avec-tablette-mur-blackview-tab90/)). C'est simple à mettre en place, mais c'est clairement un budget. 

La vieille tablette Android peut aussi être une option, mais je souhaite également fonctionner uniquement avec des logiciels mis à jour, même si ce choix pourrait être discutable pour un usage réduit à un réseau local.

# Matériel utilisé

J'ai voulu suivre l'approche inverse, en partant de ce que j'avais à disposition :
- Un écran tactile 14" acheté 31€ en promo sur [AliExpress](https://fr.aliexpress.com/item/1005009341035178.html?spm=a2g0o.order_list.order_list_main.41.57765e5bbIXhVr&gatewayAdapt=glo2fra)
- Un raspberry Pi Zero 1 acheté il y a quelques années 8 euros, et que je n'utilise plus depuis quelque temps, ayant upgradé depuis vers un Zero 2WH
- Une clé USB Wifi compatible Linux
- Une alimentation USB suffisante pour alimenter le Raspberry Pi et l'écran en USB Type C ; un seul fil à brancher pour allumer le tout.

J'ai complété avec la connectique adaptée pour que ce soit pratique à utiliser et suffisamment compact. Le Raspberry Pi Zero est connecté en HDMI à l'écran, alimenté avec un port USB, et l'autre port USB est relié à un Hub USB pour brancher la clé USB Wifi et le volet tactile de l'écran aussi en USB. Pendant le setup, j'ai également branché un clavier et souris sans fil pour faciliter.

# Incompatibilité logicielle

Dans l'absolu, il suffit faire en sorte que le Pi lance un navigateur en plein écran sur la bonne adresse au démarrage. Cependant l'usage du Pi Zero 1 s'est avéré être une grosse contrainte, car le processeur utilisé, sur ARMv6, ne comporte pas l'unité NEON (Advanced SIMD) et Chromium a supprimé la compatibilité avec cette ancienne architecture. Depuis 2023 il n'est donc plus possible d'utiliser Chromium sur Pi Zero 1. J'ai essayé les navigateurs alternatifs disponibles pour Raspberry Pi, mais Home Assistant nécessitant une bonne compatibilité sur les technologies web modernes, aucun n'a réussi à faire fonctionner Home Assistant.

J'ai donc opté pour une approche un peu plus compliquée avec un partage d'écran en VNC, mais qui répond à l'ensemble de mes contraintes : le Raspberry Pi Zero 1 lance en mode kiosque un viewer VNC vers un serveur VNC en docker dont la seule fonction est d'afficher un Chromium sur la bonne page en plein écran

# Mise en place
## Stack docker
Je suis parti du container [mrcolorrain/vnc-browser](https://hub.docker.com/r/mrcolorrain/vnc-browser) qui correspond à mon usage et semble bien maintenu.  La stack correspondante est :
```yaml
version: "3.9"
services:
  vnc-browser:
    container_name: vnc-homeassistant
    image: mrcolorrain/vnc-browser:debian
    restart: unless-stopped
    ports:
      - "5900:5900"
      - "6080:6080"
    environment:
      VNC_PASSWORD: "YOUR_PASSWORD"
      VNC_RESOLUTION: "1920x1200"
      STARTING_WEBSITE_URL: "https://homeassistant.lan/dashboard-home/0"
      LANG: fr_FR.UTF-8
      LC_ALL: fr_FR
      AUTO_START_BROWSER: true
      AUTO_START_XTERM: true
      BROWSER_OPTIONS: "--start-fullscreen --touch-events=enabled  --force-dark-mode --enable-features=WebUIDarkMode --test-type=ui"
      #CUSTOMIZE: true
    volumes:
      - vnc_ha_chrome_data:/root/.config/chromium/Default
      - vnc_ha_pki:/root/.locale/share/pki
volumes:
  vnc_ha_chrome_data:
  vnc_ha_pki:
```

Ici un volume est déclaré pour les données Chromium et un autre pour la partie pki (utile par exemple si vous ajoutez une autorité de certification locale dans Chromium par exemple). 

## Client VNC

J'ai opté pour TigerVNC qui est maintenant le défaut du paquet `xvnc4viewer`
```sh
sudo apt install tigervnc-viewer tigervnc-tools
```

Puis un script pour lancer automatiquement le viewer en plein écran :
```sh
#!/bin/bash
sleep 10
while true; do
  # Use tigervncpasswd  installed by apt install tigervnc-tools
  xvncviewer -passwd ~/.vnc/pwd_ha -fullscreen 192.168.x.x:5900
  echo "Stopped, restart"
  sleep 5
done
``` 

Et enfin, il faut enregistrer le mot de passe VNC avec  `vncpasswd -f ~/.vnc/pwd_ha`

Lancez le script pour vérifier que ça fonctionne correctement.

## Démarrage automatique

On va maintenant faire en sorte que ça se lance automatiquement. Dans les réglages Raspberry (Settings / Control Center), activez la connexion automatique de l'utilisateur (Desktop Auto login). Puis on va définir un fichier de lancement automatique

```sh
mkdir -p ~/.config/autostart
nano ~/.config/autostart/vnc-client.desktop
```
avec le contenu
```ini
[Desktop Entry]
Type=Application
Name=VNC Client Fullscreen
Exec=/home/remi/start_vnc.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
```

## Finalisation

Je vous conseille également :
- d'activer VNC : vous pourrez ensuite vous connecter depuis votre PC sur le Raspberry, lui même connecté en VNC sur votre serveur :-) ; plus sérieusement ça sera utile pour re-rentrer votre mot de passe Home Assistant si besoin de le changer plus facilement que via le clavier tactile, de modifier la configuration, etc ; pour sortir du client VNC en plein écran et accéder à l'interface raspberry OS, il faut dans le menu de votre client VNC selectionner l'option "Envoyer la touche F8" ; cela va faire apparaitre un menu dans lequel vous pourrez sortir du mode plein écran
- faire un backup de la carte SD
- activer le mode overlayfs (Settings / Control Center / Performances / Overlayfs) : permet notamment d'éviter les corruptions sur les coupures de courant

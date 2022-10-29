---
post_id: 4390
title: 'OctoPrint sur debian/ubuntu'
date: '2020-06-08T18:23:16+02:00'
last_modified_at: '2022-02-13T19:33:59+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4390'
slug: octoprint-sur-debian-ubuntu
permalink: /2020/06/octoprint-sur-debian-ubuntu/
image: /files/2020/06/octoprint_logo.png
categories:
    - 3D
tags:
    - 3D
    - Debian
    - Linux
    - OctoPrint
    - Ubuntu
lang: fr
term_language:
    - English
term_translations:
    - pll_61c76da19d84d
---

J’aime beaucoup [OctoPrint](https://octoprint.org/) pour gérer mon imprimante 3D. Il existe beaucoup de plugins pour enrichir les fonctionnalités et il est bien intégré dans Cura. L’ensemble fait un duo parfait pour gérer les impressions 3D. il existe même un plugin [OctoFusion](https://github.com/tapnair/OctoFusion) pour l’intégrer directement dans Fusion360 (non testé encore). Seul problème, l’installation recommandée est sur raspberry pi. Je dispose du premier modèle, qui est peu puissant par rapport aux récents, et déconseillé pour OctoPi, une distribution OctoPrint prête à l’emploi. Je l’ai utilisé avec succès pendant presque deux ans, mais depuis la mise à jour vers la dernière version, il est devenu vraiment lent, au point de multiplier par deux le temps d’impression, et causer des problèmes car l’imprimante se retrouve à attendre les commandes et laisse couler du filament en attendant. Cela crée alors des boursouflures problématiques sur les impressions… Comme j’ai mon serveur sous Debian qui tourne à coté de l’imprimante, c’était dommage d’acheter un raspberry rien que pour ça, d’autant que même les anciens modèles ne sont pas bradés, j’ai donc opté pour installer OctoPrint directement sur mon serveur.

# Installation d’OctoPrint

L’installation est super bien décrite sur la page [setting up octoprint on a raspberry pi running raspbian](https://community.octoprint.org/t/setting-up-octoprint-on-a-raspberry-pi-running-raspbian/2337) , il suffit de quelques adaptations pour s’adapter à un non raspberry :

Le mode d’emploi installe OctoPrint sous l’utilisateur pi ; plutôt que de créer un utilisateur pi qui ne correspondrait à rien sur mon serveur, j’ai :

- créé un utilisateur octoprint qui va exécuter le serveur pour qu’il ne tourne pas en root : `sudo useradd octoprint`
- installé dans /opt/OctoPrint plutôt que dans le home de l’utilisateur

Les séquences ci-dessous sont les scripts de la page octoprint adaptés avec les choix ci-dessus.

```
sudo su
cd /opt
apt update
apt install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential
mkdir OctoPrint && cd OctoPrint
virtualenv venv
source venv/bin/activate
pip install pip --upgrade
pip install octoprint
useradd octoprint
usermod -a -G tty octoprint
usermod -a -G dialout octoprint
chown -R octoprint:octoprint /opt/OctoPrint
```

A noter, si la version python par défaut de votre système diffère de celle octoprint vous devrez spécifier la version à utiliser avec le paramètre `–python=` ; consulter la [page de migration python d’Octoprint](https://docs.octoprint.org/en/master/plugins/python3_migration.html) ou le commentaire de Neocorp en dessous de l’article. Si vous avez une erreur sur gcc non trouvé, quelques paquets supplémentaires à installer dans le commentaire de Neocorp.

Puis pour le lancement automatique :

```
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init && sudo mv octoprint.init /etc/init.d/octoprint
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default && sudo mv octoprint.default /etc/default/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo update-rc.d octoprint defaults
```

En ajustant dans le fichier /etc/defaults/octoprint les lignes :

```
OCTOPRINT_USER=octoprint
BASEDIR=/opt/OctoPrint/.octoprint
PORT=5000
DAEMON=/opt/OctoPrint/venv/bin/octoprint
START=yes

```

# Customisation d’OctoPrint

Lors de la première connexion à OctoPrint, l’installation se déroule sans problème. OctoPrint répond à la vitesse de l’éclair sur un PC 🙂

Pour qu’OctoPrint sache se redémarrer tout seul il est nécessaire de lui donner les droits correspondant pour éviter d’avoir à le faire à la main, ce qui devient vite pénible. Comme il tourne sous l’utilisateur octoprint, il est nécessaire de donner à cet utilisateur des droits supplémentaires. Plutôt que de donner les droits sudoers sur n’importe quelle commande comme décrit sur la page (autant faire tourner le serveur en root !), j’ai préféré limiter aux commandes nécessaires.

Créer un fichier `/etc/sudoers.d/octoprint` avec le contenu :

```
# Pour autoriser le redémarrage d'octoprint par lui-même
octoprint ALL = (root) NOPASSWD: /etc/init.d/octoprint
# Pour autoriser le démarrage/arrêt de la webcam (cf la suite :))
octoprint ALL = (root) NOPASSWD: /opt/OctoPrint/webcam

```

Puis dans la configuration d’OctoPrint, dans l’entrée “Server”, indiquer comme commande “Restart OctoPrint” `sudo /etc/init.d/octoprint restart`

![](/files/2020/06/octoprint_restart.png){: .img-center}

Comme j’allume l’imprimante seulement lorsque j’en ai besoin, j’ai rencontré un petit souci :

- d’une part si je laisse Cura ouvert, celui-ci va se connecter automatiquement à l’imprimante dès que je l’allume, et je ne pourrais pas connecter OctoPrint ; pour résoudre cela, il suffit de désactiver le plugin “USB Printing”

![](/files/2020/06/octoprint_disable_cura_usb.png){: .img-center}

- d’autre part OctoPrint ne se reconnecte pas automatiquement ; pour ce faire il suffit d’ajouter le plugin [PortLister](https://plugins.octoprint.org/plugins/portlister/) !

J’utilise par ailleurs les plugins suivants :

- MultiCam pour le support de plusieurs prises de vues dans l’interface et Fullscreen pour en profiter en plein écran
- ABL Expert Plugin et Bed Visualizer pour l’autolevel du plateau
- Change Filament pour faciliter le changement de filament
- Detailled Progress pour afficher la progression de l’impression
- DisplayZ pour afficher la hauteur actuelle de l’impression
- EEPROM Marlin Editor pour éditer les paramètres du firmware enregistrés dans l’EEPROM

# Installation de la webcam

J’utilisais beaucoup la caméra raspberry, très pratique car très fine et que j’avais fixée à l’axe des Z avec [cette petite impression 3D](https://www.thingiverse.com/thing:3468974), pour pouvoir surveiller que l’impression se passe bien. Comme je n’ai pas réussi à installer une webcam plus grosse de la même façon, je vais conserver le raspberry seulement pour streamer la camera raspberry et ajouter le flux via le plugin [multicam](https://plugins.octoprint.org/plugins/multicam/) en attendant de trouver un autre moyen, sans doute en fixant une mini caméra endoscope directement sur la tête d’impression (moins de 3€ sur [AliExpress](https://www.aliexpress.com/snapshot/0.html?spm=a2g0s.9042647.6.2.90d836facd0Nwn&orderId=508283441757823&productId=32841045162)).

Mais je voulais aussi une webcam fixe pour avoir une vue d’ensemble, et potentiellement ensuite utiliser octolapse pour des jolis timelapse. Après avoir testé et positionné la webcam avec es outils classique cheese ou webcamoid, il faut installer sur la debian un outil pour streamer le flux. Dans la distribution est intégré motion, qui fonctionne très bien, mais consomme inutilement du CPU pour de la détection de mouvement. Je me suis donc résolu à ajouter mjpg-streamer manuellement comme indiqué sur le site :

```
sudo su
cd /opt/OctoPrint
apt install subversion libjpeg62-turbo-dev imagemagick ffmpeg libv4l-dev cmake
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
export LD_LIBRARY_PATH=.
make
chown -R octoprint:octoprint /opt/OctoPrint
```

*(sous Ubuntu remplacer* `libjpeg62-turbo-dev`  *par* `libjpeg62-dev`*)*

Il faut ensuite copier les deux scripts webcam et webcamDaemon ci-dessous dans /opt/OctoPrint.

Script /opt/OctoPrint/webcam :

```
#!/bin/bash
# Start / stop streamer daemon

case "$1" in
    start)
        /opt/OctoPrint/webcamDaemon >/dev/null 2>&1 &
        echo "$0: started"
        ;;
    stop)
        pkill -x webcamDaemon
        pkill -x mjpg_streamer
        echo "$0: stopped"
        ;;
    *)
        echo "Usage: $0 {start|stop}" >&2
        ;;
esac

```

Script /opt/OctoPrint/webcamDaemon :

```
#!/bin/bash

MJPGSTREAMER_HOME=/opt/OctoPrint/mjpg-streamer-experimental
MJPGSTREAMER_INPUT_USB="input_uvc.so"
MJPGSTREAMER_INPUT_RASPICAM="input_raspicam.so"

# init configuration
camera="auto"
camera_usb_options="-r 640x480 -f 10"
camera_raspi_options="-fps 10"
http_port=" -p 8080 "

if [ -e "/opt/OctoPrint/webcam.txt" ]; then
    source "/opt/OctoPrint/webcam.txt"
fi

# runs MJPG Streamer, using the provided input plugin + configuration
function runMjpgStreamer {
    input=$1
    pushd $MJPGSTREAMER_HOME
    echo Running ./mjpg_streamer -o "output_http.so -w ./www $http_port " -i "$input"
    LD_LIBRARY_PATH=. ./mjpg_streamer -o "output_http.so -w ./www $http_port" -i "$input"
    popd
}

# starts up the RasPiCam
function startRaspi {
    logger "Starting Raspberry Pi camera"
    runMjpgStreamer "$MJPGSTREAMER_INPUT_RASPICAM $camera_raspi_options"
}

# starts up the USB webcam
function startUsb {
    logger "Starting USB webcam"
    runMjpgStreamer "$MJPGSTREAMER_INPUT_USB $camera_usb_options"
}

# we need this to prevent the later calls to vcgencmd from blocking
# I have no idea why, but that's how it is...
vcgencmd version

# echo configuration
echo camera: $camera
echo usb options: $camera_usb_options
echo raspi options: $camera_raspi_options

# keep mjpg streamer running if some camera is attached
while true; do
    if [ -e "/dev/video0" ] && { [ "$camera" = "auto" ] || [ "$camera" = "usb" ] ; }; then
        startUsb
    elif [ "`vcgencmd get_camera`" = "supported=1 detected=1" ] && { [ "$camera" = "auto" ] || [ "$camera" = "raspi" ] ; }; then
        startRaspi
    fi

    sleep 120
done
```

Ces scripts sont issus de [cette page de la communauté octoprint](https://community.octoprint.org/t/setting-up-octoprint-on-a-raspberry-pi-running-raspbian-or-raspberry-pi-os/2337) en version 19, les scripts actuels ayant été modifiés pour des scripts utilisant systemd. Ces scripts ont été adaptés comme suit:

- Dans le script webcam : le répertoire a été modifié par /opt/OctoPrint/webcamDaemon
- Dans webcamDaemon : 
    - le fichier de configuration a été remplacé par /opt/OctoPrint/webcam.txt plutôt que /boot/octopi.txt
    - pour permettre de customiser le port de mjpg-streamer, ajouter un paramètre http\_opts : 
        - dans les paramètres (ou webcam.txt)

            ```
            http_port=" -p 5100 "
            ```

       - dans la fonction runMjpgStreamer

            ```
                echo Running ./mjpg_streamer -o "output_http.so -w ./www $http_port " -i "$input"
                LD_LIBRARY_PATH=. ./mjpg_streamer -o "output_http.so -w ./www $http_port" -i "$input"
            ```

Il y aura quelques erreurs liées à l’absence de vcgencmd qui est un outil qui permet d’interroger le raspberry, mais ce n’est pas grave puisque justement ce n’est pas un raspberry 🙂

La camera est alors fonctionnelle lorsqu’on lance le script webcam start, et il suffit de configurer l’url <http://localhost:5110/?action=stream> dans MultiCam.

Cependant c’est dommage de streamer tout le temps alors que ce n’est utile que lorsque l’imprimante est allumée. On va pouvoir mettre en place le démarrage et l’arrêt automatique à la connexion / déconnexion de l’imprimante via les events OctoPrint. Bizarrement je n’ai pas trouvé de possibilité de régler ça par l’interface, il faut donc modifier à la main le fichier config.yaml qui est dans le répertoire .octoprint (/opt/OctoPrint/.octoprint pour mon installation), puis redémarrer OctoPrint pour qu’il soit pris en compte

```
events:
  enabled: True
  subscriptions:
  - event: Disconnected
    command: sudo /opt/OctoPrint/webcam stop
    type: system
  - event: Connected
    command: sudo /opt/OctoPrint/webcam start
    type: system
```

Vous retrouverez ici la seconde commande que nous avions ajoutée dans le fichier /etc/sudoers.d/octoprint.

L’installation est désormais complètement fonctionnelle, vous pouvez laisser octoprint et cura fonctionner en permanence. Lorsque vous allumerez l’imprimante (via une prise commandée par Domoticz pour mon cas), alors OctoPrint se connectera automatiquement, démarrera la webcam et vous pourrez imprimer directement depuis Cura.

A vos impressions 3D !
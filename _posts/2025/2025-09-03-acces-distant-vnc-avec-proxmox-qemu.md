---
title: Accès distant VNC avec Proxmox/QEMU
lang: fr
tags:
- Proxmox
- VNC
- QEMU
- Scripts
categories:
- Informatique
toc: 2
image: files/2025/article-proxmox-vnc.png
date: '2025-09-02 19:30:00'
---

Je suis en train de moderniser mon serveur personnel avec Proxmox. Si la majorité des services sont maintenant en mode web, il me reste quelques services en mode graphique. J’utilise pour ceux-là un bureau léger type LXDE, avec LUbuntu ou Debian.

# VNC dans Proxmox/QEMU

## Choix de la solution de partage d’écran

Il existe plusieurs solutions pour se connecter en mode graphique à une VM tournant sous Proxmox.

Presque tous les OS intègrent une solution d’accès à distance, que ce soit le partage de bureau à distance sous Windows, ou des serveurs VNC sous Linux (soit en partage d’une session X existante, soit en création d’un serveur X dédié). C’est la solution la plus souple et la plus fiable, car elle ne dépend pas des contraintes Proxmox/QEMU. Cependant, il faudra faire la configuration sur chaque VM concernée, avec une configuration différente pour chaque OS. Par ailleurs, cela ajoute une consommation supérieure de ressources (notamment un double serveur graphique dans le mode indépendant). Si les ressources ne sont pas un problème pour votre installation et que vous n’avez pas trop de machines à configurer, c’est sans doute le mode à privilégier. Pour ma part étant sur une configuration frugale, j’ai privilégié une autre solution.

Proxmox/QEMU sait également partager un dispositif graphique virtuel : c’est vu par la VM comme un écran local, mais partagé à distance par Proxmox.

Proxmox offre plusieurs solutions de partage : une première solution intégrée avec `noVNC` , accessible via le menu Console de la VM ; c’est certainement la solution la plus simple à mettre en œuvre, elle est sécurisée par votre connexion à Proxmox et utilise un client VNC web qui se connecte à la VM via une socket sur la machine Proxmox. Par ailleurs `noVNC` supporte nativement les extensions QEMU qui vont permettre une bonne gestion du clavier et un partage partiel du presse-papier. Mais ce n’est pas forcément la solution la plus ergonomique à utiliser au quotidien

Une deuxième solution est proposée via l’intégration du protocole `spice` qui promet du rêve, rapide, bon support du clavier, partage à distance de fichiers, de devices USB, etc. Cependant, ce protocole est très peu utilisé et le client officiel pour Windows est d’une ergonomie catastrophique, et pas mis à jour depuis 4 ans. Bref, pas une option pour moi.

Enfin, une intégration du protocole VNC classique ; c’est cette dernière solution que j’ai utilisée, mais elle arrive avec quelques contraintes, notamment concernant la gestion du clavier et du presse-papier. 

## Activation de VNC dans Proxmox/QEMU

Par défaut, il n’est pas possible de configurer un accès VNC classique (ie sans noVNC) via l’interface de Proxmox, il va falloir ajouter les bons paramètres manuellement.

Dans le fichier de configuration de votre VM dans `/etc/pve/qemu-server/<vmid>.conf` ajouter la ligne

```  
args: -vnc 0.0.0.0:2,password=off   
```

S’il existe déjà une ligne avec `args:` il faut ajouter ces nouveaux paramètres à la ligne existante.

Cela indique d’ouvrir un accès VNC via IP, sur toutes les interfaces du serveur Proxmox (`0.0.0.0`) sur le deuxième port (`:2` soit `5902`) en indiquant également d’ouvrir un accès non sécurisé, sans mot de passe VNC. Ce n’est clairement pas conseillé, mais dans certains cas celà peut être utile. Il faut redémarrer la VM pour que cela prenne effet. 

Pour pouvoir indiquer un mot de passe, c’est un peu plus compliqué, car le mot de passe ne peut pas être fourni directement dans le fichier de configuration, et doit être ajouté via l’interface QEmu monitor, ce qui n’est particulièrement pas pratique. Pour cela, je vais utiliser un script hook qui va exécuter un fichier de configuration complémentaire via QEMU Monitor ; c’est une méthode particulièrement générique qui permet d’autres usages, comme le hotplug USB.

Pour déclarer ce hookscript il faut ajouter dans chaque VM concernée la ligne suivante :  
```  
hookscript: local:snippets/hook-hotplug.sh  
```

Et créer le script dans le répertoire des snippets et le rendre exécutable : `/var/lib/vz/snippets/hook-hotplug.sh`   
```sh
#!/bin/bash

# From Perplexity: hook script pour proxmox qui ajoute dans le qm monitor après le démarrage le contenu du fichier à .hotplug.conf à coté du fichier de configuration de la VM
# /root/hook-hotplug.sh

# Installation
# - chmod +x 
# - copy dans /var/lib/vz/snippets
# - ajouter dans la VM avec: qm set <VMID> --hookscript local:snippets/hook-hotplug.sh

# Variables transmises par Proxmox à chaque appel hook
VMID="$1"
PHASE="$2"

# Chemin du fichier de hotplug à appliquer si présent
HOTPLUG_CONF="/etc/pve/qemu-server/${VMID}.hotplug.conf"

# Lancement après démarrage effectif
if [ "$PHASE" = "post-start" ] && [ -f "$HOTPLUG_CONF" ]; then
    # Lire chaque ligne et l’injecter dans le monitor QEMU de la VM
    while IFS= read -r line; do
        # On ignore les lignes vides ou commentaires (#)
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        # Injecte la commande dans qm monitor
        echo "$line" | qm monitor "$VMID"
    done < "$HOTPLUG_CONF" >> /var/log/hook-hotplug.log 2>&1
fi
```

Le principe de ce script va être de répondre à l’évènement `post-start` lancé à la fin du démarrage de la VM, de lire le fichier de configuration `<vmid>.hotplug.conf` à coté du fichier de configuration de la VM, et de l’injecter dans l’interface QEMU Monitor.

Pour notre cas, le fichier hotplug sera simplement:  `/etc/pve/qemu-server/<vmid>.hotplug.conf`  
```  
set_password vnc <votre_mot_de_passe> -d vnc2  
``` 

On indique ici de sélectionner l’interface VNC vnc2 car l’interface noVNC reste active (et c’est bien pratique). Il faut également modifier la configuration de la VM pour indiquer que maintenant on veut un mot de passe :  
```  
args: -vnc 0.0.0.0:2,password=on -k fr  
```

On en profite également pour ajouter la mention d’utilisation du clavier français, mais lisez bien le paragraphe suivant pour comprendre le sujet du clavier avec VNC et QEMU.

Au redémarrage de la VM, elle sera maintenant accessible en VNC protégé par un mot de passe sur `<IP de votre Proxmox>:5902`  et toujours en noVNC via le menu Console de votre VM.

## Configuration du clavier

Comme souvent en informatique, essentiellement de conception US, ça marche bien avec l’anglais et ça se gâte avec les alphabets/claviers un peu plus exotiques. C’est particulièrement le cas avec le combo VNC et QEMU.

Pour comprendre le problème il faut comprendre comment fonctionne un clavier : le clavier envoie des codes brutes correspondant aux touches appuyées (`scan codes`), votre OS va ensuite convertir ces touches brutes dans les symboles correspondants, suivant la configuration clavier faite lors de l’installation. Votre OS dispose des tables de mapping pour chaque type de clavier lui permettant de savoir par exemple que la touche a correspond à un ‘a’. Il va également convertir les séquences de touches, par exemple pour un a majuscule, le clavier va envoyer successivement ‘appui sur shift’, ‘appui sur a’, ‘relachement de a’, ‘relachement de shift’, que votre OS va simplement traduire en ‘A’. Et ça se complique encore plus pour les claviers français et leur touche AltGr. Plusieurs mappings existent pour cette touche, soit via la combinaison de Ctrl et Alt, soit via une touche ISO\_Level3\_Shift.  Le protocole VNC est prévu pour transporter les touches traduites (par exemple ‘A’, et non pas Shift+a). Là où ça se complique, c’est que QEMU doit fournir les touches brutes à la VM, comme si un clavier physique étant branché sur la VM, et va donc devoir retraduire dans le sens inverse les touches traduites reçues par VNC en touches brutes pour la VM. Cette conversion est doublement complexe car elle dépend de la configuration clavier de l’OS local que QEMU ne connait pas, et elle nécessite les mappings inverses, et ces mappings ne sont pas bijectifs… Au final cela fait 3 mappings complexes successifs:  
```  
Touches brutes – [OS Local] → Touche traduite → VNC → [ QEMU / Mapping inverse ] → Touches brutes → [OS Distant] → Touche finale  
``` 

On peut indiquer à VNC quel mapping utiliser via l’argument `-k fr` qui va permettre de choisir le mapping adapté, et permettre un fonctionnement avec n’importe quel client VNC. Cependant il reste souvent quelques problèmes, notamment avec les touches `AltGr` et donc ne pas permettre l’utilisation des caractères #, \|, @…   Vous pouvez observer ce qui se passe via la commande `xev` qui va vous montrer tous les codes reçus du clavier. En l’occurence pour moi, il y a un bug dans l’ordre des touches modificatrices et donc le résultat est mauvais.  Suivant votre usage cela peut être tolérable et vous pourrez toujours copier/coller ces symboles dans la VM. Mais souvent le partage du presse-papier (la possibilité de copier/coller entre votre ordinateur et le client VNC) ne va pas bien fonctionner non plus (soit pas du tout, soit via l’utilisation des options Proxmox, fonctionner mais avec des problèmes d’encoding)

Pour résoudre ces problèmes, QEMU a développé des extensions au protocole VNC, pour pouvoir envoyer directement les touches brutes avant conversion et éviter le double mapping. Malheureusement, ces extensions sont peu implémentées par les clients VNC, et notamment le client RealVNC ne le gère pas. Dans les clients compatibles on trouve noVNC et TigerVNC. 

TigerVNC fonctionne bien et a une ergonomie correcte pour un usage quotidien. Il est possible d’enregistrer les paramètres de connexion dans un fichier de configuration `.tigervnc` pour pouvoir lancer le client facilement. Enfin presque tous, il n’est plus possible maintenant d’enregistrer le mot de passe VNC dans le fichier !  En palliatif, il est maintenant possible de l’ajouter en variable d’environnement `VNC_PASSWORD` ; vous pouvez utiliser la commande PowerShell ci-dessous pour l’enregistrer dans vos variables utilisateur :  
```  
[Environment]::SetEnvironmentVariable("VNC_PASSWORD", "<votre_mot_de_passe>", "User")  
```

Vous voilà enfin avec un serveur VNC opérationnel et un client VNC qui fonctionne bien avec clavier et presse-papier !

# Connexion hors de votre réseau local

À présent que l’on a un accès distant, il est également utile de pouvoir l’utiliser en dehors du réseau local. J’ai un VPN configuré avec WireGuard, mais pour une raison qui m’échappe, impossible d’utiliser le client RealVNC, dont la connexion échoue 90% du temps. Une fois de plus, TigerVNC fonctionne parfaitement.

## Script de connexion

N’exposez jamais directement sur internet le serveur VNC, car le protocole n’est pas suffisamment sécurisé. J’utilise deux solutions pour y accéder de l’extérieur, soit un VPN sécurisé sur mon réseau local, soit un relais SSH sécurisé.

Pour utiliser un VPN s’il est actif, ce script va en premier pinger l’adresse locale de destination. À noter que si votre connexion locale comporte aussi cette adresse, cette méthode ultra-simpliste ne fonctionnera pas et devra être adaptée. Si l’adresse est accessible, alors le script va réaliser une connexion directe en VNC, en passant par le VPN présent.

Si ce n’est pas le cas, le script va créer un tunnel SSH vers le serveur VNC destination. Pour ce faire, il vous faut un serveur ssh sur votre réseau local, exposé sur internet. et qui autorise la création de tunnels TCP. 

Suivant le serveur que vous utilisez, cela pourra être autorisé par la configuration par défaut, ou nécessiter une modification dans `sshd/sshd-config`, en ajoutant à la fin `AllowTcpForwarding yes`, ou si vous souhaitez limiter ce privilège à votre utilisateur :

```  
Match User remi  
	AllowTcpForwarding yes  
```

Une fois le tunnel activé, le script va ensuite lancer le viewer TigerVNC en se connectant au port local du tunnel pour ouvrir la connexion. Il faut d’une part laisser un peu de temps à SSH pour établir le tunnel avant de lancer TigerVNC, et également laisser du temps à la connexion VNC de se lancer pour maintenir le tunnel actif. C’est l’objet des commandes `sleep` d’une part avant le lancement de `vncviewer`, et d’autre part dans le script lancé à distance par SSH. Une fois le tunnel utilisé, la connexion SSH restera active, même si la commande initiale comportant le `sleep` est maintenant terminée. Et le tout se terminera proprement dès que vous fermerez la fenêtre de TigerVNC.

```sh
DESTIP=${1:-"192.168.1.10"}
DESTPORT=${2:-"5901"}
REMOTESSH=user@sshserver.domain
LOCALPORT=${3:-"$DESTPORT"}
VNCVIEWER=vncviewer
# If problem when resizing screen
#VNCPARAM="--RemoteResize=0 --DesktopSize=1440x950 --AutoSelect=0 --CompressLevel=9 --LowColorLevel=1 --QualityLevel=5"
# For low connections
VNCPARAM="--RemoteResize=0 --DesktopSize=1440x950 --AutoSelect=0 --CompressLevel=9 --LowColorLevel=1 --QualityLevel=5"

# We check DESTIP is not reacheable before using ssh (VPN support)
ping -w 2 -c 2 "$DESTIP"
if [ $? -eq 0 ]
then
  # Direct connection
  echo "Direct connection to VNC"
  $VNCVIEWER $VNCPARAM "$DESTIP:$DESTPORT" &
else
  # Wait ssh before connecting VNC
  (sleep 5 ; $VNCVIEWER $VNCPARAM "localhost:$LOCALPORT" ) &
  # Set up SSH port forwarding
  ssh -L "$LOCALPORT:$DESTIP:$DESTPORT" “$REMOTESSH” “echo Connected, waiting for VNC connection...  && sleep 10" &
  echo "Connecting..."
  # Wait for SSH connection before ending terminal (optional)
  sleep 10
  echo "Terminal ending, connection will be closed when closing VNC"
fi
```

Les différentes variables sont bien sûr à adapter à votre environnement, ainsi que potentiellement les délais des `sleep` s’ils ne convenaient pas. Vous pouvez aussi créer des scripts secondaires appelant ce script avec les bons paramètres si vous avez plusieurs serveurs VNC destination. N’oubliez pas d’utiliser des ports locaux différents.

## Menu de lancement

À ce stade, le script est fonctionnel, mais pas très ergonomique à utiliser. On va à présent ajouter un menu de lancement via un fichier `.desktop`. 

Dans le fichier `.local/share/applications/vnc.desktop` :  
```
[Desktop Entry]
Name=VNC
Exec=/home/remi/vnc.sh
StartupWMClass=TigerVNC Viewer
Icon=/home/remi/.local/share/icons/YourIcon.png
Terminal=false
Type=Application
StartupNotify=true
``` 


Trouvez également une icône qui vous convienne à télécharger et placer dans votre répertoire `icons` (n’oubliez pas de modifier les chemins dans le fichier ci-dessus)

Pour lancer la mise à jour du menu, il faut utiliser la commande `update-desktop-database ~/.local/share/applications/` , ou simplement redémarrer (notamment sous Chromebook la seule commande update ne semble pas suffisante, au moins immédiatement)

L’entrée `StartupVMClass` permet au gestionnaire de fenêtre de faire le lien avec une fenêtre ouverte par le script. On trouve sa valeur en utilisant la commande `xprop` et en cliquant sur la fenêtre concernée, et en regardant la valeur de `WM_CLASS`. Cependant sur Chromebook, cela ne semble pas fonctionner, et la fenêtre de TigerVNC reste avec l’icône par défaut et un titre vide, sans prendre ni l’icône indiquée, ni même l’icône fournie par TigerVNC. Sans doute un petit bug sur les différentes passerelles d’intégration qui sera peut être résolu dans une prochaine version.

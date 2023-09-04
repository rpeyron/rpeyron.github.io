---
title: Installation debian 12
lang: fr
tags:
- Debian
- Linux
- Scripts
categories:
- Informatique
toc: 'yes'
date: '2023-08-13 14:30:00'
image: files/2023/debian12.jpg
---

[Debian 12 "bookworm"](https://www.debian.org/News/2023/20230610) est sortie en juin de cette année. L'occasion de rafraîchir mon installation debian qui datait de plus de 10 ans !  À propos de décennies [debian fête ses 30 ans](https://bits.debian.org/2023/08/debian-turns-30.html), bon anniversaire debian !

Cet article n'est pas un tutoriel d'installation de debian 12 ; d'une part il n'y en a pas vraiment besoin, et d'autre part d'autres articles le font très bien. Il s'agit plutôt d'une collection des petites difficultés rencontrées et des solutions trouvées, avant tout pour m'en souvenir plus tard, mais ça peut servir à d'autres ;-)

# Environnement de bureau
J'utilisais jusqu'à présent l'environnement [LXDE](http://www.lxde.org/) qui avait l'avantage d'être léger, réactif en VNC, et raisonnablement ergonomique à utiliser. Cependant, le statut de LXDE est moyennement clair : on lit aussi bien que le projet est abandonné depuis sa fusion avec Razor-qt pour donner LXQt, mais on trouve également que LXDE continue d'évoluer... LUbuntu a d'ailleurs basculé sur LXQt, avec notamment une rupture de migration avec les LUbuntu précédentes. Bref pas idéal pour un choix à long terme.

LXQt ne présente pas non plus une situation idéal : sur une installation toute fraiche, au démarrage il y a des erreurs sur la zone de notification. On peut en supprimer une partie en ajoutant/supprimant le widget incriminé, mais d'une part certaines erreurs sont persistantes, et d'autre part, ce n'est pas vraiment bon signe. Impossible également de retrouver un layout convenable.

XFCE4 est quand même un peu trop rustique, avec des bords de fenêtre épais disgracieux, et les mêmes erreurs de notification. Gnome a trop d'effets visuels, très sympas sur un PC, mais très lents en VNC. Par ailleurs les versions récentes ont beaucoup perdu en paramétrabilité, et le layout standard ne me convient pas. Et pour une raison qui m'échappe, le switch de bureau a cassé la configuration réseau ! 

Finalement, c'est le desktop MATE (un fork de gnome version 2) qui semble le meilleur choix pour mon usage. Suffisamment répandu pour être stable et pérenne, un peu de confort moderne, mais une interface légère et rapide. Un point érnevant reste la difficulté de redimensionner les fenêtres avec la souris car la bordue d'un pixel est trop fine. Il est possible cependant via `Alt + clic droit` de redimensionner depuis n'importe quel endroit de la fenêtre ([source](https://ubuntu-mate.community/t/make-window-resizing-easier-out-of-the-box/5845/27 ))

Il existe bien d'autres solution de bureaux, dont notamment Cinnamon (Linux Mint), mais je me suis limité aux versions mises en avant par debian.

Un point commun à tous les environnements c'est que très étrangement en 2023 il ne semble plus possible de faire tourner plusieurs instances du même bureau pour un même utilisateur. Certes ce n'est pas un usage très commun, mais quand on utilise VNC, c'est pratique d'avoir un bureau lancé sous VNC sans connexion locale, mais de pouvoir quand même lancer un environnement graphique en local lors de l'installation et des problèmes réseaux. Certains environnements présentent quelques dysfonctionnements, d'autres refusent complètement de se lancer. Pour ces dernières, il existe une bidouille pour autoriser le lancement:

Dans votre fichier Xstartup, ajouter les lignes suivantes avant le lancement de l'environnement (startxfce4 dans le cas ci-dessous):
```sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
```
([source](https://stackoverflow.com/questions/19133889/how-to-run-xfce4-on-debian-on-vnc-startup))


# Boot sur NVME
J'ai installé le nouveau SSD d'une façon peu conventionnelle, en NVMe via un [adaptateur PCI-Express sur le port PCI 3.0](https://www.amazon.fr/Adaptateur-dissipateur-Chaleur-6amLifestyle-Support/dp/B07RZZ3TJG/ref=sr_1_7) du port graphique, le serveur n'utilisant pas de carte graphique.  Et comme ma carte mère a 10 ans, elle ne sait pas nativement accéder au NVMe au boot, ce que j'ai compris un peu tard...

La conséquence est que si on suit l'installateur debian sur le disque NVMe, le résultat ne boote pas. Installer GRUB sur un disque accessible par le BIOS ne suffit pas, car GRUB se charge bien, mais ne sait pas accéder à la partition qui contient le noyau. Il est donc nécessaire d'une part d'installer GRUB et la partition /boot sur un autre disque visible par le BIOS.

Par ailleurs dès que l'installateur debian identifie une partition EFI, il sélectionne GRUB EFI sans tenir compte de toute tentative de lui dire de ne pas utiliser ces partitions. La solution que j'ai utilisée est de :
- booter via [SuperGrub](https://www.supergrubdisk.org/) installé sur clé en clé USB via [Rufus](https://rufus.ie/fr/) ; cet outil permet notamment de scanner tous les disques pour identifier les configurations GRUB et pouvoir booter dessus, ce qui est très pratique pour dépanner une mauvaise installation du démarrage ; c'est beaucoup plus pratique que de devoir comprendre la syntaxe du mode rescue de GRUB ou de booter sur un autre OS et devoir monter le système en chroot
- une fois le système démarré, pour forcer à revenir à un GRUB BIOS, il faut changer de package pour `grub-pc`cela va permettre de retirer le package EFI, puis installer GRUB sur le bon disque via `grub install /dev/sdX` (à noter que la même commande avec le GRUB EFI ne renvoie aucune erreur...)

# Oh my bash!

J'utilise `zsh` depuis 25 ans, avec la même configuration zshrc et notamment le même prompt custom, plus coloré et moins austère que celui par défaut. La première chose que je paramètre sur une nouvelle machine ou une nouvelle VM, c'est de changer le shell pour zsh et de mettre mon zshrc. Autant dire que j'y suis attaché. Et pourtant, sur debian 12, mon .zshrc ne fonctionne pas, et même impossible de changer de prompt sur zsh !!

J'ai donc décidé de passer sous bash, un peu plus classique, et qui a depuis ajouté beaucoup des fonctions avancées de zsh, dont une autocompletion plus poussée que celle qui était paramétrée dans mon zshrc. J'ai quasiment retiré tout paramétrage spécifique, mais il restait à remettre mon prompt custom. Malheureusement la syntaxe du prompt n'est pas la même entre bash et zsh, et pas vraiment lisible. J'ai essayé au hasard ChatGPT qui a su convertir parfaitement le prompt zsh en bash !!  (ce qui est assez bluffant pour un LLM, de plus avec un prompt très simple)

La nouvelle version de LXTerminal (étonnament beaucoup moins bonne que la version que j'utilisais jusqu'à présent sous LXDE) ne permet pas de paramétrer la largeur des onglets, et est très petit. J'en ai donc profité pour compacifier le prompt et le titre, pour retirer le nom d'utilisateur et le nom de l'hote lorsque c'est celui que j'ai l'habitude d'utiliser.

Le résultat dans [ce post dédié]({% link _posts/2023/2023-08-20-profile-bash.md %}).

# Paramétrage réseau
Je boudais injustement NetworkManager depuis des années car je n'avais pas compris son architecture, et pensais à tort qu'il s'agissait d'un logiciel propre à la session utilisateur. Mais il s'agit bien d'un service complet exécuté sans session utilisateur, mais commandable depuis la session. Il comporte désormais quasiment toutes les fonctions principales utiles et facilement paramétrables. Il sait également cohabiter avec les autres gestionnaires réseau.

J'ai opté pour un paramétrage réseau avec :
- une interface ethernet avec DHCP sur la box + unn IP fixe
- une interface Wifi, connectée également sur la box en backup, et avec un access point paramétré en absence de réseau Wifi
- un VPN en IPSec/IKEv2

Le paramétrage complet est détaillé dans [ce post dédié]({% link _posts/2023/2023-08-20-parametrages-reseau-et-vpn-sous-debian-12.md %})

# Bugs en vrac
- A l'installation, pour activer le sudo pour l'utilisateur il ne faut pas renseigner de mot de passe root ; cependant, cela désactive le compte root, ce qui est très  ennuyeux, en cas d'erreur au démarrage, car sulogin empeche de se connecter sans compte root, Il est donc préférable de définir un mot de passe root, puis d'ajouter l'utilisateur dans le groupe `sudo`.  Par ailleurs /usr/sbin n'est pas défini pour l'utilisateur, et n'est pas accessible lors d'un `sudo su`, il faut utiliser `sudo su -` pour qu'il soit bien ajouté dans le path ([source](https://forums.debian.net/viewtopic.php?t=152483)).
- Si vous utilisez `gdm`(par défaut avec gnome), le paramétrage par défaut met en veille l'ordinateur au bout de 20 minutes, ce qui est assez ennuyeux pour un serveur ([source](https://askubuntu.com/questions/1168830/how-to-disable-screen-power-saving-in-gdm3-login-screen )), il faut décommenter la ligne `sleep-inactive-ac-timeout=0`  et redémarrer `gdm3`
- Avec wayland, certains logiciels refusent de se lancer, comme synaptic. Solution: `xhost +si:localuser:root`  ([source](https://itsfoss.com/switch-xorg-wayland/) & [source](https://www.linuxtricks.fr/news/10-logiciels-libres/439-lancer-synaptic-en-root-avec-wayland-sous-debian-gnome/))
- `tigervnc` pose parfois des problèmes de connexion à distance dont je n'ai pas trouvé la cause (malgré l'usage de `-localhost no`) ; le passage à `tightvnc` a résolu le problème

# Trucs en vrac
- Pour installer wine32 : `debian add i386 architecture`  (l'installation via PlayOnLinux n'a pas fonctionné pour ma part)
- Pour activer le service syncthing pour un utilisateur `systemctl enable syncthing@<user>.service && systemctl start syncthing@<user>.service` ou depuis l'utilisateur concerné `systemctl --user enable syncthin.service && systemctl --user start syncthing.service` 
- Pour ajouter des volumes en accès direct dans les navigateurs, ajouter l'option `x-gvfs-show`dans le fstab
- La version standard installe beaucoup de locales et dictionnaires dans tout un tas de langues ; un paquet `localpurge` permet de purger toutes les traductions sauf les locales indiquées, et un petit tour dans synaptic pour désinstaller les  paquets `task-<traduction>` (puis `apt autoremove`, puis supprimer ceux qui n'auraient pas été supprimés automatiquement comme les libreoffice et les dictionnaires `w<langue>`) ; c'est presque 1.5Go de récupéré en moins de 5 minutes
- Switcher entre profils GTK light/dark depuis MATE (le paramétrage existe dans Gnome mais pas MATE) : `gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark && gsettings set org.gnome.desktop.interface color-scheme prefer-dark` ([source](https://askubuntu.com/questions/1405961/how-to-set-dark-light-mode-from-the-gnome-session-in-ubuntu-22-04))
- Si vous en profitez pour repartir d'un profile chromium neuf, mais que vous avez oublié le nom d'utilisateur utllisé sur un site : .config/chromium/Default/Login Data  à ouvrir avec sqlite3  (mais ne permet pas de récupérer le mot de passe)
- Le package `speedtest-cli`fourni ne fonctionne plus ; il faut installer la version de ookla disponible ici https://www.speedtest.net/apps/cli
- Pour éviter les alertes de sécurité intempestives sur localhost dans chromium, on peut activer les flages `chrome://flags/#allow-insecure-localhost` + `chrome://flags/#unsafely-treat-insecure-origin-as-secure`
- Monter les clés USB en ajoutant le droit polkit `org.freedesktop.udisks2.filesystem-mount`   [source](https://unix.stackexchange.com/questions/617591/mount-usb-drive-as-regular-user-in-debian-sid)


# Transfert et nettoyage de fichiers de configuration
Le transfert des fichiers de configuration n'est pas une chose simple. D'une part une simple copie du répertoire `/etc/` est assez contradictoire avec l'idée de réinstaller, d'autre part refaire toute la configuration from scratch est long. Il existe quelques scripts pour se simplifier la vie pour purger les fichiers inutiles et identifier ceux modifiés:
- purger les fichiers de configuration des paquets désinstallés : `dpkg --purge $(dpkg --get-selections | grep deinstall | cut -f1)`  ({source](https://askubuntu.com/questions/104126/can-i-purge-configuration-files-after-ive-removed-the-package))
- identifier les fichiers de configuration modifiés (via debsums qui maintient un hash des fichiers des paquets) : `debsums -ce` ([source](https://unix.stackexchange.com/questions/721575/how-to-see-all-config-files-that-differ-from-package-maintainers-versions-in-de)) et variante pour supprimer les fichiers de configuration identique au paquet (depuis une copie du répertoire) : `debsums -e | grep -e "OK$" | sed 's/\s*OK$//' | cut -c 2-100 | xargs -L 1 -exec rm   && find /path/to/dir -empty -type d -delete` 
- pour lister les paquets installés manuellement `apt-mark showmanual`  et après filtrage, pour installer tous les paquets depuis un fichier `apt install $(cat <fichier-liste-paquets-apt>)` 


# Contexte et réflexions sur l'architecture
L'installation initiale de ce serveur datait de la création de son matériel en 2013, en version wheezy, et mise à jour successivement vers jessie (2015), stretch (2017), buster (2019), bullseye (2021) via la migration debian, qui marche globalement même si quelques ajustements ont été nécessaires parfois. Néanmoins, au bout de 10 ans cela méritait un petit rafraichissement pour repartir sur une base saine, en en profitant pour upgrader vers un nouveau SSD plus rapide. Par ailleurs j'attends toujours la version .1 pour faire la mise à jour, afin d'avoir encore moins de bugs, et ça tombe bien la 12.1 est sortie en juillet.

Je me suis également posé la question de changer plus radicalement sur une nouvelle architecture plus actuelle et maintenable, en lorgnant depuis quelque temps sur :
- une base hyperviseur [Proxmox VE](https://www.proxmox.com/en/) hyperviseur open source, sur base debian, concurrent de VMWare ESXi
- une solution de NAS type [TrueNAS](https://www.truenas.com/) ou [OpenMediaVault](https://www.openmediavault.org/) pour la gestion d'un serveur de fichiers avec tous les services modernes et une administration web
- un desktop moderne, mais en version légère type LUbuntu pour rester accessible en remote, 
- des services additionnels en conteneurs

Pour éviter de perdre du temps, quasiment tout est testable en machine virtuelle pour avoir une bonne idée des capacités des différents outils.

Aussi séduisante soit cette architecture, je suis revenu sur une solution intermédiaire, plus proche de mon architecture actuelle, pour les raisons suivantes :
- même si elle n'est pas ridicule, notamment en mémoire, ma configuration actuelle est limitée en puissance et notamment en nombre de CPU, ce qui limite grandement les capacité des machines virtuelles (et notamment lorsque les besoins en ressources matérielles sont très fluctuants dans le temps entre les services)
- certaines solutions comme Proxmox et TrueNAS sont maitrisées par des sociétés, avec tous les avantages mais également les risques associés, notamment concernant la pérennité
- les solutions gèrent souvent leur espaces de stockage via des pools de données plus ou moins propriétaires, et il faut bidouiller pour pouvoir utiliser les partitions natives de l'hôte, or l'intérêt de passer pas ce type de solution est de ne plus bidouiller
- ça nécessite une charge de mise à jour beaucoup plus importante, puisqu'il faut mettre à jour chaque VM, chaque distribution et chaque conteneur, là où une distribution comme debian simplifie énormément le maintien dans le temps avec un très bon niveau de sécurité

Bref, je suis revenu à quelque chose de plus raisonnable :
- tous les services de bases sont portés par debian, avec la facilité de mise à jour correspondante, au prix d'un setup parfois un peu plus complexe
- l'environnement desktop est directement géré par l'OS de base pour un usage classique
- la virtualisation est fournie par QEmu sur l'OS de base et permet de ne pas pourrir le système de base avec des usages temporaires (en VM pour les tests en mode graphiques, et en devcontainers pour les développement)
- les services non disponibles dans la distribution (notamment sur les solutions domotiques et impression 3D) sont gérées en docker, avec mise à jour watchtower (ce qui facilitera leur éventuel déplacement sur un raspberry - dès que les prix seront revenus à des niveaux raisonnables - pour plus de résilience sur la domotique)

Cela devrait permettre de maximiser les avantages :
- une base stable, pérenne, à jour et sécurisée avec debian
- une utilisation optimale des ressources
- la facilité des conteneurs pour les services non gérés par debian

On en reparle dans 10 ans :-)

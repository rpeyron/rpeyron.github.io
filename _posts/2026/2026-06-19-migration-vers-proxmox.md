---
title: Migration vers Proxmox
lang: fr
tags:
- Proxmox
- Docker
- Virtual
- Scripts
- Debian
- VNC
categories:
- Informatique
toc: 2
ia: Copilot
date: '2026-06-19 11:30:00'
image: files/2026/migration_proxmox.jpg
---

Retour d'expérience sur la migration de mon serveur historique monolithique vers une infrastructure Proxmox et des composants containerisés. Cette transition aura duré plus d'un an, avec différentes phases progressives pour lisser les évolutions dans le temps, quand j'ai le temps de m'en occuper, et sans pour autant avoir de coupure de service.

# Pourquoi ?
Mon serveur sous Linux s'était construit au fil du temps, de mon premier PC il y a plus de 20 ans à l'école, mis dans un placard plus tard pour en faire en serveur, et en lui ajoutant au fil du temps différentes fonctions et logiciels. Le résultat était devenu une accumulation qui n'était plus très maîtrisée de scripts, de batch cron, de services que j'utilise tous les jours, au milieu de différentes expérimentations et de mon desktop Linux me servant également d'environnement de développement. Chaque montée de version de debian était un défi, et si généralement la première se passait bien, la suivante posait problème sur certaines subtilités et j'avais à réinstaller en urgence, avec la difficulté de ne rien oublier... Avec les solutions actuelles de virtualisation et de containérisation, il était temps de restructurer et rationaliser. 

Cette situation n'avait cependant pas que des inconvénients, dans les avantages :
- cette architecture "monolithique" était très performante pour optimiser l'usage des ressources physiques limitées de mon serveur, car l'intégralité des ressources CPU et mémoire était disponible pour tous les services, sans segmentation, sans overhead
- même chose pour les accès aux disques, tous les services ont accès au matériel avec des IOs optimales 
- quasiment tous les services étaient installés depuis les paquets debian, la mise à jour était ainsi très simple, avec une gestion des mises à jour très simple à faire

C'est ce qui a fait que la migration a déjà pris du temps à concevoir, pour trouver la bonne architecture cible, puis réaliser la transition. A noter que j'avais tenté une première tentative il y a quelques années, à l'arrache lors d'une réinstallation, et j'avais fini par revenir en arrière car je m'étais retrouvé bloqué par l'absence de réflexion préalable sur l'architecture.

# Les étapes suivies

J'ai suivi les étapes suivantes :
1. Des expérimentations sur machine virtuelle sur mon PC pour choisir les solutions principales
2. Recenser tous les services dont je me sers, choisir ce que je conserve et ce que j'abandonne, et voir dans quel environnement je les positionne (container, VM,...)
3. Commencer à migrer en container petit à petit mes services en docker sur le serveur précédent
4. Installer [Proxmox sur mon serveur debian actuel](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm), Proxmox est basé sur debian et il est possible de l'ajouter sur une debian existante ; cette étape permet de poursuivre la migration petit à petit, en migrant sur VM
5. Installer Proxmox en standalone sur un nouveau disque, en maintenant un double boot pour revenir en arrière tant que ce n'est pas finalisé
6. Basculer sur la nouvelle architecture
7. Finaliser avec toutes les améliorations (notamment l'ajout d'un idp, de l'authentification, du routage https, des backups...)

On peut aussi prendre une image du serveur précédent et le faire tourner en VM (`qemu-img convert -O qcow2 /dev/nvme0n1p5 /mnt//images/100/old-server.qcow2`, désactiver le secure-boot, créer une nouvelle VM debian, ajouter le disque, le mettre en premier, booter, chroot, et réinstaller le boot avec pve-efiboot-tool)

# Les solutions et l'architecture retenue
## Hyperviseur Proxmox

[Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview), solution open source populaire, basée sur debian dont j'ai l'habitude, avec un modèle économique entreprise et une bonne communauté ; en alternatives Xen ne m'avait pas convaincu en test, et coté VMware, même si plus facile à utiliser, n'est pas libre (avec les changements de politique suite au rachat par Broadcom, je suis content de ne pas avoir fait le choix de VMWare...)  

## NAS et Docker dans une VM Debian
Eh oui, encore et toujours [debian](https://www.debian.org/) depuis 25 ans :)  j'étais plutôt parti initialement sur utiliser [OpenMediaVault](https://www.openmediavault.org/) ou [TrueNAS](https://www.truenas.com/), que j'ai essayé pendant plusieurs semaines, mais pas vraiment moderne et assez limité pour le premier, et également un peu rigide pour le second, avec des doutes sur la pérennité de la gratuité ; ce sera donc debian, mais avec un maximum sous docker et en limitant son paramétrage local (et en notant tout, dans la perspective de scripter l'installation de la VM plus tard) ; j'espère qu'une solution type [NixOS](https://nixos.org/) se développera sur debian pour pouvoir avoir une configuration scriptée et complètement reproductible (en fait, il y a déjà des tentatives, mais qui ne me semblaient pas encore assez matures).

## Stockage en passthrough PCI

Un point qui m'a bloqué pendant longtemps, j'ai en gros un stockage SSD pour le quotidien et des disques en raid logiciel pour le stockage. Mes exigences sont que ces stockages restent directement lisibles en cas de crash, sans utiliser des filesystems virtuels ou autres, et que les performances soient décentes.

Expérimental avec Proxmox 8, [virtiofs](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_virtual_machines_settings) devient facile à utiliser avec Proxmox 9. J'étais donc parti sur cette option avec le hardware géré par Proxmox et les dossiers montés dans chaque VM suivant les besoins, mais la compatibilité avec notamment Docker, Samba, et NFS n'était pas bonne. Mauvaise piste... Par ailleurs le fait que le stockage soit directement traité par proxmox ne me plaisait pas non plus, car lorsque les disques en raid ont des problèmes (et ça arrive plus souvent qu'on voudrait...), cela bloque potentiellement tout le boot, avec besoin se connecter physiquement.

J'ai finalement pensé au passthrough PCI :
- d'une part pour passer un SSD NVMe (et donc PCI), à la VM server ; comme il n'est pas possible de le couper en deux, j'ai donc ajouté un NVMe : 1 pour les VMs géré par Proxmox, et 1 autre pour le stockage quotidien géré par la VM Server
- d'autre part pour passer le contrôleur SATA de ma carte mère, et que les disques durs SATA soient directement gérés par la VM Server ; et après 15 ans d'usage du raid logiciel mdadm avec une très grande résilience (le raid m'a sauvé plusieurs fois, y compris les fonctions de récupération robustes de mdadm, par contre ext4fs a eu quelques corruptions...), j'ai cédé aux sirènes de ZFS. J'espère que je n'aurai pas à le regretter...  

La VM Server fera serveur de fichiers, avec Samba pour l'usage bureautique, et NFS pour partager avec les autres VMs.

## Home Assistant OS en VM

J'avais commencé ma migration de domoticz vers Home Assistant en docker, cependant on perd beaucoup à ne pas utiliser la version VM Home Assistant OS avec les mises à jour facile et les apps/addons qui permettent d'étendre les fonctions avec des dockers directement gérés par Home Assistant OS. Cette VM est parfaitement bien prévue, avec les mises à jour et les backups automatiques distants. 

## Routage et VPN avec OPNsense

J'ai testé différents routeurs, soit en virtuel en VM ou en physique avec un firmware custom comme OpenWRT. [OPNsense](https://opnsense.org/) correspond parfaitement à ce que je cherchais, très riche en fonctionnalités, très facile à utiliser avec son IHM simple, et extensible avec les plugins. Il permet de couvrir les fonctions de firewall, de VPN et de proxy dont j'ai besoin.

## Le maximum de services en docker

Pour que chaque service intègre ses propres dépendances et découpler au maximum les services, les containers sont l'idéal. 

Pour en faciliter la gestion, j'ai fait le choix de :
- déployer uniquement avec docker compose en fichier yaml, notamment à l'aide de [Portainer](https://www.portainer.io/) au début, et [Dockhand](https://dockhand.pro/) maintenant
- stocker les configurations et les volumes à conserver en répertoires absolus dans le système de fichier de l'hôte (et non perdu dans l'arborescence docker de la VM)
- sélectionner avec soin les images docker à utiliser, en évitant les exotiques non maintenues ou risquées
- pour mes scripts maison, de créer des scripts de setup à partir d'une base docker debian-slim plutôt que des Dockerfile à reconstruire, pour bénéficier des mises à jour sans avoir à mettre en place une CI complète sur les Dockerfile

J'ai ainsi actuellement une cinquantaine de containers en une trentaine de stacks, et notamment :
- [Dockhand](https://dockhand.pro/) pour l'administration de l'ensemble docker (stacks, logs, mises à jour automatiques,...)
- [Ofelia](https://github.com/mcuadros/ofelia) pour l'orchestration des batchs ; j'ai essayé beaucoup d'alternatives, sans trouver la solution qui me convienne parfaitement en simplicité et interface, mais après avoir appris à utiliser ofelia, j'en suis très content ; j'ai également quelques conteneurs customs qui intègrent directement leur cron locale
- [duplicati](https://duplicati.com/) pour les sauvegardes, avec [rclone](https://rclone.org/) pour des destinations non supportées 
- [syncthing](https://syncthing.net/) pour la synchronisation entre les différents PC et le serveur
- [Traefik](https://traefik.io), [PocketID](https://pocketid.app), [TinyAuth](https://tinyauth.app) pour la sécurisation (voir l'article dédié [sur la sécurisation de l'infrastructure]({{ /2026/06/securisation-de-vos-serveurs/' | relative_url }}))
- et en vrac, [Gogs](https://gogs.io), [LanguageTool](https://languagetool.org), [MiniDLNA](https://sourceforge.net/projects/minidlna), [Scrutiny](https://github.com/AnalogJ/scrutiny)

## Des dockers VNC pour administrer

La ligne de commande c'est sympa, mais les interfaces graphiques aussi. Pour pouvoir administrer le serveur, que ce soit pour l'édition des fichiers de configuration ou également pour gérer les fichiers en direct, j'avais initialement prévu une VM GUI, sous debian avec interface graphique et en montant les répertoires en NFS. C'est lourd et pas très pratique. Une excellente alternative est de créer un docker qui créé un serveur VNC. 

Voici un exemple de docker-compose (il existe une image docker sur le même principe [consol/debian-xfce-vnc](https://hub.docker.com/r/consol/debian-xfce-vnc)) :
```yaml
services:
  vnc:
    image: debian
    restart: unless-stopped
    container_name: server-vnc
    mem_limit: 2g
    environment:
      HOME_DIR: /home
      USERNAME: username
      PASSWORD: xxxxxx
      UID: 1000
      GID: 1000
      VNC_PASSWORD: yyyyyyy
      VNC_OPTIONS: -geometry 1600x1000
    ports:
      - "5900:5900"
    command: 
      - bash
      - -c
      - |
        # Escape $ to $$
        if ! id -u "$${USERNAME}" > /dev/null 2>&1; then
          echo "Création de l'utilisateur '$${USERNAME}' ..."
          groupadd -g "$${GID}" "$${USERNAME}"
          useradd -m -u "$${UID}" -g "$${GID}" -d "$${HOME_DIR}" -s /bin/bash -p "$$(mkpasswd -m sha-512 $${PASSWORD})" "$${USERNAME}"
          mkdir -p "$${HOME_DIR}"
          chown -R "$${UID}:$${GID}" "$${HOME_DIR}"
        else
          echo "L'utilisateur $${USERNAME} existe déjà."
        fi
        unset PASSWORD

        echo 'Setting up container...'
        
        export DEBIAN_FRONTEND=noninteractive
        
        echo "locales locales/locales_to_be_generated multiselect fr_FR.UTF-8 UTF-8" | debconf-set-selections
        echo "locales locales/default_environment_locale select fr_FR.UTF-8" | debconf-set-selections
        echo "localepurge localepurge/multiselect multiselect fr en" | debconf-set-selections
        echo "keyboard-configuration  keyboard-configuration/xkb-keymap select fr" | debconf-set-selections
        echo "keyboard-configuration  keyboard-configuration/layoutcode string fr" | debconf-set-selections
        echo "keyboard-configuration  keyboard-configuration/layout toggle" | debconf-set-selections 
        
        apt-get update
        apt-get install -y unattended-upgrades \
        	tigervnc-standalone-server tigervnc-tools \
        	locales localepurge keyboard-configuration tzdata \
        	lxqt-core openbox dbus-x11 xdg-user-dirs \
        	screen symlinks nano scite ncdu \
        	qterminal pcmanfm-qt qdirstat \
            \
            sudo vlc wget baobab chromium
        
        apt-get remove -y xfwm4 upower xscreensaver
        apt-get autoremove -y
        apt-get clean

        ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
        dpkg-reconfigure -f noninteractive tzdata

        usermod -aG sudo $${USERNAME}

        echo "Write xstartup"
        echo '
          export LANG=fr_FR.utf8
          export LANGUAGE=fr_FR:fr
          export LC_ALL=fr_FR.utf8
          export SHELL=/bin/bash
          
          unset SESSION_MANAGER
          vncconfig -nowin &
          xhost +
          setxkbmap fr
          
          (sleep 5 && pcmanfm-qt /home ) &
          startlxqt
        ' > /xstartup
        chmod a+rx xstartup

        echo "Switching to user $${USERNAME}"
        su --preserve-environment "$${USERNAME}" -c '

          export HOME=$${HOME_DIR}
  
          write_conf_file() {
             mkdir -p $$(dirname "$$1")
             [ ! -f "$$1" ] && echo -e "$$2" > "$$1"
          }
          
          write_conf_file "$${HOME_DIR}/.config/lxqt/lxqt.conf" "[General]\ntheme=light\n" 
          
          echo "Starting VNC server..."
          echo -e "$${VNC_PASSWORD}\n$${VNC_PASSWORD}\n" | tigervncpasswd $${HOME_DIR}/.vnc_passwd
          unset VNC_PASSWORD
          tigervncserver :2 -fg -localhost no -passwd $${HOME_DIR}/.vnc_passwd -xstartup /xstartup $${VNC_OPTIONS}
        '
    volumes:
      - /docker/vnc/home:/home
      - /:/mnt/host
```

J'utilise comme client VNC  RealVNC Viewer en version 7 (version Classic dont le téléchargement semble malheureusement réduit maintenant), qui fonctionne très bien en enregistrement de sessions, restauration de connectivité en sortie de veille, et gestion des copier/coller.

Il est possible d'avoir le même principe sous RDP avec `xrdp`.

## Autres machines virtuelles 

- une VM Linux pour avoir un desktop pour le dev, l'idée est d'en faire un template et d'instancier par projet ou réinitialisation
- une VM Lab pour avoir un environnement desktop qui me serve de lab pour tester des nouveautés sans pourrir le serveur
- une VM Windows pour avoir un desktop de secours, accessible avec Remote Desktop Protocol de Windows, en cas de problème avec mon PC portable (setup comparable)

## Autres détails

Pour des sauvegardes automatiques long terme, la VM Server expose en NFS à Proxmox un dossier qui est monté en storage pour être une destination de backup. 

# Ressources utiles
## Autres articles LPRP.fr liés à la migration Proxmox
- [Sécuriser votre infrastructure maison avec Proxmox, OPNsense, Traefik, Home Assistant et PKI XCA]({{ '/2026/06/securisation-de-vos-serveurs/' | relative_url }})   
- [USB d'un PC Windows distant dans une VM Proxmox via USB-IP]({{ '/2026/06/proxmox-usbip/' | relative_url }})
- [Proxmox - Réduire la taille d'un disque]({{ '/2026/06/proxmox-resize-disks/' | relative_url }})  
- [Accès distant VNC avec Proxmox/QEMU]({{ '/2025/09/acces-distant-vnc-avec-proxmox-qemu/' | relative_url }})

## Documentations
- [Documentation Proxmox](https://pve.proxmox.com/pve-docs/)
- [Proxmox Helper Scripts](https://community-scripts.org/)

## Trucs et astuce pour Proxmox
- Pour utiliser la console xterm.js et ses copier/coller facilités, il faut ajouter une console série dans hardware et ajouter dans `/etc/default/grub`:   `GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200"` et `GRUB_TERMINAL="console serial"`
- Hotplug automatique via Proxmox, voir le hookscript de [cet article]({{ '/2026/06/proxmox-usbip/' | relative_url }})
- Eviter de passer par un cluster pour migrer d'une instance Proxmox à une autre ; le mode cluster n'est pas prévu pour fonctionner avec 2 serveurs ; il existe maintenant [Proxmox Datacenter Manager](https://www.proxmox.com/en/products/proxmox-datacenter-manager/overview) qui devrait être plus adapté (sorti malheureusement après ma migration, donc non testé) ; si vous faites la même erreur que moi, pour forcer la sortie du mode cluster il faut suivre [Cluster_Manager / remove_a_cluster_node](https://pve.proxmox.com/wiki/Cluster_Manager#_remove_a_cluster_node) 
- Pour le passthrough PCI il peut être nécessaire de faire des group iommu séparés :  `/etc/default/grub`: `GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt pcie_acs_override=downstream,multifunction"` pour AMD, ou pour Intel  `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream,multifunction"` puis `update-grub && reboot`
- Pour optimiser la consommation électrique : `
```sh
apt install powertop linux-cpupower
cpupower frequency-set -g powersave
powertop --auto-tune
systemctl enable powertop
```
- Pour installer via DKMS des modules noyaux signés compatible avec secure boot (typiquement ZFS pour debian): https://www.linuxtricks.fr/wiki/signer-les-modules-noyau-tiers-dkms-pour-le-secure-boot-sous-linux

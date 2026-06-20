---
title: USB d'un PC Windows distant dans une VM Proxmox via USB-IP
lang: fr
date: '2026-06-14 11:00:00'
categories:
- Informatique
toc: 1
tags:
- Proxmox
- USB
- Script
- IP
ia: Perplexity
image: files/2026/usbip_vignette.jpg
---

Ce tutoriel explique comment partager un périphérique USB connecté à un PC Windows distant avec une machine virtuelle Linux sous Proxmox, en utilisant **usbipd-win** (serveur Windows) et le client USB/IP Linux.

Les différentes étapes :
- installer [usbipd-win](https://github.com/dorssel/usbipd-win) sur le PC Windows et exposer (bind) le device USB
- installer le client USB-IP sur Proxmox et attacher le périphérique
- ajouter le périphérique dans une VM
- rendre automatique l'attachement à Proxmox et l'ajout à la VM

# Installer usbipd-win sur le PC Windows
`usbipd-win` utilise WSL (Windows Subsystem pour Linux), vous devez avoir WSL opérationnel, configuré et en cours d'exécution sur votre Windows
{: .notice-note}

`usbipd-win` est la déclinaison Windows du serveur USB-IP en utilisant WSL, vous pouvez l'installer facilement via `winget`
```powershell
winget install usbipd
```
ou manuellement en téléchargeant la dernière version `.msi` sur [GitHub - dorssel/usbipd-win](https://github.com/dorssel/usbipd-win) et exécutant l'installateur.

**Ce que l'installation ajoute :**
- Un service `usbipd` (USBIP Device Host)
- L'outil en ligne de commande `usbipd` (ajouté à PATH)
- Une règle de pare-feu pour autoriser les connexions locales sur TCP 3240

> **Note :** Si vous utilisez un pare-feu tiers, reconfigurez pour autoriser les connexions entrantes sur **TCP port 3240**.


# Lister et lier (bind) le périphérique USB sur Windows
## Option ligne de commande
Ouvrez **PowerShell ou CMD en mode administrateur** sur le PC Windows.

Pour lister les périphériques USB disponibles
```powershell
usbipd list
```

Exemple de résultat :
```
BUSID DEVICE STATE
1-7 USB Input Device Not shared
4-4 STMicroelectronics STLink dongle Not shared
5-2 Surface Ethernet Adapter Not shared
```

Identifiez le **BUSID** de votre périphérique (ex: `4-4`).

Ensuite pour lier (bind) le périphérique au réseau
```powershell
usbipd bind --busid=4-4
```

Remplacez `4-4` par le BUSID de votre appareil.

Vérifier que le périphérique est partagé
```powershell
usbipd list
```

Le STATE doit maintenant être **Shared**.

> **Important :** Le `bind` est **persistant** — il survit aux redémarrages. À faire une seule fois par périphérique.


## Option GUI sous Windows - WSL USB Manager

Si vous préférez une interface graphique pour gérer les périphériques USB vers WSL, utilisez [WSL USB Manager](https://github.com/nickbeth/wsl-usb-manager), qui est une interface pratique et légère à utiliser.

![]({{ 'files/2026/usbip_wsl_manager.png' | relative_url }}){: .img-center .mw80}

- Dans l'onglet "Connected" sont listés tous les périphériques USB connectés au PC, pour exposer en USB-IP l'un d'entre eux, utiliser le bouton "Bind"
- La liste des périphériques "Binded" est visible dans l'onglet "Persisted"

N'oubliez pas que cela utilise WSL sous le capot, donc pour que l'exposition soit active, il faut vous assurer que WSL soit bien lancé. Typiquement après un reboot Windows, dès que vous voulez exposer un device USB, ouvrez une ligne de commande WSL pour forcer.


# Configuration USB/IP sur Proxmox

On va ici installer le client USB/IP directement sur Proxmox. Cela va permettre de pouvoir l'ajouter à n'importe quelle VM très simplement, qu'elle sous Windows ou Linux. Mais vous pouvez également configurer USB/IP directement dans les VMs, avec le même procédé.

## Installation des binaires et modules noyaux
Ouvrez une **Shell** sur le nœud Proxmox et installez les outils USB/IP :

```bash
apt update
apt install usbip usbip-utils
```

Chargez les modules noyaux nécessaires :
```bash
modprobe usbip-core
modprobe vhci-hcd
modprobe usbip-host
```

Ajoutez ces modules dans `/etc/modules` pour qu'ils soient chargés au démarrage :
```bash
echo "usbip-core" >> /etc/modules
echo "vhci-hcd" >> /etc/modules
echo "usbip-host" >> /etc/modules
```

## Attacher le périphérique USB remote à Proxmox 

Pour lister les périphériques distants disponibles, sur Proxmox (remplacez `IP_WINDOWS` par l'adresse IP ou DNS de votre PC Windows, par ex `192.168.1.50`) :
```bash
usbip list --remote=<IP_WINDOWS>
```

Exemple :
```
BUSID DEVICE STATE
4-4 STMicroelectronics STLink dongle Shared
```

Ensuite, pour attacher (attach) un des périphériques USB (Remplacez `IP_WINDOWS` par l'adresse IP ou DNS de votre PC Windows et `4-4` par le BUSID de votre appareil)
```bash
usbip attach --remote=<IP_WINDOWS> --busid=4-4
```

Vous pouvez ensuite vérifier que le périphérique est bien attaché avec `usbip port` et `lsusb`, et vous pouvez ensuite l'ajouter à une VM depuis Hardware / Add USB Device comme s'il était directement branché sur l'hôte Proxmox  (ou en ligne de commande avec `qm set 100 -usb0 host=0483:374b`) 

# Configurer l'attachement automatique
Pour un attachement automatique du périphérique à Proxmox et à la VM dès qu'il est détecté sur le Windows distant, il faut configurer deux parties :
- sur Proxmox, on va ajouter un script qui scanne régulièrement les devices exposés et disponibles, et les attache automatique à Proxmox
- sur la VM, on va rendre l'ajout USB dynamique pour qu'il soit ajouté dès que détecté, mais ne bloque pas le lancement de la VM

## Sur Proxmox - usbip-watch.sh

Script `usbip-watch.sh` *(vibecodé avec Copilot)*
```bash
#!/usr/bin/env bash
set -euo pipefail

SERVER="${SERVER:-votre_windows.lan}"
INTERVAL="${INTERVAL:-60}"
USBIP="${USBIP:-/usr/sbin/usbip}"

log() {
  echo "[$(date '+%F %T')] $*"
}

load_modules() {
  modprobe usbip_core || true
  modprobe vhci_hcd || true
}

remote_busids_available() {
  "$USBIP" list --remote="$SERVER" 2>/dev/null \
    | sed -n 's/^[[:space:]]*-\{0,1\}[[:space:]]*\([0-9][0-9]*-[0-9.][0-9.]*\).*/\1/p' \
    | sort -u
}

remote_busids_mounted() {
  "$USBIP" port 2>/dev/null \
    | sed -n "s#.*usbip://$SERVER:3240/\([0-9][0-9]*-[0-9.][0-9.]*\).*#\1#p" \
    | sort -u
}

debug_state() {
  log "Remote busids available:"
  remote_busids_available | sed 's/^/  - /' || true
  log "Remote busids already mounted:"
  remote_busids_mounted | sed 's/^/  - /' || true
}

attach_missing() {
  mapfile -t mounted < <(remote_busids_mounted)

  while read -r busid; do
    [[ -z "$busid" ]] && continue
    if printf '%s\n' "${mounted[@]:-}" | grep -qx "$busid"; then
      continue
    fi
    log "Attaching $busid from $SERVER"
    "$USBIP" attach --remote="$SERVER" --busid="$busid" || true
  done < <(remote_busids_available)
}

detach_disappeared() {
  mapfile -t mounted < <(remote_busids_mounted)
  mapfile -t available < <(remote_busids_available)

  local busid port
  for busid in "${mounted[@]:-}"; do
    if printf '%s\n' "${available[@]:-}" | grep -qx "$busid"; then
      continue
    fi
    port="$("$USBIP" port 2>/dev/null | sed -n "/usbip:\/\/$SERVER:3240\/$busid/,\$p" | sed -n 's/^Port \([0-9][0-9]*\):.*/\1/p' | head -n1)"
    if [[ -n "${port:-}" ]]; then
      log "Detaching port $port for missing remote busid $busid"
      "$USBIP" detach --port="$port" || true
    fi
  done
}

log "Loading kernel modules"
load_modules
log "Starting usbip watcher for server=$SERVER interval=${INTERVAL}s"

while true; do
  # debug_state
  attach_missing
  detach_disappeared
  sleep "$INTERVAL"
done
``` 

et lancé au démarrage via la ligne crontab suivante (édité avec `crontab -e`) :
```crontab
@reboot         /usr/bin/bash /root/bin/usbip-watch.sh
```

Le script scanne régulièrement les périphériques disponibles à la fréquence `INTERVAL` à modifier selon votre convenance, et attache automatiquement les nouveaux périphériques exposés et détache ceux qui ne sont plus disponibles.


## Sur la VM - en hotplug

Il ne fait pas inclure le périphérique USB directement dans la liste du Hardware, car sinon la VM refusera de se lancer si le périphérique n'est pas trouvé. L'astuce pour la VM est d'utiliser le hotplug en ajoutant le périphérique juste après que la VM soit lancée. On va réutiliser le `hook` créé dans l'article [accès distant VNC avec Proxmox]({{ '/2025/09/acces-distant-vnc-avec-proxmox-qemu/' | relative_url }})

On va créer le hook script dans le répertoire des snippets et le rendre exécutable : `/var/lib/vz/snippets/hook-hotplug.sh`   
```sh
#!/bin/bash

# From Perplexity: hook script pour proxmox qui ajoute dans le qm monitor 
# après le démarrage le contenu du fichier à .hotplug.conf 
# à coté du fichier de configuration de la VM

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
Et pour l'utiliser il faut ajouter dans chaque VM concernée la ligne suivante :  
```  
hookscript: local:snippets/hook-hotplug.sh  
```

Le principe de ce script va être de répondre à l’évènement `post-start` lancé à la fin du démarrage de la VM, de lire le fichier de configuration `<vmid>.hotplug.conf` à côté du fichier de configuration de la VM, et de l’injecter dans l’interface QEMU Monitor.

Pour notre cas, le fichier hotplug sera simplement :  `/etc/pve/qemu-server/<vmid>.hotplug.conf`  
```  
device_add usb-host,vendorid=0x0549,productid=0x0720,id=remoteusb
``` 

Et voilà il ne reste plus qu'à redémarrer Proxmox (ou lancer manuellement le script et redémarrer la VM concernée) 


# Commandes récapitulatives

| Action | Commande Windows (admin) | Commande Linux (Proxmox/VM) |
|--------|--------------------------|-----------------------------|
| Lister USB locaux | `usbipd list` | `usbip list -l` |
| Lister USB distants | - | `usbip list --remote=IP_ou_DNS` |
| Lier (bind) | `usbipd bind --busid=X-X` | `usbip bind -b X-X` |
| Attacher (attach) | `usbipd attach --wsl --busid=X-X` | `usbip attach --remote=IP_ou_DNS --busid=X-X` |
| Détacher | `usbipd detach --busid=X-X` | `usbip detach -p 0` |
| Vérifier attachement | `usbipd list` | `usbip port` |

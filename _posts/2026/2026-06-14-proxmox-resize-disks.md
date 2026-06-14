---
title: Proxmox - Réduire la taille d'un disque
lang: fr
tags:
- Proxmox
- Shell
- Partition
- Home Assistant
categories:
- Informatique
toc: 1
date: '2026-06-14 10:25:00'
image: files/2026/proxmox_disk_reduce.jpg
ia: Perplexity, Copilot
---

S'il est très facile d'augmenter la taille d'un disque virtuel sous Proxmox, l'opération inverse est nettement plus délicate. Lors de l'installation de Home Assistant, j'ai dû réduire un disque surdimensionné. Voici la procédure utilisée.

# Démarrer sur GParted

- Ajouter l'ISO [GParted](https://gparted.org/livecd.php) en CDROM à la VM
- Modifier l'ordre de boot pour démarrer dessus
- Lancer la VM

# Réduire la partition

Dans GParted :
- Sélectionner le disque
- Réduire la partition à la taille souhaitée (ex: 16G)
- Appliquer les changements
- Éteindre la VM

# Réduire le disque côté Proxmox

Sur l'hôte Proxmox :

```bash
lvreduce -L 16G /dev/mapper/pve-vm--102--disk--1
```

⚠️ Adapter le chemin du volume si nécessaire (`vm--ID--disk--X`).

# Réparer la table de partition

Toujours sur l'hôte :

```bash
gdisk /dev/mapper/pve-vm--102--disk--1
```

Ensuite dans `gdisk` :

- `x` (mode expert)
- `e` (réparer la table GPT)
- `m` (retour menu principal)
- `p` (vérifier)
- `w` (écrire)
- `q` (quitter)

# Redémarrer la VM

```bash
qm start 102
```

Dans  Home Assistant, certains plugins peuvent échouer après modification du disque. Si c'est le cas désactiver temporairement SSL  ou reconfigurer correctement les certificats

# Références

- https://forum.proxmox.com/threads/decrease-a-vm-disk-size.122430/

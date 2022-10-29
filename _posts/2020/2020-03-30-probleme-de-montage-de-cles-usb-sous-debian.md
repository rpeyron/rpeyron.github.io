---
post_id: 4273
title: 'Problème de montage de clés USB sous Debian ?'
date: '2020-03-30T20:34:48+02:00'
last_modified_at: '2020-03-30T20:34:48+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4273'
slug: probleme-de-montage-de-cles-usb-sous-debian
permalink: /2020/03/probleme-de-montage-de-cles-usb-sous-debian/
image: /files/2017/10/debian_1508005209.png
categories:
    - Informatique
tags:
    - Debian
    - polkit
    - udisks
lang: fr
---

Si depuis une mise à jour de Debian vous avez lors de l’insertion d’une clé USB une demande d’authentification suivi d’un vilain message “Not authorized to perform operation”, le problème vient certainement de udisks2 + polkit. En effet, la police par défaut distribuée avec Debian est quelque peut restrictive et demande les droits administrateurs pour ces opérations. Avec l’authentification de l’utilisateur normal, le message d’erreur s’explique.

Pour autoriser votre utilisateur sur ces opérations, il faut ajouter une règle qui va surcharger la police par défaut. Créer un fichier `automount.pkla` dans le répertoire `/etc/polkit-1/localauthority/50-local.d/` avec le contenu suivant :

```
[Allow Automount]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks2.filesystem-mount*
ResultAny=yes
ResultInactive=yes
ResultActive=yes

[Allow Eject]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks2.eject-media*
ResultAny=yes
ResultInactive=yes
ResultActive=yes

[Allow Mounting of fstab]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks2.filesystem-fstab*
ResultAny=yes
ResultInactive=yes
ResultActive=yes

[Allow Unlock]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks2.encrypted-unlock*
ResultAny=yes
ResultInactive=yes
ResultActive=yes
```

Si ce n’est pas déjà fait, ajoutez votre utilisateur au groupe `plugdev` et redémarrez la session.

Par ailleurs si les partitions de vos clés USB ne s’affichent pas comme il vous plait, c’est sans doute qu’il n’y a pas de label. Ajoutez-le suivant le type de partition :

- ext2/3/4 : `e2label /dev/<your device> “your label”`
- fat32 : `fatlabel /dev/<your device> “yourlabel”`

Et pour essayer tout ça sans devoir physiquement retirer/remettre le périphérique USB, un script très pratique sur [cette page](https://askubuntu.com/questions/1036341/unplug-and-plug-in-again-a-usb-device-in-the-terminal).
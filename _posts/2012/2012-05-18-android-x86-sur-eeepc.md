---
post_id: 1378
title: 'Installer Android x86 pour EeePC (T101MT)'
date: '2012-05-18T01:42:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2012/05/android-x86-sur-eeepc/'
slug: android-x86-sur-eeepc
permalink: /2012/05/android-x86-sur-eeepc/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1684";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/android_1507997712.jpg
categories:
    - Informatique
tags:
    - Blog
lang: fr
---

# Installer Android x86 pour EeePC (T101MT)

Télécharger la dernière iso d’Android x86 pour EeePC 4.0 sur le site internet [http://www.android-x86.org/download](http://www.android-x86.org/download "http://www.android-x86.org/download").

Pour pouvoir ensuite sélectionner d’autres sources de boot, il faut désactiver le “BootBooster” de l’EeePC dans le BIOS. Pour ceci, appuyer sur la touche \[F2\] lors du boot, puis allez dans les options désactiver le BootBooster. Il vous suffira lors des boots suivant d’appuyer sur \[Esc\] pour booter depuis un autre média.

Vous pouvez tester android en live sur la clé USB, ou l’installer sur le disque pour pouvoir l’utiliser de manière continue. Si vous optez pour la deuxième solution, il vous faudra créer une partition libre. L’outil GParted est idéal pour celà. Vous pouvez le télécharger depuis l’adresse [http://gparted.sourceforge.net/](http://gparted.sourceforge.net/ "http://gparted.sourceforge.net/") et l’installer sur une clé USB avec l’outil YUMI disponible à l’adresse [http://www.pendrivelinux.com/yumi-multiboot-usb-creator/](http://www.pendrivelinux.com/yumi-multiboot-usb-creator/ "http://www.pendrivelinux.com/yumi-multiboot-usb-creator/"). Installez GParted sur la clé USB, rebootez sur la clé USB (touche \[Esc\]), lancez GParted, redimensionnez les partitions précédentes si nécessaire pour faire de la place, et créez une partition ext2.

Puis installez l’iso d’Android x86 sur une clé USB avec Unetbootlin (disponible à l’adresse [http://unetbootin.sourceforge.net/](http://unetbootin.sourceforge.net/ "http://unetbootin.sourceforge.net/")). A noter que pour une raison inconnue, cette iso ne fonctionne pas avec YUMI. Il vous suffit ensuite de rebooter, sélectionner le boot USB via la touche \[Esc\], puis vous laisser guider dans l’installation. C’est fini !

# Tweaks

## Installer Rotation Lock

Sur un terminal n’ayant pas de capteur de rotation, le comportement d’Android est parfois erratique et le bureau tourne tout le temps, malgré l’option de non rotation. Pour remédier à cela, installez l’application “Rotation Lock” depuis le market Google Play. Vous pourrez ainsi locker la rotation sur le mode paysage ou portrait au choix. Seules les applications ne supportant pas ce mode feront tourner votre écran temporairement.

## Eteindre Android

Au mieux le bouton Power sert à contrôler la mise en veille, mais ne permet pas d’éteindre. Pour cela il suffit d’installer l’application “Shutdown” depuis le market Google Play, puis de mettre un raccourci sur votre bureau. Un simple appui permettra d’éteindre proprement votre Android. Cette application nécessitant le mode root, un message de confirmation vous sera demandé lors de la première exécution.

## Changer le clavier pour un clavier français

Par défaut le seul clavier disponible est le clavier anglais. Heureusement, grâce à XDA, le clavier français est disponible (sur [ce post](http://forum.xda-developers.com/showthread.php?t=1082408 "http://forum.xda-developers.com/showthread.php?t=1082408")). Il vous faudra télécharger les [fichiers de mapping clavier](/files/2012/05/android_azerty_keymap.zip "android_azerty_keymap.zip (4.7 KB)") et les installer dans /system/usr/keylayout/ pour Generic.kl et /system/usr/keychars/ pour Generic.kcm. Pour ce faire, il vous faudra monter /system en mode lecture/écriture (rw) ; vous pouvez installer l’application “Remount” pour ceci.

Ce fichier désactive la touche Power ; pour la récupérer, il faut éditer le fichier Generic.kcm et mettre en face du keycode 116 la valeur POWER. Vous pouvez utiliser l’application “keyEvent Display” pour d’autres touches posant problème.

## Ajouter le support ARMv5

[http://www.borncity.com/blog/2012/07/21/installing-arm-emulator-on-android-x86-4-rc2/](http://www.borncity.com/blog/2012/07/21/installing-arm-emulator-on-android-x86-4-rc2/ "http://www.borncity.com/blog/2012/07/21/installing-arm-emulator-on-android-x86-4-rc2/")
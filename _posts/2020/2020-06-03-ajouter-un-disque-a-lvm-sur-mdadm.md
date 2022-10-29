---
post_id: 4382
title: 'Ajouter un disque à LVM sur mdadm'
date: '2020-06-03T20:12:50+02:00'
last_modified_at: '2021-12-25T17:26:06+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4382'
slug: ajouter-un-disque-a-lvm-sur-mdadm
permalink: /2020/06/ajouter-un-disque-a-lvm-sur-mdadm/
image: /files/2020/06/IMG0029395-1.jpg
categories:
    - Informatique
tags:
    - Linux
    - lvm
    - mdadm
    - raid
lang: fr
term_language:
    - Français
term_translations:
    - pll_61b4dcd2585ff
---

Pour mes sauvegardes et stockage long terme, j’ai un système un peu compliqué, construit au fil des années avec différents disques disparates assemblés via LVM et en Raid5 logiciel avec mdadm pour la redondance. L’avantage, c’est que ça permet de mélanger les tailles de disques ce qui n’est pas supporté par raid5.

Le principe est tout simple : un premier raid de la taille du disque le plus petit. Tous les disques participeront à ce raid. Puis ensuite, un autre raid avec la plus petite taille restante, auquel participeront tous les disques sur lesquels il reste de la place, et au besoin, ainsi de suite jusqu’à utiliser tout l’espace des disques. En faisant ainsi, cela permet d’assembler au mieux des disques disparates, de tailles différentes car récupérés ou achetés au fil du temps. Et malgré tout de ne “perdre” en redondance que l’espace du disque le plus grand. Le résultat est plusieurs arrays raid, ce qui n’est pas pratique, d’où l’assemblage avec LVM pour ne constituer qu’un seul disque logique reposant sur les x disques physiques constitués par les raid.

L’inconvénient, c’est que quand je veux ajouter un disque (c’est-à-dire pas très souvent), eh bien je ne me souviens plus de comment il faut faire… Ce post me permettra au moins de m’en souvenir 🙂 mdadm, lvm, ext4 sont bien conçus et permettent donc de réaliser cette opération à chaud, avec les disques montés.

Après avoir partitionné le disque avec les tailles exactes attendues pour les raid, il faut en premier ajouter les partitions à chacun des arrays raid concernés :

```
mdadm /dev/md0 --add /dev/sdi1
```

Puis ensuite, augmenter la taille du raid. Cette opération va provoquer une reconstruction du raid avec un disque en plus. C’est l’opération la plus longue de l’ensemble. Rassurez-vous, mdadm a pensé à tout et vous ne perdrez pas vos données même en cas de coupure de courant pendant la reconstruction, ou défaillance d’un des disques pendant l’opération, qui sollicite fortement les disques.

```
mdadm --grow /dev/md0 --raid-devices 5
```

A cette étape votre raid doit indiquer la nouvelle taille, mais le reste de la chaîne n’est pas au courant. Il faut donc indiquer l’augmentation du disque physique à LVM :

```
pvresize /dev/md0
```

Puis redimensionner le disque logique et la partition en utilisant l’ensemble de l’espace nouvellement ajouté :

```
lvresize --resizefs -l +100%FREE /dev/lvm/main
```

L’option `–resizefs` permet d’enchaîner le redimensionnement du système de fichier de la partition logique, mais il est possible de distinguer les deux étapes.

Tout est maintenant prêt et un `df` devrait vous montrer en espace libre le nouvel espace disque ajouté !
---
post_id: 4291
title: 'Machine virtuelle avant réinstallation'
date: '2020-04-25T16:39:38+02:00'
last_modified_at: '2020-05-02T16:41:11+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4291'
slug: machine-virtuelle-avant-reinstallation
permalink: /2020/04/machine-virtuelle-avant-reinstallation/
image: /files/2020/05/VMware_Player_logo.png
categories:
    - Informatique
tags:
    - QEmu
    - VDHX
    - VMWare
    - Windows
lang: fr
---

J’ai du réinstaller mon Windows récemment, car celui-ci s’était bizarrement corrompu au niveau des pilotes réseau et toute nouvelle installation de drivers plantait, supprimant ainsi petit à petit mes interfaces réseau. Windows 10 est cependant un OS très stable par rapport à ses prédécesseurs, car 5 ans entre deux réinstallations c’est mon record absolu. Comme toujours avant de ré-installer, quelques précautions s’imposent comme des sauvegardes, bien identifier ce qui sera à réinstaller, et pour plus de sécurité, j’ai décidé de créer une machine virtuelle de mon OS avant réinstallation.

Sur mes PCs j’ai pris l’habitude de bien distinguer une partition système des partitions de données. Ainsi lors d’une réinstallation, seule la partition système est impactée et les autres partitions ne bougent pas. Cette distinction me permet également de pouvoir faire une image disque de la partition système, au juste nécessaire, et de la stocker sur une partition non impactée.

Voici les opérations que j’ai effectuées :

1. Pour ne copier que le juste nécessaire de la partition, j’utilise [sdelete](https://docs.microsoft.com/en-us/sysinternals/downloads/sdelete) avant pour supprimer les espaces libres : `sdelete -z C:` ; ce petit outil est également très utile pour vos disques de machines virtuelles qui grossissent au fur et à mesure des mises à jour. Un peu de ménage, sdelete puis le compactage de l’image disque et celle-ci reprend une taille de guèpe !
2. Ensuite, pour créer l’image disque de la partition, un autre outil que j’utilise très souvent : [Disk2VHD](https://docs.microsoft.com/en-us/sysinternals/downloads/disk2vhd) ; cet outil va permettre de prendre une image disque de n’importe quel disque, clé USB, carte SD, et de le convertir au format VHDX. Ce format est le format des images virtuelles des outils microsoft, et comporte l’énorme avantage de pouvoir être montés nativement par Windows simplement en double cliquant dessus. Vosu avez alors accès au contenu du disque et pouvez même le modifier. Il y a de rares cas où il est nécessaire d’attribuer une lettre de partition avec la gestion des disques de Windows (via Gestion de l’ordinateur) ; c’est le cas notamment de la partition C:. Cet outil permet également de copier des images bitlocker, ce qui est un moyen très pratique de protéger par mot de passe un ensemble de document et d’y accéder simplement.
3. Pour l’essentiel des besoins de récupération de données, le simple accès au disque devrait être suffisant ; si cependant pour une raison vous avez besoin de booter sur votre ancien système, il est facile de créer une machine virtuelle : 
    - Pour booter il est nécessaire de copier également les deux premières partitions cachées qui servent au boot, et non pas seulement la partition C: ; si comme moi vous les aviez oubliées, pas de panique, on peut les copier après avec un outil de gestion des partitions, comme par exemple [MiniTool Partition](https://www.minitool.fr/gestionnaire-partition/partition-wizard-accueil.html) ; j’utilie la version Pro que j’avais pu acquérir gratuitement car assez souvent proposé gratuitement dans les journées ‘giveaway’, mais la version gratuite devrait suffire (et sinon, je ne peux que vous conseiller de l’acheter car c’est un très bon outil).
    - Comme je souhaite utiliser VMWare Player (mais ça marcherait sans doute avec Virtual Box), il faut également convertir l’image disque en vmdk avec qemu-img (distribué avec QEmu) : `qemu-img.exe convert -f vhdx -O vmdk .\HP-2020-04-26i.VHDX .\HP-2020-04-26i.vmdk`
    - Puis ensuite créer sous VMWare une nouvelle machine virtuelle, ne pas créer de disque, puis éditer la machine virtuelle pour ajouter le disque existant
4. Pour le rendre non persistent, éditer le vmx et ajouter : `scsi0:0.mode = “independent-nonpersistent”` ; vous pouvez copier le vmx et ainsi disposer pour la même image disque d’une machine en mode persistent et une autre en mode non persistent, vous permettant ainsi de choisir à chaque boot.

Le premier boot sera assez long car il va installer tous les drivers des périphériques VMWare. Vous avez également intérêt à installer les outils VMTools. Pour ces opérations, sauf si vous voulez absolument garder votre disque d’origine, je vous conseille d’être en mode persistent, sinon les opérations seront à répéter à chaque boot.
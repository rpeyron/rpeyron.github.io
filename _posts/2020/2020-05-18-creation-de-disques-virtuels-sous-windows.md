---
post_id: 4359
title: 'Création de disques virtuels sous Windows'
date: '2020-05-18T18:41:46+02:00'
last_modified_at: '2020-05-18T18:41:46+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4359'
slug: creation-de-disques-virtuels-sous-windows
permalink: /2020/05/creation-de-disques-virtuels-sous-windows/
image: /files/2020/05/VHDX-creation-2.png
categories:
    - Informatique
tags:
    - BitLocker
    - Disk2VHD
    - QEmu
    - VHD
    - VMWare
    - Virtual
lang: fr
lang-ref: pll_5ec2baca1a458
lang-translations:
    fr: creation-de-disques-virtuels-sous-windows
    en: virtual-disk-creation-on-windows
---

Toutes les éditions de Windows 10 ont un support de disques virtuel qui est méconnu. Et si vous avez accès à la version Windows 10 Pro, vous pouvez le crypter avec BitLocker pour en faire un container crypté qui fonctionnera sur toutes les éditions de Windows sans besoin de logiciel supplémentaire. Pratique !

# Création du disque virtuel

Créer un disque virtuel est assez facile avec l’utilitaire “Gestion de l’ordinateur”. C’est un outil standard Windows qui a été un peu masqué dans les dernières éditions de Windows, mais qui reste très efficace. Il est trouvable dans les “Outils d’administration” dans le menu “Système Windows”. Dans cette application vous trouverez l’outil “Gestion des disques”. Vous pouvez également le trouver en cherchant directement “partition”, “gestion des disques”, “gestion de l’ordinateur” dans la recherche :

![](/files/2020/05/Gestion-des-disques.png){: .img-center}

1\. Créer un disque virtuel avec le menu “Action” / “Créer un disque virtuel”

![](/files/2020/05/VHDX-creation-300x165.png){: .img-center}

2\. Sélectionner le format VHDX, avec extension dynamique, et la taille maximum que vous désirez. Comme avec Windows 10 Home le changement de la taille d’un disque virtuel n’est pas facile, mieux vaut opter pour une taille importante. Avec Windows 10 Pro vous pourrez étendre la taille d’un disque virtuel avec les outils de gestion Hyper-V.

![](/files/2020/05/VHDX-creation-2-243x300.png){: .img-center}

3\. Il faut ensuite initialiser le disque avec une table des partitions, soit le ‘vieux’ MBR ou le plus récent GPT. Je préfère généralement le plus récent, mais cela prend également plus de place.

![](/files/2020/05/VHDX-creation-3-300x230.png){: .img-center}

4\. Puis ensuite créer une partition avec un clic droit sur l’espace libre du disque. Vous pouvez choisir d’utiliser l’intégralité du disque, ou si vous avez prévu large, vous pouvez réduire la partition à la taille utile en premier lieu, puis l’étendre par la suite. En effet, s’il n’est pas forcément facile de redimensionner un disque virtuel il est facile de le redimensionner avec l’outil de gestion des partitions disponible sur toutes les éditions. Vous pouvez donc commencer petit et augmenter au fur et à mesure des besoins, pour éviter que l’allocation automatique fasse grossir le disque virtuel jusqu’à sa taille maximum au fur et à mesure des écritures. Il faut ensuite choisir entre exFAT ou NTFS. Comme pour GPT, NTFS est plus performant mais prendra plus de place.

![](/files/2020/05/VHDX-creation-4-300x88.png){: .img-center} ![](/files/2020/05/VHDX-creation-5-300x236.png){: .img-center}

Vous avez maintenant un disque virtuel fonctionnel.

Pour le déconnecter vous pouvez soit :

- depuis l’explorateur, faire un clic droit sur le disque, et sélectionner “Ejecter” (si vous avez créé plusieurs partitions sur le même disque il vous faudra toutes les ejecter pour ejecter complètement le disque virtuel)
- depuis l’outil de gestion des partitions, faire un clic droit sur le disque virtuel et sélectionner “Détacher le disque virtuel”

Pour le re-connecter ensuite, il suffit de double cliquer sur le fichier VHDX.

# Le chiffrement avec BitLocker

Pour ajouter du chiffrerment avec BitLocker, depuis une édition Windows 10 Pro, cliquer droit sur le disque virtuel connecté dans l’explorateur et cliquer sur “Activer BitLocker” puis suivre les étapes : un mot de passe robuste, la sauvegarde des informations de récupération, ne chiffrer que l’espace utilisé, et conserver les autres paramètres par défaut.

![](/files/2020/05/Bitlocker-1-300x115.jpg){: .img-center}

![](/files/2020/05/Bitlocker-2-300x128.jpg){: .img-center}

Ejecter le disque et vous avez maintenant un conteneur autonome chiffré avec BitLocker et qui fonctionnera sur n’importe quelle édition de Windows 10, qu’elle soit Home ou Pro. Vous bénéficierez d’ailleurs de l’ensemble des fonctions BitLocker sur ce disque, comme la possibilité de changer le mot de passe ou de récupérer un mot de passe oublié avec les informations de récupération. Vous pouvez faire plusieurs copies de ce container pour en créer autant qu’il vous faut, avec des mots de passe distincts. La seule limitation est qu’ils vont partager les mêmes informations de récupération qu’il faudra donc conserver bien à l’abri. Windows 10 Pro n’est requis que pour la création du container, vous pouvez donc emprunter un PC d’un ami / collègue ayant Windows 10 Pro 5mn pour créer votre disque puis ensuite ne plus avoir besoin d’avoir accès à cette édition.

# Comparaison des tailles des conteneurs

Comme j’ai été un peu surpris par les tailels des fichiers créés, j’ai fait quelques tests. A noter que ces tests ne correspondent qu’à des conteneurs vides. Il est probable que les différences s’estompent au fur et à mesure de l’utilisation avec des vraies données.

J’ai créé une série de disques virtuels avec des paramètres différents. En premier des disques non initialisés qui ne prennent quasiment pas de place :

![](/files/2020/05/VhdxSizes-NotInitialiazed-300x28.png){: .img-center}

Puis avec une table de partition et une partition : GPT prend plus de place que MBR, et NTFS plus que exFAT. Pour une taille minimum, prendre le duo MBR et exFAT :

![](/files/2020/05/VhdxSizes-Partitionned-300x70.png){: .img-center}

BitLocker va naturellement demander plus de place avec le chiffrement :![](/files/2020/05/VhdxSizes-BitLocker-300x44.png){: .img-center}

Ce qui est très intéressant, c’est que bien que les tailles des disques deviennent conséquentes bien que vides, ces fichiers se compressent très très bien avec au final 377ko pour NTFS/GPT en zip, ou 13 Mo pour un disque virtuel zippé Bitlocker/exFAT/MBR.

![](/files/2020/05/VhdxSizes-Zipped-300x155.png){: .img-center}

Vous pouvez donc vous préparer des disques en avance et les stocker pour quasiment pas de place.

Je restais un peu étonné de la différence des tailles avec des disques créés depuis des clés USB avec Disk2VHD :

![](/files/2020/05/VhdxSizes-Disc2VHD-300x32.png){: .img-center}

Malheureusement, impossible d’utiliser Disk2VHD sur des disques virtuels… Dommage ça aurait pu être fun! Comme ces différences peuvent être dûes à des pré-allocations, j’ai voulu convertir les fichiers sans preallocation pour voir si ça change quelque chose.

# On joue un peu avec QEmu-img

Un outil pratique pour manipuler les disques virtuels est [qemu-img](https://www.qemu.org/docs/master/interop/qemu-img.html) de l’émulateur QEmu. Disponible pour Windows et Linux il vous permet de faire un peu tout : compactage, redimensionnement, et conversions entre `qcow2` (format natif QEmu), `vmdk` (format natif VMWare), `vhi` (format natif Virtual Box) and `vhdx` (format natif Hyper-V).

J’ai commencé par une conversion directe de VHDX en VHDX avec :

```
qemu-img.exe convert -f vhdx -O vhdx -o subformat=dynamic Empty100Go.vhdx Empty100Go-converted.vhdx
```

Echec total, cela a fait grossir le fichier à quasiment sa taille complète ! (86 Go vs 100 Go de capacité maximale)

Etrangement, avec un intermédiaire en qcow2 ça marche beaucoup mieux :

```
qemu-img.exe convert -f vhdx -O qcow2 -o preallocation=off Empty100Go.vhdx Empty100Go-converted.qcow2
qemu-img.exe convert -f qcow2 -O vhdx -o subformat=dynamic Empty100Go-converted.qcow2 Empty100Go-converted.vhdx
```

Le fichier résultant pèse 168 Mo, donc moins que l’original à 196 Mo. A noter que le fichier temporaire qcow2 fait 2.75 Go, ce qui est plutôt surprenant compte tenu de la préallocation nulle…

Donc en résumé, les tailles minimum des conteneurs sont obtenues :

- lorsqu’ils sont compressés !
- avec MBR &amp; exFAT (versus GPT &amp; NTFS)
- en les créant avec Disk2VHD depuis des clés USB vides (plutôt que les créer avec la gestion des disques)

(Résultats applicables uniquement sur des conteneurs vides, il est très probable que l’écart soit diminué avec du contenu.)

A noter que si vous avez l’édition Windows 10 Pro, vous pouvez installer la fonctionnalité optionnelle Hyper-V et avoir des fonctions de manipulations supplémentaires sur les disques virtuels dans la console de management Hyper-V dans le menu “Action” “Modifier le disque” : vous pourrez compacter, étendre et convertir les disques VHDX (conversion uniquement entre VHD/VHDX et prealloué ou non)

![](/files/2020/05/Hyper-V-Modify-Disk-300x225.png){: .img-center}
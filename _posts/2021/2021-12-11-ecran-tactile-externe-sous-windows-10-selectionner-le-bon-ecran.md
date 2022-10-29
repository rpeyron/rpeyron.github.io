---
post_id: 5579
title: 'Ecran tactile externe sous Windows 10 : sélectionner le bon écran'
date: '2021-12-11T18:16:02+01:00'
last_modified_at: '2021-12-11T18:16:02+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5579'
slug: ecran-tactile-externe-sous-windows-10-selectionner-le-bon-ecran
permalink: /2021/12/ecran-tactile-externe-sous-windows-10-selectionner-le-bon-ecran/
image: /files/PortableScreenZeuslap.png
categories:
    - 'Avis Conso'
    - Informatique
tags:
    - Ecran
    - Windows
    - hdmi
    - portable
    - tactile
    - zeuslap
lang: fr
---

J’ai acheté récemment un écran tactile externe, qui m’a surpris par ses nombreuses possibilités, mais souffre d’un petit défaut sous Windows lorsque l’écran est connecté en HDMI en tant qu’écran secondaire ; en effet, l’entrée tactile est positionnée sur l’écran principal et non pas l’écran secondaire. Le paramétrage est pourtant prévu dans Windows, mais pas accessible du tout...

Dans une ligne de commande avec les droits d’administrateur, lancer :

```
control.exe /name Microsoft.TabletPCSettings
```

Cela va ouvrir la fenêtre suivante :

![](/files/TabletPCSettings.png){: .img-center}

Qui va vous permettre, via l’appui du bouton “Configurer”, de pouvoir sélectionner à quel affichage correspond votre entrée tactile.

Source : https://traxusinteractive.com/tips-for-using-a-multitouch-monitor-with-windows-10/ (dans les commentaires)

Je mentionnais précédemment avoir été impressionné des possibilités de cet [écran tactile Zeuslap](https://fr.aliexpress.com/item/4000864914757.html?spm=a2g0s.9042311.0.0.27426c37TaxKxr) de 15,6 pouces :

- Connectable en HDMI à un PC + avec un câble USB pour ajouter l’entrée tactile
- Connectable en USB Type-C à un Chromebook (fonctionne aussi avec un PC ayant un port type C compatible vidéo)
- Support du [mode DEX de Samsung](https://www.samsung.com/fr/apps/samsung-dex/), ce qui permet d’avoir un affichage type PC à partir d’un smartphone Samsung S8 (tout en chargeant le téléphone) ; je n’avais jamais testé ce mode avant, mais c’est assez intéressant pour avoir une solution nomade, mais confortable (en ajoutant clavier/souris Bluetooth)
- Et permet bien évidemment d’afficher un Chromecast ou une FireTVStick, mais également de les alimenter directement depuis le port type C via un câble adaptateur type C – micro USB

L’écran est assez léger et inclue une protection d’écran qui sert également de support lorsque l’écran est ouvert. Tous les câbles utiles pour n’importe quelle configuration de branchement sont également inclus. Un peu cher au tarif normal, mais en promotion à presque moitié prix, c’est une affaire qui sera utile dans de multiples situations !
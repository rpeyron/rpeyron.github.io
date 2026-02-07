---
title: Remplacer un verrou MPM cassé en 3D avec Fusion360
lang: fr
tags:
- Verrou
- 3D
- Fusion 360
- MPM
- Printables
- Thingiverse
categories:
- 3D
toc: 'yes'
date: '2026-02-07 15:30:00'
image: files/2026/vignette_verrou_mpm.jpg
---

Après de nombreuses années de service, la partie fixe du verrou plastique d'une de mes persiennes s'est cassé en deux, sans doute suite à la fatigue du plastique soumis à de fortes températures lorsqu'il est exposé au soleil, et de fortes contraintes mécaniques lors de la fermeture. Suite à quelques recherches, il semblerait que ce soit un verrou assez courant de modèle "MPM".

![]({{ 'files/2026/MPM _ Casse et imprime.jpg' | relative_url }}){: .img-center .mw60}

# Tentative à la colle
![]({{ 'files/2026/MPM _ Tentative bicarbonate.jpg' | relative_url }}){: .img-right .mw30}
Ma première tentative a été de recoller la pièce avec de la colle cyanoacrylate. J'ai tenté en même temps de consolider avec du bicarbonate collé, une technique dont on peut voir plusieurs vidéos impressionnantes.

C'est un échec complet à la première tentative de fermeture, la contrainte mécanique casse toute la colle instantanément :

![]({{ 'files/2026/MPM _ Echec bicarbonate.jpg' | relative_url }}){: .img-left .mw40}

{: .clear-float}
# Modélisation 3D avec Inkscape et Fusion360
## Scan 
La première étape est de scanner le modèle à reproduire. La meilleure solution pour la 3D est le scan 3D, soit avec un appareil dédié (mais assez cher), soit avec de la photogrammétrie (à recommander si vous avez un iPhone avec capteur à détection de profondeur, il y a des applications dédiées). Cependant pour cet objet c'est tout à fait surdimensionné, et un simple scan 2D suffit amplement.

Je l'ai fait assez simplement avec mon scanner, en positionnant les pièces directement sur la vitre et en ajoutant des règles pour pouvoir garder des repères de taille qui seront très utiles lors de l'étape de calibration. J'ai scanné une pièce cassée, et une autre en bon état d'une autre persienne.

![]({{ 'files/2026/MPM _ SCAN1869.JPG' | relative_url }}){: .img-center .mw60}

C'est également possible sans scanner, en prenant en photo les pièces ; il faut prévoir de traiter l'image par la suite pour supprimer la déformation, par exemple avec Darktable et ses fonctionnalités de [correction de lentille](https://docs.darktable.org/usermanual/4.6/fr/module-reference/processing-modules/lens-correction/), ou de [correction de perspective](https://docs.darktable.org/usermanual/4.6/fr/module-reference/processing-modules/rotate-perspective/). Une alternative pour minimiser la déformation sans post-traitement consiste à prendre les objets assez loin et à la verticale, puis de zoomer ensuite sur l'image.

## Vectorisation
Cette partie est facultative, vous pouvez importer l'image directement dans Fusion360. Mais j'ai voulu tester la vectorisation dans Inkscape et la possibilité d'utiliser le profil correspondant dans Fusion360. Ce n'est finalement pas ce que j'ai utilisé.

Cette photo montre les différentes étapes, de gauche à droite, en vectorisant via détection de contours, puis nettoyant les imperfections et en simplifiant un maximum sans affecter la forme globale :

![]({{ 'files/2026/MPM _ Vectorisation 191505.png' | relative_url }}){: .img-center .mw80}


## Modélisation sous Fusion360

Dans Fusion360, on peut ensuite insérer l'image:

![]({{ 'files/2026/MPM - Fusion360 _ Inserer SVG.png' | relative_url }}){: .img-center .mw80}

Puis la calibrer en utilisant le clic droit sur l'image, puis option Calibrer ; il suffit ensuite de tracer une cote et la dimension associée. Parfait pour utiliser notre règle repère.

![]({{ 'files/2026/MPM - Fusion360 _ Calibration _ 2025-12-27 180135.png' | relative_url }}){: .img-center .mw80}

J'ai ensuite créé une esquisse au-dessus de l'image, puis créé les volumes 3D à partie de l'esquisse.

![]({{ 'files/2026/MPM Fusion360 _ Esquisse _ 2026-02-07 195158.jpg' | relative_url }}){: .img-center .mw80}

![]({{ 'files/2026/MPM Fusion360 _ 3D _ 2026-02-07 195158.jpg' | relative_url }}){: .img-center .mw80}


## Impression

Enfin la dernière étape est l'impression ; j'ai utilisé les réglages suivants :
- utilisation d'un filament PETG pour plus de résistance mécanique et thermique (et moins cassant que le PLA), à 240°C et 80°C pour le plateau
- un remplissage de 50% en Cubic  (un remplissage plus important ne donne pas plus de résistance mécanique)
- 3 épaisseurs de murs, et 4 couches en haut et en bas
- et bien sûr des supports

![]({{ 'files/2026/3dprint_verroumpm.gif' | relative_url }}){: .img-center}

Le résultat est plutôt OK, et semble résister correctement aux tests que j'ai faits à confirmer dans le temps :

![]({{ 'files/2026/MPM _ Resultat ferme.jpg' | relative_url }}){: .img-center .mw60}

J'avais oublié à ce stade les coins cassés, j'ai corrigé sur le dernier modèle. Les modèles sont disponibles sous [Thingiverse](https://www.thingiverse.com/thing:7290146) ou [Printables](https://www.printables.com/model/1589582-verrou-mpm-pour-persiennes).

---
post_id: 2930
title: 'Imprimante 3D &#8211; Anet A8'
date: '2018-05-08T20:03:51+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2930'
slug: imprimante-3d-anet-a8
permalink: /2018/05/imprimante-3d-anet-a8/
image: /files/2018/05/anet-a8-3d-imprimante-diy-kit-auto-assemblage-mk8.jpg
categories:
    - 3D
tags:
    - 3D
    - 'Anet A8'
lang: fr
---

J’ai acheté récemment une imprimante 3D Anet A8, et c’est vraiment super fun. Voici mon installation et les améliorations apportées.

J’ai choisi ce modèle, qui n’est désormais plus tout jeune, notamment pour les raisons suivantes :

- On la trouve maintenant à des prix défiant toute concurrence, entre 100 et 150 euros
- Elle permet d’imprimer beaucoup de types de matériaux différents, et notamment du flexible (moyennant adaptation, voir ci-dessous)
- Il existe une communauté très importante autour de cette imprimante ce qui permet de trouver rapidement : 
    - de l’aide sur un peu n’importe quel sujet
    - de nombreux design d’objets 3D à imprimer pour améliorer l’imprimante
    - des firmwares open source plus riches, notamment Marlin

Le package en lui même est plutôt bien fait, et le montage super bien documenté avec une notice papier simple et surtout une vidéo de montage pas à pas. Le montage prend facilement 5 heures en ne chômant pas, voire plus si comme moi vous prenez le temps de découvrir. A noter une astuce que j’ai vue bien trop tard : pour décoller simplement les autocollants, il suffirait de les faire tremper quelques temps dans de l’eau pour qu’ils se décollent ensuite tout seul.

Voici les améliorations que j’ai achetées / installées :

- Un serveur OctoPI / [Octoprint](https://octoprint.org/) installé sur une raspberry ; ce que j’avais sous la main est une Raspberry Pi première génération, ça tourne mais c’est quand même un peu juste (met pas mal de temps à booter + n’est pas très réactif) ; l’installation est super simple, il suffit de télécharger l’image disponible, la mettre sur une carte SD et de faire la configuration. J’avais également testé Octoprint sur un Orange PI Zero, qui marche également mais je voulais ajouter une camera raspberry pour surveiller l’impression.
- Un firmware [Marlin](http://marlinfw.org) absolument indispensable, d’une part d’un point de vue sécurité car il implémente les vérifications de températures non disponibles d’origine (et qui m’ont déjà bien sauvé la mise…) et d’autre part par les nombreuses fonctions supplémentaires qu’il apporte, et notamment le réglage vertical du lit. J’ai utilisé [marlintool](https://github.com/mmone/marlintool) pour compiler et uploader le firmware directement depuis la raspberry (attention à bien déconnecter Octoprint de l’imprimante)
- Une prise électrique commandable à distance ou depuis OctoPrint (même si finalement je n’utilise jamais l’imprimante quand je ne suis pas là pour raison de sécurité) ; j’ai retenu ces [prises](https://www.amazon.fr/gp/product/B077NVXGZ7/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1) qui se trouvent être des prises Sonoff qui peuvent être mises à jour avec le firmware [Tasmota](https://github.com/arendst/Sonoff-Tasmota) soit par wifi avec [SonOTA](https://github.com/mirko/SonOTA) si vous avez la chance d’avoir le bon firmware (ne les mettez surtout pas en service avec l’application eWelink, sinon ils se mettront automatiquement à jour avec le dernier firmware non compatible OTA), soit manuellement en se branchant sur la prise en suivant [ces instructions](https://projetsdiy.fr/hacker-prise-connectee-sonoff-s20-super-smart-plug-espeasy-rules/) ; une fois Tasmota installé, vous pouvez utiliser le plugin [Octoprint-Tasmota](https://github.com/jneilliii/OctoPrint-Tasmota)
- Le changement des roulements hyper bruyants du hotbed par des Igus RJ4JP-01-08 ; c’est un peu cher mais vous retrouverez l’usage de vos oreilles lors de l’impression, surtout si comme moi 2 roulements étaient particulièrement mauvais. Je me suis limité pour l’instant à ceux du hotbed car vu la difficulté à mettre les tiges de l’axe X je ne sais pas si j’arriverais à les démonter.
- Une [rangée de LED](https://fr.aliexpress.com/item/DC12V-LED-Strip-Light-SMD-5050-60led-M-0-5M-1M-2M-3M-4M-5-M/1000004472276.html?spm=a2g0s.9042311.0.0.IztCI5) pour éclairer, branchées en 12V en sortie du transformateur de l’Anet A8
- Un [panneau en verre](https://www.amazon.fr/gp/product/B00ICKHRBA/ref=oh_aui_detailpage_o01_s00?ie=UTF8&psc=1) attaché avec des [petites pinces de 15mm](https://www.amazon.fr/gp/product/B074G1PRDJ/ref=oh_aui_detailpage_o01_s00?ie=UTF8&psc=1) sur lequel j’utilise de la laque Pouce “fixation forte” de chez Auchan (~1€) qui marche très bien
- Une [spatule](https://www.amazon.fr/gp/product/B01L3E7N9M/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1) pour détacher les impressions (avec un marteau, ça semble bourrin mais en fait terriblement efficace et n’abîme pas du tout les impressions) ; il n’est pas inutile de nettoyer de temps en temps le plateau à l’acétone lorsqu’il y a trop de résidus
- Et pour la sécurité au feu : un extincteur à main et des [couvertures anti-feu](https://www.amazon.fr/gp/product/B01675FH3G/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1) dont j’espère bien ne jamais avoir à me servir (et bien sûr un détecteur anti feu comme obligatoire aujourd’hui)

Et les améliorations imprimées :

- La première, et absolument indispensable, [antizwooble.stl](https://www.thingiverse.com/thing:2121017/#files) pour éviter les mouvements des tiges filetées de l’axe Z, qui dans mon cas causaient de gros problèmes de déplacement de l’axe Z (les moteurs se bloquaient ce qui déréglait tout) ; pour pouvoir les imprimer j’ai bloqué les axes avec deux serre-fils inclus avec l’Anet A8, sans quoi l’imprimante était simplement inutilisable.
- Ce [guide filament à mettre à l’intérieur de l’extrudeur](https://www.thingiverse.com/thing:2242903) pour pouvoir imprimer du flexible ; j’ai testé avec du Flexismart, et c’est radical : impression impossible sans, impression parfaite avec
- Des guides filament comme [celui-ci](https://www.thingiverse.com/thing:1764285) ou [celui-ci qui se visse](https://www.thingiverse.com/thing:2332804) mais que finalement je n’utilise plus depuis que j’ai imprimé [ce très pratique porte bobines au dessus de l’écran](https://www.thingiverse.com/thing:2409405) (prévoir une tige filetée de 20cm de 8mm de diamètre)
- Ce [support pour raspberry](https://www.thingiverse.com/thing:2133010) à l’arrière de l’écran (pour OctoPi)
- Ce [cache pour la carte mère de l’Anet A8](https://www.thingiverse.com/thing:2734766), histoire de faire un peu plus propre ; je ne suis pas complètement satisfait car ça ne cache pas tous les fils, mais je n’ai pas trouvé mieux, ou alors c’est trop gros / galère à fixer
- Ce [bouton pour extrudeur](https://www.thingiverse.com/thing:1935151/#files) histoire de ne plus se massacrer le doigt à chaque fois ; je l’ai imprimé en flexible pour d’une part que ça soit plus agréable et d’autre part car tous les modèles essayés n’arrivaient pas à rentrer dans la vis
- Ce [réglage de tension pour l’axe Y](https://www.thingiverse.com/thing:2149867) car la courroie a fini par se distendre et faisait beaucoup de bruit ; j’ai du changer de vis car celle d’origine était trop grosse et cassait.
- Ce [canalisateur d’air](https://www.thingiverse.com/thing:2133328) bien plus efficace que celui d’origine et j’avais beaucoup de problèmes avec l’original ou les autres modèles circulaires qui se prenaient dans l’impression et bloquait l’axe Y en désaxant toute l’impression. Il faut bien suivre les instructions de réglages communiquées par l’auteur pour que ça soit efficace.

Coté logiciel, j’utilise :

- [Cura](https://ultimaker.com/en/products/ultimaker-cura-software) comme slice principal, avec plugin OctoPrint pour l’imprimer directement sur OctoPrint ; à noter que j’ai utilisé un temps le plugin slicer directement sur Octoprint qui utilise cura, très pratique pour une utilisation basique, mais moins pratique à configurer et la version de cura utilisée est très ancienne
- [Fusion360](https://www.autodesk.com/products/fusion-360/overview) pour la modélisation 3D ; c’est un produit professionnel gratuit pour les makers amateurs (1 an renouvelable, j’espère pour longtemps ; enregistrement obligatoire, stockage cloud) ; plutôt facile à prendre en main et aux fonctions quand même avancées

J’envisage d’ajouter également à l’imprimante un réglage Z automatique, j’attends de recevoir [le capteur](https://fr.aliexpress.com/item/LJC18A3-H-Z-BX-Capacitive-proximity-switches-10MM/32252908795.html?spm=a2g0s.9042311.0.0.tSmo7k). J’ai également acheté des [kits d’extrusion](https://fr.aliexpress.com/item/MK8-Extruder-Hot-End-Kit-For-3D-Printer-Aluminum-Heating-Block-1-75mm-0-4mm-Nozzle/32831686681.html?spm=a2g0s.9042311.0.0.D4Ky3c) de rechange ce qui m’a déjà dépanné 2 fois.
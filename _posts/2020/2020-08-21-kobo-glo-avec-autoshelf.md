---
post_id: 4446
title: 'Kobo Glo avec AutoShelf'
date: '2020-08-21T12:25:33+02:00'
last_modified_at: '2020-08-21T12:25:33+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4446'
slug: kobo-glo-avec-autoshelf
permalink: /2020/08/kobo-glo-avec-autoshelf/
image: /files/2020/08/Kobo_Glo_withLogo3px.png
categories:
    - 'Avis Conso'
tags:
    - Kobo
    - epub
lang: fr
---

J’ai acheté il y a maintenant plus de 7 ans une liseuse Kobo Glo et j’en suis toujours aussi content : non seulement elle fonctionne parfaitement bien, a un format qui me convient, lit les epub et les pdf, avec 800Mo pour contenir pas mal de livres, extensible par microsd si on se sent à l’étroit. Mais en plus elle continue toujours de bénéficier des mises à jour de son système ce qui est assez remarquable comme support de la part de l’éditeur pour un produit de cette ancienneté. Deux petits regrets cependant : l’absence d’un bouton physique sur le coté pour tourner les pages en complément du tactile résistif qui est cependant un peu capricieux et le rétroéclairage LED qui est calibré trop fort. Même à 1% il est peu trop fort pour être utilisé dans l’obscurité, et à 100% il peut carrément servir de lampe de poche !

L’autre intérêt de la gamme Kobo est la présence de nombreuses extensions et customisations par la communauté. En effet le système est construit sur une base Linux et peut être facilement étendu. Voici sur mobileread.com une liste des principales extensions : https://www.mobileread.com/forums/showthread.php?t=295612

Parmi elles, j’ai découvert [AutoShelf](https://www.mobileread.com/forums/showthread.php?t=254554) qui permet de créer automatiquement des “étagères” ou “collections” à partir de la structure des répertoires. C’est très pratique car malheureusement Kobo ne dispose pas d’un explorateur de fichier, et la navigation par auteur ou par titre n’est pas la plus facile lorsque la bibliothèque grossit.

L’installation n’est pas très compliquée :

1. Il faut télécharger la dernière version de AutoShelf disponible sur la page du forum [mobileread.com](https://www.mobileread.com/forums/showthread.php?t=254554)
2. Connecter votre Kobo au PC, ouvrir l’archive et copier le fichier KoboRoot-AutoShelf-xxxxxxxx.tgz dans le répertoire .kobo de votre Kobo
3. Renommer le fichier KoboRoot-AutoShelf-xxxxxxxx.tgz en KoboRoot.tgz et déconnecter (proprement) votre Kobo du PC
4. L’extension devrait alors être installée automatiquement ; si ce n’est pas le cas, vous pouvez redémarrer votre Kobo

![](/files/2020/08/autoshelf-1.png){: .img-right}Cette extension s’active lorsque votre Kobo est branchée au PC. Pour l’utiliser, lorsque vous branchez votre Kobo au PC, vous allez voir sur l’écran le logo de AutoShelf s’afficher (voir image ci-contre). L’image peut s’afficher différemment suivant la liseuse. Par exemple sur Kobo Glo comme la définition est moins élevée que sur les liseuses récentes le logo prend une bonne moitié de l’écran. Pour activer, appuyer une fois sur le logo. Il devrait se mettre à clignoter lentement. Puis déconnecter (proprement) la Kobo du PC. Vous allez voir alors une étape de création des collections. Puis dans la rubrique “Vos Livres”, onglet “Collections”, seront maintenant présentes une collection par répertoire.

Quelques paramétrages sont possibles, expliqué sur [la page du forum](https://www.mobileread.com/forums/showthread.php?p=3184887#post3184887) mobilread.com, mais personnellement les réglages par défaut me conviennent parfaitement. Deux points importants :

- Quelques cas de corruption de la base de données ont été remontés, prévoir impérativement un backup de votre Kobo avant installation
- Pour désinstaller il faut ajouter un paramètre uninstall=1 au fichier de configuration
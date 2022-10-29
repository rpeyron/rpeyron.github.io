---
post_id: 2229
title: 'BkmToolbar &#8211; Bookmarks Netscape pour IE'
date: '2003-03-15T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2229'
slug: bkmtoolbar
permalink: /2003/03/bkmtoolbar/
URL_before_HTML_Import: 'http://www.lprp.fr/win/bkmtoolbar.php3'
image: /files/2018/11/netscape.png
categories:
    - Informatique
tags:
    - Bookmarks
    - Freeware
    - IE
    - OldWeb
    - Prog
lang: fr
lang-ref: pll_5bded0783e26f
lang-translations:
    en: bkmtoolbar_en
    fr: bkmtoolbar
---

[Télécharger les binaires (60ko)](/files/old-web/win/bkmtoolbar_release.zip)  
[Télécharger le source (72ko)](/files/old-web/win/bkmtoolbar_src.zip)

## Nouveautés

15/03/2003 : BkmToolbar fonctionne maintenant avec Netscape 6/7 / Mozilla, et opère correctement la conversion UTF8. Si vous utilisez une version plus ancienne de Netscape, vous pouvez désactiver cette option dans la boîte de dialogue.

## I) Qu’est-ce que c’est ?

BkmToolbar est une barre d’outil pour Microsoft Internet Explorer qui permet d’avoir les signets à la mode netscape.  
Pourquoi ? Premièrement, les signets à la mode Internet Explorer sont une horreur : je n’ai qu’environ 500 signets, et tous ces petits fichiers me prennent 30 Mo (à comparer aux 300ko du fichier des signets netscape).  
Ensuite tout simplement parceque je souhaite pouvoir utiliser mes signets sous Linux, avec Netscape.

![](/files/old-web/win/bkmtoolbar_scr.jpg)

## II) Utilisation

### 1/ Installation

Cliquer avec le bouton droit de la souris sur le fichier bookmark.inf et sélectionner Installer dans le menu contextuel. Cela devrait copier les fichiers nécessaires et modifier en conséquence la base de registre.  
Puis lancez / relancez Internet Explorer. Dans le sous-menu “Barres d’outils” du menu “Affichage” vous devriez voir apparaître maintenant une nouvelle barre nommée “Bookmarks”. Cliquez sur celle-ci. Vous devriez maintenant voir une nouvelle barre d’outils dans internet explorer, avec le logo Netscape.

Si cela ne marche pas, envoyez moi un mail (<remi+web@via.ecp.fr>) avec une description détaillée de ce que vous avez fait et de votre configuration (OS, versions,…), et j’essaierai à partir de cela de voir ce qui a bien pu ne pas marcher.

### 2/ Configuration

L’application est configurée par defaut pour utiliser le fichier standart de netscape. Mais utiliser cet endroit n’est pas toujours une bonne idée (voir la remarque importante ci-dessous). Cliquez donc sur le bouton, et sélectionnez le menu Configuration. Sélectionnez ensuite le fichier que vous souhaitez utiliser. Vous pouvez spécifier un fichier qui n’existe pas, celui ci sera automatique créé.  
Enfin, choisissez si vous voulez pouvoir modifier le fichier ou pas (mode lecture seule ou mode lecture/écriture).

## III) Note importante

 **!!! Utiliser IE and Netscape simultanément peut vous faire perdre des signets !!!**

(ceci est le cas avec n’importe quelle application de la suite netscape communicator et non pas seulement netscape navigator)

Il peut y avoir des problèmes lors de l’utilisation \_simultanée\_ de netscape et de cette barre d’outil en mode lecture/écriture. Par contre, il n’y aura aucun problème dans le mode lecture seule. Cela vient du fait que netscape lit le fichier de signets lors de son lancement, et écrit le fichier de temps en temps, en écrasant des modifications éventuelles qui auraient pu avoir lieu.

Vous devrez alors soit :

- exectuer la barre d’outil uniquement en mode lecture seule lorsque netscape est lancé.
- 1. copier votre fichier bookmark.htm en un fichier bookmark\_ie.htm
    2. utiliser la barre d’outil sur le fichier bookmark\_ie.htm en lecture écriture
    3. synchroniser de temps en temps les deux fichiers, avec des outils comme merge/diff : voir <http://winmerge.sourceforge.net> par exemple
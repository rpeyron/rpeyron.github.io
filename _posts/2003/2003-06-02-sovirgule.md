---
post_id: 2131
title: 'Une virgule sous StarOffice en français'
date: '2003-06-02T13:35:35+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2131'
slug: sovirgule
permalink: /2003/06/sovirgule/
URL_before_HTML_Import: 'http://www.lprp.fr/linux/sovirgule.php3'
image: /files/2018/11/virgule_1541283462.png
categories:
    - Informatique
tags:
    - Linux
    - OldWeb
    - Virgule
lang: fr
lang-ref: pll_5bde1f6ec54f1
lang-translations:
    en: sovirgule_en
    fr: sovirgule
---

## StarOffice en Français

Pour passer StarOffice en Français, rien de plus simple. Sous Windows, ceci se fait lors de l’installation windows. Sous Linux, il suffit d’exporter la variable **LANG** avec la valeur **fr\_FR**, pour définir les paramètres régionaux à ceux de la France. Ceci n’est pas propre à StarOffice, mais à une grande partie des applications Linux (Gnome, dselect,…)

bash, zsh : `export DISPLAY=fr_FR`  
tcsh : `setenv DISPLAY=fr_FR`

Le problème est qu’une fois en français, le séparateur décimal dans StarOffice est la virgule, mais celui de votre clavier numérique est le point. Ce n’est pas pratique. L’objectif est donc de remplacer le point du clavier numérique par une virgule, comme dans Excel en Français.

<a name="comma"></a>

## Virgule sous Linux

Une solution très simple est d’utiliser `xmodmap`.  
Faites un script pour lancer StarOffice qui contiendra:

```
xmodmap -e 'keycode 91 = KP_Delete comma'
~/StarOffice51/bin/soffice
xmodmap -e 'keycode 91 = KP_Delete KP_Decimal'
```

Cela dit à X de faire correspondre une virgule au séparateur décimal du pavé numérique.

Le seul problème de cette solution est que cette correspondance est faite pour toutes les applications X, pendant toute la durée de l’exécution de StarOffice.

Une solution astucieuse proposée par Denis Cardon est un petit script de basculement placé dans un lanceur ; cela permet de basculer facilement de la virgule au point, par un simple clic dans la barre des lancements ; il suffit de créer le script suivant, et de l’inclure dans un lanceur :

```
#!/bin/bash
val=`xmodmap -pke | grep "keycode  91 = KP_Delete KP_Decimal"`
echo $val
if [ -n "$val" ]
then
        xmodmap -e 'keycode 91 = KP_Delete comma'
else
        xmodmap -e 'keycode 91 = KP_Delete KP_Decimal'
fi

```

## Virgule sous Windows

[Nouvelle version !](/2004/06/ooovirg/)

J’ai écrit un programme permettant de changer le séparateur décimal du pavé numérique en une virgule, lorsque le titre de la fenêtre commence par StarOffice. Je suis en train de faire une interface un peu plus correcte.

En attendant, vous pouvez vous contenter de la version actuelle :

- [DLL](/files/old-web/linux/kdbhook.dll)
- [Chargeur de la DLL](/files/old-web/linux/loadkbdhook.exe)

Lorsque vous lancez StarOffice, lancez loadkbdhood.exe. Le tour est joué !
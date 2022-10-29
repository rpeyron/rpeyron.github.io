---
post_id: 2132
title: 'A comma under a French StarOffice'
date: '2003-06-02T13:35:35+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2132'
slug: sovirgule_en
permalink: /2003/06/sovirgule_en/
URL_before_HTML_Import: 'http://www.lprp.fr/linux/sovirgule_en.php3'
image: /files/2018/11/virgule_1541283462.png
categories:
    - Informatique
tags:
    - Comma
    - Linux
    - OldWeb
lang: en
lang-ref: pll_5bde1f6ec54f1
lang-translations:
    en: sovirgule_en
    fr: sovirgule
---

## StarOffice in French

You can very easily run StarOffice in French. Under Windows, it is done automatically during the installation process. Under Linux, you just have to export the **LANG** variable with **fr\_FR**, to define French locales. This is not specific to StarOffice, and affects a lot of Linux application (Gnome, dselect,..)

bash, zsh: `export DISPLAY=fr_FR`  
tcsh: `setenv DISPLAY=fr_FR`

But when in French, the separator in StarOffice is the comma, but on your keyboard you have a point. This is not very handy ! So we aim at replacing the point of the numpad by a comma, as it is done in Excel in French.



## Comma under Linux

A very simple solution is to use `xmodmap`.  
Write a little script to launch StarOffice with the following lines :

```
xmodmap -e 'keycode 91 = KP_Delete comma'
~/StarOffice51/bin/soffice
xmodmap -e 'keycode 91 = KP_Delete KP_Decimal'
```

This told to X to map the point of the numpad with the comma.

The only problem is that this mapping is done for all the applications running under X during the StarOffice session, and not only for StarOffice.

Another solution proposed by Denis Cardon consist in a small script that switches between comma and decimal point ; just create the script below, and embed it into a launcher ; a simple click will switch from dot to comma ! :

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

## Comma under Windows

[New version !](/2004/06/ooovirg_en/)

I have written a program to change the numpad point with a comma when the title of the window starts with “StarOffice”. I am currently improving the interface of this handler.

If you cannot wait, you can use the current version :

- [DLL](/files/old-web/linux/kdbhook.dll)
- [DLL Loader](/files/old-web/linux/loadkbdhook.exe)

Launch loadkbdhook.exe when you start StarOffice.
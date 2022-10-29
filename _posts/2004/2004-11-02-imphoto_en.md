---
post_id: 2181
title: IMPhoto
date: '2004-11-02T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2181'
slug: imphoto_en
permalink: /2004/11/imphoto_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/imphoto/imphoto_en.php3'
image: /files/old-web/soft/imphoto/imphoto_scr.jpg
categories:
    - Informatique
tags:
    - IMPhoto
    - OldWeb
    - Prog
    - RPhoto
lang: en
lang-ref: pll_5be0cb99cbea0
lang-translations:
    en: imphoto_en
    fr: imphoto
---

**New ! RPhoto has been released. RPhoto is an important evolution of the concept of IMPhoto. Check out [the RPhoto’s page](/rphoto-en/). The development of IMPhoto will be discontinued.**

# IMPhoto

[Download the binairies.](/files/old-web/soft/imphoto/imphoto.exe)  
You must have [ImageMagick](http://www.imagemagick.org) installed : [Download ImageMagick 5.5.4-Q8-win32.](ftp://ftp.imagemagick.org/pub/ImageMagick/)  
[Download source code.](/files/old-web/soft/imphoto/imphoto_src.zip)

## What is it ?

This small piece of software aims at simplify the life of those who wish to turn / crop photos very quickly, and keeping the precious ratio width / height, to print without blank bands.

This software is totally based on IMDisplay, a sample application distributed with ImageMagick, a fabulous image library.

## How to use it ?

This software has been designed to be used following this scheme :

1. Open several files to edit (File / Open)
2. Probably rotate these files (left = key ‘l’, right = ‘r’)
3. Crop the image, with selecting the appropriate zone, and typing the key ‘a’ (or Transform / Crop)
4. Save the file (key ‘s’) (replace the existing file)
5. Close the file (key ‘q’), and then you go with the next !

As you can see, this software has been optimized for a quick and efficient keyboard use. But you can also use the toolbar buttons, or menu commands.

This program rely heavily on the superb tools [ImageMagick](http://www.imagemagick.org). You can therefore use all the image format your ImageMagick installation supports.

## How to setup ?

The parameters related to the ratio are logically located in the ‘Ratio’ menu.

- Format options : 
    - 4/3 : This is the most common numeric photo format (800×600, 1024×780,…), and certainly the one you will use (it is the default). Note that you must use a 11×15 paper (and not 10×15) to print the photo without blank borders.
    - 2/3 : This is the classical photo format, adapted to 10×15 papers.
    - 1/1 : Well square photos, not very common nowadays…
    - Custom… : You can enter a custom ratio. Note that the ratio must be entered as ‘1.3333’ and not ‘4/3’.
- Orientation options : 
    - Allow Flip : This mode allows the selection of the more appropriate orientation according to your current selection.
    - Landscape : Force the landscape mode.
    - Portrait : Force the selection to be in portrait mode.
- Fit On Window : This option resize the image so it will be displayed fully in the window. The display is often ugly, because of Windows’s stuff, but your original image remains untouched, and all the operations (Crop / Rotate / …) will be applied to the original image in high quality (contrary to other software, as the excellent IrfanView). You can uncheck this option to view the image always in high definition, but the selection will be very difficult…
- Maintain Ratio : Uncheck this option not to maintain any more the ratio. As it is the only advantage of this piece of software, this should never be unchecked.

## What does it look like ?

![IMPhoto](/files/old-web/soft/imphoto/imphoto_scr.jpg)
---
post_id: 2189
title: 'iBeadConfig2 : Set radios easily on the iBead'
date: '2004-01-25T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2189'
slug: ibeadcfg_en
permalink: /2004/01/ibeadcfg_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/misc/ibeadcfg/ibeadcfg_en.php3'
image: /files/old-web/soft/misc/ibeadcfg/ibeadconfig2_scr.jpg
categories:
    - Informatique
tags:
    - Freeware
    - OldWeb
    - iBead
lang: en
lang-ref: pll_5be1e9f3dda79
lang-translations:
    en: ibeadcfg_en
    fr: ibeadcfg
---

[Download setup](/files/old-web/soft/misc/ibeadcfg/ibeadconfig2_setup.exe) (600ko, or [zip file](/files/old-web/soft/misc/ibeadcfg/ibeadconfig2_bin.zip), 265ko)  
[Download sources](/files/old-web/soft/misc/ibeadcfg/ibeadconfig2_src.zip) (GPL code, use wxWindows, so should work on Linux)

![Capture d'écran](/files/old-web/soft/misc/ibeadcfg/ibeadconfig2_scr.jpg){: .img-right}

## Use

Should be very easy to use :

- Install / Launch the program
- Open settings.dat file
- Selection the good firmware version
- Select your location
- Select or enter the stations
- Save the file

Easy ! To transfer the list of stations from one settings.dat to another, use the preferences menu : Preferences / Save, open the destination settings.dat, Preferences / Load and your saved stations will replaced the ones contained in the destination settings.dat.

## Advanced use

iBeadConfig2 can be adapted through configuration files (much easier than though patches !)

**radios.ini** contains the lists of locations and radios. You will have no pain to edit this file.

**firmwares.ini** contains information about firmwares.

To add a new firmware, copy a section and edit the fields :

- num : number of radios (32 supported)
- position : position of the first radio in the file (decimal notation)
- increment : number of bytes to add to go o the next station (often 6)
- numbytes : number of bytes used (often 3)
- order : bytes order (often ‘little’)
- offset : frequency to add (often 0)
- multiply : multiplicator (often 1000)
- size : size of settings.dat file, for further implementation of auto-detection if possible

Formula is : `fréquence = order(lecture(position + i * increment, numbytes) ) / multiply + offset`

## Version 2

Why this new version ?

- This version should cause less deployment problems : no more .Net stuff, use wxWindows,…
- Unlike superb extensive softwares like iBeadUltime, this utility focuses on the simple task of configuring radios, but with may firmwares (especially the last french official firmware, not supported by iBeadUltime). Adding support for a firmware should be a kid’s game.
- OpenSource and Cross-platform design.

## By the way, what is iBead?

![iBead](/files/old-web/soft/misc/ibeadcfg/ibead-2-1.jpg){: .img-right}  
Look at that, isn’t it beautifull?

Features :

- Play MP3/WMA
- Radio FM
- USB Storage
- FM/Voice Recorder

## Links / Credits:

- [IBead Ultimate](http://ldeletang.free.fr/IBEAD/) probably the best ibead software I’ve seen sofar. (FW 3.0xx and 3.1xx, all known options)
- [iBeadResEdit](http://mapage.noos.fr/ibead/) : A resource editor for the iBead firmware. Modify texts, images,…
- Thanks to Jason Bingham for his precision on Technical Information, and for [his own software](/files/old-web/soft/misc/ibeadcfg/ifmed.zip) (ver 1.105 compat FW 3.1xx &amp; 3.0xx).
- [http://ibead.online.fr](http://ibead.online.fr/) : unofficial french iBead page, with an interesting forum and downloads.
- [Another radio preset software](http://perso.wanadoo.fr/9minutes/PakEXE.zip), by specimen (of ibead forums), which is now pretty good.

- - - - - -

# Previous version – iBead Configurator (Unofficial)

[Download the iBead Configurator](/files/old-web/soft/misc/ibeadcfg/ibeadconfig.exe) **(Warning : need the [.Net Framework](http://msdn.microsoft.com/netframework/downloads/howtoget.asp))**  
[Download sources *(C#, Visual Studio .Net)*](/files/old-web/soft/misc/ibeadcfg/ibead_src.zip)  
Successfully tested with iBead 100 firmware 3.0.61. (It is likely that this program won’t work with other firmwares.)

## News

Because of the fabulous lionel68’s creation, iBead Ultimate (<http://ldeletang.free.fr/IBEAD/iBead.htm>), this program will probably no more be supported. Thanks to him for this great software.

But for the FW3.141, you can modify the source code of my program as described by Milan, in this [patch](/files/old-web/soft/misc/ibeadcfg/ibeadcfg_patch3141.txt). Thanks to him too.

A port to iBead2 has been done : <http://membres.lycos.fr/tmp2074/iBead2/Start.html> (local files : [binary](/files/old-web/soft/misc/ibeadcfg/ibead2cfg.zip), [source](/files/old-web/soft/misc/ibeadcfg/ibead2cfg_src.zip))

## Why?

Set the 15 FM preset is long and not very handy on the iBead. But the SETTINGS.DAT file of the iBead contains that data. Therefore, it is possible to sets those radios on your PC.

## How?

You just have to :

- Get the SETTINGS.DAT file on your iBead (it is a hidden, system and read-only file, so you have to check that your explorer can display it : Tools / Folder Options)
- Launch the program
- Open SETTINGS.DAT
- Go to the Radios’ tab, and modify the frequancies
- Save the file back to the iBead

Ok, it is ready !

![capture d'ecran](/files/old-web/soft/misc/ibeadcfg/ibeadcfg_scr.png)

## And then ?

### Technical materials

Informations are stored in three bytes stored in reverse order, each 6 bytes, starting at 0x66. (0x78 for 3.1xx Firmwares)

The formula is simple : `code = frequence * 1000`.

By example, if from offset 0x66 contains B4 A4 01 then it can be decoded :  
`(B4 + A4 * 2^8 + 01 * 2^16) / 1000 = 107.7` (Note : Decoding the frequency on three bytes explain the -65536 in my first formula, which was using only the two first bytes. Thanks to Jason Bingham for the explanation).

### Other options

This soft contains only radios preset, but the concept can be genealized to each options, provided you have the correct  
SETTINGS.DAT file format. You can do that by making one change, and see the corresponding differences in the settings.dat file. This is a tedious work, and a bit less usefull for other options than radios preset…

More complete technical information are available from the softs iBead Ultime, iBeadResEdit, and PakEXE (see in the links section below).
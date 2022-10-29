---
post_id: 2234
title: 'OOVirg &#8211; A Comma with OpenOffice.org'
date: '2004-06-21T18:24:01+02:00'
last_modified_at: '2018-12-01T20:22:14+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2234'
slug: ooovirg_en
permalink: /2004/06/ooovirg_en/
URL_before_HTML_Import: 'http://www.lprp.fr/win/ooovirg/ooovirg_en.php3'
image: /files/2018/11/virgule_1541283462.png
categories:
    - Informatique
tags:
    - Comma
    - OldWeb
lang: en
lang-ref: pll_5bde2377094b0
lang-translations:
    en: ooovirg_en
    fr: ooovirg
---

[Download ! *(sources included)*](/files/old-web/win/ooovirg/ooovirg_tray.zip)*(If needed, supplementary DLLs : [here](/files/old-web/win/ooovirg/dllsrelease.zip), and older version [here](/files/old-web/win/ooovirg/ooovirg_tray_030621.zip))* Windows 95 users only : [Download the special Win95 version](/files/old-web/win/ooovirg/ooovirg_tray_win95.zip) (If needed, [MFC42’s DLL win95 version](/files/old-web/win/ooovirg/mfc42_win95.zip).

Possible solutions are :  
[Set up OpenOffice.org to use a point as decimal separator instead.](#param)  
[OOoVirg, a tool that will replace the dot by a comma only when using OpenOffice.org](#ooovirg)  
[Change permanently the decimal point by a comma in the registry.](#registry)  
[Create a new keyboard with a comma with the Microsoft Keyboard Creator.](#mskc)

For Linux, or for an older version, please see [this page](/2003/06/sovirgule_en/).

## Latests news

### 04/12/2004

I have received a feature request about the comma be replaced in dialogs. I have found a solution, which is in testing state. To help me to test, just download the [oovirghk.dll](/files/old-web/win/ooovirg/oovirghk.dll) file, replace your current version by it, and restart OOoVirg. Please let me known in case of problems.

### 25/04/2004

- Problems have been reported with the exe name’s filter : conflicts with Win95 systems, and does not work with NT systems. It has been removed.
- Internationalization : the UI should have a default english langage on non french systems (should, because I have not been able to test it :-). Strings are now easy to translate, only the resources file has to be modified.
- Improved the iconisation system.

### 07/03/2004

New version of [OOoVirg](/files/old-web/win/ooovirg/ooovirg_tray.zip), that solves :

- Conflicts with software using other keyboard hooks (iTouch de Logitech, Autocad,…)
- Traybar icon too similar with the one of the Quick Launch of OpenOffice.org (Thanks to Frédéric Vuillod)
- A Win95 problem (DLL not found), caused by the long name of the DLL.

### 21/06/2003

OOoVirg is now under L-GPL license. It can now be directly integrated in OpenOffice.org. To contribute to this integration, or to have more information, please consult the issue 1820, IssueZilla on www.OpenOffice.org.

The package proposed to the OOo team is : [ooovirg\_integration.zip](/files/old-web/win/ooovirg/ooovirg_integration.zip). It contains some remarks, a better solution for Windows, and a xmodmap solution for Linux.

**So this piece of software should be soon obsolete.**

## OpenOffice.org and the decimal separator

In some languages (as french by instance), the decimal separator is a comma, but there is a point on the numpad. That is not very handy, as you cannot type a decimal number with the numpad. The goal of OOoVirg is to solve this issue, by replacing the point of the numpad by a comma, as Excel does.

<a name="param"></a>

## First solution : ask OpenOffice.org to use a point as decimal separator

This is described in the french FAQ ([http://fr.openoffice.org/FAQ/calc\_fr/c25fr.html](http://fr.openoffice.org/FAQ/calc_fr/c25fr.html)). Just choose the option “English” in the options `Format / Cellules / Nombres.<br></br>`

<a name="ooovirg"></a>

## Second solution : a small utility OOoVirg.

If you prefer to keep a comma as decimal separator, I wrote a small tool that will replace the numpad point by a comma, only in OpenOffice.org applications. Other applications will remain unaffected.

[Download the latest version!](/files/old-web/win/ooovirg/ooovirg_tray.zip)  
You may need these extra DLL : [redistributables DLLs Microsoft VC](/files/old-web/win/ooovirg/dllsrelease.zip).

[Debug version](/files/old-web/win/ooovirg/ooovirg_tray_dbg.zip) (if you encounter some problems)  
Please download theses debug DLL : [Debug redistributables DLLs Microsoft](/files/old-web/win/ooovirg/dllsdebug.zip).

### Installation

This program appears in the TrayBar, next to the clock : you will find the OpenOffice.org logo with a comma.

This program must be relaunched each time Windows reboots. I suggest you to put it in your Programs/Startup in the Start menu. Just drag and drop the executable in the menu.

### Configuration

The default configuration should be ok for 1.0.x and 1.1.x versions of OpenOffice.org. You can adapt it for other versions, or for StarOffice (versions 5 or 6) by double-clicking on the TrayIcon, modifying the configuration in the dialog, saving and relaunching the application.

The program has not been translated yet, so please find the meaning of the options below.

Methods to select if the numpad point should be replaced :

- “Actif sur toutes les fenêtres” (All) : all windows are affected.
- “Actif sur les fenetres ayant dans leur titre” (Title) : if this option is checked, the windows title must contain the provided text.
- “Actif sur les fenetres ayant dans le nom de classe” (ClassName) : if this option is checked, the class name of the window must contain the provided text.
- “Actif sur les fenetres de l’éxécutable” (Executable) : if this option is checked, the numpad point will be replaced only if the windows belongs to the provided executable name (Does not always works.)

If you combine several options (excluded the first one), the windows must satisfy all of them.

### Screenshot

![](/files/old-web/win/ooovirg/ooovirg_scr.jpg)

### Licence

This software is free, and distributed under L-GPL licence. You can modify and improve it regarding your needs, as long as you respect the L-GPL licence.

More information : [remi+ooovirg@via.ecp.fr](mailto:remi+ooovirg@via.ecp.fr?subject=OpenOfficeHook).

### Support / FAQ

This program has been sucessfully used on Windows 2000 / XP, Windows 95 / 98SE / ME. But if you encounter a problem check the FAQ below :

#### Windows says “File not found : OOVirgHook.dll”

Copy this file (distributed in the zip package) in `C:WindowsSystem32`.

#### The program does not appear to function.

Go in the configuration panel, check the “Actif sur toutes les fenetres” item, and restart the program.

<a name="registry"></a>

## Another solution

With Windows 2000/XP, you can permanently change the behaviour of a key (regardless the application). I do not use this method, as this is not very handy, but if you are intersted, please go on [this page](/2004/11/trucs_en/) where the principle is explained. Michel Bigle has done this for you, and [here is mapcomma.reg](/files/old-web/win/ooovirg/mapcomma.reg), a simple registry file to map permanently the decimal separator of the numpad to a comma.

<a name="mskc"></a>

## Another good solution for Windows 2000 or higher.

A free [Microsoft Keyboard Layout Creator](http://www.microsoft.com/globaldev/tools/msklc.mspx) is available from Microsoft, for Windows 2000 / XP / 2003. It allows you to create an installable custom keyboard. [Here](http://forum.hardware.fr/hardwarefr/WindowsSoftwareReseaux/sujet-180317-1.htm) is some help.

Here is an example made by Michel Bigle : [mskc\_decimal.zip](/files/old-web/win/ooovirg/mskc_decimal.zip) will map the numpad decimal separator to a comma. What is very nice with this method is the facility to switch from a keyboard to another, as it is completly integrated in the Windows Keyboard management :

![Windows Keyboard Management](/files/old-web/win/ooovirg/clavier_windows.jpg)

As you can see, you just have to click on the keyboard you want (Custom : with a comma, and France : with a decimal point)

## Older versions of this software

KbdHook for StarOffice 5.2 :

- [DLL](/files/old-web/win/ooovirg/kdbhook.dll)
- [DLL Loader](/files/old-web/win/ooovirg/loadkbdhook.exe)

Launch loadkbdhood.exe.
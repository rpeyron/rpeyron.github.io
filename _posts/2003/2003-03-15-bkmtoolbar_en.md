---
post_id: 2230
title: 'BkmToolBar &#8211; Share Bookmarks between Netscape and IE'
date: '2003-03-15T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2230'
slug: bkmtoolbar_en
permalink: /2003/03/bkmtoolbar_en/
URL_before_HTML_Import: 'http://www.lprp.fr/win/bkmtoolbar_en.php3'
image: /files/2018/11/netscape.png
categories:
    - Informatique
tags:
    - Bookmarks
    - OldWeb
    - Software
lang: en
lang-ref: pll_5bded0783e26f
lang-translations:
    en: bkmtoolbar_en
    fr: bkmtoolbar
---

[Get the binaries (60ko)](/files/old-web/win/bkmtoolbar_release.zip)  
[Get source code (72ko)](/files/old-web/win/bkmtoolbar_src.zip)

## News

15/03/2003 : BkmToolbar has been updated to be used with Netscape 6/7 / Mozilla (UTF-8 conversion). If you are a user of Netscape 4.7, you can disable this conversion in the options.

## I) What is BkmToolbar ?

BkmToolbar is a toolbar for Microsoft Internet Explorer that intends to handle the netscape bookmarks file.  
But why ? First of all, the bookmark management of IE is rubbish : I have something like 500 bookmarks and all these littles files are taking 30Mo of used space on my hard drive (compared with 300ko with the netscape file) with all these cluster things ! Second thing is that I want to keep the compatibility with Netscape to keep on using my bookmarks on Linux.

![](/files/old-web/win/bkmtoolbar_scr.jpg)

## II) How to use ?

### 1/ Install

Simply right-click on the file bookmark.inf and click Install. This should copy the appropriate files in the right place, and do the accurate manipulation in the registry.  
Then launch/re-launch Internet Explorer, and in the View menu, submenu Toolbars, you should see a new entry named Bookmarks. Click, and that is it ! You should now see a new toolbar, with the Netscape logo and the title Bookmarks.

If it does not work, send me an email (<remi+web@via.ecp.fr>) with an accurate description of your configuration (OS, version,…), and I will try to figure out why it did not work.

### 2/ Configure

The toolbar is configured to use the default location of the netscape file. But use this place is not a very good idea (see important note below). So click on the drop down, and select the menu “Configuration”. Then select the file you want to use. You can select a file that does not exists, and the application will create a new one. And last thing, choose if you want to be able to modify the file, or if you just want to use it read only.

## III) Important note

 **!!! Using IE and Netscape simultaneously can loose some bookmarks !!!**  
(this is the case with all the netscape application belonging to the netscape communicator suite, not only netscape navigator)

There can be problems if you are using \_simultaneously\_ netscape and this toolbar (in write mode), because netscape had the bad habit to read the bookmarks file when it is launched, and to write it later sometimes, but not each time a bookmark was added.

So you should consider either :

- running the toolbar always in readonly mode when netscape is running.
- 1. duplicate your bookmark.htm file into a bookmark\_ie.htm file
    2. run netscape and the toolbar in read/write mode on the bookmark\_ie.htm file.
    3. sometimes synchronize the two files by running diff/merge tools : see winmerge.sourceforge.net for instance.

Hope this toolbar helps.
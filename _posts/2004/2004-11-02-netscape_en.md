---
post_id: 2134
title: 'Share Netscape between Linux and Windows'
date: '2004-11-02T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2134'
slug: netscape_en
permalink: /2004/11/netscape_en/
URL_before_HTML_Import: 'http://www.lprp.fr/linux/win/netscape_en.php3'
image: /files/2018/11/netscape.png
categories:
    - Informatique
tags:
    - Linux
    - OldWeb
lang: en
lang-ref: pll_5bdecdb2a43d0
lang-translations:
    fr: netscape
    en: netscape_en
---

**Warning**, information here are for the 4.75 version of Netscape. Files could slightly differs from one version to another.

# Introduction

You should, after the reading of the page relative to windows cohabitation, have installed your Netscape user directory on the data partition. You can choose this location during the first launch of Netscape under Windows, when creating a new user profile.  
We will store all data here, and link the ~user/.nestcape directory under Linux to this location on the FAT16 partition. You will so be able to access your mail, bookmarks and address book under Linux or Windows without problems.

# Have the same bookmarks

You just have to edit the file *~user/.netscape/preferences.js* and modify the line **user\_pref(“browser.bookmark\_file”, “\[path to the data partition\]/bookmark.htm”);**

If, like me, you prefer Internet Explorer, please see my page about the [BkmToolbar](/2003/03/bkmtoolbar_en/)

# Have the same address book

You just have to delete the **~user/.netscape/pab.na2** file, and to link this file with the one on your data partition. In your Linux ~user/.netscape directory, type :  
`ln -s [path to the Netscape Home directory on you data partition]/pab.na2 pab.na2`

# Have the same filter rules

You just have to delete the **~user/.netscape/mailrule** file, and to link this file with the one on your data partition. In your Linux ~user/.netscape directory, type :  
`ln -s [path to the Nescape Home directory on your data partition]/mailrule mailrule`

# Have the same mailbox

You have two different means to do that :

- Enter the data partition path in Edit-&gt;Preferences-&gt;Mail-&gt;Mail Servers-&gt;Local MailDirectory
- Link each directory.

I made a little [script](/files/old-web/linux/win/updatemail) that implements the second method and update all the directories of your mailbox on the Linux partition (your mailbox is not modified). Just modify the vars `DEFSOURCE` and `DEFTARGET` in the script, and execute it : `./updatemail` (after having typed chmod +x updatemail)
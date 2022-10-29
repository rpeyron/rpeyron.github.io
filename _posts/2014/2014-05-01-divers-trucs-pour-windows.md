---
post_id: 1380
title: 'Autoriser les connexions à \localhost sous WinXP'
date: '2014-05-01T20:15:00+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/2014/05/divers-trucs-pour-windows/'
slug: divers-trucs-pour-windows
permalink: /2014/05/divers-trucs-pour-windows/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
post_slider_check_key: '0'
image: /files/2017/10/web_server_1507996534.jpg
categories:
    - Informatique
tags:
    - Blog
lang: fr
---

Windows n’autorise pas par défaut sur Windows XP l’accès SMB à \\localhost . Cela peut être contourné en ajoutant l’alias localhost au LanManServer : ajouter une entrée `Reg_multi_sz` nommée `“OptionalNames”` dans `“HLKMSystemCurrentControlSetServicesLanManServerParameters”` avec la valeur `“localhost”`, puis rebooter.

Référence : [http://blog.uvm.edu/jgm/2011/11/08/file-server-aliases/](http://blog.uvm.edu/jgm/2011/11/08/file-server-aliases/ "http://blog.uvm.edu/jgm/2011/11/08/file-server-aliases/")
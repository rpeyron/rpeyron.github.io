---
title: Site Documentation
---

# Links
Soit : 
{{ '/2023/...' | relative_url }}

Soit:
{% link _posts/2019/2019-01-02-offline-extraction-of-a-wordpress-site.md %}

# Styles

Some styles available on this site
    
```
{: }
```
 
.mw60
.mx80

.img-center

.center
.img-right 
.img-left 
.div-center
.img-center
.mw80 
.mw60 
.mw40
.mw20 

.clear-float

.font-large 
.font-xlarge 

.base-button 
.download-button 
.green-button 
.red-button 
.blue-button 

.float-right 
.photos-album 
.photos-albums
.feature-icon 
.img-col-2 
.img-col-2 div 

.notice-note 
.frame-red 

# Front Matter

## Standard

title: 'Titre'
date: '2022-02-27T22:10:40+01:00'
last_modified_at: '2022-02-27T23:03:52+01:00'
author: 'Rémi Peyronnet'
slug: the-slug
layout: post
categories:  <list>
tags:  <list>
image: /files/ophtalmologue-lunettes-correctrice-stockpack-adobe-stock.jpg
permalink: /2022/02/lire-les-corrections-de-lunettes/


## Custom

csp: 'frame-src: rpeyron.github.io' (add to csp)
toc: false (default: true for posts)

lang: fr
lang-ref: pll_5be1e9f3dda79
lang-translations:
    en: ibeadcfg_en
    fr: ibeadcfg

modules:
    - jquery
    - gallery
    - bootstrap
    - owl-carousel
    
google-fonts:
    - Caveat



## Migration

post_id: identifier of WordPress post for migrated post
guid: '/?p=5679'
URL_before_HTML_Import: 'http://www.lprp.fr/soft/misc/ibeadcfg/ibeadcfg.php3'

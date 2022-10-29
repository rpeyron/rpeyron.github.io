---
post_id: 3560
title: Logiciels
date: '2018-11-17T00:39:59+01:00'

author: admin
layout: page
slug: logiciels
permalink: /logiciels/
lang: fr
lang-ref: pll_5bef5579a398c
lang-translations:
    en: softwares
    fr: logiciels
toc: true
---


Les logiciels principaux et encore maintenus:

- [RPhoto](/rphoto/) (et son composant wxRectTracker pour wxWidgets)
- [xmlTreeNav](/xmltreenav/) (et sa bibliothèque [libxmldiff](/libxmldiff/))
- les plugins [GIMP fourier](/gimp_plugin/) et Dokuwiki [button](/dokuwikibutton/)

&nbsp;


# Le reste de la collection

<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Freeware'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>


&nbsp;

# Autres articles sur la programmation


<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Prog'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>

&nbsp;

# Programmation Casio et TI

<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Casio' or item.tags contains 'TI'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>

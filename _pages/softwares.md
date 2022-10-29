---
post_id: 3562
title: Softwares
date: '2018-11-17T00:40:41+01:00'

author: admin
layout: page
guid: '/?page_id=3562'
slug: softwares
permalink: /softwares/
lang: en
lang-ref: pll_5bef5579a398c
lang-translations:
    en: softwares
    fr: logiciels
toc: true
---

Main supported softwares:

- [RPhoto](/rphoto/) (and the wxRectTracker component for wxWidgets)
- [xmlTreeNav](/xmltreenav/) (and the library [libxmldiff](/libxmldiff/))
- [GIMP plugins](/gimp_plugin/) and Dokuwiki [button plugin](/dokuwikibutton/)

&nbsp;


# Other softwares

<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Freeware'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>


&nbsp;

# Other posts about programming


<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Prog'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>

&nbsp;

# Casio and TI programming

<section class="cards cards-horizontal">
{% assign display_posts = site.posts | where_exp: "item", "item.tags contains 'Casio' or item.tags contains 'TI'" %}
{% for post in display_posts %}
{% include main-loop-card.html %}
{% endfor %}
</section>


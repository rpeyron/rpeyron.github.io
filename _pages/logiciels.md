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

# Principaux logiciels

Les logiciels principaux et maintenus:

- [RPhoto](/rphoto/) (et son composant wxRectTracker pour wxWidgets)
- [xmlTreeNav](/xmltreenav/) (et sa bibliothèque [libxmldiff](/libxmldiff/))
- les plugins [GIMP fourier](/gimp_plugin/) et Dokuwiki [button](/dokuwikibutton/)

&nbsp;

# Les autres logiciels sur GitHub

Dépôts GitHub maintenus :
- [encfs-tree-browser](https://github.com/rpeyron/encfs-tree-browser) — Explorateur d'archive EncFS sans montage (2026)
- [encfs-names-ts](https://github.com/rpeyron/encfs-names-ts) — Bibliothèque TypeScript d'encodage/décodage noms EncFS (2026)
- [ha-dbusage](https://github.com/rpeyron/ha-dbusage) — Optimisation base de données Home Assistant (2026)
- [homeassistant_umami](https://github.com/rpeyron/homeassistant_umami) — Intégration analytics Umami pour Home Assistant (2026)
- [scrap2api](https://github.com/rpeyron/scrap2api) — API de scraping depuis Excel/LibreOffice (2019)
- [verres](https://github.com/rpeyron/verres) — Calculette corrections lunettes (2022)
- [blelt2mqtt](https://github.com/rpeyron/blelt2mqtt) — Capteur Bluetooth LE température → MQTT (2022)
- [rc2magichome](https://github.com/rpeyron/rc2magichome) — Automatisation RF433 pour contrôleurs MagicHome (2024)
- [slides-capture](https://github.com/rpeyron/slides-capture) — Capture diaporamas Canva partagés (2024)
- [bleparser](https://github.com/rpeyron/bleparser) — Parser Bluetooth LE

Anciens projets GitHub non maintenus :
- [dropbox-comments-downloader](https://github.com/rpeyron/dropbox-comments-downloader) — Téléchargement commentaires Dropbox Paper (2019)


Forks GitHub d'autres projets avec modifications:
- [wordpress-to-jekyll-exporter](https://github.com/rpeyron/wordpress-to-jekyll-exporter) — Export WordPress vers Jekyll avec commentaires (2022)
- [wordpress-language-mix](https://github.com/rpeyron/wordpress-language-mix) — Plugin WordPress multilingue (2022)
- [xiaomi_mi_scale](https://github.com/rpeyron/xiaomi_mi_scale) — Fork Xiaomi Mi Scale pour Python <3.6 (2021)
- [miniweb](https://github.com/rpeyron/miniweb) — Serveur web minimal avec support SVG (2022)
- [jekyll-admin](https://github.com/rpeyron/jekyll-admin) — Fork Jekyll Admin avec raccourcis (2023)
- [HTML-Import-2](https://github.com/rpeyron/HTML-Import-2) — Polyfill HTML Imports (fork)
- [domoticz](https://github.com/rpeyron/domoticz) — Fork Domoticz avec bidouilles


&nbsp;


# Articles sur les logiciels de ce blog

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

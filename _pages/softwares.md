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

# Main softwares

Main supported softwares:

- [RPhoto](/rphoto/) (and the wxRectTracker component for wxWidgets)
- [xmlTreeNav](/xmltreenav/) (and the library [libxmldiff](/libxmldiff/))
- [GIMP plugins](/gimp_plugin/) and Dokuwiki [button plugin](/dokuwikibutton/)


# Other softwares on GitHub

Supported GitHub repositories:
- [encfs-tree-browser](https://github.com/rpeyron/encfs-tree-browser) — EncFS archive browser without mounting (2026)
- [encfs-names-ts](https://github.com/rpeyron/encfs-names-ts) — TypeScript library for EncFS name encoding/decoding (2026)
- [ha-dbusage](https://github.com/rpeyron/ha-dbusage) — Home Assistant database optimization (2026)
- [homeassistant_umami](https://github.com/rpeyron/homeassistant_umami) — Umami analytics integration for Home Assistant (2026)
- [scrap2api](https://github.com/rpeyron/scrap2api) — Scraping API from Excel/LibreOffice (2019)
- [verres](https://github.com/rpeyron/verres) — Glasses prescription calculator (2022)
- [blelt2mqtt](https://github.com/rpeyron/blelt2mqtt) — BLE temperature sensor → MQTT (2022)
- [rc2magichome](https://github.com/rpeyron/rc2magichome) — RF433 automation for MagicHome controllers (2024)
- [slides-capture](https://github.com/rpeyron/slides-capture) — Capture shared Canva slides (2024)
- [bleparser](https://github.com/rpeyron/bleparser) — Bluetooth LE parser

Older GitHub unmaintained projects:
- [dropbox-comments-downloader](https://github.com/rpeyron/dropbox-comments-downloader) — Dropbox Paper comments downloader (2019)


GitHub Forks of other projects with modifications:
- [wordpress-to-jekyll-exporter](https://github.com/rpeyron/wordpress-to-jekyll-exporter) — WordPress to Jekyll exporter with comments (2022)
- [wordpress-language-mix](https://github.com/rpeyron/wordpress-language-mix) — Multilingual WordPress plugin (2022)
- [xiaomi_mi_scale](https://github.com/rpeyron/xiaomi_mi_scale) — Xiaomi Mi Scale fork for Python <3.6 (2021)
- [miniweb](https://github.com/rpeyron/miniweb) — Minimal web server with SVG support (2022)
- [jekyll-admin](https://github.com/rpeyron/jekyll-admin) — Jekyll Admin fork with shortcuts (2023)
- [HTML-Import-2](https://github.com/rpeyron/HTML-Import-2) — HTML Imports polyfill (fork)
- [domoticz](https://github.com/rpeyron/domoticz) — Domoticz fork with tweaks


&nbsp;


# Software posts on this blog
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


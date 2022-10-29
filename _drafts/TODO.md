---
post_id: 3718
title: TODO
layout: page
lang: fr
---

# Migration Jekyll 2022

## Site Layout

- PWA
- Local Comments & direct GitHub discussions links
- Local Gallery (if folder present)

- Language support 
  - Client-side translation with localStorage
  - Filter only language option
- Optimization with ruby plugins for:
  - categories & tags : site.posts | count_by: 'tags'
  - archive tree : site.posts | tree_by_date
- Remove inline scripts (and add unsafe-inline-javascript: true  in header for pages like search, compteur,...)

- Post processing to add index.html to links for local use? / local serve


## Pages

- Recreate original design of RPhoto, xmlTreeNav and libxmldiff
- Echecs - Analyse rétrograde


## Jekyll-Admin

- Links configurable from config.jekyll_admin.admin_links (in https://github.com/jekyll/jekyll-admin/blob/master/src/containers/Header.js)
- Frames in sidebar (for analytics for instance) ; config.jekyll_admin.sidebar_frames (in https://github.com/jekyll/jekyll-admin/blob/master/src/containers/Sidebar.js + new component)
- Allow save after create
- Plugin to search & load images from the web ?
- Merge all configuration files (for draft mode) or force show-drafts in config.jekyll_admin.force_drafts (in https://github.com/jekyll/jekyll-admin/blob/master/src/containers/Sidebar.js)

## Done

### Site Layout

- Favicon
- Image responsive size support
- Gallery support in pages
- Language support
  - Client-side translation (without cookies)
  - Google Translate for untranslated pages
  - Prev/Next if same language
- Better related posts
- Google Photo gallery
- Comments
- Make relative links compatible for whole site (replace links with { % link % } or override kramdown link processing with custom plugin -> custom plugin blindly replacing ](/ ))
- Optimization with ruby plugins for:
  - related posts : site.posts | related_posts: post
- _config_dev.yml override for development mode: disabled archive generation
- Analytics
- Reading time
- Redirects  (plugin en :post_write _data/redirection.yml -> redirect_template.html ; finally done: javascript parsing htaccess)
- Dark mode theme
- Print CSS

### Pages

- RPhoto
- libxmldiff
- Plugins
- XmlTreeNav
- RX100 : replace by local images

- All Posts


### Jekyll Export

- Fixed content mix
- Ignore :
    - ocean_
    - classic-editor-remember
    - osh_disable_topbar_sticky
    - osh_disable_header_sticky
    - osh_sticky_header_style
    - ampforwp-amp-on-off
- Generate permalink for pages
- Generate lang 
- Extract pre lang> and last_modified_at
- Replace translated tag and category by only one


# Migration WordPress 2018

A Faire :

- Verifier/moderniser tous les autres services web
- Galerie via fichiers
- Rattrapage de projets anciens
- Portage en application html5 : de mots croisés &amp; compteur horaire
- Activer le CDN cloudfare ?
- Publication du site statique (sur via ? / ovh ?) –&gt; en attente nouvelle release de wp2static

Done :

- Retrait des pages wiki migrées (archivés)
- Menu sticky qui s’applatit
- Packaging vieux site
- Export de site avec services masqués (recherche / google translate / respond)
- Mettre à jour remipeyronnet.free.fr
# Architecture du site — LPRP.fr

Document technique de référence pour comprendre comment le site est assemblé. Complète
`AGENTS.md` (mode d'emploi) et le skill `nouvel-article` (style rédactionnel).

## Vue d'ensemble

```
Jekyll 4.2.2 + Ruby 3.1
├── _config.yml          config principale (site, menus, analytics, defaults)
├── _config_dev.yml      overrides dev (archives désactivées, host 0.0.0.0)
├── _config_prod.yml     overrides prod (url = https://www.lprp.fr, show_drafts false)
├── _layouts/            gabarits de page
├── _includes/           fragments réutilisables
├── _sass/               styles,thm Sass compilé par Jekyll
├── _plugins/            8 plugins Ruby maison
├── _data/               données YAML/JSON
├── _posts/YYYY/        articles
├── _pages/              pages statiques
├── files/YYYY/          images et pièces jointes servies en statique
├── assets/              CSS/JS du thème + images
└── libs/                JS/CSS vendorisés (jquery, bootstrap, giscus, owl-carousel…)
```

## Chaîne de build

### En local

`serve.sh` :

```bash
BUNDLE_GEMFILE=Gemfile-dev bundle install
bundle exec jekyll build --profile --trace
BUNDLE_GEMFILE=Gemfile-dev bundle exec jekyll serve \
  --livereload --watch --future --drafts --profile --config "_config.yml,_config_dev.yml"
```

Points d'attention :

- `--drafts` est utilisé : les brouillons de `_drafts/` sont visibles en local.
- Le `--config` à deux fichiers est obligatoire en local, sinon `url` et `host` ne
  sont pas définis.
- `Gemfile-dev` ajoute `jekyll-admin` (l'interface d'édition web) et `webrick`.
- `incremental` est commenté dans `serve.sh` : il produisait de la duplication de
  contenu avec jekyll-admin.
- `--lsi` est commenté : il génère des `related_posts` sans rapport.

### En CI

`.github/workflows/jekyll.yml`, sur chaque push sur `main` :

1. `bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}" --config "_config.yml,_config_prod.yml"` avec `JEKYLL_ENV=production`
2. `node build-index.js` → génère `_site/assets/search-lunr-index.json` (index Lunr
   pour la recherche) depuis `_site/assets/search-cards.json`
3. `gzip _site/assets/search-lunr-index.json`
4. Déploiement GitHub Pages

`build-index.js` a besoin de `node` ; il utilise les copies locales de lunr dans
`assets/js/lunr*.js` (pas de npm install). Le fichier `build-index.js` est exclu de la
config Jekyll (`exclude:`) pour ne pas être publié.

### Recherche

Deux artefacts, générés par des pages à `layout: null` :

| Fichier source | Sortie | Contenu |
|---|---|---|
| `search-contents` | `/assets/search-cards.html` | toutes les cartes du site, pour l'affichage |
| `search-js` | `/assets/search-cards.json` | `{id, url, title, body}` pour l'index Lunr |

La page `search.html` charge le JSON, l'index Lunr, et affiche les cartes filtrées.
`build-index.js` (Node) transforme le JSON en index Lunr compressé.

## Layouts

| Layout | Usage | Points notables |
|---|---|---|
| `default.html` | socle de toutes les pages | `<head>`, CSP, modules JS/CSS, header, footer |
| `post.html` | articles | en-tête (date, auteur, badge IA, tags), sommaire, contenu, tags, partage, articles liés, commentaires |
| `page.html` | pages statiques | version allégée de `post.html`, sans header de date ni partage |
| `home-layout.html` | accueil `/` | 3 panneaux (Derniers / Les plus consultés / Mis en avant) + scroll infini |
| `blog-layout.html` | `/blog/` | 16 cartes par page + scroll infini + sidebar catégories/tags |
| `archive.html` | archives par année/mois/tag/catégorie | génère via `jekyll-archives` |
| `redirect.html` | redirection JS | utilisé par `_plugins/redirects.rb` |

Le `<head>` de `default.html` est un point sensible : il assemble la CSP, les
`{%- seo -%}`, les polices, les modules. Toute ressource externe nouvelle
(YouTube, un CDN, un tracker) doit être ajoutée **dans la CSP** de la page, sinon le
navigateur la bloque. Le champ `csp:` du front matter permet d'ajouter un fragment
propre à un article.

### Modules

Le front matter `modules:` charge conditionnellement des ressources (voir `default.html`) :

| Module | Ce qu'il charge |
|---|---|
| `jquery` | `libs/jquery-3.6.1.min.js` |
| `bootstrap` | `assets/bootstrap.css` + `libs/bootstrap/js/bootstrap.bundle.min.js` |
| `gallery` | jQuery + bootstrap + `assets/js/gallery.js` |
| `owl-carousel` | jQuery + owl-carousel CSS/JS |
| `asciimath` | `libs/ASCIIMathML.js` (et active le rendu `$$`…`$$` en AsciiMath) |

`bootstrap` est aussi chargé implicitement pour le CSS du contenu : `.post-content`
a la classe `bootstrap`, donc les classes Bootstrap (table, alert, etc.) sont
utilisables dans les articles.

## Plugins maison (`_plugins/`)

| Plugin | Rôle |
|---|---|
| `protect_code.rb` | enveloppe les blocs de code et l'inline code dans `{% raw %}` pour que Liquid ne les interprète pas |
| `md_link_relative.rb` | réécrit `](/` en `]({{ site.baseurl }}/` : les liens internes à la racine sont préfixés automatiquement |
| `asciimath.rb` | retire les marqueurs MathJax `\( \)` / `\[ \]` autour des blocs `` $$`…`$$ `` |
| `include_absolute.rb` | `{% include_absolute '.htaccess' %}` : inclut un fichier hors de `_includes` |
| `fa_icon.rb` | tag `{% fa_svg fas.fa-home %}` (icônes FontAwesome SVG en inline) |
| `reading_time_filter.rb` | filtres `reading_time` (article) et `reading_time_brief` (carte) |
| `related_posts.rb` | `site.related_posts` : articles liés, score = tags communs + 3 × catégories communes |
| `redirects.rb` | génère les pages de redirection depuis `_data/redirects.json` |

`related_posts.rb` remplace la version de `post.html` (qui est commentée) : c'est
la version en Ruby qui fait foi.

## Données (`_data/`)

| Fichier | Contenu | Usage |
|---|---|---|
| `categories.yml` | catégorie → `{fr, en}` | `_includes/category.html` affiche la traduction selon la langue de la page |
| `langs.yml` | `fr`, `en` → nom, drapeau, `date_format` | format de date, sélecteur de langue |
| `picture.yml` | presets `default` et `card` | `jekyll_picture_tag` : largeurs, formats webp/original, media queries |
| `redirects.json` | `{ancienne_url: nouvelle_url}` | `redirects.rb` |

`categories.yml` est la source de vérité pour les catégories : une catégorie non
déclarée s'affiche en clair, sans traduction.

## Images

- Source : `files/YYYY/`, servie telle quelle.
- `jekyll_picture_tag` génère des variantes dans `_site/generated/` (webp + original,
  largeurs 150/400/600/800/1000 pour `default`, 150/400/600 pour `card`).
- Le front matter `image:` d'un post et le `{% picture card … %}` dans
  `main-loop-card-cached.html` utilisent le preset `card`.
- `libvips` et `libvips-tools` sont requis (installés par le devcontainer et la CI).
- `picture: { suppress_warnings: true, fast_build: true }` dans `_config.yml`.

## Multilingue

- `lang:` par page (`fr` ou `en`). `site.lang` est le défaut.
- `default.html` déclare `hreflang` pour la page et ses traductions.
- `lang-ref` identifie le groupe de traductions ; `lang-translations` mappe
  langue → slug. Les deux sont nécessaires : `post.html` s'en sert pour sauter vers
  l'autre version dans le fil précédent/suivant.
- Les chaînes bilingues dans les templates utilisent deux balises :
  `<span class="lang-fr">…</span><span class="lang-en">…</span>`, masquées par le CSS
  de `_includes/header.html` selon `page.lang`.
- Les menus (categories, tags) traduits sont dans `_data/categories.yml`.

## Conventions de nommage

| Objet | Convention | Exemple |
|---|---|---|
| Article | `YYYY-MM-DD-slug.md` | `2026-10-25-mon-sujet.md` |
| URL d'article | `/YYYY/MM/slug/` | `/2026/10/mon-sujet/` |
| Dossier d'images | `files/YYYY/` | `files/2026/` |
| Image | `slug-contexte.png` | `usbip-vignette.jpg` |
| Page statique | `nom.md` dans `_pages/` | `cv.md`, `blog.md` |

Les noms de fichiers **définissent les URL** (via `permalink: /:year/:month/:title/`).
La date affichée et l'URL viennent du champ `date:` — les deux doivent concorder
(cf. `2022-12-26-Minikube.md`, dont le `date:` est en juin et l'URL en `/2022/06/`).

## Pièges connus

S'applique à `_config*.yml`, `_layouts/`, `_includes/`, `_plugins/`, `_sass/`, `_data/`.

- **Le build passe avant tout** : la CI construit et déploie à chaque push sur `main`.
  `bundle exec jekyll build --config "_config.yml,_config_prod.yml"`.
- **CSP** : toute ressource externe nouvelle (CDN, vidéo, tracker) doit être déclarée
  dans le `<head>` de `_layouts/default.html`, sinon le navigateur la bloque. Le champ
  `csp:` du front matter ajoute un fragment par page.
- **Les plugins s'exécutent sur tous les documents** : un plugin mal écrit casse tout
  le site, pas seulement un article.
- **Les noms de fichiers définissent les URL** : renommer un article casse les liens.
  Préférer `{% link %}` et ajouter une entrée dans `_data/redirects.json` si une
  ancienne URL doit survivre.
- `md_link_relative.rb` préfixe automatiquement les liens `](/` : écrire `/blog/` dans
  un article fonctionne, mais écrire `/2024/01/ancien-slug/` en dur casse si l'article
  est renommé. Préférer `{% link %}`.
- `protect_code.rb` protège le code, mais pas les maths : `$...$` peut être mangé par
  Liquid. Utiliser AsciiMath (`$$`…`$$` + `modules: asciimath`) ou MathJax.
- Les images référencées par `![…]({{ 'files/…' | relative_url }})` ne sont pas
  transformées par `jekyll_picture_tag` (le tag n'est pas utilisé en Markdown) : pas de
  `srcset` automatique, pas de webp. C'est voulu, la balise est simple.
- `_config.yml` n'est pas rechargé à chaud : il faut redémarrer `jekyll serve`.
- Les URLs de catégories utilisent `slugify: 'latin'` : `Général` → `/category/general/`,
  `Domotique` → `/category/domotique/`. Les anciennes URL sont dans
  `_data/redirects.json`.
- Le champ `ia:` du front matter affiche un badge « (+IA) » dans l'en-tête, à condition
  que `author` soit présent (il l'est par défaut via `_config.yml`).

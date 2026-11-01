# Guide rédactionnel — LPRP.fr

Le style des articles de lprp.fr : genre, plan, ton, typographie, et le détail mécanique
détaillé (front matter, images, liens, classes CSS). `AGENTS.md` à la racine n'en donne
que l'essentiel : **ne pas dupliquer les deux.**

S'applique aux fichiers de `_posts/`.

## Les pièges qui cassent le plus souvent

- `_posts/YYYY/YYYY-MM-DD-slug.md` ; le slug du nom de fichier **est** l'URL.
- `date:` du front matter = date du nom de fichier.
- `categories` prises dans `_data/categories.yml` ; `tags` en camel case.
- Images dans `files/YYYY/`, référencées
  `![alt]({{ 'files/2026/x.png' | relative_url }}){: .img-center .mw80}` — le
  `{: ... }` sur la **même ligne**.
- Liens vers un article : `{% link _posts/2026/2026-01-31-sujet.md %}`, jamais une URL
  en dur.
- Style : retours d'expérience personnels, une `#` par action concrète, `# Conclusion`,
  `# Références`.

Vérification avant livraison :

```bash
bash .agents/skills/nouvel-article/scripts/check-post.sh <fichier>
```

## Le genre

Le blog est un **blog de retours d'expérience personnel**. L'auteur (Rémi Peyronnet)
documente ce qu'il fait sur son infrastructure domestique : Proxmox, Home Assistant,
Docker, domotique RF433, 3D, outillage réseau.

Conséquences directes :

- On écrit depuis le vécu : « Voici ce que j'ai fait », pas « Voici comment faire ».
- On donne les commandes exactes, avec les versions, les chemins, les noms de fichiers.
- On assume les subjectifs : « Personnellement j'ai utilisé… », « À mon avis… ».
- Pas de contenu sponsorisé, pas de SEO, pas d'introduction générique du type
  « Dans le monde actuel de plus en plus connecté… ».

## Front matter complet

Gabarit, à recopier en supprimant les lignes inutiles :

```yaml
---
title: Titre de l'article
lang: fr
tags:
- Tag1
- Tag2
categories:
- Informatique
toc: 2
date: '2026-10-25 10:30:00'
image: files/2026/vignette-mon-sujet.jpg
---
```

| Champ | Rôle | Valeurs |
|---|---|---|
| `title` | Titre affiché | texte libre, accents autorisés |
| `lang` | Langue de l'article | `fr` (défaut) ou `en`. Contrôle le format de date, le menu langues, le badge de traduction |
| `tags` | Mots-clés, **camel case** (`Home Assistant`, `Proxmox`, `Wi-Fi`) | 4 à 8 |
| `categories` | 1 à 2, **prises dans `_data/categories.yml`** (sinon non traduites sur la page EN) | `Informatique`, `Domotique`, `3D`, `Avis Conso`, `Général`, `Divers`, `Humeurs`, `Politique`, `Télécoms`, `Calculatrices` |
| `toc` | Profondeur du sommaire : `1` = les `#`, `2` = `#` et `##` (défaut), `3` = jusqu'aux `###` | `1`, `2`, `3` ou `true` (= 2) |
| `date` | Publication, format `YYYY-MM-DD HH:MM:SS` entre apostrophes | = date du nom de fichier |
| `image` | Vignette des cartes du blog et de la home. Chemin **sans slash initial** | `files/2026/xxx.jpg` |
| `last_modified_at` | Modification, affichée dans l'en-tête (icône crayon) | optionnel |
| `ia` | Outils IA utilisés → badge « (+IA) » | `Perplexity, Copilot` |
| `modules` | Ressources à charger : `jquery`, `gallery`, `bootstrap`, `owl-carousel`, `asciimath` | liste YAML |
| `featured` | Rang d'affichage sur `/featured/` (les plus grands d'abord) | optionnel |
| `card-desc` | Texte de la carte à la place de l'extrait automatique | optionnel |
| `hidden` | `true` exclut l'article des listes (blog, home, recherche) | optionnel |
| `lang-ref` / `lang-translations` | Traductions : identifiant commun + table langue → slug | optionnel |
| `csp` | Fragment CSP ajouté à l'en-tête si l'article charge une ressource externe | optionnel |

Fournis par `_config.yml` pour tout `_posts/` : `layout: post`, `toc: true`,
`author: 'Rémi Peyronnet'`. Ne pas les répéter.

## Images

- Stockage : `files/YYYY/`, **pas** `assets/`.
- Nommage : `vignette-<slug>.jpg` pour la vignette, `<slug>-<etape>.png` pour les
  captures. Minuscules, tirets, **pas d'espace** (des fichiers historiques en ont, ne
  pas les imiter).
- Référence dans le corps :

```markdown
![Description utile]({{ 'files/2026/mon-sujet-01.png' | relative_url }}){: .img-center .mw80}
```

- L'indicateur de classe `{: ... }` est **sur la même ligne** que l'image.
- `image:` du front matter doit pointer vers un fichier existant, sinon la carte
  affiche le logo par défaut.
- Usage rédactionnel : une capture par étape, insérée **après** l'explication
  correspondante, pas à la fin. Alt text descriptif : `![adb devices -l](...)`.
  `.img-center .mw80` pour une capture pleine largeur, `.mw60` pour une capture de
  terminal, `.img-right .mw30` pour une photo en marge.

## Liens

| Destination | Syntaxe |
|---|---|
| Article du site | `{% link _posts/2026/2026-01-31-sujet.md %}` |
| Page du site | `[texte]({{ '/2022/12/multi-language-jekyll/' | relative_url }})` |
| Ressource externe | `[texte](https://…)` |

Ne jamais écrire l'URL d'un article en dur : elle casse si le slug change. Dans un même
article, ne mélange pas `{% link %}` et URL en dur sans raison : si l'article cite
surtout ses frères, `{% link %}` partout est plus propre.

## Classes CSS de mise en forme

Définies dans `_sass/styles.scss` (aussi listées dans `_drafts/archives/site-doc.md`) :

| Classe | Effet |
|---|---|
| `.img-center` | Image centrée, `max-width: 100%` |
| `.img-right` / `.img-left` | Image flottante à droite / gauche |
| `.mw80` `.mw60` `.mw40` `.mw30` `.mw20` | Largeur maximale de l'image (responsive) |
| `.center` | Texte centré |
| `.clear-float` | Interrompt un flottant |
| `.div-center` | Block centré |
| `.font-large` `.font-xlarge` `.font-xxlarge` | Corps de texte agrandi |
| `.notice-note` | Encadré d'avertissement (attribut `title` pour l'en-tête) |
| `.frame-red` `.frame-orange` `.border-1fg` | Encadré coloré pleine largeur |
| `.base-button` `.download-button` `.green-button` `.red-button` `.blue-button` | Boutons |
| `.photos-album` `.photos-albums` | Galerie de vignettes |
| `.img-col-2` | Deux colonnes d'images |

## Plan type

| Partie | Contenu |
|---|---|
| Chapeau | 1 à 2 paragraphes : le contexte, la motivation, l'enjeu |
| (optionnel) Synthèse | « Si vous êtes pressés, en synthèse : » + liste à puces des étapes |
| `#` Sections | Une action concrète par section, titre à l'infinitif ou en nom d'étape |
| `##` Sous-sections | Précision, variante, commande détaillée |
| `# Conclusion` | Bilan + usages possibles + ouverture |
| `# Références` | Liens vers docs officielles, dépôts GitHub, discussions |

Le sommaire automatique (`toc`) n'apparaît que s'il y a plus de 5 entrées.

## Exemple d'ouverture

> Il est possible depuis peu de réutiliser les Facebook Portal rendus inutiles par
> l'arrêt du service en écrans connectés domotique.

> S'il est très facile d'augmenter la taille d'un disque virtuel sous Proxmox,
> l'opération inverse est nettement plus délicate. Lors de l'installation de Home
> Assistant, j'ai dû réduire un disque surdimensionné. Voici la procédure utilisée.

Explications :

- Phrase d'accroche courte, sujet + enjeu, sans formule toute faite.
- Détail personnel ensuite : pourquoi, dans quel contexte.
- Annonce de ce que l'article contient (« Voici la procédure utilisée »).

## Titres

- `#` : des actions ou des étapes. « Installer mosquitto », « Réduire la partition »,
  « Activer ADB », « Le "piège" des couleurs des ports ».
- `##` : un sous-ensemble de l'étape. « Option ligne de commande », « Installation ».
- Éviter les titres purement descriptifs vagues (« Introduction », « Conclusion
  détaillée ») — le site n'a jamais de `# Introduction`.
- Accents et majuscules corrects : « Mise à jour et remise à zéro », pas « MAJ et reset ».

## Code

Toujours en blocs fermés avec le langage :

````markdown
```bash
lvreduce -L 16G /dev/mapper/pve-vm--102--disk--1
```
````

- Commandes réellement exécutées, dans l'ordre, copiables.
- Ajoute les commentaires utiles (`# Installer l'ISO dans le CDROM de la VM`).
- Les chemins du site : `/config/home-assistant_v2.db`, `/etc/proxmox/…`, `/sdcard/Download/`.
- N'invente pas de sortie de commande que tu n'as pas vue. Si tu n'as pas la sortie réelle,
  écris le résultat attendu en commentaire.

## Typographie française

- Espaces insécables (U+00A0 ou U+202F) avant `:`, `;`, `!`, `?`, `%`.
- Apostrophe typographique `’` (jamais `'` dans le texte français).
- Guillemets français `« … »`.
- `⚠️` pour un avertissement ponctuel, en début de ligne.
- Pas d'emoji décoratif ailleurs. Les rares emojis du site sont fonctionnels.
- Les noms de technologies restent en anglais : `Docker`, `Proxmox`, `Home Assistant`,
  `MQTT`. Le reste est en français.

## Registre

- Phrases courtes, une idée par paragraphe.
- Ponctuation française : `;` rare, `,` fréquente, pas de phrase à rallonge.
- On explique le *pourquoi* quand une étape semble arbitraire : « j'ai choisi X parce
  que Y ».
- Les échecs sont racontés : « La méthode classique n'a pas fonctionné correctement ;
  en revanche, une solution simple fonctionne. »
- Conclusion frequently followed by « D'autres usages sont bien sûr possibles. »

## Traductions

Un article `lang: en` est une **réécriture** en anglais, pas une traduction littérale :

- L'anglais est souvent plus court et plus direct.
- Les exemples de commandes sont identiques.
- Le ton reste le même : retours d'expérience, pas documentation officielle.
- Les liens vers les articles frères restent en français, avec la mention
  « (in french) » quand c'est utile.

### Couplage des versions

Les deux versions d'un même article partagent un `lang-ref` (identifiant commun,
format du site : `pll_` + 13 caractères hexadécimaux) et un `lang-translations`
(langue → slug sans le préfixe de date), présents dans **les deux** fichiers.

```yaml
lang-ref: pll_5be1f437513de
lang-translations:
  fr: creation-de-disques-virtuels-sous-windows
  en: virtual-disk-creation-on-windows
```

La `category` du front matter reste en français dans les deux versions : c'est la clé
du dictionnaire de traductions (`_data/categories.yml`), pas sa valeur.

### Garder les deux versions en cohérence

**Modifier une version impose de répercuter dans l'autre.** Trouve la version jumelle
par le `lang-ref` :

```bash
grep -rl "lang-ref: <valeur>" _posts/
```

Puis répercute :

- le contenu modifié, avec le même plan (`#` et `##` en nombre et en ordre) ;
- la date : `last_modified_at` des deux côtés, `date:` si la publication change ;
- les liens entre les deux versions, et `lang-translations` si un slug a changé
  (ajoute alors une redirection dans `_data/redirects.json`) ;
- les captures : mêmes images, mêmes positions.

Ne laisse jamais les deux versions diverger sur un point technique : commande, version
de logiciel, chemin, lien externe. L'anglais est plus court, pas différent.

Si une seule version existe, ne crée pas l'autre sans demande explicite : signale
simplement à l'utilisateur qu'elle pourrait être écrite.

## Anti-patterns

| À éviter | Pourquoi |
|---|---|
| « Dans le monde moderne… » | Introduction creuse, aucun apport |
| Phrases exclamatives / superlatifs | Le site est factuel |
| Recopier une documentation officielle | L'apport personnel est la valeur |
| Article sans captures | Le site est très visuel |
| `#` pour un simple détail | Le sommaire devient illisible |
| Traduction automatique fr→en | Le style anglais du site est plus sec |
| Versions fr et en divergentes | Le lecteur tombe sur des infos contradictoires |
| Piège à ciel ouvert | Métaphore récurrente du site, à éviter |

---
name: creer-image
description: "Créer ou faire produire une image pour un article du site LPRP.fr : vignette de carte (champ image du front matter), capture d'écran, schéma ou illustration. Utilise quand on demande une image, une vignette, une illustration, une capture pour un post, ou quand un article manque d'illustration. Couvre le lieu de stockage, le nommage, le format, le rattachement à l'article et les contrôles."
argument-hint: "Article concerné (chemin) et type d'image : vignette, capture, schéma"
---

# Créer une image pour un article

Le site LPRP.fr est **très visuel** : presque tous les articles ont une vignette et des
captures. Ce skill couvre la partie mécanique (où, comment, sous quel nom). Le style
visuel et la syntaxe Markdown sont dans
[`.agents/writing-style.md`](../../writing-style.md) § Images.

Skills liés : `nouvel-article` (rédiger l'article qui accueille l'image),
`article-depuis-notes` (structurer un texte brut qui contient déjà des captures).

## Les deux rôles d'une image

| Rôle | Où | Rendu |
|---|---|---|
| **Vignette** | champ `image:` du front matter | image de la carte sur le blog, la home, la recherche |
| **Capture / schéma** | corps de l'article | illustration à côté du texte |

La vignette est la plus importante : c'est la première chose qu'on voit dans la liste
des articles. Sans elle, la carte affiche le logo du site.

## Étape 1 — cadrer

Avant de produire quoi que ce soit, demande (ou déduis du contexte) :

1. **Quel article** : chemin du `.md` dans `_posts/YYYY/`.
2. **Quel type** : vignette, capture d'écran d'une commande, capture d'une interface,
   schéma d'architecture, photo de montage.
3. **Le contenu réel** : pour une capture, il faut la vraie commande ou le vrai écran.
   Pour un schéma, il faut l'architecture réelle. **N'invente pas** une fausse capture
   d'écran d'une commande que l'auteur n'a pas exécutée : ça induit le lecteur en
   erreur.

Si l'image est destinée à un article qui a déjà une vignette, propose de la remplacer
plutôt que d'en ajouter une seconde.

## Étape 2 — stockage et nommage

Les images vont dans `files/YYYY/` (dossier de l'année), **jamais** dans `assets/`.

| Type | Nom | Format |
|---|---|---|
| Vignette | `vignette_<slug>.jpg` ou `vignette-<slug>.jpg` (les deux existent sur le site) | JPG |
| Capture | `<slug>_<etape>.png` ou `<slug>-<etape>.png` | PNG |
| Schéma | `<slug>_schema.svg` | SVG |

Règles :

- minuscules, tirets ou underscores, **pas d'espace** (des fichiers historiques en
  ont, ne pas les imiter) ;
- pas d'accent ;
- le nom doit être devinable : on doit pouvoir le retrouver par `grep` dans le
  `_posts/`.

```bash
# où sont les images de l'année
ls files/2026/ | head -20

# a-t-on déjà une image pour cet article ?
grep -n "^image:" _posts/2026/2026-10-25-mon-sujet.md
ls files/2026/ | grep -i "mon-sujet"
```

## Étape 3 — produire l'image

Trois voies, selon ce qu'on a sous la main.

### a) Capture d'écran d'une interface ou d'un terminal

L'auteur fournit l'image (capture manuelle, export d'un outil) ou la commande à
exécuter. Si l'environnement permet l'exécution (accès SSH, machine locale), tu peux
lancer la commande et capturer le résultat.

Bon format : la sortie du terminal en police lisible, fond contrasté, sans le prompt
si la commande est déjà décrite juste avant.

### b) Schéma d'architecture

Le site utilise le SVG pour les schémas (exemple : `files/2026/Server-SecureStack.svg`).
Avantages : net à toutes les tailles, poids faible, texte sélectionnable.

Écris un SVG à la main, aux dimensions du contenu (ex. 1200×600), avec :
- des rectangles aux coins arrondis pour les briques ;
- des flèches entre les briques ;
- des libellés en français, courts (2-3 mots) ;
- une couleur par couche, cohérente avec le reste du site.

### c) Image générée par IA

Utilisée sur ce site pour les captures d'écran d'interfaces (voir l'article
`2026-10-04-encfs-tree-browser-…` : « les captures d'écran présentées dans cet article
sont également générées automatiquement, à partir de la description des scénarios
d'utilisation souhaités »).

La méthode : **décrire le scénario d'utilisation** plutôt que l'apparence. « Une
fenêtre de navigateur affichant un arborescence à deux colonnes, noms chiffrés à
gauche en clair, noms décodés à droite, un champ de recherche en haut » produit une
image cohérente ; « une capture d'écran pretty » ne produit rien d'utile.

Si l'image est générée par IA, le site le mentionne dans l'article. L'auteur décide.

## Étape 4 — rattacher à l'article

### Vignette

```yaml
---
image: files/2026/vignette_mon-sujet.jpg
---
```

Chemin **sans slash initial**, relatif à la racine du site. Le fichier doit exister,
sinon la carte affiche le logo par défaut.

### Capture dans le corps

```markdown
![Description utile]({{ 'files/2026/mon-sujet_01.png' | relative_url }}){: .img-center .mw80}
```

- l'indicateur de classe `{: ... }` est **sur la même ligne** que l'image ;
- `.mw80` pour une capture pleine largeur, `.mw60` pour un terminal, `.img-right .mw30`
  pour une photo en marge ;
- l'alt doit décrire, pas nommer : `![Arborescence EncFS avec les noms décodés](…)`,
  pas `![image1](…)`.

## Étape 5 — vérifier

```bash
# le fichier existe et n'est pas vide
ls -la files/2026/mon-sujet_01.png

# la vignette du front matter pointe vers un vrai fichier
grep "^image:" _posts/2026/2026-10-25-mon-sujet.md
test -f "files/2026/vignette_mon-sujet.jpg" && echo OK

# toutes les images référencées par l'article existent
grep -oE "'files/[0-9]{4}/[^']+'" _posts/2026/2026-10-25-mon-sujet.md | tr -d "'" \
  | while read f; do [ -f "$f" ] || echo "MANQUANTE: $f"; done

# la vignette est bien trackée par git (la CI ne build que le commit)
git status --short files/2026/

# l'article passe le contrôle global
bash .agents/skills/nouvel-article/scripts/check-post.sh _posts/2026/2026-10-25-mon-sujet.md
```

**Si tu n'as pas d'outil de manipulation d'image** (pas de `convert`, `magick`,
`libvips`, navigateur headless) : produis le fichier dans un format que tu peux écrire
directement (SVG pour un schéma, ou demande à l'auteur la capture) et **dis-le
explicitement** plutôt que de prétendre avoir généré un PNG.

## Pièges

| Piège | Conséquence |
|---|---|
| Image dans `assets/` | Servie en statique mais pas servie depuis `files/`, incohérent avec le reste |
| `image:` avec un slash initial | La vignette ne se résout pas |
| Fichier image non commité | La CI ne le voit pas : image cassée en ligne |
| `{: .img-center}` sur la ligne suivante | Kramdown ignore la classe |
| Faux screenshot d'une commande | Trompe le lecteur, contredit le retour d'expérience |
| Nom avec accent ou espace | URL d'image bancale, cassage selon le serveur |

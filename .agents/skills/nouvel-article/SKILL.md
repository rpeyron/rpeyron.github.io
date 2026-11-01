---
name: nouvel-article
description: "Rédiger un nouvel article de blog pour le site Jekyll LPRP.fr. Utilise quand on demande de créer, publier ou préparer un billet, un article, un post, une publication sur lprp.fr, ou de transformer des notes en article. Couvre le choix du slug et de l'URL, le front matter, les images, les liens, le style rédactionnel français ou anglais, et la vérification avant livraison."
argument-hint: "Sujet de l'article, langue, éventuelles notes ou sources"
---

# Rédiger un nouvel article

Site : **LPRP.fr** — blog personnel Jekyll. Les règles mécaniques (front matter,
nommage, images, liens, classes CSS) sont dans [`AGENTS.md`](../../../AGENTS.md) à la
racine. Le style détaillé est dans
[`.agents/writing-style.md`](../../writing-style.md). **Lis ces deux fichiers
avant d'écrire.** Ce skill décrit la *méthode*, pas le contenu des règles.

## Entrées à clarifier avant d'écrire

Demande (ou déduis du contexte) :

1. **Le sujet** — en une phrase. Si c'est flou, reformule et fais valider.
2. **La langue** — `fr` (défaut) ou `en`. L'anglais du site est une *réécriture* plus
   sèche, pas une traduction.
3. **L'angle** — retour d'expérience personnel, test, tutoriel, comparatif ? Le site
   fait majoritairement du retour d'expérience sur l'infrastructure de l'auteur.
4. **Les supports** — photos, captures d'écran, commandes, logs. Sans images, l'article
   n'est pas dans le style du site : demande ou propose de les produire.
5. **La date de publication** — par défaut aujourd'hui.

Ne commence pas à écrire tant que le sujet et l'angle ne sont pas posés. En revanche,
si l'utilisateur a déjà tout fourni, va droit au texte.

## Étape 1 — cadrage

Avant d'écrire, vérifie dans le dépôt ce qui existe déjà :

```bash
# articles proches du sujet (mots-clés dans le titre, les tags, le corps)
grep -ril "mot-clé" _posts/ | head
# une catégorie existe-t-elle ?
grep -n "^[A-Za-zÀ-ÿ0-9]" _data/categories.yml
# un tag est-il déjà utilisé (casse) ?
grep -rn "^- Home Assistant$" _posts/ | head -3
```

Objectif : ne pas créer de doublon, réutiliser les tags existants (camel case :
`Home Assistant`, `Proxmox`, `Wi-Fi`), et choisir une catégorie **déjà déclarée** dans
`_data/categories.yml`. Si une nouvelle catégorie est justifiée, ajoute-la au fichier
de données **et** à la section `menu:` de `_config.yml`.

## Étape 2 — plan

Écris le plan (titres `#` et `##`) avant les paragraphes. Un titre `#` = une action
concrète ou une étape, à l'infinitif ou en nom d'étape. Le plan doit tenir en 5 à 10
titres pour un article de 900 mots.

Ordre type :

```
chapeau (1-2 paragraphes : contexte + enjeu)
[ synthèse "si vous êtes pressés" + liste à puces ]
# Étape 1 …
# Étape 2 …
## Sous-étape
# Conclusion
# Références
```

## Étape 3 — rédaction

Le style détaillé est dans [`.agents/writing-style.md`](../../writing-style.md).
Les points qui font la différence :

- **Chapeau** : pas de formule creuse (« Dans le monde connecté… »). Contexte personnel
  + enjeu concret + annonce du contenu.
- **Voix** : « J'ai… », « Dans mon cas… », « Personnellement… ». L'auteur raconte ce
  qu'il a fait chez lui.
- **Difficultés** : dis ce qui n'a pas marché et le contournement trouvé. C'est le cœur
  du style du site.
- **Code** : commandes réelles, dans l'ordre, pas de sortie inventée.
- **Images** : une capture par étape, insérée **après** le paragraphe qu'elle illustre.
- **Anglais** : même ton, plus direct — c'est une réécriture, pas une traduction.

## Étape 4 — images

Le détail est dans le skill `creer-image`. En pratique :

```bash
# où aller, et s'il y a déjà des captures exploitables
ls files/2026/ | head
```

- Prévoir une vignette pour `image:` (elle alimente les cartes du blog et la home) et
  une capture par étape dans le corps.
- Si l'auteur n'a pas de visuels, **propose** de les produire (capture d'écran de la
  commande, schéma, photo du montage) ou utilise un visuel sobre déjà présent.

Si le sujet et la structure sont déjà posés mais que le texte est en vrac, le skill
`article-depuis-notes` fait la passe de structuration (accroche, plan, conclusion,
références) — il complète celui-ci.

## Étape 5 — front matter

Le tableau complet des champs est dans `AGENTS.md`. Remplis le gabarit, supprime les
lignes inutiles, et n'ajoute `ia:` que si un assistant IA a participé à la rédaction.

Le point qui piège : `date:` doit correspondre à la date du nom de fichier, sinon
l'URL et la date affichée divergent (c'est le champ `date:` qui fait foi, pas le nom).

## Étape 6 — traductions

Avant d'écrire, vérifie si le sujet existe déjà dans l'autre langue :

```bash
grep -ril "mot-clé" _posts/ | head
```

Si une version française **et** une version anglaise existent (même `lang-ref`), tu
modifies un article publié : **répercute dans les deux versions** le contenu, la date,
les liens entre versions et les captures. La procédure complète est dans
[`.agents/writing-style.md`](../../writing-style.md) (§ Garder les deux
versions en cohérence).

Si une seule version existe, ne crée pas l'autre sans demande explicite : signale
simplement qu'elle pourrait être écrite.

## Étape 7 — vérification

Lance le script de contrôle statique du skill :

```bash
bash .agents/skills/nouvel-article/scripts/check-post.sh _posts/2026/2026-10-25-mon-sujet.md
```

Il vérifie : front matter présent et clos, champs obligatoires, cohérence date / nom de
fichier, existence des images référencées, accolades Liquid équilibrées, absence de
`{{` orphelin, structure (nombre de sections, images, blocs de code, conclusion).

Modes : `check-post.sh <fichier>…` ou `check-post.sh --all` (tous les `_posts/`).
**Le mode `--all` remonte des erreurs sur les articles de 1999-2023** : ils suivent les
conventions de l'époque (front matter absent, images en chemin absolu, slugs avec
espaces). C'est attendu. Utilise `--all` comme état des lieux historique, pas comme
critère de validation. Pour valider ton travail, passe le fichier concerné.

Si Ruby est disponible, le vrai contrôle est le build :

```bash
bundle exec jekyll build --config "_config.yml,_config_prod.yml"
```

Puis relis l'article **en entier** comme le ferait un lecteur : titre, chapeau, ordre des
étapes, code, images à leur place, conclusion, références.

## Livraison

- Un seul fichier ajouté (l'article) + les images.
- Si une nouvelle catégorie ou un nouveau tag structurant a été introduit, le dire
  explicitement (le tag n'apparaît dans le menu latéral qu'au build suivant).
- Rappelle le chemin du fichier et l'URL resulting.

## Anti-patterns

| À éviter | Pourquoi |
|---|---|
| Écrire sans avoir lu `AGENTS.md` | Les règles de front matter et d'images sont strictes |
| Slug avec accents ou espaces | L'URL est cassée |
| `date:` ≠ date du nom de fichier | L'URL et la date affichée divergent |
| Image absente de `files/YYYY/` | Image cassée à l'écran |
| `![...](files/...)` sans `relative_url` | Cassé si `baseurl` change |
| Article sans aucune image | Hors style du site |
| Traduction littérale fr→en | L'anglais du site est plus sec, réécris-le |
| Sections `#` génériques (« Introduction ») | Sommaire illisible |
| Écrire une sortie de commande inventée | Trompe le lecteur, contredit le retour d'expérience |

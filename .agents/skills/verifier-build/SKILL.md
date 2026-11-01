---
name: verifier-build
description: "Vérifier qu'une modification du site Jekyll LPRP.fr ne casse pas le build ni le rendu. Utilise quand on a touché à un layout, un include, un plugin, la config, les données, le Sass, ou après avoir écrit un article, avant commit ou push. Couvre le build de production, la vérification des pages générées, et les contrôles de rendu (CSP, assets, images)."
argument-hint: "Fichier ou chemin modifié à vérifier (optionnel)"
---

# Vérifier le build

**Un build cassé casse le site en ligne.** Avant commit, toujours tester le build prod.

## 1. Build Jekyll (comme la CI)

```bash
bundle exec jekyll build --config "_config.yml,_config_prod.yml"
```

Si Ruby manque : dis-le explicitement, passe aux contrôles statiques seulement.

## 2. Vérifier le rendu

Remplace `/2026/10/mon-sujet/` par le chemin de ta page.

```bash
# page existe + pas d'erreur Liquid
ls _site/2026/10/mon-sujet/index.html
grep "Liquid Exception\|Liquid syntax error" _site/2026/10/mon-sujet/index.html
```

## 3. Avant commit

```bash
git status --short
git diff --stat
```

Vérifie : rien de non intentionnel, images trackées, message de commit en minuscules sans point.

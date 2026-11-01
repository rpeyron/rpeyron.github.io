---
name: lprp-new-post
description: "Créer ou structurer un article de blog pour LPRP.fr. Utilise pour rédiger un nouvel article, transformer des notes en article structuré, ou les deux ensemble. Couvre cadrage, structuration des notes, rédaction, front matter, images, et vérification."
argument-hint: "Sujet, langue (fr/en), et optionnellement des notes à structurer"
---

# Créer ou structurer un article

Site : **LPRP.fr** — blog Jekyll. Règles mécaniques dans [`AGENTS.md`](../../../AGENTS.md). Style dans [`.agents/writing-style.md`](../../writing-style.md). **Lis les deux avant d'écrire.**

## Étape 1 — cadrage

Clarifier avant d'écrire :

1. **Sujet** — en une phrase. Si flou, reformule.
2. **Langue** — `fr` (défaut) ou `en`. L'anglais est une réécriture sèche, pas traduction.
3. **Angle** — retour d'expérience, test, tutoriel, comparatif ?
4. **Supports** — photos, captures, commandes, logs. Article sans images hors style.
5. **Des notes fournies ?** — Passe à l'étape 2 si oui. Sinon va à l'étape 3.

Vérifier dans le dépôt :

```bash
# articles proches du sujet
grep -ril "mot-clé" _posts/ | head
# catégories existantes
grep -E "^[A-Za-zÀ-ÿ]" _data/categories.yml
# tags utilisés (camel case)
grep -rn "^- Home Assistant$" _posts/ | head -3
```

Réutiliser tags et catégories existants. Si nouvelle catégorie : ajouter dans `_data/categories.yml` ET `menu:` dans `_config.yml`.

## Étape 2 — structurer les notes (si fournies)

**Trier le matériau** :

| Catégorie | Traitement |
|---|---|
| Fil narratif — ce qu'on a voulu faire, pourquoi, ce qu'on a rencontré | structure principale |
| Détails techniques — commandes, config, versions | intègrent le fil |
| Digressions — doutes, annexes | supprimer ou réduire |

Ne pas supprimer un échec — c'est le cœur du style.

**Accroche (2-3 blocs)** :
1. Phrase : sujet + enjeu.
2. Contexte : pourquoi l'auteur s'y est lancé.
3. Annonce : la démarche, l'angle.

**Plan** :
- Une `#` = une action concrète, infinitif ou étape.
- `##` = variantes, options, détails.
- Ordre : accroche → [ synthèse ] → # Étape 1 → # Étape 2 → # Conclusion → # Références.
- Minimum 4-5 `#` pour un article.

## Étape 3 — rédaction

Style de `.agents/writing-style.md` :

- **Voix** : « J'ai… », « Dans mon cas… », « Personnellement… ».
- **Code** : commandes réelles, dans l'ordre, commentaires utiles. Si sortie terminal : garder ou reformater.
- **Difficultés** : ce qui n'a pas marché et le contournement.
- **Images** : une capture par étape, après le paragraphe qu'elle illustre.

Pas d'invention : pas de commande imaginée, pas de capture fictive. Si info manque et nécessaire : marquer `<!-- à compléter : X -->`.

## Étape 4 — conclusion (si pertinent)

- **Article a taught quelque chose** → `# Conclusion` : résumé et usages possibles.
- **Test ou comparatif** → conclusion contient verdict et chiffres.
- **Note courte** → pas de conclusion.

## Étape 5 — références (si pertinent)

Sous `# Références` ou `# Liens` :
- Ne citer que sources consultées.
- Articles du site : `{% link _posts/2026/2026-01-31-sujet.md %}`, jamais URL en dur.
- Si pas de source : ne pas inventer la section.

## Étape 6 — front matter

```yaml
---
title: "Titre"
lang: fr
date: 2026-11-01
image: files/2026/vignette.jpg
categories:
  - Catégorie
tags:
  - Tag1
  - Tag2
---
```

**Point clé** : `date:` = date du nom de fichier, sinon URL et date divergent.

## Étape 7 — vérification

Contrôle statique :

```bash
bash .agents/scripts/check-post.sh _posts/2026/2026-11-01-slug.md
```

Si Ruby disponible, build prod :

```bash
bundle exec jekyll build --config "_config.yml,_config_prod.yml"
```

Relire en entier : titre, chapeau, plan, code, images à leur place, conclusion, références.

## Livraison

- Un seul fichier ajouté + les images.
- Si nouvelle catégorie ou tag structurant : le dire explicitement.
- Rappeler le chemin et l'URL resulting.

# AGENTS.md — LPRP.fr

Blog personnel **LPRP.fr** — Jekyll 4.2.2, layouts et plugins maison, bilingue FR/EN.
Format standard, lu nativement par Claude Code, GitHub Copilot, Cursor et Codex.

**Ne jamais casser le build** : la CI construit et déploie sur `main` à chaque push.

```bash
bundle exec jekyll build --config "_config.yml,_config_prod.yml"   # = la CI
./serve.sh                                                          # local :4000
```

## Où aller

| Tu vas… | Lis |
|---|---|
| créer ou modifier un article | skill `nouvel-article` + `.agents/writing-style.md` (front matter, images, liens, classes CSS, style) |
| structurer des notes ou un texte en vrac | skill `article-depuis-notes` (accroche, plan, conclusion, références) |
| produire une vignette, une capture, un schéma | skill `creer-image` |
| traduire, ou garder les versions FR/EN cohérentes | `.agents/writing-style.md` § Traductions |
| toucher aux layouts, plugins, config, Sass, `_data` | `.agents/site-architecture.md` |
| vérifier avant commit | skill `verifier-build` |

Tout est dans `.agents/` ; `.claude/skills` est un lien symbolique vers `.agents/skills`.
Structure : `_posts/YYYY/`, `_pages/`, `_layouts/`, `_includes/`, `_sass/`, `_plugins/`,
`_data/`, `files/YYYY/` (images), `assets/` (thème), `_drafts/` (brouillons).

## Règles qui ne pardonnent pas

- Fichier d'article : `_posts/YYYY/YYYY-MM-DD-slug.md`. Le slug **est** l'URL
  (`/YYYY/MM/slug/`) : minuscules, tirets, sans accents ni espaces. `date:` du front
  matter = date du nom de fichier.
- Images dans `files/YYYY/` (pas `assets/`), référencées
  `![alt]({{ 'files/2026/x.png' | relative_url }}){: .img-center .mw80}` — le
  `{: ... }` sur la **même ligne**.
- Lien vers un article : `{% link _posts/2026/2026-01-31-sujet.md %}`, jamais une URL
  en dur (elle casse au renommage).
- `categories` prises dans `_data/categories.yml` ; `tags` en camel case.
- L'anglais est une **réécriture**, pas une traduction. Les versions FR/EN sont liées
  par un `lang-ref` commun : toute modification de l'une se répercute dans l'autre.
- Un article publié ne se modifie pas sans le dire ; `last_modified_at` si le contenu
  change.

## Vérifier

```bash
bash .agents/skills/nouvel-article/scripts/check-post.sh _posts/2026/2026-10-25-sujet.md
```

Le build réel reste la référence. Si Ruby manque, dis-le explicitement et fais au
maximum les contrôles statiques.

Notes de l'auteur (classes CSS, front matter) : `_drafts/archives/site-doc.md`.

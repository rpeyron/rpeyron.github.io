#!/usr/bin/env bash
# Contrôle statique d'un article Jekyll du site LPRP.fr.
# Usage: bash .agents/skills/nouvel-article/scripts/check-post.sh <article.md> [article2.md ...]
#        bash .agents/skills/nouvel-article/scripts/check-post.sh --all   (tous les _posts/)
#
# Ne remplace pas un build Jekyll (bundle exec jekyll build) : c'est le filet de
# sécurité quand Ruby n'est pas disponible.

set -uo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)" || exit 2

if [ "${1:-}" = "--all" ]; then
  mapfile -t FILES < <(find _posts -name "*.md" ! -name "_blank.md" | sort)
  TOTAL_ERR=0
  for f in "${FILES[@]}"; do
    out=$(bash "$0" --one "$f" 2>&1)
    n=$(printf '%s' "$out" | grep -c "^ERREUR")
    [ "$n" -gt 0 ] || continue
    printf '%s\n' "$out" | grep -E "^ERREUR|^\-\-\-|^RÉSULTAT"
    TOTAL_ERR=$((TOTAL_ERR + n))
  done
  echo "---"
  echo "TOTAL: $TOTAL_ERR erreur(s) sur ${#FILES[@]} article(s)"
  [ "$TOTAL_ERR" -eq 0 ] || exit 1
  exit 0
fi

if [ "${1:-}" = "--one" ]; then
  shift
  FILE="${1:-}"
  if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "usage: $0 --one <chemin/vers/article.md>" >&2
    exit 2
  fi
  # le corps du contrôle commence plus bas, dans la même fonction shell
  # (on sort de la branche --one juste avant)
else
  if [ "$#" -lt 1 ]; then
    echo "usage: $0 <chemin/vers/article.md> [...] | --all" >&2
    exit 2
  fi
  TOTAL_ERRORS=0
  for FILE in "$@"; do
    bash "$0" --one "$FILE" || TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  done
  [ "$TOTAL_ERRORS" -eq 0 ] || exit 1
  exit 0
fi


ERRORS=0
WARNINGS=0
err() { echo "ERREUR  $*"; ERRORS=$((ERRORS + 1)); }
warn() { echo "AVERT.  $*"; WARNINGS=$((WARNINGS + 1)); }
ok() { echo "ok      $*"; }

# ---------------------------------------------------------------- front matter
# Les articles de 1995-2004 (migrés de l'ancien site) n'ont pas de front matter :
# ils restent valides tels quels. Avertissement, pas erreur.
FIRST_LINE=$(head -1 "$FILE" | tr -d '\r')
FM_END=$(awk 'NR>1 && /^---[[:space:]]*$/ {print NR; exit}' "$FILE" | tr -d '\r')
if [ "$FIRST_LINE" != "---" ]; then
  warn "pas de front matter (le fichier ne commence pas par '---') : article ancien ?"
  [ -n "${FM_END:-}" ] || FM_END=0
  [ "$FM_END" -gt 0 ] || warn "aucun front matter détecté : les champs ne sont pas vérifiés"
fi

if [ "${FM_END:-0}" -gt 0 ]; then
  ok "front matter fermé ligne $FM_END"
fi

BODY_START=$((FM_END + 1))
BODY=$(tail -n +"$BODY_START" "$FILE")

# ---------------------------------------------------------------- champs
# tr -d '\r' : les fichiers migrés depuis WordPress ont des fins de ligne CRLF,
# le \r resterait sinon collé à la valeur extraite.
fm() { sed -n "2,${FM_END}p" "$FILE" | tr -d '\r' | grep -E "^$1:" | head -1 | sed -E "s/^$1:[[:space:]]*//; s/^['\"]//; s/['\"]$//"; }

if [ "${FM_END:-0}" -eq 0 ]; then
  # pas de front matter (articles de 1995-2004) : champs non vérifiables
  warn "front matter absent : champs non vérifiés"
  CATS=""
  TAGS=""
else
  for field in title lang date image; do
    if [ -n "$(fm "$field")" ]; then
      ok "champ '$field' présent"
    elif [ "$field" = "date" ]; then
      # Jekyll retombe sur la date du nom de fichier : avertissement, pas erreur
      warn "champ 'date' manquant (Jekyll utilisera la date du nom de fichier)"
    elif [ "$field" = "image" ]; then
      # sans vignette, la carte affiche le logo par défaut : pas bloquant
      warn "champ 'image' manquant (la carte affichera le logo par défaut)"
    else
      err "champ '$field' manquant"
    fi
  done

  CATS=$(sed -n "2,${FM_END}p" "$FILE" | tr -d '\r' | sed -n '/^categories:/,/^[a-z_-]*:/p' | grep -E "^- " | sed 's/^- //')
  TAGS=$(sed -n "2,${FM_END}p" "$FILE" | tr -d '\r' | sed -n '/^tags:/,/^[a-z_-]*:/p' | grep -E "^- " | sed 's/^- //')
fi

[ -n "${CATS:-}" ] && ok "catégories: $(echo "$CATS" | tr '\n' ' ')" || warn "aucune catégorie"
[ -n "${TAGS:-}" ] && ok "tags: $(echo "$TAGS" | tr '\n' ' ')" || warn "aucun tag"

# catégories déclarées ?
while IFS= read -r cat; do
  [ -z "$cat" ] && continue
  if grep -qE "^${cat}:" _data/categories.yml 2>/dev/null; then
    ok "catégorie '$cat' déclarée dans _data/categories.yml"
  else
    err "catégorie '$cat' absente de _data/categories.yml (ajoute-la, ou choisis-en une existante)"
  fi
done <<< "$CATS"

LANG=$(fm lang)
case "$LANG" in
  fr|en) ok "lang '$LANG' valide" ;;
  "")     warn "pas de 'lang' (défaut du site : fr)" ;;
  *)      warn "lang '$LANG' inhabituel (attendu : fr ou en)" ;;
esac

TOC=$(fm toc)
case "$TOC" in
  1|2|3|true|yes|"") ok "toc '${TOC:-défaut}' accepté" ;;
  *) warn "toc '$TOC' inhabituel (attendu : 1, 2, 3 ou true)" ;;
esac

# ---------------------------------------------------------------- date vs nom de fichier
FN_DATE=$(basename "$FILE" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
FM_DATE=$(fm date | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}')
if [ -n "$FN_DATE" ] && [ -n "$FM_DATE" ]; then
  if [ "$FN_DATE" = "$FM_DATE" ]; then
    ok "date du nom de fichier == date du front matter ($FN_DATE)"
  else
    warn "date du nom de fichier ($FN_DATE) != date du front matter ($FM_DATE) : l'URL suit le front matter, la date affichée aussi"
  fi
else
  warn "impossible de comparer la date du nom de fichier et celle du front matter"
fi

# ---------------------------------------------------------------- slug
SLUG=$(basename "$FILE" .md | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')
if echo "$SLUG" | grep -qP '[A-ZÀ-Ý]'; then
  warn "slug '$SLUG' contient des majuscules (l'URL sera en minuscules, mieux vaut ne pas avoir d'écart)"
fi
if echo "$SLUG" | grep -qP '[^\x00-\x7F]'; then
  err "slug '$SLUG' contient des caractères non-ASCII : l'URL sera_slugifiée"
fi
if echo "$SLUG" | grep -q ' '; then
  # Jekyll slugifie les espaces en tirets : l'URL reste valide, mais un nom de
  # fichier avec des espaces est une source de quotation pénible
  warn "slug '$SLUG' contient un espace (l'URL sera slugifiée en tirets)"
fi

# ---------------------------------------------------------------- images
# Deux formes à extraire :
#   - Liquid : {{ 'files/AAAA/xxx.png' | relative_url }}   → chemin entre apostrophes
#   - Markdown : ![alt](files/AAAA/xxx.png)                → chemin jusqu'à la parenthèse
# Les noms historiques contiennent des espaces et des parenthèses, d'où la
# double extraction. Un chemin '/files/...' (slash initial) est la forme legacy :
# elle fonctionne, on la signale sans la traiter comme une erreur.
extract_images() {
  grep -oE "'files/[0-9]{4}/[^']+'" "$FILE" | sed "s/^'//; s/'$//"
  grep -oE "\(files/[0-9]{4}/[^)]+\)" "$FILE" | sed "s/^(//; s/)$//"
}

MISSING=0
while IFS= read -r img; do
  [ -z "$img" ] && continue
  case "$img" in
    /*) img="${img#/}" ;;
  esac
  if [ ! -f "$img" ]; then
    err "image absente du dépôt : $img"
    MISSING=1
  fi
done < <(extract_images | sort -u)
[ "$MISSING" -eq 0 ] && ok "toutes les images référencées existent"

# image: du front matter
IMG=$(fm image)
if [ -n "$IMG" ]; then
  case "$IMG" in
    /*) warn "vignette '$IMG' : chemin absolu. Préfère 'files/2026/xxx.jpg' (sans slash initial) pour les nouveaux articles" ;;
  esac
  IMG_PATH="${IMG#/}"
  if [ -f "$IMG_PATH" ]; then
    ok "vignette '$IMG' présente"
  else
    err "vignette '$IMG' absente du dépôt"
  fi
fi

# ---------------------------------------------------------------- liquid
# On analyse le corps HORS code : le plugin protect_code.rb protège au build les
# blocs ``` et l'inline `code`, où des {{ }} sont du code (JSON, Jinja, shell),
# pas du Liquid.
LIQUID_SRC=$(awk '
  /^```/ { inblock = !inblock; next }
  inblock { next }
  { print }
' "$FILE" | sed 's/`[^`]*`//g')

OPEN=$(printf '%s' "$LIQUID_SRC" | grep -o '{{' | wc -l)
CLOSE=$(printf '%s' "$LIQUID_SRC" | grep -o '}}' | wc -l)
[ "$OPEN" -eq "$CLOSE" ] && ok "accolades Liquid équilibrées hors code ($OPEN)" || err "accolades Liquid déséquilibrées hors code ({{ = $OPEN, }} = $CLOSE)"

# {% %} : on ne compte que les vraies balises Liquid. Un '%}' isolé vient
# souvent du CSS (ex. '.input {width:98%}') et n'est pas une balise.
TAGOPEN=$(printf '%s' "$LIQUID_SRC" | grep -o '{%' | wc -l)
TAGCLOSE=$(printf '%s' "$LIQUID_SRC" | grep -oE '\{%[^%]*%\}' | wc -l)
[ "$TAGOPEN" -eq "$TAGCLOSE" ] && ok "balises Liquid {% %} équilibrées ($TAGOPEN)" || err "balises Liquid déséquilibrées ({% = $TAGOPEN, fermées = $TAGCLOSE)"

if printf '%s' "$LIQUID_SRC" | grep -qE '\{\{[^}]*$'; then
  err "balise {{ non fermée en fin de ligne"
fi

# ---------------------------------------------------------------- structure
N_H1=$(printf '%s\n' "$BODY" | grep -c '^# ' || true)
N_H2=$(printf '%s\n' "$BODY" | grep -c '^## ' || true)
N_IMG=$(printf '%s\n' "$BODY" | grep -cE '!\[' || true)
N_CODE=$(printf '%s\n' "$BODY" | grep -c '^```' || true)
WORDS=$(printf '%s\n' "$BODY" | wc -w)

[ "$N_H1" -ge 2 ] && ok "$N_H1 sections '#', $N_H2 sous-sections '##'" || warn "seulement $N_H1 section(s) '#' : un article long en a généralement 4 à 8"
[ "$N_IMG" -ge 1 ] && ok "$N_IMG image(s) dans le corps" || warn "aucune image dans le corps (le site est très visuel)"
[ "$N_CODE" -ge 1 ] && ok "$((N_CODE / 2)) bloc(s) de code" || echo "info    aucun bloc de code"

if [ "$WORDS" -lt 250 ]; then
  warn "article court ($WORDS mots) : vérifier que c'est voulu (notes courtes = OK)"
elif [ "$WORDS" -gt 3000 ]; then
  warn "article long ($WORDS mots) : le site plafonne vers 2500 mots, mais c'est faisable"
else
  ok "$WORDS mots"
fi

# conclusion / références
if printf '%s' "$BODY" | grep -qiE '^# (Conclusion|Bilan|Références|Liens)'; then
  ok "section de conclusion ou de références présente"
else
  warn "pas de '# Conclusion' ni de '# Références' : usage constant du site"
fi

# ---------------------------------------------------------------- liens
if grep -qE '\]\(/[0-9]{4}/[0-9]{2}/' "$FILE"; then
  warn "URL d'article en dur détectée : préfère {% link _posts/... %} (robuste au renommage)"
fi

echo "---"
echo "RÉSULTAT: $ERRORS erreur(s), $WARNINGS avertissement(s)"
[ "$ERRORS" -eq 0 ] || exit 1

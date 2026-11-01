---
name: article-depuis-notes
description: "Transformer un contenu brut, en vrac ou non structuré (notes de travail, logs, transcription d'une séance, brouillon confus) en un article de blog structuré pour le site LPRP.fr. Utilise quand on demande de mettre en forme, structurer, réorganiser ou transformer des notes en article, ou de donner une accroche et un plan à un texte existant. Couvre le tri du matériau, la construction de l'accroche et de l'introduction, le plan, la conclusion et les références."
argument-hint: "Contenu brut à structurer, et ce que l'article doit démontrer"
---

# Transformer un contenu brut en article

Le site LPRP.fr publie des **retours d'expérience** : contexte, étapes, ce qui a marché,
ce qui n'a pas marché. Un texte en vrac n'a ni accroche, ni plan, ni conclusion. Ce
skill fait la passe de « notes » à « article ».

Les règles mécaniques (front matter, nommage, images, liens) sont dans
[`AGENTS.md`](../../../AGENTS.md), le style dans
[`.agents/writing-style.md`](../../writing-style.md). Ce skill décrit la **méthode de
structuration**.

Skills liés : `nouvel-article` (le squelette et le front matter), `creer-image` (les
captures à produire pour les étapes).

## Étape 1 — trier le matériau

Un contenu brut est un mélange de trois choses. **Sépare-les avant d'écrire** :

| Catégorie | Traitement |
|---|---|
| **Le fil narratif** — ce que j'ai voulu faire, pourquoi, ce que j'ai rencontré | structure principale |
| **Les détails techniques** — commandes, chemins, versions, config | intégrent le fil, dans le bon chapitre |
| **Les digressions** — digressions, scepticisme, digressions, détails annexes | supprimées, ou réduites à une ligne |

 techniques inutiles :

- commandes répétées ou sales (historique shell) ;
- debogage intermédiaire sans valeur pédagogique ;
- digressions ;
- ce qui est évident pour le lecteur visé.

**Ne supprime pas un échec.** « Cette méthode n'a pas fonctionné, en revanche… » est
au cœur du style du site : c'est souvent la partie la plus utile.

Confronte le matériau à ce qui existe déjà sur le site :

```bash
# un article traite déjà-t-il le sujet ?
grep -ril "mot-clé" _posts/ | head

# quelles commandes sont déjà expliquées ailleurs (éviter de recopier) ?
grep -ril "commande-clé" _posts/ | head
```

## Étape 2 — poser l'accroche et l'introduction

L'accroche est le passage qui fait comprendre **en 20 secondes** de quoi parle
l'article et pourquoi le lire. C'est la partie la plus difficile, et la plus rare dans
les textes en vrac : elle est généralement absente.

Structure en 2 à 3 blocs :

1. **La phrase d'accroche** — sujet + enjeu, en une phrase. Pas de formule creuse
   (« Dans le monde moderne… »), pas d'introduction de manuel.
2. **Le contexte** — pourquoi l'auteur s'y est lancé, ce qu'il avait avant, ce qui ne
   marchait plus. C'est ce qui rend l'article un retour d'expérience et non une
   notice.
3. **L'annonce** — ce que le lecteur va trouver : la démarche, l'angle, et si
   pertinent une synthèse « Si vous êtes pressés, en synthèse : » suivie de la liste
   des étapes.

Exemples tirés du site :

> Il est possible depuis peu de réutiliser les Facebook Portal rendus inutiles par
> l'arrêt du service en écrans connectés domotique.

> S'il est très facile d'augmenter la taille d'un disque virtuel sous Proxmox,
> l'opération inverse est nettement plus délicate. Lors de l'installation de Home
> Assistant, j'ai dû réduire un disque surdimensionné. Voici la procédure utilisée.

Le test : après l'accroche, le lecteur doit savoir **de quoi** ça parle, **pour
quoi** ça l'intéresse, et **ce qu'il va y trouver**. S'il ne sait pas encore s'il doit
continuer, l'accroche est à refaire.

## Étape 3 — construire le plan

Le plan se déduit du matériau, en gardant **l'ordre chronologique ou logique de
l'expérience** : c'est l'ordre dans lequel l'auteur a fait les choses, et il est
presque toujours le meilleur ordre pédagogique.

Une `#` = **une action concrète**. Titre à l'infinitif ou en nom d'étape :
« Installer mosquitto », « Réduire la partition », « Activer ADB ». Un `#` ne peut pas
être « Résultats », « Discussion » ou « Introduction » : le sommaire doit se lire comme
une liste d'actions.

Les `##` sont les variantes, options et détails d'une étape.

Ordre type :

```
accroche (2-3 paragraphes)
[ synthèse "si vous êtes pressés" + liste à puces ]
# Étape 1 …
# Étape 2 …
## variante
# Conclusion
# Références
```

Si le matériau ne permet pas de dégager 4 à 5 `#`, l'article est soit trop court (note
courte, 300 mots, pas de sommaire), soit confus : dans le second cas, demande à
l'auteur ce qui est le plus important avant de structurer.

## Étape 4 — rédiger

Applique le style de `.agents/writing-style.md` § Registre :

- **voix** : « J'ai… », « Dans mon cas… », « Personnellement… » ;
- **code** : commandes réelles, dans l'ordre, avec les commentaires utiles. Si le
  matériau contient une sortie de terminal, garde-la ; si elle est illisible,
  reformate-la ;
- **difficultés** : ce qui n'a pas marché, et le contournement trouvé ;
- **captures** : une par étape, insérée après le paragraphe qu'elle illustre (voir le
  skill `creer-image`).

**Ce qui n'est pas dans le matériau ne doit pas être inventé.** Pas de commande
imaginée, pas de capture fictive, pas de version de logiciel plausible mais fausse.
Si une information manque et qu'elle est nécessaire à la compréhension, marque-la
explicitement (`<!-- à compléter : version de Proxmox -->`) et signale-la à l'auteur
dans ta livraison.

## Étape 5 — conclusion

À ajouter **si pertinent** : ce n'est pas un remplissage obligatoire, mais le site y
a presque toujours recours, et c'est là que se trouve la valeur ajoutée.

Trois cas :

- **L'article a taught quelque chose** → une `# Conclusion` qui résume le résultat et
  donne les usages possibles. Souvent suivie de « D'autres usages sont bien sûr
  possibles. »
- **L'article est un compte rendu de test ou de comparatif** → la conclusion contient
  le verdict et les chiffres, pas un résumé de ce qui précède.
- **L'article est une note courte sans portée** → pas de conclusion. Ne gonfle pas le
  texte pour cocher une case.

## Étape 6 — références

À ajouter **si pertinent** : docs officielles, dépôts GitHub, discussions de forum,
billets du site. Le site utilise un lien par ligne, en Markdown, sous un titre
`# Références` ou `# Liens`.

- Ne cite que des sources **réellement consultées** : si tu n'as pas vérifié l'URL,
  ne l'invente pas.
- Un lien externe instruit (documentation officielle, dépôt du projet) vaut mieux
  qu'une liste de liens génériques.
- Les articles frères du site se citent avec `{% link _posts/2026/2026-01-31-sujet.md %}`,
  jamais avec une URL en dur.
- Si le matériau ne contient aucune source, n'invente pas de section Références : les
  commandes et les captures de l'article suffisent.

## Étape 7 — vérifier

```bash
bash .agents/skills/nouvel-article/scripts/check-post.sh _posts/2026/2026-10-25-sujet.md
```

Puis relis en jouant le rôle du lecteur, dans cet ordre :

1. **L'accroche** suffit-elle ? Un lecteur pressé s'arrête-t-il au bon endroit ?
2. **Le plan** se lit-il comme une suite d'actions ?
3. **Chaque étape** a-t-elle sa capture et sa commande ?
4. **La conclusion** apporte-t-elle quelque chose que le corps ne dit pas ?
5. **Les références** sont-elles toutes vérifiables ?

## Erreurs fréquentes

| Erreur | Correction |
|---|---|
| Chapeau générique en guise d'accroche | Contexte + enjeu + annonce, en 2-3 blocs |
| Plan en catégories (« Configuration », « Utilisation ») | Une `#` par action concrète |
| Suppression de l'échec | Le garder, c'est la valeur du retour d expérience |
| Conclusion qui répète le corps | Verdict, bilan, usages possibles |
| Références inventées | Ne citer que des sources vérifiées, ou pas de section Références |
| Matériau réorganisé dans un ordre « logique » théorique | Garder l'ordre de l'expérience |
| Article sans aucune image | Une capture par étape |

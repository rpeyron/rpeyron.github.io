---
title: AsciiMath - Formules mathématiques simples pour Jekyll
lang: fr
tags:
- Jekyll
- AsciiMath
- MathMl
categories:
- Informatique
modules:
- asciimath
date: '2023-05-27 19:09:09'
image: files/2023/asciimath_jekyll.jpg
---

Si avez déjà eu à réaliser des documents avec des formules mathématiques, vous savez sans doute que la Rolls de l'édition scientifique est TeX/LaTeX. Cependant, le langage n'est pas des plus simples à maîtriser, surtout lors d'un usage occasionnel, et s'il existe des éditeurs comme [Kile](https://apps.microsoft.com/store/detail/kile/9PMBNG78PFK3?hl=en-in&gl=in&rtc=1&activetab=pivot%3Aoverviewtab), [LyX](https://www.lyx.org/Home) ou [TeXmaker](https://www.xm1math.net/texmaker/) pour simplifier la vie sur l'édition d'un document, je n'ai pas trouvé d'équivalent pour utiliser avec Jekyll simplement.

# AsciiMath et MathML
Pour les quelques formules mathématiques que je suis susceptible d'utiliser sur mon blog, je cherche quelque chose de simple à utiliser et simple à mettre en place. Dans les différentes alternatives que j'ai regardées :
* [Typst](https://typst.app/) est une version moderne de TeX, à la syntaxe beaucoup plus simple ; malheureusement l'écosystème est encore assez pauvre, il y a un compilateur PDF open source, et un éditeur online ; pas d'intégration Jekyll identifiée
* [MathML](https://developer.mozilla.org/fr/docs/Web/MathML) est un langage XML pour écrire des formules ; il est désormais supporté par quasiment tous les navigateurs, ce qui en fait un très bon candidat. Cependant, compte tenu de sa syntaxe XML, c'est très peu pratique à écrire.
* [AsciiMath](http://asciimath.org/) a justement l'objectif de définir un langage très simple. En effet, pour la plupart des éléments basiques, c'est très proche de ce qu'on écrirait naturellement. 

Par exemple la formule : 

$$` "Aire d'un quart de cercle" = ( pi * "Rayon"^2 ) / 4 `$$

s'écrit en AsciiMath aussi naturellement que :
```asciimath
"Aire d'un quart de cercle" = ( pi * "Rayon"^2 ) / 4
```
*  Pour utiliser un mot ou une phrase au lieu d'une seule lettre, il suffit de mettre entre guillemets
*  La fraction est automatiquement prise en compte, et on peut utiliser des parenthèses pour expliciter ce que l'on veut y inclure
*  La mise en exposant utilise le classique `^`

# Déploiement AsciiMath

Le site [AsciiMath](http://asciimath.org/) propose deux types de déploiement :
* via [MathJax](https://mathjax.org/), une bibliothèque JavaScript très répandue pour l'édition de mathématiques en JavaScript, et qui permet notamment le rendu de formules TeX et AsciiMath dans un navigateur (avec des rendus HTML/CSS, SVG ou MathML au choix) ; la richesse de cette bibliothèque vient avec un coût : 117 fichiers pour 23 Mo si vous voulez l'auto-héberger. En utilisant la version CDN, et comme le moteur Markdown `kramdown`supporte nativement l'intégration de MathJax, l'intégration est assez simple (voir [cet article](https://medium.com/coffee-in-a-klein-bottle/creating-a-mathematics-blog-with-jekyll-78cdee0339f3) et modifier la configuration pour utiliser AsciiMath)
* via un simple fichier JavaScript avec rendu coté navigateur : [ASCIIMathML.js](https://github.com/asciimath/asciimathml/blob/master/ASCIIMathML.js) ; c'est cette dernière solution que j'ai trouvée la plus simple et efficace

Quelle que soit la solution choisie, le principe reste le même : il s'agit d'une bibliothèque JavaScript qui va cherche les formules mathématiques après le chargement de la page par le navigateur, puis remplacer la formule par le code MathML adéquat pour l'affichage de la formule. L'inconvénient est donc un léger temps de retard à l'affichage dans le navigateur. Il y a aussi une [version ruby](https://github.com/riboseinc/jekyll-asciimath) pour rendu coté serveur lors de la compilation par Jekyll, mais d'une part la version est plutôt ancienne, d'autre part, il est mentionné que cela ralentit considérablement la compilation. 

# Intégration  Jekyll
L'intégration Jekyll a nécessité un peu plus de travail car il faut trouver un bon équilibre entre:
* éviter l'interprétation par Liquid/Kramdown des éléments de syntaxe AsciiMath (par exemple pour ne pas convertir les `"` par leur élément typographique `“`; j'ai opté pour l'utilisation des séparateurs prévus pour MathJax par Kramdown `$$ <code mathjax > $$`
* utiliser les séparateurs natifs de AsciiMathML.js (backticks) car leur modification n'est pas très simple pour utiliser les séparateurs de MathJax (`[\    \]`  en paragrapge ou `(\    \)` en ligne )
* les backticks rentrent également en conflit avec la syntaxe markdown le séparateur des blocs de code en ligne

Bref, j'ai fini par opter pour une syntaxe proche 
```text
$$\` < formule AsciiMath > \`$$
``` 

Le dernier inconvénient de cette syntaxe est qu'elle fait apparaitre les séparateurs MathJax. J'ai donc ajouté un script de post-processing à la compilation du site qui va simplement retirer ces séparateurs surnuméraires

## Script pour supprimer les séparateurs MathJax
_plugins/asciimath.rb
```ruby
Jekyll::Hooks.register :documents, :post_render do |document|
    # Remove mathjax markers for asciimath code blocks (use $$\` <asciimath> \`$$)
    newContent = document.output.gsub(/\\\((\`[^\`]*\`)\\\)/m, "\\1")
    newContent = newContent.gsub(/\\\[(\`[^\`]*\`)\\\]/m, "\\1")
    document.output = newContent
  end
```

## Script pour inclure le javascript AsciiMath.js
à ajouter dans _layouts/default:
```
        <script src="{{ '/libs/ASCIIMathML.js' | relative_url }}"></script>
```
## Un brin de CSS pour ajouter la marge en bas de la formule

```
math {
  margin-bottom: 15px; // Replicate same as pargraph for ascimath
}
```

## Un brin de paramétrage de AsciiMathML.js
à modifier dans libs/AsciiMathML.js:
```
var mathcolor = "";        // change it to "" (to inherit) or another color
var mathfontsize = "1.2em";      // change to e.g. 1.2em for larger math
```

## Un raccourci dans ma version de jekyll-admin 
dans _config
```yaml
jekyll_admin:
  commandbar:
    shortcuts:
      'Asciimath': '$$\`  "rachat" =  "intérêts" * ("valorisation" / ("valorisation" * "capital") )   \`$$' 
``` 
Si vous êtes intéressés par les fonctionnalités ajoutées dans jekyll-admin comme la possibilité ci-dessus d'avoir des raccourcis, voir mon repository GitHub : [rpeyron/jekyll-admin](https://github.com/rpeyron/jekyll-admin) et la présentation de quelques-unes sur [la fin de cet article concernant ma migration sous Jekyll (en anglais)]({{ '/2022/10/migrate-to-jekyll/' | relative_url }})

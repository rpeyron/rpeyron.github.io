---
post_id: 4239
title: 'Archimate 3.0 en SVG'
date: '2020-02-22T12:06:09+01:00'
last_modified_at: '2020-03-21T14:27:56+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4239'
slug: archimate-3-0-en-svg
permalink: /2020/02/archimate-3-0-en-svg/
image: /files/2020/03/ArchiMate-SAFe.png
categories:
    - Divers
tags:
    - Archimate
    - Architecture
    - svgexport
    - vss2svg
lang: fr
---

Pour tout travaux d’architecture SI, le langage [Archimate](https://pubs.opengroup.org/architecture/archimate3-doc/) est un incontournable dont il serait dommage de se priver. Il est implémenté par bon nombre d’outils de cartographie payants très chers, mais également par un outil gratuit qui lui est dédié, [Archi](https://www.archimatetool.com/). Ce dernier est déjà très performant et s’étoffe de plus en plus, notamment avec une [bibliothèque de plugins non officiels](http://archi-contribs.github.io/) qui commence à grossir. Cependant, certains symboles n’ont pas leur forme sans rectangles, ce qui est parfois moins lisible : par exemple pour faire un diagramme de processus, le symbole actor sans son rectangle est bien plus parlant. Par ailleurs il peut être pratique d’utiliser la symbolique Archimate dans des outils plus classiques, comme Powerpoint.

# Convertir les symboles Archimate en SVG

L’OpenGroup publie les symboles officiels sous la forme de [stencils visio](https://publications.opengroup.org/i163) (sous licence Creative Commons Attribution 3.0 License) ; c’est très pratique si vous utilisez Visio, mais moins avec d’autres outils. Il est possible de convertir les stencils visio en SVG avec la bibliothèque [libvisio2svg](https://github.com/kakwa/libvisio2svg). Compte tenu des dépendances elle n’est pas très facile à compiler soi-même, mais des binaires sont proposés dans l’[issue 24](https://github.com/kakwa/libvisio2svg/issues/24) en packages rpm ou deb.

Une fois installé, pour convertir tous les stencils d’un seul coup :

```
ls | while read FILE ; do mkdir "$FILE""_dir" ; vss2svg-conv --input="$FILE" --output="$FILE""_dir" ; done
rename -e 's/Archimate 3.0 (.*) v1.0.vssx_dir/\\1/' *
```

Télécharger en SVG : [ArchimateStencils-3.0-SVG](/files/2020/03/ArchimateStencils-3.0-SVG.zip)

# Conversion en PNG

On a ainsi maintenant toutes les formes au format SVG. Cependant tous les outils n’aiment pas le SVG et préfèrent du SVG. Pour une conversion de bonne qualité j’utilise [svgexport](https://github.com/shakiba/svgexport) :

```
npm install svgexport
find . -iname '*.svg' | while read FILE ; do node_modules/svgexport/bin/index.js "$FILE" "$(echo $FILE | sed 's/svg/png/')" 100% 2x pad "text {display: none}" ; done
```

Quelques explications sur les options :

- 100% est pour spécifier la meilleure qualité
- 2x est pour un zoom x2 (car 1x est un peu petit et le PNG scale mal ensuite)
- “text {display:none}” est le style CSS pour supprimer le texte à l’intérieur de la forme : en effet en PNG il n’est plus éditable, et donc il faut le retirer avant la conversion

Télécharger en PNG : [ArchimateStencils-3.0-PNG](/files/2020/03/ArchimateStencils-3.0-PNG.zip)
---
post_id: 4222
title: 'Modélisation paramétrique dans Fusion 360'
date: '2020-01-25T19:28:07+01:00'
last_modified_at: '2020-01-25T19:28:07+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4222'
slug: modelisation-parametrique-dans-fusion-360
permalink: /2020/01/modelisation-parametrique-dans-fusion-360/
image: /files/2020/01/RobotStop_Parameters_Constraints.jpg
categories:
    - 3D
tags:
    - 3D
    - 'Fusion 360'
lang: fr
---

Pour le design de pièces 3D, j’aime beaucoup l’idée de [OpenSCAD](http://www.openscad.org/) de pouvoir modéliser une pièce via un langage de programmation, et la beauté de ce système est que l’on peut obtenir une pièce complètement paramétrable par les utilisateurs et ce assez facilement comme avec le Customizer de [Thingiverse](http://www.thingiverse.com).

Mais il faut reconnaître que, d’une part, ce n’est pas très ergonomique et pratique pour modéliser des pièces un peu complexes, et d’autre part, le langage est assez pauvre par défaut en primitives et manque notamment des courbes de Béziers, de la possibilité d’ajouter des fillets, qui sont quasiment indispensables pour une finition un peu sympa. Des bibliothèques existent pour ajouter plus ou moins bien ces fonctions, mais on perd alors la facilité d’utilisation d’un simple fichier à ouvrir avec OpenSCAD.

Par ailleurs, Fusion360 propose des fonctionnalités de modélisation paramétrique, et pour peu qu’on y fasse un peu attention, c’est très pratique et efficace. Le résultat reste tout de même moins simple à utiliser que via un Customizer de Thingiverse, mais cela me semble un bon compromis entre la facilité de modélisation et la facilité de customization pour les utilisateurs.

J’ai utilisé ces fonctionnalités pour les deux objets que j’ai modélisé pour éviter que mon robot Deebot 605 ne s’emmêle les roues dans mon étendoir à linge. L’un permet de garder [un espacement constant](https://www.thingiverse.com/thing:4126792) entre les deux tiges, et l’autre permet en se fixant sur une tige de [stopper le robot en offrant un obstacle à sa hauteur](https://www.thingiverse.com/thing:4126819). Pour que l’objet soit utilisable par d’autres, la capacité de paramétrage à d’autres matériels est importante.

Il suffit de suivre quelques points d’attention dans la modélisation :

- Lors de la construction d’éléments, qu’ils soient 2D ou 3D, il faut absolument taper une dimension au clavier pour qu’elle devienne paramétrable ; les autres dimensions qui dépendent simplement de la position de la souris ne créent pas de paramètres (et je n’ai pas trouvé de moyen de rajouter le paramètre a posteriori). Par exemple pour un rectangle qui doit être complètement paramétrable, positionner le rectangle a peu près comme souhaité, puis recopier les valeurs au clavier (avec &lt;Tab&gt; pour changer entre la hauteur et la largeur)
- Utiliser au maximum des méthodes de construction géométrique et utiliser les contraintes pour que le dessin se comporte comme vous le souhaitez lorsqu’un paramètre sera modifié. Quelques contraintes très utiles : 
    - Fixe : indique que l’élément sélectionné (par exemple un coté d’un rectangle) ne doit pas bouger lors de la modification d’un paramètre. C’est très utile par exemple pour que Fusion360 sache de quel coté faire varier un rectangle en modifiant une de ses dimension.
    - Lié : indique que les deux éléments sélectionnés doivent rester liés
    - Tangents : indique que l’élément doit rester tangent au cercle indiqué

![](/files/2020/01/RobotStop_Parameters_Constraints.jpg){: .img-center}

Ensuite tout se passe dans le menu Modify / Change parameters (à faire au fur et à mesure du dessin pour que ce ne soit pas trop compliqué) :

![](/files/2020/01/RobotStop_Parameters_Full.jpg){: .img-center}

- Ajouter en “User parameters” les différents paramètres que l’utilisateur va pouvoir choisir et qui vont être utilisables dans le dessin
- Puis changer tous les paramètres dans “Model parameters” de toutes les constructions faites pour être paramétrables en formules mathématiques qui dépendent des paramètres d’entrée ; il suffit d’entrer soit le nom du paramètre à utiliser, soit une formule mathématique avec les paramètres.
- Sauvegarder les formules (pour ne pas les perdre si besoin d’annuler en cas de problème sur un test), puis les essayer en ouvrant à nouveau l’écran et en modifiant les paramètres d’entrée (il faut tester à la hausse et à la baisse pour être sûr que les contraintes se comportent bien)
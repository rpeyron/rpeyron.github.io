---
post_id: 4211
title: 'Simulation de résistance sous Fusion360'
date: '2020-01-20T22:36:22+01:00'
last_modified_at: '2020-01-20T22:36:22+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4211'
slug: simulation-de-resistance-sous-fusion360
permalink: /2020/01/simulation-de-resistance-sous-fusion360/
image: /files/2020/01/AlexaHolder-Simulation-Fusion360-Initiale-Ressemblante.jpg
categories:
    - 3D
tags:
    - 3D
    - 'Fusion 360'
lang: fr
featured: 210
---

Un peu avant l’été, j’avais modifié un [support d’assistant vocal Alexa Echo Dot 3](https://www.thingiverse.com/thing:3845606) pour ajouter une anse, et pouvoir le suspendre à un crochet sans avoir à percer des trous dans mon mur en béton. Mais le Alexa Echo Dot est lourd, et pendant l’été, sans doute également à cause de la chaleur, le support s’est légèrement plié :

![](/files/2020/01/20190928_182903-225x300.jpg){: .img-center}

Plusieurs facteurs peuvent expliquer cette déformation :

- le modèle original était prévu pour avoir deux vis qui maintiennent la face arrière sur le mur et permettre donc de soulager les contraintes sur le dos assez étroit
- l’impression en PLA, qui n’est pas le plastique le plus solide, ni le plus résistant à la température.

J’ai alors cherché à modifier le modèle pour ajouter un peu de résistance, en premier lieu avec deux modifications un peu intuitives :

- supprimer le trou au milieu du dos qui reprenait le motif du logo Alexa, et introduit donc une fragilité supplémentaire dans le dos
- ajouter un renfort en dessous du support pour soulager la contrainte du poids de l’appareil qui père sur le bord bas du support.

Cependant ce n’est pas très scientifique comme méthode et j’ai cherché un logiciel qui permet de simuler la résistance des pièces, avec différents logiciels de simulation par la méthode des éléments finis (FEM) pour finalement me rendre compte que Fusion 360 met à disposition cette fonctionnalité dans sa version gratuite.

J’ai d’abord voulu reproduire la déformation que j’ai pu observer avec le modèle actuel. J’ai commencé en prenant simplement le modèle, en fixant l’anse et en appliquant sur la partie basse du support une force correspondant au poids de l’Alexa.

La simulation s’effectue très simplement, une fois positionnées les différentes contraintes, on peut vérifier le modèle, puis lancer la simulation. Par défaut Fusion360 propose un calcul de simulation sur leurs serveurs, mais c’est payant et les quelques crédits proposés gratuitement seront vite engloutis. Heureusement Fusion360 permet d’installer en local le solveur pour lancer les simulations en local sur son poste. Le résultat est plutôt satisfaisant pour un premier jet :

![](/files/2020/01/AlexaHolder-Simulation-Fusion360-Simple-257x300.jpg){: .img-center}

On voit bien la pliure au niveau du dos, mais ce n’est pas fidèle à l’observation sur la position verticale, car en fixant l’anse, on ne permet pas à cette dernière de pivoter sur le crochet. Par ailleurs, on ne voit pas l’effet du mur. J’ai donc opté pour modéliser une deuxième pièce qui va matérialiser le mur et le crochet sur lequel le support sera appuyé. J’ai également modélisé un Alexa très simplifié. La simulation est un peu plus complexe à mettre en place. Il faut fixer le mut et le crochet, et ré-activer la gravité (qui est désactivée par défaut). Par ailleurs il faut préciser que les contacts anse-crochet, support-mur, support-alexa peuvent glisser et pivoter. Pour cela il y a un mode “Separation” qui est adapté. Après quelques tatonnements, le résultat est assez ressemblant :

![](/files/2020/01/AlexaHolder-Simulation-Fusion360-Initiale-Ressemblante-259x300.jpg) ![](/files/2020/01/AlexaHolder-Simulation-Fusion360-Deformation-Modele-Redesigné-146x300.jpg)
{: .center}

A noter que mon PC portable vieux de bientôt 5 ans a commencé à montrer son grand age sur les simulations, surtout que le modèle initial était assez complexe, car issu d’un STL importé, avec toutes les faces que cela suppose, malgré les opérations de simplifications sur le modèle. J’ai donc fini par le re-modéliser sous Fusion360 pour que le modèle puisse être moins lourd et plus adapté pour la simulation.

J’ai ensuite apporté les modifications que je souhaitais, en supprimant les trous dans le dos du support, et en ajoutant un renfort en bas pour éviter que le bas se plie trop. Le résultat n’est pas visuellement très flagrant, on voit toujours le modèle se plier et peut être même un peu plus car avec le support l’effet de levier est plus important. On voit cependant le bas qui plie beaucoup moins, ce qui était le principal problème du modèle initial.

![](/files/2020/01/AlexaHolder-Simulation-Fusion360-Deformation-Modele-Renforce-183x300.jpg){: .img-center}

Cependant la simulation s’intéresse à des cas limite et augmente la déformation. Je vais donc tenter une impression et voir comment cela se comporte en vrai.

A noter que le module de simulation n’est pas toujours facile à dompter. Notamment, onn peut paramétrer le matériau utilisé. Malheureusement, le PLA n’est pas dans la liste des matériaux proposés par défaut, mais on peut en ajouter, pour peu de trouver les caractéristiques techniques (trouvées sur le forum de Fusion360). J’ai essayé avec du PLA et du plastique normal, et j’ai eu des résultats très surprenants :

![](/files/2020/01/AlexaHolder-Simulation-Fusion360-Resultat-délirant-en-plastique-137x300.jpg){: .img-center}

On y voit la partie haute qui passe au travers du modèle Alexa ! C’est absolument incompréhensible car il n’y a quasiment pas d’effort positionné sur cette partie, alors que la partie basse, qui supporte tout le poids, ne ploie pas. Les deux surfaces étant initialement assez éloignées, il n’y avait pas de contact identifié, ce qui explique que cette partie passe au travers du modèle. J’ai fait plusieurs tentatives avec du plastique (dur) et je suis toujours tombé sur cette situation incompréhensible. Au final, ce qui a donné les résultats les plus conforme à la réalité a été d’utiliser de l’acier comme matériau.

En conclusion le module de simulation de Fusion360 est plutôt pratique à utiliser, assez facile par rapport aux autres outils gratuits qu’on peut trouver et qui sont particulièrement complexes, mais qu’il me faut encore apprendre à dompter…
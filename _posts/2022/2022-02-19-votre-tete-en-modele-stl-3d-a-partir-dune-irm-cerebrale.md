---
post_id: 5642
title: 'Votre tête en modèle STL 3D à partir d&#8217;une IRM Cérébrale'
date: '2022-02-19T16:49:36+01:00'
last_modified_at: '2022-02-28T00:57:36+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5642'
slug: votre-tete-en-modele-stl-3d-a-partir-dune-irm-cerebrale
permalink: /2022/02/votre-tete-en-modele-stl-3d-a-partir-dune-irm-cerebrale/
image: /files/resonancia-magnetica-stockpack-adobe-stock.jpg
categories:
    - 3D
    - Informatique
tags:
    - 3D
    - DICOM
    - 'Fusion 360'
    - IRM
    - STL
lang: fr
modules:
  - gallery
featured: 220
---

À partir de résultats d’une imagerie par résonance magnétique (IRM) il est possible de découvrir le monde merveilleux de l’imagerie médicale, et même d’en créer des modèles 3D.

Je ne suis ni médecin ni professionnel de la santé, les éléments ci-dessous sont issus de rapides recherches sur Internet et ne sauraient constituer une quelconque expertise médicale.
{: .notice-note title="Disclaimer" style="--notice-color: #91110c;"}

# Présentation de la structure d’un CD de résultats d’IRM

À la fin d’un examen type IRM, les résultats sont souvent communiqués sous la forme d’un CD ou d’un DVD qui contient les images prises ainsi que le logiciel de visualisation. Ces fichiers sont au format DICOM ([Digital imaging and communications in medicine](https://fr.wikipedia.org/wiki/Digital_imaging_and_communications_in_medicine)), un standard pas tout récent puisque créé en 1985 pour les images en médecine. Ces fichiers sont fréquemment stockés dans un dossier “IMAGES”, le reste des fichiers étant généralement les programmes de consultation installés sur le CD pour différents systèmes d’exploitation. Le dossier est constitué d’une arborescence normalisée.

Exemple de l’arborescente d’un CD ou DVD DICOM :

![](/files/IRM-Structure-Fichiers.png){: .img-center .mw80}

On trouve plusieurs niveaux dans l’arborescence :

- Patient (PATxxx) : correspond au patient (en pratique un seul sur un CD d’un examen)
- Etude (STxxx) : correspond à un examen (en pratique un seul sur un CD d’un examen), qui comporte un ensemble de séries de clichés
- Série (SExxxx) : contient la série de clichés qui couvre la zone à observer avec certaines caractéristiques de prises de vue communes à la série au format DICOM

Exemple de contenu d’une série (répertoire SExxx) :

![](/files/IRM-Contenu-serie.png){: .img-center .mw80}

Chaque fichier est une image au format DICOM, qui va comporter l’image et tout un tas de méta données normalisées permettant de caractériser très exactement l’image, la technique de prise de vue, l’emplacement exact, le patient, le contexte de l’examen, etc.

La bonne nouvelle est que comme souvent pour les travaux issus de la recherche, il existe pas mal d’outils open source ou gratuits en utilisation non commerciale (en plus de ceux des équipementiers qui sont évidemment payants) qui permettent d’aller plus loin que la visionneuse incluse sur le CD. À peu près tous proposent les fonctions indispensables pour un usage médical, de navigation entre les clichés, mesures, contraste, etc. N’étant pas médecin, je ne m’étendrais pas sur ce type de fonction, mais sur des fonctions un peu plus en marge de la médecine. En voici deux particulièrement intéressants ci-dessous.

# MicroDicom viewer pour convertir en JPEG

Le premier logiciel est [MicroDicom viewer](https://www.microdicom.com/dicom-viewer.html) (gratuit en utilisation non commerciale) et permet entre autres d’exporter votre examen au format JPEG (avec ajout sur l’image des quelques métas données que vous aurez choisies). À noter que si le résultat permet de gagner beaucoup de place, c’est absolument déconseillé de s’en servir ensuite pour un usage médical, car la compression JPEG aura pu affecter des détails importants. Conservez donc soigneusement les images originales !

![](/files/IRM-MicroDicom-Floute.png){: .img-center .mw80}

Le menu File / Export permet d’exporter tout l’examen au format JPEG en gardant la même structure de répertoire

![](/files/IRM-MicroDicom-Export.png) ![](/files/IRM-MicroDicom-Export-Options.png)
{: .center }

Pour vous donner une idée des tailles :

- Taille du disque : 877 Mo
- Taille du dossier IMAGES : 802 Mo
- Taille après compression : 58 Mo

# 3DimViewer pour créer des modèles 3D en STL

Le second logiciel est [3DimViewer](http://www.3dim-laboratory.cz/software/3dimviewer/) et va permettre entre autres d’interpréter les séries DICOM et d’en créer des modèles 3D exportables en STL. Contrairement à MicroDicom viewer, celui-ci travaille uniquement sur une seule série de clichés, qu’il vous faudra donc choisir après avoir sélectionné votre répertoire d’images DICOM :

![](/files/IRM-3DimViewer-SelectSerie.png){: .img-center .mw80}

Les résultats seront très différents d’une série à l’autre, selon la technique de prise de vue qui va permettre de voir certains tissus ou non, et selon la résolution. Je vous conseille d’essayer en premier avec les séries ayant la meilleure définition (dimension de l’image et nombre d’images). Une fois l’analyse de la série effectuée, le logiciel affiche une visualisation 3D des volumes que vous pouvez inspecter sous toutes les coutures.

![](/files/IRM-3DimViewer-Volume-Flou.png){: .img-center .mw80}

Sur la droite il y a un certain nombre d’outils disponible, dont celui qui nous intéresse “Quick Tissue Model Creation” qui va permettre de créer un modèle STL. Il faut pour cela jouer avez les sliders pour trouver les bons seuils permettant d’éliminer les parasites et de garder les tissus souhaités. La création du modèle va prendre quelques minutes suivant la série et la puissance de l’ordinateur.

![](/files/IRM-3DimViewer-Model-267-Flou.png){: .img-center .mw80}

En faisant varier les seuils et les séries, on peut avoir des résultats plus ou moins différents.

![](/files/IRM-Cerveau-Flou.png){: .mw40} ![](/files/IRM-Cerveau2-Flou.png){: .mw40}
{: .center}

Le modèle est maintenant exportable via “File / Export STL Model” (compter entre 20 Mo et 100 Mo) et vous pourrez l’ouvrir dans un autre logiciel comme [MeshLab](https://www.meshlab.net/) pour nettoyer les petites imperfections du modèle et Fusion 360 pour réparer le modèle. On voit bien la marque du casque anti bruit de l’IRM autour des oreilles.

![](/files/IRM-MeshLab-Clean.png){: .img-center}

Il ne me reste plus qu’à trouver comment ne garder que l’extérieur pour pouvoir imprimer en 3D le modèle ainsi générer.

# Nettoyage et impression 3D du modèle

Le nettoyage du modèle n’est pas le plus simple, car le modèle généré est plutôt complexe. Après quelques essais avec [MeshLab](https://www.meshlab.net/) j’ai finalement opté pour [Fusion 360](https://www.autodesk.fr/products/fusion-360/personal) qui se révèle également redoutablement efficace pour travailler des maillages. En effet, il existe deux modes de travail différent dans Fusion360 : l’un dit “Solide” (“Body” en anglais), qui manipule des objets en 3D ‘natifs” dans Fusion 360. Ainsi une sphère est réellement une sphère, un cube réellement un cube, etc. L’autre mode est le mode “Maillage” (“Mesh” en anglais), qui manipule des maillages de triangles qui forment un objet 3D. C’est ce qu’on trouve dans des fichiers STL, et ce qui est utilisé pour l’impression 3D. Dans ce mode, une sphère n’est pas une sphère, mais tout un ensemble de petits triangles qui ensemble donnent l’illusion d’une sphère. Plus les triangles sont petits et nombreux plus la sphère sera précise (et plus la puissance de calcul nécessaire sera importante). Le fichier produit par 3DimViewer étant un fichier STL, c’est bien à un maillage auquel nous avons à faire.

L’import dans Fusion360 se fait via “Insérer” / “Insérer le maillage”. Première chose pour voir à quoi nous avons affaire, mettre une analyse de coupe, qui se fait très simplement via “Inspecter” / “Analyse de section”, puis sélectionner le plan horizontal et faire varier la hauteur de coupe. Vous obtenez ainsi une analyse de section qui est activable ou désactivable à l’envie en cliquant sur l’œil de la section Analyse dans l’arborescence des objets.

![](/files/IRM-Fusion360-RepairAndExplore.png){: .img-center}

Et là petite surprise, il y a plein de choses dans notre tête ! En effet, le modèle créé par 3DimViewer ne s’arrête pas à la surface, mais retraduit tous les tissus qui entraient dans les seuils indiqués. Cela explique notamment la taille très importante du STL généré, entre 20 et 100 Mo. Comme il serait dommage de perdre du temps d’impression à vouloir imprimer tous ces détails invisibles de l’extérieur, on a un peu de travail à faire pour nettoyer tout ça. Il y a également quelques petites imperfections à nettoyer.

Voici les étapes que j’ai suivies pour nettoyer le modèle :

1. Insertion du modèle
2. Comme on peut le constater, il y a sur la face du bas des trous vers l’intérieur
3. On va donc supprimer un certain nombre de faces du bas pour couper toute liaison entre l’extérieur et l’intérieur afin que la fonction suivante sépare bien extérieur et intérieur.
4. On peut ensuite demander à Fusion360 de générer les groupes de faces (dans Maillage, “Préparer” / “Générer les groupes de faces” ; cela va grouper par couleur les faces qui sont jointives.
5. Une fois les groupes de faces générés, on peut demander de les séparer via “Modifier” / “Séparer”, puis en sélectionnant le groupe de faces extérieur qu’on va utiliser par la suite. Une fois séparés, j’ai déplacé le nouveau maillage pour bien visualiser les deux, mais il suffit de masquer ce qui n’est plus utile.
6. On va ensuite nettoyer les quelques imperfections qui restent, notamment autour des oreilles, en supprimant tous les triangles des excroissances via “Modifier” / “Modification directe”, puis la sélection des faces à supprimer, puis “Supprimer”.
7. Une fois ces nettoyages faits, on va pouvoir utiliser la fonction de réparation des maillages, qui permet de retrouver un maillage “clos” sans trous. J’ai utilisé l’option “Reconstruire” qui a donné de meilleurs résultats dans mon cas.
8. Enfin j’ai finalisé en redressant le modèles de quelques degrés pour qu’il soit bien droit, en réduisant un peu la définition du maillage via “Modifier” / “Réduire” et en convertissant en objet solide via “Modifier” / “Convertir le modèle”. On obtient alors un objet solide, qui est donc “plein” à l’intérieur contrairement à notre maillage d’origine.

- ![Insertion du modèle](/files/IRM_Fusion360_Etape1.png)
- ![Comme on peut le constater, il y a sur la face du bas des trous vers l’intérieur](/files/IRM_Fusion360_Etape2.png)
- ![On va donc supprimer un certain nombre de faces du bas pour couper toute liaison entre l’extérieur et l’intérieur afin que la fonction suivante sépare bien extérieur et intérieur.](/files/IRM_Fusion360_Etape3.png)
- ![On peut ensuite demander à Fusion360 de générer les groupes de faces (dans Maillage, “Préparer” / “Générer les groupes de faces” ; cela va grouper par couleur les faces qui sont jointives.](/files/IRM_Fusion360_Etape4.png)
- ![Une fois les groupes de faces générés, on peut demander de les séparer via “Modifier” / “Séparer”, puis en sélectionnant le groupe de faces extérieur qu’on va utiliser par la suite. Une fois séparés, j’ai déplacé le nouveau maillage pour bien visualiser les deux, mais il suffit de masquer ce qui n’est plus utile.](/files/IRM_Fusion360_Etape5.png) 
- ![On va ensuite nettoyer les quelques imperfections qui restent, notamment autour des oreilles, en supprimant tous les triangles des excroissances via “Modifier” / “Modification directe”, puis la sélection des faces à supprimer, puis “Supprimer”.](/files/IRM_Fusion360_Etape6.png)
- ![Une fois ces nettoyages faits, on va pouvoir utiliser la fonction de réparation des maillages, qui permet de retrouver un maillage “clos” sans trous. J’ai utilisé l’option “Reconstruire” qui a donné de meilleurs résultats dans mon cas. </dd></dl> </div>Il ne reste plus qu’à exporter le résultat. On voit directement le résultat de la phase de nettoyage, car le fichier ne pèse plus qu’ 1,3 Mo !](/files/IRM_Fusion360_Etape7.png)
- ![Enfin j’ai finalisé en redressant le modèles de quelques degrés pour qu’il soit bien droit, en réduisant un peu la définition du maillage via “Modifier” / “Réduire” et en convertissant en objet solide via “Modifier” / “Convertir le modèle”. On obtient alors un objet solide, qui est donc “plein” à l’intérieur contrairement à notre maillage d’origine.](/files/IRM_Fusion360_Etape8.png)
{: .gallery .slide .gallery-thumbs .img-center }

Pour l’imprimer, j’ai opté pour les paramétrages suivants :

- Z = -1mm : Malgré le redressement du modèle, la face du bas n’est pas parfaitement plane. C’est un problème car Cura va chercher à faire une première couche non complète, ce qui risque de compromettre la suite de l’impression. Il aurait été possible de faire dans Fusion360 une découpe avec un plan horizontal, mais je n’y ai pas pensé. J’ai donc déplacé le modèle dans Cura de 1mm vers le bas, ce qui suffit pour que la première couche soit bien complète.
- Support = Tree : il faut des supports pour certaines parties, notamment le menton, les oreilles et le nez. Les supports classiques sont plutôt compliqués à retirer sur ce genre de modèles, j’ai donc essayé ces supports en arbre, qui reposent sur le plateau et non une autre partie du modèle, et ils sont beaucoup plus faciles à retirer sans abimer le modèle.
- Gradual Infill Step = 3 : inutile d’avoir un remplissage important sur ce modèle, mais il y a quand même besoin d’en avoir un peu pour maintenir la structure du crane ; cette option permet d’activer le remplissage progressif qui permet de densifier là ou il y a besoin, et ne quasi pas avoir de remplissage au milieu où il n’y a pas besoin.

Et c’est parti pour 3h15 d’impression !  
![](/files/IMG_20220227_224624.jpg){: .img-center .mw60}
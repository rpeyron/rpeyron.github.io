---
post_id: 2022
title: 'Travis, Github et doxygen'
date: '2017-11-05T11:57:21+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2022'
slug: travis-github-et-doxygen
permalink: /2017/11/travis-github-et-doxygen/
image: /files/2017/11/TravisCI-Full-Color.png
categories:
    - Informatique
    - libxmldiff
tags:
    - Blog
lang: fr
---

Dans la continuité de la migration des projets sur GitHub, l’ajout d’une intégration continue s’imposait. J’ai choisi [travis](https://travis-ci.org/rpeyron/), un des plus connus et qui a le mérite d’être gratuit pour les projets open source. Très puissant, il permet également d’autres intégration, comme la génération automatique de la documentation doxygen et de la publication sur les pages GitHub. C’est déployé uniquement pour libxmldiff pour l’instant car c’est le projet qui en a le plus besoin, mais les autres devraient suivre.

# Mise en place de Travis

La mise en place est très simple, en deux étapes :

1. L’inscription sur Travis (hyper simple en se connectant avec son compte github), et l’activation des projets à prendre en compte.
2. Le paramétrage du fichier de configuration .travis.yml

Cette deuxième étape est un peu plus complexe, et il y a peu d’exemples pour le C++. S’il existe une interface pour vérifier la syntaxe du fichier, il n’est pas possible de le tester avant de le commiter sur github, ce qui entraine donc un peu de tatonnements et commits surnuméraires…

Voici le fichier qui a fonctionné pour moi :

```yaml
language: cpp

sudo: enabled
    
before_install:
  - sudo apt-get -qq update
  - sudo apt-get install -y libxml2-dev libxslt-dev pkg-config autotools-dev automake autoconf libtool valgrind
  - autoreconf -f -i
  

```

Notez l’ajout de autoreconf car il y avait des problèmes de versions de aclocal avec la version que j’utilisais. Par ailleurs j’ai forcé le mode sudo pour ne pas être sur l’environnement docker car la gestion de package n’était pas reconnue par la vérification syntaxique.

La configuration par défaut de Travis lance également la cible make test. J’ai donc ajouté dans mon makefile un alias pour les cibles existantes. Travis prenant en compte les codes retours j’ai également corrigé la gestion du code de retour de mon script, un peu complexe à cause de l’éternel problème du partage de contexte entre sous process créés par l’utilisation de pipes. Malheureusement cela n’a pas suffit, la gestion des codes par make étant incompréhensible. L’état des tests est consultable dans la console de Travis, mais ne remonteera pas dans le statut de build.

Pour finaliser, il est possible d’ajouter le statut du build dans le README.md de github, en copiant le code qu’on obtient en cliquant sur l’image de statut de la page Travis et en demandant le code markdown.

# Génération automatique de doxygen

Il est possible de générer depuis Travis la documentation doxygen d’un projet, et de la mettre à disposition des pages GitHub. La documentation sera ainsi facilement accessible de tous, et mise à jour automatiquement à chaque commit. Il faut pour cela :

1. Créer une branche gh-pages qui ne contiendra que les pages pour les pages GitHub
2. Activer les pages GitHub sur la branche gh-pages
3. Créer un token GitHub pour que Travis puisse publier sur le projet et l’ajouter dans Travis
4. Ajouter un script de génération et publication des pages doxygen
5. Adapter le .travis.yml pour ajouter les étapes de génération

Pour l’essentiel, je me suis inspiré très fortement de [cette page](https://gist.github.com/vidavidorra/548ffbcdae99d752da02) qui explique très bien les différentes étapes, avec quelques différences :

- J’ai restreint la suppression des fichier au répertoire html pour permettre l’ajout d’autre contenus sur la page github
- J’ai supprimé le fichier .nojekyll pour conserver jekyll pour les autres pages
- J’ai remplacé la génération à l’intérieur du script par l’utilisation de ma target make dox, et le déplacement du répertoire produit dans le répertoire attendu via `mv ../../doc/html` .

Le fichier de configuration travis correspondant complété est :

```yaml
language: cpp

sudo: enabled

branches:
  except:
    - gh-pages

# From https://gist.github.com/vidavidorra/548ffbcdae99d752da02
env:
  global:
    - GH_REPO_NAME: libxmldiff
    - DOXYFILE: $TRAVIS_BUILD_DIR/doc/libxmldiff.dox
    - GH_REPO_REF: github.com/rpeyron/libxmldiff.git
    
before_install:
  - sudo apt-get -qq update
  - sudo apt-get install -y libxml2-dev libxslt-dev pkg-config autotools-dev automake autoconf libtool valgrind
  - sudo apt-get install -y doxygen graphviz
  - autoreconf -f -i
  
# Generate and deploy documentation
after_success:
  - cd $TRAVIS_BUILD_DIR
  - make dox
  - chmod +x doc/travis_dox.sh
  - ./doc/travis_dox.sh
```

A noter que ce fichier doit être sur la branch master et non pas la branche gh-pages, qui est ignorée pour éviter les boucles infines.

Au prochain commit, vous verrez donc à la fin de l’execution de l’intégration continue dans la console Travis les étapes after\_success, et l’apparition dans la branche gh-pages sous github du dossier html, que vous pouvez ensuite consulter via http://nomutilisateeur.github.io/nomduprojet/html/

Pour avoir une page d’accueil doxygen plus facile d’accès, vous pouvez ajouter une page en markdown. Il faut ajouter à votre fichier de configuration dox les commandes :

```
INPUT += doc/dox_main_page.md
USE_MDFILE_AS_MAINPAGE = doc/dox_main_page.md
```

That’s it !
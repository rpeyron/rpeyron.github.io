---
post_id: 4021
title: 'Sonarcloud et la qualimétrie logicielle'
date: '2019-03-29T17:21:27+01:00'
last_modified_at: '2019-03-29T17:21:27+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4021'
slug: sonarcloud-et-la-qualimetrie-logicielle
permalink: /2019/03/sonarcloud-et-la-qualimetrie-logicielle/
image: /files/2018/11/article-SonarCloud-Analysez-votre-projet-GitHub-via-VSTS.jpg
categories:
    - Informatique
tags:
    - GitHub
    - Prog
    - Sonarcloud
    - Travis
lang: fr
term_language:
    - Français
term_translations:
    - pll_5ed7e822d571a
---

Dans la continuité de la migration des projets sur GitHub, de l’ajout d’une intégration continue avec Travis-CI, l’étape d’après était d’ajouter de l’analyse de code, notamment sur le volet des vulnérabilités. J’ai choisi le scanner [S](https://travis-ci.org/rpeyron/)onar, et son portail Sonarcloud, un des plus connus et qui a le mérite d’être gratuit pour les projets open source. C’est déployé uniquement pour libxmldiff pour l’instant car c’est le projet qui en a le plus besoin, mais les autres devraient suivre.

# Mise en place

La mise en place se fait très facilement : il faut d’abord créer un compte sur [Sonarcloud.io](https://sonarcloud.io/) et y relier son compte github. Il faut ensuite configurer Travis-CI pour lancer l’analyse Sonar sur le projet et uploader les résultats sur Sonarcloud. Il y a une page d’aide très bien faite sur l’[aide de Travis-CI](https://docs.travis-ci.com/user/sonarcloud/).

Dans mon cas j’ai ajouté au fichier .travis.yml les lignes suivantes :

```
addons:
  sonarcloud:
    organization: "rpeyron-github" # the key of the org you chose at step #3

script:
  # other script steps might be done before running the actual analysis
  - autoreconf --force --install
  - ./configure  
  - build-wrapper-linux-x86-64 --out-dir bw-output make clean all
  - sonar-scanner
```

et généré dans Sonarcloud le token d’accès correspondant ajouté dans la variable d’environement SONAR\_TOKEN des paramètres du projet.

Il faut ensuite créer le fichier de configuration sonar : sonar-project.properties

```
sonar.projectKey=libxmldiff
sonar.projectName=libxmldiff
sonar.projectVersion=1.0

# =====================================================
#   Meta-data for the project
# =====================================================

sonar.links.homepage=/libxmldiff/
sonar.links.ci=https://travis-ci.org/rpeyron/libxmldiff/
sonar.links.scm=https://github.com/rpeyron/libxmldiff
sonar.links.issue=https://github.com/rpeyron/libxmldiff/issues
# =====================================================
#   Properties that will be shared amongst all modules
# =====================================================

# SQ standard properties
sonar.sources=src
sonar.tests=tests

# Specific for C
sonar.cfamily.build-wrapper-output=bw-output
sonar.cfamily.gcov.reportsPath=.
```

Chaque commit va provoquer l’activation de Travis-CI, qui va en plus des étapes précédentes va lancer l’analyse Sonar, et en cas de succès uploader les résultats sur Sonarcloud.io. Une fois fini il suffit de consulter les résultats sur la console Sonarcloud.io :

![](/files/2018/11/sonarcloud-overview.jpg)

Vous pouvez ensuite consulter chaque violation, et c’est vraiment très pratique : il y a un sélecteur de violations pour filtrer les violations auxquelles vous voulez vous intéresser, puis en cliquant sur une violation, vous allez pouvoir voir :

1. le code source incriminé, avec la date d’introduction et le fautif (dans le cartouche rouge)
2. une explication de la violation avec ce qui est reproché et un exemple de code correspondant à la bonne façon de faire (en bas)

![](/files/2018/11/sonarcloud-violations.jpg)

Les violations sont classés en trois catégories :

- bugs : celles qui peuvent mener à ce que l’application plante (ex : ne pas vérifier qu’un pointer n’est pas nul avant d’y accéder)
- vulnerabilities : celles qui peuvent provoquer des problèmes de sécurité (ex : ne pas faire attention aux débordement avec snprintf)
- code smells : celles qui ne sont pas des bonnes pratiques pour un code maintenable

Vous pouvez également décider de ne pas corriger certains problèmes. Pour que ce soit complet, il ne manque que la possibilité de créer des issues à partir des violations à corriger et la possibilité d’éditer et tester directement le code depuis le navigateur. Peut-être est-ce disponible dans la version premium, mais c’est déjà très bien de pouvoir disposer de cette puissance en gratuit.

Pour ma part j’ai choisi de corriger les catégories bugs (13 bugs) et vulnerabilities (2), car c’est les deux qui me semblent particulièrement prioritaires. Certaines sont d’ailleurs des faux positifs un peu trop compliqués pour le parser, mais je les ai quand même corrigés dans la forme visible pour le parser pour descendre à 0. Les code smells sont un peu nombreux et parfois discutables donc je ne m’y suis pas attaqué. Sonarcloud inclue également un indicateur “Quality gate” qui concerne le code récemment mis à jour et qui en gros dit que lorsque vous modifiez du code, celui-ci doit être nickel, donc petit effet de bord de la correction des bugs et vulnerabilités, je suis passé d’une quality gate verte mais avec des notes “D” (très mauvaises), à une quality gate rouge mais des notes “A”. Cela s’explique simplement parceque en corrigeant les bugs, j’ai modifié du code que sonar a donc considéré comme récent mais il reste les “code smells” précédent…

Vous pouvez inclure dans github les badges correspondant aux résultats de l’analyse en ajoutant dans votre README.md :

```
[![Build Status](https://travis-ci.org/rpeyron/libxmldiff.svg?branch=master)](https://travis-ci.org/rpeyron/libxmldiff)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=security_rating)](https://sonarcloud.io/dashboard?id=libxmldiff)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=reliability_rating)](https://sonarcloud.io/dashboard?id=libxmldiff)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=libxmldiff)
[![Sonarcloud Status](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=vulnerabilities)](https://sonarcloud.io/dashboard?id=libxmldiff)
[![Sonarcloud Status](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=bugs)](https://sonarcloud.io/dashboard?id=libxmldiff)
[![Sonarcloud Status](https://sonarcloud.io/api/project_badges/measure?project=libxmldiff&metric=alert_status)](https://sonarcloud.io/dashboard?id=libxmldiff)
```

Ce qui va donner en affichage :

![](/files/2018/11/libxmldiff-sonarcloud-badges-e1553561023301.jpg)

# Prochaines étapes

La prochaine étape devrait en principe être l’automatisation des tests et la couverture de tests. Cependant la solution actuelle “maison” de tests de non-régression donne pour l’instant satisfaction, et compte-tenu de la bonne stabilité actuelle de la solution, l’effort de développement des tests unitaires pour la couverture de test complète me semble trop important par rapport aux gains qu’on peut en attendre.

La prochaine étape sera sans doute d’une part de généraliser CI &amp; analyse de code à mes autres projets, et également d’automatiser le processus de releases, notamment avec la production automatique des binaires pour les plateformes supportées, ainsi que leur publication.
---
post_id: 2042
title: 'Passage sous aptly de mon repository debian'
date: '2017-12-31T17:53:44+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2042'
slug: passage-sous-aptly-de-mon-repository-debian
permalink: /2017/12/passage-sous-aptly-de-mon-repository-debian/
image: /files/2017/10/debian_1508005209.png
categories:
    - Informatique
tags:
    - APT
    - Debian
    - Linux
lang: fr
---

L’ancien outil [debarchiver](http://inguza.com/software/debarchiver) que j’utilisais alors se faisait vieux et capricieux, et le repository ne marchait plus. Un nouvel outil [aptly](https://www.aptly.info/) est apparu depuis et semble beaucoup plus performant. Voici donc mon nouveau repository :

```sh
# Add repository
sudo echo "deb [arch=amd64]  http://www.lprp.fr/debian stable main" > /etc/apt/sources.list.d/lprp.list
# Add apt key (remi+debian@via.ecp.fr)
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 090B93891134CECB
# Install
sudo apt-get install libxmldiff
```

Ci-dessous quelques indications pour créer un repository aptly

Je vous conseille d’installer au moins la version 1.2 depuis la distribution debian du site (celle de stretch est trop vieille et manque de fonctions bien utiles).

Le principe d’aptly repose sur l’utilisation d’une base de données locale (généralement dans $HOME/.aptly), puis ensuite de publications dans d’autres espaces.

Pour initialiser le fichier de configuration ($HOME/.aptly.conf) : `aptly config show `

Pour créer un repository local : `aptly -distribution=”stable” repo create local`

Si vous voulez publier en local, ajoutez votre répertoire comme indiqué dans le fichier de configuration :

```js
  "FileSystemPublishEndpoints": {
    "test": {
      "rootDir": "/opt/aptly-publish",
      "linkMethod": "copy",
      "verifyMethod": "md5"
    }
  },
```

(N’oubliez pas d’avoir les droits d’écriture sur l’endroit où vous voulez publier)

Puis pour publier : `aptly publish repo local filesystem:web:debian`  
Si vous avez besoin d’utiliser une clé GPG différente : `aptly -gpg-key=”remi+debian@via.ecp.fr” publish repo local filesystem:web:debian`

Pour les mises à jour : `aptly -gpg-key=remi+debian@via.ecp.fr -force-overwrite publish update stable filesystem:web:debian`  
(-force-overwrite est pratique pour débuter et mettre au point, mais à éviter par la suite)
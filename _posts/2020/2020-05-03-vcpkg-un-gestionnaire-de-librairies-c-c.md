---
post_id: 4301
title: 'vcpkg &#8211; un gestionnaire de bibliothèques C/C++'
date: '2020-05-03T21:17:21+02:00'
last_modified_at: '2021-06-25T21:38:26+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4301'
slug: vcpkg-un-gestionnaire-de-librairies-c-c
permalink: /2020/05/vcpkg-un-gestionnaire-de-librairies-c-c/
image: /files/2020/05/vcpkg.png
categories:
    - Informatique
tags:
    - developpement
    - microsoft
    - vcpkg
    - 'visual studio'
lang: fr
---

A chaque réinstallation de Visual Studio je râle contre la galère d’installer les différentes dépendances de compilation de mes projets, surtout une fois qu’on a goûté sur d’autres OS ou dans d’autres langages à des gestionnaires de packages comme sous linux, ou maven en java, pip en python, ou npm en js. Cela existe maintenant avec [vcpkg](https://github.com/microsoft/vcpkg) , open-source, multiplateforme, initié par Microsoft et alimenté par la communauté, une nouvelle preuve de la nouvelle orientation intéressante de Microsoft vers le développeur, l’open-source et Linux.

L’installation est un peu inhabituelle sous Windows puisqu’on va commencer par cloner le repository et compiler l’outil :

 ```
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
```

Ce qui au final est très agréable puisqu’on obtient un répertoire tout à fait portable.

Pour intégrer vcpkg à Visual Studio, il suffit de lancer :

 ```
vcpkg integrate install 
```

J’ai pris l’habitude pour simplifier la distribution de mes projets de toujours compiler en statique, pour éviter les dépendances avec les librairies Visual Studio, et devoir ainsi distribuer l’installateur correspondant. vcpkg intègre la possibilité de construire l’ensemble des bibliothèques avec des paramètres cohérents, regroupés sous l’appellation de “triplets”. Pour compiler en statique et en 32bits le triplet correspondant est “x86-windows-static”. Pour éviter de l’oublier j’ai ajouté un fichier batch “vcpkg-static.bat” qui contient simplement :

 ```
@vcpkg.exe --triplet x86-windows-static %*
```

Pour ajouter la configuration du triplet dans le projet, il faut éditer le vcxproj et ajouter dans le groupe de propriétés “Globals” la mention du triplet :

 ```
<PropertyGroup Label="Globals"> 
  <!-- .... --> 
  <VcpkgTriplet Condition="'$(Platform)'=='Win32'">x86-windows-static</VcpkgTriplet> 
  <VcpkgTriplet Condition="'$(Platform)'=='x64'">x64-windows-static</VcpkgTriplet> 
</PropertyGroup>
```

Ensuite pour installer un paquet, rien de plus simple :

 ```
vcpkg-static install wxwidgets
```

vcpkg télécharge et compile la bibliothèque demandée et ses dépendances. Pour wxwidgets tout s’est passé automatiquement sans problème et a pris 16 minutes. A noter que les paquets sources des bibliothèques jpeg, png, zlib &amp; co sont celles de vcpkg et non celles incluses dans wxwidgets. Vous n’aurez donc pas exactement le même nommage des bibliothèques à inclure à l’édition de liens (quelques préfixes wx à retirer, que l’on identifie assez simplement en observant le contenu du répertoire `vcpkg\installed\x86-windows-static\lib`

Attention vcpkg ne fait pas le ménage, et va vite prendre des gigas si vous n’y faites pas attention. Il suffit alors de supprimer régulièrement les répertoires intermédiaires de compilation et de téléchargement : `rmdir /s /q packages buildtrees downloads` (dans un vcpkg-clean.bat par exemple)

Je commence à aimer à nouveau Windows comme environnement de développement 😉
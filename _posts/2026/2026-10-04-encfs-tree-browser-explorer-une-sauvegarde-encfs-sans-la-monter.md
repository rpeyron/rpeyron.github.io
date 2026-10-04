---
title: encfs-tree-browser - explorer une sauvegarde encfs sans la monter
lang: fr
tags:
- encfs
- Web
- GitHub
- Typescript
categories:
- Informatique
toc: 2
ia: Claude Code, GitHub Copilot, Perplexity
date: '2026-10-04 19:00:00'
image: files/2026/vignette-encfs-tree-browser.jpg
---

[encfs-tree-browser](https://github.com/rpeyron/encfs-tree-browser) est une application web qui permet d’explorer l’arborescence d’un volume EncFS en affichant les noms de fichiers chiffrés et leurs noms déchiffrés côte à côte.

# Présentation

EncFS chiffre également les noms des fichiers et des répertoires. Sans monter le volume, il est donc difficile de savoir ce qu’il contient. C’est précisément le cas lorsque l’on accède à une sauvegarde chiffrée à distance, par exemple sur un stockage cloud, sans avoir la possibilité d’exécuter EncFS localement.

Dans ce contexte, l’application permet d’identifier les fichiers à télécharger avant de récupérer effectivement les données.

![Vue Browse avec agent local]({{ 'files/2026/browse-agent-view.png' | relative_url }}){: .img-center .mw80}

## Fonctionnement

L’application repose sur le fichier de configuration `.encfs6.xml` du volume, le mot de passe et le répertoire contenant les données chiffrées.

Elle propose deux modes :

- **Browse** : sélection d’un répertoire et affichage d’un arbre interactif, avec les noms encodés et décodés côte à côte 
- **Convert** : encodage ou décodage d’une liste de noms ou de chemins, collée directement dans l’interface ou chargée depuis un fichier.

![Onglet Convert avec arbre décodé]({{ 'files/2026/convert-view.png' | relative_url }}){: .img-center .mw80}

Dans l’arbre, il est possible de rechercher un fichier, de trier les entrées, de basculer entre les colonnes encodée et décodée, puis de copier le chemin complet correspondant. L’application permet aussi d’exporter l’arborescence en CSV ou JSON.


## Configuration et utilisation

Les configurations EncFS sont gérées depuis l’interface, à partir du fichier `.encfs6.xml` et du mot de passe. Le mot de passe reste en mémoire par défaut ; son enregistrement dans le navigateur est un choix explicite.

Le projet peut également être compilé en un unique fichier HTML autonome, utilisable hors ligne. L’onglet **Browse** nécessite Chrome ou Edge, via la File System Access API ; l’onglet **Convert** fonctionne dans les navigateurs modernes.

Pour accéder à des répertoires non couverts par cette API, l’application peut utiliser un petit agent local : il liste les répertoires accessibles par l’utilisateur, fournit les chemins absolus et sert l’interface depuis `localhost`. Ce mode est utile notamment pour parcourir des répertoires système, cachés ou distants montés localement.


## La bibliothèque encfs-names-ts

[encfs-names-ts](https://github.com/rpeyron/encfs-names-ts) est la bibliothèque TypeScript utilisée par `encfs-tree-browser`. Elle implémente l’encodage et le décodage des noms de fichiers et de répertoires EncFS, sans chiffrer le contenu des fichiers ni monter de système de fichiers.

Elle peut être réutilisée dans un projet TypeScript ou Node.js pour construire un outil d’inventaire, un script de conversion ou une interface spécifique.

```ts
import { readFile } from "node:fs/promises";
import { EncfsNameCodec } from "encfs-filename-codec";

const xml = await readFile(".encfs6.xml", "utf8");
const codec = await EncfsNameCodec.fromV6Xml(xml, "password");

const encryptedPath = await codec.encodePath("documents/report.txt");
const plaintextPath = await codec.decodePath(encryptedPath);
```


# Développement assisté par IA

Ces deux projets ont été développés avec une assistance importante de l’IA. 

Le point de départ a été une conversion automatique du code C++ et Rust d’EncFS vers TypeScript. Cette conversion a permis d’obtenir rapidement une première implémentation des algorithmes de chiffrement des noms, mais elle a aussi mis en évidence un écart de comportement entre les versions C++ et Rust : un bug a ainsi été identifié et signalé en amont.

La première version générée effectuait l’ensemble des calculs cryptographiques en TypeScript. Le résultat était fonctionnel, mais extrêmement lent. Une contrainte a été donnée à l'IA pour s’appuyer sur les fonctions natives de crypto disponibles via la Web Crypto API, ce qui a permis de déléguer les opérations lourdes au navigateur.

La validation a été facilitée par la génération d’un jeu de tests réel : des volumes EncFS ont été créés avec l’outil officiel afin de comparer les chemins encodés et décodés produits par l’implémentation TypeScript avec ceux du système d’origine.

L’interface a été construite de manière itérative : une première version a été générée à partir d'exigences initiales, puis affinées au fil des essais. Cette approche a permis de préciser progressivement les besoins réels, notamment sur la navigation dans l’arborescence, la conversion de listes de noms, la gestion des configurations et l’affichage des chemins encodés et décodés.

Les captures d’écran présentées dans cet article sont également générées automatiquement, à partir de la description des scénarios d’utilisation souhaités.

# Liens

- Application : [encfs-tree-browser](https://github.com/rpeyron/encfs-tree-browser)
- Bibliothèque : [encfs-names-ts](https://github.com/rpeyron/encfs-names-ts)
- Documentation EncFS : [vgough.github.io/encfs](https://vgough.github.io/encfs/)

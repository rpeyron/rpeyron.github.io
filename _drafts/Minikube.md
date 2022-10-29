---
post_id: 5746
title: Minikube
date: '2022-06-08T22:16:54+02:00'
last_modified_at: '2022-06-08T22:16:54+02:00'
author: admin
layout: post
guid: 'https://www.lprp.fr/?p=5746'
categories:
    - Général
lang: fr
---

En repartant de WSL2 + Docker-desktop + VMWare

scoop install minikube

minikube nécessite 2 cpus minimum, il faut donc modifier .wslconfig

- éditer .wslconfig, le sauvegarder sous un nouveau nom (le système refuse d’enregistrer un nom qui commence par .), supprimer le précédent et renommer en .wslconfig
- faire prendre en compte la nouvelle config : 
    - arreter wsl : wsl–shutdown
    - redémarrer docker : wsl -d docker-desktop-data
- installer minikube : minikube start

Pour que les services marchent (sinon restent en pending) : minikube tunnel
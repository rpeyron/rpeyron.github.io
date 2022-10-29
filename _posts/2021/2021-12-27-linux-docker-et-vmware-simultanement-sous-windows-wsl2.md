---
post_id: 5607
title: 'Linux, Docker et VMWare simultanément sous Windows / WSL2'
date: '2021-12-27T17:19:24+01:00'
last_modified_at: '2021-12-27T20:49:50+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5607'
slug: linux-docker-et-vmware-simultanement-sous-windows-wsl2
permalink: /2021/12/linux-docker-et-vmware-simultanement-sous-windows-wsl2/
image: /files/dock-container-export-stockpack-pixabay-scaled.jpg
categories:
    - Informatique
tags:
    - Docker
    - VMWare
    - WSL2
lang: fr
---

Il est maintenant possible d’utiliser simultanément Linux, Docker et VMWare sous Windows grâce à WSL2 et à la nouvelle couche Plateforme d’ordinateur virtuel de Windows, et ce même sur un Windows Home.

Voici les étapes que j’ai suivies :

# Installation de WSL2

1. Si vous avez une version de VMWare installée, commencez par la désinstaller
2. Depuis une ligne de commande Administrateur, activez WSL : `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all` , redémarrez
3. Toujours en ligne de commande Administrateur, activez la nouvelle plateforme de virtualisation : `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all` , redémarrez
4. Installez la mise à jour du kernel Linux disponible ici : <https://aka.ms/wsl2kernel>,
5. Activez WSL2 par défaut : `wsl –set-default-version 2`
6. Installez une version de linuw, par exemple ubuntu : `wsl –install ubuntu`

À présent vous devriez pouvoir lancer Ubuntu, qui va finir d’installer quelques composants puis vous demander la création de votre utilisateur Linux (login et mot de passe).

Vous pouvez également demander une mise à jour de WSL avec `wsl –update` , pour par exemple, mettre à jour le kernel avec la dernière version qui permet également une virtualisation du GPU NVidia (via des drivers beta NVidia supportant WSL2 GPU Paravirtualization).

À l’usage, WSL2 a un peu tendance à prendre toute la place mémoire disponible, avec un processus vmmem qui peut aller jusqu’à saturer votre mémoire et déclencher le swap. Pour éviter cela, vous pouvez contraindre les ressources associées. Pour cela, ouvrez le fichier de configuration avec `notepad “$env:USERPROFILE/.wslconfig”` (cela va sans doute vous proposer de créer le fichier s’il n’existe pas), et entrez et ajustez selon votre besoin les lignes suivantes :

```
[wsl2]
memory=4GB   # Limits VM memory in WSL 2 up to 4GB
processors=1 # Makes the WSL 2 VM use 1 virtual processors
```

Enfin, quand vous n’avez plus besoin des services tournant sur WSL2 et voulez récupérer les ressources associées, la commande magique est `wsl –shutdown`

# Installation de Docker

L’installation est super simple, il suffit de télécharger le package d’installation sur le site de Docker Desktop : <https://docs.docker.com/desktop/windows/install/> ; il devrait vous proposer automatiquement l’installation sur le backend WSL2.

Pour pouvoir utiliser docker directement depuis Linux, il faut activer l’intégration WSL et sélectionner la ou les distributions que vous utilisez.

![](/files/docker_wsl_integration.png){: .img-center}

# Installation de VMWare Player

L’installation est également très simple. Assurez-vous de [télécharger une version de VMWare Player](https://www.vmware.com/fr/products/workstation-player.html) plus récente que la version 15.5, lancer l’installation et c’est prêt !

## Désactiver les options de virtualisation

Vous aurez cependant peut être à modifier les paramètres de vos anciennes machines virtuelles si vous aviez activé certains paramètres tels que VT-x, ce qui est quand même assez problable. En effet, pour l’instant VMWare Player 16 refuse de se lancer avec WSL2 si cette option est activée. Et comme le contrôle de la virtualisation est pris par la Virtual Machine Platform de Windows, VMWare ne pourra plus se lancer.

Ainsi si vous avez dans vos paramètres :

![](/files/vmware_settings_before.png){: .img-center}

Alors décochez simplement les options de virtualisation :

![](/files/vmware_settings_after.png){: .img-center}

Je ne sais pas si on perd en optimisation, mais pour ma part, la machine virtuelle fonctionne encore tout à fait raisonnablement sans que je puisse dire s’il y a une dégradation ou non, donc ça me convient bien.

## Désactiver VPMC

Si malgré la désactivation de l’option “Virtualize CPU performance counters” ci-dessous vous avez le message d’erreur de VMWare ci-dessous :

```default
`Virtualized performance counters are not supported on the Host CPU type.Module VPMC power on failed. Failed to start the virtual machine``
```

Dans ce cas, il est probable que votre VM force son activation ; pour y remédier, éditez le fichier .vmx de votre machine virtuelle avec un éditeur de texte, et mettez à FALSE le paramètre vpmc (qui doit être à TRUE précédemment) :

```
vpmc.enable = "FALSE"
```

Il se peut également qu’une alerte sur le fonctionnement avec mitigations soit affichée au démarrage. Si c’est le cas, vous pouvez cliquer sur ignorer toujours, ou ajouter la ligne suivante dans le fichier .vmx

```
ulm.disableMitigations="TRUE"
```

# Autres problèmes potentiels

## Hyper-V est activé

Il se peut que le module Hyper-V soit activé et entre en conflit avec WSL2. Sur une version de Windows Home, Hyper-V est assez peu utile (et sur les autres versions, si vous utilisez Hyper-V il est probable que vous n’ayez pas vraiment besoin de VMWare et préfériez Docker avec Hyper-V). Assurez-vous de ne pas avoir Hyper-V activé dans les fonctionnalités facultatives (Paramètres / Applications / Fonctionnalités facultatives / Plus de fonctionnalités Windows) ![](/files/fonctionnalite_hyperv.png){: .img-center}

## VMWare n’arrive pas à installer ou désinstaller les pilotes de réseau virtuel

J’ai eu plusieurs fois le problème de VMWare qui bloque sur les pilotes de réseau virtuel. Installer, Réparer, rien n’y fait. La première fois, j’ai fini par complètement détruire ma stack réseau et devoir réinstaller intégralement Windows. La deuxième fois, en cherchant un peu plus *(mais je n’ai pas réussi à retrouver la source à l’écriture de cet article…)* j’ai trouvé l’astuce de nettoyer le registre de Windows avec la [version gratuite de CCleaner](https://www.ccleaner.com/fr-fr/ccleaner/download) avant de réinstaller. Et ça a marché !
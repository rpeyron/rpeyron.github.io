---
title: Rendre le Wi-Fi prioritaire à l'Ethernet sous Windows
lang: fr
tags:
- Windows
- Wi-Fi
- Ethernet
- Configuration
- Script
categories:
- Informatique
image: files/2023/windows-fast-wifi-bing-creator.jpg
toc: 'yes'
---

Par défaut, s'il existe simultanément des connexions Ethernet et Wi-Fi, Windows va privilégier la connexion Ethernet. Mais ce n'est pas toujours adapté, et il est heureusement possible d'inverser ce comportement.

# Pourquoi ?
La solution la plus simple est naturellement de débrancher le cable Ethernet...
Mais ce n'est pas toujours satisfaisant, notamment dans mon cas, la carte Ethernet est branchée sur un CPL, qui est déjà technologiquement dépassé sur le papier (500Mbps vs 1300Mbps pour le Wi-Fi ac), et encore plus compte tenu de mon réseau électrique un peu ancien et très exposé aux perturbations électriques des appartements voisins ce qui résulte dans un débit réel de 100 Mbps en moyenne pour le CPL, et qui peut chuter parfois à moins de 20 Mbps, voire couper complètement suivant les perturbations, souvent fortes le soir. Le Wi-Fi s'en sort généralement mieux malgré les murs en béton armé avec 200 Mbps. Cependant, le Wi-Fi souffre également de temps en temps d'instabilités et de déconnexions, ce qui fait que je souhaite tout de même que l'Ethernet soit branché, mais que Windows puisse privilégier le Wi-Fi quand celui-ci est disponible.

# Comment ça marche ?
Lorsqu'il y a plusieurs cartes réseaux sur un ordinateur, il doit avoir un moyen de trouver quelle carte réseau utiliser lorsque vous souhaitez vous connecter à Internet. Cela se fait via la notion de "métrique" qui indique "la difficulté" d'atteindre le réseau avec cette interface. Le système va alors sélectionner l'interface avec la métrique la plus faible.

Dans le détail, c'est un peu plus compliqué que cela, car l'exercice est appliqué à chaque route accessible par chaque interface, et met en œuvre des protocoles réseau de routage assez complexe, mais pour le cas qui nous intéresse, nous n'avons pas besoin de rentrer dans ces explications complexes.

Pour savoir quelle sont les métriques des interfaces de l'ordinateur on peut utiliser la commande `netsh` suivante :

![netsh interface ipv4 show interfaces]({{ 'files/2023/windows-default-metrics.png' | relative_url }}){: .img-center .mw80}

On voit ici que par défaut, l'interface Wi-Fi a une métrique de 45, et l'interface Ethernet une métrique de 25.  On retrouve bien ici que la connexion Ethernet, ayant une métrique inférieure, sera plus prioritaire que la connexion Wi-Fi. C'est ce que nous allons inverser.

# Configurer via les écrans des adaptateurs

La modification de la métrique d'une interface par les menus de configuration n'est pas très simple à trouver... 

Le paramétrage ne semble pas avoir encore été porté dans les nouveaux paramétrages de Windows 10/11, donc on va aller chercher l'ancien écran de paramétrage des adaptateurs réseau. Il est accessible via les paramètres Réseau et Internet, dans l'écran Paramètres réseau avancé, en cliquant sur l'entrée Options d'adaptateur réseau supplémentaires :

![]({{ 'files/2023/windows-options-adaptateurs.png' | relative_url }}){: .img-center .mw80}

Cela va ouvrir le panneau de configuration qui liste tous les adaptateurs déclarés. Cet écran est très utile, car il permet également de désactiver/activer le matériel pour le réinitialiser sans avoir à redémarrer, déclarer des bridges entre interfaces, et de nombreuses autres options avancées. La modification de la métrique d'une interface est accessible via les propriétés de l'interface :

![]({{ 'files/2023/windows-options-adaptateurs-proprietes.png' | relative_url }}){: .img-center .mw80}

Il faut ensuite sélectionner le protocole IPv4, cliquer sur propriétés, puis dans le nouvel écran, le bouton de paramètres avancés, puis dans le nouvel écran, décocher la métrique automatique et rentrer la valeur souhaitée. Nous allons mettre une métrique de 10 qui est inférieur à la valeur de 25 de l'interface Ethernet que nous avons vue avant.

Si l'interface est aussi configurée pour IPv6 il faut recommencer ces étapes en sélectionnant le protocole IPv6.

![]({{ 'files/2023/windows-options-adaptateurs-proprietes-ipv4-metric.png' | relative_url }}){: .img-center .mw80}

Il est ensuite nécessaire de désactiver et réactiver l'interface pour que la nouvelle métrique prise en compte immédiatement. 

En réinterrogeant les métriques des interfaces on peut bien constater la modification de valeur

![]({{ 'files/2023/windows-updated-metrics.png' | relative_url }}){: .img-center .mw80}

Maintenant, vous devriez constater que le trafic internet passe par cette interface.


# Configurer avec un script

Il faut beaucoup de clics pour changer le comportement, donc c'est quand même plus facile en script pour activer et désactiver à volonté. Et la bonne nouvelle est que c'est très simple dans un fichier .bat:
```batch
@echo off

netsh interface ipv4 show interfaces

REM netsh interface dump

REM Defaults metrics (Win 11)
REM - Ethernet : 25
REM - Wi-Fi    : 45

echo Make sure you have run this script as administrator
echo.
echo What do you want for Wi-Fi metric?
echo - Empty to Reset metric to default
echo - 10 to set to 10 (lower than default Ethernet)
set /p metric=Enter Wi-Fi metric: 

set wifi="Wi-Fi"

netsh interface ipv4 set interface %wifi% metric=%metric%
netsh interface ipv6 set interface %wifi% metric=%metric%

REM reset interfaces to enable new metric
netsh interface set interface %wifi% disable
netsh interface set interface %wifi% enable

netsh interface ipv4 show interfaces

pause Done
```

Une fois enregistré en .bat, il faut exécuter avec les droits d'administrateurs, via un clic droit.

# Mesurer de la vitesse de connexion
Si seule la vitesse de l'accès internet vous intéresse, il suffit d'utiliser un des nombreux _speedtest_ . Google propose également le sien accessible simplement en faisant une recherche sur le mot [speedtest](https://www.google.com/search?q=speedtest). 

Si vous vous intéressez à la vitesse de connexion à votre réseau local, il est nécessaire d'installer quelque chose qui permettra de mesurer la vitesse entre deux ordinateurs du réseau local. Certaines box ont la fonctionnalité directement incluses, c'est le cas de la Freebox, en se connectant en admin dans l'interface, dans les paramètres de la box, dans la section Divers, via l'entrée "Test de débit local". 

![]({{ 'files/2023/freebow-speedtest-local.png' | relative_url }}){: .img-center .mw80}

Pour ma part j'ai installé sur mon serveur web [cette simple application PHP](https://www.google.com/search?q=speedtest)  qui permet de calculer les débits locaux comme le ferait un speedtest.

![]({{ 'files/2023/html5-speedtest.png' | relative_url }}){: .img-center .mw80}

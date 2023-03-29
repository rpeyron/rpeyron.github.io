---
title: Répliquer une télécommande RF avec Raspberry Pi
'': fr
tags:
- domotique
- domoticz
- rtl-sdr
- raspberry
- rf
categories:
- Domotique
toc: 'yes'
image: files/2023/repliquer-rf-domoticz.png
date: '2023-02-18 17:00:00'
---

Pour mon premier bandeau LED, j'ai acheté un mini-variateur LED commandable avec une télécommande RF (Radio Fréquence). 

![]({{ 'files/2023/Mini-contr-leur-Led-DC-12V-6a-t-l-commande-RF.png' | relative_url }}){: .img-left.mw20 }  

Ça marche très bien, ce n'est pas cher, mais ce n'est pas possible de l'intégrer à un système domotique. Il existe bien sûr des systèmes domotiques complets, avec variateurs, interrupteurs et passerelles, mais ce n'est pas du tout le même tarif, et il s'agit souvent de solutions propriétaires fermées qu'il n'est pas possible d'intégrer à une solution libre. Il existe par ailleurs des variateurs Wifi, mais pas les deux Wifi + RF pour un ruban de LED monochrome. Ironiquement, cela existe pour des rubans RGB, mais malheureusement limités avec des ampérages qui ne permettent pas leur utilisation pour mon bandeau monochrome.  Me voici donc à la recherche d'une solution alternative... 

L'idée développée dans ce billet est de pouvoir émuler la télécommande RF depuis mon installation domotique sous Domoticz (lire les limitations de cette méthode dans la conclusion avant de vous lancer)

# Identification de la télécommande RF
La première étape consiste à identifier la télécommande pour pouvoir trouver le bon matériel à acheter. En effet, les modules RF ne sont pas les mêmes suivant la fréquence utilisée. Plusieurs possibilité pour identifier la fréquence :
- l'information est marquée quelque part dans la fiche produit de la télécommande ou du variateur
- vous ouvrez la télécommande et trouvez la référence sur internet, ou arrivez à lire la vitesse sur le quartz en espérant qu'elle corresponde à la fréquence utilisée
- vous achetez en aveugle des modules pour la ou les fréquences les plus fréquentes (433.92, 868, 315)
- vous analysez le signal émis ; c'est cette dernière option que j'ai choisie

Il existe certainement des analyseurs très évolués, mais je n'en dispose pas. La méthode que j'ai choisie d'utiliser s'appuie sur un dongle SDR (Software Defined Radio), dont le principe est d'avoir un matériel peu cher et de déporter le maximum du traitement du signal sur PC. L'écosystème est devenu assez formidable, et permet aussi bien de capter la TNT, la radio FM, la radio numérique DAB+ et bien d'autres protocoles, dont les transpondeurs des avions. 

![]({{ 'files/2023/rtl-sdr-dongle.png' | relative_url }}){: .img-right .mw20 }  

Pour ce faire, il suffit de s'équiper d'un dongle USB RTL2832U dont les premiers prix démarrent à moins de 15€ sur les sites chinois, pour des modèles de faible qualité, mais tout à fait utilisables. Le site https://www.rtl-sdr.com/, le site de référence en la matière, propose également sur son store un modèle équipé du même RTL2832U, mais avec une meilleure conception et de meilleurs composants pour recevoir un signal de meilleure qualité pour un peu plus de 30$ ([lire cet article d'essai du kit RTL-SDR par elektor](https://www.elektormagazine.fr/news/banc-essai-kit-rtl-sdr)). On va pouvoir utiliser ces dongles comme analyseurs de spectre pas cher.

Pour ce faire :
  - Télécharger [AirSpy SDR#](https://www.rtl-sdr.com/big-list-rtl-sdr-supported-software/)  et l'installer
  - Télécharger [Zadig](https://zadig.akeo.ie/) pour l'installation des drivers USB ; lancer Zadig en mode administrateur, il faut sélectionner dans la liste interface l'entrée qui ressemble à "RTL2832U" puis lancer l'installation ; l'installation est à renouveler pour chaque port USB différent que vous utiliserez
- Lancer AirSpy SDR# et sélectionner dans la listte RTL-SDR USB

Vous pouvez maintenant lancer l'acquisition et rechercher la fréquence ; je vous conseille de regarder autour des fréquences connues pour ce genre d'usage, en commençant par 433.92 MHz,  868 MHz et 315 MHz. Appuyez régulièrement sur la télécommande que vous voulez observer et regarder si le signal est modifié. Attention, il est probable qu'il y ait de nombreux autres signaux sur ces fréquences dans votre environnement.

En l'occurrence, la trace laissée par ma télécommande ressemble à :

![]({{ 'files/2023/sdr-find-frequency.png' | relative_url }}){: .img-center .mw80 }

On voit très clairement les taches rouges autour de la fréquence 433.92. Il ne nous faut pas plus d'information pour commander les modules de réception et émission en 433.92. Il existe pas mal de modèles de modules, avec différents niveaux de qualité sur le signal. Pour ma part, j'ai essayé les moins chers et ils ont raisonnablement bien fonctionné. Il faut deux modules, un pour la réception et un pour l'émission, et des antennes adaptées.

![]({{ 'files/2023/rf433-modules.png' | relative_url }}){: .img-center .mw60}

On peut aller théoriquement beaucoup plus loin avec SDR# et probablement décoder intégralement le signal, mais je ne suis pas suffisamment calé pour ça. Il existe [un grand livre SDR# en français](https://airspy.com/downloads/Le_Grand_Livre_de_SDRsharp_v5.5.pdf)  à télécharger sur le site AirSpy. Et si SDR# ne vous convient pas, il y a de nombreuses alternatives listées sur la page [rtl-sdr](https://www.rtl-sdr.com/big-list-rtl-sdr-supported-software/)

# Montage sur Raspberry Pi
Il y a plusieurs options pour utiliser ces modules, et notamment :
- brancher directement les modules sur un Raspberry pi  et utiliser les outils rpi-rf
- utiliser un équipement intermédiaire comme le RFLink qui utilise un arduino mega pour brancher tous vos modules et s'interface avec l'ordinateur en USB

J'aurai l'occasion d'utiliser le RFLink dans un prochain article, donc je vais ici utiliser la méthode du Raspberry pi, qui est la plus classique et directe. Cependant, compte tenu de la pénurie actuelle, et donc de l'impossibilité de remplacer un matériel abimé accidentellement dans l'opération, je vais utiliser un vieux Raspberry de première génération avec des connecteurs dupont, et réserver les soudures sur mon Raspberry zero pour plus tard.

Les branchements sont décrits sur la page du projet [rpi-rf](https://pypi.org/project/rpi-rf/) et il y a un tuto détaillé sur [instructables](https://www.instructables.com/RF-433-MHZ-Raspberry-Pi/). Voici ce que ça donne sur mon Raspberry :

![]({{ 'files/2023/rpi-rf-branchements.jpg' | relative_url }}){: .img-center .mw60}

# Lecture des signaux
Rien de plus simple pour lire un signal RF sur raspberry. Après avoir installé rpi-rf, il suffit de lancer la commande
```
rpi-rf_receive
```

Si vous avez utilisé des pins différentes pour brancher votre module, il faudra lui indiquer via l'option adéquate. 

Appuyez sur votre télécommande, vous allez voir les signaux apparaitre :

![]({{ 'files/2023/rpi-rf-receive.png' | relative_url }}){: .img-center .mw80}

Notez pour chaque bouton le code qui est le plus fréquent, avec les infos pulselength et protocol. Suivant votre télécommande, plusieurs combinaisons pourront alterner car sans doute assez proche. Dans ce cas, c'est l'essai de l'émission de signal qui permettra d'identifier quel est la bonne combinaison.

#  Émission des signaux

Rien de plus simple, c'est la commande symétrique 
```
rpi-rf_receive -t <protocol> -p <pulselength> <value>
```

![]({{ 'files/2023/rpi-rf-send.png' | relative_url }}){: .img-center .mw80}

Si votre lampe LED réagit c'est gagné ! Sinon, tentez votre chance avec d'autres combinaisons, vérifier le branchement de l'émetteur, et que le module à commander n'est pas trop loin.

# Conclusion mitigée

Vous pouvez maintenant intégrer directement cette commande comme action dans votre logiciel de domotique pour commander la lampe. 

Cependant, cette intégration domotique est assez peu satisfaisante, car le logiciel de domotique est aveugle sur le device commandé et ne connait pas son état. Et si les boutons de la télécommande ont seulement un effet relatif, comme un seul bouton Power pour allumer et éteindre avec le même bouton, ou des boutons "+" et "-" de luminosité, alors il est impossible de piloter l'équipement sans connaitre son statut (et notamment toutes les modifications potentiellement effectuées directement par la télécommande)

Pour résoudre ces problèmes, nous verrons dans un prochain billet comment utiliser l'autre option, à savoir l'[utilisation de variateurs Wifi intégrés à Domoticz]({{ '/2023/03/interrupteurs-rf-domoticz/' | relative_url }}) et en leur rajoutant des boutons de commande physique.

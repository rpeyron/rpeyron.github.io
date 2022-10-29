---
post_id: 2116
title: 'Récepteur infrarouge'
date: '2004-11-02T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2116'
slug: recepteurinfrarouge
permalink: /2004/11/recepteurinfrarouge/
URL_before_HTML_Import: 'http://www.lprp.fr/elec/ir/recepteurinfrarouge.php3'
image: /files/2018/11/infrarouge_1541191272.jpg
categories:
    - Informatique
tags:
    - Elec
    - OldWeb
lang: fr
lang-ref: pll_5bdcb7e9a5620
lang-translations:
    en: recepteurinfrarouge_en
    fr: recepteurinfrarouge
---


## Partie Electronique

Plusieurs montages circulent sur Internet. Le plus simple est sans doute de prendre un module récepteur infrarouge et de le connecter tel quel sur le port série, en plaçant uniquement une résistance entre RX et la masse. Même si ce schéma est rarement proposé, c’est de loin le plus facile à réaliser et pour mon cas, il marche très bien :

```
GND(5) o------------------+
                          |    +-------------------------+
                          |    |      SIEMENS 444        |
                          +----+ -    SFH 506-36         |
                               |      _____________      |
RTS(4) o-----------------------+ +                      |
             |                 |                    )    |
            | |                |      _____________/     |
            | | R2 (10K)  +----+ 
Nota : J'ai utilisé un récepteur de récupération, sensiblement différent du SIEMENS proposé.
```

Les broches indiquées entre parenthèses sont le numéro des broches pour des connecteurs SUB-D à 9 broches.

```
Nom          SUB-D25        SUB-D9      Utilisé pour

RTS            4               7        Source de courant
GND            7               5        Masse
DCD            8               1        Signal

```

Alternatives souvent proposées :

Celle avec régulateur marche souvent dans la plupart des cas. Je la conseille si la première méthode n’a pas marché.

```
C (10uF)
GND(5) o-------------+---------+---+
                     |         |   |    +-------------------------+
                 ---GND---   ----- |    |      SIEMENS 444        |
        1N4148 +-+IN  OUT+-+ ----- +----+ -    SFH 506-36         |
         | |  |  78L05 / |   |        |      ______________     |
RTS(4) o-| >|--+  -------  +------------+ +                      |
         |/ |  |                        |                     )   |
              | |                       |      ______________/    |
              | | R2 (10K)         +----+
```

```
GND o-----------------------+------+
                            |      |    +-------------------------+
                 C (10uF) -----    |    |      SIEMENS 444        |
 e.g. 1N4148  R1 (5K)     -----    +----+ -    SFH 506-36         |
      | |      _____    +  |           |      ______________     |
RTS o-| >|-----|_____|------------------+ +                      |
      |/ |  |                           |                     )   |
           | |                          |      ______________/    |
           | | R2 (10K)            +----+ 

```

Note : Le brochage d’un régulateur 78L05 est :

```
   1 2 3
  _______
 /             Pin1 = OUT
(  o o o  )     Pin2 = GND
        /      Pin3 = IN
   -___-

```



## Partie Informatique

Ce n’est pas tout de pouvoir récupérer le signal, il faut encore pouvoir le décoder. Le module fait déjà la majeure partie, en démodulant le signal envoyé par la télécommande.

La principale difficulté réside dans le fait qu’il existe beaucoup de protocoles différents : RC5, RCA, …  
Voici quelques adresses qui peuvent vous être utiles :

- [RCA code request form](http://www.parkwon.com/rcatest/form.htm)
- [Universal Remote Control Codes](http://www.xdiv.com/remotes/)
- [An analysis of IR signals used by a remote control](http://cgl.bu.edu/GC/shammi/ir/)
- [A Serial Infrared Remote Controller](http://www.armory.com/~spcecdt/remote/remote.html)
- [IR Remote System](http://web2.airmail.net/jsevinsk/ha/ir.html)
- [Systems Internals](http://www.sysinternals.com/)
- [Quelques infos sur les télécommandes IR](http://www.supelec-rennes.fr/ren/perso/jweiss/remote/remote.htm)
- [Universal Infrared Receiver](http://www.geocities.com/SiliconValley/Sector/3863/uir/index.html)

J’ai fait la synthèse des principales informations contenues dans ces pages en ce qui concerne le décodage de ces protocoles dans [ce fichier texte](/files/old-web/elec/ir/irremote.txt).

Voici un exemple de codes : [TV Philips](/files/old-web/elec/ir/philips_tv.cfg).



## Configuration Windows

Sous Windows, un excellent programme qui s’occupe de cela est [WinLIRC](http://home.jtan.com/~jim/winlirc/). Ce programme s’occupe de décoder les données arrivant sur le port série, en fonction d’un fichier de configuration décrivant la télécommande, et de mettre à disposition sur un port TCP/IP un identificateur simple de la touche appuyée. Ce programme est basé sur LIRC, dont nous parlerons plus tard.

La configuration se fait très simplement, soit en indiquant directement le fichier de configuration et le numéro de port, soit en enregistrant le fichier de configuration soi-même en appuyant successivement sur tous les boutons de la télécommande et en donnant leur signification. A noter que cette dernière procédure ne marche pas pour l’instant pour toutes les télécommandes.

Une fois lancé, WinLIRC se place dans la TrayBar et envoie les données sur un port TCP/IP. Le bouton est jaune lors de la configuration, vert si le décodage a été effectué avec succès, rouge si une touche n’a pas été conprise.  
Vous pouvez trouver une version de WinLIRC [ici](/files/old-web/elec/ir/winlirc-0.6.zip). La version sur le site de [WinLIRC](http://home.jtan.com/~jim/winlirc/) sera évidemment plus récente.

L’utilisation de ces données décodées se fait ensuite programme par programme. Un plugin a été développé pour WinAmp, pour permettre de commander la lecture de ses fichiers audio par infra-rouge. Vous pouvez trouver ce plugin sur la page de WinLIRC, ou encore [ici](/files/old-web/elec/ir/gen_ir-0.2.zip).  
La configuration en est fort simple :

- Assurez vous que WinLIRC fonctionne correctement.
- Copiez le gen\_ir.dll dans le répertoire plugin de winamp.
- Configurez ce plugin (onglet General Purpose), en faisant correspondre le nom de la touche donné par WinLIRC (par exemple POWER) à une action de WinAmp.
- Activez le plugin

Il faut donc un plugin spécifique à chaque programme. [Girder](http://www.girder.nl) est un excellent freeware qui se chargera d’effectuer de multiple tâches, bouger la souris, envoyer des touches à des applications,… un must !

Je suis actuellement en train de développer d’une part, un programme permettant de décoder une de mes télécommandes non reconnues par WinLIRC, et d’autre part un programme basé sur LIRC, mais capable d’envoyer n’importe quel touche, ou encore n’importe quel message à des applications. Ce programme n’est pour l’instant pas très avancé et je risque de ne pas avoir beaucoup de temps pour le développer dans les prochaines semaines.



## Configuration Linux

Sous Linux, vous avez la possibilité de faire à peu près n’importe quoi avec votre télécommande, du pilotage d’applications à l’émulation de souris. Tout ceci est possible gràce à un logiciel : [LIRC](http://www.lirc.org) (Linux Infra Red Control). Une version est disponible [ici](/files/old-web/elec/ir/lirc-0.6.2.tar.gz).

Ce programme installe un module qui permet de décoder les signaux de la télécommande et de les mettre à disposition dans un device (/dev/lirc). LIRC comprend :

- **lircd** : le démon, qui s’occupe de convertir les signaux de la télécommande.
- **irexec** : un programme capable de lancer n’importe quelle commande lorsqu’une touche est pressée.
- **irrecord** : pour enregistrer les codes de votre télécommande.
- **irw** : pour voir les touches enfoncées.

### Configuration de lircd

- Vous devez premièrement compiler LIRC, ce qui se fait simplement en tapant ./configure et en sélectionnant le port du récepteur, puis `make` et `make install` (en root).
- Vous devrez ensuite installer le module si le chargement n’est pas automatique : `modprobe lirc_serial`.
- Il faut ensuite créer un fichier de configuration à l’aide de irrecord, sauf si vous en trouvez un tout fait sur la page de [LIRC](http://www.lirc.org).
- Lancez ensuite le démon `lircd`
- Vérifiez votre configuration en exécutant `irw` et en pressant une touche. Vous devriez voir apparaître le nom de la touche pressée. Si ce n’est pas le cas, vérifiez le fichier de log /var/log/lircd.

### Configuration de irexec

Vous pouvez maintenant passer à l’étape suivante, celle de de la configuration de irexec, c’est à dire celui qui va faire quelque chose, concrêtement.

Plutôt que de vous faire de longs discours scabreux, je vais uniquement vous recommander d’aller lire la documentation dans le répertoire doc de lirc, pour créer le fichier **lircrc**. Vous pouvez aussi vous inspirer de [mon fichier de configuration](/files/old-web/elec/ir/lircrc).

### Configuration de Xmms

Quoi de plus agréable que de pouvoir piloter winamp. Les développeurs ont pensé à tout, et un plugin pour xmms est sorti. Vous pouvez trouver le dernier sur la page software de [LIRC](http://www.lirc.org) ou une version [ici](/files/old-web/elec/ir/lirc-xmms-plugin-1.1.tar.gz).

Reste ensuite à le compiler et à l’installer. L’installation pose parfois quelques problèmes, dûs à des librairies qu’il cherche au mauvais endroit. Une solution est de recopier cette librairie : `cp /usr/local/lib/liblirc_client.so.0.0.0 /usr/lib/liblirc_client.so.0.0.0`  
Ceci effectué lancez xmms à partir d’un terminal pour pouvoir vérifier qu’il n’y a pas de problèmes lors du chargement du plugin et activez le.

Comme vous avez pu le constater dans mon fichier de configuration et dans la documentation de lirc-xmms-plugin, la commande de xmms se fait au travers de irexec, et du fichier lircrc. Les fonctionnalités essentielles sont reprises dans [mon fichier de configuration](/files/old-web/elec/ir/lircrc).
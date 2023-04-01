---
post_id: 5211
title: 'Domoticz &#8211; Scénarios par Google Home ou Alexa avec HomeBridge'
date: '2021-01-16T16:45:17+01:00'
last_modified_at: '2022-08-07T22:05:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5211'
slug: domoticz-scenarios-par-google-home-ou-alexa-avec-homebridge
permalink: /2021/01/domoticz-scenarios-par-google-home-ou-alexa-avec-homebridge/
image: /files/smart-home-4905026_1280-alexa-home-domoticz-homebridge.jpg
categories:
    - Domotique
tags:
    - Alexa
    - Domoticz
    - 'Google Home'
    - Homebridge
    - Domotique
lang: fr
toc: true
---

Au fur et à mesure que je m’équipe en domotique, mes besoins augmentent et notamment celui de pouvoir déclencher des séquences préprogrammées à partir de Google Home ou Alexa.

# <span id="Installer_Homebridge">Installer Homebridge</span>

***Edit 12/06/2022 :** l’auteur du plugin [homebridge-alexa](https://github.com/NorthernMan54/homebridge-alexa) a rendu payant l’usage du service pour pouvoir payer les frais associés ; merci à lui d’avoir pu maintenir le service gratuit jusqu’à ce jour. Au jour où j’écris cet edit, le site homebridge.ca est même inaccessible. Les tarifs semblent être comparables suivant les différentes solutions disponibles et maintenant plus raisonnables qu’à l’époque de l’écriture de cet article. Pour une solution 100% gratuite, il reste toujours la possibilité d’auto-héberger une des solutions open source et de réaliser les déclarations auprès de Google et Amazon. Pour Alexa il existe également la solution ha-bridge (voir cet article pour [la configuration en remplacement de homebridge](/2022/08/piloter-votre-domotique-via-alexa-grace-a-ha-bridge-domoticz-ou-tasmota/)). Le plugin hombridge-gsh parait rester quant à lui intégralement fonctionnel et gratuit pour Google Home.*

Google Home ou Alexa proposent chacun la création de scénarios directement dans leur écosystème. Cependant comme j’utilise les deux et que je n’ai aucune envie de paramétrer les scénarios de chaque côté, je souhaite centraliser l’opération sur mon serveur domotique [Domoticz](https://www.domoticz.com/). Domoticz ne supporte pas nativement la connexion à Google Home ou Alexa, mais il existe un service payant pour ajouter cette fonctionnalité. Il existe néanmoins des alternatives gratuites, comme OpenHAB2 dont j’avais présenté [l’ajout à Domoticz dans un article précédent](/2019/03/domotique-avec-google-home/). Malheureusement j’ai rencontré par mal de problèmes de stabilité et à chaque fois que je souhaitais m’en servir OpenHAB2 était en vrac et nécessitait d’être redémarré, ce qui n’est pas vraiment pratique. J’ai finalement opté pour [Homebridge](https://homebridge.io/) dont la fonction initiale est de faire un pont avec l’univers domotique HomeKit (Apple), ce qui m’est parfaitement inutile en l’occurrence, mais qui dispose de nombreux plugins dont tout ce qu’il faut pour faire le pont entre Domoticz et les assistants Google Home et Alexa (et bien plus encore !)

![](/files/HomebridgePlugins.png){: .img-center}

L’installation se fait via npm et ne pose aucune difficulté en suivant [les instructions données sur le site](https://github.com/homebridge/homebridge/wiki/Install-Homebridge-on-Debian-or-Ubuntu-Linux), et celle des plugins est tout aussi facile :

- Homebridge Edomoticz permet d’exposer les différents appareils de Domoticz dans Homebridge. C’est très simple à configurer et le plugin importe automatiquement tous les appareils sans qu’il n’y ait rien besoin de faire. Si vous modifiez dans Domoticz un device et que la modification n’est pas prise en compte (par exemple en cas de renommage), il est possible de supprimer le cache dans le menu Réglages / Gérer les accessoires en cache de HomeBridge.
- Homebridge Alexa permet de contrôler tous les appareils connus de Homebridge depuis Alexa. La passerelle est réalisée par le site <https://www.homebridge.ca/> sur lequel il faut s’inscrire gratuitement, puis installer la skill ‘Homebridge’ depuis Alexa, et s’authentifier. Tous les devices sont alors importés et sont immédiatement commandables à la voix depuis Alexa. Si vous utilisiez un autre logiciel avant, comme moi avec OpenHAB2, Alexa ne supprime pas les équipements lors de la suppression de la skill concernée et il faut les supprimer un par un à la main.
- Homebridge Google Smart Home (homebridge-gsh) est l’équivalent pour Google Home. Il vous faudra relier votre compte Google et importer Homebridge dans Google Home.

L’ensemble se révèle pour l’instant très stable et je n’ai noté aucun dysfonctionnement comme je pouvais avoir précédemment.

# <span id="Un_bouton_virtuel_pour_commander_des_scenarios">Un bouton virtuel pour commander des scénarios</span>

Le seul petit souci est que eDomoticz ne gère pas les scénarios. L’auteur donne cependant une alternative très simple : il suffit de créer un bouton virtuel qui déclenchera l’activation du scénario. Depuis le menu “Matériel”, cliquer sur le bouton “Créer un capteur virtuel” du matériel “Dummy” (s’il n’est pas dans la liste, il suffit de l’ajouter en le sélectionnant dans la liste en bas).

![](/files/2020/12/domoticz_creer_capter_virtuel.png){: .img-center}

![](/files/domoticz_virtualsensor.png){: .img-center}

Retourner sur la page Interrupteurs, et modifier le nouvel interrupteur créé :

![](/files/domoticz_virtualswitch_scene.png){: .img-center}

Outre le nom et l’icône que vous pouvez changer à votre guise, on va changer deux paramètres :

- Le délai d’extension à 5 secondes : cela va permettre d’ “éteindre” l’interrupteur automatiquement au bout de 5 secondes pour que vous puissiez à nouveau l’utiliser. Comme vous l’avez compris, cet interrupteur est virtuel et son état n’est donc pas mis à jour. Vous pouvez aussi utiliser le mécanisme des dispositifs esclaves notamment si vous comptez pouvoir utiliser l’action d’extinction.
- Le champ Action On pour lui indiquer d’activer le scénario à activer. Le plus simple est de passer par l’API JSON et de renseigner donc l’URL correspondante, par exemple `http://localhost:9090/json.htm?type=command&param=switchscene&idx=1&switchcmd=On&passcode=` . Adaptez le port de votre serveur domoticz ainsi que l’identifiant de scénario à utiliser. Un moyen pratique pour trouver la bonne URL est d’ouvrir Domoticz depuis un navigateur sur le serveur, ouvrir les outils de développements, et dans l’onglet “Network” d’identifier l’adresse utilisée lorsqu’on active la scène via l’interface.

Pour que cela fonctionne, il faut que Domoticz autorise les connexions locales. Pour tester, il suffit d’utiliser curl :

```
curl 'http://localhost:9090/json.htm?type=command&param=switchscene&idx=1&switchcmd=On&passcode='
```

Si une erreur d’authentification est remontée, il faut aller dans les paramètres de Domoticz pour indiquer les adresses à considérer comme locales, et notamment ne pas oublier “::1” qui est l’équivalent de 127.0.0.1 en IPv6 :

![](/files/domoticz_reseauxlocaux.png){: .img-center}

A noter que si vous exposez Domoticz à l’extérieur via un reverse proxy comme Apache ou nginx, je vous conseille très vivement d’indiquer exactement la même chaîne de caractères dans les proxys :

![](/files/domoticz_remoteproxys.png){: .img-center}

Sans cela le fonctionnement de Domoticz est un peu confusant et il ne va regarder le champ X-Forwarded-For à comparer aux réseaux locaux uniquement pour les adresses IP sources indiquées dans RemoteProxyIPs. Ainsi si vous laissez le champ vide, comme les requêtes en provenance de Apache / Nginx sont en local (si sur le même serveur) alors l’ensemble du trafic sera considéré comme local ! Dans tous les cas, je vous recommande vivement de tester…

Désormais l’appui du bouton ou la commande vocale “allume” + bouton va activer le scénario !

# <span id="Des_scenarios_plus_riches_avec_Bockly">Des scénarios plus riches avec Bockly</span>

Les scénarios sont pratiques pour regrouper les équipements à allumer ou éteindre ensemble, mais assez limités pour aller plus loin et avoir des séquences automatisées plus complexes. Heureusement Domoticz a tout prévu et il y a de nombreux moyens d’ajouter des scripts. Il en existe un qui est assez fun et graphique, et qui permet de faire des scripts par simple assemblage de blocs. C’est également un bon palliatif si pour une raison ou une autre la méthode de l’API ci-dessus ne fonctionne pas, un simple script Blockly peut pallier le problème. il faut créer le script à partir du menu Réglages / plus d’options / Evènements, appuyer sur le “+” pour créer un script avec Blockly, et ensuite sélectionner et assembler les blocs avec le menu de gauche jusqu’à avoir :

![](/files/domoticz_blocky_scene1.png){: .img-center}

Ce script se lit de la manière suivante : la mention Trigger Device indique que le script sera déclenché à chaque évènement d’un device. Ensuite le bloc If test si le bouton “scene1” est activé, et si oui active le scénario qui nous intéresse.

On peut alors se passer complètement des scénarios et inclure tous nos équipements directement dans Blockly pour intégrer des scénarios plus complexes, comme :

![](/files/domoticz_blocky_videos.png){: .img-center}

Ce script va plus loin en prévoyant des séquences plus complètes pour automatiser une séquence d’opérations impossibles à réaliser avec des scénarios. Pour les fonctions n’étant pas disponibles directement depuis les blocs Blockly mais réalisable via l’API (en l’occurrence ici les touches médias de ma TV Panasonic), on peut ajouter un bloc Open URL pour solliciter l’API si l’appel d’API fonctionne bien, cf ci-dessus (ou se retrousser les manches et proposer une modification de code pour ajouter le bloc manquant).

Bon on ne va pas se mentir, même si c’est plus riche que les scénarios, on va vite atteindre d’autres limites qui vont inciter à passer par des “vrais” scripts plus riches comme dzVents ou Python, mais il faut reconnaitre que Blockly est vraiment fun et visuel 🙂

# <span id="Des_icones_personnalisees_pour_nos_boutons_virtuels">Des icônes personnalisées pour nos boutons virtuels</span>

Un dernier point pour affecter des icônes personnalisées à nos boutons virtuels, pour les faire mieux correspondre à leur nouvelle fonction. Domoticz propose dans le menu Réglages / plus d’options / Icônes personnalisées une façon simple d’en ajouter de nouvelles. Et pour que ça soit encore plus simple, il y a un service web (non officiel) [Domoticz Icon](https://domoticz-icon.aurelien-loyer.fr/) qui permet d’aider à la constitution des fichiers zip à importer dans Domoticz. Super simple. À noter que pour nos boutons virtuels, ils seront en règle générale à l’état “Off”, et l’état “On” n’est pas vraiment utile puisqu’il ne dure que cinq secondes. Donc personnellement j’ai utilisé les mêmes images pour les deux.

![](/files/domoticz_customicons.png){: .img-center}

C’est fini pour cette nouvelle fournée de customisations de Domoticz motivée par les nouvelles possibilités apportées par [les modifications du plugin Panasonic](/2020/12/domoticz-panasonic-remote-buttons-and-custom-urls/) et l’allumage [via la FireTV](/2020/12/firetv-sur-domoticz/) et bien que pouvant sembler anecdotique, se révèle bien agréable au quotidien.
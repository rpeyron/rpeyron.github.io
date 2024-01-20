---
title: Commandes RF pour Domoticz via rtl_433
lang: fr
tags:
- Domotique
- Domoticz
- RTL-SDR
- rtl_433
- dzVents
categories:
- Domotique
date: '2023-05-01 19:30:00'
toc: 'yes'
image: files/2023/interrupteur-rtl_433-domoticz.jpg
featured: 195
---

Cet article est une variante de la méthode exposée dans l'article [Commandez vos lumières avec des interrupteurs RF sous Domoticz]({% link _posts/2023/2023-03-19-interrupteurs-rf-domoticz.md %})  qui utilise une clé RTL-SDR au lieu d'un récepteur RFLink.

# Matériel
![]({{ 'files/2023/rtl-sdr-2832.jpg' | relative_url }}){: .img-right .mw20}
Dans cet article, le récepteur sera un récepteur RTL-SDR, c'est-à-dire un récepteur radio à décodage logiciel (SDR: Software Defined Radio) basé sur le chipset RTL2832U ([exemple ici sur AliExpress](https://fr.aliexpress.com/item/32900553328.html)), pour environ entre 10 et 50 euros selon la qualité. L'avantage de ce matériel est qu'il n'est pas spécialisé à la réception 433MHz et peut être utilisé sur plein d'autres projets (comme [dans cet article pour analyser le signal d'une télécommande]({{ '/2023/02/repliquer-une-telecommande-rf-avec-raspberry/' | relative_url }}) mais également pour recevoir la radio, la TNT, et même les signaux des avions.

Le modèle d'interrupteur reste le même ([interrupteur RF mural 433](https://fr.aliexpress.com/item/1005004791222586.html?spm=a2g0o.order_list.order_list_main.44.3cf75e5biYrDcm&gatewayAdapt=glo2fra), ou également des télécommandes RF "universelles") 

Vous pourrez ensuite paramétrer n'importe quelle action dans Domoticz. Dans mon cas cela commandera des bandeaux LED, mais ça pourrait être n'importe quoi d'autre.


# Paramétrage de rtl_433
## Installation et premier essai
Pour décoder les signaux de la télécommande nous allons utiliser l'excellent [rtl_433](https://github.com/merbanan/rtl_433). Il est disponible dans de nombreuses distributions, (`sudo apt install rtl-433` sous Debian/Ubuntu) mais comme il est régulièrement mis à jour avec de nouveaux appareils, cela peut être intéressant de l'installer manuellement (voir [docs/BUILDING.md](https://github.com/merbanan/rtl_433/blob/master/docs/BUILDING.md) pour les quelques étapes à suivre pour compiler avec cmake)

Par défaut, si on lance simplement `rtl_433` et qu'on appuie sur un bouton de l'interrupteur, rtl_433 va bien reconnaitre un signal, mais va l'interpréter comme un signal d'un détecteur de fumée ([Smoke GS558](https://github.com/merbanan/rtl_433/blob/ecb0b361ad487cfd9e66d4326797dbbac6b32d54/src/devices/smoke_gs558.c)):
```text
time      : 2023-05-01 15:39:52
model     : Smoke-GS558  id        : 32369
unit      : 11           learn     : 0             Raw Code  : 4fce2b
``` 

## Décoder le protocole EV1527
Dans l'absolu pour simplement détecter le signal ça pourrait être suffisant, mais pour l'intégration classique de rtl_433 dans Domoticz, il va être nécessaire d'avoir la définition d'un interrupteur ([Generic Remote](https://github.com/merbanan/rtl_433/blob/ecb0b361ad487cfd9e66d4326797dbbac6b32d54/src/devices/generic_remote.c)). Après quelques tentatives infructueuses, j'ai enfin repéré que la description de certains interrupteurs muraux ou télécommandes universelles mentionnaient l'utilisation de [EV1527](http://aitendo3.sakura.ne.jp/aitendo_data/product_img/wireless/315MHz-2012/RX315-HT48R/EV1527.pdf). Il s'agit d'une puce qui se charge du décodage/encodage de signaux 433 Mhz, avec un protocole qui lui est propre. La bonne nouvelle est que rtl_433 comporte déjà des définitions permettant de décoder EV1527. 

On va donc simplement désactiver la reconnaissance du protocole du détecteur de fumée pour voir s'il devient reconnu comme télécommande : `rtl_433 -R-86` (`-R` est l'option de sélection de protocoles, `-86` pour désactiver le protocole 86 qui correspond au détecteur de fumée, trouvé dans la liste que l'on obtient avec `rtl_433 -R`). Malheureusement, pour une raison qui m'échappe, le protocole générique ne semble pas reconnaître l'interrupteur. 

Il existe cependant d'autres solutions dans rtl_433, dont notamment le fichier [EV1527-4Button-Universal-Remote.conf](https://github.com/merbanan/rtl_433/blob/master/conf/EV1527-4Button-Universal-Remote.conf) dont le nom est très prometteur. Il s'agit de la configuration d'un récepteur très générique [flex](https://github.com/merbanan/rtl_433/blob/ecb0b361ad487cfd9e66d4326797dbbac6b32d54/src/devices/flex.c) et qui peut être paramétré dans le fichier de configuration de rtl_433, ou en ligne de commande via l'argument `-X` (en agrégeant toutes les lignes de l'intérieur des accolades sur une seule)
```
$ rtl_433 -R-86 -X 'n=EV1527-Remote,m=OOK_PWM,s=369,l=1072,g=1400,r=12840,bits>=24,repeats>=3,invert,get=@0:{20}:code:[123456:REMOTE-A 987654:REMOTE-B],get=@20:{4}:button:[1:A 2:B 3:AB 4:C 5:AC 6:BC 7:ABC 8:D 9:AD 10:BD 11:ABD 12:CD 13:ACD 14:BCD 15:ALL],unique' -F json

...
{"time" : "2023-05-01 15:43:32", "model" : "EV1527-Remote", "count" : 6, "num_rows" : 7, "len" : 25, "data" : "d473f10", "code" : 870207, "button" : "A"}
```

## Adapter la sortie pour Domoticz

Notre interrupteur est maintenant correctement reconnu par rtl_433, mais nous ne sommes pas au bouts de nos efforts car l'intégration Domoticz nécessite la présence de champs particuliers que nous pouvons voir dans le fichier du hardware Domoticz [Rtl433.cpp](https://github.com/domoticz/domoticz/blob/8e441bce6feebe77f71afb159bc227eb6c943f4f/hardware/Rtl433.cpp#L315) :
- il faut un champ `id` pour identifier l'interrupteur
- si on veut que chaque bouton corresponde à un interrupteur distinct dans Domoticz, il faut également un champ `channel`
- et l'appui doit correspondre à un champ `command=On`

Par chance, le décodeur `flex` utilisé est très configurable et va nous permettre d'ajouter ces fonctionnalités ; la lecture du code de [flex.c](https://github.com/merbanan/rtl_433/blob/ecb0b361ad487cfd9e66d4326797dbbac6b32d54/src/devices/flex.c#L535) permet de comprendre la syntaxe utilisée, dont je n'ai pas trouvé la documentation ailleurs ; ainsi dans l'extrait ci-dessus `get=@20:{4}:button:[1:A 2:B 3:AB 4:C 5:AC 6:BC 7:ABC 8:D 9:AD 10:BD 11:ABD 12:CD 13:ACD 14:BCD 15:ALL]` correspond à une commande `get` dont les paramètres, séparés par `:` (l'ordre n'est pas important)
- `@20` indique la sélection des bits à partir du 20ème bit
- `{4}`indique qu'une longueur de 4 bits sera sélectionnée
- `button`indique que le paramètre de sortie sera nommé button
- `[1:A 2:B 3:AB 4:C 5:AC 6:BC 7:ABC 8:D 9:AD 10:BD 11:ABD 12:CD 13:ACD 14:BCD 15:ALL]`indique un mapping optionnel entre la valeur lue et celle qui sera dans le message de sortie (liste `<valeur lue>:<valeur de sortie>` séparée par des espaces et entre crochets)

Ainsi pour satisfaire aux exigences de Domoticz, nous allons modifier le paramétrage du décodeur flex comme suit:
- `code` est à renommer en `id`
- `button` est à renommer en `channel`
- nous allons ajouter `param=On` en utilisant les fonctionnalités de mapping de `get` sur n'importe quel bit dont les valeurs 0 et 1 seront mappées sur On : `get:@0:{1}:command:[0=On 1=On]`

Encore une petite contrainte Domoticz, la méthode de protection contre les attaques via arguments de ligne de commande est un peu brutale et va remplacer notamment `'` et `/` ; cela ne nous permet donc ni de passer notre décodeur directement dans le paramétrage de rtl_433 du hardware, ni d'indiquer un chemin vers un fichier de configuration spécifique. Nous allons donc ajouter notre décodeur dans un des emplacements de configuration par défaut, dans `/etc/rtl_433/rtl_433.conf` pour ma part :

```text
decoder {
    n=EV1527-Remote,
    m=OOK_PWM,
    s=369,
    l=1072,
    g=1400,
    r=12840,
    bits>=24,
    repeats>=3,
    invert,
    get=@0:{20}:id,
    get=@20:{4}:channel,
    unique,
    get=command:@0:{1}:[0:On 1:On]
}
```

C'est fini coté rtl_433, il reste un peu de boulot dans Domoticz.

# Paramétrage de Domoticz
## Installation du matériel Domoticz rtl_433
Dans l'onglet Hardware, ajouter un équipement de type "Rtl433" et ajouter dans les paramètres la désactivation du protocole Smoke-GS558  `-R-86` (sauf si vous l'avez également inclus dans le fichier de configuration).

![]({{ 'files/2023/domoticz-rtl_433.png' | relative_url }}){: .img-center .mw80}

## Ajout des interrupteurs
Appuyez sur chacun des boutons que vous voulez ajouter. Puis dans l'écran "Device" de Domoticz, vous allez voir les nouvelles entrées détectées :

![]({{ 'files/2023/domoticz-device-rtl.png' | relative_url }}){: .img-center .mw80}

Cliquez sur la flèche verte sur la droite pour ajouter le bouton. Le bouton va être ajouté dans l'onglet "Interrupteurs" et prendre par défaut l'apparence d'une ampoule allumée. 

Cependant l'interrupteur ne peut pas encore fonctionner pour l'instant à cause d'une petite subtilité avec l'interface de rtl_433 qui ne permet pas d'envoyer une commande qui correspond déjà au statut de l'appareil. Or les interrupteurs que j'ai choisi sont des boutons poussoirs qui vont toujours envoyer une commande 'On'. Le fautif est le code [Rtl433.cpp](https://github.com/domoticz/domoticz/blob/8e441bce6feebe77f71afb159bc227eb6c943f4f/hardware/Rtl433.cpp#L323) utilise la fonction [SendSwitch](https://github.com/domoticz/domoticz/blob/afcf6d64fd3a62b590a1efde9d2e342fc76fb93f/hardware/DomoticzHardware.cpp#L721) qui vérifie l'état avant de lancer la commande ; il faudrait remplacer par la fonction SendSwitchUnchecked qui ne réalise pas cette vérification.



## Palliatif pour forcer le changement de statut

Pour pallier ce fonctionnement actuel, on va créer deux scripts qui vont forcer le retour à l'état 'Off' des interrupteurs :
- un premier va régulièrement forcer tous les interrupteurs RF à Off
- un second va immédiatement forcer l'interrupteur à actionner à Off

On pourrait se contenter du premier, mais cela ne permettrait pas des appels multiples rapprochés, par exemple pour sélectionner un type d'éclairage par appui successifs. Ou également se contenter du second, en forçant tous les interrupteurs Off à chaque fois, mais on a besoin au moins une première fois du premier pour réinitialiser le statut.

Pour fonctionner avec ces scripts, tous les switchs RF doivent être nommés avec le préfixe "RFSwitch"  (par exemple "RFSwitch Salon bouton Gauche")

Dans le menu Configuration / Plus d'options / Evènements, créeé un script dzVents "RFSwitch Reset All" :
```lua
return {
	on = { timer = { 'every minutes' } },
	execute = function(domoticz, triggeredItem, info)
	   domoticz.devices().forEach(function(device)
	      if (device.name:match("RF ?Switch.*")) then
	        if device.state ~= "Off" then
                  domoticz.log('Reset ' .. device.name)
                  device.updateQuiet('Off')
                end
             end
          end)
       end
}
```

Ce script va tourner toutes les minutes et forcer la réinitialisation à 'Off' des interrupteurs ayant le préfixe "RFSwitch" (ou "RF Switch"). Une fois réinitialisés, lorsque vous appuierez sur un interrupteur lvous verrez passer l'évènement dans Domoticz et l'ampoule passer au jaune (temporairement).

Le deuxième script force la réinitialisation immédiate après le passage à 'On' ; vous ne verrez donc plus l'ampoule jaune, mais l'évènement sera bien utilisable dans Domoticz. Dans le menu Configuration / Plus d'options / Evènements, créeé un script dzVents "RFSwitch Reset" :
```lua
return {
	on = {devices = {'RFSwitch*' },},
	execute = function(domoticz, triggeredItem, info)
	    if triggeredItem.state ~= "Off" then
	      triggeredItem.updateQuiet('Off')
	    end
	end
}
```

## Script pour réaliser les actions souhaitées pour chaque bouton

Maintenant que nous avons dans Domoticz l'évènement correspondant à l'appui sur l'interrupteur RF, nous pouvons lui faire faire n'importe quoi, en Blockly, ou via script. Voici un exemple en dzVents, correspondant à la commande d'un bandeau LED : un premier appui va allumer ou éteindre, et un appui successif va changer la luminosité:

```lua
return {
	on = { devices = { 'RFSwitch Salon'},},
	logging = {level = domoticz.LOG_INFO, marker = "RFSalon" },
	execute = function(domoticz, triggeredItem, info)
	    local led = domoticz.devices('LED Salon')
	    local cycleTimeSeconds = 5
	    
	    if ((led.lastUpdate.secondsAgo > cycleTimeSeconds) or (not led.active)) then
	        led.toggleSwitch()
	    else
              if (led.level == 100) then
                led.dimTo(75)
              elseif (led.level == 75) then
                led.dimTo(50)
              elseif (led.level == 50) then
                led.dimTo(25)
              else
                led.dimTo(100)
              end
	    end
	end
}
```

---
title: LED MagicHome  sous Domoticz
lang: fr
image: files/2022/Domoticz_MagicHome_Vignette.jpg
tags:
- Domoticz
- MagicHome
- LED
categories:
- Domotique
date: '2022-12-08 19:44:00'
---

J'ai acheté récemment [ce mini controleur LED Wifi](https://fr.aliexpress.com/item/1005003605999234.html?spm=a2g0o.order_list.order_list_main.10.21ef5e5biZmB4B&gatewayAdapt=glo2fra) pour commander mon éclairage LED qui fonctionne parfaitement avec l'application MagicHome, Google Home et Alexa. Cependant je souhaite également l'utiliser dans Domoticz.

# A l'intérieur
Le boitier s'ouvre avec un peu d'insistance pour passer un outil dans la fente entre les deux parties plastiques et déclipser le couvercle. On y trouve le circuit imprimé assez classique pour ce type d'appareil, même si je pensais trouver des pistes et des fils un peu plus gros pour un appareil censé supporter jusqu'à 96W.

![]({{ 'files/2022/WifiLedController_Inside.jpg' | relative_url }}){: .img-center .mw80 }

On peut y lire la référence "HS-D E514910 94V-0" au dos, qui ne renvoie vers aucun équipement connu. On identifie également très nettement les différents connecteurs pour souder un accès UART. Cependant, cela ne ressemble pas à un ESP8266 et effectivement on peut lire sur la puce 'BL602L20". C'est donc une des nouvelles puces qui remplacent petit à petit les ESP8266 sur ce genre d'équipements, et qui font perdre tout espoir à l'idée de flasher Tasmota ou autre ESPeasy, car ils sont exclusivement prévus pour ESP. 

Il existe cependant un firmware alternatif [OpenBK7231T/OpenBeken](https://github.com/openshwprojects/OpenBK7231T_App) en cours de développement pour supporter toutes les nouvelles puces alternatives, comme BL602, BK7231T, W601 et plein d'autres que vous avez peut-être  déjà croisés. On y trouve les instructions pour un [device supporté qui ressemble pas mal](https://www.elektroda.com/rtvforum/topic3889041.html#19999397) mais ça ne semble encore pas très simple et garanti comme opérations...

# MagicHome = Arilux
Au fil de mes errances sur le forum Domoticz et Tasmota il semble que MagicHome et Arilux ont des produits très similaires, voire identiques, et un hardware "Arilux" a été intégré dans Domoticz. 

Il suffit alors simplement d'ajouter le hardware :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_162713.png' | relative_url }})

Puis de cliquer sur ajouter un device sur ce nouveau hardware via le bouton "Add Light" :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_162732.png' | relative_url }})


Et d'indiquer le nom, l'adresse IP et le type du controlleur que l'on veut ajouter :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_162759.png' | relative_url }})

Il ne reste plus qu'à l'ajouter depuis l'écran des devices :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_162914.png' | relative_url }})

Et bingo !

![]({{ 'files/2022/Domoticz_MagicHome_20221208_162947.png' | relative_url }})



# Passer en monochrome

Si l'équipement fonctionne parfaitement, il y a un petit problème, car bien qu'ayant sélectionné l'entrée "Mono" lors de la création du device, il a été créé en "RGB" comme on peut le voir dans l'écran device. La conséquence est que lorsqu'on appuie sur l'équipement dans l'interface Domoticz, on a alors la mire de couleur qui apparait au lieu du on/off :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_163004.png' | relative_url }})

Ce n'est pas bien grave, mais ce n'est pas pratique, et heureusement ça se corrige assez simplement en modifiant directement en base de données. Il faut ouvrir le fichier domoticz.db via un éditeur SQLite, comme par exemple sqlitebrowser sous Linux. Et ensuite, dans la table devices_status, de chercher l'identifiant de l'équipement à changer :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_163300.png' | relative_url }})

Il faut changer le SubType de la valeur '2' à la valeur '3' :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_163323.png' | relative_url }})

Puis enregistrer les modifications, rafraichir l'écran des devices, et on peut bien constater que notre device est bien maintenant en "White" et non plus en "RGB" :

![]({{ 'files/2022/Domoticz_MagicHome_20221208_163359.png' | relative_url }})

Maintenant un appui sur l'icone fait bien du on/off ! (et le slider fonctionne bien sûr pour indiquer la puissance du dimmer souhaité)


# Bug ?

Pourquoi 3 et non pas 2 ?   Om suffit de voir la valeur des définitions dans [le fichier ColorSwitch.h](https://github.com/domoticz/domoticz/blob/da57df49b5f1d8bbd364b78c2b4ff5f33ce7acf8/hardware/ColorSwitch.h#L10) :

![]({{ 'files/2022/Domoticz_MagicHome_Bug_20221208_165105.png' | relative_url }})


L'origine semble venir d'un petit bug dans le code, avec un petit décalage entre le texte original (RGB) et la valeur pour la traduction (Mono) dans le fichier [Hardware.html](https://github.com/domoticz/domoticz/blob/f64304efb7c74a7f37f237a06c16c8a5544a14f7/www/app/hardware/Hardware.html#L1622) :

![]({{ 'files/2022/Domoticz_MagicHome_Bug_20221208_165843.png' | relative_url }})

Mais on constate dans le bout de code qui gère l'ajout que seul le RGB et RGB_W_Z sont aujourd'hui supportés dans [Arilux.cpp](https://github.com/domoticz/domoticz/blob/23cc0035332ffdefd3478a4d7ced035c1b36f0f0/hardware/Arilux.cpp#L225) :

![]({{ 'files/2022/Domoticz_MagicHome_Bug_20221208_165454.png' | relative_url }})

Bug signalé [ici](https://github.com/domoticz/domoticz/issues/5448).

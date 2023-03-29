---
title: Commandez vos lumières avec des interrupteurs RF sous Domoticz
date: '2023-03-19 18:30:00'
lang: fr
tags:
- domotique
- domoticz
- led
- raspberry
- rf
categories:
- Domotique
toc: 1
image: files/2023/interrupteurs-rf-sous-domoticz.png
---

Dans l'article précédent, nous avions [répliqué une télécommande RF]({{ '/2023/02/repliquer-une-telecommande-rf-avec-raspberry/' | relative_url }}) (Radio Fréquence) pour pouvoir commander depuis Domoticz un variateur RF, mais nous avions également vu les limites de ce mode de communication dans Domoticz, notamment par l'absence de retour d'état du device. Nous allons faire l'inverse dans ce billet, à savoir commander un variateur WiFi avec une télécommande RF.

# Choix du matériel
![]({{ 'files/2023/controleur-led-wifi.png' | relative_url }}){: .img-right .mw20}

Si je n'ai pas trouvé le variateur parfait, Wi-Fi, RF, commandable depuis Domoticz, et avec une puissance suffisante pour mes bandeaux LEDs, il existe un peu plus de choix en Wi-Fi. J'ai opté pour ce contrôleur [MagicHome WiFi mini contrôleur WiFi](https://fr.aliexpress.com/item/1005003605999234.html?spm=a2g0o.order_list.order_list_main.10.3cf75e5biYrDcm&gatewayAdapt=glo2fra). Pas cher, et ressemble à des modèles supportés par Domoticz. Il existe plusieurs déclinaisons du même matériel suivant le logiciel de commande, comme Tuya, SmartLife et eWeLink ; si vous avez l'habitude d'utiliser une de ces solutions, autant tout combiner sur le même. Il affiche une puissance maximale de 95W qui semble un peu optimiste. Par ailleurs, il faut également souvent prendre en compte l'ampérage qui ne va pas être le même sur toute la plage de compatibilité en entrée (5V-28V) ; pour ma part, je suis en 24V donc pas loin, mais pour prendre une marge de sécurité, j'ai tout de même préféré couper mon bandeau LED (10m) en deux pour le répartir sur deux contrôleurs. Par ailleurs, cela offre plus de combinaisons d'éclairage possible.

![]({{ 'files/2023/interrupteur-mural-rf.png' | relative_url }}){: .img-left .mw20}
Ensuite vient le choix des interrupteurs ; il existe une grande variété de technologies : Wi-Fi, Bluetooth, ZigBee, RF,...   J'ai porté mon choix sur la technologie RF pour sa grande autonomie, sa portée suffisante dans un appartement et son prix très abordable. J'avais également en stock pour expérimenter [une télécommande RF "universelle"](https://fr.aliexpress.com/item/1005002008344083.html?spm=a2g0o.order_list.order_list_main.77.3cf75e5biYrDcm&gatewayAdapt=glo2fra) qui peut copier d'autres signaux, et j'ai ensuite commandé des [interrupteurs RF muraux](https://fr.aliexpress.com/item/1005004791222586.html?spm=a2g0o.order_list.order_list_main.44.3cf75e5biYrDcm&gatewayAdapt=glo2fra). Ces interrupteurs sont très peu chers et plutôt bien faits : cela se fixe avec des vis ou tout simplement du double-face (fourni), et la pile se change en retirant les boutons par l'avant (il faut forcer un peu)

{: .clear-float}
Puis vient la question du récepteur RF ; il y a également plusieurs options possibles :
![]({{ 'files/2023/rf433-modules.png' | relative_url }}){: .img-right .mw20 .clear-float}
- avec un raspberry et un module de réception RF 433 ; le choix le plus classique, mais qui devient compliqué/cher à trouver compte tenu de la pénurie de composants
- avec un récepteur radio type RTL-SDR (voir également [l'article précédent]({{ '/2023/02/repliquer-une-telecommande-rf-avec-raspberry/' | relative_url }}) ; une solution assez générique, utilisable avec l'excellent [rtl_433](https://github.com/merbanan/rtl_433) qui s'interface nativement sur PC avec domoticz,  mais quand même parfaitement overkill si vous n'en avez pas d'autres usages
- avec [RFLink](https://www.rflink.nl/index.php) sur un Arduino Mega, également interfacé sur PC nativement avec Domoticz ; comme je disposais déjà de cette solution, c'est celle que j'ai retenue, même si je pense que je passerai sur une solution raspberry zéro une fois la pénurie résorbée pour avoir une solution autonome et compacte.

# Configuration RFLink et Domoticz

Je ne rentre pas dans le détail de la création du RFLink c'est très bien expliqué sur [leur page](https://www.rflink.nl/wires.php) ; pour les besoins de cet article, seul le récepteur RF433 est nécessaire à raccorder au Mega (broche Data du récepteur sur la broche 19 du Mega, et +5V sur la broche 16, et gnd sur gnd), vous pouvez ignorer tous les autres composants. Il faut ensuite uploader le firmware avec le logiciel fourni, qui permet également de faire quelques tests de réception :
![]({{ 'files/2023/rflink.png' | relative_url }}){: .img-center .mw80 }

Lors de l'appui sur votre télécommande, vous verrez apparaitre des lignes "20;" correspondant au code détecté. Peu importe le protocole et la valeur, tant que c'est détecté de manière un peu fiable. 

Dans Domoticz, cela se passe comme d'habitude : il suffit d'aller dans l'onglet Hardware pour ajouter le RFLink ; il faut configurer le bon port USB :

![]({{ 'files/2023/domoticz-rflink.png' | relative_url }}){: .img-center .mw80 }

Ensuite, chaque appareil détecté va apparaître dans l'onglet Devices (avec mention du matériel RFLink) et il suffira ensuite de l'ajouter. Appuyez donc sur chaque bouton de vos interrupteurs, puis ajoutez les interrupteurs. Comme ce sont des interrupteurs poussoir, il faut configurer dans Domoticz le mode "Push On"

![]({{ 'files/2023/domoticz-button-push-on.png' | relative_url }}){: .img-center .mw60 }

# Programmer les actions

Il nous reste ensuite à relier l'action des boutons aux bandeaux LEDs ; pour ce faire, nous allons avoir recours aux "évènements" Domoticz qui permettent de définir des scripts. Il est également possible de créer des scènes avec les boutons en déclencheur et les LEDs en actions, mais le script permet de ne pas être limité et faire des combinaisons plus complexes. De la même façon, s'il est possible en Blockly de gérer les scénarios simples, partir du DzVents permet d'avoir une solution évolutive qui évitera d'avoir à tout refaire sur l'atteinte d'une limitation de Blockly.

Pour ma part j'ai pris des interrupteurs deux boutons pour avoir : 
- un bouton marche/arrêt
- un bouton sélecteur d'éclairage (fort / moyen / faible / ...)

Le code pour le bouton marche/arrêt:
```lua
return {
	on = { devices = { 'RF2 Droite'},},
	execute = function(domoticz, triggeredItem, info)
	    local led = domoticz.devices('LED Salon')
        led.toggleSwitch()
	end
}
```
Le code pour le bouton selecteur:
```lua
return {
	on = { devices = { 'RF2 Gauche'},},
	logging = {
        level = domoticz.LOG_INFO,
        marker = "RF2 Gauche"
    },

	execute = function(domoticz, triggeredItem, info)
	    local led = domoticz.devices('LED Salon')
	    local cycleTimeSeconds = 5
	    
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
}
```

Et si vous voulez tout combiner sur un seul bouton(agit en toggle au premier appui, et en sélecteur sur les appuis suivants dans les 5 secondes) :
```lua
return {
	on = { devices = { 'RF2 Gauche'},},
	logging = {
        level = domoticz.LOG_INFO,
        marker = "RF2 Gauche"
    },

	execute = function(domoticz, triggeredItem, info)
	    local led = domoticz.devices('LED Salon')
	    local cycleTimeSeconds = 5
	    
	    if ((led.lastUpdate.secondsAgo > cycleTimeSeconds) or (not led.active)) then
	        domoticz.log("Toggle")
	        led.toggleSwitch()
	    else
	        domoticz.log("else cur=" .. led.level)
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



# Conclusion

Voilà, j'ai enfin des éclairages LED de mes pièces commandables avec des interrupteurs physiques, mais aussi via Domoticz et à la voix avec Google Home et Alexa !  Petit défaut de mon installation, seul le premier appui sur l'interrupteur est bien détecté, mais il faut un délai de 2-3 secondes avant de pouvoir appuyer sur le même bouton. Cela rend un peu capricieux le mode "sélecteur" si besoin de naviguer sur plusieurs niveaux, mais on prend vite l'habitude et je pense qu'un prochain passage sur Raspberry résoudra ce problème.

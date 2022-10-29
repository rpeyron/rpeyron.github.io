---
post_id: 5762
title: 'Température Bluetooth LE dans domoticz par reverse engineering et MQTT auto-discovery Home Assistant'
date: '2022-07-16T13:31:39+02:00'
last_modified_at: '2022-07-16T17:09:32+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5762'
slug: capteur-bluetooth-le-temperature-dans-domoticz-par-reverse-engineering-et-mqtt-auto-discovery-domoticz-et-home-assistant
permalink: /2022/07/capteur-bluetooth-le-temperature-dans-domoticz-par-reverse-engineering-et-mqtt-auto-discovery-domoticz-et-home-assistant/
image: /files/canicule-thermometre-40-degres-rouge-stockpack-adobe-stock.jpg
categories:
    - Domotique
    - Informatique
tags:
    - Auto-discovery
    - Bluetooth
    - Domoticz
    - 'Home Assistant'
    - MQTT
    - Thermomètre
lang: fr
---

À la recherche de thermomètres simples à intégrer à mon installation domotique, je suis tombé sur des capteurs Bluetooth LE très bons marchés, mais pour lesquels il n’existait pas d’intégration disponible. J’ai donc cherché à faire cette intégration, à la découverte du reverse engineering Android, du protocole Bluetooth LE et de l’auto-discovery MQTT sous Home Assistant et Domoticz.

Le modèle de thermomètre que j’ai repéré est très simple, assez petit (carré de 4 cm de côté), avec un simple affichage de la température et de l’humidité, et un pictogramme qui illustre le confort hygrométrique. On le trouve à moins de 5 € sur des sites comme AliExpress (exemple : <https://fr.aliexpress.com/item/1005004073828412.html> ; attention, il existe des modèles non Bluetooth très ressemblant, à l’exception du logo Bluetooth sur la droite de la température). Il est alimenté par une pile bouton CR2032 dont je n’ai pas encore d’idée de l’autonomie, mais que l’on trouve également peu chère sur les mêmes sites.

![](/files/Thermom-tre-et-hygrom-tre-num-rique-LCD-Bluetooth-capteur-lectronique-de-temp-rature-et-d.jpg_640x640-e1657961528905-300x300.jpg) ![](/files/Thermometre-Application-300x300.jpg)
{: .center}

Le thermomètre arrive avec une notice en chinois avec un QR-Code qui pointe vers une application Android ou iOS (qui porte le délicieux nom de “qaqa” 😉 ) qui permet de se connecter au thermomètre et d’afficher les mesures ainsi que l’historique.

# Reverse Engineering

Le reverse engineering en France n’est autorisé que dans certains cas précis, et notamment à des fins d’interopérabilité, en ayant le droit d’usage du logiciel et lorsque les informations n’ont pas déjà été mises à disposition par leur auteur (source [LegiFrance](https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000028345224/) et [son analyse par un avocat](https://www.avocats-mathias.com/propriete-intellectuelle/decompilation-logiciel-application)). Ça tombe bien, c’est exactement notre cas. Cette parenthèse juridique levée, nous pouvons passer à la suite.

Pour comprendre comment cela marche, j’ai commencé par chercher sur internet si je trouvais quelque chose. Rien… Puis par observer ce qui est exposé en Bluetooth ; pour ce faire, la société Nordic Semiconductor qui fabrique des puces de connectivité Bluetooth met à disposition gratuitement une application Android “[nRF Connect for Mobile](https://play.google.com/store/apps/details?id=no.nordicsemi.android.mcp&hl=fr&gl=US)” très bien faite pour observer les périphériques Bluetooth. Cela permet de naviguer dans les différents services et caractéristiques disponibles, et de se rendre compte assez vite qu’il n’y a rien d’évident de disponible et qu’il va falloir creuser un peu plus. Pour les plus fortunés, il existe aussi des analyseurs de protocole Bluetooth pour plusieurs centaines d’euros.

Comme une application Android est disponible, il est possible de l’analyser. En effet, les applications Android sont écrites en Java et le Java se décompile plutôt très bien. Il existe un logiciel particulièrement bien adapté pour faire ça qui s’appelle [JADX](https://github.com/skylot/jadx) (également installable via `scoop install jadx` ). Il faut en premier récupérer l’apk. L’adresse donnée par le QRCode sur la notice est <https://d.ihunuo.com/app/dqwu> et il suffit de cliquer sur le logo Android pour télécharger le fichier APK (LT\_Thermometer-V3.apk). Il faut ensuite lancer jadx-gui, ouvrir le fichier, et le code décompilé apparait !

![](/files/LT_Thermometer-V3-JADX-decode-function.png){: .img-center .mw80}

Après un peu de recherche, on trouve rapidement la fonction principale qui permet de décoder la température. En analysant le reste du fichier, on trouve que le protocole est le suivant :

UUID de la caractéristique Bluetooth de notification, à laquelle il va falloir s’abonner pour recevoir les données : **“0000FFE8-0000-1000-8000-00805f9b34fb”**

Structure des données reçues :

| Octets | Contenu |
|---|---|
| 0,1 | Header (0xAA0xAA) |
| 2 | Type de données :   – 162 : hygrométrie (température + humidité)   – 163 : historique des données   – 164 : information de version |
| 3,4 | Taille des données n (Big Endian) |
| 5,5+n | Données suivant le type |
| 5+n | Checksum des données (somme de tous les octets jusqu’au checksum exclus, modulo 256) |
| 6+n | Footer (0x55) |

Et pour un type de donnée 162 (hygrométrie), la taille de la structure est de 6 octets et la structure complète est la suivante :

| Octets | Contenu |
|---|---|
| 0,1 | Header (0xAA0xAA) |
| 2 | Type de données 162 (0xA2) : hygrométrie (température + humidité) |
| 3,4 | Taille des données : 6 (Big Endian) |
| 5,6 | Température en Big Indian, à diviser par 10 |
| 7,8 | Humidité en Big Indian, à diviser par 10 |
| 9 | Indicateur de pile |
| 10 | Unité ; 0 pour Celcius |
| 11 | Checksum des données (somme de tous les octets de 0 à 10, modulo 256) |
| 12 | Footer (0x55) |

En ce qui concerne la version, c’est une simple chaîne de caractère avec le texte de la version, et pour les informations d’historique, un tableau d’entrées de 4 octets contenant la température et l’humidité sur 2 octets chacun suivant la même formule que précédemment. Chaque valeur correspond à une heure, à compter à rebours depuis l’heure courante.

On peut maintenant vérifier avec l’application “[nRF Connect for Mobile](https://play.google.com/store/apps/details?id=no.nordicsemi.android.mcp&hl=fr&gl=US)” que notre compréhension est la bonne avant de passer à l’implémentation :

![](/files/LT_Thermometer-V3-nRF-decode-test-461x1024.jpg){: .img-center}

Pour arriver cet écran, il faut trouver le bon device (généralement LT\_xxxx), s’y connecter, repérer le service 0xFFE9 et sa caractéristique de notification 0xFFE8, cliquer sur la petite icone à droite pour s’abonner aux notifications, et attendre quelques secondes pour voir s’afficher la ligne value, qui dans cet exemple est (0x) AA-AA-A2-00-06-01-10-01-86-10-00-95-55 ; nous observons bien:

- AA-AA : l’en-tête
- A2 : c’est l’hygrométrie
- 00-06 : la taille des donnée est de 6 octets
- 01-10 : 0x0110, soit 256 en décimal, à diviser par 10 : 25,6° (et ça tombe bien, c’est bien ce que mon thermomètre affiche !)
- 01-86 : 0x0186, soit 390 en décimal, à diviser par 10 : 39%
- 01 : indication de pile ; je suppose que 1 veut dire que l’indicateur de pile n’est pas affiché
- 00 : nous sommes en degrés Celsius
- 95 : le checksum (et il est correct)
- 55 : le footer

Nous pouvons maintenant lire les données et passer à la suite !

# Implémentation du script de décodage

Le script devra s’exécuter sur un périphérique ayant accès à une connectivité Bluetooth LE, et être situé de sorte à pouvoir capter vos thermomètre. Dans mon cas, le seul équipement que j’ai de compatible Bluetooth LE est mon raspberry zéro wifi, le choix sera donc vite fait.

Mon cahier des charges est le suivant :

- Écouter un ou plusieurs de ces thermomètres
- Publier les résultats sur un serveur MQTT pour pouvoir réutiliser ensuite
- En python, mon langage de prédilection pour ce genre de scripts, a minima compatible Linux et plus si possible

J’ai commencé à utiliser la librairie python bluepy que j’ai trouvée utilisée à plusieurs reprises dans d’autres scripts similaires, mais en plus de la documentation défaillante (notamment pour les notifications, utiliser withDelegate et non pas setDelegate, j’ai perdu un temps fou à cause de ce manque de documentation…), je suis tombé sur plusieurs bugs, dont un particulièrement gênant de déconnexion lors de l’exécution d’un autre script de lecture d’une balance connectée (voir l’article [/2021/02/xiaomi-smart-scale-with-domoticz-nodered-raspberry-and-google-fit](/2021/02/xiaomi-smart-scale-with-domoticz-nodered-raspberry-and-google-fit)). Donc, j’ai essayé [Bleak](https://github.com/hbldh/bleak), qui en plus de sembler un peu plus stable, plus simple, et se trouve être également plus portable.

Pour MQTT, paho-mqtt semble faire l’unanimité et est effectivement super simple à utiliser pour envoyer un message.

Le code est disponible ici : [**https://github.com/rpeyron/blelt2mqtt**](https://github.com/rpeyron/blelt2mqtt)

<details markdown="1"><summary>Version à la date de la rédaction de cet article</summary>

```python
import asyncio
from functools import partial
import bleak
import paho.mqtt.publish as publish
import json
import re

# Install requirements :
# pip3 install bleak paho-mqtt

# crontab -e
# @reboot    python3 /home/pi/ble-lt.py

# Device Settings
# {
#   'mac': MAC Address of the bluetooth LT Thermometer
#   'name' : to override the name provided by bluetooth
#   'domoticz_idx': id of the virtual sensor to be updated through domoticz   
# }
DEVICES = [ 
   {'mac': "C8:33:DE:43:2C:00", 'name': "LT Bureau", 'domoticz_idx': 396},
]


# MQTT Settings

MQTT_HOST="127.0.0.1"       # MQTT Server (defaults to 127.0.0.1)
MQTT_PREFIX="lt_temp/"         # MQTT Topic Prefix. 
MQTT_USERNAME="username"      # Username for MQTT server ('username' if not required)
MQTT_PASSWORD=None             # Password for MQTT (None if not required)
MQTT_PORT=1883                # Defaults to 1883
MQTT_DISCOVERY=True           # Home Assistant Discovery (true/false), defaults to true
MQTT_DISCOVERY_PREFIX="homeassistant/"      # Home Assistant Discovery Prefix, defaults to homeassistant


# The UUID of the service that you want to use.
service_uuid = "0000FFE5-0000-1000-8000-00805f9b34fb"
notify_uuid = "0000FFE8-0000-1000-8000-00805f9b34fb"
char_uuid = "00002902-0000-1000-8000-00805f9b34fb"



def get_topic_state(client: bleak.BleakClient) -> str:
    return MQTT_PREFIX + client_get_name(client) + "/state"

def get_topic_discovery(client: bleak.BleakClient) -> str:
    return MQTT_DISCOVERY_PREFIX + "sensor/" + client_get_name(client) + "/config"

def mqtt_send_discovery(client: bleak.BleakClient):
    if MQTT_DISCOVERY:
        name = client_get_name(client)
        message =  {
            "device_class": "temperature", 
            "name": name , 
            "state_topic": get_topic_state(client),
            "value_template": "{{ value_json.temperature}}",
            "json_attributes_topic": get_topic_state(client),
            "unit_of_measurement": "°C", 
            "icon": "mdi:thermometer"
        }
        mqtt_send_message(get_topic_discovery(client), message)

def mqtt_remove_discovery(client: bleak.BleakClient):
    if MQTT_DISCOVERY:
        mqtt_send_message(get_topic_discovery(client), "")


def mqtt_send_message(topic: str, message) -> None:
    message = json.dumps(message)
    publish.single(
                    topic,
                    message,
                    retain=True,
                    hostname=MQTT_HOST,
                    port=MQTT_PORT,
                    auth={'username':MQTT_USERNAME, 'password':MQTT_PASSWORD}
                )
    print("Sent to MQTT", topic, ": ", message)


def mqtt_send_state(client: bleak.BleakClient, message) -> None:
    mqtt_send_message(get_topic_state(client), message)

def mqtt_send_domoticz(client: bleak.BleakClient, domoticz_id, message) -> None:
    topic = "domoticz/in"
    message = {
        "command":"udevice", 
        "idx": domoticz_id, 
        "svalue": str(message['temperature']) + ";" + str(message['humidity']) + ";0"
    }
    mqtt_send_message(topic, message)


def client_get_name(client: bleak.BleakClient) -> str:
    try:
        if 'name' in client.ltDefinition:
            name = client.ltDefinition['name']
        else:
            name=client._device_info["Name"]
    except:
        name=client.address
    # Sanitize
    name = re.sub('[^a-zA-Z0-9_]', '', name)
    return name    


def notification_handler(client: bleak.BleakClient, sender, data):
    #print("notification_handler", sender, data)
    dataSize = len(data)
    
    # Check message header
    if ( (dataSize > 6) and  (data[0] != 170) or (data[1] != 170) ):
        print("Unknown data",', '.join('{:02x}'.format(x) for x in data))
        return
    
    # Check checksum
    payloadSize = (data[3] << 8) + data[4]
    checksum = sum(data[0:payloadSize+5]) % 256
    if checksum != data[dataSize-2]:
        print("Checksum error:", checksum, data[dataSize-2], "data",', '.join('{:02x}'.format(x) for x in data))
        return
        
    if ((data[2] == 162) and (dataSize > 10)):
        result = {
            "temperature": ((data[5] << 8) + data[6]) / 10.0,
            "humidity": ((data[7] << 8) + data[8]) / 10.0,
            "power": data[9],
            "unit": "Celcius" if data[10] == 0 else "Farenheit"
        }
        print(result)
        mqtt_send_state(client, result)
        if 'domoticz_idx' in client.ltDefinition:
            mqtt_send_domoticz(client, client.ltDefinition['domoticz_idx'], result)
        return
    
    if ((data[2] == 163)):
        print("Hour data", ', '.join('{:02x}'.format(x) for x in data))
        return
    
    if ((data[2] == 164)):
        print("Version Info", ''.join(chr(x) for x in data))
        return
    
    print("Other data", ', '.join('{:02x}'.format(x) for x in data))
    

def disconnect_handler(client: bleak.BleakClient):
    print("Disconnected from", client_get_name(client))
    mqtt_remove_discovery(client)


async def deviceConnect(deviceDefinition):
    maxRetries = -1
    retry = 0
    while retry != maxRetries:
        try:
            c = bleak.BleakClient(deviceDefinition['mac'])
            c.ltDefinition = deviceDefinition
            await c.connect()
            if c.is_connected:
                retry = 0
                print("Connected to ", c._device_info["Name"])
                mqtt_send_discovery(c)
                
                c.set_disconnected_callback(disconnect_handler)
                
                await c.start_notify(notify_uuid, partial(notification_handler, c))
                
                while c.is_connected:
                    await asyncio.sleep(0.1)
                    
            else:
                print("Cannot connect")
        except bleak.exc.BleakError as err:
            retry+=1
            print("Error connecting : ", err)
            await asyncio.sleep(5.0)
        finally:
            await c.disconnect()

    print("Too much error, stopping")
    

async def main():
    await asyncio.gather(*[deviceConnect(definition) for definition in DEVICES])
  

asyncio.run(main())

```

</details><br>

Il reprend les différentes étapes détaillées ci-dessus dans l’analyse de protocole et ne comporte pas de difficulté particulière.

# Auto-discovery et setup dans Domoticz

Lors de précédentes recherches sur Domoticz j’avais repéré l’existence d’un [plugin d’auto-discovery MQTT](https://github.com/emontnemery/domoticz_mqtt_discovery) qui semble même maintenant [intégré de façon native dans domoticz](https://www.domoticz.com/wiki/MQTT#Add_hardware_.22MQTT_Auto_Discovery_Client_Gateway.22) depuis peu. Il s’agit en fait de l’intégration dans Domoticz d’un [protocole défini par Home Assistant](https://www.home-assistant.io/docs/mqtt/discovery/) pour simplifier la découverte de nouveaux devices via MQTT. J’ai trouvé relativement peu de tutoriels sur le sujet, donc voici ce que j’ai trouvé.

Le principe de l’auto-discovery MQTT repose sur des messages de configuration qui doivent être émis par le device pour se déclarer et mentionner les caractéristiques. Le topic est sous la forme `/homeassistant/<devicetype>/<deviceid>/config` ; par exemple pour définir un device capteur (sensor) nommé LTBureau : `/homeassistant/sensor/LTBureau/config` . Le contenu du message est un json qui suit la structure suivante :

```js
{
 "device_class": "temperature",   // Le typde de capteur, ici un capteur de température
 "name": "LT Bureau" ,  // Le nom du device à ajouter 
 "state_topic": "lt_temp/LTBureau/state",  // Le nom du topic qui va publier les états du capteur
 "value_template": "{{ value_json.temperature}}",   // Si le topic ci-dessus publie du json, le template pour extraire la valeur à conserver, ici on garde le champ temperature
 "json_attributes_topic": "lt_temp/LTBureau/state",  // le nom du topic pour les attributs du capteur, ici on va conserver le contenu total du message (non traité sous domoticz)
 "unit_of_measurement": "°C",  // L'unité du capteur
 "icon": "mdi:thermometer"  // L'icone à utiliser, le préfixe mdi fait référence à https://materialdesignicons.com/ ; non utilisé par domoticz
}
```

Il existe bien sûr d’autres propriétés pour d’autres types d’équipements dont vous trouverez les indications dans la [documentation](https://www.home-assistant.io/integrations/sensor.mqtt/). L’auto-discovery peut également désinscrire le device (lorsqu’il n’est plus actif par exemple), en envoyant simplement un message vide sur ce même topic.

A noter qu’il n’est pas nécessaire que le topic de statut fasse partie de la même arborescence que le topic d’auto-configuration (c’est même recommandé que ce ne soit pas le cas). Il est même possible d’ajouter plusieurs devices Home Assitant à partir du même topic d’état. C’est par exemple ce qu’il faut faire pour déclarer les mesures de température et d’humidité pour un capteur d’hygrométrie car Home Assistant ne dispose pas d’un device qui supporte les deux valeurs contrairement à Domoticz. Et malheureusement, comme Home Assistant ne supporte pas ce type de device, il n’est pas non plus possible de déclarer un tel device par le protocole d’auto-discovery. J’ai donc conservé l’auto-discovery dans le script si jamais des personnes voudrait l’utiliser dans Home Assistant, mais développé un complément pour Domoticz. Pour domoticz, il faut faire manuellement la création d’un capteur virtuel (via le matériel Dummy dans l’onglet Hardware) dans l’interface et recopier l’idx ainsi obtenu (visible une fois créé dans l’onglet Devices), et lui envoyer les nouvelles valeur via le topic “`domoticz/in` ” (ou celui que vous avez paramétré si vous en avez utilisé un différent). La structure du json est [documentée sur cette page](https://piandmore.wordpress.com/2019/02/04/mqtt-out-for-domoticz/) à envoyer et est super simpledans le cas d’un capteur Température + Humidité :

```js
{
 "command":"udevice",  // Pour dire qu'on veut changer la valeur d'un device
 "idx": 345,   // Le code idx du device domoticz que l'on veut adresser
 "svalue": "25.9;39;0"  // <température>;<humidité>;<environment>, ce dernier paramètre peut valeur 0 (normal), 1 (confort), 2 (sec), 3 (humide) ; pour bien faire il faudrait calculer à partir des deux premiers paramètres, par simplicité j'ai forcé à 0
}
```

Ainsi au final, le plugin ci-dessus publiera à chaque mesure sur deux topics :

```
lt_temp/LTBureau/state {
  "temperature": 26.3, 
  "humidity": 35.0, 
  "power": 1, 
  "unit": "Celcius"
}
domoticz/in {
  "command": "udevice", 
  "idx": 396, 
  "svalue": "26.3;35.0;0"
}
```

et lors du discovery sur le topic dédié :

```
homeassistant/sensor/LTBureau/config {
  "device_class": "temperature", 
  "name": "LTBureau", 
  "state_topic": 
  "lt_temp/LTBureau/state", 
  "value_template": "{{ value_json.temperature}}", 
  "json_attributes_topic": "lt_temp/LTBureau/state", 
  "unit_of_measurement": "\u00b0C", 
  "icon": "mdi:thermometer"
}
```

Et le résultat dans Domoticz *(à gauche le device natif domoticz ajouté manuellement, et à droite celui issu du discovery MQTT)* :

![](/files/LT_Thermometer-V3-Domoticz.png){: .img-center}
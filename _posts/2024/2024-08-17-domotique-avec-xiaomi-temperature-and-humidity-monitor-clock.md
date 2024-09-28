---
title: Domotique avec Xiaomi Temperature And Humidity Monitor Clock
lang: fr
tags:
- Domoticz
- Python
- Script
categories:
- Domotique
image: files/2024/mitemp_card.jpg
toc: 'yes'
date: '2024-08-13 12:10:40'
---

J'ai acheté récemment un thermomètre connecté [Xiaomi Temperature And Humidity Monitor Clock](https://www.mi.com/fr/product/xiaomi-temperature-and-humidity-monitor-clock/). S'il est un peu cher au prix normal, il est de temps en temps à moitié prix pendant les périodes de soldes. 

Ce qui m'a intéressé sur ce modèle est son affichage e-Paper plutôt que les cristaux liquides des thermomètres classiques ou écrans LED des solutions avec réveils connectés.  À l'usage, je trouve que cet affichage fait une vraie différence et est beaucoup plus agréable.

![]({{ 'files/2024/miclock_product_Sd48a3af613b7406a8b9a4e5d880b1417X.webp' | relative_url }}){: .img-center .mw60}

Je vais donc chercher à l'intégrer à ma solution actuelle de domotique basée sur Domoticz. Cet article décrit l'exploration que j'ai suivie.  Si vous êtes pressés, en synthèse :
- le nom technique de ce modèle est LYWSD02MMC, les données sont transmises dans les adversisements bluetooth LE, avec un chiffrement qui nécessite une clé de chiffrement récupérable avec [Xiaomi-cloud-tokens-extractor](https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor)
- il est possible d'intégrer le modèle à Domoticz avec un script intermédiaire et MQTT 
- l'équipement est nativement supporté par [Home Assistant](https://www.home-assistant.io/integrations/xiaomi_ble) / ESPHome, ce qui m'a motivé à finalement migrer pour Home Assitant (article à venir)

# Identifier le modèle : LYWSD02MMC
La première difficulté est de trouver le nom technique du modèle. C'est souvent marqué sur la boite (et ça m'aurait fait gagner un temps fou !). 

Sans la boite sous la main, une autre technique est d'utiliser Google Images avec le nom commercial du modèle, puis de chercher les forums ou autres, pour voir si des références sont mentionnées. 

Vous ne trouverez peut-être pas la bonne référence du premier coup, mais cela vous permettra d'avancer dans les recherches et préciser le modèle au fur et à mesure. Par exemple j'avais commencé en pensant qu'il s'agissait du modèle LYWSD03, avant de comprendre que le grand écran était le modèle LYWSD02, LYWSD03 correspondant à son petit frère carré, et que le suffixe MMC correspondait à la version cryptée, qui est celle actuellement commercialisée (et complique considérablement les choses).


# Comprendre comment ça marche
Je repère assez rapidement sur le forum Domoticz que ce modèle n'est pas supporté. Cela veut dire qu'il va falloir faire une solution maison. Pour cela, il faut d'abord comprendre comment cela fonctionne.

Lorsqu'il existe une application Android, une première piste est de faire du reverse engineering comme j'ai fait pour un autre thermomètre chinois (lire [cet article]({{ '/2022/07/capteur-bluetooth-le-temperature-dans-domoticz-par-reverse-engineering-et-mqtt-auto-discovery-domoticz-et-home-assistant/' | relative_url }})). Malheureusement, il s'agit ici de l'application Xiaomi Home, qui est bien trop grosse et complexe pour espérer comprendre le fonctionnement dans un temps raisonnable.

Il reste alors à poursuivre les recherches sur internet. Heureusement le modèle ou la famille de modèle est assez répandue et on peut trouver pas mal d'informations.

# Theengs / OpenMQTTGateway

Je remarque ensuite que Theengs / [OpenMQTTGateway](https://docs.openmqttgateway.com/) supporte un modèle proche (LYWSD02 et LYWSD03MMC). [OpenMQTTGateway](https://docs.openmqttgateway.com/) permet de faire passerelle entre différents capteurs et les systèmes domotique, en l'occurrence pour ce qui nous intéresse ici, un grand nombre d'appareils Bluetooth et le système Domoticz. Il s'installe facilement sur un ESP32, et une fois le serveur MQTT configuré, tous les devices Bluetooth détectés sont publiés sous le topic OMG. [Theengs](https://decoder.theengs.io/) est en gros la même chose, mais déployable sur un ordinateur, comme un raspberry. 

La configuration des devices est réalisée via un fichier JSON, mais malheureusement, via compilation. Bien qu'ayant repéré le [fichier de configuration du LYWSD03MMC](https://github.com/theengs/decoder/blob/development/src/devices/LYWSD03MMC_ENCR_json.h) qui pourrait servir de base, le processus de compilation et utilisation me semble assez complexe, et la [documentation pour l'ajout de décodeurs](https://gateway.theengs.io/participate/adding-decoders.html) est très sommaire... Bref, cela demanderait un effort important alors que je ne sais pas encore si c'est possible, donc je continue de regarder les autres solutions avant de me lancer là-dedans.


# Protocole et récupération de la clé de déchiffrement

Au fur et à mesure de mes explorations, j'arrive sur une page détaillant le protocole [MiBeacon v5 utilisé par le LYWSD02MMC](https://custom-components.github.io/ble_monitor/MiBeacon_protocol)

Le protocole est chiffré, et il est nécessaire de récupérer la clé de déchiffrement. Lorsque le thermomètre a été ajouté à l'application Xiaomi Home, il existe un outil d'extraction [Xiaomi-cloud-tokens-extractor](https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor) à partir du compte cloud Xiaomi. 

Sous Windows, il suffit de télécharger le binaire, le lancer, et renseigner login / mot de passe du compte sur lequel est connecté l'application Xiaomi Home sur laquelle vous avez configuré votre thermomètre. 

```text
Username (email or user ID):
Password:

Server (one of: cn, de, us, ru, tw, sg, in, i2) Leave empty to check all available:

Logging in...
Logged in.

No devices found for server "cn" @ home "xxxxxxx".
Devices found for server "de" @ home "xxxxxxx":
   ---------
   NAME:     Xiaomi Temperature and Humidity Monitor Clock
   ID:       blt.xxxxxxx
   BLE KEY:  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   MAC:      A4:C1:38:58:xx:xx
   TOKEN:    xxxxxxxxxxxxxxxxxxxxxxxx
   MODEL:    miaomiaoce.sensor_ht.o2
   ---------

No devices found for server "us" @ home "xxxxxxx".
```

La ligne qui nous intéresse est la ligne "BLE KEY".  Gardez la clé pou pouvoir déchiffrer les messages.



# Tentative d'implémentation du protocole

Sur la page détaillant le protocole [MiBeacon v5 utilisé par le LYWSD02MMC](https://custom-components.github.io/ble_monitor/MiBeacon_protocol) il est également fourni un code python d'exemple. 

Pour faire fonctionner ce code, il faut installer la bibliothèque `Crytodome` et modifier l'import de `Cryptodome.Cipher` en `Crypto.Cipher`car elle semble avoir été renommée.
```sh
pip install Cryptodome
```

Par ailleurs, pour capturer des trames correspondant à notre thermomètre, on peut utiliser `hcidump`
```sh
sudo apt install bluez-hcidump
sudo hcidump -x -R
```

À ce moment, il est intéressant de capturer quelques trames et de noter la température et l'humidité lisible sur le thermomètre.

Malheureusement, le script ne fonctionne par directement sur les trames capturées. Il se trouve que cette page d'explication de protocole fait partie du projet [custom-components/ble_monitor](https://github.com/custom-components/ble_monitor) qui est une intégration dans Home Assistant de nombreux capteurs, dont le notre !  Le code du décodage du protocole est [disponible dans le fichier xiaomi.py](https://github.com/custom-components/ble_monitor/blob/master/custom_components/ble_monitor/ble_parser/xiaomi.py#L1296), et permet rapidement de voir que le protocole est un peu plus complexe que celui décrit dans la page précédente.

Je tente d'adapter le script et fini par aboutir à :
```python
# Inspired From https://custom-components.github.io/ble_monitor

# pip install Cryptodome
from Crypto.Cipher import AES

import struct

# Method 1: use OpenMQTTGateway and copy servicedata of uuid "fe95"
# Method 2, with hcidump: 
#  sudo apt install bluez-hcidump
#  sudo hcidump -x -R  and search for the MAC address of your device
# You will strings like "043E29xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx95FE4858e416e5ac9aadd02dd6de613300356751d2"
# Keep the part after "95FE" (may also begin with 5858)
data_hex= "4858e416e5ac9aadd02dd6de613300356751d2"
aeskey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
mac_hex_reversed = "08a45838c1a4"   # Reversed MAC Address without ":", in hex

# Function to decrypt using AES and key
def decrypt_mibeacon(data, mac_reversed, key):
    header = data[:11]
    nonce = mac_reversed + header[2:5] + data[-7:-4]
    ciphertext = data[5:-7]
    mac = data[-4:]
    cipher = AES.new(key, AES.MODE_CCM, nonce=nonce, mac_len=4)
    cipher.update(b"\x11")
    return cipher.decrypt_and_verify(ciphertext, mac)

# Function to decode the decrypted MiBeacon V5 data
def decode_mibeacon(data):
    try:
        frame_ctrl, product_id, frame_counter, mac, capability = struct.unpack('<HHB6sB', data[:12])
        print(f"Frame Control: {frame_ctrl}")
        print(f"Product ID: {product_id}")
        print(f"Frame Counter: {frame_counter}")
        print(f"MAC: {mac.hex()}")
        print(f"Capability: {capability}")
        event_type = data[12]
        event_length = data[13]
        event_value = data[14:14+event_length]
        print(f"Event Type: {event_type}")
        print(f"Event Length: {event_length}")
        print(f"Event Value: {event_value.hex()}")
    except Exception as e:
        print(f"Failed to decode MiBeacon V5: {e}")

def main():
    data = bytes.fromhex(data_hex)
    print(f"Data: {data.hex()}")
    decrypted_data = decrypt_mibeacon(data, bytes.fromhex(mac_hex_reversed), bytes.fromhex(aeskey))
    decode_mibeacon(data)
    print(f"Decoded Value: {decrypted_data.hex()}")

if __name__ == "__main__":
    main()

# Decoded Value: 014c040000cc41
```

En mettant au point le script et en essayant sur plusieurs trames, j'arrive aux premières conclusions suivantes:
- la structure n'est pas identique pour toutes les trames (ne serait-ce que la longueur)
- dans les données décodées, je retrouve parfois facilement l'humitidité (à diviser par 10), mais pas la température

En lisant plus attentivement [la fonction de décoage du payload](https://github.com/custom-components/ble_monitor/blob/12.14.0/custom_components/ble_monitor/ble_parser/xiaomi.py#L1460) que la valeur décodée comporte un certain nombre de segments dont les 2 premiers octets indiquent la signification et structure ; en l'occurence, pour "014c"  la structure est décodée par la fonction [obj4c01](https://github.com/custom-components/ble_monitor/blob/12.14.0/custom_components/ble_monitor/ble_parser/xiaomi.py#L893), qui utilise une structure float `struct.Struct("<f")`  ; la [documentation struct python](https://docs.python.org/3/library/struct.html) confirme qu'il s'agit d'un float encodé. Voilà pourquoi la seule division par 10 ne convenait pas !  Et si on décode en utilisant le [format float](https://en.wikipedia.org/wiki/Single-precision_floating-point_format), je retrouve parfaitement la température !  

Au final:
- la structure n'est pas fixe, il peux y avoir un grand nombre de combinaisons pour mon seul thermomère
- les données vont comporter la température et/ou l'humidité suivant que leur valeur a changé ou non
- il existe dans un plugin HomeAssistant une bonne implémentation python de ce protocole


# bleparser et ble2mqtt
## Identification du package
A ce stade, je cherche toujours un moyen d'intégrer le device dans Domoticz et vu la complexité du protocole, cela ne serait clairement pas une bonne idée que de vouloir le réimplémenter. Le code dans le plugin d'intégration HomeAssistant est très intéressant, mais la dépendance à HomeAssistant rend complexe l'utilisation en dehors, et le code n'est pas disponible en package. 

Heureusement il existe une version packagée du coeur du parser dans le répertoire ble_parser, mis à disposition dans le repository [Ernst79/bleparser](https://github.com/Ernst79/bleparser) et en [package installable via pip](https://pypi.org/project/bleparser/). Le package n'a plus l'air mis à jour depuis 2 ans, et l'auteur semble maintenant directement contribuer dans l'intégration HomeAssistant. Quoiqu'il en soit l'intégration Xiaomi est disponible dans cette version, et si besoin de mise à jour il ne devrait pas être compliqué de mettre à jour le package avec l'autre repository.

Le package comporte égalemen un exemple `ble2mqtt` exactement ce qu'il nous faut. 

## Installation
L'utilisation du bluetooth est très dépendante de l'environnement dans lequel sera exécuté le script. Notamment, sous Linux, il faut avoir les bons droits. Regarder comment faire pour votre OS, pour certains c'est l'ajout de l'utilisateur dans un groupe, dans mon cas, sur un raspberry pi zero sur dietpi (après ajout du bluetooth via [`dietpi-config`](https://dietpi.com/docs/dietpi_tools/system_configuration/#__tabbed_1_4) ), il faut ajouter la [capability](https://connect.ed-diamond.com/GNU-Linux-Magazine/glmf-164/les-capabilities-sous-linux) cap_net_raw (+e (effective), +i (inheritable) + p (permitted)) à l'exécutable, en l'occurence python3 (et non votre script):
```sh
sudo setcap cap_net_raw+eip $(eval readlink -f `which python3`)
```

Puis ensuite, installer les dépendances requises et lancer le script (il faut configurer les informations de connextion ble2mqtt.py dans le script au préalable, et soit activer le discovery (`discovery=True`), soit ajouter les adresses MAC des devices de la liste blanche) :
```
python3 venv/bin/activate -m venv --system-site-packages venv
. venv/bin/activate
pip install bleparser paho-mqtt aioblescan
python ble2mqtt.py
```

S'il n'y a pas d'erreur à l'exécution du script, c'est a priori bon signe. Il faut se connecter à serveur MQTT, par exemple avec [MQTT Explorer](https://mqtt-explorer.com/), et regarder s'il y a effectivement des publications. S'il y a encore des problèmes, [la documentation custom-components](https://custom-components.github.io/ble_monitor/Installation) mentionne des capabilites complémentaires `sudo setcap 'cap_net_raw,cap_net_admin+eip' $(eval readlink -f /usr/bin/python3) `

![]({{ 'files/2024/mitemp_bleparser.png' | relative_url }}){: .img-center .mw80}


En cas de problèmes de droits bluetooth persistants, une solution brutale mais radicale consiste à exécuer en `root`et sans environnement virtuel :
```
sudo pip install bleparser paho-mqtt aioblescan --break-system-packages  
sudo python3 ble2mqtt.py
```

Si vous avez besoin d'utiliser pour une raison ou une autre `bluez`via `bluepy`  plutôt que `aioblescan`,  j'ai fait une déclinaison du script dans [mon fork du repository bleparser](https://github.com/rpeyron/bleparser/blob/master/examples/ble2mqtt_bluepy.py).


## Ajout de l'auto discovery pour Domoticz

Depuis 2022, Domoticz intègre nativement le protocole de découverte automatique MQTT de HomeAssistant. C'est maintenant la solution la plus simple pour intégrer un device par MQTT dans Domoticz, et évite l'implémentation des formats MQTT spécifiques à Domoticz.

J'ai donc ajouté au script d'exemple ble2mqtt cette fonctionnalité (script disponible dans [mon fork du repository bleparser](https://github.com/rpeyron/bleparser/blob/master/examples/)

```python
import json
import asyncio
from textwrap import wrap
from collections import defaultdict

import aioblescan as aiobs
from bleparser import BleParser
import paho.mqtt.client as mqtt

import os
LOCALCONFIG = "config.local.py"

SENSORS = [
    "C4:7C:8D:61:B0:52",
    "C4:7C:8D:62:D5:55",
    "A4:C1:38:56:53:84",
    ]
TRACKERS = [
    "C4:7C:8D:62:DD:9B"
    ]
AESKEYS = {
    "A4:C1:38:56:53:84": "a115210eed7a88e50ad52662e732a9fb",
}
MQTT_HOST = "IPV4 or hostname"
MQTT_PORT = 1883
MQTT_USER = "username"
MQTT_PASS = "password"
MQTT_SENSOR_BASE_TOPIC = ""
MQTT_TRACKER_BASE_TOPIC = ""

# Take local config if exists
if os.path.exists(LOCALCONFIG):
    exec(open(LOCALCONFIG).read())

## Setup MQTT connection
client = mqtt.Client()
client.username_pw_set(MQTT_USER, MQTT_PASS)
client.connect(MQTT_HOST, MQTT_PORT)
client.loop_start() # Will handle reconnections automatically

## Setup parser
parser = BleParser(
    discovery=False,
    filter_duplicates=True,
    sensor_whitelist=[bytes.fromhex(mac.replace(":", "").lower()) for mac in SENSORS],
    tracker_whitelist=[bytes.fromhex(mac.replace(":", "").lower()) for mac in TRACKERS],
    aeskeys={bytes.fromhex(mac.replace(":", "").lower()): bytes.fromhex(aeskey) for mac, aeskey in AESKEYS.items()},
)

SENSOR_BUFFER = defaultdict(dict)

def publish_ha_autodiscovery(mqtt_client, data, mac, state_topic):
    had_topic_prefix = "homeassistant/sensor/ble2mqtt/" + mac 
    had_topic_suffix = "/config"
    had_base_object = {
            "stat_t": state_topic,
            "name": mac , 
            "uniq_id": "ble2mqtt_"+mac,
            "state_class": "measurement",
            "dev": { "ids": mac.replace(":", ""), "name": mac, "sw_version": "ble2mqtt 0.1", "via_device": "ble2mqtt" },
            #"value_template": "{{ value_json.temperature }}",
            #"unit_of_measurement": "°C", 
            #"icon": "mdi:thermometer"
    }

    if ("temperature" in data):
        mqtt_client.publish(had_topic_prefix + "_temperature" + had_topic_suffix, json.dumps({**had_base_object,
            "dev_cla": "temperature", 
            "name": had_base_object["name"] + " Temperature", 
            "uniq_id": had_base_object["name"] + "_temperature",
            "val_tpl": "{{ value_json.temperature }}",
            "unit_of_meas": "°C", 
            "icon": "mdi:thermometer"
        }))
    
    if ("humidity" in data):
        mqtt_client.publish(had_topic_prefix + "_humidity" + had_topic_suffix, json.dumps({**had_base_object,
            "dev_cla": "humidity", 
            "name": had_base_object["name"] + " Humidity", 
            "uniq_id": had_base_object["name"] + "_humidity",
            "val_tpl": "{{ value_json.humidity }}",
            "unit_of_meas": "%", 
            "icon": "mdi:gauge"
        }))

## Define callback
def process_hci_events(data):
    sensor_data, tracker_data = parser.parse_raw_data(data)

    if tracker_data:
        mac = ':'.join(wrap(tracker_data.pop("mac"), 2))
        client.publish(f"{MQTT_TRACKER_BASE_TOPIC}/{mac}", json.dumps(tracker_data))

    if sensor_data:
        mac = ':'.join(wrap(sensor_data.pop("mac"), 2))

        old = SENSOR_BUFFER[mac]
        new = SENSOR_BUFFER[mac] = {**old, **sensor_data}

        if set(new.keys()) == set(old.keys()):
            # Buffer filled, lets publish!
            state_topic = f"{MQTT_SENSOR_BASE_TOPIC}/{mac}"
            client.publish(state_topic, json.dumps(new))
            publish_ha_autodiscovery(client, new, mac, state_topic)


## Get everything connected
loop = asyncio.get_event_loop()

#### Setup socket and controller
socket = aiobs.create_bt_socket(0)
fac = getattr(loop, "_create_connection_transport")(socket, aiobs.BLEScanRequester, None, None)
conn, btctrl = loop.run_until_complete(fac)

#### Attach callback
btctrl.process = process_hci_events
loop.run_until_complete(btctrl.send_scan_request(0))

## Run forever
loop.run_forever()

```

Cet auto discovery très basique ne supporte que les devices avec température / humidité, et fonctionne avec Domoticz. A noter que cela ne fonctionne pas Home Assistant (il doit manquer une partie du protocole, peut être la disponibilité), mais comme Home Assistant supporte nativement ce device d'une part, et a une intégration de bleparser officielle, ça n'aurait aucun sens d'utiliser ce script pour Home Assistant.

Il faut ensuite [ajouter le materiel permettant l'auto discovery](https://www.domoticz.com/wiki/MQTT#Add_hardware_.22MQTT_Auto_Discovery_Client_Gateway.22) (penser à désinstaller d'éventuels plugins d'Auto Discovery si vous en utilisiez avant l'intégration officielle par Domoticz, qui fonctionne bien mieux que les plugins précédents):

![]({{ 'files/2024/mitemp_domoticz_mqttautodiscovery.png' | relative_url }}){: .img-center .mw80}

Le thermomètre va alors apparaitre :

![]({{ 'files/2024/mitemp_domoticz_device.png' | relative_url }}){: .img-center .mw80}

Et voilà pour l'intégration du LYWSD02MMC dans Home Assistant !

# ESPHome / Home Assistant

Bon on va pas se mentir, la méthode ci-dessus n'est pas très simple à mettre en place... Et dans les différents tatonnements et tests pour faire cette intégration, j'ai eu l'occasion de retester Home Assistant. Je l'avais essayé à ses débuts il y a quelques années, et même si c'était déjà visuellement plus abouti que Domoticz, la différence de fonctionnalités et d'intégrations n'était pas encore importante, et le déploiement était un peu complexe. Le projet a depuis fait d'énormes progrès, et surpasse maintenant clairement Domoticz sur le nombre d'intégrations et la facilité d'utilisation. Pour le LYWSD02MMC, je n'ai littéralement rien eu à faire,  il a été parfaitement auto détecté sans rien faire après l'installation de HomeAssistant dans une VM de test disposant d'un récepteur Bluetooth, et[ la page d'aide du device](https://www.home-assistant.io/integrations/xiaomi_ble) fournit toutes les informations nécessaire pour l'ajout de la clé de déchiffrement. Un sans faute.

J'ai pu également découvrir ESPHome, qui permet via un ESP32, de mettre en place une passerelle BLE - Home Assitant externe au serveur qui fait tourner Home Assistant, ainsi que tout un tas d'autres intégrations de capteurs (pour lesquels j'utilisais classiquement [tasmota](https://tasmota.github.io/docs/)). 

Bref, l'écosystème est maintenant très convaincant, et je vais très certainement regarder pour migrer.


# Alternatives (non testées)
- Il existe un [plugin pour HomeBridge](https://github.com/hannseman/homebridge-mi-hygrothermograph) ; j'utilise HomeBridge  notamment pour exposer les appareils Domoticz via HomeKit (Apple) et Google Assistant (voir [cet article]({{ '/2022/08/piloter-votre-domotique-via-alexa-grace-a-ha-bridge-domoticz-ou-tasmota/' | relative_url }}))
- Il existe un [firmware alternatif pour LYWSD03MMC](https://github.com/atc1441/ATC_MiThermometer) ([si le firmware actuel n'est pas trop récent](https://peyanski.com/hacking-xiaomi-th-sensor-to-work-with-home-assistant/)) qui permet notamment de [supprimer le chiffrement](https://hackaday.com/2020/12/08/exploring-custom-firmware-on-xiaomi-thermometers/), et est compatible avec un certain nombre d'intégrations, mais l'espoir de pouvoir l'adapter pour le LYWSD02MMC est [faible, voire nul](https://github.com/atc1441/ATC_MiThermometer/issues/87)
- D'autres codes de parsers pour Xiaomi:
  - ESPHome: <https://github.com/esphome/esphome/blob/dev/esphome/components/xiaomi_ble/xiaomi_ble.cpp>
  - Bluetooth-Devices/xiaomi-ble: <https://github.com/Bluetooth-Devices/xiaomi-ble/blob/main/src/xiaomi_ble/parser.py> (package également disponible via pip)

---
title: Zigbee sous Home Assistant avec la box LIDL (Silvercrest TYGWZ-01)
lang: fr
tags:
- Home Assistant
- Zigbee
- Hacking
categories:
- Domotique
toc: 2
date: '2025-06-15 11:03:38'
image: files/2025/SilvercrestTYGWZ-01_vignette.png
---

À l'occasion d'une promotion chez Lidl j'ai acheté une box Zigbee Silvercrest à moins de 10 euros, un peu au pif compte tenu du faible prix, et dans l'idée d'ajouter une interface Zigbee à mon installation domotique Home Assistant.  Pas si simple, mais finalement une bonne affaire.

Si vous cherchez la facilité, je vous conseille une autre box ou une clé USB (quasiment au même prix). L'installation est bien sûr bien plus simple car la clé est automatiquement détectée et paramétrée par Home Assistant, mais malheureusement sur le modèle que j'ai testé, la très faible couverture la rendait inutilisable, d'où la nouvelle tentative avec cette box.

# Présentation de la box

![]({{ 'files/2025/SilvercrestTYGWZ-01.png' | relative_url }}){: .img-center .mw60}

Cette box est la plus ancienne de chez LIDL, et a priori remplacée par un modèle plus récent qui se distingue par ne pas avoir les petits trous sur son boitier et a priori [directement utilisable avec Home Assistant](https://www.domo-blog.fr/lidl-smart-home-box-domotique-zigbee-compatible-home-assistant/). Cette  box n'est pas Wifi, il faudra donc la connecter à votre routeur Wifi via un câble Ethernet. Elle est alimentée par USB, j'ai donc pu brancher Ethernet et USB directement sur mon routeur Wifi, ce qui est finalement assez pratique.

LIDL a créé tout son écosystème, avec son application, sa box, sa propre gamme de capteurs, etc. Je n'ai pas testé la gamme, mais il est mentionné sur plusieurs sites que les capteurs ne sont pas compatibles avec d'autres installations Zigbee, et j'ai pu constater quelques bugs sur l'application, qui n'arrivait pas à mettre à jour le dernier firmware de la box. Également, je n'ai jamais pu ajouter des capteurs Zigbee d'une autre marque que Silvercrest sur cette box. Bef je ne recommande pas spécialement l'écosystème Silvercrest.

# Hacking de la box
## Sources
Différents acteurs ont réussi à trouver le moyen d'utiliser cet appareil autrement ; vous allez voir que ce n'est pas simple, bravo à eux pour avoir réussi à trouver ces éléments ! La box a évolué dans le temps, nécessitant des petites variantes dans la méthode d'exploitation. Je cite en premier toutes les références qui m'ont été utiles et sans lesquelles cet article n'existerait pas :
- La [méthode originale de Paul Banks](https://paulbanks.org/projects/lidl-zigbee/#overview), avec de nombreux renseignements utiles sur la box, et [cette synthèse](https://zigbee.blakadder.com/Lidl_TYGWZ-01.html)
- Une [méthode alternative](https://github.com/parasite85/tuya_dmd2cc_gateway_hack)
- Des compléments dans le [forum Home Assistant](https://community.home-assistant.io/t/hacking-the-silvercrest-lidl-tuya-smart-home-gateway/270934/117 ) et le [forum OpenHab](https://community.openhab.org/t/hacking-the-lidl-silvercrest-zigbee-gateway-a-step-by-step-tutorial/129660)
- Une [méthode potentiellement plus rapide avec tftpd](https://community.home-assistant.io/t/hacking-the-silvercrest-lidl-tuya-smart-home-gateway/270934/498) que je n'ai pas testée

Je vais décrire ici la méthode qui a marché pour moi ; cela ne sera pas forcément la même pour vous, mais vous devriez trouver la solution alternative dans les liens ci-dessus.

## Branchement USB

Il faut avant tout ouvrir la box, et la connecter en USB à un PC pour pouvoir récupérer l'accès. J'ai pour cela utilisé un connecteur USB FTDI en 3.3V dont j'ai simplement inséré les connecteurs dupont dans les trous du circuit imprimé et en retournant le circuit pour maintenir un peu de pression sur les contacts. Et cela a suffit, pas besoin de soudure !

![]({{ 'files/2025/Silvercrest_USB_Connection.jpg' | relative_url }}){: .img-center .mw80}

Contrairement à ce qui est indiqué dans les articles, j'ai également branché l'alimentation du port USB directement pour plus de simplicité, en utilisant un port USB3 (un port USB2 ne délivre pas assez de puissance).

Il faut ensuite utiliser un terminal. Compte tenu des manipulations à faire, assurez-vous de prendre un terminal pratique à utiliser. La connexion est à 38400 bauds sut 8 bits. Pour ma part j'ai utilisé 
- sous Windows: [simplyserial](https://github.com/fasteddy516/SimplySerial) (`scoop instal simplyserial`) : `ss -com:7 -baud:38400` 
- sous Linux : minicom (`apt install minicom`) : `minicom -D /dev/ttyUSB2 -b 38400 -8` 


## Récupération du mot de passe root

Malheureusement [la méthode rapide décrite ici](https://paulbanks.org/projects/lidl-zigbee/root/) n'a pas fonctionné pour moi. J'ai donc opté pour l'extraction complète du firmware. L'extraction est très longue (~8h), prévoyez donc un setup qui permet d'opérer sur toute la durée. J'ai adapté le script de Paul Banks pour permettre l'arrêt puis la reprise. 

<p><details markdown='1'><summary>Cliquez pour le script dump.py avec reprise</summary>

```python
# Dump out flash from RTL bootloader... very slowly!
#====================================================
# Author: Paul Banks [https://paulbanks.org/]
#

import serial
import struct
import argparse
import os


def doit(s, fOut, start_addr=0, end_addr=16*1024*1024):

    # Get a couple of prompts for sanity
    s.write(b"\n")
    s.read_until(b"<RealTek>")
    s.write(b"\n")
    s.read_until(b"<RealTek>")

    print("Starting...")

    step = 0x100
    assert(step%4==0)
    for flash_addr in range(start_addr, end_addr, step):

        s.write(b"FLR 80000000 %X %d\n" % (flash_addr, step))
        print(s.read_until(b"--> "))
        s.write(b"y\r")
        print(s.read_until(b"<RealTek>"))

        s.write(b"DW 80000000 %d\n" % (step/4))

        data = s.read_until(b"<RealTek>").decode("utf-8").split("\n\r")
        for l in data:
            parts = l.split("\t")
            for p in parts[1:]:
                fOut.write(struct.pack(">I", int(p, 16)))
                fOut.flush()


if __name__=="__main__":

    parser = argparse.ArgumentParser("RTL Flash Dumper")
    parser.add_argument("--serial-port", type=str,
                        help="Serial port device - e.g. /dev/ttyUSB0")
    parser.add_argument("--output-file", type=str,
                        help="Path to file to save dump into")
    parser.add_argument("--start-addr", type=str, help="Start address",
                        default="0x0")
    parser.add_argument("--end-addr", type=str, help="End address",
                        default=hex(16*1024*1024))

    args = parser.parse_args()

    s = serial.Serial(args.serial_port, 38400)
    start_addr = int(args.start_addr, 0)
    end_addr = int(args.end_addr, 0)

    nameOut = args.output_file
    outMode = "wb"
    if os.path.exists(nameOut):
        taille = os.path.getsize(nameOut)
        print("Resuming ", taille,  " ...")
        start_addr = start_addr + taille
        outMode = "ab"

    with open(nameOut, outMode) as fOut:
        doit(s, fOut, start_addr, end_addr)


```

</details></p>

Le script nécessite le module `pycryptodome`, à installer dans un environnement virtuel pour éviter les conflits de version.
```sh
# Extraction 
python -m venv .venv 
.venv/bin/pip3 install pycryptodome 
.venv/bin/python3 dump.py --serial-port /dev/ttyUSB2 --output-file all.bin --start-addr 0x000000 --end-addr 0x000001000000
```

Pour que le script fonctionne, l'appareil doit être dans un mode spécial que l'on active en pressant `Esc` au démarrage. Pour que le port USB reste actif et pouvoir presser Esc juste après le boot, il ne faut pas débrancher/rebrancher la prise USB pour rebooter, mais seulement débrancher la pin d'alimentation et la remettre. Il vaut mieux s'entrainer quelques fois avec le terminal avant de lancer le script.

Ensuite, on découpe les partitions suivant les adresses que l'on voit sur la console lors du boot
```sh
# Découpage des partitions
cp all.bin flash_bank_1.bin
dd if=flash_bank_1.bin of=boot+cfg.bin    bs=1M iflag=skip_bytes,count_bytes    skip=$((0x000000))    count=$((0x020000))    status=progress
dd if=flash_bank_1.bin of=linux.bin    bs=1M iflag=skip_bytes,count_bytes    skip=$((0x020000))    count=$((0x1E0000))    status=progress
dd if=flash_bank_1.bin of=rootfs.bin    bs=1M iflag=skip_bytes,count_bytes    skip=$((0x200000))    count=$((0x200000))    status=progress
dd if=flash_bank_1.bin of=tuya-label.bin    bs=1M iflag=skip_bytes,count_bytes    skip=$((0x400000))    count=$((0x020000))    status=progress
dd if=flash_bank_1.bin of=jffs2-fs.bin    bs=1M iflag=skip_bytes,count_bytes    skip=$((0x420000))    count=$((0xBE0000))    status=progress
```

Nous avons maintenant besoin de l'outil `jefferson` pour extraire le format de partition `jffs2` : 
```sh
pip install jefferson
jefferson -d jffs2 jffs2-fs.bin
cd jffs2/jffs2-root/config
```

Vous devriez voir dans le répertoire `jffs2-root/config` deux fichiers `Licence.file1`  et `Licence.file2`.  Le script [lidl_auskey_decode.py](https://paulbanks.org/download/files/lidl-zigbee/lidl_auskey_decode.py) permet d'extraire les informations utiles (à lancer également depuis le virtualenv).

La sortie du script donne les clés tant cherchées:
```
Decrypted data
b'{"auzkey":"xN1e5Uhvc____YyjXArrd2CULAQNnm___","uuid":"c03808b8f8a3____","master_mac":
"10d56144_____","sn":"HMGW2113001_____","prodtest_exit":"true"}
\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f\x0f'
```

Le mot de passe root étant les 8 derniers caractères de auzkey, c'est donc ici `AQNnm___`   (une partie des identifiants est remplacée dans cet article par `_`). Gardez-le précieusement !

## Installation 

Avec le mot de passe root, vous pouvez maintenant booter normalement (sans `Esc`) et vous connecter en tant que root lors de l'invite, grâce au mot de passe récupéré. Une partie des opérations va maintenant nécessiter d'utiliser l'accès ssh, il faut donc connecter votre passerelle au réseau. Bien que l'accès physique à votre passerelle ne devrait plus être nécessaire, je vous conseille cependant de garder l'accès tant que toute la configuration n'est pas finie, car il est très facile sur une erreur de ne plus pouvoir se connecter en SSH. Si votre routeur n'est pas très accessible vous pouvez également tenter le partage de connexion entre le port Ethernet de votre PC et le Wifi. Le port ssh utilisé initialement est le port 2333. 

On peut reprendre alors les instructions [de cet article ](https://zigbee.blakadder.com/Lidl_TYGWZ-01.html):
- Le remplacement du lancement de ssh
```sh
if [ ! -f /tuya/ssh_monitor.original.sh ]; then cp /tuya/ssh_monitor.sh /tuya/ssh_monitor.original.sh; fi
echo "#!/bin/sh" >/tuya/ssh_monitor.sh
reboot
```
- Cependant le server ssh n'était pas lancé sur ma passerelle, il a fallu l'activer avec:
  1. `cat > /tuya/ssh_enable_flag ` + Ctrl-D
  2. ajout de `dropbear -p 22 -K 300` dans  ssh_monitor.sh (via vi)

Au reboot il devrait être maintenant possible de vous connecter via ssh. Compte tenu des capacités réduites, vous devrez sans doute ajouter des paramètres pour forcer votre client ssh à utiliser ces algorithmes obsolètes
```sh
ssh -p22 -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa root@<ip de la passerelle>
```

- Il faut ensuite transférer le fichier [serialgateway.bin](https://paulbanks.org/download/files/lidl-zigbee/serialgateway.bin) sur la passerelle ; je n'ai pas réussi à faire fonctionner depuis Windows (sans doute les retours chariots), donc j'ai poursuivi depuis Linux : `cat serialgateway.bin | ssh -x -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa root@192.168.0.154 "cat >/tuya/serialgateway"` 

- Et finaliser l'installation avec le lancement de la gateway serie

```sh
if [ ! -f /tuya/tuya_start.original.sh ]; then cp /tuya/tuya_start.sh /tuya/tuya_start.original.sh; fi

cat >/tuya/tuya_start.sh <<EOF
#!/bin/sh
/tuya/serialgateway &
EOF
chmod 755 /tuya/serialgateway

reboot
```

- Vous pouvez également faire la mise à jour de version EZSP (facultatif) ; suivez la procédure [de cet article ](https://zigbee.blakadder.com/Lidl_TYGWZ-01.html), et si nécessaire pour votre cilent ssh, modifier 3x la commande ssh dans le script pour ajouter ` -x -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa ` .


# Configurer Home Assistant

Vous pouvez maintenant refermer votre box et l'installer comme vous souhaitez. La configuration sous Home Assistant est assez simple :
1. Dans les intégrations, chercher `ZHA`
2. Choisissez ensuite la méthode manuelle
3. Choisir "EZSP" comme Radio Type
4. A l'emplacement du port série, entrer `socket://[gateway_ip]:8888` en remplaçant[gateway_ip] pas son adresse IP (pas de DNS).
5. Utiliser la vitesse de 115200

Et voilà ! Vous pouvez maintenant ajouter des devices [Zigbee](https://www.home-assistant.io/integrations/zha/)

# Conclusion

La couverture de la box est plutôt bonne, bien meilleure que la clé USB Zigbee pas chère que j'avais testée, et la stabilité est très bonne. Bref, un succès ! C'est la solution que j'ai gardée.

Il est sans doute également possible de faire d'autre choses avec cette box car on a à dispostion un environnement Linux embarqué qui offre beaucoup de possibilités,certes limitées par la faible puissance de l'appareil.

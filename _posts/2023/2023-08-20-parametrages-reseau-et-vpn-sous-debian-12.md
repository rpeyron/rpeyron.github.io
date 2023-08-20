---
title: Paramétrages réseau et VPN sous debian 12
lang: fr
tags:
- Linux
- Debian
- Configuration
categories:
- Informatique
toc: 'yes'
date: '2023-08-20 15:49:56'
image: files/2023/debian_network_zoo_sdxl.jpg
---

Je boudais injustement NetworkManager depuis des années car je n'avais pas compris son architecture, et pensais à tort qu'il s'agissait d'un logiciel propre à la session utilisateur. Mais il s'agit bien d'un service complet exécuté sans session utilisateur, mais commandable depuis la session. Il comporte désormais quasiment toutes les fonctions principales utiles et facilement paramétrables. Il sait également cohabiter avec les autres gestionnaires réseau.

# Réseau ethernet fixe sur /etc/network/interfaces

J'ai donc opté pour une configuration fixe via `/etc/network/interfaces`, avec l'utilisation du DHCP + le forçage d'une IP fixe (le bail fixe est parfois bizarrement perdu sur la Freebox, et pas toujours supporté sur les autres box): 
```
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

dns-nameservers 1.1.1.1 8.8.8.8 192.168.0.254

# The primary network interface
allow-hotplug enp4s0
iface enp4s0 inet dhcp

# This is an autoconfigured IPv6 interface
iface enp4s0 inet6 auto

#Static server adress
auto enp4s0.0
iface enp4s0.0 inet static
  address 192.168.0.1
  broadcast 192.168.0.255
  netmask 255.255.255.0
  #gateway 192.168.0.254
  #post-up /sbin/route add default gw 192.168.0.254 dev enp4s0
```

À noter que les noms des interfaces ont changé, et sont bien plus complexes à retenir que les précédents eth0 / wlan0 (mais dont la numérotation pouvait ne pas être stables en cas de modifications matérielles sur d'interfaces multiples)

J'ai aussi ajouté les DNS Cloudflare (1.1.1.1) et Google (8.8.8.8) qui ont l'avantage d'être très rapides.


# VPN

J'utilisais jusqu'à présent un VPN basé sur PPTP mais qui est devenu inaccessible depuis Android depuis quelques années, et en regardant visiblement le protocole est obsolète et plus suffisament sécurisé. L'occasion de passer sur IPSec/IKEv2 maintenant que le support Android est natif.

J'ai commencé par suivre un tutoriel avec les packages debian, mais sans succès. J'ai trouvé ensuite un [github hwdsl2](https://github.com/hwdsl2/setup-ipsec-vpn)  qui semble très expert sur le sujet etmet à disposition des scripts d'installation prêts à l'emploi. Comme le script est à exécuter en root, il convient de regarder s'il ne fait rien de méchant avant de le lancer, ce qui est le cas. Une fois exécuté, le VPN fonctionne immédiatement !  

Par contre le routage externe ne fonctionne pas, il faut aller modifier dans `/etc/ipsec.d/ikev2.conf` pour mettre l'adresse locale dans `left=`et mettre le bon `leftsubnet=`du réseau local.

Enfin, le script installe en local une version du logiciel libreswan, alors qu'il existe une version dans debian. J'ai donc pris l'option de rebasculer sur la version debian, pour bénéficier de la mise à jour automatique. Il suffit pour cela d'installer le package debian en laissant les fichiers de configuration créés par le script, et de supprimer dans `/usr/local/`la version du script.

Il est également possible d'ajouter un VPN directement sur une [Freebox](https://freedom-ip.com/fr/aide-et-tutoriels/openvpn_freebox) avec de nombreux types de VPN supportés.



# WiFi via NetworkManager


Pour le paramétrage du WiFi j'ai opté pour NetworkManager, qui a l'énorme avantage de permettre très simplement le paramétrage d'un access point sans la complexité de la configuration wpasupplicant que j'utilisais précédemment. Il est également possible de gérer une priorités dans les connexions, ce qui permet de paramétrer l'activation de l'access point automatiquement si le wifi de la box est désactivé.

Mais par défaut, l'interface graphique NetworkManager sous un utilisateur classique demande le mot de passe à chaque action, voire plusieurs fois par action, ce qui est vite pénible. Il est possible de rajouter une règle à la politique de sécurité, en créant le fichier ci-dessous:

/etc/polkit-1/localauthority/50-local.d/10-network-manager.pkla
```
[Allow wi-fi operations for all users]
Identity=unix-user:*
Action=org.freedesktop.NetworkManager.wifi.scan;org.freedesktop.NetworkManager.enable-disable-wifi;org.freedesktop.NetworkManager.settings.modify.own;org.freedesktop.NetworkManager.settings.modify.system;org.freedesktop.NetworkManager.network-control
ResultAny=yes
ResultInactive=yes
ResultActive=yes
``` 
*([source](https://askubuntu.com/questions/1220076/networkmanager-constantly-prompts-for-admin-password))*

A noter qu'avec VNC, les demandes incessantes de mot de passe peuvent entrainer une perte de focus qui empêche tout usage clavier ou souris. Pour s'en sortir, il existe un outil bien pratique qui permet d'envoyer des actions clavier / souris à distance depuis un autre terminal. Il faut installer le paquer `xdotool`  ([source](https://linuxhint.com/xdotool_stimulate_mouse_clicks_and_keystrokes/)). Exemples :
```
export DISPLAY=":1"
xdotool key Escape
xdotool mousemove 100 100 click
```

La création d'un accesspoint se fait très simplement par la création d'une interface hotspot avec NetworkManager, et en sélectionnant le mode shared / "partagé avec d'autres ordinateurs".  Mais bizarrement le routage ne fonctionne pas immédiatement, sans doute à cause de règles firewall. J'ai donc attribué une place d'IP sur le même subnet que le VPN créé précédemment pour bénéficier des règles firewall paramétrées à cette occasion. A cette étape, le routage fonctionne, mais ne propose pas de DNS, ce qui fait que les clients vont détecter une absence de connexion internet. On peut effectivement observer qu'aucun DNS n'a été fourni aux clients, et que tout rentre dans l'ordre si on force un DNS externe. Le DNS local ne fonctionne pas, il manque peut-être une règle de routage firewall, mais j'ai finalement opté pour forcer de forcer l'annonce d'un DNS externe dans la requête DHCP. Le mode partagé de NetworkManager créée une instance dédiée de dnsmasq pour la gestion des annonces DHCP. Pour le paramétrer, il faut créer le fichier suivant :

/etc/NetworkManager/dnsmasq-shared.d/10-ns-server.conf 
```
 dhcp-option=option:dns-server,8.8.8.8
```
([source](https://fedoramagazine.org/internet-connection-sharing-networkmanager/))

---
post_id: 5178
title: 'Reverse engineering TV Remote Panasonic &#8211; Quelques techniques simples'
date: '2020-12-24T15:00:26+01:00'
last_modified_at: '2020-12-24T21:24:18+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5178'
slug: reverse-engineering-tv-remote-panasonic-quelques-techniques-simples
permalink: /2020/12/reverse-engineering-tv-remote-panasonic-quelques-techniques-simples/
image: /files/2020/12/kisspng-wireshark-packet-analyzer-computer-software-protoc-leopard-shark-5b249064bbfc40.61560480152912291677.png
categories:
    - Informatique
tags:
    - 'Reverse engineering'
    - panasonic
    - tutoriel
lang: fr
---

Lors de mon [adaptation du plugin PanasonicTV](/2020/12/domoticz-panasonic-remote-buttons-and-custom-urls/) de Domoticz, il était nécessaire de connaître un peu mieux le fonctionnement du protocole UPnP de ma télévision Panasonic (modèle 47AS650E de 2014). Panasonic met à disposition une application android [TV Remote 2](https://play.google.com/store/apps/details?id=com.panasonic.pavc.viera.vieraremote2&hl=fr&gl=US) qui comporte toutes les fonctions qui m’intéressent. L’occasion de mettre en œuvre quelques techniques simples de reverse engineering au travers de 2 méthodes illustrées ci-dessous.

# Inspecter le trafic réseau avec Wireshark

La solution la plus simple à mettre en œuvre est l’inspection des échanges réseau avec l’excellent outil [Wireshark](https://www.wireshark.org/). C’est un logiciel qui va vous permettre d’écouter tous les échanges sur une interface réseau. Il nécessite bien sûr des droits d’administrateur pour être exécuté. Il faut bien sûr pour que cela fonctionne que les échanges à inspecter passent effectivement par cette interface réseau.

Pour en être sûr le plus simple est d’installer l’application sur un émulateur Android sur le PC qui exécute Wireshark. J’ai utilisé [MEmu](http://www.memuplay.com/) qui s’est avéré parfait pour cela. Une fois l’émulateur installé il faut télécharger l’application. Pour éviter d’avoir à enregistrer mon compte sur l’émulateur pour accéder au Play Store il est possible de télécharger directement le fichier apk, via un des nombreux sites web qui proposent ce service, comme [apkpure.com](https://apkpure.com/fr/search?q=panasonic+tv+remote+2), puis de l’installer via le bouton “APK” sur le côté. Pour que le logiciel puisse échanger avec la TV en UPnP il est nécessaire que les appareils soient sur le même réseau. Or par défaut MEmu fonctionne en NAT, il faut donc le paramétrer pour utiliser un mode bridge (“réseau ponté”) et que l’émulateur apparaisse comme un nouvel appareil sur le même réseau que l’ordinateur :

![](/files/2020/12/Memu-Bridge.png){: .img-center}

Une fois ce mode sélectionné, le logiciel va vous demander d’installer un pilote supplémentaire et de redémarrer le logiciel. Il faudra revenir à nouveau dans cet écran pour pouvoir venir sélectionner l’interface réseau à utiliser :

![](/files/2020/12/memu_adaptateur.png){: .img-center}

Du côté de Wireshark les choses sont assez simples. Sélectionnez votre interface réseau, lancez la capture, et vous allez voir tous les échanges réseau… et il y en a beaucoup… C’est tout à fait possible de s’y retrouver comme ça, mais pour y voir plus clair un simple paramétrage est possible. Premièrement, on va filtrer uniquement les échanges qui concernent la TV. Pour cela on va filtrer par IP de la TV (192.168.0.43 dans mon cas et dans les exemples ci-dessous), en mettant `ip.addr == 192.168.0.43` dans la barre de filtre (ip.addr pour les échanges entrants/sortants, ou si vous ne voulez qu’un des deux sens il existe ip.src et ip.dst). Ensuite l’UPnP se base sur du SOAP sur HTTP mais sur un port non standard. Pour indiquer à Wireshark de décoder le HTTP sur ce port il faut soit cliquer droit sur un des paquets et sélectionner “Decode As…”, ou modifier dans les options (port 50000 pour l’UPnP Panasonic)

![](/files/2020/12/Wireshark-custom-HTTP-port.png){: .img-center}

Pour y voir encore plus clair, indiquer comme filtre de capture à Wireshark (ssdp or http) and (`ip.addr == 192.168.0.43`) pour n’afficher que les échanges SSDP ou HTTP avec la TV. Tout est prêt il est temps de lancer la capture Wireshark et de lancer l’application TV Remote 2 depuis l’émulateur android.

![](/files/2020/12/wireshark_panasonic.png){: .img-center}

Et magie, la commande à envoyer pour récupérer la liste des applications est complètement visible. La commande à envoyer était simplement X\_GetAppList ! L’ensemble des informations à envoyer est disponible ; il faut faire attention de bien respecter à la lettre aussi bien le contenu XML que les headers HTTP.

# Décompiler l’application et se documenter sur le protocole

Si la méthode ci-dessus est la plus simple, il existe des cas pour lesquels il n’est pas possible de la mettre en œuvre. Par exemple si vous n’être pas administrateur de votre poste de travail, si le trafic est crypté (pour le https il existe des proxys comme [mitmproxy](https://mitmproxy.org/)), ou encore s’il n’existe pas d’émulateur pour ce que vous voulez analyser. Il est alors possible d’essayer de deviner le fonctionnement à partir du binaire.

Après avoir récupéré le binaire, la première chose est de voir s’il existe un décompilateur/désassembleur. Il en existe généralement une multitude, plus ou moins complets et plus ou moins faciles à utiliser. Pour android, j’ai utilisé le service web [javadecompilers.com](http://www.javadecompilers.com/) (sans désassembler, vous pouvrez aussi simplement extraire l’archive en renommand le fichier apk en .zip ; la suite de l’article montrera qu’ici ça aurait été suffisant). Il suffit d’uploader le fichier apk et de récupérer l’archive décompiler, impossible de faire plus simple. S’il n’existe pas de décompilateur pas de panique ça se tente tout de même 😉

La deuxième chose est de trouver un angle d’attaque, une première recherche à faire. Si vous n’en avez aucune idée, vous pouvez toujours regarder au pif les fichiers de code (en ciblant les plus gros) dans l’espoir de trouver des identifiants un peu parlants, mais comme les noms sont souvent perdus dans la décompilation, c’est assez incertain. Internet est une meilleure option, vous n’êtes sans doute pas la première personne à vous intéresser au sujet. Cherchez des informations techniques, des bouts de code, avec des mots clés qui permettent de s’écarter du bruit marketing autour du produit (ex : nomproduit protocol, nomproduit firmware, nomproduit php, nomproduit python,…). Dans mon cas, d’une part il est assez évident de savoir qu’il s’agit du protocole UPnP, et d’autre part il est facile de trouver pas mal de bouts de code, plugins et autres pour contrôler la TV.

UPnP est né dans l’ère SOAP et est aussi peu pratique que ce dernier… De ce que j’ai pu observer, il semble que le fonctionnement soit le suivant :  
1. L’appareil UPnP diffuse périodiquement des paquets SSDP pour s’annoncer. Il y a un paquet SSDP (Simple Service Discovery Protocol) “notify” par service, et une SmartTV dispose classiquement de plusieurs devices (MediaServer, DMR, RenderingControl, NetworkControl,…) Dans la notification il y a un champ Location qui correspond à une URL de description du device. (Pour le Panasonic Network Control : http://192.168.0.43:55000/nrc/ddd.xml)  
2. Ce fichier de description décrit le device et la liste des services offerts par le device. Pour chaque service il y a à nouveau une autre URL vers la description du service (Pour celui qui nous intéresse : http://192.168.0.43:55000/nrc/sdd\_0.xml)  
3. Dans le fichier descriptif du service, il y a la liste des actions disponibles ainsi que les paramètres entrée/sortie. Malheureusement sans plus d’explications… Quand les identifiants ne commencent pas par “X\_” cela signifi que qu’ils sont normalisés et qu’il doit être possible de trouver quelque part une spécification qui explique le fonctionnement et les valeurs attendues. Mais pour les identifiants en “X\_” inutile de chercher, c’est propriétaire…  
Voilà pour la très courte introduction à UPnP. Pour maîtriser le sujet, la référence est [la spécification UPnP Device Architecture](https://web.archive.org/web/20151107123618/http://www.upnp.org/specs/arch/UPnP-arch-DeviceArchitecture-v1.1.pdf).

Revenons à notre cas. Dans le fichier descriptif du service je trouve bien les fonctions X\_SendKey et X\_LaunchApp pour envoyer des touches et lancer des applications, mais pas moyen de trouver de méthode pour récupérer la liste des applications. Il en existe bien une qui s’appelle X\_GetAppInfo dont le nom est intéressant :

<details markdown="1"><summary>X_GetAppInfo PHP script (cliquer pour déplier)</summary>
```php
<?php
$operation = "X_GetAppInfo";

$input = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
$input .= "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n";
$input .= "<s:Body>\n";
$input .= "<u:$operation xmlns:u=\"urn:panasonic-com:service:p00NetworkControl:1\">\n";
$input .= "<u:X_InfoType></u:X_InfoType>\n";
$input .= "</u:$operation>\n";
$input .= "</s:Body>\n";
$input .= "</s:Envelope>\n\n";

$header = array(
"Content-type: text/xml;charset=\"utf-8\"",
"Accept: text/xml",
"Cache-Control: no-cache",
"Pragma: no-cache",
"SOAPACTION: \"urn:panasonic-com:service:p00NetworkControl:1#$operation\"",
"Content-Length: ".strlen($input),
);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'http://192.168.0.43:55000/nrc/control_0');
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
curl_setopt($curl, CURLOPT_POSTFIELDS, $input);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  if(($result = curl_exec($curl)) === false) {
    $err = 'Curl error: ' . curl_error($curl);
    curl_close($curl);
    print $err;
  } else {
    curl_close($curl);
    print 'Operation completed without any errors';
	print $result;
  }
?>
```

</details><br>

Malheureusement le résultat est mitigé, pour certaines applications ça marche, je récupère bien l’identifiant de l’application. Par exemple :

```
Pour YouTube : <X_AppInfo>vc_app:1:product_id=0070000200000001:YouTube</X_AppInfo>
Pour Netflix : <X_AppInfo>vc_app:7:product_id=0010000200000001:Netflix</X_AppInfo>

```

Mais parfois c’est complètement vide. Impossible de savoir pourquoi, et comment faire pour trouver l’identifiant systématiquement.

Or l’application Android le permet, donc ça doit bien être possible quelque part. Après avoir tenté sans succès dans quelques fichiers sources, je décide de chercher la chaine “X\_SendKey” que je sais devoir être assez proche dans le code de là où je dois regarder :

`fgrep -r "X_SendKey" apk/`

*(avec apk/ qui est le nom du répertoire dans le quel j’ai décompressé l’archive issue du décompilateur)*

Et surprise, la chaine n’est pas trouvée dans le code, mais dans une bibliothèque libtvconnect.so disponible pour x86, armeabi et armeabi-v7a. S’il est possible de décompiler aussi des binaires natifs c’est bien plus difficile à exploiter. Mais si fgrep a pu trouver la chaine de caractère `X_SendKey` il est probable que celle que je cherche soit également lisible. Pour ceci il existe une commande très pratique ‘`strings`‘ qui va extraire d’un binaire tout ce qui ressemble à une chaine de caractère un peu potable.

`strings libtvconnect.so > libtvconnect.strings`

Ensuite, il suffit d’ouvrir le fichier dans un éditeur de texte, de chercher à nouveau `X_SendKey` et on le retrouve au milieu de plein d’autres commandes, dont une dont le nom est bougrement intéressant `X_GetAppList`. Le plus dur est fait, il suffit alors d’adapter un script UPnP pour tester la commande, et nos identifiants d’applications sont là !

```php
<?php
$operation = "X_GetAppList";

$input = "\n";
$input .= "\n";
$input .= "\n";
$input .= "<u:$operation xmlns:u=\"urn:panasonic-com:service:p00NetworkControl:1\">\n";
$input .= "\n";
$input .= "</u:$operation>\n";
$input .= "\n";
$input .= "\n\n";

$header = array(
"Content-type: text/xml;charset=\"utf-8\"",
"Accept: text/xml",
"Cache-Control: no-cache",
"Pragma: no-cache",
"SOAPACTION: \"urn:panasonic-com:service:p00NetworkControl:1#$operation\"",
"Content-Length: ".strlen($input),
);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'http://192.168.0.43:55000/nrc/control_0');
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
curl_setopt($curl, CURLOPT_POSTFIELDS, $input);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  if(($result = curl_exec($curl)) === false) {
    $err = 'Curl error: ' . curl_error($curl);
    curl_close($curl);
    print $err;
  } else {
    curl_close($curl);
    print 'Operation completed without any errors';
	print $result;
  }
?>
```

Renvoie bien la liste des identifiants disponibles :

```
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<s:Body>
<u:X_GetAppListResponse xmlns:u="urn:panasonic-com:service:p00NetworkControl:1">
<X_AppList>
vc_app&apos;Unknown&apos;product_id=0387878700000032&apos;Lecteur multim├®dia&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000032&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000014&apos;Serveur Media&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000014&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0070000200000001&apos;YouTube&apos;http://192.168.0.43:55000/nrc/app_icon/0070000200000001&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000016&apos;VIERA Link&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000016&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0387878700000064&apos;Screen Market&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000064&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0387878700000062&apos;Apps Market&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000062&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0077777700140002&apos;Web Browser&apos;http://192.168.0.43:55000/nrc/app_icon/0077777700140002&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000003&apos;Guide TV&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000003&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000013&apos;T├®l├® enreg.&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000013&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000049&apos;Yans─▒tma&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000049&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000017&apos;Image incrust├®e&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000017&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0076002307000001&apos;Digital Concert Hall&apos;http://192.168.0.43:55000/nrc/app_icon/0076002307000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0010000200000001&apos;Netflix&apos;http://192.168.0.43:55000/nrc/app_icon/0010000200000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020000600000001&apos;ARTE&apos;http://192.168.0.43:55000/nrc/app_icon/0020000600000001&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000056&apos;my Stream&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000056&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0070000600000001&apos;Skype&apos;http://192.168.0.43:55000/nrc/app_icon/0070000600000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020007600000001&apos;Deezer&apos;http://192.168.0.43:55000/nrc/app_icon/0020007600000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0010001800000001&apos;TuneIn&apos;http://192.168.0.43:55000/nrc/app_icon/0010001800000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020001200000001&apos;CineTrailer&apos;http://192.168.0.43:55000/nrc/app_icon/0020001200000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020007100000001&apos;Meteonews TV&apos;http://192.168.0.43:55000/nrc/app_icon/0020007100000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020002A00000002&apos;Cinema&apos;http://192.168.0.43:55000/nrc/app_icon/0020002A00000002&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000009&apos;Menu principal&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000009&apos;Unknown&gt;
vc_app&apos;Unknown&apos;product_id=0387878700000001&apos;TV&apos;http://192.168.0.43:55000/nrc/app_icon/0387878700000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0020001000000001&apos;euronews&apos;http://192.168.0.43:55000/nrc/app_icon/0020001000000001&apos;Unknown&gt;
vc_app&apos;Stop&apos;product_id=0070000C00000001&apos;AccuWeather.com&apos;http://192.168.0.43:55000/nrc/app_icon/0070000C00000001&apos;Unknown</X_AppList>
</u:X_GetAppListResponse>
</s:Body>
</s:Envelope>

```

A noter que l’implémentation de Panasonic est particulièrement capricieuse et ne tolère aucune fantaisie dans le message envoyé ou dans les headers. Ainsi toutes mes tentatives avec des outils comme RESTed ou Postman ont été des échecs et une pure perte de temps à cause de headers ajoutés par les outils ou le navigateur.

Quelques autres scripts pour tester quelques actions (basés sur ce [script PHP](http://cocoontech.com/forums/topic/21266-panasonic-viera-plasma-ip-control/page-4) ) :

<details markdown="1"><summary>X_SendKey PHP script (cliquer pour déplier)</summary>```php
<?php
$action = "NRC_HDMI2-ONOFF";

$operation = "X_SendKey";

$input = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
$input .= "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n";
$input .= "<s:Body>\n";
$input .= "<u:$operation xmlns:u=\"urn:panasonic-com:service:p00NetworkControl:1\">\n";
$input .= "<X_KeyEvent>";
$input .= $action;
$input .= "</X_KeyEvent>\n";
$input .= "</u:$operation>\n";
$input .= "</s:Body>\n";
$input .= "</s:Envelope>\n\n";

$header = array(
"Content-type: text/xml;charset=\"utf-8\"",
"Accept: text/xml",
"Cache-Control: no-cache",
"Pragma: no-cache",
"SOAPACTION: \"urn:panasonic-com:service:p00NetworkControl:1#$operation\"",
"Content-Length: ".strlen($input),
);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'http://192.168.0.43:55000/nrc/control_0');
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
curl_setopt($curl, CURLOPT_POSTFIELDS, $input);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  if(($result = curl_exec($curl)) === false) {
    $err = 'Curl error: ' . curl_error($curl);
    curl_close($curl);
    print $err;
  } else {
    curl_close($curl);
    print 'Operation completed without any errors';
	print $result;
  }
?>
```

</details>

<details markdown="1"><summary>X_LaunchApp PHP script (cliquer pour déplier)</summary>```php
<?php

$operation = "X_LaunchApp";

$input = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
$input .= "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n";
$input .= "<s:Body>\n";
$input .= "<u:$operation xmlns:u=\"urn:panasonic-com:service:p00NetworkControl:1\">\n";
$input .= "<X_AppType>vc_app</X_AppType>\n";
$input .= "<X_LaunchKeyword>product_id=0387878700000013</X_LaunchKeyword>\n";
$input .= "</u:$operation>\n";
$input .= "</s:Body>\n";
$input .= "</s:Envelope>\n\n";



$header = array(
"Content-type: text/xml;charset=\"utf-8\"",
"Accept: text/xml",
"Cache-Control: no-cache",
"Pragma: no-cache",
"SOAPACTION: \"urn:panasonic-com:service:p00NetworkControl:1#$operation\"",
"Content-Length: ".strlen($input),
);
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'http://192.168.0.43:55000/nrc/control_0');
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_HTTPHEADER, $header); 
curl_setopt($curl, CURLOPT_POSTFIELDS, $input);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  if(($result = curl_exec($curl)) === false) {
    $err = 'Curl error: ' . curl_error($curl);
    curl_close($curl);
    print $err;
  } else {
    curl_close($curl);
    print 'Operation completed without any errors';
	print $result;
  }
?>
```

</details>


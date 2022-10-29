---
post_id: 4289
title: 'Logithèque Windows 2020'
date: '2020-05-02T18:08:15+02:00'
last_modified_at: '2020-05-02T18:08:35+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4289'
slug: logitheque-windows-2020
permalink: /2020/05/logitheque-windows-2020/
image: /files/2020/05/MenuDemarrer-2020.png
categories:
    - Informatique
tags:
    - Logithèque
    - Windows
lang: fr
---

Suite à une réinstallation de Windows 10, l’occasion de fait un point sur les logiciels que j’utilise au quotidien sous Windows 10 en 2020 :

- La base pour l’utilisation quotidienne : 
    - Navigateur Google Chrome, pour le surf Internet bien sûr, et utiliser les services GMail, Drive, Feedly, Pocket, Whatsapp
    - LibreOffice pour l’usage bureautique ; j’ai opté pour cette suite logicielle depuis StarOffice, puis OpenOffice.org, et maintenant LibreOffice, et pour un usage personnel c’est absolument parfait.
    - Spotify en client lourd, plus agréable que l’interface web
    - Skype
    - Un client VNC pour me connecter à mon serveur Linux ; j’utilise une vieille version portable de VNC Viewer 5.3 de RealVNC, leur dernière version étant insupportable. J’installe en complément un TightVNC qui me sert comme serveur VNC pour mon Windows.
    - Thunderbird, pour avoir une copie locale de mes mails ; pour l’usage des mails j’utilise l’interface GMail web, pour pouvoir utiliser mes mails de n’importe quel device.
    - KeePass (en version portable), pour la gestion de mes mots de passe
    - SyncThing (via l’IHM SyncTrayzor) pour la synchronisation et sauvegarde de mes documents avec mon serveur et autres devices
    - GoodSync pour la synchronisation périodique de mes autres contenus plus gros ; c’est un logiciel payant très performant qui permet un contrôle total sur les synchronisations et qui s’est montré jusqu’à présent très fiable. J’ai eu un peu de mal à télécharger la version qui correspond à ma licence car visiblement l’éditeur souhaite y mettre fin. C’est normal, les éditeurs de logiciels payants ne peuvent pas maintenir pendant des années gratuitement leurs logiciels, mais il est probable que j’évaluerais la capacité de SyncThing avant d’envisager de le racheter pour la troisième fois.
    - Insync pour la synchronisation des fichiers de plusieurs comptes Google Drive ; c’est un logiciel payant dont j’ai pu bénéficier d’une licence gratuite pendant leur phase de test, bien utile depuis que Google a remplacé son client par le ‘bizarre’ Sync and Backup et qui ne supportait toujours pas plusieurs comptes
- Pour le développement : 
    - SciTE, l’éditeur de Scintilla, qui est gratuit, très léger, et très efficace pour l’édition rapide d’un fichier seul.
    - VSCode qui est gratuit, multiplateforme, relativement léger par rapport à ses concurrents, et dispose d’un formidable écosystème d’extensions ; je ne lui reproche que sa déroutante “palette” et l’absence de menus/toolbars classiques. C’est mon éditeur par défaut dès que je travaille sur un projet et que SciTE devient limité, et pour des projets python/js/php.
    - Visual Studio Community pour les projets C/C++ même si sa taille XXXL a tendance à m’exaspérer, que je galère à chaque nouvelle édition pour retrouver un environnement fonctionnel, et que je n’en utilise sans doute pas 1% des possibilités, cela reste le meilleur pour l’édition et débogage C/C++ sous Windows. C’est mon IDE principal pour la maintenance de RPhoto, xmlTreeNav &amp; libxmldiff.
    - VMWare Player pour la gestion des machines virtuelles, que je préfère depuis quelques années à VirtualBox pour son mode non persistant des disques virtuels (qui n’est malheureusement plus disponibles dans l’IHM, mais qu’on peut ajouter à la main dans les fichiers VMX) : cela permet ainsi de tester n’importe quel logiciel mais de garder une image disque toujours propre. Sous Linux j’utilise plutôt QEmu-KVM qui permet plus facilement un accès VNC sur la VM.
    - PoEdit pour la localisation des applications et l’édition des fichiers .po
    - PuTTY pour l’accès en SSH à mon serveur Linux (lorsque VNC ne marche plus) ou à un raspberry.
    - VcXsrv qui est un serveur X gratuit pour Windows, et qui permet ainsi d’avoir accès à l’interface graphique d’un Ubuntu installé sous Windows via le Windows Subsystem for Linux (WSL). J’ai surtout utilisé pour tester car au final je préfère quand même utiliser une VM
    - InnoSetup et son Studio pour la création des installeurs (même si personnellement je préfère toujours les versions portables c’est principalement ce qu’utilisent les personnes qui téléchargent RPhoto / xmlTreeNav)
- Pour la 3D / maker : 
    - Fusion 360, la référence pour la modélisation 3D dans le monde des makers, un grand merci à Autodesk d’offrir cette suite professionnelle gratuitement aux makers, que ce soit pour la modélisation paramétrique, la simulation,…
    - Cura, un slicer 3D puissant mais qui reste simple d’accès
    - OpenSCAD, lorsque je suis suffisamment motivé pour faire une pièce via ce langage de programmation ; l’avantage est l’intégration native de la gestion paramétrique dans Thingiverse, mais le langage devient très galère dès l’utilisation de fillet ou thread…
    - Fritzing pour l’édition des projets arduino ; cet outil permet de gérer à un même endroit le circuit électronique et le code
- Autres programmes / utilitaires : 
    - 7-zip pour une gestion un peu plus puissante des archives qu’en standard dans Windows
    - Cyberlink Power2Go &amp; Media Player dont le mérite est d’être fourni avec mon PC pour la gravure DVD et la licence codec MPEG2 ; même si je ne me souviens même plus de la dernière gravure, ou même dernière utilisation d’un CD… Sans doute mon dernier PC avec un lecteur…
    - ElitechLog\_Win qui me permet la lecture des enregistrements d’un enregistreur de température Elitech RC-4
    - GeoSetter qui permet de manipuler les coordonnées GPS de photos. Cela permet notamment de géocoder des photos prises en voyages avec une trace GPS enregistrée sur son téléphone (ou simplement via celle que Google construit automatiquement pour vous et qui est téléchargeable, mais moins précise que celle que vous pourrez enregistrer)
    - FSViewer pour trier facilement les photos
    - Minitool Partition Wizard Pro, un super gestionnaire de partition très puissant, qui dispose d’une version gratuite déjà très utile, et dont j’ai pu avoir une licence Pro via un ‘giveaway’
    - Les nouveaux PowerToys microsoft, notamment pour le PowerRename
    - FreeCommander notamment pour trier/ranger des fichiers plus facilement avec le système de double panneaux
    - LiberKey pour l’installation d’un certain nombre de programmes portables utilisés ponctuellement, comme Gimp, Inkscape, Firefox, VLC
- Dans les outils Windows, notamment : 
    - “Assistance rapide” pour le dépannage à distance de PC, qui est super simple à utiliser et très efficace
    - “Capture d’écran et croquis” pour mes captures d’écran
 
J’ai également accumulé au fur et à mesure des années une important logithèque de programmes et utilitaires portables que j’utilise somme toute assez peu, ainsi qu’une toolbox de petites pépites légères et très efficaces, dont je ne vais pas donner la liste exhaustive mais quelques exemples :

- AutoCopy, très utile pour numériser en masse sa collection de Cd / Dvd avant de ne plus avoir de lecteur pour les lire
- DriveSort, qui permet de définir l’ordre des fichiers dans la table des fichiers, très utile pour les lecteurs MP3 qui prennent l’ordre par défaut de la table des fichiers
- h2testw, un indispensable pour tester chaque clé USB / carte SD après achat pour vérifier que la capacité réelle est bien disponible sans perte de fichier (et que ce n’est pas une contrefaçon chinoise qui fait croire que vous avez 32Go alors qu’il n’y a que 2Go de mémoire)
- TreeComp pour comparer des arborescences importantes
- TreeSizeFree pour identifier les dossiers les plus volumineux
- WiFiGuard (dans sa dernière version gratuite avant que ça devienne payant) pour surveiller les périphériques connectés sur le WiFi
- WinSCP, l’alter ego de PuTTY pour la copie de fichier via SSH
- Disk2VHD, pour convertir des disques physiques en disques virtuels VHDX
- UPX pour compresser bon nombre d’executables de cette toolbox
 
Voilà pour cet état des lieux des logiciels Windows que j’utilise en 2020. Cette liste évolue lentement, je regrette de ne pas en avoir fait avant pour voir l’évolution, j’essaierai de refaire l’exercice dans 5-10 ans voir les gros changements !
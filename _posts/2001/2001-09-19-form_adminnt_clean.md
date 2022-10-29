---
post_id: 2091
title: 'Formation au poste d&#8217;Administrateur NT VIA'
date: '2001-09-19T13:35:35+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2091'
slug: form_adminnt_clean
permalink: /2001/09/form_adminnt_clean/
URL_before_HTML_Import: 'http://www.lprp.fr/divers/via/form_adminnt_clean.php3'
image: /files/2004/11/via-transparent.gif
categories:
    - Informatique
tags:
    - ECP
    - OldWeb
    - VIA
lang: fr
---

Cette page est un support à la formation des futurs Admins NT de VIA pour l’année 2001-2002.

**Admins NT : Les parties plus délicates de cette formations ont été retirées.**

[RSHD](#rshd)  
[Les partages](#partages)  
[Les machines](#machines)  
[Accès depuis l’exterieur](#acces)  
[La Mailing Liste](#ml)  
[VIALog](#vialog)  
[Sauvegardes](#sauv)  
[Relations avec les linux](#linux)

- - - - - -

<a name="rshd"></a>

# RSHD

Remote SHell Daemon est un programme installé sur les serveurs de VIA pour permettre à Webase d’effectuer des requètes sur les NTs, en particulier l’ajout et la suppression d’utilisateurs, et la remise à zéro de mot de passe. La license a été achetée. RSHD est installé sur Bipbip.

Les paramètres sont très facile à mettre en place, et la documentation est bien faite. Il faut principalement :

- N’autoriser que la machine hébergeant Webase à faire des requètes : Attention lors du changement de machines ! Ceci est dans un fichier de configuration (access.txt ou quelque chose comme ça)
- Regler les paramètres de création des logs. Les fichiers de logs sont situés dans le répertoire de RSHD. Toutes les requètes apparaissent dans un de ces fichiers, et un autre indique les erreurs : indispensable de jeter un oeil la dessus en cas de disfonctionnement.
- Parametrer le service RSHD, en le rendant automatique au démarrage, et en le faisant executer par l’utilisateur correct. Ne pas oublier de mettre ce champ à jour en cas de changement de mot de passe ! Sans quoi vous n’aurez plus qu’à recréer à la main tous les comptes dont la création a échouée…
- Pour ce qui est des commandes à envoyer par RSHD, elles sont toutes basées sur la commande `net`, `net help` pour plus d’information. Par cette commande vous pouvez gerer en particulier les comptes utilisateurs et les groupes.

<a name="partages"></a>

# Les partages

Les partages sont une des fonctions principales des Windows. En très très gros :

Sur bipbip : les partages publics

- Drivers pour les imprimantes et les cartes réseaux.
- Logiciels : Ce partage est prévu pour accueillir les logiciels les plus courants. Le but de ce partage est de reduire au maximum l’utilisation de la bande passante pour les logiciels d’utilisation commune. En particulier, s’y trouvent les patches et Service Packs pour les logiciels, des navigateurs, StarOffice, et un certain nombre de logiciels divers. Essayez de maintenir ce partage à jour pour continuer à épargner notre bande passante.
- Incoming : il est prévu pour alimenter le partage Logiciels. Les connectés ont droit d’écriture sur ce répertoire (pas de lecture) et peuvent y déposer leur trouvailles. A vous de les classer ensuite. Le chemin normal d’un logiciel qui arrive ici c’est un coup d’antivirus. Les programmes passés à l’antivirus sont stockés dans Incomingclean$. Puis de là, ils sont regardés et triés. VIA a décidé d’épargner au maximum de la bande passante plutot que de s’embeter à être hyper reglo pour ce qui est des licences de redistribution, mais nous ne partageons uniquement que les sharewares, adwares, ou versions de demonstration, et bien sur, préférentiellement les freewares.
- MSDN : Informations pour le Développement sour les outils Microsoft. A mettre à jour à chaque arrivée de MSDN : pour celà, commencer par effacer l’intégralité du repertoire, utilisez la commande netcopy (pour les 3 cds) pour copier dans le repertoire. N’installez pas, cela ne servirait à rien pour les connectés.TechNet : Informations techniques pour l’administration de systèmes Windows. A mettre à jour à chaque arrivée de TechNet : une copie brutale de tout le CD des Monthly Issues est efficace s’il n’y a pas de netcopy.Vialog : Très important, si ce partage est cassé, tous ceux qui essaieront de se connecter auront le droit à un message désagréable. Point de vue droits, regardez ceux actuels, ils sont assez subtils, donc faîtes attention. Ils sont recopiés sur une feuille dans le classeur en cas d’accident

Taz : principalement les partages à but privé :

- Reseau$ : le répertoire des données de l’association, donc faire attention. Ce partage est monté sur zen avec l’utilisateur VIA. Il est classé par date. Un peu de ménage s’imposera éventuellement. Une des premieres choses que vous aurez a faire sera de creer un nouveau répertoire pous vous, d’y recopier les fichiers necessaires, et de rendre l’ancien en lecture seule pour eviter les problemes.
- VisualStudio6$ : ce repertoire partage Visual Studio 6 pour les gens autorisés à l’utiliser, c’est à dire les projets qui ont en fait la demande. Les personnes autoriser sont dans le groupe de sécurité Visual Studio 6. Ajoutez les nouveaux dans ce groupe, et non directement dans le partage.
- Office$ : ce repertoire partage Office 2000 pour Bipbip.
- Admin$ : partage du répertoire de profil itinérant d’admin. Pour faire un profil itinérant, cliquer sur l’onglet compte des propriétés de l’utilisateur et selectionnez le repertoire contenant le profil.
- WinMac : ce partage public est une passerelle entre les partages AppleTalk et Windows. Les deux réseaux peuvent en effet verser leurs programmes dans ces repertoires depuis un réseau, et les recupérer d’un autre. Attention, les données sont visibles de tous. Le repertoire est nettoyé intégralement toutes les 30 minutes par une tache programmée qui appelle un .bat. Pour réaliser ce partage, rien de plus simple, il s’agit de cliquer sur les deux options “partager pour le réseau AppleTalk” et “partager pour le réseau Windows” lors de la création du partage.
- Et n’oubliez pas les partages par defaut c$, d$,… Ceux ci peuvent être désactivés, mais ils sont souvent pratiques.

<a name="machines"></a>

# Les machines

Les admins NT ont à administrer 4 machines :

- Taz : controleur de domaine “principal”, le plus puissant, c’est lui qui répondra principalement aux requètes. Il s’occupe aussi de quelques partages non publics, il contient les repertoires de sauvegarde, ainsi que le dossier de profil itinérant Admin. Terminal Server mode adminitration.
- Bipbip : controleur de domaine “secondaire”, moins puissant. Il y a réplication entre les deux serveurs. Si l’un tombe, l’autre prend le relai. Attention, ne **jamais** rebooter les deux machines en même temps. A noter aussi que souvent, une demande de reboot à distance se solde souvent par une demande d’arrêt, et qu’il faut aller aux vialabs pour redemarrer la machine bloquée sur “Vous pouvez maintenant arrêter en toute sécurité” un petit bug quoi… Terminal Server mode administration.
- Coyote : machine de perm, rien de special, un office (97, pas la place pour 2000), un VNC avec le mot de passe VIA, les imprimantes, un navigateur,…
- Chepa : ancien controleur de domaine, a eu un petit probleme de carte mere. Apres rachat d’une carte mere, destiné a devenir machine de perm, avec un windows de type 9x pour avoir la meme configuration qu’un connecte, et pouvoir lui montrer les opérations de configuration. A vous de tanner le responsable matos…
- A noter que Rominet est une ancienne machine NT, sauvagement capturée par les méchants Linuxmen 🙂

<a name="acces"></a>

# Accès depuis l’exterieur

Les machines sont sevèrement firewallées depuis l’extérieur, et ceci pour éviter de prendre des risques avec les multiples failles de sécurité… Tous les parts sont coupés, sauf les ports de consultation web et ftp.

<a name="ml"></a>

# La Mailing Liste

Quelques regles evidentes de bonne conduite de travail en groupe, l’utilisation de la mailing liste est indispensable. Cela laisse ausi des traces, elle est archivée sur le site ouaibe de VIA, zone privée :

- **1 modif = 1 mail**, pour que les autres admins ne soient par surpris, pris en traitres,… et pour archiver. Essayez de detailler la procedure accomplie pour y arriver : cela servira aux futurs s’ils ont le même problème. De même vous, n’hésitez pas à aller jeter un coup d’oeil dans les archives.
- Petit test sur un serveur : on prévient
- Pour un gros test : on ne fait pas ça sur un serveur, mais on essaie de reproduire la situation sur ses propres machines. Les licenses en rab pour les admins sont faites pour ça, et il y a suffisament de babasses sur la résidence pour que cela soit possible. Regle absolue pendant ces tests : ne jamais devoir entrer le mot de passe admin : en effet, on ne sait pas ce que windows peut faire une fois qu’il a ce mot de passe. En particulier il peut enregistrer plein d’informations dont on a du mal a se defaire sur les serveurs. Un petit rappel : vu le peu que font les NTs, l’objectif est une qualité de service maximale.

<a name="vialog"></a>

# VIALog

Attention VIALog est source de bien des soucis. Longtemps décrié par les anciens, il semble mieux admis des nouveaux connectés, certainement parcequ’ils n’ont pas connu la vie sans VIALog…

VIALog est inscrit dans le profil utilisateur, comme commande à exectuer : vous voyez ainsi la commande client.exe. Ce fichier est situé dans le partage logon, qui sera monté dans Z: lorsque l’utilisateur se logguera. client.exe vérifiera que vous avez la dernière version de vialog à jour, sinon il l’installera, puis exéutera VIALog sur votre machine.

VIALog a besoin du répertoire de partage Bipbipvialog, attention les droits sont très particuliers, et notés dans le classeur NT. En particulier vialog écrit un fichier de logs dans le répertoire. A vous de faire un peu le ménage de temps en temps si vous voulez éviter d’avoir 42 000 fichiers !! Attention de ne pas virer le dernier fichier de logs… sinon ça plante avec une erreur désagréable.

Vialog plante ? oui bon bien sur… Certainement un .rtf est mauvais, et a été changé par quelqu’un malencontreusement. Ainsi a chaque fois que vous donnez les droits à quelqu’un pour une assoce, dites lui bien de verifier que vialog marche encore après sa modif. Et rajoutez le uniquement pour le repertoire dont il a besoin.

Si vous avez un problème, une bonne solution est de compiler vialog, et de le lancer avec le debuggage activé. Ainsi il vous montrera ou il y a eu un probleme. Vous trouverez les sources dans Reseau$.

<a name="sauv"></a>

# Sauvegardes

Il est bon de faire quelques sauvegardes, en particulier de Reseau$ et des vieux trucs qui ont demandé un peu de boulot mais dont on ne se sert plus (comme Office97 modifié par exemple).

Les sauvegardes sont mises sur un des disques de Taz. Une bonne chose pour vous serait de mettre en place un système de sauvegarde automatique, et aussi de la configuration et des utilisateurs : en effet, actuellement il n’y a pas de sauvegarde des utilisateurs : si vous avez un probleme, il reste la copie de replication, si elle aussi est altérée, il ne vous reste plus qu’a vous debrouiller avec webase pour lui faire cracher les nom des utilisateurs, et de faire un méaculpa pour dire que tous les mots de passe on été remis à passe.

Une bonne chose est de faire des sauvegardes sur des CDs. Il y a 10 CD-RW achetés par VIA, bientôt aussi des CD-R, et il y a suffisament de graveurs sur la résidence. Ces CDs ne doivent pas etre conservés dans les vialabs(s’il arrive quelque chose aux vialabs on perdrait en même temps les données des serveurs et les sauvegardes…), donc preferez soit le -1A, soit votre piaule.

<a name="linux"></a>

# Relations avec les linux

Les relations avec les Linux sont le moins nombreuses possibles, mais… En particulier :

- RSHD de Webase, voir la rubrique [RSHD](#rshd),
- le partage réseau de TazReseau$ sur zen:/R:/,
- les divers samba qui nous pourrissent la vie. En particulier, en reglant l’os level de son smb.conf, un linuxien peut sans probleme prendre le controle du réseau. Pour voir, ca, la commande netstat (a verifier, le programme est dans le C: de coyote et dans le repertoire admin.) /status vous donnera le maitre explorateur. Si ce n’est pas Taz, un coup de telephone, ou un passage dans les sous-sols s’impose.
- la DNS. Voila le point compliqué de l’installation des Windows 2000 : les winows 2000 ont besoin de s’inscrire dans une DNS dynamique. Donc soit ils demandent de la gerer, soit d’y avoir acces. A VIA, c’est simple, la DNS c’est les Linux qui s’en occupent. Donc lors de l’installation des 2000 il a fallu negocier une demande de mise a jour dynamique (ce qui n’a pas été facile, les Linux n’aiment pas que des Windows polluent leur base). D’autre part, une option spéciale a été nécessaire pour autoriser les noms bizarres (\_xxx) des adresses Windows. Voir les archives pour plus de renseignements, ou me [demander](mailto:remi@via.ecp.fr). L’installation finie, les droits de mise à jour dynamique ont bien entendu été retirés. Mais Windows est vraiment très sale et demande continuellement à mettre à jour la DNS, pour des trucs stupides, comme par exemple retirer une clé et la rajouter deux secondes plus tard. Il rale alors dans les logs qu’il n’a pas pu, ignorez donc ces messages la, cela marche tres bien sans. Par contre si vous voulez faire des trucs qui changent pas mal l’active directory, comme l’ajout d’un domaine fils (non recommandé), l’acces en dynamique de la DNS sera necessaire, mais la negociation avec les roots sera sans fin 🙂

Voila, normalement les données essentielles sont ici, n’hésitez pas à poser des questions, et puis à remettre cette formation au gout du jour.

© 2001 [RP](mailto:remi@via.ecp.fr), [Jean](mailto:jean@via.ecp.fr), [Clem](mailto:clem@via.ecp.fr), [Xav](mailto:xav@via.ecp.fr).
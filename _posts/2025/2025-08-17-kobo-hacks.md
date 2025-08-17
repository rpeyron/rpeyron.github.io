---
title: Kobo Hacks
lang: fr
tags:
- Kobo
- Hack
categories:
- Informatique
ia: Perplexity
image: files/2025/kobo_glo_nickelmenu_ftp.png
date: '2025-08-17 10:30:58'
---

Plus de 12 ans après l'achat de ma liseuse **Kobo Glo**, je continue à découvrir de nouvelles fonctionnalités (voir [mes autres articles sur Kobo](https://www.lprp.fr/tag/kobo/)). C’est assez rare de voir un constructeur maintenir sa stack logicielle pendant plus de 10 ans : **bravo Kobo** !  
Voici quelques astuces et outils pratiques pour prolonger la vie de votre liseuse.


# NickelMenu : telnet, ftp et plein d’options cachées

[NickelMenu](https://pgaskin.net/NickelMenu/) ([GitHub](https://github.com/pgaskin/NickelMenu), [forum Mobileread](https://www.mobileread.com/forums/showthread.php?t=329525)) est un petit utilitaire qui permet d’ajouter des entrées personnalisées au menu de la liseuse. On peut ainsi activer des fonctions non documentées comme **telnet** ou **ftp**, très utiles pour accéder directement au système de la Kobo.

L'installation se fait simplement en mettant le fichier [KoboRoot.tgz](https://github.com/pgaskin/NickelMenu/releases/download/v0.5.4/KoboRoot.tgz) dans le répertoire `.kobo` de la carte SD.  L'installation va se faire après avoir débranché la liseuse. Il faut ensuite rebrancher sur PC pour ajouter la configuration en créant le fichier `nickelmenu.cfg` à la racine de la liseuse (`.adds/nm/`). Il y a de nombreuses options décrites dans le fichier [documentation](https://github.com/pgaskin/NickelMenu/blob/master/res/doc)  ou il y a cet exemple très complet d'un utilisateur [gist t18n](https://gist.github.com/t18n/bbb48d10b56f7984636ff16db1ff20df)   ; par exemple pour FTP et Telnet: 
```
menu_item :main :Enable FTP :cmd_spawn :quiet:ftp -p 2121
menu_item :main :Enable Telnet :cmd_spawn :quiet:telnetd -l /bin/sh
```

Une fois rechargé, ces nouvelles options apparaissent dans le menu de la Kobo.
- **FTP** : utiliser votre client favori (par exemple WinSCP).  ;  ⚠️ Astuce : il faut **forcer le mode UTF-8** dans WinSCP pour ne pas avoir de problème d’accents dans les noms de fichiers.  
- **Login** par défaut : `admin / admin` (source : [forum Mobileread](https://www.mobileread.com/forums/showthread.php?t=362428)).


# Plato : alternative légère au lecteur par défaut

[Plato](https://github.com/baskerville/plato) est une application alternative qui se lance depuis la Kobo.  

Avantages :  
- navigation par dossiers (ce qui manque au logiciel standard Kobo),  
- interface très légère,  
- support des formats textuels courants, notamment PDF.

L'installation est super simple, il faut [télécharger le fichier **One Click Setup**](https://www.mobileread.com/forums/showthread.php?t=314220), et copier le contenu de l'archive à la racine de la carte SD. Il faut bien mettre le contenu à la racine, cela va ajouter les fichiers nécessaires dans tous les répertoires existants (notamment dans .kobo pour l'installation, dans .adds pour les ressources). Rebooter et laisser le temps à l'installation de se faire.

Plato s’affiche alors comme une application dans NickelMenu.


# Autres éléments (non testés)

- **Send to Kobo** : [send.djazz.se](https://send.djazz.se/) — envoi de documents directement par navigateur  
- **KoboCloud** : [fsantini/KoboCloud](https://github.com/fsantini/KoboCloud) — synchronisation automatique avec un drive (Nextcloud, GDrive, etc.)  
- Plein d’autres ressources sont regroupées ici : [bricoles.du-libre.org/kobo:la_page_kobo](https://bricoles.du-libre.org/kobo:la_page_kobo)  

## Conclusion

Après toutes ces années, la Kobo reste une petite machine **moddable**, pratique à bidouiller pour ceux qui aiment aller plus loin que les fonctions officielles.  
Entre NickelMenu pour ouvrir le système, Plato pour une lecture plus flexible, et des outils comme KoboCloud, la Kobo Glo et ses consœurs continuent à vivre bien au-delà des attentes initiales.

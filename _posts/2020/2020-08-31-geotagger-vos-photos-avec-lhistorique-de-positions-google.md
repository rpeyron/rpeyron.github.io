---
title: Géotagger vos photos avec l'historique de positions Google
post_id: 4457
date: '2020-08-31T16:29:06+02:00'
last_modified_at: '2025-09-02T13:05:08+02:00'
author: Rémi Peyronnet
layout: post
guid: "/?p=4457"
slug: geotagger-vos-photos-avec-lhistorique-de-positions-google
permalink: "/2020/08/geotagger-vos-photos-avec-lhistorique-de-positions-google/"
image: "/files/2020/08/gps_1598883806.jpg"
categories:
- Informatique
tags:
- GPS
- Geosetter
- Geotag
- Google
- gpsbabel
- maps
- takeout
lang: fr
---

Depuis 2010 et l’achat de mon Panasonic TZ10 avec GPS intégré j’ai pris l’habitude des photos de vacances géotagguées et je trouve ça très agréable et pratique. Malheureusement les appareils photos sont assez peu nombreux à intégrer cette fonction, même en haut de gamme, et j’ai depuis des appareils sans GPS, notamment un [Sony RX100](/2015/09/rx100vstz10/) qui est excellent et que j’utilise beaucoup. J’avais déjà écrit un billet expliquant [comment géotagger ses photos](/2013/05/geotag/) avec une trace GPS notamment avec l’excellent logiciel [Geosetter](https://geosetter.de/en/main-en/). Pour ce faire il faut avoir pensé à enregistrer une trace GPS au préalable, par exemple avec l’application android [GeoTracker](https://play.google.com/store/apps/details?id=com.ilyabogdanovich.geotracker&hl=en) (Google ayant arrêté l’application MyTracks que je conseillais précédemment), l’exporter en GPX et l’appliquer sur ses photos ensuite avec Geosetter.

Cette technique comporte cependant deux petits inconvénients : d’une part l’application GeoTracker consomme un peu plus la batterie du téléphone pour avoir une trace qui corresponde à la précision demandée dans les paramètres, et d’autre part… il faut penser à lancer l’enregistrement de la trace ! Si vous avez oublié de lancer l’enregistrement, tout n’est pas perdu, voici ci-dessous une méthode pour récupérer une trace, beaucoup moins précise, à partir de l’historique de position Google si vous n’avez pas désactivé cette fonction. En effet Google, pour différentes raisons plus ou moins bonnes que nous n’aborderons pas ici, enregistre périodiquement la position de votre téléphone, soit via une localisation par les antennes relais, soit via GPS. Et conformément à sa politique sur les données personnelles, elles sont toutes accessibles via [Google Takeout](https://takeout.google.com/settings/takeout). On peut toujours critiquer Google pour sa collecte de données et leur usage, mais on peut au moins reconnaître l’effort pour mettre à disposition de l’utilisateur les données collectées.

**Mise à jour (02/09/2025) :** depuis la nouvelle version de "Vos trajets", sécurisé sur le portable, les données ne sont plus disponibles via Google Takeout :
- L'export doit maintenant être fait sur le téléphone, dans l'application Paramètres / Localisation / Services de localisation / Vos trajets / Exporter Vos trajets, puis enregistrer le fichier JSON (il ne semble plus possible de choisir le format KML)
- Lorsque vous changez de portable, il faut importer les données Vos Trajets du portable précédent pour pouvoir les conserver ; dans l'application Maps / icone de profil / Vos trajets / icone Cloud / et dans Vos sauvegarde, sur la ligne du portable à importer, cliquer sur les "..." et cliquer sur "importer". 
- Pour découper le JSON et le convertir en KML, l'outil [google-maps-timeline-viewer](https://github.com/kurupted/google-maps-timeline-viewer) est compatible avec le nouveau format de fichier ; il faut télécharger le fichier index.html et modifier la clé API (fonctionne sans avoir besoin de mettre une clé valide, mais bien sûr dans ce cas on n'aura pas les plans) ; on peut ensuite à nouveau importer le KML dans Google Maps / Créer une carte / importer


Via [Google Maps / Vos trajets](https://www.google.com/maps/timeline) (Timeline) vous avez déjà accès à une représentation simplifiée de vos déplacements. Il suffit de sélectionner la journée pour afficher l’historique des trajets de la journée, organisés avec ce que Google en a compris : Google interprète en effet votre activité pour détecter si vous étiez à pied, en voiture, en train de courir et vos positions pour reconnaître les lieux. C’est ce qu’ils appellent l’historique “sémantique”. C’est une belle performance technique, et aussi une catastrophe pour la vie privée 🙂 Depuis cette vue vous pouvez télécharger le fichier KML correspondant. Bizarrement ce KML ne comporte que des “waypoints” et n’est donc pas directement utilisable pour géocoder avec GeoSetter. Pour ce faire, l’outil [gpsbabel](https://www.gpsbabel.org/) permet de convertir ces “waypoints” en “tracks” pour pouvoir appliquer le géocodage via GeoSetter via la commande :

```
gpsbabel -i kml -f history-2020-08-28.kml -x transform,trk=wpt -o gpx -F history-2020-08-28.gpx
```

S’il est sans doute suffisant pour la majorité des cas, il n’est parfois pas assez précis et ne comporte pas toutes les mesures enregistrées. Par exemple si Google a identifié un lieu, il ne vous fournira que la position de ce lieu, et agrégera les positions sur ce lieu, donc par exemple si vous vous êtes promené dans les jardins d’un chateau, vous n’aurez probablement pas ce trajet.

Pour le géocodage il vaut donc mieux utiliser les données brutes accessibles via [Google Takeout](https://takeout.google.com/settings/takeout). Une fois connecté, décocher toutes les données et cocher “Historique des positions” :![](/files/2020/08/Annotation-2020-08-31-133252.png){: .img-center}

Via le bouton “Formats multiples”, sélectionner comme option le format KML pour l’historique des positions :

![](/files/2020/08/Annotation-2020-08-31-133052.png){: .img-center}

Choisir ensuite comment récupérer le fichier et attendre les quelques minutes de génération pour pouvoir récupérer le fichier. Il n’est cependant pas possible de filtrer entre deux dates, et donc le fichier que vous aller télécharger contiendra toutes les données depuis votre première utilisation de Google… Il est possible de filtrer la période qui vous intéresse avec gpsbabel :

```
gpsbabel -i kml -f Takeout/Historique\ des\ positions/Historique\ des\ positions.kml -x track,start=20200824,stop=20200829 -o gpx -F output3.gpx
```

Les valeurs dans start et stop correspondent aux dates de début et de fin au format YYYYMMDD (donc 20200824 pour le 24/08/2020). Vous obtiendrez alors une trace GPX parfaite pour utilisation avec GeoSetter. Pour une synchronisation optimale, il est utile de vérifier l’heure de votre appareil photo avec l’heure de votre téléphone, et le cas échéant appliquer les quelques minutes d’écart en offset.

A noter que depuis d’autres logiciels que GeoSetter permettent l’intégration de traces GPS, comme [FastStone Image Viewer](https://www.faststone.org/) que j’utilise pour le tri des photos et [DarkTable](https://darktable.fr/) pour les retouches, tous deux disponibles via [scoop](https://scoop.sh/). Je préfère cependant toujours GeoSetter pour son interface spécialisée plus pratique à utiliser.

En parlant d’autres logiciels, un mot sur mon workflow de traitement photo. J’utilisais précédemment [RPhoto ](/rphoto/)+ [Picasa](https://picasa.google.fr/) + [Gallery 1.x](http://galleryproject.org/) (la première version sans base de données) + des [scripts maison](/2012/05/gallery-1/) mais vu l’arrêt du second et du troisième je n’ai pas encore trouvé mon workflow idéal. J’ai par ailleurs remplacé RPhoto par FastStone qui intègre le recadrage sans perte avec conservation du ratio, la rotation par verticale, les commentaires JPEG, les raccourcis clavier, bref tout ce qui m’avait motivé à créer RPhoto, mais avec beaucoup d’autres fonctions. Pour l’instant j’utilise :

- [FastStone Image Viewer](https://www.faststone.org/) pour le tri des photos, le recadrage JPEG sans pertes, la retouche basique des couleurs et les commentaires JPEG.
- GeoSetter pour le géotaggage *(je pense que vous l’aviez compris :))*
- [DarkTable](https://darktable.fr/) pour les modifications plus avancées comme la correction de perspective ; j’ai découvert ce logiciel très récemment et il est vraiment très complet, bien que moins facile à utiliser que FastStone (notamment par l’utilisation obligatoire des sideimages et du besoin d’exporter ensuite ; très efficace pour un traitement systématique des photos, mais peu adapté à la retouche de quelques photos)

J’ai encore deux problèmes par rapport à mon workflow précédent :

- Les commentaires JPEG vs EXIF : FastStone utilise les commentaires JPEG alors que les autres ne traitent que les données EXIF. DarkTable va jusqu’à supprimer le commentaire JPEG lors de l’export de la photo, pas pratique ! Pour copier les commentaires JPEG dans la description EXIF avec [exiftool](https://exiftool.org/) (existe sous Windows via scoop) :

```
exiftool -r -overwrite_original_in_place -Copyright="(c) 2020" -Title<Comment -Description<Comment -Charset cp1252 *
```

A noter :

1. Le paramètre -Charset pour permettre la bonne conversion de l’encoding du commentaire JPEG. Attention, si vous voulez contrôler le contenu, n’oubliez pas le paramètre -Charset avec l’encoding de votre terminal pour que l’affichage soit correct (`-Charset 850` pour l’encoding par défaut du terminal Windows en France) ; et également `-s -G` pour avoir les identifiants des tags et leur groupe.

2. Certains logiciels utilisent Title, d’autres Description (Google Photos par exemple), donc je préfères dupliquer; J’ai donc le titre dans le commentaire JPEG, le titre et la description…

3. Comme je prends des photos depuis plusieurs appareils (mon RX100 et mon téléphone), le nom des fichiers ne suffit pas pour les trier selon la date de prise de vue, et le tri par date des logiciels est parfois capricieux en cas de modification. Je les renomme donc avec :

```
exiftool -DocumentName<FileName '-FileName<${DateTimeOriginal} - %f' -d '%y-%m-%d %H-%M-%S%%-c' *
```

Et si vous souhaitez avoir le titre dans le nom du fichier, les logiciels n’y arrivent généralement pas à cause des caractères spéciaux (ni Darktable ni FastStone ne savent faire), mais GeoSetter fonctionne très bien. J’utilise le motif suivant : `{TakenDate:yyyy-mm-dd HH-MM-SS} – {Caption:60} – {Filename}` .

J’ai également écrit un petit [script exiftool](/2020/09/exiftool-config-file-to-rename-files-with-title-on-windows/) pour pouvoir renommer avec cet outil.

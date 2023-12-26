---
title: Optimisations de systèmes de fichiers ext4 (et tentatives zfs et btrfs)
lang: fr
tags:
- Linux
- Ext4
- Zfs
- Btrfs
- Shell
categories:
- Informatique
date: '2023-12-26 12:57:27'
image: files/2023/ext4_inlinedata.jpg
---

Les systèmes de fichiers ne sont pas magiques, et comme tout, sont matière de compromis. Le réglage par défaut convient dans la très grande majorité des cas, mais pour des usages particuliers, il est nécessaire de bien comprendre leur fonctionnement et d'adapter les paramétrages.

# Cas particulier d'un grand nombre de petits fichiers
Pour un usage très particulier, j'ai besoin de stocker un grand nombre de très petits fichiers. Il s'agit de fichiers md5 de contrôle d'intégrité pour chaque fichier de mon disque. Les puristes diront qu'utiliser un système de fichier pour cet usage n'est pas une bonne solution, et qu'il est préférable d'utiliser une base de données, et dans l'absolu, ils auront complètement raison. Mais en l'occurrence, pour de mauvaises raisons, notamment de simplicité et rapidité de mise en place, c'est la solution que j'ai historiquement mise en place. Pour les plus curieux,  j'ai décrit le fonctionnement en fin d'article. 

# Différence entre la taille d'un fichier et sa taille sur le disque
Sur un disque dur, les fichiers ne peuvent pas simplement être écrits les uns après les autres à l'octet près. Il faut en effet gérer des métadonnées : les noms des fichiers, l'arborescence, les dates de création, modification et accès, les propriétaires, les permissions, etc. Et pour le contenu, il faut prévoir de faire changer la taille des fichiers sans avoir à tout réécrire. Cela suppose une organisation un peu intelligence du disque pour pouvoir s'y retrouver et c'est justement l'objet des systèmes de fichiers. Il en existe {une très grande variété](https://fr.wikipedia.org/wiki/Syst%C3%A8me_de_fichiers) avec des caractéristiques différentes. Les plus connus sont FAT32 ou NTFS pour Windows, et ext4 pour Linux. Mais quasiment tous les types de systèmes de fichiers fonctionnent par blocs, qui découpent le disque en sous ensembles d'octets contigus, et vont attribuer un ou plusieurs blocs à chaque fichier.  Lorsqu'un bloc est affecté à un fichier, il ne peut pas être utilisé pour un autre. Ainsi, la taille réelle qu'occupe un fichier sur le disque n'est pas le nombre d'octets du fichier, mais le nombre de blocs utilisés. 

Les tailles classiques des blocs se situent souvent entre 4ko et 64ko, selon la taille du disque. Ainsi la taille sur le disque d'un fichier est au moins de la taille du fichier arrondi à la taille d'un bloc supérieur. Si pour des fichiers classiques ce n'est pas souvent perceptible, quand on utilise beaucoup beaucoup de fichiers, cela devient très important et on perd une place folle. Imaginons pour une taille de blocs de 64ko et 1 million de fichiers de 100 octets, la taille est de 100 Mio (1 million x 100 octets) alors que la taille sur disque va être de 64 Go (1 million x 64ko), la différence est considérable puisque pour chaque fichier on va "perdre" 64ko - 100 octets, soit 99.8% !

Il existe d'autres mécanismes qui peuvent faire différer la taille d'un fichier avec son usage réel sur le disque, comme la compression, qui va avoir l'effet inverse d'utiliser moins de disque que la taille du fichier.


# Paramétrage de ext4
[ext4}(https://fr.wikipedia.org/wiki/Ext4) est un système de fichier datant de 2006, évolution de ext3, lui-même évolution de ext2 qui est le système de fichier historique de GNU/Linux, introduit en 1993. Il est stable, très répandu et utilisé par une grande majorité de distribution Linux  
Notre cas se confronte à deux limitations de ext4:
- la taille des blocs: ext4 impose un minimum de 1024 octets par blocs
- le nombre de fichiers : avec ext4 les fichiers sont identifiés par des inodes, et ext4 réserve de l'espace pour décrire les metadata de ces inodes à la création du système de fichier ; une fois le nombre limite d'inodes atteint, il n'est plus possible de créer de fichier et vous obtiendrez une erreur "disque plein" qui peut être déroutante, car la commande `df` montre qu'il reste de la place. Il faut utiliser `df -i`  pour pouvoir contrôler le nombre d'inodes restant disponibles.

Avec un grand nombre de fichiers, il est donc nécessaire de minimiser la taille des blocs et d'augmenter le nombre d'inodes possibles.

Il existe également une fonctionnalité [`inline_data`]((https://www.kernel.org/doc/html/latest/filesystems/ext4/overview.html#inline-data) très intéressante de ext4 qui permet d'utilser la place restante dans les metadata d'un inode pour stocker un très petit contenu. Ca tombe bien c'est notre cas !  Par exemple si 256 octets sont réservés pour chaque inode mais que les metadata n'occupent réellement que 128 octets, il reste 128 octets utilisables dans l'inode pour stocker 128 octets de données sans avoir à allouer le moindre bloc.

Et bien sûr, tous ces paramètres sont réglables à la construction du système de fichier, ainsi nous allons utiliser la commande suivante pour créer notre système de fichier
```
mkfs.ext4 -b 1024 -i 1024 -I 512 -O inline_data  /dev/sdb3
```
- `-b <taille d'un bloc>` : pour la taille d'un bloc, nous utilisons le minimum disponible, à savoir 1024 octets
- `-I <taille d'un inode>` : pour la taille d'un inode, nous allons doubler la taille classique pour se donner un peu de marge
- `-i <bytes/inode ratio>` : c'est ce paramètre qui permet de définir le nombre d'inode à créer à partir de la taille du disque divisé par ce paramètre ; on veut beaucoup d'inodes donc on va utiliser un ratio très bas
- `-O inline_data` ; permet de forcer l'activation de l'option inline_data qui nous intéresse

Il faut comprendre que le système va donc réserver <taille d'un inode > * (<taille du disque> / <bytes/inode ratio>), ainsi si vous utilisez la taille de l'inode, vous allez construire un système de fichier de taille nulle, car l'intégralité de l'espace sera réservée par les inodes ! 
Ici, j'ai un ratio qui fait deux fois la taille d'un inode, et qui se trouve aussi être la taille d'un bloc. Je vais donc avoir la moitié du disque pour la table des inodes, et l'autre moitié en blocs. Et dans la table des inodes, j'ai environ 3/4 de la taille de l'inode utilisable.
C'est un compromis intéressant pour mon cas : la majorité de mes petits fichiers devraient être intégralement stockés dans les metadata des inodes sans devoir allouer de blocs, et pour les fichiers les plus "gros", il aura la possibilité d'allouer finement des petits blocs.

La commande `tune2fs -l /dev/sdb3` permet de controler les différents paramètres effectifs sur la partition.

Ces réglages m'ont ainsi permis de déplacer ma collection de petits fichiers sur un petit disque que je n'utilisais plus et qui sera dédié à cet usage. Alors que les paramètres par défaut ne permettaient pas de faire rentrer tous les fichiers sur le disque, aussi bien à cause de la taille des blocs que la limitation du nombre d'inodes, j'ai pu avec ce réglage non seulement copier tous les petits fichiers dans les inodes en conservant de la marge, et conserver près de la moitié du disque disponible pour d'autres fichiers. Et cerise sur le gâteau, avec inline_data les temps d'accès sont également bien meilleurs !


# Essais et échecs avec zfs et btrfs
## Echec avec zfs
Je lorgne depuis quelques années sur le système de fichier [ZFS](https://fr.wikipedia.org/wiki/ZFS)  dont les caractéristiques sont assez intéressantes, et notamment la capacité théorique de faire du RAID sur des disques de tailles différentes qui m'intéresse pour simplifier la combinaison [LVM/MDADM que j'utilise actuellement] {{ '/2020/06/ajouter-un-disque-a-lvm-sur-mdadm/' | relative_url }}. Malheureusement l'appréhension de quitter une solution certes compliquée, mais éprouvée pour une solution inconnue et le manque d'espace pour réaliser la conversion ne m'ont pas encore permis de tester réellement ce système de fichiers. Or zfs est également censé supporter le stockage de data dans les metadata pour gérer efficacement les petits fichiers, l'occasion revée de tester ! Spoiler alert: ça n'a pas marché.

ZFS fonctionne avec des pool de stockage et des disques logiques, un peu comme LVM ; à noter que bizarrement il n'y pas de type de partition pour ZFS, sans doute pour favoriser l'usage de disques entiers
1. Installer le module pour le noyau `apt install zfs-dkms`
2.  Création du pool (-f pour forcer, car le type ne lui plait pas) `zpool create -f zfspool /dev/sda3` 
3.  Création du disque virtuel`zfs create zfs_ssd/zfs120` 
4.  Création du point de montage associé au disque`zfs set mountpoint=/mnt/zfs_ssd zfs_ssd` 

Après copie des fichiers, je constate l'usage de 8.5ko par fichier, c'est un échec...
Il y a sans doute matière à creuser et comprendre pourquoi l'écriture inline ne s'est pas activée, mais en cherchant sur internet il était beaucoup fait mention de btrfs que j'ai donc voulu tester.


## Echec avec btrfs

[btrfs](https://fr.wikipedia.org/wiki/Btrfs) est un système de fichier récent et moderne, aux nombreuses fonctionnalités. On le trouve décrit comme le futur remplaçant de ext4. Spoiler: ce n'est pas encore prêt d'après cette expérience.

L'usage de btrfs est un peu plus simple que zfs car il existe un type de partition, et le formattage est donc inclus dans des outils comme gparted. J'ai donc opté pour le formatage avec options standard dans gparted. La copie s'est passée sans problème et tous mes petits fichiers sont rentrés dans le disque. Victoire !!  Enfin presque...

Premier point assez peu pratique, on ne peut pas simplement utiliser `df`  pour savoir quelle est l'occupation du disque.  En effet, btrfs utilise un découpage un peu complexe avec une section metadata, une section data et la partie du disque non allouée. Au fur et à mesure des besoins le système va allouer la partie non allouée pour ajouter à la section metadata ou data.  Regarder l'usage non alloué est incorrect, car il reste de la place dans les sections. Il faut donc utiliser et interpréter la commande `btrfs filesystem usage -T *` pour  savoir la place restante sur le disque.... vraiment pas simple !  J'espère que cela sera simplifié avant un éventuel remplacement de ext4, et éviter la complexité croissante de Linux ces dernières années, comme avec systemd et son journalctl...

Deuxième point, la commande précédente montre une section metadata très volumineuse et vide ; il n'y a pas de balance automatique et il semble falloit forcer le réglage au fur et à mesure de l'utilisation du disque : dans mon cas `btrfs balance start -v -musage=50 /mnt/ssd120` 

Enfin le coup de grace, au bout de seulement 2-3 semaines d'usagen sans interruption forcée ni coupure de courant, le disque disparait...  Le check montre qu'il y a des erreurs, et qu'il n'est pas possible de corriger même avec tous les flags pour forcer les corrections avec éventuelles pertes... Après correction d'une partie des erreurs le système accepte d'être remonté, mais rebascule rapidement en readonly. Au bout de seulement quelques semaines d'utilisation je trouve cela extremement surprenant, et non acceptable pour un système de fichier.... Fin de l'essai de btrfs, sans doute pour longtemps.


# Génération de md5 pour suivre l'intégrité des fichiers
Pour vérifier l'absence de corruption des fichiers, notamment en cas de suspicion d'éventuels malware/ransomware qui crypteraient les fichiers eux-même (et non la table de partition qui nécessite des droits plus élevés), j'ai voulu mettre en place rapidement un test d'intégrité backupable. A l'époque je n'avais pas trouvé de solution satisfaisante et j'ai opté pour la génération d'une arborescence de fichiers md5. Il doit exister maintenant des outils bien plus performants.

La première version était vraiment très simple, et basée sur l'outil make, pour mettre à jour des md5 avec une simple règle Makefile. 

Seulement c'était bizarrement très lent, et ne gérait pas les suppressions, donc j'ai fini par écrire un script shell pour automatiser. 

<details><summary>md5update.sh (Cliquer pour voir le source)</summary>
<pre>
#! /bin/sh

SRCDIR=/espace
MD5DIR=${1:-/md5}

# Cleaning
echo Cleaning $MD5DIR
find $MD5DIR -type f  -printf "%P\n"  | while read MD5FILE
do
	SRCFILE=$MD5FILE
	#echo Processing /$SRCFILE
	#SRCFILE=`echo "$MD5FILE"  | sed 's/^$MD5DIR//'`
	if [ ! -e "/$SRCFILE" ]
	then
		echo "Source file $SRCFILE removed, removing md5 file"
		rm -f "$MD5DIR/$MD5FILE"
	fi
done
echo "Remove empty dirs"
find $MD5DIR -type d -empty -delete -print
echo "Remove empty files (errors)"
find $MD5DIR -type f -size 0 -delete -print

# Update
find $SRCDIR -type f | while read SRCFILE
do
	MD5FILE=$MD5DIR$SRCFILE
	if [ -e "$MD5FILE" ]
	then 
		if [ "$MD5FILE" -ot "$SRCFILE" ]
		then
			echo -n "Updating MD5 for $SRCFILE..."
			rm -f "$MD5FILE"
			md5sum "$SRCFILE" > "$MD5FILE"
			echo " OK."
		fi
	else
		echo -n "Creating MD5 for $SRCFILE..."
		MKMD5FILE=`dirname "$MD5FILE"`
		mkdir -p "$MKMD5FILE"
		md5sum "$SRCFILE" > "$MD5FILE"
		echo " OK."
	fi
done
</pre> 
</details>


On peut ensuite compresser l'arborescence pour l'archiver, utiliser diff pour voir les différences entre deux arborescence md5, ou la commande md5 pour controler.

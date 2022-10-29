---
post_id: 4335
title: 'Disque non persistant sous QEmu (Transient) et VMWare'
date: '2021-08-30T17:23:29+02:00'
last_modified_at: '2021-08-30T17:23:29+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4335'
slug: disque-non-persistant-sous-qemu-transient-et-vmware
permalink: /2021/08/disque-non-persistant-sous-qemu-transient-et-vmware/
image: /files/Logos-Libvirt-QEmu.png
categories:
    - Informatique
tags:
    - Persistant
    - QEmu
    - Transient
    - VMWare
lang: fr
---

J’utilise depuis longtemps la fonctionnalité de disque non persistant sous VMWare ; c’est très pratique pour tester un logiciel ou une opération sans pour autant modifier la machine virtuelle. En effet à l’extinction de la VM, les modifications apportées au disque seront supprimées et la VM sera comme si vous n’aviez rien installé ou modifié.

# Sous VMWare

Même si l’option ne semble plus apparaître dans les récentes versions de VMWare Player, la configuration dans le fichier vmx est bien toujours prise en compte. Ainsi pour convertir un disque en non persistant, il suffit d’ajouter la ligne suivante dans le fichier vmx après la déclaration du disque, en ayant bien sûr pris soin de modifier `scsi0:0` suivant l’identification de votre disque.

```
scsi0:0.mode = "independent-nonpersistent"
```

Il est également possible de dupliquer le fichier vmx pour avoir une version persistante et une autre non persistante en utilisant le même disque. Cela permet ainsi de choisir au moment de lancer la VM si on veut conserver ou non les modifications, pratique par exemple pour installer les mises à jour de sécurité de l’OS de façon permanente, mais de ne pas garder les autres modifications / essais d’installation.

# Sous QEmu

Si la fonctionnalité est ancienne sous VMWare, elle est plutôt récente sous QEmu et libvirt, et plus particulièrement, disponible sous debian seulement depuis bullseye publiée il y a quelques jours (ne fonctionne pas sous buster). La fonctionnalité n’est pas non plus activable via l’interface virt-manager et il faut éditer le fichier de définition manuellement.

Heureusement il y a un script pour gérer ça tout seul : <https://github.com/hugojosefson/virsh-transient-disk> que j’ai encapsulé dans le script suivant pour que ce soit plus pratique :

```
if [ "$#" -ne 2 ] ; then
	echo "virsh-transient.sh <current-vm> <transient-vm-to-create>"
else
	# https://github.com/hugojosefson/virsh-transient-disk
	tmpfile=$(mktemp /tmp/virsh-transient.XXXXXX)
	virsh -c qemu:///system dumpxml "$1" \
	  | npx @hugojosefson/virsh-transient-disk --name "$2" \
	  > "$tmpfile"
	virsh -c qemu:///system define "$tmpfile"
	rm "$tmpfile"
fi

```

Si vous avez plusieurs disques / CDs sur votre machine virtuelle, vérifiez tout de même le résultat (et de toute façon, je ne peux que vous conseiller une sauvegarde / un petit test avant des modifications importantes en mode non persistant)

Si vous préférez réaliser la modification manuellement, il faut :

- Aller dans `/etc/libvirt/qemu` pour trouver les définitions des VM de libvirt
- Copier la VM avec un nouveau nom
- Editer le fichier
- Changer GUID + nom
- Ajouter `<transient />` dans le disk concerné (cf <https://libvirt.org/formatdomain.html#elementsDisks>)
- Redémarrer libvirt avec `systemctl restart libvirtd` pour qu’il prenne la nouvelle définition de VM

Autre possibilité si vous préférez virt-xml (<https://unix.stackexchange.com/questions/235414/libvirt-how-to-pass-qemu-command-line-args>) :

- `virt-xml “vmLUbuntu (transient)” –edit –confirm –qemu-commandline ‘-snapshot 1’`
- Attention on est obligés d’ajouter ‘1’ sinon ça ne marche pas, mais il faut aller le retirer dans le XML ensuite… (et bien sûr redémarrer libvirt)

Et comme vous avez pu le deviner, si vous préférez QEmu directement en ligne de commande, l’option à ajouter est `-snapshot` à la suite de la définition du disque (cf <https://wiki.qemu.org/Documentation/CreateSnapshot>)
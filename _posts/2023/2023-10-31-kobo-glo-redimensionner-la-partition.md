---
title: Kobo Glo - Redimensionner la partition
lang: fr
tags:
- Kobo
- Partition
categories:
- Informatique
toc: true
date: '2023-10-30 12:30:05'
image: files/2023/KoboGlo-Partition-Miniature.jpg
---

J'ai une liseuse [Kobo Glo](https://www.lesnumeriques.com/liseuse/fnac-glo-p14415/test.html) depuis 2013 ; elle fonctionne encore parfaitement, mais avec le temps, et une liste de lecture qui s'allonge beaucoup plus vite que ce que je lis, et une manie de ne pas supprimer les livres lus, je commence à être un peu à l'étroit. 

![Partition de la liseuse pleine]({{ 'files/2023/KoboGlo-Partition (1).png' | relative_url }}){: .img-center}

Or, il se trouve que sur mon modèle, la mémoire n'est pas soudée à l'appareil, mais prend la forme d'une carte SD. Encore mieux, la carte SD fournie est de 4 Go, mais seuls 2 Go sont utilisés. J'ai donc simplement redimensionné la partition. Il est également possible de changer de carte SD pour un modèle plus grand. Par ailleurs, la Kobo Glo accepte une deuxième carte SD externe pour étendre le stockage, cependant cela ne fait pas bon ménage avec la coque que j'utilise.

# Ouverture de la liseuse
Avant toute opération, il est indispensable d'éteindre complètement la liseuse, via un appui long sur le bouton on/off. Une mise en veille n'est pas suffisante, il faut vraiment éteindre complètement la liseuse.

La première étape, et sans doute la plus compliquée, est d'ouvrir la liseuse. Heureusement pas de colle ou autre comme sur d'autres appareils, mais des clips qui maintiennent le dos en plastique sur la liseuse, et sans prise pour ouvrir. Il vous faudra une petite lame pour glisser entre le dos et la liseuse (comme par exemple cet [outil d'ouverture](https://www.amazon.fr/MMOBIEL%C2%AE-Inoxydable-antid%C3%A9rapant-r%C3%A9parations-Smartphone/dp/B01MFC7DMJ/?th=1) très pratique), et déclipser petit à petit. C'est un peu plus facile en commençant par le haut, et il faut faire un peu attention autour du bouton on/off pour ne pas casser le mécanisme. Les clips sont très fragiles et il est difficile de ne pas en casser, mais le dos se reclipse malgré tout sans problème.

![Ouverture de la liseuse]({{ 'files/2023/KoboGlo-Partition-Open.jpg' | relative_url }}){: .img-center .mw60}

La carte SD se trouve à proximité de la batterie, voir le cercle rouge ci-dessus.

# Sauvegarde de la carte SD
Avant de modifier quoi que ce soit, il est préférable de faire une sauvegarde.  J'utilise pour cela sous Windows [HDDRawCopyTool](https://hddguru.com/software/HDD-Raw-Copy-Tool/) :

![Sauvegarde de la partition]({{ 'files/2023/KoboGlo-Partition-Backup.png' | relative_url }}){: .img-center .mw60}

Sous Linux, un simple `dd` suffit:
```
sudo dd if=/dev/<votre device> of=backup.raw bs=2M
```
Vérifiez à la fin que la carte a bien été intégralement copiée et qu'il n'y a pas eu d'erreur de lecture.

# Remplacement de la carte SD (si nécessaire)
Si la carte SD d'origine n'est pas de 4 Go, ou si vous souhaitez encore plus, vous pouvez remplacer la carte SD à ce stade. Attention, le type et la qualité de carte SD peuvent être importants, si cela ne fonctionne pas, essayez avec un autre modèle de carte.

Il suffit de restaurer la sauvegarde réalisée ci-dessus sur la nouvelle carte SD, sous Windows toujours par HDD-Raw-Copy-Tool, et sous Linux en inversant la commande (vérifiez plutôt deux fois qu'une que vous utilisez le bon device, vous pouvez effacer vos disques en moins de 2s en cas d'erreur !) :
```
sudo dd if=backup.raw  of=/dev/<votre device> bs=2M
```

# Augmentation de la partition
Il vous faudra pour cela utiliser un logiciel de partitionnement des disques. Sous Windows j'utilise en ce moment [Macrorit Partition Expert](https://macrorit.com/fr/partition-expert/free-edition.html) ; la version gratuite devrait être suffisante, il existe également des alternatives sous d'autres marques comme MiniTool, EaseUs et AOMEI. Des versions complètes sont également régulièrement proposées sur les sites de [Giveway](https://giveawayradar.weebly.com/), si vous voyez une version complète illimitée dans le temps, cela vaut le coup d'avoir ce type d'outil à disposition. La Gestion des disques de Windows (accessible via clic droit sur le logo Windows du menu démarrer et "Gestion des disques") devrait aussi pouvoir faire ce redimensionnement simple, mais je n'ai pas pensé à tester. Sous Linux, GParted fonctionnera à merveilles.

La carte SD comporte deux partitions de 256 Mo qu'il ne faut pas toucher, puis la partition de données en FAT32, puis un espace non alloué. Nous allons étendre la partition FAT32 sur l'espace non alloué :

![Redimensionnement - Partitions au dé]({{ 'files/2023/KoboGlo-Partition (2).png' | relative_url }}){: .img-center .mw80}

En clic droit sur la partition FAT32, sélectionnez Resize/Move Volume, et redimensionnez au maximum :

![Redimensionnement - Deuxième étape]({{ 'files/2023/KoboGlo-Partition (3).png' | relative_url }}) ![Redimensionnement - Troisième étape]({{ 'files/2023/KoboGlo-Partition (4).png' | relative_url }})
{: .center}

Puis validez l'opération pour la mettre en attente, puis cliquer sur le bouton "Commit" pour réaliser les changements (si vous quittez sans avoir validé via ce bouton, aucune modification ne sera faite)

![Redimensionnement - Quatrième étape]({{ 'files/2023/KoboGlo-Partition (5).png' | relative_url }}){: .img-center}

Vous devriez maintenant voit la partition prendre tout l'espace disponible, vous pouvez éjecter la carte SD.

![Redimensionnement - Résultat en partitions]({{ 'files/2023/KoboGlo-Partition (6).png' | relative_url }}){: .img-center .mw80}

Remettez la carte SD, refermez la liseuse et branchez-la à nouveau sur le PC pour constater votre succès :

![Redimensionnement - Résultat]({{ 'files/2023/KoboGlo-Partition (7).png' | relative_url }}){: .img-center}
 
# Conclusion

Voilà, vous avez plus que doublé la capacité de votre Kobo ! 

Si vous ne connaissez pas déjà, il y a de nombreuses modifications disponibles pour les Kobo sur les [pages Kobo du forum mobileread.com](https://www.mobileread.com/forums/forumdisplay.php?f=223) pour agrémenter la seconde vie de votre liseuse.

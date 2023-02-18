---
title: Garder plus longtemps votre tablette Android en la mettant à jour (Lenovo Tab
  A10-70 - A7600F)
lang: fr
tags:
- Android
- Update
categories:
- Informatique
image: files/2023/lenovo-tab-a10-70-update-nougat.png
date: '2023-01-21 16:44:00'
---

J'ai acheté en 2015 une tablette Android Lenovo Tab A10-70. C'est un modèle bas de gamme, mais qui convient parfaitement à l'usage que  j'en ai.  Seulement, elle est équipée d'origine d'android 4.4 KitKat, qui est arrivé en fin de vie, et petit à petit les applications ne fonctionnent plus, par exemple YouTube. Même si la version web peut toujours fonctionner dans Chrome, l'ergonomie n'est vraiment pas terrible et plante souvent.  Heureusement, grâce à la communauté [XDA](https://forum.xda-developers.com/t/rom-7-1-2-unofficial-port-resurrection-remix-5-8-5-for-lenovo-a7600-f-mt6582.3895322/), il est possible de mettre à jour la tablette vers une version Android 7.1, retrouver en fluidité, gagner des nouvelles fonctions comme les gestes qui ne fonctionnaient pas d'origine, résoudre certains problèmes du logiciel précédent (comme le Bluetooth), et de prolonger ainsi la vie de cette tablette plutôt que de devoir la remplacer.

# Préparation de la mise à jour
La première étape absolument indispensable est de **sauvegarder** toutes les données de votre tablette. En effet, son contenu sera intégralement effacé dans l'opération. 
Il faut ensuite télécharger les fichiers nécessaires :
- Le [logiciel Lenovo d'origine](https://firmwarefile.com/lenovo-a7600f) avec les outils de mise à jour 
- Les [drivers](https://drive.google.com/file/d/1Cd1pu3rePKDy3YxOqDFfwXS8Fy0Hlo10/view?usp=sharing) mis à jour
- Le [recovery TWRP](https://drive.google.com/file/d/1KafQRuA_ynWzZ5-fHbDzzpEVmB0uoSCj/view?usp=sharing) qui va permettre de mettre à jour la tablette
- La [ROM Android 7.1.2 - Resurrection Remix 5.8.5 - Unofficial](https://drive.google.com/open?id=1qT_0b6nYO_q-pPC2G9_FY3bzVbC-LsWf) réalisée par la communauté
- Les [Google Apps](https://opengapps.org/) à ajouter pour avoir les applications Google et le Google Play Store (sélectionner ARM, Android 7.1 et Variant pico - les variantes plus grosses sont trop grosses pour être installées)

Il vous faudra également avoir installé l'outil adb (par exemple via scoop : `scoop install adb`)

# Mise à jour

Les différentes étapes pour installer la nouvelle ROM sont détaillées [sur la page du post XDA](https://forum.xda-developers.com/t/rom-7-1-2-unofficial-port-resurrection-remix-5-8-5-for-lenovo-a7600-f-mt6582.3895322/)

1. Installer les drivers USB *(soit ceux de la ROM d'origine, soit les plus récents téléchargés ci-dessus)*
2. Pour commencer, on réinstalle la ROM d'origine pour partir d'une base connue : 
   * Lancer l'outil `flash-tool.exe` depuis le répertoire de la ROM *(SP-Flashable TWRP 3.1.0)*
   * Ouvrir le `scatterfile` (.txt) de la ROM d'origine *(MT6582_scatter_LVP0-WIFI-ROW.0.024.01.txt)*
   * Lancer le chargement via le bouton Download
   * Puis brancher le câble USB, et rebooter la tablette si nécessaire *(à noter, il est important de respecter l'ordre de ces opérations, car le mode de chargement ne reste actif qu'un court moment lors du démarrage de la tablette contrairement à d'autres marques)*
   * Attendre et vérifier que tout s'est bien passé ; la tablette devrait pouvoir se lancer normalement *(le premier reboot peut être assez long)*
3. On installe ensuite TWRP  qui est le recovery qui permettra d'installer la ROM téléchargée : il faut répéter les mêmes opérations que ci-dessus, mais sélectionner le scatterfile depuis le répertoire SP-Flashable TWRP 3.1.0 *(MT6582_scatter_LVP0-WIFI-ROW.1.016.01.txt)*
4. On reboote dans le mode recovery TWRP en maintenant enfoncés les boutons `Power` et `Volume -` suffisamment longtemps jusqu'à pouvoir choisir le mode recovery.
5. On doit maintenant effacer le système précédent pour pouvoir installe le nouveau via `Wipe system+cache+data`
6. Puis on va pouvoir charger la ROM via sideload: 
   * en sélectionnant dans TWRP le menu `Advanced / sideload` 
   * puis en lançant en mode de commande depuis le répertoire de la ROM à installer : `adb sideload  Resurrection_Remix_N_v5.8.5_Lenovo_A7600-F.zip`
   * le téléchargement va prendre un certain temps, vérifier à la fin que tout s'est bien passé
7. On recommence pour installer les Google Apps : `Advanced / sideload`  + `adb sideload open_gapps-arm-7.1-pico-20220215.zip`
8. La tablette peut maintenant être débranchée et redémarrer ; le premier redémarrage va prendre plusieurs minutes, c'est normal
9. La tablette est maintenant en version Android 7.1.2 avec les nouvelles fonctionnalités, et une ROM "Resurrection Remix" très paramétable. 

# Conclusion
Cette simple mise à jour permet de prolonger la vie de cette tablette de quelques années, car le matériel est toujours suffisant pour l'usage que j'en ai, et le seul problème que j'avais était lié à l'obsolescence du logiciel. Et en prime j'ai gagné la fonction des gestures dans les applications qui n'étaient pas gérée dans ma version précédente (très pratique pour passer en plein écran YouTube plutôt que d'avoir à viser le minuscule bouton). C'est sans doute la dernière version de ROM qui sera éditée par la communauté, mais avec un peu de chances, elle pourra durer longtemps, car les écarts de fonctionnalités Android tendent à diminuer)

À l'heure de la prise de conscience des déchets numériques, il serait intéressant de pouvoir trouver un moyen pour que les fabricants de matériel puissent mettre à jour le logiciel de leur matériels, ou éventuellement, s'ils ne font pas, de libérer les ressources logicielles permettant à la communauté de réaliser cette mise à jour. C'est un critère d'achat que j'intègre lors du choix d'une tablette ou d'un smartphone, d'une part, toutes les marques n'ont pas les mêmes pratiques en mise à jour, et d'autre part, de favoriser un modèle largement répandu sur lequel il y aura plus de chance que la communauté soit suffisamment grande pour chercher à réaliser une mise à jour, plutôt qu'un modèle peut être supérieur, mais à la diffusion très confidentielle.

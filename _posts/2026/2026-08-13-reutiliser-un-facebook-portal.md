---
title: Réutiliser un Facebook Portal
lang: fr
tags:
- Hack
- Android
- Shell
- Home Assistant
categories:
- Domotique
modules:
- gallery
toc: 2
ia: Perplexity, Copilot
image: files/2026/facebook_portal_copilot_20260813_122938.jpg
---

Il est possible depuis peu de réutiliser les Facebook Portal rendus inutiles par l'arrêt du service en écrans connectés domotique.

Les Facebook Portal étaient des écrans connectés conçus par Meta pour les appels vidéo, avec caméra, micro et haut-parleurs intégrés, pensés à l’origine pour intégrer l'écosystème Facebook dans le salon ou la cuisine. Cependant, ils sont devenus peu utiles après l’arrêt de la gamme par Meta en novembre 2022, puis le retrait de services et d’applications a fini par les rendre presque inutilisables dans leur usage d’origine. Le matériel est cependant bon, mais restait verrouillé par Meta. Une discrète mise à jour récente permet enfin de libérer ces matériels et leur éviter de finir au fond d'un tiroir.

Meta a publié une nouvelle version du firmware qui donne accès à `adb`, l'outil de debug Android,  permettant ainsi de changer la configuration et d'installer de nouvelles applications. Il y a différentes solutions pour exploiter cette nouvelle possibilité. Ce billet décrit une méthode utilisant deux outils opensource `unmetaportal` pour d’abord enlever l’interface Meta, puis installer `Immortal` un lanceur avec des fonctions utiles. Dans mon cas, je l'utiliserai comme écran Home Assistant, en installant enfin l'application Android, mais d'autres usages sont bien sûr possibles.

# Mise à jour et remise à zéro

Pour pouvoir débloquer l'appareil, il :
1. Mettre à jour le firmware du Portal (Paramètres / A propos / Rechercher des mises à jour)
2. Réinitialiser l’appareil (Paramètres / Général / Réinitialiser le périphérique)
3. Reconnecter temporairement un compte Facebook ou WhatsApp si nécessaire pour retrouver les menus de configuration et le mode debug.

Une fois ces opérations effectuées, en retournant dans les paramètres, un nouveau menu "Debuguer" est apparu !

![]({{ 'files/2026/portal_settings_apropos.png' | relative_url }}){: .img-center .mw80}


# Activer ADB

Sur le Portal, ouvrir les paramètres puis le menu de debug, et activer ADB.  

![]({{ 'files/2026/portal_settings_debug.png' | relative_url }}){: .img-center .mw80}

Ensuite, brancher le câble USB-C. Sur le Facebook Portal, le port USB est sous un petit cache en caoutchouc sur le bord du haut parleur arrière. Il faudra ensuite accepter l’autorisation de débogage sur l’écran du Portal.

Il vous faudra ensuite un PC avec `adb`, un shell, et des outils comme `curl` et `wget`.  Personnellement j'ai utilisé Windows jusqu'à avoir une connection adb fonctionnelle (installeur Android ou avec scoop: `scoop install adb`), puis ensuite une VM Ubuntu avec passage du port USB et `sudo apt install adb curl wget`.

Si le device apparaît dans `adb devices -l`, la connexion est prête. S'il n'est pas détecté, réinstallez les drivers USB Android.

![]({{ 'files/2026/portal_adb_devices.png' | relative_url }}){: .img-center .mw80}

Vous pouvez maintenant vérifier modèle et version avec :

```bash
adb shell getprop ro.product.model
adb shell getprop ro.build.version.sdk
```


# Supprimer Facebook Portal avec unmetaportal

Le projet `unmetaportal` permet de transformer un Portal Android 9 en appareil Android standard avec un lanceur normal.  
Il gère automatiquement les différences entre les modèles tactiles Portal/Portal+ et le Portal TV.

Cloner le dépôt :

```bash
git clone https://github.com/fcjr/unmetaportal
cd unmetaportal/
```

Faire d’abord un test sans modifier l’appareil :

```bash
./unmetaportal.sh --dry-run
```

Puis lancer la conversion :

```bash
./unmetaportal.sh
```

Le script :
1. Vérifie la connexion ADB.
2. Détecte le modèle.
3. Télécharge un lanceur adapté.
4. Le définit comme HOME.
5. Désactive les surfaces Meta inutiles.
6. Nettoie les données de session.
7. Rafraîchit la liste des applications.

Pour nettoyer aussi les comptes Android stockés côté système :

```bash
./unmetaportal.sh --with-account-cleanup
```

Il est possible de revenir à l’état d’origine :

```bash
./unmetaportal.sh --revert
```


## Installer Immortal

[Immortal](https://github.com/starbrightlab/immortal) est un lanceur personnalisé, un économiseur d’écran en mode cadre photo et une boutique d’applications intégrée qui redonnent vie aux appareils Meta Portal abandonnés par Meta. C'est un ajout intéressant à installer après avoir débloqué le Portal.


Pour une installation plus complète, le projet fournit aussi un kit de provisioning. Ce kit peut installer Immortal, le définir comme HOME, gérer le screensaver, et corriger certains problèmes :

```bash
wget https://github.com/starbrightlab/immortal/releases/download/v1.64/portal-kit.zip
unzip portal-kit.zip
cd portal-kit/
./Provision-Portal.command
```

Il est bien sûr possible de télécharger et installer l'APK à la main en suivant les instructions sur le GitHub.


# Conclusion & usages possibles
Maintenant que Meta a ouvert le Portal,  avec `unmetaportal` et `Immortal`, on récupère un appareil propre, simple et réutilisable !

Une fois converti, le Portal devient un petit écran Android utile pour :
- Un tableau de bord Home Assistant pour faire un écran domotique pour la maison
- Un cadre photo avec le screensaver Immortal
- Un navigateur dédié.
- Un support de test Android avec ADB.

Quelques copies d'écran de Immortal :
- ![Home Immortal]({{ 'files/2026/portal_home.png' | relative_url }})
- ![Settings Immortal]({{ 'files/2026/portal_settings.png' | relative_url }})
- ![Immortal Screensaver options]({{ 'files/2026/portal_screensaver.png' | relative_url }})
- ![Immortal Screensaver sources]({{ 'files/2026/portal_screensaver_sources.png' | relative_url }})
{: .gallery .slide .gallery-thumbs .img-center .mw60 }


Références :
- [GitHub unmetaportal](https://github.com/fcjr/unmetaportal)
- [GitHub immortal](https://github.com/starbrightlab/immortal)
- [Documentation Meta Portal pour le setup](https://developers.meta.com/horizon/documentation/android-apps/portal-setup/)



# Compléments
## Gestion d'un certificat interne

J’ai aussi essayé d’ajouter un certificat interne pour accéder en HTTPS à mes services qui utilisent une autorité de certification personnelle.  
La méthode classique ci-dessous n’a pas fonctionné correctement sur mon Portal : écran grisé, rien ne se passe.

```bash
adb push internal_ca.crt /sdcard/Download/
adb shell am start -a android.intent.action.VIEW  -t application/x-x509-ca-cert -d file:///sdcard/Download/internal_ca.pem
```

En revanche, une solution simple fonctionne :
1. Installer Firefox sur le Portal.
2. Télécharger le certificat depuis un partage réseau ou via un gestionnaire de fichiers.
3. Ouvrir le certificat dans Firefox et lancer l’import.

Dans mon cas, cela a permis d’ajouter le certificat correctement.  


## Capturer l’écran

Les copies d'écran pour illustrer ce billet ont été faites via ADB :

```bash
adb exec-out screencap -p > portal_settings_apropos.png
```

Powershell semble corrompre la redirection et rendre le PNG illisible, dans ce cas utiliser :

```powershell
cmd /c "adb exec-out screencap -p > portal_settings_apropos.png"
```

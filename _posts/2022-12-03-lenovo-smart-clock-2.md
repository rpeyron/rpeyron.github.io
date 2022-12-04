---
title: Hacks pour Lenovo Smart Clock 2
date: '2022-12-03 14:35:00'
image: files/2022/SmartClock2.jpg
lang: fr
categories:
- Avis Conso
- Domotique
tags:
- Hack
- Android
- Domoticz
- Alexa
- Google Home
- Dock
- Smart
- Clock
- Lenovo
---

En bidouillant un peu, il est possible de débloquer le Lenovo Smart Clock 2 pour utiliser Spotify, Alexa, ou même une télécommande Domoticz, Alexa ou Google TV.

# Présentation du Lenovo Smart Clock 2
Le Lenovo Smart Clock 2 est un réveil connecté assez compact avec un écran couleur tactile de 4 pouces. Il embarque android 10 et Google Assistant.  Les fonctions sont optimisées pour un usage en réveil : le menu pour régler le réveil est très accessible, il affiche une horloge bien visible, l'affichage est adapté dès qu'il détecte une faible luminosité, il embarque la météo et un YouTube Music à l'interface très très simplifiée. L'affichage normal permet également de faire cadre photo.

Proposé normalement à 70€, il n'est pas spécialement intéressant par exemple par rapport à un Google Nest Hub qui a un écran 4 fois plus grand et des possibilités plus importantes. Mais avec des promotions comme récemment qui le font chuter à 17€ (!) et comme il est basé sur android, cela ouvre des possibilités de l'acheter pour bidouiller et le détourner de son usage initial.

# Etape 1 - Installer un apk
Le principe est d'utiliser les fonctions d'accessibilité pour pouvoir ouvrir un navigateur (via les conditions d'utilisations qui ouvrent un navigateur pour les consulter) et télécharger un apk (via le copier/coller depuis la vocalisation). La procédure est donnée sur [ce post du site XDA](https://forum.xda-developers.com/t/guide-installing-android-apps-on-the-lenovo-smart-clock-2.4393271/) ; voici les étapes à suivre :

1. Activer Accessibilité / Lecteur d'écran
2. Repérer la recherche pour télécharger l'apk souhaité (par exemple "f-droid")
3. Créer un rendez vous le même jour avec comme titre cette recherche
4. Demander "qui a t il dans mon calendrier"
5. Sur le rendez-vous, faire lire le nom du rendez-vous
6. Geste "L" (bas et droite) jusqu'à obtenir le menu, défiler avec le geste vers la droite jusqu'à "Copier le dernier texte lu dans le presse-papier" ; attention si le geste est raté et qu'un autre texte est lu, il faut recommencer 
7. Geste "L" jusqu'à obtenir le menu, et défiler jusqu'à paramètres Talkback
8. Défiler avec le geste vers la droite jusqu'à la politique de confidentialité, double cliquez, cela ouvre le navigateur !  Accepter toutes les permissions (se referme sinon)
9. Cliquer sur le menu des options Google et cliquer sur "Recherche Google" ; acceptez les conditions google
10. Coller le texte dans le presse papier et lancer la recherche
11. Cliquer sur le lien qui permet d'atteindre le ficher apk, lancer le téléchargement et installer l'apk télécharger (il faudra accepter d'installer depuis des sources inconnues)

# Etape 2 - Installer un nouvel écran d'accueil
Via F-Droid, installer un nouvel écran d'accueil J'ai opté un peu au pif pour [Lanceur Discret](https://f-droid.org/fr/packages/com.vincent_falzon.discreetlauncher/) qui fait le job, mais il y en a sans doute des plus adaptés. A noter que toutes les applications android ne fonctionnent pas sur le Smart Clock 2, mais vous ne pourrez le savoir qu'en essayant...

Une fois installé, ouvrir le nouveau lanceur et définissez le comme lanceur par défaut. Les fonctions du Smart Clock 2 sont toujours accessibles via les applications "Home" ou "Assistant Core", mais à ce stade, pour revenir sur le lanceur il suffira de débrancher et rebrancher l'appareil.

Via le lanceur, vous allez voir maintenant les applications auxquelles vous pouvez accéder. Pour ma part avec le "Lanceur Discret"; il n'affichait pas par défaut la liste des actions, donc il faut ajouter les applications en favoris et défiler l'écran vers le bas pour afficher les favoris ; on peut aussi modifier les paramètres pour qu'il affiche par défaut les favoris. 



# Etape 3 - Appairer un clavier bluetooth

L'application "Paramètres" devrait maintenant être accessible et permet d'accéder aux paramètres d'android, et notamment les périphériques Bluetooth. Il existe une application mobile ["Clavier et souris sans serveur"](https://play.google.com/store/apps/details?id=io.appground.blek)  assez pratique qui permet de transformer votre mobile en clavier bluetooth, avec en prime le bouton "Home" qui manque cruellement sur le Smart Clock 2. Contrairement aux autres "claviers sans fil" disponibles sur le Google Play Store qui nécessitent pour la plupart d'installer un serveur sur l'appareil à controler, celui-ci permet d'émuler un clavier bluetooth standard. Parfait pour notre cas ! La procédure d'appairage est un peu chatouilleuse, mais en suivant bien les étapes cela fonctionne. Sinon le plus simple est de supprimer les appairages et de recommencer.

Une fois appairé, il est maintenant possible:
- de revenir facilement sur notre lanceur avec la touche "Home" sans avoir à débrancher/rebrancher à chaque fois
- d'utiliser le clavier pour saisir du texte sans passer par la procédure de l'étape 1

Cependant, la puce du Smart Clock 2 est un peu limitée, et ne permet pas de garder la connexion wifi active lorsque le bluetooth est activé... il faut donc arriver à jongler entre les deux en se déconnectant de l'application "Clavier et souris sans serveur".

# Etape 4 - Installer un clavier virtuel

Pour jongler un peu moins avec l'application mobile, il est possible d'ajouter un clavier virtuel. Via F-Droid, j'ai choisi ce clavier [Simple Keyboard](https://f-droid.org/fr/packages/rkr.simplekeyboard.inputmethod/), effectivement simple mais efficace. Une fois installé il faudra activer le clavier soit en le lançant soit directement dans les paramètres. A noter que lorsque l'application "Clavier et souris sans serveur" est connectée, cela désactive le clavier virtuel, pensez à vous déconnecter avant de tester le clavier virtuel.

# Etape 5 - Installer une touche Home virtuelle
Toujours via F-Droid, installer l'application ["Key Mapper"](https://f-droid.org/fr/packages/io.github.sds100.keymapper/). Cette application permet de redéfinir des touches et de les affecter à un autre usage. Une fois installée et lancée, il faut bien donner toutes les autorisations et notamment l'autorisation d'accessibilité. Je ne sais pas pourquoi mais elle saute de temps en temps, si le mapping ne marche plus il faut retourner dans les paramètres d'accessibilité pour réautoriser l'application. Pour éviter trop de désactivations intempestives, il faut autoriser l'application dans DuraSpeed pour l'autoriser en arrière plan et désactiver l'optimisation de la batterie qui peut aussi tuer les applications en arrière plan.

Pour ma part j'ai défini trois mapping:
- Sur un double clic sur le bouton "volume +" j'ai défini l'action "Home"
- Sur un double clic sur le bouton "volume -" j'ai défini l'action "Back"
- Sur un clic long sur le bouton "volume +" j'ai défini comme actions d'une part de désactiver la rotation de l'écran et ensuite de forcer une rotation (l'action mode paysage n'a pas fonctionné pour moi) ; cela permettra de forcer le mode paysage pour les applications qui veulent absolument s'afficher en mode portrait

Avec ces raccourcis et le clavier virtuel, ça devrait maintenant beaucoup limiter le recours au clavier bluetooth ou le reboot.

# Etape 6 - Installer vos applications

Quelques exemples:
- [Aurora Store](https://f-droid.org/fr/packages/com.aurora.store/) via F-Droid, qui permet d'installer des apk téléchargés depuis le Google Play Store
- Spotify depuis Aurora
- Pour YouTube Music, l'application native ne fonctionne pas, j'ai opté pour installer Edge (Chrome ne marche pas non plus, et Firefox est plus lent), et installer le raccourci de l'application web YouTube Music


Quelques autres idées non encore testées:
- Le controle de votre domotique (via Homy / Domoticz par exemple)
- Le controle de votre streaming OBS via OBS Remote
- Ultimate Alexa si vous êtes plus team Alexa que Google Assistant
- ...

On peut également activer le débogage USB, mais je n'ai pas réussi à me connecter via adb en wifi. Il semble possible de se connecter en USB en usant du fer à souder mais je ne me suis pas lancé là dedans...
# Bilan
![]({{ 'files/2022/SmartClock2.jpg' | relative_url }}){: .mw60 .img-center }

Même si ce n'est pas vraiment simple et intuitif, cela permet de bénéficier des prix très attractifs du Smart Clock 2 actuellement (17€), et de recycler le Smart Clock 2 en petit dock pour d'autres usages. Les usages seront sans doute un peu plus limités que ceux d'un vieux smartphones qui n'est plus utilisé, mais le design en dock restera plus pratique et le niveau sonore du haut parleur est tout à fait décent pour en faire une petite enceinte d'appoint.

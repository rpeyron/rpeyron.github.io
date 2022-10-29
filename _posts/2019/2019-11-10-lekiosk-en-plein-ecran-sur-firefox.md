---
post_id: 4142
title: 'LeKiosk en plein écran sur Firefox'
date: '2019-11-10T20:50:29+01:00'
last_modified_at: '2019-11-13T00:40:55+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4142'
slug: lekiosk-en-plein-ecran-sur-firefox
permalink: /2019/11/lekiosk-en-plein-ecran-sur-firefox/
image: /files/2019/11/lekiosk-logolk-color2-1000px.png
categories:
    - Informatique
tags:
    - Hack
    - LeKiosk
    - Web
lang: fr
---

Utilisateur heureux de LeKiosk depuis quelques temps, je souhaite pouvoir disposer d’une lecture plein écran sur ma tablette pour avoir plus de surface de lecture.

Depuis quelques années je me suis converti à la lecture de magazines sur tablette. Il y a beaucoup de coté plus pratiques : plus de passage obligatoire chez le marchand de journaux, plus de piles de magazines papiers qui s’entassent, et l’accès à des offres de type illimités (mais sur un catalogue plus ou moins limité). J’ai commencé à découvrir ce système avec mon offre internet Red by SFR qui donnait accès à SFR Presse, qui s’est révélé satisfaisant pendant quelques années, jusqu’à ce qu’ils suppriment la lecture pdf. A cette période, CDiscount s’est mis à proposer un accès à LeKiosk avec leur offre CDAV, à un tarif bien plus intéressant que le forfait mensuel de LeKiosk qui reste un peu cher (9.90€/mois). L’offre CDAV coute 39.90€/an, et se négocie plusieurs fois par an à moins de 10€. Cela donne accès à l’application tablette LeKiosk, moyennant une re-authentification tous les mois. Puis Canal+ a également intégré dans ses offres l’accès à l’offre LeKiosk. Déjà client Canal+, j’ai donc basculé sur cette offre. Seul bémol, il n’y a pas d’accès à l’application tablette, mais seulement à la lecture via le site web, moyennant une re-authentification quotidienne. Le problème est que la version site web a un gros défaut, elle ne sait pas fonctionner en plein écran, il reste toujours une barre noire pour les boutons de navigation. Or j’ai acheté une tablette Asus ZenPad Z500 qui dispose d’un ratio 4/3 spécifiquement pratique pour maximiser l’affichage des magazines (versus le ratio classique 16/9 qui laisse de grandes barres noires avec un affichage plus réduit, et donc trop petit pour une bonne lecture).

![](/files/2019/11/Screenshot_20191110-201313-225x300.jpg){: .img-center}

J’ai donc cherché à pouvoir afficher la page en grand, et comme il s’agit d’une application HTML5 sur un navigateur classique, il doit y avoir possibilité de bidouiller. Pour ce faire j’ai choisi le navigateur Firefox qui permet d’avoir des plugins sur Android contrairement à Chrome que j’utilise classiquement. J’ai donc installé Firefox et l’extension [Custom Style Script](https://addons.mozilla.org/fr/firefox/addon/custom-style-script/) qui permet d’injecter du CSS et du javascript personnalisés sur des sites particuliers. Exactement ce qu’il me faut.

Les outils de développement de la version PC de Firefox ont été très efficaces pour identifier les bonnes modifications de CSS pour régler son compte à la barre du haut. Je voulais supprimer la barre noire, mais pouvoir pour autant conserver les contrôles. Il existe très certainement des façons plus élégantes que ce que j’ai fait, par exemple de faire apparaître la barre de navigation par swipe vers le bas, mais j’ai opté pour la simplicité, et j’ai simplement rendu la barre flottante et transparente. On voit encore juste le bord des contrôles, ce qui est bien suffisant pour mon usage.

Le code CSS a utiliser est super simple, à utiliser sur l’adresse `https://reader.lekiosk.com` :

```css
/* app.496e29c3.css | https://reader.lekiosk.com/css/app.496e29c3.css */
#reader_header #reader_header_content[data-v-27e0c72a] {
    padding: 1px 3px;
    background-color: transparent;
}

#reader #reader_container {
    padding-top: 0px;
}

/* chunk-vendors.69d2b632.css | https://reader.lekiosk.com/css/chunk-vendors.69d2b632.css */
.lk .btn.btn-secondary {
    background-color: transparent;
}

/* Élément | https://reader.lekiosk.com/fr/901219/21531805 */
div#canvas1,
#canvas1 {
    width: 100%;
    height: 100%;
}

#reader > div:nth-child(4) {
 display: none;
}
```

Malheureusement ce n’est pas suffisant, car si cela déplace bien la page vers le haut, cela n’augmente pas sa taille pour autant. En effet, la taille d’affichage n’est pas simplement régie par une feuille de style CSS mais créée dynamiquement en javascript. Il faut donc se plonger un peu plus dans le code de l’application, ce qui s’est avéré bien plus complexe que la partie CSS. En effet, il s’agit d’une application Vue.js dont le code source semble avoir été obfusqué/crypté. Tous les noms de fonctions “lisibles” ont été remplacés par des noms comme “`x[_0x1627(“0x1af”)][0]` “. C’est assez ingénieux, tous les noms sont déclarés dans un tableau au début du document, puis mélangés et appelés via une autre fonction. Cela rend une compréhension “statique” quasiment impossible. Cependant, le mode débuggueur de Firefox permet d’avoir l’évaluation immédiate du résultat et de retrouver ainsi le nom de la fonction appelée.

Je découvre assez facilement dans le code la fonction qui est source de mes ennuis :

```
var t = window["innerHeight"] - 72
```

Il suffit que je commente dans le mode développeur de Firefox le “- 72” (qui correspondait à la hauteur de la barre de navigation) pour que la page se redimensionne à la bonne taille. Si la solution est assez simple, il est malheureusement beaucoup plus compliqué de trouver le moyen d’injecter la modification. Le code utilise de nombreuses fonctions implicites qui ne permettent pas simplement de les redéfinir, et certains callbacks sont effectués avec des timers. Je finis finalement par trouver la solution de redéfinir une des fonctions du code après chargement via un timer. Le code suivant est à injecter via le plugin Custom Style Script :

```js
setTimeout(function() {
    document.querySelectorAll('div#reader')[0].__vue__.setCanvasSize = function(x) {
        this["singlePage"] = true;
        if (x && x[_0x1627("0x1af")][_0x1627("0x0")] > 0) {
            if (0 === this[_0x1627("0xd")][_0x1627("0xb8")]) {
                var e = x[_0x1627("0x1af")][0];
                this[_0x1627("0xd")]["width"] = e[_0x1627("0xb8")], this[_0x1627("0xd")][_0x1627("0xb7")] = e[_0x1627("0xb7")]
            }
            if (this[_0x1627("0xb3")] <= 1) {
                var t = window["innerHeight"] /*- 72*/ ,
                    a = this[_0x1627("0xda")] * t,
                    _ = a;
                if (!this[_0x1627("0xcd")] && this["currentPage"] > 1 && this["currentPage"] < this["maxPage"] && (_ *= 2), _ > window[_0x1627("0x1b2")]) {
                    var n = this["singlePage"] ? window["innerWidth"] : window[_0x1627("0x1b2")] / 2;
                    x[_0x1627("0xba")][_0x1627("0xb8")] = "" [_0x1627("0x2d")](Math[_0x1627("0x1b3")](n), "px"), x[_0x1627("0xba")][_0x1627("0xb7")] = "" [_0x1627("0x2d")](n / this[_0x1627("0xda")], "px")
                } else x[_0x1627("0xba")][_0x1627("0xb8")] = "" ["concat"](Math["floor"](a), "px"), x[_0x1627("0xba")]["height"] = "" [_0x1627("0x2d")](t, "px")
            }
        }
    }
    document.querySelectorAll('div#reader')[0].__vue__.setCanvasSize();
}, 5000);
```

Cela ajoute un timer de 5s qui va surcharger la fonction setCanvasSize de l’application principale pour la fonction dont j’ai commenté la suppression de la hauteur de la barre de navigation, et re-provoque un nouvel appel à cette fonction pour adapter la taille. Le timer de 5 secondes est tout à fait expérimental et peut être à modifier suivant votre configuration.

Le résultat dans les réglages de l’extension ressemble donc à ça :

![](/files/2019/11/Screenshot_20191110-202644-e1573415179134.jpg)

Dernier petit problème : si cela fonctionne très bien sur PC, l’affichage ‘tablette’ de l’application LeKiosk désactive le bouton “Plein écran”. Or il n’y a pas de bouton permettant cela sur Firefox et comme la page est redimensionnée à la taille de l’affichage, Firefox ne passe pas automatiquement en plein écran en défilant la page. On voit dans le code que l’application utilise le user agent pour détecter qu’il s’agit d’une tablette et ne pas afficher le bouton plein écran. J’ai donc ajouté l’extension [ User-Agent Switcher and Manager](https://addons.mozilla.org/fr/firefox/addon/user-agent-string-switcher/) pour indiquer à Firefox d’utiliser un user-agent PC et le tour est joué ! (et l’affichage bien plus pratique au total)

Le rechargement de la page donne alors l’affichage en “vrai” plein écran !

![](/files/2019/11/Screenshot_20191110-201409-225x300.jpg){: .img-center}

Deux jours après avoir fini cette modification, LeKiosk annonce une nouvelle version de son application : la modification risque donc de ne plus marcher à l’heure où vous lirez ces lignes… A suivre.

**Edit (12/11/2019) :** LeKiosk s’appelle maintenant Cafeyn. A cette occasion l’application a été légèrement mise à jour, mais les principes restent identiques. Ci-dessous les nouveaux codes à prendre en compte, sur la nouvelle adresse https://reader.cafeyn.co :

Code CSS :

```css
/* app.d6bb6e96.css | https://reader.cafeyn.co/css/app.d6bb6e96.css */

#reader_header #reader_header_content[data-v-3fc15d64] {
  /* padding: 12px 30px; */
  /* background-color: #000; */
  padding: 1px 3px;
  background-color: transparent;
}

#reader_header_title {
  display: none;
}

#reader #reader_container {
  /* padding-top: 65px; */
  padding-top: 0px;
}

#app .btn-secondary {
  /* background-color: #1e323d; */
  /* border: 1px solid #1e323d; */
  background-color: transparent;
  border: 1px solid grey;
}
```

Code JavaScript :

```js
setTimeout(function(){
document.querySelectorAll('div#reader')[0].__vue__.setCanvasSize= function(x) { this["singlePage"]=true;
            if (x && x[_0x2c90('0x1a0')][_0x2c90('0x0')] > 0) {
              if (0 === this[_0x2c90('0x10')][_0x2c90('0xae')]) {
                var c = x['children'][0];
                this[_0x2c90('0x10')][_0x2c90('0xae')] = c[_0x2c90('0xae')],
                this[_0x2c90('0x10')][_0x2c90('0xad')] = c['height']
              }
              if (this['scale'] <= 1) {
                var e = window[_0x2c90('0x19d')] /* - 72*/,
                t = this['ratio'] * e,
                _ = t;
                if (!this['singlePage'] && this[_0x2c90('0xc6')] > 1 && this[_0x2c90('0xc6')] < this[_0x2c90('0xd4')] && (_ *= 2), _ > window[_0x2c90('0x1a1')]) {
                  var a = this[_0x2c90('0xc7')] ? window[_0x2c90('0x1a1')] : window['innerWidth'] / 2;
                  x['style'][_0x2c90('0xae')] = ''[_0x2c90('0x2b')](Math[_0x2c90('0x1a2')](a), 'px'),
                  x['style']['height'] = ''[_0x2c90('0x2b')](a / this[_0x2c90('0xd5')], 'px')
                } else x['style'][_0x2c90('0xae')] = ''[_0x2c90('0x2b')](Math[_0x2c90('0x1a2')](t), 'px'),
                x[_0x2c90('0xaf')][_0x2c90('0xad')] = ''['concat'](e, 'px')
              }
            }
}
document.querySelectorAll('div#reader')[0].__vue__.setCanvasSize();
},5000);

```

Il est probable que ces éléments soient à mettre à jour avec chaque modification de l’application LeKiosk.
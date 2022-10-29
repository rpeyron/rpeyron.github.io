---
post_id: 3935
title: 'Scripts pour Google Docs'
date: '2018-12-08T14:41:01+01:00'
last_modified_at: '2018-12-08T14:41:01+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=3935'
slug: scripts-pour-google-docs
permalink: /2018/12/scripts-pour-google-docs/
image: /files/2018/11/application-google-docs.jpg
categories:
    - Informatique
tags:
    - Google
    - Scripts
lang: fr
---

Après la migration de mon site web sur WordPress, je poursuis la modernisation des services que j’utilise, et notamment mes pages dokuwiki privées vers Google Docs. Pour cela il existe un [plugin odt](https://www.dokuwiki.org/plugin:odt) bien pratique qui permet d’extraire les pages wiki sous format OpenOffice, afin de les importer très facilement sous Google Docs. L’import fonctionne très bien, trop bien même car il importe des signets pour chaque en-tête de paragraphe. N’ayant pas besoin de ces signets j’ai souhaité les supprimer, et comme il y en avait pas mal, en automatisant la tache. L’occasion de découvrir les App Scripts.

L’éditeur de script s’active simplement depuis n’importe quel document Google Docs via le menu Outils / Editeur de scripts. A noter qu’en procédant de cette façon le script sera attaché au document ; vous pouvez également installer l’extension “Google Apps Script” pour éditer un script non attaché à un document. Pour ma part j’ai opté pour créer un document dont la seule fonction est d’héberger mes scripts. C’est d’autant plus utile de les regrouper qu’il faudra autoriser votre module de script à accéder à votre Google Drive comme n’importe quelle autre extension.

Le langage de script est assez simple. Je n’ai pas compris s’il suivait un standard quelconque mais cela ressemble beaucoup à du javascript. Il semble possible via [clasp](https://codelabs.developers.google.com/codelabs/clasp/#0), un outil opensource tiers de développer en Typescript. Une [documentation](https://developers.google.com/apps-script/guides/docs) assez claire et avec examples est disponible.

Voilà le code source correspondant à mon besoin de supprimer les signets :

```js
function removeBookmarks() {
  var doc = DocumentApp.getActiveDocument();
  var bkms = doc.getBookmarks();
  for (var i = 0; i < bkms.length; i++) {
    bkms[i].remove();
  }  
}
```

Pour l’exécuter il suffit de cliquer depuis l’éditeur de script sur le menu Exécuter / Exécuter la fonction / removeBookmarks.

Ce code fonctionne pour un script attaché dans un document (cf l’utilisation de la fonction getActiveDocument). Si vous avez externalisé votre script il faut modifier la référence au document à modifier, en remplaçant la deuxième ligne par :

```js
var doc = DocumentApp.openById('1U9-P4r-sfd-3u4DGNurbWc4Wfaj6sC7Ce9r_bCzJmfo');
```

L’argument à utiliser est l’identifiant ‘GID’ de votre document. Vous le trouvez assez simplement dans l’url de l’édition de votre page. Ainsi si l’url d’édition de votre document est `https://docs.google.com/document/d/1U9-P4r-sfd-3u4DGNurbWc4Wfaj6sC7Ce9r_bCzJmfo/edit` alors votre GID sera `1U9-P4r-sfd-3u4DGNurbWc4Wfaj6sC7Ce9r_bCzJmfo`. Cet identifiant change, par exemple si vous renommez votre document.

Le mécanisme de script semble très développé, avec une API assez riche, et la possibilité de les publier en extensions dans le store.
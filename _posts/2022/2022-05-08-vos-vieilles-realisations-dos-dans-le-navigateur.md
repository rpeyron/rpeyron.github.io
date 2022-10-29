---
id: 5702
title: 'Vos vieilles réalisations DOS dans le navigateur !'
date: '2022-05-08T21:41:22+02:00'
last_modified_at: '2022-05-08T21:55:21+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5702'
slug: vos-vieilles-realisations-dos-dans-le-navigateur
permalink: /2022/05/vos-vieilles-realisations-dos-dans-le-navigateur/
image: /files/logo-doszone.png
categories:
    - Informatique
tags:
    - dos
    - dosbox
    - iframe
    - jsdos
    - programmes
    - rpsoft
lang: fr
csp-default-src: "'unsafe-eval'"
csp-script-src: "'unsafe-eval'"
---

Les programmes DOS appartiennent maintenant au passé, et il faut maintenant utiliser des outils comme [DosBox](https://www.dosbox.com/) pour les utiliser. Avec [js-dos](https://js-dos.com/), il est maintenant aussi possible de les exécuter dans un navigateur.

Et c’est très simple. Il y a plusieurs méthodes expliquées sur le site, cela se fait en deux étapes :

- Créer le bundle .jsdos : ça se fait très facilement avec le site [Game Studio](https://dos.zone/studio/) : créez un zip de ce que vous voulez exécuter, uploadez-le, ajustez quelques paramètres et vous pourrez télécharger le bundle .jsdos créé
- Créer un site pour le bundle : méthode simple avec npm via `npx create-dosbox my-app` ; il vous suffit ensuite de customiser la trame produite à votre souhait et pour utiliser le bundle que vous avez créé avant. Dans mon cas, j’ai simplement intégré le code à une page wordpress.

Et voici le résultat sur une vieille démo de mes productions sous DOS quand j’étais au lycée :

<iframe style="width: 100%; aspect-ratio: 4/3;" srcdoc="&lt;div&gt;&lt;script src=&quot;{{ site.baseurl }}/files/js-dos/js-dos.js&quot;&gt;&lt;/script&gt;&lt;style&gt;@import &quot;{{ site.baseurl }}/files/js-dos/js-dos.css&quot;; #jsdos { width: 100%; aspect-ratio: 4 / 3; margin: 0; padding: 0; }&lt;/style&gt;&lt;div id=&quot;jsdos&quot; class=&quot;jsdos&quot; tabindex=&quot;0&quot;&gt;&lt;/div&gt;&lt;script&gt; emulators.pathPrefix = &quot;{{ site.baseurl }}/files/js-dos/&quot;; Dos(document.getElementById(&quot;jsdos&quot;), {}).run(&quot;{{ site.baseurl }}/files/RP-Soft.jsdos&quot;); &lt;/script&gt;&lt;/div&gt;"></iframe>

À noter que je n’ai pas réussi à ce que le clavier soit capturé et non traité par le navigateur, mais cet ennui disparait en passant en plein écran. La feuille de style CSS est également un peu ennuyeuse, car mal scopée et s’applique donc à tout wordpress… Pour pallier à cela, une astuce est de tout mettre dans une iframe dont on donne le code source dans l’attribut srcdoc en une seule ligne et encodée.

Ainsi :

```xml
<div>
<script src="{{ site.baseurl }}/files/js-dos/js-dos.js"></script>
<style>
@scope (.jsdos) {
@import "{{ site.baseurl }}/files/js-dos/js-dos.css";
#jsdos { width: 100%; aspect-ratio: 4 / 3;  margin: 0; padding: 0; }
}
</style>
<div id="jsdos" class="jsdos" tabindex="0"></div>
<script>
emulators.pathPrefix = "{{ site.baseurl }}/files/js-dos/";
Dos(document.getElementById("jsdos"), {}).run("{{ site.baseurl }}/files/RP-Soft.jsdos");
</script>
</div>

```

devient :

```
<iframe style="width: 100%; aspect-ratio: 4/3;" srcdoc="&lt;div&gt;&lt;script src=&quot;/files/js-dos/js-dos.js&quot;&gt;&lt;/script&gt;&lt;style&gt;@import &quot;/files/js-dos/js-dos.css&quot;; #jsdos { width: 100%; aspect-ratio: 4 / 3;  margin: 0; padding: 0; }&lt;/style&gt;&lt;div id=&quot;jsdos&quot; class=&quot;jsdos&quot; tabindex=&quot;0&quot;&gt;&lt;/div&gt;&lt;script&gt; emulators.pathPrefix = &quot;/files/js-dos/&quot;; Dos(document.getElementById(&quot;jsdos&quot;), {}).run(&quot;/files/RP-Soft.jsdos&quot;); &lt;/script&gt;&lt;/div&gt;"></iframe>

```
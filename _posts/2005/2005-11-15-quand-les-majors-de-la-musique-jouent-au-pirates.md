---
post_id: 1434
title: 'Quand les Majors de la musique jouent au Pirates'
date: '2005-11-15T19:54:25+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2005/11/quand-les-majors-de-la-musique-jouent-au-pirates/'
slug: quand-les-majors-de-la-musique-jouent-au-pirates
permalink: /2005/11/quand-les-majors-de-la-musique-jouent-au-pirates/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1818";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/pirate_1508004637.png
categories:
    - Informatique
tags:
    - Blog
lang: fr
---

Depuis quelques années, les Majors de la musique font du téléchargement illégal leur cheval de bataille : vocabulaire de “téléchargement légal”, procès contre des pirates, protections multiples et variées des CD. On pourrait croire que des sociétés prônant la légalité, leur comportements seraient sans reproches ?

Eh bien non, c’est que nous montrent deux exemples récents :  
– le premier avec le site de “téléchargement légal” Virgin-Mega qui a piraté le dernier titre de Madonna, dont France Telecom avait obtenu l’exclusivité.  
– le second avec Sony, et sa protection CD dont le logiciel comporte un rootkit, principe souvent utilisé par des pirates et virus.  
Les clients du site de “téléchargement légal” Virgin-Mega qui ont téléchargé le dernier titre de Madonna, *Hang Up* ont eu la mauvaise surprise de se retrouver involontairement receleurs. En effet, France Telecom avait négocié un partenariat exclusif avec Madonna à l’occasion de cette sortie évènement, jusqu’au 17 octobre. Ceci n’a pas plu du tout aux responsables du site Virgin-Mega, qui auraient acheté le titre sur le site Wanadoo, puis fait sauter la protection pour pouvoir le revendre sur leur plate-forme (<http://www.atelier.fr/juridique/madonna,virgin,mega,improvise,pirate-30684-21.html>). Bref, un piratage dans les règles de l’art, de plus pour un usage commercial…

Après les risques du “téléchargement légal”, les clients honnêtes ont eu une autre mauvaise surprise, orchestrée par Sony sur le domaine du CD protégé classique. Le principe du CD protégé est assez simple : il s’agit de créer un CD lisible sur les platines de salon classiques, mais illisibles sur un lecteur CD d’ordinateur, pour éviter la conversion en MP3 et sa diffusion sur Internet. Bien évidemment, le compromis n’est pas magique, et ces CD ont de nombreux disfonctionnements : refus de lecture sur de nombreuses platines de salon, protection inefficace sur certains lecteurs d’ordinateur… Au delà de ces difficultés techniques, ces CD “protégés” ont continué à se répandre, avec souvent le bénéfice d’un prix moindre.

Pour que les clients puissent tout de même lire ces CD sur leur ordinateur, le CD comporte un petit logiciel installable qui permettra de décrypter le disque, et d’en contrôler l’utilisation. Mark Russinovich, en inspectant son ordinateur, a remarqué qu’un rootkit présent sur sa machine provenait en fait de ce système de protection (<http://www.presence-pc.com/actualite/sony-cd-rootkit-12710/>).

Devant le scandale, Sony propose alors un patch permettant de retirer l’intrus (<http://www.presence-pc.com/actualite/rootkit-sony-patch-12742/>). Mais les problèmes ne s’arrêtent pas là. Des failles de sécurité sont alors rapidement découvertes dans ce rootkit, et exploitées par un virus (<http://www.presence-pc.com/actualite/sony-rootkit-12894/>). Avoir acheté et utilisé un CD Sony a alors compromis la sécurité de l’ordinateur !

C’en est trop, Microsoft ajoute alors dans l’outil AntiSpyware la suppression de cet intrus ([http://actualite.free.fr/\[…\]](http://actualite.free.fr/actu.pl?doc=multimedia/3_2005-11-15T191019Z_01_GAR565417_RTRIDST_0_OFRIN-MICROSOFT-SONY-POLEMIQUE-20051115.XML)).  
Sony annonce également l’arrêt de l’utilisation de cette technologie ([http://actualite.free.fr/\[…\]](http://actualite.free.fr/actu.pl?doc=multimedia/3_2005-11-12T193041Z_01_MAN266477_RTRIDST_0_OFRIN-SONY-BMG-ANTICOPIE-20051112.XML))

Une fois de plus, les majors décrédibilisent leur lutte contre le piratage en utilisant d’autres techniques malhonnêtes, plutôt qu’en proposant de réelles solutions ou alternatives pour répondre aux besoins des consommateurs.
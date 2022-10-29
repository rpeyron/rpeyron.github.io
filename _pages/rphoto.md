---
post_id: 2004
title: RPhoto
date: '2017-10-31T13:27:30+01:00'
last_modified_at: '2020-05-14T19:40:12+02:00'
author: admin
layout: page
guid: '/?page_id=2004'
slug: rphoto
permalink: /rphoto/
lang: fr
lang-ref: pll_59f866b35b96a
lang-translations:
    fr: rphoto
    en: rphoto-en
modules:
    - bootstrap
    - owl-carousel
google-fonts:
    - Caveat
disable-comments: false
---



<div class="container-fluid"><div class="row align-items-start"><div class="col-md" markdown="1">

*Recadrer. Simple.*
{: .font-xlarge .center }

RPhoto est un logiciel libre et léger pour retraiter ses photos numériques. Il a été créé du manque de logiciel capable de recadrer des photos en conservant un ratio longueur/largeur pour éviter les bords blancs à l’impression. Disponible pour Windows &amp; Linux.

[ Télécharger ](https://github.com/rpeyron/rphoto/releases/download/v0.4.5/rphoto_setup.exe){: .btn .btn-success .btn-lg style="width: 45%" } [ Github ](https://github.com/rpeyron/rphoto){: .btn .btn-primary .btn-lg style="width: 45%" }
{: .center}

<details markdown="1"><summary>Version 0.4.5 – Autres téléchargements Windows &amp; Linux :</summary>

- Sources : [rphoto-0.4.5.zip](https://github.com/rpeyron/rphoto/archive/v0.4.5.zip)
- Windows (Portable) : [rphoto\_bin.zip](https://github.com/rpeyron/rphoto/releases/download/v0.4.5/rphoto_bin.zip)
- Debian : [rphoto\_0.4.5-ppa1\_amd64.deb](https://github.com/rpeyron/rphoto/releases/download/v0.4.5/rphoto_0.4.5-ppa1_amd64.deb)
- Ubuntu :  <ppa:rpeyron/ppa>

</details>

</div><div class="col-md" markdown="1">

 ![](/files/2017/10/rphoto_scr.jpg)

 </div>
</div></div>

<br>

# Pourquoi opter pour RPhoto ?

<div class="container-fluid features-list"><div class="row">

<div class="col-sm">

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-crop-alt %}</div></div>
  <div class="col-9"><h4>Recadrer avec un ratio fixe  </h4>Recadrer les photos en conservant un rapport hauteur / largeur fixe (usuellement ratio de 4:3 ou 16:9) pour éviter des bandes blanches à l'impression.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-image %}</div></div>
  <div class="col-9"><h4>Conserver la qualité des photos  </h4> Recadrer, tourner des fichiers JPEG se fait sans perdre la qualité des photos grace à un traitement sans recompression.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-gift %}</div></div>
  <div class="col-9"><h4>Gratuit &amp; Open source </h4> RPhoto est complètement gratuit pour utilisation personnelle ou commerciale. Il est également open source. Le code source est disponible sous GitHub. N'hésitez pas à contribuer !</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-language %}</div></div>
  <div class="col-9"><h4>En français et en anglais  </h4>Actuellement traduit en français et en anglais, et également partiellement en tchèque et en russe.</div>
</div>

</div>

<div class="col-sm">

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-comment %}</div></div>
  <div class="col-9"><h4>Ajouter une légende et voir les Exif  </h4> Commenter votre photo pour décrire la scène, l'endroit ou ce que vous souhaitez. Les informations Exif enregistrées par votre appareil photo sont simplement lisibles. Toutes les marques sont supportées.
</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-layer-group %}</div></div>
  <div class="col-9"><h4>Optimisé pour traiter beaucoup de photos    </h4>RPhoto est prévu pour un usage facile pour traiter un grand nombre de photos, avec une ergonomie et des raccourcis clavier pour passer rapidement d'une image à une autre, et classer, selectionner ou supprimer simplement des photos.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fab.fa-linux %}</div></div>
  <div class="col-9"><h4>Multi-platformes &amp; à jour  </h4> Ecrit pour être hautement portable, RPhoto est disponible pour Windows &amp; Linux, et devrait être facilement porté sur d'autres plateformes d'ordinateur. Il est régulièrement mis à jour avec les dernières versions logicielles pour être toujours compatible avec votre ordinateur.</div>
</div>

</div></div></div>

<br>

# Guide de démarrage et manuel utilisateur

<details class="user-guide" id="manual-details"><summary>Quide de démarrage rapide / utilisation classique inclus dans le package (cliquer pour consulter)</summary>

<iframe id="manual" src="{{ '/files/old-web/soft/rphoto/manual/help_en.html' | relative_url }}" style="width:100%; background-color: #f5f5f5;" class="mw80 img-center" frameborder="0" onload="resizeIframe(this)"></iframe>

<script>
  function resizeIframe(obj) {
    obj.style.height = obj.contentWindow.document.documentElement.scrollHeight + 'px';
  }

  function resizeFrame() { resizeIframe(document.getElementById('manual')) }
  document.getElementById('manual').contentWindow.addEventListener('resize', resizeFrame);
  document.getElementById('manual-details').addEventListener("toggle", resizeFrame);

</script>

</details>

<br>

# Voir une démo

<iframe allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="" frameborder="0" height="900" width="1200" style="aspect-ratio: 1200/900; " class="mw80 img-center" loading="lazy" src="https://www.youtube.com/embed/pcDi5PxY8x4?feature=oembed" title="RPhoto-GuideRatio.avi"  ></iframe>

<br>

★★★★★
{: .center style="font-size: xxx-large"}

“RPhoto: almost perfect image viewer”
{: .center style="font-size: xx-large; font-family: Caveat, Serif;"}

RPhoto is lightweight, very fast, and offers basic rotate, resize and crop functions, optimizes JPEG files, has a built-in file explorer and is able to read EXIF data. After using it a bit, RPhoto already became my default image viewer and I am sure most of you will also like it!
{: .center .img-center .mw60}

[Web UPD8](http://www.webupd8.org/2009/10/rphoto-almost-perfect-image-viewer.html)
{: .center}


- ![Freelog](/files/2017/10/Freelog.jpg)
- ![logo-01net](/files/2017/10/logo-01net.png)
- ![webupd8-logo-main](/files/2017/10/webupd8-logo-main.png)
- ![computer_bild_header](/files/2017/10/computer_bild_header-1.png)
- ![framasoft](/files/2017/10/framasoft.jpg)
- ![ccm-logo](/files/2017/10/ccm-logo.png)
- ![photofreeware-logo](/files/2017/10/photofreeware-logo.png)
- ![launchpad-logo-and-name](/files/2017/10/launchpad-logo-and-name.png)
- ![gratilog_logo](/files/2017/10/gratilog_logo.png)
- ![freeware-files](/files/2017/10/freeware-files-1.jpg)
- ![freecode_fm_logo](/files/2017/10/freecode_fm_logo-1.png)
- ![download_weiss](/files/2017/10/download_weiss.svg)
{: .owl-carousel .img-center .mw80 style="background-color: #e0e0e0; padding: 1em; margin-bottom: 0; border-radius: 1em;" }

<script>
$(document).ready(function(){ $(".owl-carousel").owlCarousel({
  items:3, 
  loop:true, margin: 20, center:true, dots: false,
  autoplay: true, autoplayTimeout: 1000,
  responsive: {  600:{items:4}, 900:{items:5}}
});});
</script>



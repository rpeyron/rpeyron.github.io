---
post_id: 3101
title: xmlTreeNav
date: '2018-10-27T23:56:03+02:00'
last_modified_at: '2020-05-09T22:18:43+02:00'
author: admin
layout: page
guid: '/?page_id=3101'
slug: xmltreenav-en
permalink: /xmltreenav-en/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
lang: en
lang-ref: pll_5bd4def3c1fd5
lang-translations:
    en: xmltreenav-en
    fr: xmltreenav
modules:
    - bootstrap
    - owl-carousel
disable-comments: false
---


<div class="container-fluid"><div class="row align-items-start"><div class="col-md" markdown="1">

*The ultimate XML diff viewer*
{: .center }

Diff and view XML files with a powerful xmldiff engine, XPath and XLST.

[ Download ](https://github.com/rpeyron/xmltreenav/releases/download/v0.3.4/xmltreenav_setup.exe){: .btn .btn-success .btn-lg style="width: 45%" }   [ Github ](https://github.com/rpeyron/xmltreenav){: .btn .btn-primary .btn-lg style="width: 45%" }
 
 <details markdown="1"><summary>Version 0.3.4 – Other Windows &amp; Linux downloads (clic here)</summary>

- Sources : [v0.3.4.zip](https://github.com/rpeyron/xmltreenav/archive/v0.3.4.zip)
- Windows (Portable) : [xmltreenav\_bin.zip](https://github.com/rpeyron/xmltreenav/releases/download/v0.3.4/xmltreenav_bin.zip)
- Debian : [xmltreenav\_0.3.4ppa1\_amd64.deb ](https://github.com/rpeyron/xmltreenav/releases/download/v0.3.4/xmltreenav_0.3.4ppa1_amd64.deb)
- Ubuntu : <ppa:rpeyron/ppa>

</details>

</div><div class="col-md" markdown="1">

![](/files/old-web/soft/xml/xmltreenav/xmltreenav_scr.jpg)

</div>
</div></div>

<br>


# Features


<div class="container-fluid features-list"><div class="row">

<div class="col-sm">

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-tree %}</div></div>
  <div class="col-9"><h4>XML Tree Navigation   </h4>Easy navigation in the XML tree.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-search %}</div></div>
  <div class="col-9"><h4>XPath Search    </h4>Search through your file with the powerful XPath langage.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-weight-hanging %}</div></div>
  <div class="col-9"><h4>Support Large Files   </h4>Load very large files in an eyeblink.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-gift %}</div></div>
  <div class="col-9"><h4>Free software  </h4>xmlTreeNav is obvisouly free software and supported through Github. Feel free to contribute with translations, issue reports or pull requests.</div>
</div>


</div>

<div class="col-sm">

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-divide %}</div></div>
  <div class="col-9"><h4>Diff XML Files   </h4>Embedded powerful XML diff engine.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-tv %}</div></div>
  <div class="col-9"><h4>XSLT display customization  </h4>Customize the way your file will be displayed in XSLT (tree output or HTML output)</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fas.fa-language %}</div></div>
  <div class="col-9"><h4>English, French, Italian   </h4>Include English, French and Italian translations.</div>
</div>

<div class="row feature py-2">
  <div class="col-3"><div class="feature-icon">{% fa_svg fab.fa-linux %}</div></div>
  <div class="col-9"><h4>Linux and Windows   </h4>Run both on Linux and Windows.</div>
</div>


</div>

</div></div>

<br>


# Screenshots

![XSLT HTML Display](/files/old-web/soft/xml/xmltreenav/xmltreenav_scr2.jpg){: .img-caption-below}
![Diff Filtering](/files/old-web/soft/xml/xmltreenav/xmltreenav_scr.jpg){: .img-caption-below}
![Diff Tree](/files/old-web/soft/xml/xmldiff/xmldifftreeview_scr.jpg){: .img-caption-below}
![Diff Wizard](/files/old-web/soft/xml/xmldiff/xmldiff_scr.jpg){: .img-caption-below}
{: .img-col-2}

<script>
        // Convert alt of images to titles
        $(document).find("img.img-caption-below").each((i, el) => {
            let alt = $(el).attr("alt")
            if (alt) {
                $(el).wrap('<div class="img-alt-below"></div>')
                $(el).parent().attr("data-alt", alt)
            }
        })
</script>


<br />

# User manual

Read [the help file](/files/old-web/soft/xml/xmltreenav/help_en.html).

<br>

# They speak about xmlTreeNav

- ![launchpad-logo-and-name](/files/2017/10/launchpad-logo-and-name.png)
- ![framasoft](/files/2017/10/framasoft.jpg)
- ![ccm-logo](/files/2017/10/ccm-logo.png)
- ![logo-01net](/files/2017/10/logo-01net.png)
{: .owl-carousel .img-center .mw80 style="background-color: #e0e0e0; padding: 1em; margin-bottom: 0; border-radius: 1em;" }

<script>
$(document).ready(function(){ $(".owl-carousel").owlCarousel({
  items:3, 
  loop:true, margin: 20, center:true, dots: false,
  autoplay: true, autoplayTimeout: 1000,
  responsive: {  600:{items:4}, 900:{items:5}}
});});
</script>
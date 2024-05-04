---
post_id: 2178
title: 'Plugins GIMP'
date: '2014-04-20T17:43:19+02:00'
last_modified_at: '2022-01-11T20:05:15+01:00'
author: 'Rémi Peyronnet'
layout: page
guid: '/?p=2178'
slug: gimp_plugin
permalink: /gimp_plugin/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/gimp/gimp_plugin.php3'
image: /files/2017/10/gimp_1508001517.png
categories:
    - Général
tags:
    - OldWeb
lang: fr
lang-ref: pll_5bdde5f575ddc
lang-translations:
    fr: gimp_plugin
    en: gimp_plugin_en
toc: true
disable-comments: false
---

Deux plugins assez simples mais efficaces :

- Fourier : réalise une transformation de fourier pour pouvoir travailler dans l’espace de fourier (directe et inverse afin de pouvoir revenir à l’image initiale)
- YUV : conversion des images RGB en YUV


## Plugin Fourier

Un simple plugin pour faire une transformation de Fourier sur une image. L’avantage principal de ce plugin est qu’il donne la possibilité de travailler directement dans GIMP dans l’espace de Fourier, en utilisant toute la puissante des filtres, des capacités d’éditions,… et en revenant ensuite via une transformation inverse pour constater le résultat.

![source image](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image in fourier space](/files/old-web/ecp/tpi/rapport/f_log_tr.png){: .border-1fg }&nbsp;&rarr;&nbsp;![transformed image](/files/old-web/ecp/tpi/rapport/f_log_inv.png){: .border-1fg }
{: .center .font-xxxlarge}

&nbsp;  

### Téléchargement / Installation

Les dernières instructions et téléchargements pour Windows et Linux sont sur la [page GitHub](https://github.com/rpeyron/plugin-gimp-fourier)  

<details markdown="1"><summary>Anciennes versions</summary>
[Code source du Plugin (Linux et Win32)](/files/old-web/soft/gimp/fourier-0.4.3-2.tar.gz) (v 0.4.3, sous licence GPL)  
Binaires pour Windows (v 0.4.3) : [32bits](/files/fourier_gimp2.10.24-2_x32.zip) ou [64bits](/files/fourier_gimp2.10.24-2_x64.zip) testé OK pour GIMP 2.10.24. Vous pouvez également regarder les nouvelles versions sur la 
Votre distribution Linux peut avoir packagé ce plugin : [pour Fedora](https://apps.fedoraproject.org/packages/gimp-fourier-plugin)
Windows 0.4.3 pour GIMP 2.8 : [32bits](/files/old-web/soft/gimp/fourier-0.4.3-win32.zip) ou [64bits](/files/old-web/soft/gimp/fourier-0.4.3-win64.zip)  
Windows 0.4.3 pour GIMP 2.10 : aljacom version pour [GIMP 2.10](https://samjcreations.blogspot.com/2018/05/filtres-anciens-pour-gimp-210-64-bits.html)

[Source v0.3.3](/files/old-web/soft/gimp/fourier-0.3.3.tar.gz) ; [Win32 v0.3.0 ](/files/old-web/soft/gimp/fourier-0.3.0_bin_win32.zip) + [FFTW3](http://www.fftw.org) [DLL](/files/old-web/soft/gimp/fftw3_dll.zip).


&nbsp;  

Pour une utilisation sous Linux, suivez les étapes ci-dessous :

1. Installer les packages requis : `sudo apt-get install libfftw3-dev libgimp2.0-dev`
2. `tar xvzf fourier-0.4.*.tar.gz`
3. `cd fourier-0.4.*`
4. `make clean`
5. `make`
6. `make install`

Pour utiliser le plugin sous Windows, téléchargez le plugin (et pour des versions antérieurs à la v0.3.3, la DLL FFTW3) et copiez les dans le répertoire des plugins (.gimp-2.2plug-ins ou C:\\Program Files\\GIMP-2.2\\libgimp2.0\\plug-ins). 

La page GIMP Repository était <http://registry.gimp.org/node/19596>.

</details>

&nbsp;  

Pour savoir comment compiler ce plugin sous windows, consultez [l'article sur la compilation avec msys2 (en anglais)](/2021/06/compiling-gimp-plugins-for-windows-has-never-been-so-easy-with-msys2/)
<!-- allez à la [page GIMP DevPack]  (/2014/04/gimp_devpack_en/).-->

### Utilisation

Vous allez trouver les deux nouveaux éléments dans le menu :

- Filtres/Generique/Foward FFT
- Filtres/Generique/Inverse FFT

### Plus de documentation

Il n’y a pas encore beaucoup de documentation, mais le fonctionnement est assez simple. Les grands principes sont exposés [ici](/2002/02/fourier/). Attention, ce rapport n’est pas tout à fait à jour, notamment en ce qui concerne le “magic pixel” (remplacé par un GIMP parasite), et l’ordre des colonnes.

Merci à Mogens Kjaer et Alex Fernández pour leur contributions.

<details markdown="1"><summary>Historique</summary>Pour d'anciennes version (GIMP 1.3,...), consulter [l'ancienne page](/2002/02/tpi/)

```
 v0.1.1 : First release of this plugin
 v0.1.2 : BugFixes by Mogens Kjaer, May 5, 2002 
 v0.1.3 : Converted to Gimp 2.0 (dirty conversion)
 v0.2.0 : Many improvements from Mogens Kjaer, Mar 16, 2005
              * Moved to gimp-2.2
              * Handles RGB and grayscale images
              * Scale factors stored as parasite information
              * Columns are swapped
 v0.3.0 : Great Improvement from Alex Fernández with dynamic boosting :
              * Dynamic boosted normalization : 
                    fft/inverse loss of quality is now un-noticeable 
              * Removed the need of parasite information
 v0.3.1 : Zero initialize padding (patch provided by Rene Rebe)
 v0.3.2 : GPL distribution
 v0.4.0 : Patch by Edgar Bonet :
             * Reordered the data in a more natural way
             * No Fourier coefficient is lost
 v0.4.1 : Select Gray after transform + doc (patch by Martin Ramshaw)
 v0.4.2 : Makefile patch by Bob Barry (gcc argument order)
 v0.4.3 : Makefile patch by bluedxca93 (-lm argument for ubuntu 13.04)

```
</details>

&nbsp;  

## Plugin YUV

Ceci est un simple plugin pour “convertir” des images RGB en YUV. Cela signifie qu’après passage du plugin, la luminance (Y) va être stockée dans le canal rouge (R), et les chrominances (UV) dans les canaux verts et bleus (GB). En utilisant les fonctionnalités GIMP comme la décomposition ou l’outil canaux, il devient possible d’isoler et de travailler séparément en YUV.

![source image](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image in YUV space](/files/old-web/ecp/tpi/rapport/f_yuv.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image back in RGB](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }
{: .center .font-xxxlarge }

&nbsp;  

### Téléchargement / Installation

Les nouvelles releases et instructions sont sur la [page GitHub](https://github.com/rpeyron/plugin-gimp-yuv) 

[Code source du Plugin (Linux et Win32)](/files/old-web/soft/gimp/yuv-0.1.3.tar.gz) (v0.1.3)  
Binaires Windows : [32bits](/files/yuv_gimp2.10.24-2_x32.zip) or [64bits](/files/yuv_gimp2.10.24-2_x64.zip) for GIMP 2.10.24 *([v0.1.1 pour très vieux GIMP](/files/old-web/soft/gimp/yuv-0.1.1_bin_win32.zip))*.  

Pour utilisation sous Linux, suivez les étapes ci-dessous :

1. Installer les packages requis : `sudo apt-get install libgimp2.0-dev`
2. `tar xvzf yuv-0.1.3.tar.gz`
3. `cd yuv-0.1.3`
4. `make`
5. `make install`

Pour une utilisation sous Windows, copier le plugin dans le répertoire des plugins (`\.gimp-2.2\plug-ins` ou `C:\Program Files\GIMP-2.2\libgimp2.0\plug-ins`).

### Utilisation

Deux éléments sont ajoutés dans le menu :

- Image / Mode / RGB -&gt; YUV
- Image / Mode / YUV -&gt; RGB

### Documentation

Les principes de ce plugins sont développés dans [le rapport](/2002/02/yuv/).

Pour d’anciennes version (GIMP 1.3,…), consulter [l’ancienne page](/2002/02/tpi/)


---
post_id: 2179
title: 'GIMP Plugins'
date: '2014-04-20T17:44:41+02:00'
last_modified_at: '2022-01-11T20:04:47+01:00'
author: 'Rémi Peyronnet'
layout: page
guid: '/?p=2179'
slug: gimp_plugin_en
permalink: /gimp_plugin_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/gimp/gimp_plugin_en.php3'
image: /files/2017/10/gimp_1508001517.png
categories:
    - Général
tags:
    - OldWeb
lang: en
lang-ref: pll_5bdde5f575ddc
lang-translations:
    fr: gimp_plugin
    en: gimp_plugin_en
toc: true
disable-comments: false
---

Two simple plugins :

- Fourier : do direct and reverse fourier transform on your image
- YUV : convert RGB images to YUV

Select the plugin you want in the tabs below.

## Fourier Plugin

A simple plug-in to do fourier transform on you image. The major advantage of this plugin is to be able to work with the transformed image inside GIMP. You can so draw or apply filters in fourier space, and get the modified image with an inverse FFT.

![source image](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image in fourier space](/files/old-web/ecp/tpi/rapport/f_log_tr.png){: .border-1fg }&nbsp;&rarr;&nbsp;![transformed image](/files/old-web/ecp/tpi/rapport/f_log_inv.png){: .border-1fg }
{: .center .font-xxxlarge}

&nbsp;  

### Download

New builds and instructions are available on the [GitHub page](https://github.com/rpeyron/plugin-gimp-fourier)

<details markdown="1"><summary>Older versions</summary>
[Plugin source code (Linux and Win32)](/files/old-web/soft/gimp/fourier-0.4.3.tar.gz) (v0.4.3, under GPL license)  
Binaries for Windows (v0.4.3) : [32bits](/files/fourier_gimp2.10.24-2_x32.zip) or [64bits](/files/fourier_gimp2.10.24-2_x64.zip) tested OK for GIMP 2.10.24. 
Your Linux distribution may have packaged it : [for Fedora](https://apps.fedoraproject.org/packages/gimp-fourier-plugin)

Windows 0.4.3 for GIMP 2.8 : [32bits](/files/old-web/soft/gimp/fourier-0.4.3-win32.zip) or [64bits](/files/old-web/soft/gimp/fourier-0.4.3-win64.zip)  
Windows 0.4.3 for GIMP 2.10 : aljacom version for [GIMP 2.10](https://samjcreations.blogspot.com/2018/05/filtres-anciens-pour-gimp-210-64-bits.html)

[Source v0.3.3](/files/old-web/soft/gimp/fourier-0.3.3.tar.gz) ; [Win32 Binaries v0.3.0 ](/files/old-web/soft/gimp/fourier-0.3.0_bin_win32.zip) + [FFTW3](http://www.fftw.org) [DLL](/files/old-web/soft/gimp/fftw3_dll.zip).

### Installation

For use under Linux, follow the usual steps :

1. Install the required libraries : `sudo apt-get install libfftw3-dev libgimp2.0-dev`
2. `tar xvzf fourier-0.4.*.tar.gz`
3. `cd fourier-0.4.*`
4. `make clean`
5. `make`
6. `make install`


GIMP Registry Page was <http://registry.gimp.org/node/19596>.

</details>

&nbsp;  

For use under Windows, get the binary plugin (and the FFTW3 DLL with versions before 3.2), and copy them to the plugins directory (.gimp-2.2plug-ins or C:Program FilesGIMP-2.2libgimp2.0plug-ins). 

To know how to compile under win32, please read  [this post to compile GIMP plugins with msys](/2021/06/compiling-gimp-plugins-for-windows-has-never-been-so-easy-with-msys2/) 
<!-- go to the [GIMP DevPack page]  (/2014/04/gimp_devpack_en/) (old, please check GitHub) -->

### Use

You will find two more items in the menu :

- Filters/Generic/Foward FFT
- Filters/Generic/Inverse FFT

### More documentation

There is not much documentation for now, but use should be very straight forward. As this plugin was developped for educationnal purpose, documentation about principles used is available in the [french report](/2002/02/fourier/). Note this report is not up to date : the “magic pixel” was replaced by a GIMP parasite, and column order has changed.

Special Thanks to Mogens Kjaer and Alex Fernández for their patches.

<details markdown="1"><summary>History</summary>For older versions, you can go to the [old page](/2002/02/tpi/).

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


## YUV GIMP Plugin

A simple plug-in to convert RGB images to YUV in GIMP. This means that after having applied the filter, you will get luminance (Y) in the red channel (R), and chrominances in green and blue channel. By using the decompose plugin, or the channel dialog, you will be able to work in YUV space, and be back in RGB space by the reverse plugin. In fact, combined to the fourier plugin, you should be able to demonstratete a simple JPEG compression on the whole image.

![source image](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image in YUV space](/files/old-web/ecp/tpi/rapport/f_yuv.png){: .border-1fg }&nbsp;&rarr;&nbsp;![image back in RGB](/files/old-web/ecp/tpi/rapport/f_src.png){: .border-1fg }
{: .center .font-xxxlarge }

### Download / Installation

Latest builds and instructions are available on the [GitHub page](https://github.com/rpeyron/plugin-gimp-yuv)

[Plugin source code (Linux and Win32)](/files/old-web/soft/gimp/yuv-0.1.3.tar.gz) (v0.1.3)  
Binaries for Windows: [32bits](/files/yuv_gimp2.10.24-2_x32.zip) or [64bits](/files/yuv_gimp2.10.24-2_x64.zip) for GIMP 2.10.24 *([v0.1.1 for very old GIMP](/files/old-web/soft/gimp/yuv-0.1.1_bin_win32.zip))*.  


For use under Linux, follow the usual steps :

- Install the required libraries : `sudo apt-get install libgimp2.0-dev`
- `tar xvzf yuv-0.1.3.tar.gz`
- `cd yuv-0.1.3`
- `make`
- `make install`

For use under Windows, get the binary plugin and copy it to the plugins directory (`\.gimp-2.2\plug-ins` or `C:\Program Files\GIMP-2.2\libgimp2.0\plug-ins`). To know how to compile under win32, please read  [this post to compile GIMP plugins with msys](/2021/06/compiling-gimp-plugins-for-windows-has-never-been-so-easy-with-msys2/) 
<!-- go to the [GIMP DevPack page]  (/2014/04/gimp_devpack_en/) (old, please check GitHub) -->

### Use

You will find two more items in the menu :

- Image / Mode / RGB -&gt; YUV
- Image / Mode / YUV -&gt; RGB

### More documentation

There is not much documentation for now, but use should be very straight forward. As this plugin was developped for educationnal purpose, documentation about principles used is available in the [french report](/2002/02/yuv/).

For older versions, you can go to the [old page](/2002/02/tpi/).


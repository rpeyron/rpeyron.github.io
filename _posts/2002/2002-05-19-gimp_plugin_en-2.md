---
post_id: 2105
title: 'GIMP Plugins (Old)'
date: '2002-05-19T17:05:55+02:00'
last_modified_at: '2019-08-06T19:26:09+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2105'
slug: gimp_plugin_en-2
permalink: /2002/05/gimp_plugin_en-2/
URL_before_HTML_Import: 'http://www.lprp.fr/ecp/tpi/gimp_plugin_en.php3'
image: /files/2017/10/gimp_1508001517.png
categories:
    - Informatique
tags:
    - GIMP
    - OldWeb
    - Plugin
lang: en
---

**Updated versions of the plugins available on [the new page](/gimp_plugin_en/).**

For more information, please see the french page of [yuv](/2002/02/yuv/) or [fourier](/2002/02/fourier/) plugins.

## What are these plugins

- yuv : a simple plugin to convert images to and from yuv in GIMP
- fourier : a plugin that does a FFT of an image 
    - The advantage of this plug-in over the other FFT plug-ins available is that it lets you work with the transformed image inside Gimp.
    - It can be used to remove moiré patterns (see README.Moire).

## Download section

You can download GIMP at <http://www.gimp.org>.

- [Binairies for Win32, with all the DLLs](/files/old-web/ecp/tpi/plug-ins_w32.zip)
- [Release 0.1.1 of the fourier plugins, with edge detection and a simulation in 16bits. The two latter are not supported any more.](/files/old-web/ecp/tpi/fourier.zip)
- [Release 0.1.2 of the fourier plugin](/files/old-web/ecp/tpi/fourier0.1.2.zip) *(this is a zip file, but it compiles too on linux. I guess that more linux users know the unzip command than windows users the tar command 🙂*
- [Release 0.1.3 of fourier plugin, for GIMP 2.0](/files/old-web/ecp/tpi/fourier-0.1.3.tar.gz)
- [Source files for YUV plugins.](/files/old-web/ecp/tpi/yuv.zip)
- [Some documentation (currently only in french)](/2002/02/tpi/)

## How to use

On Windows, simply copy the binaries in the plugin directory of GIMP.

On GNU/Linux, download the source files, and type make; make install. You will need the development packages gimp-dev, glib-dev, gtk+-dev and fftw-dev.

## Warnings

- These plugins have not been fully tested, and these is certainly dozen of bugs. [Mogens Kjaer &lt;mk@crc.dk&gt;](mailto://mk@crc.dk) have corrected some (see his original version on <ftp://ftp.crc.dk/pub/gpplugin>). May 5, 2002
- The FFT plugin use a special pixel to store data to be able to make te reverse FFT. If this pixel is altered (can be often when using filters) the reverse FFT will give a blank or black image… I am open to any suggestion to improve this.
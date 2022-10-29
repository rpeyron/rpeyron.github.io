---
post_id: 2177
title: 'Gimp Plugin Development environments'
date: '2005-02-09T17:41:13+01:00'
last_modified_at: '2018-12-01T20:31:00+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2177'
slug: gimp_devpack_en
permalink: /2005/02/gimp_devpack_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/gimp/gimp_devpack_en.php3'
image: /files/2018/11/configuration_1541191865.jpg
categories:
    - Informatique
tags:
    - GIMP
    - OldWeb
    - Plugin
    - Prog
lang: en
---

Aljacom has created great development environments for Gimp 2.8 32bits and 64bits. Follow instructions on <http://www.aljacom.com/~gimp/divers.html>

# Outdated – Setting a GIMP Plugin development environment.

For now, creating a sane environment for GIMP Plugin development under windows is quite a pain. Here are some methods I tried. I strongly encourage you to use one of the two methods, as it seems to me they are the easier and lighter. The goal of this page is to set a working environment in order to create and compile plugins for win32. It depends on a full build of GIMP, as <http://gimp-win.sourceforge.net/> does brillantly, and is not intended to setting an environment to perform such a build.

[MSVC – Using the LIB tool](#libtool) : download [gimp-dev-2.2.1.zip](/files/old-web/soft/gimp/gimp-dev-2.2.1.zip) and at least glib2.0 and gtk2 win32 distribution [on Tor Lillqvist’s page.](http://www.gimp.org/~tml/gimp/win32/).

[Cygwin / Mingw32 – Using dlltool](#dll) : download [gimp-dev-mingw-2.2.1.zip](/files/old-web/soft/gimp/gimp-dev-mingw-2.2.1.zip) or [gimp-dev-mingw-2.2.1.DevPak](/files/old-web/dist/devpacks/gimp-dev-mingw-2.2.1.devpak) and GLib2 and GTK2 DevPacks (available in the Packet Manager)  
[Cygwin – Compiling from scratch, or using pre-built librairies](#cygwin)  
[MSVC – Compiling from scratch](#msvc_full)  
[Credits](#credits)

<a name="libtool"></a>

## MSVC – Using the Lib tool.

This method sticks exaclty to our needs : we want the import libraries (.lib) and headers that we can use with the win32 GIMP distribution found on <http://gimp-win.sourceforge.net/>, but we do **not** need to compile a regular DLL file on our environment : some smarter guys did it very well for us, and that will considerably simplify our job.

The Microsoft `lib` tool provided with MS Visual Studio, is able to generate import libraries from library definition files (.def), as explained in [Q131313](http://support.microsoft.com/kb/q131313/). And these .def files are included in the gimp source distribution. So we just have to :

- Run `lib /machine:i386 /def:<input def filename>.def /name:>wanted DLL name in gimp-win.sf.net distibution>.dll /out:<output lib filename>.lib` (ex : lib /machine:i386 /def:gimp.def /name:libgimp-2.0-0.dll /out:libgimp-2.0.lib). [Here](/files/old-web/soft/gimp/gimp-libs.bat) is a simple batch file to do that.
- 
- Copy the headers in your include folder (lib\*/\*.h)
- 
- Install glib2.0 and gtk2 development packages (easily found [on Tor Lillqvist’s page.](http://www.gimp.org/~tml/gimp/win32/))
- 

And that’s all for building GIMP plugins ! This a very simple method to have a development package. I made it for GIMP 2.2.1 : download [gimp-dev-2.2.1.zip](/files/old-web/soft/gimp/gimp-dev-2.2.1.zip)

<a name="dlltool"></a>

## Cygwin/Mingw32 – Using dlltool.

The same principles used above may be used for cygwin / mingw32. I have not tested it yet, but the following steps should work :

- `dlltool --input-def <input def filename>.def   --dllname >wanted DLL name in gimp-win.sf.net distibution>.DLL --output-lib <output lib filename>.a -k`
- 
- `cp <output lib filename>.a /usr/local/lib` (or in any another place you want)
- 
- `ranlib /usr/local/lib/<output lib filename>.a`
- 

It works quite well. You can get it, as a zip ([gimp-dev-mingw-2.2.1.zip](/files/old-web/soft/gimp/gimp-dev-mingw-2.2.1.zip) ) or as a DevPak [gimp-dev-mingw-2.2.1.DevPak](/files/old-web/dist/devpacks/gimp-dev-mingw-2.2.1.devpak) for [DevCPP](http://www.bloodshed.net/devcpp.html)

<a name="cygwin"></a>

## Cygwin – Compiling from scratch, or using pre-built librairies

[Matthew H. Plough](http://www.princeton.edu/~mplough/plugins.html) has a set of pre-built librairies. That worked pretty well with no effort and no cygwin dependancies, but gimptool-2.0.exe crashed, and I found the resulting environment a bit unclean. The crash of gimptool-2.0 is quite easy to fix (just replace in gimptool-win32.c line 143 ` r = strrchr (path, G_DIR_SEPARATOR);)` by `if (path == NULL) return ""; else  r = strrchr (path, G_DIR_SEPARATOR);)`. But I tried to build a minimalistic sane cygwin environment, with the use of the provided packages.

Here are the steps I followed :

- Install [Cygwin](http://www.cygwin.com), with the following packages : atk-devel, freetype2, gettext-devel, glib2-devel, gtk2-x11-devel, intltool, jpeg, libart\_lgpl, libtool-devel, pango-devel, pkgconfig, tiff, libpng12-devel, libtiff-devel, libjpeg-devel, XFree86-lib-compat (I probably missed some, [see my installed.db](/files/old-web/soft/gimp/cygwin-installed.db) for complete list)
- Install [XML::Parser Perl module](http://search.cpan.org/~msergeant/XML-Parser/)
- Unzip gimp source code ; note that you should have no space in your directory name, it causes problems.
- Launch `./configure --disable-print`
- If `/etc/gtk-2.0/gdk-pixbuf.loaders` is missing, update it with `gdk-pixbuf-query-loaders.exe  >  /etc/gtk-2.0/gdk-pixbuf.loaders`
- Remove from SUBDIRS variable of the main generated Makefile “tools”, and everythind starting from “app” to the end. As we are only interested in libgimp\* librairies, the rest is not useful.
- `make`
    - If it fails on a libgimp non valid libtool library, just restart make (about 2-3 times), it should pass
    - If it fails with libXrender.la not found, bad luck, that’s a cygwin package hasard, try to remove `-lpangoxft-1.0` from the corresponding Makefile.
- `make install` ! 
    - If you encounter problems with libtool complaining, replace in libgimp/Makefile the line 376 `no_undefined = -no-undefined` by `no_undefined = #-no-undefined`
- You should now get working librairies. To produce cygwin-independant executables, use `-mno-cygwin` (I got some cygwin problems with gcc-mingw and libXrender, so I have not tested that for now)

Note : the gimptool-2.0 installed is the normal shell script, and works quite well to compile plugins (everything is ok, except –install)

This was better than MSVC, but it did not satisfied me a lot, because I did not manage to compile fftw in a shared library (a lib I use in my fourier plugin), and so the resulting executable was very huge (more than 1 Mo, compared to ~20ko… with external fftw dll)

<a name="msvc_full"></a>

## MSVC – Compiling from scratch

If you have many hours to waste, this one is made for you. You will have to download all librairies from [Tor Lillqvist (tml) page](http://www.gimp.org/~tml/gimp/win32/), run nmake -f makefile.msc, and pray. You will have to patch some files, but it should compile the lib\*. But, in my case, I finally got gimp-2.0.lib and gimp-2.0-0.dll, without the prefix *lib*. So it was incompatible with libgimp-2.0-0.dll distributed by <http://gimp-win.sourceforge.net/>… I guess it is not too difficult to change the name of the library, but this method did not seem good to me.

<a name="credits"></a>

## Credits

I wish to thank all the people that helped me :

- Tor Lillqvist (tml) and [his pre-built win32 packages ](http://www.gimp.org/~tml/gimp/win32/) of the librairies user by GIMP.
- Matthew H. Plough for [his plugin page](http://www.princeton.edu/~mplough/plugins.html) and the pre-built librairies for Cygwin he kindly made available for me.
- The Q131313 entry of MSDN, for [the lib method](http://support.microsoft.com/kb/q131313/)
- And the [equivalent for libtool](http://www.emmestech.com/software/cygwin/pexports-0.43/moron1.html)
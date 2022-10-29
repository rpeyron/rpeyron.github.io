---
post_id: 2117
title: 'Infra-Red Sensor'
date: '2004-11-02T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2117'
slug: recepteurinfrarouge_en
permalink: /2004/11/recepteurinfrarouge_en/
URL_before_HTML_Import: 'http://www.lprp.fr/elec/ir/recepteurinfrarouge_en.php3'
image: /files/2018/11/infrared_1541191638.jpg
categories:
    - Informatique
tags:
    - Elec
    - OldWeb
lang: en
lang-ref: pll_5bdcb7e9a5620
lang-translations:
    en: recepteurinfrarouge_en
    fr: recepteurinfrarouge
---


## Hardware part

Different circuits are available. The easiest is maybe to take an infrared sensor and to connect it on the serial port, with just a resistor between RX and the ground. This works very well for me.

```
C (10uF)
GND o-------------+-----------+----+
                  |           |    |    +-------------------------+
              ---GND---     -----  |    |      SIEMENS 444        |
     1N4148 +-+IN  OUT+-+   -----  +----+ -    SFH 506-36         |
      | |  |  78L05 / |     |         |      ______________     |
RTS o-| >|--+  -------  +---------------+ +                      |
      |/ |  |                           |                     )   |
           | |                          |      ______________/    |
           | | R2 (10K)            +----+ 
Nota : I have used an old sensor different from the SIEMENS.
```

Pin numbers indicated are for SUB-D9. See this table for SUB-D25.

```
Name         SUB-D25        SUB-D9      Used for

RTS            4               7        Power source
GND            7               5        Ground
DCD            8               1        Signal

```

Common replacements :

This one is probably the best, it works merely always.

```
C (10uF)
GND o-------------+-----------+----+
                  |           |    |    +-------------------------+
              ---GND---     -----  |    |      SIEMENS 444        |
     1N4148 +-+IN  OUT+-+   -----  +----+ -    SFH 506-36         |
      | |  |  78L05 / |     |         |      ______________     |
RTS o-| >|--+  -------  +---------------+ +                      |
      |/ |  |                           |                     )   |
           | |                          |      ______________/    |
           | | R2 (10K)            +----+
```

```
GND o-----------------------+------+
                            |      |    +-------------------------+
                 C (10uF) -----    |    |      SIEMENS 444        |
 e.g. 1N4148  R1 (5K)     -----    +----+ -    SFH 506-36         |
      | |      _____    +  |           |      ______________     |
RTS o-| >|-----|_____|------------------+ +                      |
      |/ |  |                           |                     )   |
           | |                          |      ______________/    |
           | | R2 (10K)            +----+ 


```

A 78L05 regulator has the following pins :

```
   1 2 3
  _______
 /             Pin1 = OUT
(  o o o  )     Pin2 = GND
        /      Pin3 = IN
   -___-

```



## Software part

The sensor makes the most of the decoding process, by demodulating the ir signal..

Many IR protocols exist, like RC5, RCA,… , and that make the decoding not an easy task.  
Here are some useful links :

- [RCA code request form](http://www.parkwon.com/rcatest/form.htm)
- [Universal Remote Control Codes](http://www.xdiv.com/remotes/)
- [An analysis of IR signals used by a remote control](http://cgl.bu.edu/GC/shammi/ir/)
- [A Serial Infrared Remote Controller](http://www.armory.com/~spcecdt/remote/remote.html)
- [IR Remote System](http://web2.airmail.net/jsevinsk/ha/ir.html)
- [Systems Internals](http://www.sysinternals.com/)
- [Quelques infos sur les télécommandes IR](http://www.supelec-rennes.fr/ren/perso/jweiss/remote/remote.htm)
- [Universal Infrared Receiver](http://www.geocities.com/SiliconValley/Sector/3863/uir/index.html)

I have summarised information about decoding protocols stored in these documents in [this file](/files/old-web/elec/ir/irremote.txt).

Here is an example of codes : [TV Philips](/files/old-web/elec/ir/philips_tv.cfg).



## Windows configuration

Under windows, an excellent program is [WinLIRC](http://home.jtan.com/~jim/winlirc/). This software decodes data of the serial port, according to a configuration file, and puts the result on a TCP/IP port. This is based on LIRC, that we will see later.

The configuration is very easy : you just have to enter the name of the configuration file and which serial port is it. If you do not have the configuration file, you can record it by pushing the keys one after the other.

Once launched, WinLIRC stays in the TrayBar and send data to the TCP/IP port. Yellow means configuration, green a good code, and red a bad code.

You can find a version of WinLirc [here](/files/old-web/elec/ir/winlirc-0.6.zip). The latest version will be found on [the WinLIRC home page](http://home.jtan.com/~jim/winlirc/).

The use of these data is done program by program. A plugin has been developed for WinAmp. You can find it on the WinLirc home page or [here](/files/old-web/elec/ir/gen_ir-0.2.zip).  
The configuration is very easy :

- Ensure WinLIRC is working properly.
- Copy gen\_ir.dll in the plugin directory of winamp.
- Configure this plugin (tab General Purpose), with matching names of the keys with actions to do.
- Activate the plugin

The problem is that a plugin is required for each application. [Girder](http://www.girder.nl) is a wonderul freeware that allows to send keys to windows or to move the mouse, … a must !

I am developping a program capable of sending a keystoke or a message to a window by the remote controller. But nothing relevant has been done yet and I will not have many time to continue.



## Linux configuration

Under Linux, you have the possibility to do approximatively everything you want with your remote controller, from controlling an application to emulating a mouse. All this is possible owing to this software : [LIRC](http://www.lirc.org) (Linux Infra Red Control). A version is available [here](/files/old-web/elec/ir/lirc-0.6.2.tar.gz).

This program set up a module allowing decoding the IR signals, and putting the results in a device (/dev/lircd). LIRC has several parts :

- **lircd** : the daemon, converting the IR signals.
- **irexec** : to launch a command when a key has been pressed.
- **irrecord** : to record yourself the codes of your remote.
- **irw** : to see the key pressed.

### Lircd configuration

- First you have to compile LIRC, what is very easy typing ./configure, selecting the correct serial port number, then typing `make` and `make install` (with root rigths).
- Then you have to load the module if is not automaticaly made : `modprobe lirc_serial`.
- You have then to record a configuration file with irrecord, except if you had it already : you can find some on the homepage of [LIRC](http://www.lirc.org).
- Launch the daemon `lircd`
- Check your configuration with `irw` and pressing a key of your remote controller. The name of the key should print. If not, check /var/log/lircd.

### Irexec configuration

You can now configure irexec. The documentation of LIRC is brief and well doneto create the file **lircrc**. You can also adapt [my configuration file](/files/old-web/elec/ir/lircrc).

### Xmms configuration

A plugin is available for Xmms. You can find the latest on the software page of [LIRC](http://www.lirc.org) or a version [here](/files/old-web/elec/ir/lirc-xmms-plugin-1.1.tar.gz).

You have then to compile it and install it. The installation process have sometimes problems with shared libraries. A solution is to copy this file : `cp /usr/local/lib/liblirc_client.so.0.0.0 /usr/lib/liblirc_client.so.0.0.0`  
Then launch xmms from a terminal in order to see any problem. Do not forget to activate the plugin.

This plugin is used through the lircrc configuration file. You will need irexec to be running to use this plugin. Just see in [my configuration file](/files/old-web/elec/ir/lircrc) what to add in it to make this plugin work properly.

That’s it ! You can now enjoy your IR remote.
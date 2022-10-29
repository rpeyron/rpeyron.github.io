---
post_id: 1408
title: 'iPhone icon with The Gimp'
date: '2009-08-02T00:18:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2009/08/scriptfu-iphoneicon/'
slug: scriptfu-iphoneicon
permalink: /2009/08/scriptfu-iphoneicon/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1747";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/gimp_1508001517.png
categories:
    - Informatique
tags:
    - Blog
lang: en
---

This is a script-fu for The Gimp that will help you to create icons with iPhone style. Install it in the .gimp/scripts directory of your profile, and reload The Gimp. Then run it in `File / Create / Buttons / Simple iPhone icon…`.

This script-fu was created with the instructions on [http://userlogos.org/node/6888](http://userlogos.org/node/6888 "http://userlogos.org/node/6888"). Here is a sample output :

![](/files/2009/08/iphoneicon_sample-1.png)![](/files/2009/08/iphone-iconfu.png)

Download this script : [iphone-fu](/files/2009/08/iphone-fu.zip) ; or use the code below.

```scheme
(define (script-fu-iphone top-color bottom-color tg-webclip)
  (let* (
        (img-width 125)
        (img-height 125)
        (img (car (gimp-image-new img-width img-height RGB)))
        (drawable (car (gimp-layer-new img img-width img-height RGB "Round Rectangle" 100 NORMAL-MODE)))
        (drawable_ellipse (car (gimp-layer-new img img-width img-height RGB "Blank Ellipse" 20 NORMAL-MODE)))

        )

    (gimp-layer-add-alpha drawable)
    (gimp-layer-add-alpha drawable_ellipse)

    (gimp-context-push)
    (gimp-image-undo-disable img)

    ; Begin

    (gimp-image-add-layer img drawable 0)
    (gimp-edit-clear drawable)

    (gimp-round-rect-select img 15 15 95 95 20 20 0 FALSE FALSE 0 0)

    (gimp-context-set-foreground bottom-color)
    (gimp-context-set-background top-color)
    (gimp-edit-blend drawable 0 0 0 100 0 0 FALSE FALSE 5 5 FALSE 75 100 75 25)
    (script-fu-drop-shadow img drawable 0 4 5 '(0 0 0) 40 1)

    (gimp-selection-all img)
    (gimp-edit-copy drawable)
    (gimp-image-add-layer img drawable_ellipse 0)
    (gimp-edit-clear drawable_ellipse)
    (gimp-floating-sel-anchor (car (gimp-edit-paste drawable_ellipse FALSE)))

    (gimp-ellipse-select img 0 0 125 67 0 TRUE FALSE 0)
    (gimp-round-rect-select img 15 15 95 95 20 20 3 FALSE FALSE 0 0)
    (gimp-context-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill-full drawable_ellipse 0 0 100 255 FALSE TRUE 0 0 0)

    (gimp-image-merge-visible-layers img 0)

    ; Create new image for web stuff
    (if (= tg-webclip TRUE)
      (begin
        (gimp-image-crop img 95 95 15 15)
        (gimp-image-scale img 59 59)
      )
    )

    ; Done

    (gimp-selection-none img)
    (gimp-image-undo-enable img)
    (gimp-context-pop)

    (gimp-display-new img)
  )
)

(script-fu-register "script-fu-iphone"
  _"Simple iPhone icon..."
  _"Create a simple iPhone icon"
  "Remi Peyronnet"
  "Remi Peyronnet"
  "August 2009"
  ""
  SF-COLOR      _"Top color"   '(0 255 127)
  SF-COLOR      _"Bottom color"  '(0 127 255)
  SF-TOGGLE     _"Finalize for WebClips"                   FALSE
)

(script-fu-menu-register "script-fu-iphone" "<Image>/File/Create/Buttons")
```

# WebClip iPhone icon

To create a webclip icon, you do not need to use the above method. Just provide a “raw” image, and the iPhone will provide a mask to give the iPhone look. See sample below.

The image ![](/files/2009/08/iphoneicon.png) will become ![](/files/2009/08/iphoneicon_byiphone.png)

To include one in your own webpage, use the code below in your `head` section. The image should be a 59×59 pixels png file.

```
<a href="http://december.com/html/4/element/link.html">link</a> rel="apple-touch-icon" href="/customicon.png"/>
```
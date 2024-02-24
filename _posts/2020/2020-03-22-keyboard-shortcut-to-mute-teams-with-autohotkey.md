---
post_id: 4267
title: 'Keyboard shortcut to mute Teams with AutoHotKey'
date: '2020-03-22T22:31:26+01:00'
last_modified_at: '2024-02-24T15:24:50+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4267'
slug: keyboard-shortcut-to-mute-teams-with-autohotkey
permalink: /2020/03/keyboard-shortcut-to-mute-teams-with-autohotkey/
image: /files/2020/03/shh_1585593668.png
categories:
    - Informatique
tags:
    - autohotkey
    - mute
    - teams
lang: en
---

**Edit (16/01/2021):** I have found a small utility that does exactly what I needed: [MicMute](https://sourceforge.net/projects/micmute/). It is a simple keyboard hook that will mute/unmute the mic, with a method that is compatible with Microsoft Teams. You still must be careful when using it because you cannot mix the use of MicMute and the mute button of Teams, and be careful to let both in sync (be careful especially to Teams auto-mute function when entering a room with more than 5 people). If any problem, check the level of your microphone in the microphone device options; it may have been altered. Even it is a little off-topic of this post, I think this can be useful, and as the source code is available, the mute method could be converted to AutoHotKey.

**Edit (14/12/2020):** Randy has shared in the comments a version working with Teams version 1.3.00.30866 ([direct link](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=84286&p=369546#p369546))

With the confinement because of COVID-19, I have been using Microsoft Teams for my work with my home setup that does not have a “mute” button to mute the mic of Microsoft Teams. And that’s is very annoying as Microsoft had the very odd idea to set the mute keyboard shortcut to “Ctrl+Maj+M”, which is not handy at all to operate! And it is not possible to change it.

Here is an [AutoHotKey](https://www.autohotkey.com/) script to replace it by the hotkey **Left Control + Left Alt** (please note the Left Control key must be pressed before Left Alt). This version works for Teams without the new feature with meeting windows detached from the main window (see at the end).

```
LControl & LAlt::
#HotkeyInterval 200
WinGet, active_id, ID, A
WinActivate, ahk_exe Teams.exe
Send ^+m
WinActivate, ahk_id %active_id%
SoundBeep, 200, 100
return
```

You may also download the compiled version: [mute-teams.zip](/files/2020/03/mute-teams.zip)

This tool is great, very simple to use, even it is surprising at first: you write a script ahk with AutoHotKey syntax and execute it with one of the provided binaries. The script will remain visible in the tray bar so it can be stopped. You can also compile the script with the provided compiler, and get a standalone executable you can distribute without any annoying dependencies. And there is a ton of much more advanced features that I used to create GUIs, tray bar menu, etc.

I have struggled a while with the use of `ControlSend `that should be able to send keys to a window without the need to be focused, but it worked sometimes… or not… That is why this version activates shortly the target window and revert to the one you were using. A discreet beep indicates the hotkey has been fired.

Do not miss [SciTE4AutoHotKey](http://fincs.ahk4.net/scite4ahk/): in addition to syntax highlighting it will provide a quite efficient debugging environment.

The new Teams feature that open distinct windows for each call/conversation breaks this script, and there is no simple way to identify the right window to mute. As a workaround, below is a script that will loop each Teams window, and focus and send Ctrl+Shit+M to each :

```
#UseHook
LControl & LAlt::
;#HotkeyInterval 200

WinGet, active_id, ID, A
SetTitleMatchMode, 2
;DetectHiddenWindows, On
WinGet, fensterID, List, ahk_exe Teams.exe
Loop, %fensterID% { ; will run loop for number of windows in array
  WinActivate, % "ahk_id " fensterID%A_Index%
  Send ^+m
}
SoundBeep, 200, 100
WinActivate, ahk_id %active_id%
Return

; Loop adapted from: https://autohotkey.com/board/topic/29871-cycling-through-all-windows-that-match-wintitle/
```

If you use Teams to have multiple calls simultaneously the script above might not behave as you like:
- Ben S. has provided in the comments below the article [another version based on the window size](https://github.com/rpeyron/rpeyron.github.io/discussions/16#discussioncomment-4007775) that may better suit you.
- tdalon shared a [AHK script to get Teams Meeting window](https://tdalon.blogspot.com/2022/07/ahk-get-teams-meeting-win.html) that can be included in the above script

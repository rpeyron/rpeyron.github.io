---
post_id: 4472
title: 'Force a command without UAC elevation in PowerShell'
date: '2020-09-05T15:46:06+02:00'
last_modified_at: '2021-06-12T19:30:16+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=4472'
slug: force-a-command-without-uac-elevation-in-powershell
permalink: /2020/09/force-a-command-without-uac-elevation-in-powershell/
image: /files/2020/09/PowerShell_5.0_icon.png
categories:
    - Informatique
tags:
    - darktable
    - powershell
    - scoop
    - uac
lang: en
---

The version of Darktable in the scoop extras bucket was very old, because of the new exe file distribution. I wanted to improve that. One of the biggest problem was to get rid of the UAC elevation asked by the NSIS installation script, which was quite useless with the use of another folder than the default one.

A google search gives as a result that you can force no UAC elevation with RunAsInvoker. Under cmd.exe it would be :

```
set __COMPAT_LAYER=RUNASINVOKER && start .\darktable-3.2.1-win64.exe /S /D=D:\Temp\dark
```

As scoop run in PowerShell, here is the PowerShell version :

```
$Env:__COMPAT_LAYER='RunAsInvoker'; .\darktable-3.2.1-win64.exe /S /D=D:\Temp
```

In the scoop script, another difficulty is to get the proper variable substitution. To do so, you will need to use Invoke-Expression :

```
Invoke-Expression "$dir\\$fname /S /D=$dir"
```

Doing so it won’t wait for the installation to be done. A simple way to wait for completion is to add a pipe to Out-Null. Indeed, with a pipe, it will force PowerShell to wait the end of the first process! So the final string, with proper quote escaping is :

```
"$Env:__COMPAT_LAYER='RunAsInvoker'; Invoke-Expression \"$dir\\$fname /S /D=$dir | Out-Null \""
```

References :

- RunAsInvoker : <https://stackoverflow.com/questions/37878185/what-does-compat-layer-actually-do>
- Out-Null : <https://stackoverflow.com/questions/7908000/run-an-application-with-powershell-and-wait-until-it-is-finished/7908022#7908022>
- Pull request to Scoop extras bucket : <https://github.com/lukesampson/scoop-extras/pull/4707>
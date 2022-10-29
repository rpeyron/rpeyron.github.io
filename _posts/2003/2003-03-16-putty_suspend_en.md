---
post_id: 2195
title: 'PuTTY Suspend Patch'
date: '2003-03-16T19:33:22+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2195'
slug: putty_suspend_en
permalink: /2003/03/putty_suspend_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/misc/putty_suspend/putty_suspend_en.php3'
image: /files/2018/11/patch_1541532449.jpg
categories:
    - Informatique
tags:
    - OldWeb
    - Patch
lang: en
---

I use PuTTY with screen, and I also use the hibernate function of Windows. The problem is that connections timeout, and I have after each resume to close/reopen/resize all of my PuTTY windows.

This patch is a very quick workaround. It handles the Windows Power Message (WM\_POWERBROADCAST), and when resuming it duplicates the current session and terminates the old one (waiting for ‘reuse-windows’ item, see below). The attached file contains the piece of code to be inserted somewhere in main select of the WndProc.

[PuTTY 0.58 with this patch. (Unofficial)](/files/old-web/soft/misc/putty_suspend/putty.exe)  
[Patch against 0.58 *(to be inserted in window.c / WndProc)*](/files/old-web/soft/misc/putty_suspend/putty_suspend.patch)  
[Source Code including this patch.](/files/old-web/soft/misc/putty_suspend/putty_suspend.zip)

### Patch Code (to be inserted in window.c / WndProc)

```c
/** 
 * Reset the connection when suspending, and try to re-establish it when resuming.
 * This is designed to be used with screen (SSH Remote Command : 'screen -r || zsh || bash')
 *
 * Windows broadcasts these messages 
 * * when pushing the suspend button :
 *  - PBT_APMQUERYSUSPEND : Query if suspend is allowed => We do not do anything.
 *  - PBT_APMSUSPEND      : Tell the program Windows is suspending => Close the connection.
 * * when resuming :
 *  - PBT_APMRESUMESUSPEND : Tell the program Windows is resuming from suspend mode => Re-open the connection.
 *  - PBT_APMRESUMEAUTOMATICALLE : Tell the program that Windows has resumed from something. => Do nothing.
 */
case WM_POWERBROADCAST:
      switch(wParam)
      {
            case PBT_APMSUSPEND:
            {
                    logevent(NULL, "APM Suspend.");
                    break;
        }
            case PBT_APMRESUMESUSPEND:
            {
                    logevent(NULL, "APM Resume.");
                    // Restart the session
                    PostMessage(hwnd, WM_COMMAND, (WPARAM)IDM_RESTART, (LPARAM)NULL);
                    break;
            }
            default: break;
      }
      return TRUE;

```

## What? – Version 0.53a

This patch is a very quick workaround. It handles the Windows Power Message (WM\_POWERBROADCAST), and when resuming it duplicates the current session and terminates the old one (waiting for ‘reuse-windows’ item, see below). The attached file contains the piece of code to be inserted somewhere in main select of the WndProc.

### Vote for wish ‘reuse-windows’

The ‘Ability to re-use dead session windows’ in on the wishlist of PuTTY. This would be really great (as with this patch, the screen would be restored within exactly the same window : no need to resize/move the window). So as stated in PuTTY’s page, do vote for this feature !

### Patch Code (to be inserted in window.c / WndProc)

```c
/** 
* Suspend - 2003 - Rémi Peyronnet <remi.peyronnet@via.ecp.fr> http://www.via.ecp.fr/~remi 
* 
* Reset the connection when suspending, and try to re-establish it when resuming.
* This is designed to be used with screen (SSH Remote Command : 'screen -r || zsh || bash')
*
* Windows broadcasts these messages 
* * when pushing the suspend button :
*  - PBT_APMQUERYSUSPEND : Query if suspend is allowed => We do not do anything.
*  - PBT_APMSUSPEND      : Tell the program Windows is suspending => Close the connection.
* * when resuming :
*  - PBT_APMRESUMESUSPEND : Tell the program Windows is resuming from suspend mode => Re-open the connection.
*  - PBT_APMRESUMEAUTOMATICALLE : Tell the program that Windows has resumed from something. => Do nothing.
*/
case WM_POWERBROADCAST:
      switch(wParam)
      {
            case PBT_APMSUSPEND:
            {
                    logevent("APM Suspend.");
                    break;
        }
            case PBT_APMRESUMESUSPEND:
            {
                    logevent("APM Resume.");
                    // Duplicate the session and close the current. 
                    // Knows Issue : As this is the wrong order (duplicate, then close), 
                    //  screen might not have been detached if the suspend time was too short.
                    //  This should only happen when testing suspend/resume quickly.
                    // It would obviously be neat to re-use the window, but my tries have been unsuccessful.
                    PostMessage(hwnd, WM_SYSCOMMAND, IDM_DUPSESS, NULL);
                    PostMessage(hwnd, WM_DESTROY, 0, NULL);
                    break;
            }
            default: break;
      }
      return TRUE;


```
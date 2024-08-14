---
title: Download as PDF a canva slideshow shared view only (with Chrome)
lang: en
tags:
- Script
- PDF
- Javascript
categories:
- Informatique
toc: 'yes'
date: '2024-08-11 18:26:37'
image: files/2024/canvadl_card.jpg
---

[Canva](https://www.canva.com/) is a commonly used tool to create some slideshows or booklet. It has an online sharing feature that allow authors to share their work. But it is sometimes useful to have an offline version of the document, even it is with less interactive features, and I have not found any solution to make such offline versions.

Below is a basic method to create an offline PDF version of a canva slideshow:
- Print each page in a PDF file with your browser
- Join all the PDF pages in a single PDF file

Notes:
- Use this method only in compliance with copyright of the document.
- It is design for canva and chrome, but the principle may also work with other sharing tools and browsers


# Manual steps

1. Print the page:
   - right-click on the page *(note: the shortcut Ctrl-P has been disabled by canva)*
   - select in the context menu the item Print...
   - select the PDF printer, 
   - append the page number
   - save the PDF file 
2. Go to the next page, and redo the steps until the end of the file
3. Use a tool like [pdfarranger](https://github.com/pdfarranger/pdfarranger) to join all the PDFs: 
   - open pdfassembler
   - drag and drop all the files
   - check the page order (and rearrange if needed)
   - save the file


# With a bit of automation
For this kind of work, usually a scripted tool with [Selenium](https://www.selenium.dev/), or any other browser automation tool, should be a perfect choice. The [jonasmalm/pitch.com-pdf-downloader](https://github.com/jonasmalm/pitch.com-pdf-downloader) GitHub repository is using this technique and should have been able to do the job. But canva is protected by Cloudflare CAPTCHA protection, and it proved to be very effective, despite all options I had tried. 

So I ended with the very lame automation below, but that works. The purpose of this is to automate the above manual steps that are very long, as renaming the file.

This script is designed only for Chrome. I haven't tested on other browsers, but as the UI is different, it is likely that the script should be adapted.

## Print pages - Javascript part

Open the console, and paste the below script:
```js
// Save Title
var baseTitle=document.title;
// Count number of pages
var nbPages = document.querySelector('div[role="slider"]').nextElementSibling.children.length;
// Go back to begining of document
[...Array(nbPages)].map((_,i)=>{ document.querySelector('button[aria-label="Previous page"]').click() });
// Declare print function
var printPageIndex = 0;
var printFunction = () => {
  if (printPageIndex < nbPages) {
    if (printPageIndex != 0) { document.querySelector('button[aria-label="Next page"]').click(); }
    printPageIndex++;
    setTimeout(() => {
      console.log("Print page " + printPageIndex);
      document.title=baseTitle+" - Page " + printPageIndex; 
      window.print(); 
    }, 100);
  } else {
    document.title=baseTitle;
    window.onafterprint = prev_onafterprint
    console.log("Done");
  }
}
// Set afterPrint callback
var prev_onafterprint = window.onafterprint
window.onafterprint = () => { setTimeout(printFunction,10) }
// And launch first print
setTimeout(printFunction, 1000)
```
The script will iterate all the page, rename the page title (because it will be used for the default file name of the printed pdf), print the page, and go to the next one.

Be sure to set the PDF export as default printer in Chrome (usually by selecting once).

Note: 
- there is a lot of asynchronous processing needed to allow the browser to refresh before the next action.
- window.print is very basic and does not have a filename parameter, and is not async, that is why we rename the title of the document, and we use onafterprint callback to catch the end of print dialog
- the CSS selectors may need to be updated if canva changes the UI
- the above timeouts are working for me, but may need to be tweaked depending on your computer speed and the printed document


## Print pages - AutoHotKey part

With the above script, you only have to press Enter two times for each page, the first one to validate the print, the second one to validate the file name. For a small file, it is really easy to do this manually. Also be sure to not type Enter with no dialog, as you will skip one page or more pages. 

But for a large file it can be tedious, and can be automated very simply with [AutoHotKey](https://www.autohotkey.com/) v1 (aka AHK): install AutoHotKey, and create a file named `chrome_press_enter.ahk` with the following contents:
```autohotkey
#Persistent ; Keep the script running
SetTitleMatchMode, 2 ; Allows partial match with window titles
SetTimer, CheckForSaveButton, 5000 ; Check every 5000 ms
return

CheckForSaveButton:
	if WinActive("ahk_exe chrome.exe")
		Send, {Enter} ; 
return
```

When launched, it will check the active window is Chrome, and if it is, will send each 5 seconds an Enter key. The 5 seconds delay is good in my case to be sure there is a dialog to validate, and to avoid skipping page by typing Enter on canva viewer, but you may need to tweak that.

Please note:
- You cannot use your computer to do anything else during the process (the focus has to stay on chrome) ; you may also consider using a VM for very long runs
- Chrome dialogs, menu and buttons are not detected by AHK, hence the use of the Enter key and the delay. There might exist some extension allowing to detect chrome buttons
- Be sure to use the version 1 of AutoHotKey ; the version 2 should also work, but the syntax has changed and the script has to be migrated
- Start this script after the first print window shown by the JavaScript script, and do not forget to stop the script by closing the process in the traybar
![]({{ 'files/2024/canvadl_stop_ahk.png' | relative_url }}){: .img-center}


## Join PDF pages

As the use of pdfassembler is very straightforward and quick, I did not investigate to automate this. There are many scriptable alternatives to that if needed with tools like [convert](https://imagemagick.org/), [Ghostscript](https://www.ghostscript.com/), [pdfunite](https://manpages.ubuntu.com/manpages/trusty/man1/pdfunite.1.html),...

![]({{ 'files/2024/canvadl_pdfassembler.png' | relative_url }}){: .img-center .mw80}

# See in action

![]({{ 'files/2024/canvadl_video.webp' | relative_url }}){: .img-center .mw80}

*(Tools used to capture:  [screentogif](https://www.screentogif.com/) optimized with [ezgif.com/optiwebp](https://ezgif.com/optiwebp))*

#### Note : how to find a canva sample for this article

The file used for the example is [https://www.canva.com/design/DAFuO-Ku-PU/lsIRCHuHWqTWHkKaHjJJEw/view?utm_content=DAFuO-Ku-PU&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink#1](https://www.canva.com/design/DAFuO-Ku-PU/lsIRCHuHWqTWHkKaHjJJEw/view?utm_content=DAFuO-Ku-PU&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink#1). It is a random file that was found with the Google Search [https://www.google.com/search?q=allinurl:canva+design+view+publishsharelink&filter=0](https://www.google.com/search?q=allinurl:canva+design+view+publishsharelink&filter=0) 

The use of Google Search operators is very powerful to find URL patterns ; see [this blog article for list of operators](https://ahrefs.com/blog/google-advanced-search-operators/)
 - allinurl: to specify a list of keyword that are expected to be found in the URL
 - &filter=0: to tell Google to not filter results that he found not relevant

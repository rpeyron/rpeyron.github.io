---
post_id: 1416
title: 'VSFolderMove : Move your Visual Studio personal folder'
date: '2015-08-16T21:24:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2015/08/vsfoldermove/'
slug: vsfoldermove
permalink: /2015/08/vsfoldermove/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1638";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2015/08/vs2015.png
categories:
    - Informatique
tags:
    - Blog
lang: en
---

Visual Studio creates your personal folder in %userdata%/Documents which is surprising and anoying when you want to keep the Documents for documents… You may think that as a professionnal developer tool, there will be a simple setting for the personal folder, but you are wrong, and it is a real pain to change this folder.

Different possibilities are shown on internet forums :

- give up
- change registry settings (a lot)
- use a ntfs junction to move files (do not solve the pollution in documents, but files will be in right place)

I choose the registry one, and decided to provide a small tool to help with : VSFolderMove

To ask Microsoft to add this setting, please vote for : [https://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/2312281-stop-polluting-my-documents-with-visual-studio-fol](https://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/2312281-stop-polluting-my-documents-with-visual-studio-fol "https://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/2312281-stop-polluting-my-documents-with-visual-studio-fol")

# Download

Binaries : [VSFolderMove.zip](/files/old-web/soft/misc/VSFolderMove.zip) (.Net Framework 3.5 needed, designed for Windows 7/8/8.1/10)

Source file : [VSFolderMove-2015-08-16.zip](/files/old-web/soft/misc/VSFolderMove-2015-08-16.zip) (C# with WPF, Visual Studio 2013)

# Screenshot

![VSFolderMove Screenshot](/files/2015/08/vsfoldermove-1.jpg "VSFolderMove Screenshot")

# Usage

Launch the executable file. If there are several installations of Visual Studio, you can choose which one in the combo box. The current personal folder path will be displayed. Select the destination path and click “Move” !

Please note that this tool moves the location in the registry, but does NOT move the files. You should :

- backup you registry
- close any Visual Studio instance
- move your files in the new location before starting Visual Studio
- if you have a message about vssettings, go to Tools / Options / Environment / “Import and Export Settings” and change the path to existing one
- if you have further problems you can reset your profile with : `%programfiles%Microsoft Visual Studio 10.0Common7IDEdevenv.exe“ /resetuserdata`

Please note that Most Recent Used items are not updated.

This tool has been tested on my computer with Visual Studio 2013. It is design to work with other versions (2010, 2012, 2015), but this has not been tested so far. Thus it should not do much damages : in the worst case it can screw you Visual Studio user data, but you can restore it with devenv /resetuserdata.

# Sources

- [http://stackoverflow.com/questions/6395057/change-visual-studio-2010-folder-location](http://stackoverflow.com/questions/6395057/change-visual-studio-2010-folder-location "http://stackoverflow.com/questions/6395057/change-visual-studio-2010-folder-location")
- [https://social.msdn.microsoft.com/Forums/vstudio/en-US/f2925f02-6523-4b02-849d-eab0871228da/is-there-a-way-to-specify-paths-for-saving-the-autorecovery-information-and-the-start-page-contents?forum=vseditor](https://social.msdn.microsoft.com/Forums/vstudio/en-US/f2925f02-6523-4b02-849d-eab0871228da/is-there-a-way-to-specify-paths-for-saving-the-autorecovery-information-and-the-start-page-contents?forum=vseditor "https://social.msdn.microsoft.com/Forums/vstudio/en-US/f2925f02-6523-4b02-849d-eab0871228da/is-there-a-way-to-specify-paths-for-saving-the-autorecovery-information-and-the-start-page-contents?forum=vseditor")
- [http://stackoverflow.com/questions/3697381/where-is-the-vssettings-for-visual-studio-express](http://stackoverflow.com/questions/3697381/where-is-the-vssettings-for-visual-studio-express "http://stackoverflow.com/questions/3697381/where-is-the-vssettings-for-visual-studio-express")
- Junction : [https://technet.microsoft.com/en-us/sysinternals/bb896768?f=255&amp;MSPPError=-2147217396](https://technet.microsoft.com/en-us/sysinternals/bb896768?f=255&MSPPError=-2147217396 "https://technet.microsoft.com/en-us/sysinternals/bb896768?f=255&MSPPError=-2147217396")
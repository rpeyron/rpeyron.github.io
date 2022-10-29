---
post_id: 2226
title: xmlDiffTreeView
date: '2004-05-29T13:35:35+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2226'
slug: xmltreenav_en
permalink: /2004/05/xmltreenav_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/xml/xmldiff/xmltreenav_en.php3'
image: /files/old-web/soft/xml/xmldiff/xmldifftreeview_scr.jpg
categories:
    - Informatique
tags:
    - OldWeb
    - Prog
    - XML
lang: en
---

xmlDiffTreeView is the ancestor of [xmlTreeNav](/xmltreenav-en/) (and you should really use the new one 🙂 )

- - - - - -

## Download

[Download the XML Diff Tree View](/files/old-web/soft/xml/xmldiff/xmldifftreeview.exe) (Win32 binary only)

## What ?

XML Tree Nav provides easy navigation in XML files. It includes a special display of xml diff files produced by [XML Diff](/2004/02/xmldiff1_en/), where icons are representing the diff status : ‘+’ means ‘added’, ‘-‘ means ‘removed’, ‘?’ means that there is a modification in the child items, and a yellow block show an element with a modification. In the modified item, the values before and after are provided : `before|after`.

## How expansive is it ?

These programs are released under the [GPL license](http://www.gnu.org/copyleft/gpl.html). It allows you to use the program at no charge, and freely adapt the provided source code to your needs.

## Screenshot

Screenshot of XMLDiffTreeView :  
![Screenshot of the UI](/files/old-web/soft/xml/xmldiff/xmldifftreeview_scr.jpg)

## How to use ?

You just have to launch the file, open a file, and and use it as explorer.

### Display of Text Nodes

With the use of the ‘T’ button, you can choose to display as nodes (when checked) or to display the text directly in the node :

So `Toto will appear with 'T' option as :<br></br>`

```
 + test
   . Toto
```

and without the ‘T’ option as :

```
 . test = Toto
```

### Display only changed nodes

To display only changed nodes, just click on the “shark” icon. Only nodes marqued by a @diff:status attribute will be displayed. This button reset the whole file to apply the new setting. If you do not want the display to be reseted, check the “atomic” button before using the “shark” one. The tree will not be erased, and the setting will apply to newly expanded nodes.
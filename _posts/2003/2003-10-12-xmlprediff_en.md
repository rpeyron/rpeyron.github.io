---
post_id: 2225
title: 'XML Pre Diff Tool'
date: '2003-10-12T13:35:35+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2225'
slug: xmlprediff_en
permalink: /2003/10/xmlprediff_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/xml/xmldiff/xmlprediff_en.php3'
image: /files/2017/10/xml_1508003040.png
categories:
    - Informatique
tags:
    - OldWeb
    - Prog
    - XML
lang: en
---

This is the ancestor of [libxmldiff](/libxmldiff/) ; you should really consider using the new one but the method below is not uninteresting.


## Why ?

Diff on XML files is a really tough problem, and there is few free solutions. Here is a method for using the standart unix `diff` command with xml files, with an understable result.

## How ?

This method is based on the idea that for an xml diff to be usable, you must have the element changed, and all his ancestors. In order to use the standart diff tool, I set up a `flat xml format` which consists in putting on the same line the ancestors with their attributes, the element, the attributes and the value. For example :

```xml
<root>
 <element id="1" name="toto">
  <child id="2" type="text">Example</child>
 </element>
</root>
```

will output in flat xml as

```
/root=
/root/element[id="1",name="toto",]=
/root/element[id="1",name="toto",]/child[id="2",type="text",]=Example
```

As you can see, all the ancestor information is summerized on a single line.

## Limitations

- Does not work with xml files with multi line contents.
- Does not work with namespaces, or xml comments.
- Does not restore xml declaration and encodings.
- Does not work with flatxml lines of more than 65535 characters.
- Is not very usefull when there is differences on root or top level elements.

## Possible improvements

Main improvements possibilities rely on the filtering possibilities in the xsl files. For instance, in the previous example, the xsl file should have been set up to output a line only for the element child, because the two first lines are neither relevant nor usefull.

# Tools

- [xml2flat.xsl](/files/old-web/soft/xml/xmldiff/xml2flat.xsl) : convert xml to a flat xml file. ([MSXSL Tool](/files/old-web/soft/xml/xmldiff/msxsl.exe))
- [flat2xml.exe](/files/old-web/soft/xml/xmldiff/flat2xml.exe) : convert flat xml back to xml file. This is a win32 binary, but the code ([flat2xml.cpp](/files/old-web/soft/xml/xmldiff/flat2xml.cpp)) should compile everywhere.
- [rediff.sh](/files/old-web/soft/xml/xmldiff/rediff.sh) : with large files, diff sometimes find false differences. This script splits the results and rediff again. To use this under windows, check out cygwin environnement, or win32 unix tools.
- [undiff.sh](/files/old-web/soft/xml/xmldiff/undiff.sh) : split the diff result in two files.

# Usage

Just follow these steps :

1. Remove from the xml file all information in the header you don’t want to see in the diff, like the timestamp of generated files…
2. Convert both xml files to flat xml files, with the xml2flat.xsl provided (for instance, using xsltproc or cooktop). \[file1.xml -&gt; file1.txt and file2.xml -&gt; file2.txt\]
3. Diff / Rediff the flat xml files. \[`./rediff.sh file1.txt file2.txt` produces diff.txt\]
4. Undiff the result file, in two files. \[`./undiff.sh diff.txt diff.before.txt diff.after.txt`\]
5. Convert back to xml files using flat2xml. \[`./flat2xml diff.before.txt diff.before.xml.]`

You now have in the two xml files the only differences between them. You can no use visualization tools like IBM’s XML Diff (warning : this tool is no more free) to view these differences in a graphical view.

Using this method, you now have shrinked your source xml files to their only differences. This allow you to use standart xml diff tools (non free : IBM XML Diff, Delta XMl,…) with very large xml files (50Mb or more) containing few differences (30ko). With the large xml files these tools usually become unusable (unless you do have 5Go of memory), but will work properly with the shrinked files, providing you exactly the same results.
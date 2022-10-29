---
post_id: 1577
title: libxmldiff
date: '2017-10-08T23:49:28+02:00'
last_modified_at: '2021-04-03T18:13:16+02:00'
author: admin
layout: page
guid: '/?page_id=1577'
slug: libxmldiff
permalink: /libxmldiff/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
lang: en
toc: true
disable-comments: false
---

![](/files/2018/10/logo-2.png){: .img-center }

*An efficient library to diff XML files*
{: .font-xlarge .center }

[ Download ](https://github.com/rpeyron/libxmldiff/archive/v0.2.9.zip){: .green-button .large-button style="width: 10em" }  [ Github ](https://github.com/rpeyron/libxmldiff){: .blue-button .large-button style="width: 10em" }  
{: .center }

&nbsp;
 
<details markdown="1"><summary>Version 0.2.9 – Other downloads (clic here)</summary>

- [Windows binaries](https://github.com/rpeyron/libxmldiff/releases/download/v0.2.9/xmldiff_bin.zip)
- [MSVC library binaries](https://github.com/rpeyron/libxmldiff/releases/download/v0.2.9/libxmldiff_bin_msvc.zip)


Older versions :

- Local (2.8) : [Source](/files/old-web/soft/xml/libxmldiff/libxmldiff-0.2.8.tar.gz)
- MinGW (2.6) : [binairies](/files/old-web/soft/xml/libxmldiff/libxmldiff_bin_devcpp.zip), [dev](/files/old-web/soft/xml/libxmldiff/libxmldiff_dev_devcpp.zip), [DevPak](/files/old-web/dist/devpacks/libxmldiff-dev.devpak) ([+libxml2](/files/old-web/dist/devpacks/libxml2-dev.devpak), +[libxsl](/files/old-web/dist/devpacks/libxslt-dev.devpak))

</details>

&nbsp;


### Technology

 Here is a sample output with diff:status attributes added by xmldiff :

```xml
<test diff:status="below" xmlns:diff="http://www.via.ecp.fr/~remi/soft/xml/xmldiff">
  <file diff:status="added" id="2"/>
  <att diff:status="modified" id="1" old="tata|toto" removed="|toto"/>
  <file att="tot|" diff:status="modified" id="12">
    <name diff:status="modified">toto.dat|toto.cfg</name>
    <!-- Test -->C'est toto !
  </file>
  <file diff:status="added" id="24"/>
  <tulipe diff:status="modified" id="42">Tulipe|Tulipe 2</tulipe>
  <toto diff:status="added">Titi !</toto>
  <section1 diff:status="below">
    <section2 diff:status="below">
      <section3>Test</section3>
      <section3 diff:status="removed">Test</section3>
    </section2>
  </section1>
</test>
```

libxmldiff diff two files, and output a file with **exactly the same structure** (unlike other xml diffing utilities), and containing an extra diff:status attribute.  
The meaning of this diff:status argument is :

- added : the element has been added.
- removed : the element has been removed.
- modified : either an argument or the text has been modified, the values will be outputted with the `|` separator : `before|after`.
- below : the element itself was not modified, but a child item was.

### How to use

### Library usage

```
#include "libxmldiff.h"
```

libxmldiff is a C library. It is extensively documented through [doxygen documentation](https://rpeyron.github.io/libxmldiff/html/) and a default xmldiff example is provided, demontrating all the possibilities.

### Command line usage

 The xmldiff example allow to use all the power of libxmldiff from command line :

```plaintext
xmldiff v0.2.9 - (c) 2004 - Remi Peyronnet - http://people.via.ecp.fr/~remi/
xmldiff - diff two XML files. (c) 2004-2006 - Rémi Peyronnet
Syntax : xmldiff action [options] <parameters>
Actions
 - diff <before.xml> <after.xml> <output.xml>
 - merge <before.xml> <after.xml> <output.xml>
 - xslt <style.xsl> <input.xml> <output.xml> [param='value']
 - recalc <output.xml>
 - execute <script.xds> (xds = list of these commands)
 - load <filename> <alias>
 - save <filename> <alias>
 - close <alias> / discard <alias> (same as close without saving)
 - flush
 - options
 - print <string>
 - delete <from alias> <xpath expression>
 - dup(licate) <source alias> <dest alias>
 - rem(ark),#,--,;,// <remark>
 - print_configuration
 - ret(urn) <value>
Global Options : 
  --auto-save yes      : Automatically save modified files
  --force-clean no     : Force remove of blank nodes and trim spaces
  --no-blanks yes      : Remove all blank spaces
  --pretty-print yes   : Output using pretty print writer
  --optimize no        : Optimize diff algorithm to reduce memory (see doc)
  --use-exslt no       : Allow the use of exslt.org extended functions.
  --savewithxslt yes   : Save with <xsl:output> options the results of XSLT.
  --verbose 4          : Verbose level, from 0 (nothing) to 9 (everything).
Diff Options : 
  --ids '@id,@value'   : Use these item to identify a node
  --ignore '@ignore,..': Ignore differences on these items
  --diff-only no       : Do not alter files, just compare.
  --keep-diff-only no  : Keep only different nodes.
  --before-values yes  : Add before values in attributes or text nodes
  --sep |              : Use this as the separator
  --encoding none  : Force encoding
  --tag-childs yes     : Tag Added or Removed childs
  --merge-ns yes       : Create missing namespace on top of document
  --special-nodes-ids yes  : Content of special nodes (CData, PI,...) will be used as ids
  --special-nodes-before-value no  : Display changed value for special nodes (CData, PI,...)
  --diff-ns http://... : Namespace definition, use no to disable
  --diff-xmlns diff    : Alias to use, use no to disable
  --diff-attr status   : Name of attribute to use (should not be used in docs)
</output.xml></input.xml>
```

#### Basic examples

```
xmldiff execute script.txt param1.xml param2.xml param3.xsl
xmldiff diff before.xml after.xml diff.xml
xmldiff --use-exslt yes xslt transform.xsl input.xml output.xml
xmldiff print "Hello World !" (that is rather useless, but it can do it !)
```

#### Aliases and other commands

The commands ” load / save / discard / flush / close / options / remark ” are useless from the command line, but are designed to be used in scripts. All these functions uses *aliases* to access xml files. Aliases are references to xml files. You can specify alias names with the load command. When you use an alias which does not exist, xmldiff tries to load the file and creates the corresponding alias.  
Typically in “load file.xml alias; diff alias file2.xml out.xml”, when processing the diff command, xmldiff will take the “alias” alias as is, as it has previsouly been opened by the load command, and will load file2.xml ans create a “file2.xml” alias, as the file was not previously loaded. It will output the result in the alias out.xml. If –auto-save is set, the alias “out.xml” will be save to a “out.xml” file.  
If you understood the previous paragraph you can use aliases to make your code easier to read. If not, just use them as standard file names, it works too 🙂

### Scripting

XML Diff introduces scripting capabilities to make xslt transformation, differences computations, basic xml manipulation (nodes deletion,…) in a same environment, with higher performance as usual scripting (as xml files do not have to be saved / loaded each times).  
A script is called by the “execute” command. Several arguments can be used in the script (‘$1’ to ‘$8’). All the commands / options described in the previous section can be used here. Here is a simple script sample :

```
# Script sample
options --auto-save no --optimize no
print "Pre-Processing..."
load $1 Before
xslt pre-processing.xsl Before Before
load $2 After
xslt pre-processing.xsl After After
diff Before After Diff
discard Before
discard After
xslt post-processing.xsl Diff Diff
save $3 Diff
print "Done."
```

### Script to merge two XML files

You will first need to create the script file named merge.xds, in the same folder as your XML files, and containing the text below : # Load files  
```
load $1 first  
load $2 second

# Do not keep values of the first file when element exists in the second one  
# Set elements identifier to attribute id  
# Disable namespace to avoid extra tag  
options –before-values no –ids ‘@id’ –diff-ns no –diff-attr xmldiff\_status

# Do the diff  
diff first second output

# Remove nodes with diff:status=added, as they were not in the first fils  
delete output ‘//\*\[@xmldiff\_status=”added”\]’

# Remove diff:status attribute to get a clean file  
delete output //@xmldiff\_status

# Save the results  
save $3 output 
```

Then you will tell xmldiff to execute this script and provide the filenames : `xmldiff.exe execute merge.xds ui\_en.xml ui\_it.xml ui\_it\_merged.xml`

### Changelog

<details markdown="1"><summary>Click to see full changelog</summary>

```plaintext
2020-05-09 19:52 [0.2.9] remi
* Release 0.2.9
* Moved Windows build to vs2019
* Removed global 'using namespace std'
* Fix CData diff : added --special-nodes-ids and --special-nodes-before-value
2016-01-31 20;29 [0.2.8] remi
* Fix memleak signaled by Andrey Paraskevopulo
2015-09-20 19:14 [0.2.7-2] remi
* Packaging updates to support xmlTreeNav 0.3.2 release
2010-07-18 19:14 [0.2.7] remi
* Fixed missing headers
* Added pkg-config file
2009-08-02 19:14 [0.2.7] remi
* Applied patch from Yong Wu (null ns prefix bug)
2008-09-29 20:37 [0.2.6] remi
* Added "ret" keyword (usefull for scripting)
* Accept empty separator (with -s no)
* Modified merge behaviour (do not add separator when removed)
2006-03-18 23:37 [0.2.5] remi
* BUGFIX : infinte loop when executing a script that does not exists
* BUGFIX : may crash with XSLT elements
* BUGFIX : some Memory Leak (should be ok now)
2006-03-02 22:37 [0.2.4] remi
* Major changes in non-regression test unit :
- test support now other operation than simple diff
- expected results are no more included
- command.lst format was modified
* Fixed crash with wrong XSLT files
* Implemented xsltSaveToFilename (fix omit-declaration)
* New feature : merge action
* Implemented namespaces in delete action
2006-02-14 00:02 remi
* Support of parameters in xslt
* Increased the number of arguments to 25 ; now is a #define.
* Conversion console -> UTF8 for XSLT arguments
* Handling of variables in XSLT arguments
* Take care of 
2006-01-06 19:47 remi
* Fixed bug reported by Jorge Robles - Tests provided
2005-08-06 16:42 [0.2.3] remi
* Boolean argument now are set to 'yes' if no second member was given
* Fixed parser bug on invalid arguments
* Diff strings (ns, xmlns, attr) as arguments
* If set to 'no', no diff namespace will be used
2005-07-30 19:14 remi
* Kludged a crash on Linux for similar documents
* Fixed CDATA bug
* Do not create the output file when no differences
* New ignore option
* Added non-regression tests
2005-05-28 20:13 remi
* Added minimalistic build
* Fixed namespace problem
* Added --merge-ns option
* Added --keep-diff-only option
* Fixed help message
* Fixed removed element handling when optimizing memory
2005-05-01 00:46 [0.2.2] remi
* Fixed Namespace bug on imported nodes (xmlReconciliateNs)
* Added cleanPrivateTag function
* Better Error Handling
* Fixed bug in namespace in elements
2005-03-10 21:54 remi
* Added debian packaging system
* Removed VS6 useless warnings
* Fixed a strcmp redefinition (if it still complains, rebuild all)
* Solved (partially) xmlFree segfault with DevCPP : static link of a mingw build of libxml2
* TODO: Added some todo's
2005-03-05 18:01 remi
* Linux Build System
* DevPak generation
* Added main Header of the libxmldiff library
2005-02-13 19:04 remi
* Initial New Tree (with DevCPP and VS support)
* bin/xmldiff.gui: Gui It command file
* BugFix : problem with force-clean on 1-char text
2004-08-08 01:42 [0.2.1] remi
* Refactored for use in xmlTreeNav
* Fix of forceClean in xslt : this option does not make sense on xslt files
2004-07-05 23:59 remi
* Added decent exception handling (first step, contents should be completed)
* BugFixes :
- auto-save issue : flush is called at the end of a script execution
- number of nodes problems
- doNotFreeBeforeItems when optimiseMemory = false
* Reuse alias in xslt transforms
2004-06-26 20:39 remi
* Added xslt/exslt transformation
* Added scripts & script parameters
2004-06-06 01:28 remi
* Splitted Operations design (no backwards compatibility)
* Implemented xmldiff progress bar callback
* Implemented diffOnly & doNotFreeBeforeNodes options
* recalc now take check if modified items are still modified
2004-06-01 00:11 remi
* src/: libxml2_utils.h, xerces_utils.h, xmldiff_xerces.cpp: Files
removed while refactoring the code.
2004-06-01 00:10 [0.2.0] remi
* Code refactoring ; it is now split into :
- xmldiff : contains program specific items (command line parsing, options,...)
- lx2_diff : diff algorithm implemented for libxml2
- lx2_utils : libxml2 usefull functions (and string handling)
It actually does work on win32 with the same functionnality as
before (Xerces). Run under Windows and Linux.
* Namespace in attributes are now handled properly.
2004-05-23 22:50 [0.1.0] remi
* First Import in CVS. Some files are taken from xmldiff previous module

```

</details>
---
post_id: 2193
title: 'GUI Launcher (Old)'
date: '2004-01-18T13:35:35+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2193'
slug: launcher_en
permalink: /2004/01/launcher_en/
URL_before_HTML_Import: 'http://www.lprp.fr/soft/misc/launcher/launcher_en.php3'
image: /files/old-web/soft/misc/launcher/launcher_scr.jpg
categories:
    - Informatique
tags:
    - Freeware
    - OldWeb
lang: en
---

GUI Launcher aims at providing an easy solution for building front end GUI for command line tools. It is now replaced by [Guit It !](/2006/02/guiit_en/)

Download [windows binaries](/files/old-web/soft/misc/launcher/launcher_bin.zip) or [python sources](/files/old-web/soft/misc/launcher/launcher_src.zip). (As this is python, the program is cross-platform). This application does not need any installation. Just unzip the contents of the archiver and run the executable.

This is [GPL software.](http://www.gnu.org/copyleft/gpl.html) The last version of this software can be found on the [home page of this software](http://www.via.ecp.fr/~remi/soft/misc/launcher/launcher_en.php3?menu=no).

The usage is very easy. Once the application launched, you can modify a set of parameters. For file parameters, you can choose the file by clicking on the “…” browse button.

Once you are happy with these settings (you can check the resulting command line in the corresponding text box), just click on the “Process” button. Then you will be able to see the output in the output window (if not disabled). If the program does require manual entry, you can enter your answer in the input text field, and click on the “Send” button (if the entry fiels has not been disabled).

Well that’s all… Here is the corresponding screenshot :

![screenshot](/files/old-web/soft/misc/launcher/launcher_scr.jpg)


# Settings

The main feature of this simple GUI program is the wide range of settings. This configuration is done through one xml file. The default name of this xml file is `"launcher.xml"`. If you want to use another xml file (usefull for configuring several application with only one executable of launcher), you can provide the name in the first argument of the command line.

The main features are :

- Support any number of parameters.
- Browse button for file names parameters.
- Path configuration.
- Translation of the strings used in this program.
- Support parameters like width / height and displau output/input panes.

The default file should be self-explanatory :

```html
<?xml version="1.0" encoding="iso-8859-1" standalone="yes" ?>
<launcher>
 <!-- Title of the window -->
 <title>Test</title>
 <!-- A small text of introduction (HTML) -->
 <intro><![CDATA[
 <center>Ceci est un <b>petit</b> texte d'introduction</center><br />
 <p>Voici un petit mode d'emploi</p>
 ]]></intro>
 <!-- 
  Information about the command to launch :
   - workingpath is the working path of the command (chdir to this path before executing)
   - commandpath is the path of the command (the file executed is commandpath/command args)
   - command is the command line to execute
   - arg is an argument to pass :
      @name : is the name of the asked value
      @type : is the type of selector (ex : file, dir, hidden)
           - file : the argument is a file, a button will browse files.
           - dir : the argument is a directory, a button will browse directories.
           - hidden : the argument is not displayed, but included in the command line. 
                         This is usefull to add constant values (switches,...)
           - check : the element is displayed as a check box. Default is unchecked. 
                        The value is used in the command line if checked.
      @use : use the argument in the command line (yes / no, yes by default). 
                If @use="quoted", the value is protected by quotes, rather usefull for files with spaces under windows !
      value : is the default value
                  You can use {name of another argument} in the value, to dynamically provide default dynamic values.
   - out works rather like arg elements, but appears in out section, and is readonly. 
           This is designed to open directly results.

   See below and in the program for other small options, which should be either useless or self explainatory.
 -->
 <program>
  <workingpath></workingpath>
  <commandpath>.</commandpath>
  <command>sh xmldiff.sh</command>
  <arg name="Fichier" id="Fic1">Testé.txt</arg>
  <arg type="hidden">-cx</arg>
  <arg name="Option Test" type="check">--test</arg>
  <arg name="Fichier" id="Fic2" file="yes" />
  <arg name="Répertoire 3" type="dir" use="no">{command}</arg>
  <arg name="Fichier 4" type="file" />
  <arg name="Fichier 5" use="quoted" >{Fic1}.txt</arg>
  <out name="Sortie" edit-with="notepad" >{Fic2}.txt</out>
  <redirect-output to-id="Fic1" />
 </program>
 <!-- Some parameters of the application -->
 <parameter name="display-output" value="yes" />
 <parameter name="display-input" value="no" />
 <parameter name="display-out" value="yes" />
 <parameter name="width" value="500" />
 <parameter name="height" value="500" />
 <!-- Another help text (HTML) -->
 <help>
 </help>
 <!-- Strings of the appplication : translate here -->
 <strings>
   <string name="Process">Lance le traitement</string>
   <string name="Arguments">Arguments</string>
   <string name="Outputs">Résultats</string>
   <string name="mnu_File">Fichier</string>
   <string name="mnu_File_Quit">Quitter</string>
   <string name="des_File_Quit">Terminer le programme.</string>
   <string name="st_Ready">Pret.</string>
   <string name="st_Done">Terminé.</string>
   <string name="st_Process">Traitement en cours...</string>
   <string name="fl_FileMask">Fichiers XML (*.xml)|*.xml|Fichiers Textes (*.txt)|*.txt|Tous les fichiers (*.*)|*.*</string>
   <string name="st_ChooseFile">Choix du fichier</string>
   <string name="st_ChooseDir">Choix du répertoire</string>
   <string name="Command">Commande</string>
   <string name="Input">Entrée utilisateur</string>
   <string name="Send">Envoi</string>
   <string name="CloseStream">Terminer</string>
 </strings>
</launcher>

```
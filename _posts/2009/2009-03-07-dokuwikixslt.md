---
post_id: 1383
title: 'XSLT Plugin for Dokuwiki'
date: '2009-03-07T19:29:00+01:00'
last_modified_at: '2018-12-07T22:13:51+01:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/2009/03/dokuwikixslt/'
slug: dokuwikixslt
permalink: /2009/03/dokuwikixslt/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1773";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/xml_1508003040.png
categories:
    - Informatique
tags:
    - Blog
lang: en
---

You may want to do some XSL transformations in Dokuwiki, for instance to maintain a small database in xml, and be able to render it in Dokuwiki. This plugin adds this functionnality, provided Dokuwiki is installed on a server which have **PHP5** and the **xsl** module.

Please consult the [official page of the plugin](http://www.dokuwiki.org/plugin:xslt) on Dokuwiki

# Pre-requisites

- A [Dokuwiki](http://www.dokuwiki.org "http://www.dokuwiki.org") installation
- PHP5
- The xsl module

# Installation

Use [automatic installation](/files/old-web/soft/misc/dokuwiki_xslt.zip) from the plugin database or [download](/files/old-web/soft/misc/dokuwiki_xslt.zip).  
More instructions on [this page](http://www.dokuwiki.org/plugin_installation_instructions "http://www.dokuwiki.org/plugin_installation_instructions").

# Usage

To use XSLT transformation, you will need to use **&amp;&amp;XML&amp;&amp;**, **&amp;&amp;XSLT&amp;&amp;** and **&amp;&amp;END&amp;&amp;** tags. Theses tags must have line separators before and after them. The xml file is located between &amp;&amp;XML&amp;&amp; and &amp;&amp;XSLT&amp;&amp;, and the xslt to use is between &amp;&amp;XSLT&amp;&amp; and &amp;&amp;END&amp;&amp;. Easy enough, no ?

```xml
&&XML&&

<xml>
<book>Book 1</book>
<book>Book 2</book>
</xml>

&&XSLT&&

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/REC-html40">
<xsl:template match="/">List of books : <ul><xsl:apply-templates /></ul></xsl:template>
<xsl:template match="book"><li><b><xsl:apply-templates /></b></li></xsl:template>
</xsl:stylesheet>

&&END&&
```

# Plugin code

```php
<?php
/**
 * Plugin XSLT : Perform XSL Transformation on provided XML data
 * 
 * To be run with Dokuwiki only
 *
 * Sample data provided at the end of the file
 *
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     Rémi Peyronnet  <remi+xslt@via.ecp.fr>
 */
 
if(!defined('DOKU_INC')) die();
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
class syntax_plugin_xslt extends DokuWiki_Syntax_Plugin {
 
    function getInfo(){
      return array(
        'author' => 'Rémi Peyronnet',
        'email'  => 'remi+xslt@via.ecp.fr',
        'date'   => '2009-03-07',
        'name'   => 'XSLT Plugin',
        'desc'   => 'Perform XSL Transformation on provided XML data',
        'url'    => 'http://people.via.ecp.fr/~remi/',
      );
    }
 
    function getType() { return 'substition'; }
    function getPType() { return 'block'; }
    function getSort() { return 1242; }
    function connectTo($mode) { $this->Lexer->addSpecialPattern('&&XML&&\n.*\n&&XSLT&&\n.*\n&&END&&',$mode,'plugin_xslt'); }

    function handle($match, $state, $pos, Doku_Handler $handler)
    { 
        switch ($state) {
          case DOKU_LEXER_SPECIAL :
                $matches = preg_split('/(&&XML&&\n*|\n*&&XSLT&&\n*|\n*&&END&&)/', $match, 5);
                $data = "XML: " . $matches[1] . "\nXSLT: ". $matches[2] . "(" . $match . ")";
                $xsltproc = new XsltProcessor();
                $xml = new DomDocument;
                $xsl = new DomDocument;
                $xml->loadXML($matches[1]);
                $xsl->loadXML($matches[2]);
                $xsltproc->registerPHPFunctions();
                $xsltproc->importStyleSheet($xsl);
                $data = $xsltproc->transformToXML($xml);
                
                if (!$data) {
                    $errors = libxml_get_errors();
                    foreach ($errors as $error) {
                        $data = display_xml_error($error, $xml);
                    }
                    libxml_clear_errors();
                }                

                unset($xsltproc);
                return array($state, $data);
 
          case DOKU_LEXER_UNMATCHED :  return array($state, $match);
          case DOKU_LEXER_EXIT :       return array($state, '');
        }
        return array();
    }
    
    function render($mode, Doku_Renderer $renderer, $data) 
    {
         if($mode == 'xhtml'){
            list($state, $match) = $data;
            switch ($state) {
              case DOKU_LEXER_SPECIAL :      
                $renderer->doc .= $match; 
                break;
 
              case DOKU_LEXER_UNMATCHED :  $renderer->doc .= $renderer->_xmlEntities($match); break;
              case DOKU_LEXER_EXIT :       $renderer->doc .= ""; break;
            }
            return true;
        }
        return false;
    }
}


function display_xml_error($error, $xml)
{
    $return  = $xml[$error->line - 1] . "\n";
    $return .= str_repeat('-', $error->column) . "^\n";

    switch ($error->level) {
        case LIBXML_ERR_WARNING:
            $return .= "Warning $error->code: ";
            break;
         case LIBXML_ERR_ERROR:
            $return .= "Error $error->code: ";
            break;
        case LIBXML_ERR_FATAL:
            $return .= "Fatal Error $error->code: ";
            break;
    }

    $return .= trim($error->message) .
               "\n  Line: $error->line" .
               "\n  Column: $error->column";

    if ($error->file) {
        $return .= "\n  File: $error->file";
    }

    return "$return\n\n--------------------------------------------\n\n";
}

/*

Sample data :

This is my list of books, maintained in XML/XSLT inside Dokuwiki.
&&XML&&

<xml>
<book>Book 1</book>
<book>Book 2</book>
</xml>

&&XSLT&&

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/REC-html40">
<xsl:template match="/">List of books : <ul><xsl:apply-templates /></ul></xsl:template>
<xsl:template match="book"><li><b><xsl:apply-templates /></b></li></xsl:template>
</xsl:stylesheet>

&&END&&


*/

?>
```
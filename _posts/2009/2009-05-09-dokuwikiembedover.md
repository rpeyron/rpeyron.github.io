---
post_id: 1382
title: 'Plugin Embedover for Dokuwiki'
date: '2009-05-09T17:30:00+02:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2009/05/dokuwikiembedover/'
slug: dokuwikiembedover
permalink: /2009/05/dokuwikiembedover/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";s:4:"1751";s:11:"_thumb_type";s:5:"thumb";}'
post_slider_check_key: '0'
image: /files/2017/10/wiki_1508001856.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

You may want to embed external pages over Dokuwiki, and see it by clicking on the text. This can be useful by example to add some extra informations on a word, by linking with a dictionnary, a database, or whatever could add information to this word.

See plugin page on dokuwiki : <https://www.dokuwiki.org/plugin:embedover>

## Pre-requisites

- A [Dokuwiki](http://www.dokuwiki.org "http://www.dokuwiki.org") installation
- PHP5

## Installation

Use [automatic installation](/files/old-web/soft/misc/dokuwiki_embedover.zip) from the plugin database or [download](/files/old-web/soft/misc/dokuwiki_embedover.zip).  
More instructions on [this page](http://www.dokuwiki.org/plugin_installation_instructions "http://www.dokuwiki.org/plugin_installation_instructions").

## Usage

Embedover uses these delimiters **{(** and **)}**. You must first define the url which will be used when clicking on the keywords by using **{(url:http://your.url.here/the/page.html?query=)}**. Then you can use it in keywords {(keyword)} : a click on the keyword will display a popup with the url http://your.url.here/the/page.html?query=keyword.

In addition, you may want to mix several urls. You can do that with modes. The syntax is **mode!**. So to define a url for the mode ‘modetest’, **{(url:modetest!yoururlhere)}** and to use it in a keyword : **{(modetest!keyword)}**. Note that the url definition **must** take place before its first utilisation.

If you want to display another text than the keyword, you can use **|** as in regular dokuwiki link syntax : **{(keyword|displayed text)}**.

You can also specify the style of the popup displayed, as its width, or any valid css style, by using **{(style: width: 400px; )}**.

Example :

```
{(url:http://fr.wiktionary.org/w/index.php?title=)}
{(url:en!http://en.wiktionary.org/w/index.php?title=)}
{(style:width:700px;height:500px;overflow:scroll;)}
{(style:en!width:700px;height:500px;overflow:scroll;)}
{(click|Click)} on a {(en!word)} to have its {(definition)}.
```

Note : if the page you link is on the same domain, the height will be automatically set according to the real height of the included content. This is not allowed by javascript for other domains, for security reasons.

## Plugin code

*syntax.php*

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

    onmouseover : ouvre un popup au dessus, et affiche url contenant le texte

    {[url:mode!http://toto?value=]}
    {[url:mode!inline]}
    {[url:mode!wiki]}
    {[ignore:cam]}
    {[style:]}
    {[mode!texte|affiché]}

    tri dvd inversé (sort) 

    Shift + Refresh pour raffraichir sous firefox

 */

if(!<a href="http://www.php.net/defined">defined</a>('DOKU_INC')) <a href="http://www.php.net/die">die</a>();
if(!<a href="http://www.php.net/defined">defined</a>('DOKU_PLUGIN')) <a href="http://www.php.net/define">define</a>('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');

class syntax_plugin_embedover extends DokuWiki_Syntax_Plugin {

    public $urls = <a href="http://www.php.net/array">array</a>();
    public $styles = <a href="http://www.php.net/array">array</a>();

    function getInfo(){
      return <a href="http://www.php.net/array">array</a>(
        'author' => 'Rémi Peyronnet',
        'email'  => 'remi+embedover@via.ecp.fr',
        'date'   => '2009-05-03',
        'name'   => 'EmbedOver Plugin',
        'desc'   => 'Embed in an overlay a remote web/wiki page',
        'url'    => 'http://people.via.ecp.fr/~remi/',
      );
    }

    function <a href="http://www.php.net/gettype">getType</a>() { return 'substition'; }
    function getPType() { return 'normal'; }
    function getSort() { return 4212; }
    function connectTo($mode) { $this->Lexer->addSpecialPattern('{([^}]*)}',$mode,'plugin_embedover'); }

    function handle($match, $state, $pos, &$handler)
    { 
        switch ($state) {
          case DOKU_LEXER_SPECIAL :
                $data = '';
                // URLs
                if (<a href="http://www.php.net/preg_match">preg_match</a>('/{(url:((?<mode>.*)!)?(?<text>[^|]*))}/', $match, $matches))
                {
                    if (!$matches[mode]) $matches[mode] = 'default';
                    $this->urls[$matches[mode]] = $matches[text];
                    $data = '{[embedover_div]}';
                }
                // Style
                else if (<a href="http://www.php.net/preg_match">preg_match</a>('/{(style:((?<mode>.*)!)?(?<text>[^|]*))}/', $match, $matches))
                {
                    if (!$matches[mode]) $matches[mode] = 'default';
                    $this->styles[$matches[mode]] = $matches[text];
                }
                // Items
                else if (<a href="http://www.php.net/preg_match">preg_match</a>('/{(((?<mode>.*)!)?(?<text>[^|]*)(|(?<aff>.*))?)}/', $match, $matches))
                {
                    if (!$matches[aff]) $matches[aff] = $matches[text];
                    if (!$matches[mode]) $matches[mode] = 'default';
                    $dest = $this->urls[$matches[mode]] . <a href="http://www.php.net/urlencode">urlencode</a>($matches[text]);
                    $style = $this->styles[$matches[mode]];
                    if ($matches[aff]) $data = "<span onclick='embedover_click(event, "$dest", "$style");'>${matches[aff]}</span>";
                }
                return <a href="http://www.php.net/array">array</a>($state, $data);

          case DOKU_LEXER_UNMATCHED :  return <a href="http://www.php.net/array">array</a>($state, $match);
          case DOKU_LEXER_ENTRY :          return <a href="http://www.php.net/array">array</a>($state, '');
          case DOKU_LEXER_EXIT :            return <a href="http://www.php.net/array">array</a>($state, '');
        }
        return <a href="http://www.php.net/array">array</a>();
    }

    function render($mode, &$renderer, $data) 
    {
         if($mode == 'xhtml'){
            <a href="http://www.php.net/list">list</a>($state, $match) = $data;
            switch ($state) {
              case DOKU_LEXER_SPECIAL :
                if ($match ==  '{[embedover_div]}')
                {
                    $renderer->doc .= "<iframe id='embedover_div' scrolling='no' marginwidth='0' marginheight='0' frameborder='0' vspace='0' hspace='0'></iframe>";
                }
                else
                {
                    $renderer->doc .= $match; 
                }
                break;

              case DOKU_LEXER_UNMATCHED :  $renderer->doc .= $renderer->_xmlEntities($match); break;
              case DOKU_LEXER_EXIT :       $renderer->doc .= ""; break;
            }
            return true;
        }
        return false;
    }
}


?>
```

*script.js*

```js
var embedover_visible;

function embedover_click(e, click, style)
{
    // Update style
    document.getElementById("embedover_div" ).setAttribute("style", style);
	document.getElementById("embedover_div" ).style.cssText = style;
    // Update contents
    if ((click == document.getElementById("embedover_div" ).src) && 
         (embedover_visible != 'no') )
    {
        document.getElementById("embedover_div" ).style.display= 'none';
        embedover_visible = 'no';
    }
    else
    {
        document.getElementById("embedover_div" ).src=click; // encodeURIComponent
        document.getElementById("embedover_div" ).style.display = 'block' ;
        embedover_visible = 'yes';
    }
    // Update position
    if (!e) var e = window.event;
	if (e.pageX || e.pageY) 	{ posy = e.pageY; }
	else if (e.clientX || e.clientY) 	{ 		posy = e.clientY + document.body.scrollTop 	+ document.documentElement.scrollTop; 	}
    document.getElementById("embedover_div" ).style.top = posy;
    document.getElementById("embedover_div" ).style.left = document.body.clientWidth - document.getElementById("embedover_div").offsetWidth ;
}


// From  : http://www.dynamicdrive.com/dynamicindex17/iframessi2.htm
// Use : <iframe id="myframe" src="externalpage.htm" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" vspace="0" hspace="0" style="overflow:visible; width:100%; display:none"></iframe>

/***********************************************
* IFrame SSI script II- © Dynamic Drive DHTML code library (http://www.dynamicdrive.com)
* Visit DynamicDrive.com for hundreds of original DHTML scripts
* This notice must stay intact for legal use
***********************************************/

//Input the IDs of the IFRAMES you wish to dynamically resize to match its content height:
//Separate each ID with a comma. Examples: ["myframe1", "myframe2"] or ["myframe"] or [] for none:
var iframeids=["embedover_div"];

//Should script hide iframe from browsers that don't support this script (non IE5+/NS6+ browsers. Recommended):
var iframehide="yes";

var getFFVersion=navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1];
var FFextraHeight=parseFloat(getFFVersion)>=0.1? 16 : 0; //extra height in px to add to iframe in FireFox 1.0+ browsers

function resizeCaller() {
var dyniframe=new Array();
for (i=0; i<iframeids.length; i++){
if (document.getElementById)
resizeIframe(iframeids[i]);
//reveal iframe for lower end browsers? (see var above):
if ((document.all || document.getElementById) && iframehide=="no"){
var tempobj=document.all? document.all[iframeids[i]] : document.getElementById(iframeids[i]);
//tempobj.style.display="block";
}
}
}

function resizeIframe(frameid){
var currentfr=document.getElementById(frameid);
if (currentfr && !window.opera){
//currentfr.style.display="block";
if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight) //ns6 syntax
currentfr.height = currentfr.contentDocument.body.offsetHeight+FFextraHeight; 
else if (currentfr.Document && currentfr.Document.body.scrollHeight) //ie5+ syntax
currentfr.height = currentfr.Document.body.scrollHeight;
if (currentfr.addEventListener)
currentfr.addEventListener("load", readjustIframe, false);
else if (currentfr.attachEvent){
currentfr.detachEvent("onload", readjustIframe); 
currentfr.attachEvent("onload", readjustIframe);
}
}
}

function readjustIframe(loadevt) {
var crossevt=(window.event)? event : loadevt;
var iframeroot=(crossevt.currentTarget)? crossevt.currentTarget : crossevt.srcElement;
if (iframeroot)
resizeIframe(iframeroot.id);
}

function loadintoIframe(iframeid, url){
if (document.getElementById)
document.getElementById(iframeid).src=url;
}

if (window.addEventListener)
window.addEventListener("load", resizeCaller, false);
else if (window.attachEvent)
window.attachEvent("onload", resizeCaller);
else
window.onload=resizeCaller;
```

*style.css*

```css
.embedover { color: #4d5b90;  }

#embedover_div 
{
	float: right;
	width:700px;
	display: none;
	position: absolute;
	background-color: white;
}
```
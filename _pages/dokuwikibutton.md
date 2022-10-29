---
post_id: 1381
title: 'Button plugin for dokuwiki'
date: '2013-05-18T20:50:00+02:00'
last_modified_at: '2013-05-18T20:50:00+02:00'
author: admin
layout: page
guid: '/2013/05/dokuwikibutton/'
slug: dokuwikibutton
permalink: /dokuwikibutton/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
post_slider_check_key: '0'
categories:
    - Général
lang: en
disable-comments: false
---

Please see the dokuwiki plugin homepage : [https://www.dokuwiki.org/plugin:button](https://www.dokuwiki.org/plugin:button "https://www.dokuwiki.org/plugin:button")

![](/files/2013/05/dokuwiki_button_button-1.png){: .img-center}


## Installation

Use [automatic installation](/files/old-web/soft/misc/dokuwiki_button.zip) from the plugin database or [download](/files/old-web/soft/misc/dokuwiki_button.zip).  
More instructions on [this page](http://www.dokuwiki.org/plugin_installation_instructions "http://www.dokuwiki.org/plugin_installation_instructions").

You may also use [https://github.com/rpeyron/plugin-button](https://github.com/rpeyron/plugin-button "https://github.com/rpeyron/plugin-button") for downloading the zip file or to contribute to this plugin.

## Usage

The full syntax is :

```
        [[{namespace:image|extra css}wiki page|Title of the link]]
```

Where :

- `namespace:image` is the location of the image to use in the media manager
- `extra css` is some css code to add to the button, or the name of a style defined with `conf.styles` (see below)
- `wiki page` is the targetted id page
- `Title of the link` is the name that will be displayed on the button (‘\\’ will break the line in the button)

All fields are optional, so the minimal syntax is :

```
	[[{}Simple button without image]]
```

You may configure some styles to use in your buttons without repeating all the css :

```
	[[{conf.styles}style|css]]
```

Where :

- `conf.styles` is the keyword to set the styles
- `style` is the name of the style you want to set ; if ‘default’, it will be added to all buttons
- `css` is the css code you will assign to that style

Note that the CSS part is a bit tricky due to the selectors used in the template CSS and the layout needed for the button. By default, the style of the links is not repeated (just external links icon). See comments in `style.css` file for more information.

You may also configure the target of the link with the use of conf.target :

```
	[[{conf.target}style|target]]
```

Example :

```
	[[{conf.target}default|_blank]]
```

## Issues

- If you experience display problems with Internet Explorer, please check the “Compatibility Mode” setting.

## Changelog

Latest changelog code is available on download on [the dokuwiki plugin page](https://www.dokuwiki.org/plugin:button "https://www.dokuwiki.org/plugin:button")

- 19/05/2013 : Initial release
- 20/04/2014 : Added target support (feature request from Andrew St Hilaire)

## Source code

Latest source code is available on download on [the dokuwiki plugin page](https://www.dokuwiki.org/plugin:button "https://www.dokuwiki.org/plugin:button")

<details markdown="1"><summary>Click here to see the first version of the source code</summary>



### syntax.php

```php
<?php
/**
 * Plugin Button : Add button with image support syntax for links
 * 
 * To be run with Dokuwiki only
 
 *
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author     RÃ©mi Peyronnet  <remi+xslt@via.ecp.fr>
 
 Full Syntax :
     [[{namespace:image|extra css}wiki page|Title of the link]]
 
All fields optional, minimal syntax:
	[[{}Simple button]]
 
 Configuration :
	[[{conf.styles}style|css]]
	[[{conf.target}style|target]]
 
 19/05/2013 : Initial release
 20/04/2014 : Added target support (feature request from Andrew St Hilaire)
 
 */
 
if(!defined('DOKU_INC')) die();
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
// Copied and adapted from inc/parser/xhtml.php, function internallink
// Should use wl instead (from commons), but this won't do the trick for the name
function dokuwiki_get_link(&$xhtml, $id, $name = NULL, $search=NULL,$returnonly=false,$linktype='content')
{
	global $conf;
	global $ID;
	global $INFO;
 
	$params = '';
	$parts = explode('?', $id, 2);
	if (count($parts) === 2) {
		$id = $parts[0];
		$params = $parts[1];
	}
 
	// For empty $id we need to know the current $ID
	// We need this check because _simpleTitle needs
	// correct $id and resolve_pageid() use cleanID($id)
	// (some things could be lost)
	if ($id === '') {
		$id = $ID;
	}
 
	// default name is based on $id as given
	$default = $xhtml->_simpleTitle($id);
 
	// now first resolve and clean up the $id
	resolve_pageid(getNS($ID),$id,$exists);
 
	$name = $xhtml->_getLinkTitle($name, $default, $isImage, $id, $linktype);
	if ( !$isImage ) {
		if ( $exists ) {
			$class='wikilink1';
		} else {
			$class='wikilink2';
			$link['rel']='nofollow';
		}
	} else {
		$class='media';
	}
 
	//keep hash anchor
	list($id,$hash) = explode('#',$id,2);
	if(!empty($hash)) $hash = $xhtml->_headerToLink($hash);
 
	//prepare for formating
	$link['target'] = $conf['target']['wiki'];
	$link['style']  = '';
	$link['pre']    = '';
	$link['suf']    = '';
	// highlight link to current page
	if ($id == $INFO['id']) {
		$link['pre']    = '<span class="curid">';
		$link['suf']    = '</span>';
	}
	$link['more']   = '';
	$link['class']  = $class;
	$link['url']    = wl($id, $params);
	$link['name']   = $name;
	$link['title']  = $id;
	//add search string
	if($search){
		($conf['userewrite']) ? $link['url'].='?' : $link['url'].='&amp;';
		if(is_array($search)){
			$search = array_map('rawurlencode',$search);
			$link['url'] .= 's[]='.join('&amp;s[]=',$search);
		}else{
			$link['url'] .= 's='.rawurlencode($search);
		}
	}
 
	//keep hash
	if($hash) $link['url'].='#'.$hash;
 
	return $link;
	//output formatted
	//if($returnonly){
	//	return $this->_formatLink($link);
	//}else{
	//	$this->doc .= $this->_formatLink($link);
	//}
}
 
 
class syntax_plugin_button extends DokuWiki_Syntax_Plugin {
 
    public $urls = array();
    public $styles = array();
 
    function getInfo(){
      return array(
        'author' => 'RÃ©mi Peyronnet',
        'email'  => 'remi+button@via.ecp.fr',
        'date'   => '2013-05-17',
        'name'   => 'Button Plugin',
        'desc'   => 'Add button links syntax',
        'url'    => 'http://people.via.ecp.fr/~remi/',
      );
    }
 
    function getType() { return 'substition'; }
    function getPType() { return 'normal'; }
    function getSort() { return 250; }  // Internal link is 300
    function connectTo($mode) { $this->Lexer->addSpecialPattern('[[{[^}]*}[^]]*]]',$mode,'plugin_button'); }
 
    function handle($match, $state, $pos, &$handler)
    { 
		global $plugin_button_styles;
 
        switch ($state) {
          case DOKU_LEXER_SPECIAL :
                $data = '';
                // Button
                if (preg_match('/[[{(?<image>[^}|]*)|?(?<css>[^}]*)}(?<link>[^]|]*)|?(?<title>[^]]*)]]/', $match, $matches))
                {
					$data = $matches;
                }
                return array($state, $data);
 
          case DOKU_LEXER_UNMATCHED :  return array($state, $match);
          case DOKU_LEXER_ENTRY :          return array($state, '');
          case DOKU_LEXER_EXIT :            return array($state, '');
        }
        return array();
    }
 
    function render($mode, &$renderer, $data) 
    {
		global $plugin_button_styles;
		global $plugin_button_target;
 
		if($mode == 'xhtml'){
            list($state, $match) = $data;
            switch ($state) {
              case DOKU_LEXER_SPECIAL:
				if (is_array($match))
				{
					if ($match['image'] == 'conf.styles')
					{
						$plugin_button_styles[$match['link']] = $match['title'];
					}
					else if ($match['image'] == 'conf.target')
					{
						$plugin_button_target[$match['link']] = $match['title'];
					}
					else
					{
						// Test if internal or external link (from handler.php / internallink)
						if (preg_match('#^([a-z0-9-.+]+?)://#i',$match['link']))
						{
							// External
							$link['url'] = $match['link'];
							$link['name'] = $match['title'];
							if ($link['name'] == "") $link['name'] = $match['link'];
							$link['class'] = 'urlextern';
						}
						else
						{
							// Internal
							$link = dokuwiki_get_link($renderer, $match['link'], $match['title']);
						}
						$target = "";
						if (is_array($plugin_button_target) && array_key_exists('default',$plugin_button_target))
						{
							$target = " target='" . $plugin_button_target['default'] . "'";
						}
						if (is_array($plugin_button_target) && array_key_exists($match['css'],$plugin_button_target))
						{
							$target = " target='" . $plugin_button_target[$match['css']] . "'";
						}
						if ($match['css'] != "")
						{
							if (is_array($plugin_button_styles) && array_key_exists($match['css'],$plugin_button_styles))
							{
								$match['css'] = $plugin_button_styles[$match['css']];
							}
						}
						if (is_array($plugin_button_styles) && array_key_exists('default',$plugin_button_styles) && ($match['css'] != 'default'))
						{
							$match['css'] = $plugin_button_styles['default'] .' ; '. $match['css'];
						}
						$image = $match['image'];
						$link['name'] = str_replace('\\','<br />', $link['name']);
						if ($image != '')
						{
							$image =  "<span><img src='" . ml($image) . "' /></span>";
						}
						$text = "<a $target href='${link['url']}'><spancss']}'>$image<spanclass']}'>${link['name']}</span></span></a>";
						$renderer->doc .= $text; 
					}
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

### style.css

```
.plugin_button {
	border-radius:6px;
	border:1px solid __border__;
	background-color: __background_alt__;
	box-shadow:inset 0px 1px 0px 0px #ffffff;
	padding:0.5em;
	margin: 0.2em;
	text-decoration:none;
	display: inline-table;
	text-align:center;
}
 
.plugin_button_text {
	display: table-cell;
	width: 99%;
	text-align: center;
	vertical-align: middle;
	text-shadow:1px 1px 0px #ffffff;
}
 
.plugin_button_image {
	display: table-cell;
	vertical-align: middle;
	white-space: nowrap;
	padding-right: 1em;
}
 
/*  
Note : 
- template style won't apply to the links because it is not a <a> link.
- if I forced a link here (beside some problems in layout), it will override css given
 
If you want standard CSS here, just copy it below, and add a space between 'a' and the class
(example below for external links)
*/
 
.dokuwiki a .urlextern {
    background-image: url(../../images/external-link.png);
    background-repeat: no-repeat;
    background-position: 0 center;
    padding: 0 0 0 18px;
}
```

</details>
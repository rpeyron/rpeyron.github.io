---
post_id: 2099
title: 'Mots croisés'
date: '2013-03-08T14:53:43+01:00'
last_modified_at: '2022-10-08T19:28:31+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=2099'
slug: motscroises
permalink: /2013/03/motscroises/
URL_before_HTML_Import: 'http://www.lprp.fr/echecs/motscroises.php3'
categories:
    - Général
tags:
    - OldWeb
lang: fr
---

Ce rapide petit script PHP permet de formatter rapidement une grille de mots croisés et de générer diverses vues. Pour l’utiliser, il suffit de rentrer vos lettres dans les cases (pas plus d’une lettre par case), et de mettre ‘\*’ pour un noir.

Ci-dessous le script original de 2013 :

```php
<?php 
 // Paramètres
 $taillex = 30;
 $tailley = 30;
 $col = "#F0F0F0";
 $colgris = "#000000";

$sizex = $_REQUEST['sizex'];
$sizey = $_REQUEST['sizey'];
$oldsizex = $_REQUEST['oldsizex'];
$oldsizey = $_REQUEST['oldsizey'];
$test = $_REQUEST['test'];

// Traduit valeurs en tableau
for ($i=0;$i<$sizey;$i++)
{
 for ($j=0;$j<$sizex;$j++)
 {
  $tab[$i][$j]="";
 }
}
for ($i=0;$i<$oldsizey;$i++)
{
 for ($j=0;$j<$oldsizex;$j++)
 {
  $c = "c".($i*$oldsizex+$j);
  $tab[$i][$j]=$_REQUEST[$c];
 }
}


// Set the default size 
if ($sizex == "") { $sizex = 8; }
if ($sizey == "") { $sizey = 8; }
?>

<form method="get">
 <p>
 <input type="hidden" name="oldsizex" value="<?php echo $sizex; ?>">
 <input type="hidden" name="oldsizey" value="<?php echo $sizey; ?>">
 Dimensions du damier :&nbsp;X = <input type="text" size="5" style="width: 5em" name="sizex" value="<?php echo $sizex; ?>">,
 Y = <input type="text" size="5" style="width: 5em" name="sizey" value="<?php echo $sizey; ?>">
 <input type="submit" name="redim" value="Redimensionner">
 </p>

<table border="0" cellspacing="0" cellpadding="0">
<?php
 for ($i=0;$i<$sizey;$i++)
 {
  ?><tr><?php
  for ($j=0;$j<$sizex;$j++)
  {
   $c = "c".($i*$sizex+$j);
   ?><td><input type="text" size="1" name="<?php echo $c; ?>" value="<?php echo  $tab[$i][$j]; ?>"></td><?php
  }
  ?></tr><?php
 }
?>
</table>

 <input type="submit" name="test" value="Générer">
 
</form>


<?php
if ($test != "")
{
 // Affiche la grille de réponse.
 ?><h2>Grille remplie</h2>
 <table border="0" cellpadding="0" cellspacing="0">
 <tr><td width="<?php echo $taillex; ?>" height="<?php echo $tailley; ?>">&nbsp;</td><?php for ($j=0;$j<$sizex;$j++) {?><td width="<?php echo $taillex; ?>" align="center" valign="bottom"><?php echo $j+1 ?></td><?php } ?></tr>
 <tr><td height="<?php echo $tailley; ?>" align="right" valign="center">1&nbsp;</td><td colspan="<?php echo $sizex; ?>" rowspan="<?php echo $sizey; ?>">
 <table border="1" cellpadding="0" cellspacing="0" rules="all"><?php
 for ($i=0;$i<$sizey;$i++)
 {
  ?><tr><?php
  for ($j=0;$j<$sizex;$j++)
  {
   ?><td align="center" valign="center" width="<?php echo $taillex; ?>" height="<?php echo $tailley; ?>" bgcolor="<?php if($tab[$i][$j]=='*') {echo $colgris;} else {echo $col;} ?>"><?php if (($tab[$i][$j]=='*') || ($tab[$i][$j]=='')) {echo "&nbsp;";} else {echo strtoupper($tab[$i][$j]);} ?></td><?php
  }
  ?></tr><?php
 }
 ?></table></td></tr>
 <?php for ($j=1;$j<$sizey;$j++) {?><tr><td height="<?php echo $tailley; ?>" align="right" valign="center"><?php echo $j+1 ?>&nbsp;</td></tr><?php } ?></table>
 <?php

 // Affiche la grille vide.
 ?><h2>Grille vierge</h2><table border="1" cellpadding="0" cellspacing="0"><?php
 for ($i=0;$i<$sizey;$i++)
 {
  ?><tr><?php
  for ($j=0;$j<$sizex;$j++)
  {
   ?><td width="<?php echo $taillex; ?>" height="<?php echo $tailley; ?>" bgcolor="<?php if($tab[$i][$j]=='*') {echo $colgris;} else {echo $col;} ?>">&nbsp;</td><?php
  }
  ?></tr><?php
 }
 ?></table><?php



 // Affiche les réponses
 ?><h2>Réponses</h2>
 <h3>Horizontalement</h3><?php
 for ($i=0;$i<$sizey;$i++)
 {
  echo ($i+1).". ";
  for ($j=0;$j<$sizex;$j++)
  {
   if ($tab[$i][$j]=='*')
    { echo ", "; }
    else { echo strtoupper($tab[$i][$j]); }
  }
  echo "<br>";
 }
 ?><h3>Verticalement</h3><?php
 for ($j=0;$j<$sizex;$j++)
 {
  echo ($j+1).". ";
  for ($i=0;$i<$sizey;$i++)
  {
   if ($tab[$i][$j]=='*')
    { echo ", "; }
    else { echo strtoupper($tab[$i][$j]); }
  }
  echo "<br>";
 }
 
}

?>
```

Sur la version Wordpress sur site, il pouvait simplement être inclus avec un shortcode, déclaré dans un fichier `shortcode-motscroises.php` inclus depuis le fichier `functions.php` de votre thème
```php
<?php 

add_shortcode( 'motscroises', 'rp_motscroises_func' );
function rp_motscroises_func( $atts ) {

ob_start();

// Original PHP  ------------------------------

< Include Original PHP script above here >

//// ------------------------

$out = ob_get_contents();
ob_end_clean();
return($out);

	
}

?>
```

Et être utilisé simplement via le shortcode `[motscroises]` dans la page Wordpress de votre choix.



Et sur la version Jekyll, bien sûr plus de PHP!
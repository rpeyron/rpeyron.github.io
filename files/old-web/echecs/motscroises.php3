<?php // Template Top definitions 
 $docRoot="";  while (!file_exists($docRoot . "ROOT")) { $docRoot = $docRoot . "../"; } 
 include ($docRoot . "config.php3"); 
 include ($docRoot . "header.php3"); 
 // ------------------------------------------------------------------------


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


?>

<html>
<head>
 <title>Mots croisés</title>
</head>
<body>

<p>
Ce rapide petit script PHP permet de formatter rapidement une grille de mots croisés et de générer divers vues.</p><p>
Pour l'utiliser, il suffit de rentrer vos lettres dans les cases (pas plus d'une lettre par case), et de mettre '*' pour un noir.
</p>

<?php

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
 Dimensions du damier :&nbsp;X = <input type="text" size="5" name="sizex" value="<?php echo $sizex; ?>">,
 Y = <input type="text" size="5" name="sizey" value="<?php echo $sizey; ?>">
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

</body>
</html>
<?php 
 // ------------------------------------------------------------------------
 // Template Bottom definitions
 include ($docRoot . "footer.php3");
?>
<?php
 /* Paramètres :
  * $load_file = nom du fichier à charger
  * $save_to_file = nom du fichier à sauver
  * $retrograde = inclus les problèmes d'analyse rétrograde
  * $demo = inclus les problemes de demo
  * $all = affiche tous les problèmes
  * $rep = affiche la réponse
  * */

$load_file=$_REQUEST['load_file'];
$save_to_file=$_REQUEST['save_to_file'];
$retrograde=$_REQUEST['retrograde'];
$demo=$_REQUEST['demo'];
$all=$_REQUEST['all'];
$rep=$_REQUEST['rep'];


  // Compatibilité IIS
  if ($REQUEST_URI == "") {$REQUEST_URI=$PATH_INFO;}
?>

<base href="/files/old-web/echecs/" />

<!--<html>
<body>-->

<script type="text/javascript">
<!--
    function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'block')
          e.style.display = 'none';
       else
          e.style.display = 'block';
    }
//-->
</script>

<?php
 
 include "aff_echiquier.php3";
 
 if ($compile != "") {$all = $compile;}
 
?>
<?php

$i = count($tab);
/*
// On peut aussi mettre ca en chaîne. Merci PHP !
$tab[$i]["ech"] =  "TCFDRFCTPPPPPPPP                                pppppppptcfdrfct";   
$tab[$i]["desc"]="Damier normal";
*/
 if ($load_file != "") 
 {
  // Lecture du $tab
  $file = fopen($load_file,"r");
  $contents = fread($file,filesize($load_file));
  //$tab_ = $tab;
  $tab= unserialize($contents);
  //$tab = array_merge ($tab_, $tab);
  fclose($file);
 }


// Echiquier normal
$i = count($tab);
 
if ($retrograde != "0")
{
 $i--;
 require "retrograde.inc.php3";
}

if ($demo != "")
{
 $i--;
 require "demo.inc.php3";
}

$i--;
// Fin de la rétrograde
$i++;
$tab[$i]["ech"] =  array (
   " "," "," ","t"," "," "," "," ",
   "t"," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","r"," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","R"," "," "," ","c"," "," ",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Les Blancs jouent et font MAT en 3 coups.";
$tab[$i]["rep"]="Te7, roi joue, Td2, roie joue, Te1 ou Te3.";
$tab[$i]["expl"]="";
$tab[$i]["diff"]="";

$i++;
$tab[$i]["ech"] =  array (
   " "," "," ","C"," ","c"," ","f",
   "F"," "," "," "," "," "," ","r",
   " "," "," "," "," ","t"," ","c",
   " "," ","T"," ","R"," "," "," ",
   " ","d"," "," ","T"," "," "," ",
   " "," "," "," ","t"," "," ","C",
   "f"," ","F"," "," "," "," "," ",
   " "," "," ","D"," "," "," "," ");
$tab[$i]["desc"]="Les Blancs jouent et font MAT en 2 coups.";
$tab[$i]["rep"]="1/ Te2(menace Cg4 mat), Te3(Fb3, Cf5, Tc7, Te4, Dxe2, Ce6) 2/ Tg6(Dxe4, Cg6, Tf7, Tf5, Cd7, Cf7)";
$tab[$i]["expl"]="";
$tab[$i]["diff"]="";


/* Template
$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="";
$tab[$i]["rep"]="";
$tab[$i]["expl"]="";
$tab[$i]["diff"]="";
*/

 if ($save_to_file != "") 
 {
  // Sauvegarde du $tab
  if ($file = fopen("$save_to_file","w"))
  {
   fputs($file,serialize($tab));
   fclose($file);
   ?>Saved to file.<?php
  }
 } 

?>

<!--
<a href="#custom">Créer votre propre grille.</a>
<br />
<br />
-->
Quelques exemples (analyse rétrograde et problèmes) :
<br /><br />
<!--
<?php // Affiche le sommaire
   for ($j=0; $j<count($tab); $j++) { ?>
   <a href="#<?php echo $j; ?>"><?php echo $tab[$j]["desc"] ?></a><br>
<?php } ?>
-->


<?php // Affiche les plateaux 
  for ($j=0; $j<count($tab); $j++) { ?>
<br><a name="<?php echo $j; ?>"><h2><?php echo $tab[$j]["desc"] ?></h2></a>
<?php aff_echiquier($tab[$j]["ech"],$tab[$j]["decal"]) ?><p>

<div onclick="toggle_visibility('rep<?php echo $j ?>')">Consulter la réponse</div>
<div id="rep<?php echo $j ?>" style="display: none;">
<p>Réponse : <b><?php print($tab[$j]["rep"]); ?></b></p>
<p><u>Explication :</u> <br /><?php print ($tab[$j]["expl"]); ?><p>
</div>

<!--
<?php if ($rep != "") { ?>
Réponse : <b><?php print($tab[$j]["rep"]); ?></b><p>
<u>Explication :</u> <p><?php print ($tab[$j]["expl"]); ?><p>
<?php } else { ?>
<a href="?<?php if ($QUERY_STRING != "") { echo ($QUERY_STRING . "&"); } ?>rep=on#<?php echo $j; ?>">Consulter la réponse</a>
-->

<?php } /* end if */ ?>
<?php } /* end for */?>

<!--

<a name="custom"><h1>Votre propre position</h1></a>
<p>Mettez dans les cases la lettre qui correspond à la pièce. La lettre est en minuscule pour les pièces blanches, et en majuscules pour les pièces noires. Les lettres sont affectées suivant : c = cavalier, d = dame, f = fou, p = pion, r = roi, t = tour, ? = pion indéterminé.</p>
<?php
 if ($custom  != "")
 {
  ?><a name="resu"><h2>Résultat</h2></a><?php
  aff_echiquier(array($c00,$c01,$c02,$c03,$c04,$c05,$c06,$c07,
                      $c10,$c11,$c12,$c13,$c14,$c15,$c16,$c17,
		      $c20,$c21,$c22,$c23,$c24,$c25,$c26,$c27,
		      $c30,$c31,$c32,$c33,$c34,$c35,$c36,$c37,
		      $c40,$c41,$c42,$c43,$c44,$c45,$c46,$c47,
		      $c50,$c51,$c52,$c53,$c54,$c55,$c56,$c57,
		      $c60,$c61,$c62,$c63,$c64,$c65,$c66,$c67,
		      $c70,$c71,$c72,$c73,$c74,$c75,$c76,$c77),0);
  ?><h2>Recommencer</h2><?php
 }

?>
<form action="#resu" method="post">
 <input type="hidden" name="custom" value="oui">
 <table border="0" cellspacing="0" cellpadding="0" style="width: auto"><?php
 for ($i=0;$i<8;$i++)
 {
  ?><tr><td align="right" valign="center"><font size="+1"><?php echo 8-$i; ?>&nbsp;&nbsp;</font></td><?php
  for ($j=0;$j<8;$j++)
  {
   ?><td width="49" height="49" align="center" valign="center" bgcolor="<?php if ( (($i + $j + $d) % 2) == 0 ) {echo "#F0F0F0";} else {echo "#707070";}?>"><?php
    ?><input type="text" name="c<?php echo $i; ?><?php echo $j ?>" size="1" value="<?php $ccc = "c$i$j"; echo $$ccc;?>"><?php
   ?></td><?php
  }
  ?></tr><?php
 }
 ?><tr><td height="30">&nbsp;</td>
 <td align="center" valign="bottom"><font size="+1">A</font></td>
 <td align="center" valign="bottom"><font size="+1">B</font></td>
 <td align="center" valign="bottom"><font size="+1">C</font></td>
 <td align="center" valign="bottom"><font size="+1">D</font></td>
 <td align="center" valign="bottom"><font size="+1">E</font></td>
 <td align="center" valign="bottom"><font size="+1">F</font></td>
 <td align="center" valign="bottom"><font size="+1">G</font></td>
 <td align="center" valign="bottom"><font size="+1">H</font></td></tr><tr>
   <td colspan="4" align="center"><br><input type="submit" value="Voir"></td>
   <td colspan="4" align="center"><br><input type="reset" value="Zero"></td>
 </tr></table>

</form>

-->

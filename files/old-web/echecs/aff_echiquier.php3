<?php

// Echiquier
//  Majuscules => Noir, Minuscules => Blancs
//  p=pion, t=tour, c=cheval, f=fou, d=dame, r=roi

$ech[0] =  array (
   "T","C","F","D","R","F","D","T",
   "P","P","P","P","P","P","P","P",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   "p","p","p","p","p","p","p","p",
   "t","c","f","d","r","f","d","t");

// Affiche l'echiquier
function aff_echiquier($e,$d)
{
 $sizex = 8;
 $sizey = 8;
 ?><table border="0" cellspacing="0" cellpadding="0" style="width: auto"><?php
 for ($i=0;$i<$sizey;$i++)
 {
  ?><tr><td align="right" valign="center"><font size="+1"><?php echo 8-$i; ?>&nbsp;&nbsp;</font></td><?php
  for ($j=0;$j<$sizex;$j++)
  {
   ?><td bgcolor="<?php if ( (($i + $j + $d) % 2) == 0 ) {echo "#F0F0F0";} else {echo "#707070";}?>"><?php
    ?><img border="0" src="<?php 
                              $p=$e[$i*$sizex+$j];
			      if ((strtolower($p) == " ") || (strtolower($p)==""))
			      {
			       print("blank.gif");
			      }
			      else if (strtolower($p) == "?")
			      {
			       print("question.gif");
			      }
			      else 
			      {
			       if (strtolower($p)==$p)
			       {
			        print(strtolower($p)."_b.gif");
			       }
			       else
			       {
			        print(strtolower($p)."_n.gif");
 			       }
			      }
                            ?>"><?php
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
 <td align="center" valign="bottom"><font size="+1">H</font></td></tr>
 </table><?php
}

?>


<?php

$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," ","R"," "," "," ",
   " "," "," "," "," ","P"," "," ",
   " "," ","D"," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," ","f"," ",
   " ","p"," ","p"," ","r"," "," ",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Prouver qu'un pion a atteint la huitième position.";
$tab[$i]["rep"]="Le fou est promu";
$tab[$i]["expl"]="Le fou blanc de la rein n'est pas sorti puisque les deux pions n'ont pas bougé. C'est donc un pion arrivé en huitième position.";
$tab[$i]["diff"]=":-)";

$i++;
$tab[$i]["ech"] =  array (
   "R"," ","r"," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," ","p",
   " "," "," "," "," "," ","f"," ");
$tab[$i]["desc"]="Les noirs ont joué en dernier. Quel a été leur dernier coup et celui des blancs ?";
$tab[$i]["rep"]="Le roi noir a mangé le cavalier blanc en e8.";
$tab[$i]["expl"]="Problème : comment le fou est arrivé à mettre en échec le roi noir.<p>Les noirs ont mangé avec leur roi une pièce blanche en a8.<p>Cette pièce couvrait l'échec du fou, en b6, donc c'est un cavalier : Les blancs ont déplacés le cavalier de b6 en a8.";
$tab[$i]["diff"]=":-)";

$i++;
$tab[$i]["ech"] =  array (
   "T"," "," ","D","R"," "," ","T",
   "P","P","P"," ","P","P"," ","P",
   " "," ","C"," ","P"," "," ","P",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","p"," "," "," "," "," "," ",
   "c","p","p","p","p","p","p","p",
   "t"," "," "," ","r"," "," ","t");
$tab[$i]["desc"]="Sur quelle case la reine blanche a-t'elle été capturée ?";
$tab[$i]["rep"]="h6";
$tab[$i]["expl"]="Il manque aux blancs 2 fous qui n'ont pas pu sortir, un cavalier et la reine, au noir deux fous.<p>Le pion c3 a donc mangé le fou blanc, qui est sorti avant la reine, donc e6 avait déjà mangé le cavalier. C'est donc le pion h6 qui a mangé la reine.";
$tab[$i]["diff"]=":-)";

$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," ","R"," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","r"," "," "," "," "," "," ",
   " "," "," "," "," "," ","?"," ",
   " "," "," ","p"," ","p"," "," ",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Partie Monochromatique. Quelle est la couleur du pion placé en g3 ?";
$tab[$i]["rep"]="Noir";
$tab[$i]["expl"]="Pour que l roi blanc soit sorti, il a nécessairement roqué. Pour les même raison, le pion est noir, sinon il n'aurait pas permis au roi de sortir.";
$tab[$i]["diff"]=":-)";

$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," ","R"," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","p"," ","p"," "," "," "," ",
   " "," "," "," ","r"," "," "," ");
$tab[$i]["desc"]="Partie Monochromatique. Le roi blanc a fait moins de 14 mouvements. Prouver qu'un pion blanc a été promu.";
$tab[$i]["rep"]="Qui a pris le cavalier b8 ?";
$tab[$i]["expl"]="Sur une monochromatique, les cavaliers ne peuvent pas se déplacer : ils ont été pris sur leur case.<p>Qui a pu prendre le cavalier b8 ? Ni les cavaliers (aucun déplacement), ni les fous (le noir n'est pas sorti, le blanc n'est pas la bonne couleur), ni les tours (qui se déplacent de deux cases dans une partie monochromatique), ni le roi. Donc soit par un fou, ou une dame promue, soit par un pion qui allait être promu.";
$tab[$i]["diff"]=":-|";

$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," ","R"," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," ","?"," "," "," ",
   " "," "," "," ","?"," "," "," ",
   " "," "," ","p"," ","p"," "," ",
   " "," "," "," ","r"," "," "," ");
$tab[$i]["desc"]="Partie Monochromatique. Le fou (indiqué ici en double point d'interrogation) est-il sur une case blanche ou une case noire ?";
$tab[$i]["rep"]="Noire";
$tab[$i]["expl"]="D'un carnage il reste forcément des survivants, un qui a mangé en dernier les autres.<p>Qui a fait disparaître les pièces noires : les pions et le roi blanc n'ont pas bougé ; il faut que le fou soit sur une case noire.";
$tab[$i]["diff"]=":-)";

?>
<?php

$i++;
$tab[$i]["ech"] =  array (
   " "," ","C","t"," "," "," ","r",
   "P","R"," ","t","P"," ","P"," ",
   "P"," "," ","P"," "," "," "," ",
   "p"," ","P"," "," "," "," "," ",
   " ","p","P"," "," "," "," ","?",
   " "," ","p","p"," "," ","p"," ",
   " "," "," "," ","p"," "," ","p",
   "C"," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Quelle est la pièce en h4 ?";
$tab[$i]["rep"]="Un fou blanc";
$tab[$i]["expl"]="Il y a échec, c'est donc aux noirs de jouer. Les blancs ont joué au boup précédent le pion c7xd8. Quelle était la pièce en d8 ? Ni une tour, ni une dame, sinon il y aurait eu échec des blancs, mais pas de cases pour y venir (sans provoquer l'échec), donc il s'agit d'un cavalier ou d'un fou. Le fou de f8 n'est pas sorti. Il s'agit donc soit d'un cavalier, soit d'un fou promu par le pion h7 qui n'a pu manger qu'une fois (sinon problème de nombre de pièces blanches) et manger en g1 (NB: Compter le nombre de pièces blanches prises sur une case blanche.). Le ? ne peut pas être noir : ni de dame, ni de tour sinon échec, ni de pion, ni de cavalier, ni de fou car il y aurait des problèmes de comptes. Un pion promu a pris sur g2 (sinon problème de comptes : 6 captures noires et le fou est pris sur sa case), donc 5 prises sur cases blanches. Il ne reste donc que le fou.";
$tab[$i]["diff"]=":-(";
?>
<?php
$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," ","R"," "," ","T",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," ","P"," "," "," "," "," ",
   " "," "," "," "," ","p"," "," ",
   " "," ","p"," "," ","p","p"," ",
   " "," "," ","F"," ","t","r"," ");
$tab[$i]["desc"]="Trait aux Noirs. Pas de prises au dernier coup. Les noirs ont-ils le droit de roquer ?";
$tab[$i]["rep"]="Non";
$tab[$i]["expl"]="Dernier mouvement des blancs : ni un pion, ni une tour (sinon échec). Si le roi a bougé, c'est que la tour est venue mettre le roi en échec, donc pas le droit de roquer. Si le roi n'a pas bougé, les blancs ont roqué. <p>Quel est le dernier mouvement des noirs ? On élimine le roi et la tour. S'ils ont bougé le pion, alors les blancs au coup d'avant ont fait ef3 et le fou est promu, mais le pion en passant pour la promotion aurai mis le roi en échec. Si le fou a bougé de e2, les blancs n'auraient rien pu faire : le roi aurait été en échec sur sa trajectoire.";
$tab[$i]["diff"]=":-(";
?>
<?php

$i++;
$tab[$i]["ech"] =  array (
   " "," "," ","D"," ","T","R"," ",
   " ","P"," ","P","P","P","P"," ",
   " "," "," "," "," ","C"," "," ",
   " "," "," "," "," "," ","c"," ",
   " "," "," "," "," "," ","c"," ",
   " "," "," "," "," "," "," "," ",
   " ","p","p","p","p","p","p"," ",
   "t"," ","f","r","d","f"," ","t");
$tab[$i]["desc"]="Trait aux blancs. Mat en 1 coup !";
$tab[$i]["rep"]="Les côtés sont inversés. Cf6 Mat.";
$tab[$i]["expl"]="Les blancs ne sont pas de leur coté de départ, sinon ils n'auraient pas pu échanger les positions du roi et de la rein. Donc les pions noirs ne peuvent pas prendre par derrière, donc le cavalier en f6 met mat.";
$tab[$i]["diff"]=":-)";

$i++;
$tab[$i]["ech"] =  array (
   " "," ","F","D"," "," "," ","T",
   "F"," ","P"," ","P"," "," "," ",
   " ","p"," "," "," ","C"," "," ",
   "T"," "," ","P"," "," "," "," ",
   " "," "," ","d"," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " ","p","p"," ","f","t"," "," ",
   "t"," ","r"," ","R"," "," "," ");
$tab[$i]["desc"]="Trait aux blancs. Mat en 1 coup !";
$tab[$i]["rep"]="Plateau tourné de 90° : g4 ou fe8.";
$tab[$i]["expl"]="La case en bas à droite est noire : le damier est tourné de 90°<p>Quel que soit le sens, mat : dans un sens, g4 mat, dans l'autre fe8 mat.";
$tab[$i]["diff"]=":-)";
$tab[$i]["decal"]=1;

$i++;
$tab[$i]["ech"] =  array (
   "T"," "," ","D","R"," ","C","T",
   "P","P"," "," ","P","P","P","P",
   " ","P","P"," "," "," "," "," ",
   " "," "," "," "," ","?"," "," ",
   " "," "," "," "," ","?"," "," ",
   " "," "," "," "," "," ","p"," ",
   "p","p","p","p"," "," ","p","p",
   "t"," "," ","d","r"," ","c","t");
$tab[$i]["desc"]="Quelle est la position du pion (position représentée par deux points d'interrogation ici) ? ";
$tab[$i]["rep"]="En haut";
$tab[$i]["expl"]="Il manque aux noirs et aux blancs un cavalier, un fou blanc et un fou noir qui n'est pas sorti. Les deux pions ont donc mangé 1 cavalier (case noire) et un fou blanc (case blanche).<p>Pour que le fou blanc noir soit sorti, il faut que le fou blanc blanc se soit fait manger, c'est à dire que le pion f soit avancé.";
$tab[$i]["diff"]=":-|";

$i++;
$tab[$i]["ech"] =  array (
   "T"," "," ","D","R"," "," ","T",
   "P"," ","P"," "," ","P","P","P",
   " ","P","C"," "," ","C"," "," ",
   " ","c","F"," ","P"," ","f"," ",
   " "," "," "," "," ","p"," "," ",
   " "," ","p"," ","p"," "," ","c",
   "p","p","p","d"," "," ","p","p",
   " "," ","r","t"," "," "," ","t");
$tab[$i]["desc"]="Le dernier coup est f4. Il n'y a pas eu de promotion. D'où vient ce pion f4 ?";
$tab[$i]["rep"]="f3";
$tab[$i]["expl"]="Il ne peut venir que de f2, f3, g3. Pas de g3 sinon il y aurait eu trois prises noires, or il ne manque que 2 pions.<p>Seul un pion a pu se faire manger en c3 car c'est une case noire. Pounr y arriver, le pion a mangé le fou blanc pour aller en colonne c. Donc le pion en a été avancé avant dc3. Or il barre le passage à la sortie du fou noir qui n'a pu sortir que si le pion était en f3.";
$tab[$i]["diff"]=":-|";

$i++;
$tab[$i]["ech"] =  array (
   "T"," "," ","D","R"," "," ","T",
   "P"," ","P","P"," ","P","F","P",
   "C"," ","P"," ","P","C","P"," ",
   " "," "," "," "," "," "," "," ",
   "f"," ","p"," "," ","p"," "," ",
   "c","p"," "," "," ","p"," ","c",
   "p"," "," ","p"," "," ","p","p",
   " "," "," ","d","r"," "," "," ");
$tab[$i]["desc"]="Cette situation est impossible. Prouvez le.";
$tab[$i]["expl"]="Pb: comment est arrivé le fou blanc à sa position.<p>Pour sortir le fou blanc, il a fallut que le fou noir de la reine soit pris en f3, donc le pion noir deait avoir pris quelque chose.<p>Ce quelque chose ne peut être que la tour de la reine car l'autre ne peut pas sortir. Le fou de la reine étant sorti, les pions étaient déjà comme ça avant que le fou blanc ne sorte. Alors comment peut-il arriver ici ?";
$tab[$i]["rep"]="Comment est arrivé le fou blanc ?";
$tab[$i]["diff"]="";

$i++;
$tab[$i]["ech"] =  array (
   "t","F","f"," "," "," "," "," ",
   "C"," ","P"," "," ","P","P"," ",
   " "," ","f"," ","P"," "," "," ",
   "p","P","r","P"," "," "," "," ",
   "R","p"," ","p"," "," "," "," ",
   "P"," ","P"," "," "," "," ","p",
   "p"," ","p"," "," "," "," ","p",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Trait aux Blancs. Mat en un coup !";
$tab[$i]["rep"]="Prise en passant a5b6";
$tab[$i]["expl"]="Pion d3 venu en h7 : Prise 4 des 5 pièces blanches. Donc aucun pion n'est sorti de sa colonne et n'a mangé. Les noirs n'ont pas pu jouer autrement qu'un pion. Ce n'est pas avec d3 (parcequ'il vient de e4) Ce n'est pas e6 (car sinon le pion blanc n'aurait pas pu être promu). Ni d6d5 sinon roi en échec, ni d7 sinon le fou promu n'aurait pas pu quitter e8. donc on a joué avec b5. Il ne pouvait pas venir de b6, sinon le roi était en échec : donc b7b5, prise en passant possible.";
$tab[$i]["diff"]=":-(";

$i++;
$tab[$i]["ech"] =  array (
   " "," "," "," "," "," "," ","T",
   "P","P","P","P","P","r","P","p",
   " "," "," "," "," "," ","p"," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ",
   "C"," "," "," "," "," "," "," ",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Pendant les 5 derniers mouvements, aucun pion n'a bougé, aucune pièce prise. Où est le roi noir ?";
$tab[$i]["rep"]="c8";
$tab[$i]["expl"]="Pour éviter un pat rétrograde des blancs, il faut que le roi soit en c8.<p>Les noirs roquent: roi en c8, tour en d8. Le blanc est venu sur sa case, la tour s'est déplacée en h8.";
$tab[$i]["diff"]=":-|";

$i++;
$tab[$i]["ech"] =  array (
   "T"," "," "," ","R","D","t"," ",
   " ","P"," ","P","P","P"," "," ",
   " "," "," "," "," ","f","P","p",
   " "," "," "," "," "," ","p","c",
   " "," "," "," ","p"," "," ","P",
   " "," "," ","d"," ","p"," "," ",
   " "," ","p","r"," "," ","P","p",
   " "," "," "," "," "," "," "," ");
$tab[$i]["desc"]="Trait aux Blancs. Mat en deux coups.";
$tab[$i]["rep"]="Dd6";
$tab[$i]["expl"]="Dame en d6.<br>Ensuite mat avec la tour, la Dame ou le Cavalier suivant la réponse des noirs.<p>Les noirs ne peuvent pas roquer : deux pions ont été promus, dont un en e8, donc la tour de la reine a bougé (4 cas à examiner...)";
$tab[$i]["diff"]=":-(";


// Source : Analyse rétrograde ! Mystères sur l'échiquier avec Sherlock Holmes. Raymond Smullyan.



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

?>

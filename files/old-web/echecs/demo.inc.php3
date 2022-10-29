<?php
// Petie selection pour le web

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

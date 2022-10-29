type liste {
 mutable valeur : 'a
 muitable suiv : 'a liste };;
type liste = {
 mutable valeur : 'a
 muitable suiv : 'a liste };;
type liste = {
 mutable valeur of 'a
 muitable suiv : 'a liste };;
type liste = {
 mutable valeur : int
 muitable suiv : 'a liste };;
type 'a liste = {
 mutable valeur : 'a
 muitable suiv : 'a liste };;
type 'a liste = {
 mutable valeur : 'a;
 muitable suiv : 'a liste };;
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
let x = (valeur = 1, (valeur = 2, (valeur = 3, NUL)));
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
let x = (valeur = 1, (valeur = 2, (valeur = 3, NUL)));;
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
let x = (valeur = 1; (valeur = 2, (valeur = 3, NUL)));;
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
let x = {valeur = 1; {valeur = 2, {valeur = 3, NUL}}};;
type 'a liste = {
 mutable valeur : 'a;
 mutable suiv : 'a liste };;
let x = {valeur = 1; {valeur = 2; {valeur = 3; NUL}}};;
type 'a liste = 
 | liste_vide
 | Liste of mutable 'a*('a liste)
type 'a liste = 
 | liste_vide
 | Liste of mutable 'a*('a liste);;
type 'a liste = 
 | liste_vide
 | Liste of mutable 'a*('a liste);;
type 'a liste = 
 | liste_vide
 | Liste of mutable 'a*('a liste);;
let x = Liste (1,Liste(2,Liste(3,Liste_vide)));;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let x = Liste (1,Liste(2,Liste(3,Liste_vide)));;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste (x,y)) -> x := e;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
 
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x <- e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ref 'a* ref('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x <- e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ref 'a* ref('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref 'a)* ref('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref 'a)* (ref('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref int)* (ref('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref 'a)* (ref ('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref int)* (ref ('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable (ref int)* (ref (int liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type int. liste = 
 | Liste_vide
 | Liste of mutable (ref int)* (ref (int liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type int liste = 
 | Liste_vide
 | Liste of mutable (ref int)* (ref (int liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x := e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> Liste (x,y) <- Liste (e,y);;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste));;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = ref Liste (1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (1,Liste_vide);; 
let y = ref x;;
rplaca (5,y);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,y);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
type 'a liste = 
 | Liste_vide
 | Liste of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste (ref x,y) of mutable 'a*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ('a ref)*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ('a ref)*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ('a)*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ('a)*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x:=e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
x;;
type 'a liste = 
 | Liste_vide
 | Liste of mutable ('a)*('a liste);;
let rplaca=function
 | (e,Liste_vide) -> failwith "Erreur"
 | (e,Liste (x,y)) -> x<-e;;
let x = Liste (ref 1,Liste_vide);; 
rplaca (5,x);;
x;;
let 'a essai == 'a ref list ;;
type 'a essai == 'a ref list ;;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x := MListe [1;2;3;4;5;6;7;8;9];;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function 
 | ([],e) -> []
 | (t::q,e) -> t:=e;;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function 
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function 
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function 
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rec MListe = function
 | [] -> ref []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rec rplacb = function
 | (x,b) -> b
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rec rplacb = function
 | (x,b) -> b
let rec MListe = function
 | [] -> []
 | t::q -> (ref t)::MListe(q);;
let x = MListe [1;2;3;4;5;6;7;8;9];;
let rplaca = function
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rec rplacb = function
 | ([],b) -> failwith "mmmh"
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref MListe(q));;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste ((ref t),(ref MListe(q)));;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a ref list ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x := MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x := MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x := MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*(('a liste) ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*(('a liste) ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*(('a liste) ref);;
let MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*(('a liste) ref);;
let rec MListe = function
 | [] -> Liste_vide
 | t::q -> Liste (ref t,ref (MListe(q)));;
let x = MListe [1;2;3;4;5;6;7;8];;
let rplaca = function 
 | ([],e) -> ()
 | (t::q,e) -> t:=e;;
rplaca (x,5);;
x;;
let rplacb = function
 | ([],e) -> ()
 | (t::q,e) -> q := e;;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref)
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
type 'a liste = 
 | Liste_vide
 | Liste of ('a ref)*('a liste ref);;
let x = Liste (1,Liste_vide);;

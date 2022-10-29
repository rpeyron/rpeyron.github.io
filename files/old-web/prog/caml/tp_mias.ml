(* (c) Rémi Peyronnet 02/04/2002 *)

exception ArgError of string;;

let bissextile = function
        | x when ((x mod 400) = 0) -> true
        | x when ( ((x mod 100) <> 0) & ((x mod 4) = 0) ) -> true
        | _ -> false;;
        
let nb_jours_dans_mois = function
        | (a,1) -> 31
        | (a,2) when (bissextile(a)) -> 29
        | (a,2) -> 28
        | (a,3) -> 31
        | (a,4) -> 30
        | (a,5) -> 31
        | (a,6) -> 30
        | (a,7) -> 31
        | (a,8) -> 31
        | (a,9) -> 30
        | (a,10) -> 31
        | (a,11) -> 30
        | (a,12) -> 31
        | _ ->  raise(ArgError "Mois incorrect");;

let nb_jours_annee = function 
        | a when bissextile(a) -> 366
        | _ -> 365;;
        
let rec nb_jours_depuis_debut_annee = function
        | (a,1,jm) -> jm
        | (a,i,jm) -> nb_jours_dans_mois(a,i-1) +
        nb_jours_depuis_debut_annee(a,i-1,jm);;

        
type date = 
        {
                js : int;
                jm : int;
                m  : int;
                a  : int;
        };;
        
let verifie_date = function
        | (js,jm,m,a) when ((js < 1) or (js > 7)) -> false
        | (js,jm,m,a) when ((m < 1) or (m > 12)) -> false
        | (js,jm,m,a) when ((jm < 1) or (jm > nb_jours_dans_mois(a,m))) -> false
        | _ -> true;;

let jour_semaine = function d -> d.js;;
let jour_mois = function d -> d.jm;;
let mois = function d -> d.m;;
let annee = function d -> d.a;;

let jour_en_toutes_lettres = function
        | 1 -> "lundi"
        | 2 -> "mardi"
        | 3 -> "mercredi"
        | 4 -> "jeudi"
        | 5 -> "vendredi"
        | 6 -> "samedi"
        | 7 -> "dimanche"
        | _ -> raise(ArgError "Jour inconnu");;

let mois_en_toutes_lettres = function
        | 1 -> "janvier"
        | 2 -> "février"
        | 3 -> "mars"
        | 4 -> "avril"
        | 5 -> "mai"
        | 6 -> "juin"
        | 7 -> "juillet"
        | 8 -> "août"
        | 9 -> "septembre"
        | 10 -> "octobre"
        | 11 -> "novembre"
        | 12 -> "décembre"
        | _ -> raise(ArgError "Mois inconnu");;

let date_en_toutes_lettres = function d -> jour_en_toutes_lettres(d.js) ^ " " ^
string_of_int(d.jm) ^ " " ^ mois_en_toutes_lettres(d.m) ^ " " ^
string_of_int(d.a);;

let make_date = function (mjs,mjm,mm,ma) -> {js=mjs; jm=mjm; m=mm; a=ma};;

let date_cmp = function
        | (d1,d2) when (d1.a < d2.a) -> -1
        | (d1,d2) when ( (d1.a = d2.a) & (d1.m < d2.m) ) -> -1
        | (d1,d2) when ( (d1.a = d2.a) & (d1.m = d2.m) & (d1.jm < d2.jm) ) -> -1
        | (d1,d2) when ( (d1.a = d2.a) & (d1.m = d2.m) & (d1.jm = d2.jm) ) -> 0
        | _ -> 1;;

let lendemain = function (d) -> 
    let mjs = ref d.js and
        mjm = ref d.jm and
        mm = ref d.m and
        ma = ref d.a in 
       begin
        if (!mjs = 7) then mjs := 1 else mjs := !mjs + 1;
        if (!mjm = nb_jours_dans_mois(!ma,!mm)) then
                begin
                        mjm := 1;
                        if (!mm = 12) then begin mm := 1; ma := !ma + 1; end 
                                     else mm := !mm + 1;
                end
                else mjm := !mjm + 1;
        make_date(!mjs,!mjm,!mm,!ma);         
       end;;

let veille = function (d) -> 
    let mjs = ref d.js and
        mjm = ref d.jm and
        mm = ref d.m and
        ma = ref d.a in 
       begin
        if (!mjs = 1) then mjs := 7 else mjs := !mjs - 1;
        if (!mjm = 1) then
                begin
                        mjm := nb_jours_dans_mois(!ma,!mm);
                        if (!mm = 1) then begin mm := 12; ma := !ma - 1; end 
                                     else mm := !mm - 1;
                end
                else mjm := !mjm - 1;
        make_date(!mjs,!mjm,!mm,!ma);         
       end;;


       
let nb_jours_entre_dates = function (d1,d2) -> 
        nb_jours_annee(d1.a) - nb_jours_depuis_debut_annee(d1.a,d1.m,d1.jm) +
        (d2.a - d1.a) * 365 + ((d2.a - d1.a) / 4) - ((d2.a - d1.a) / 100) +
        ((d2.a - d1.a) / 400) +
        nb_jours_depuis_debut_annee(d2.a,d2.m,d2.jm) - nb_jours_annee(d2.a);;
        
let jour_naissance = function (d1,d2) ->
        {js=(((d1.js-1) + (nb_jours_entre_dates(d1,d2) mod 7)) mod 7) + 1;
         jm=d2.jm;m=d2.m;a=d2.a};;
       
let rec min_date_rec = function 
        | ([],d) -> d
        | (t::q,d) when (date_cmp(t,d) = -1) -> min_date_rec(q,t)
        | (t::q,d) -> min_date_rec(q,d);;
let min_date = function 
        | t::q -> min_date_rec (q,t)
        | [] -> raise (ArgError "Liste vide");;


(* Examples *)         
print_endline(string_of_bool(verifie_date(2,28,3,2002)));;        
print_endline(string_of_int(nb_jours_depuis_debut_annee(1992,3,12)));;        
print_endline(date_en_toutes_lettres(make_date(2,2,4,2002)));;
print_endline(string_of_int(date_cmp(make_date(2,1,4,2003),make_date(2,2,4,2002))));;
print_endline(date_en_toutes_lettres(lendemain(make_date(6,31,3,2001))));;
print_endline(date_en_toutes_lettres(veille(make_date(6,1,1,2001))));;
print_endline(string_of_int(nb_jours_entre_dates(make_date(2,2,4,2002),make_date(2,17,3,1980))));;
print_endline(date_en_toutes_lettres(jour_naissance(make_date(2,2,4,2002),make_date(-1,17,3,1980))));;
print_endline(date_en_toutes_lettres(min_date(make_date(6,1,1,2000)::make_date(6,1,1,2001)::make_date(6,1,1,2001)::make_date(6,1,1,1901)::make_date(6,1,1,2001)::make_date(6,1,1,2001)::[])));;

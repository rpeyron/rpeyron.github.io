let hd = function
let hd = function
 | t::q -> t
 | _ -> failwith "Pas une liste";;
let hd = function
 | t::q -> t
 | _ -> failwith "Pas une liste";;
let tl = function
 | t::q -> q
 | _ -> failwith "Pas une liste";;
let tl = function
 | t::q -> q
 | _ -> failwith "Pas une liste";;
1::2::3::4::[];;
let rev = function 
 | [] -> []
 | t::q -> rev(q)@[t];;
let rev = function 
 | [] -> []
 | t::q -> rev(q)@[t];;
rev ([1;2;3;4;5;6]);
let rev = function 
 | [] -> []
 | t::q -> rev(q)@[t];;
rev ([1;2;3;4;5;6]);;
let rev = function 
 | [] -> []
 | t::q -> rev(q)@[t];;
rev ([1;2;3;4;5;6]);;
let rec list_len = function
 | [] -> 0
 | t::q -> 1 + list_len (q)
 | _ -> failwith "Pas une liste";;
list_len ([1;2;3;4;5;6;7;8;9;0]);;
let rec colle = function
 | ([],b) -> b
 | (t::q,b) -> t::colle(q,b);;
let rec colle = function
 | ([],b) -> b
 | (t::q,b) -> t::colle(q,b);;
colle([1;2;3;4],[5;6;7;8;9]);;
let rec elim = function
 | ([],e) -> []
 | (t::q,e) when (t=e) -> elim (q,e)
 | (t::q,e) -> t::elim (q,e);;
elim ([1,2,3,1,4,2,6,1,5,1,5,1,4],1);;
let rec elim = function
 | ([],e) -> []
 | (t::q,e) when (t=e) -> elim (q,e)
 | (t::q,e) -> t::elim (q,e);;
elim ([1,2,3,1,4,2,6,1,5,1,5,1,4]);;
let rec elim = function
 | ([],e) -> []
 | (t::q,e) when (t=e) -> elim (q,e)
 | (t::q,e) -> t::elim (q,e);;
elim ([1,2,3,1,4,2,6,1,5,1,5,1,4]);;
let rec elim = function
 | ([],e) -> []
 | (t::q,e) when (t=e) -> elim (q,e)
 | (t::q,e) -> t::elim (q,e);;
elim ([1;2;3;1;4;2;6;1;5;1;5;1;4]);;
let rec elim = function
 | ([],e) -> []
 | (t::q,e) when (t=e) -> elim (q,e)
 | (t::q,e) -> t::elim (q,e);;
elim ([1;2;3;1;4;2;6;1;5;1;5;1;4],1);;
let rec doublons = function
 | [] -> []
 | (t::q) -> elim (q,t);;
let rec doublons = function
 | [] -> []
 | (t::q) -> elim (q,t);;
doublons ([1,2,3,1,2,1,5]);
let rec doublons = function
 | [] -> []
 | (t::q) -> elim (q,t);;
doublons ([1,2,3,1,2,1,5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> elim (q,t);;
doublons ([1,2,3,1,2,1,5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> elim (q,t);;
doublons ([1;2;3;1;2;1;5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> doublons(elim (q,t));;
doublons ([1;2;3;1;2;1;5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> doublons(elim (q,t));;
doublons ([1;2;3;1;2;1;5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> t::elim (q,t);;
doublons ([1;2;3;1;2;1;5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> t::doublons(elim (q,t));;
doublons ([1;2;3;1;2;1;5]);;
let rec doublons = function
 | [] -> []
 | (t::q) -> t::doublons(elim (q,t));;
doublons ([1;2;3;1;2;1;5;5;5;5;5;5;5;5]);;
let app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre (q,b);;
let app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b);;
let app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([x->x-1;x->x-2;x->x-3;x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(x->x-1);x->x-2;x->x-3;x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);x->x-2;x->x-3;x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);function x->x-2;x->x-3;x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);function x->x-2;function x->x-3;x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);function x->x-2;function x->x-3;function x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);function x->x-2;function x->x-3;function x->x-4],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
app_ordre ([(function x->x-1);(function x->x-2);(function x->x-3;function x->x-4)],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
let f(x)=x+1
app_ordre ([f;f;f;f],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
let f(x)=x+1;;
app_ordre ([f;f;f;f],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
let f(x)=x+1;;
let f2(x)=x+2;;
app_ordre ([f;f2;f;f2],[1;2;3;4]);;
let rec app_ordre = function
 | (t,q) when (t=[] or q=[]) -> []
 | (t::q,a::b) -> t(a)::app_ordre(q,b)
 | _ -> failwith "Bizarre";;
 
let f(x)=x+1;;
let f2(x)=x+2;;
app_ordre ([f;f2;f;f2],[1;2;3;4]);;
let rec inlist = function
let rec inlist = function
let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;

let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;

let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;

let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;
let f(x,y)=x+y;;
let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;
let f(x,y)=x+y;;
inlist (f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;
let f(x,y)=x+y;;
inlist (f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist);;
let f(x,y)=x+y;;
inlist(f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[]) -> []
 | (f,t::q) -> f(t,inlist(f,q));;
let f(x,y)=x+y;;
inlist(f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[a]) -> f(a)
 | (f,t::q) -> f(t,inlist(f,q));;
let f(x,y)=x+y;;
inlist(f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[a]) -> a
 | (f,t::q) -> f(t,inlist(f,q));;
let f(x,y)=x+y;;
inlist(f,[1,2,3,4,5,6]);;
let rec inlist = function
 | (f,[a]) -> a
 | (f,t::q) -> f(t,inlist(f,q));;
let f(x,y)=x+y;;
inlist(f,[1;2;3;4;5;6]);;
let rec inlist = function
 | (f,[a]) -> a
 | (f,t::q) -> f(t,inlist(f,q));;
let f(x,y)=x*y;;
inlist(f,[1;2;3;4;5;6]);;
let max = function t::q 
 let max_int = function (q,t) -> t;;
 in max_int (q,t);;
let max = function t::q 
 let max_int = function (q,t) -> t;;
 in max_int (q,t);;
let max = function t::q 
 let max_int = function (q,t) -> t
 in max_int (q,t);;
let max = function t::q 
 let max_int = function (q,t) -> t
 in max_int (q,t);;
let max = function l 
 let rec max_int = function (q,t) -> t
 in max_int (q,t);;
let max = function l =
 let rec max_int = function (q,t) -> t
 in max_int (q,t);;
let max l =
 let rec max_int = function (q,t) -> t
 in max_int (q,t);;
let max t::q =
 let rec max_int = function (q,t) -> t
 in max_int (q,t);;
let max = function
 (t::q) ->
 let rec max_int = function (q,t) -> t
 in max_int (q,t);;
let max = function
 (t::q) ->
 let rec max_int = function (q,t) -> t
 in max_int (q,t)
 _ -> failwith "error";;
let max = function
 | (t::q) ->
 let rec max_int = function (q,t) -> t
 in max_int (q,t)
 | _ -> failwith "error";;
let max = function
 | (t::q) ->
 let rec max_int = function 
  | (a::b,t) when (a>t)-> a
  | _ -> t
 in max_int (q,t)
 | _ -> failwith "error";;
let max = function
 | (t::q) ->
 let rec max_int = function 
  | (a::b,t) when (a>t)-> a
  | _ -> t
 in max_int (q,t)
 | _ -> failwith "error";;
let max = function
 | (t::q) ->
 let rec max_int = function 
  | (a::b,t) when (a>t)-> a
  | _ -> t
 in max_int (q,t)
 | _ -> failwith "error";;
max ([1;2;4;51;2;3;4;8;5]);;
let max = function
 | (t::q) ->
 let rec max_int = function 
  | ([],t) -> t
  | (a::b,t) when (a>t)-> max_int(b,a)
  | (a::b,t) -> max_int(b,t)
 in max_int (q,t)
 | _ -> failwith "error";;
max ([1;2;4;51;2;3;4;8;5]);;
let rec pge = function
 | [a] -> a
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q);;
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q);;
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error"
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";;
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";;
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";;
pge ([1;2;51;223;45;6]);
let rec pge = function
 | [a] -> a
 | a::b::q when (a>b)-> pge (a::q)
 | a::b::q -> pge (b::q)
 | _ -> failwith "error";;
pge ([1;2;51;223;45;6]);;
let rec renvoie_dernier = function
 | [] -> failwith "error"
 | [a] -> [a]
 | t::q -> renvoie_dernier (q);;
let rec2(l) = hd(rev(l));;
let rec renvoie_dernier = function
 | [] -> failwith "error"
 | [a] -> [a]
 | t::q -> renvoie_dernier (q);;
let renvoie_dernier2(l) = hd(rev(l));;
renvoie_dernier ([1;2;3;4;5;6]);;
renvoie_dernier2 ([1;2;3;4]);;
let rec renvoie_dernier = function
 | [] -> failwith "error"
 | [a] -> a
 | t::q -> renvoie_dernier (q);;
let renvoie_dernier2(l) = hd(rev(l));;
renvoie_dernier ([1;2;3;4;5;6]);;
renvoie_dernier2 ([1;2;3;4]);;
let rec dup = function
 | []->[]
 | t::q -> t::t::dup(q);;
let rec dup = function
 | []->[]
 | t::q -> t::t::dup(q);;
dup([1;2;3;4;5]);;
let rec explode = 
 | "" -> []
 | str -> substring(str,1,1)::explode (str,2,string_length(str)-1);;
let rec explode = function
 | "" -> []
 | str -> substring(str,1,1)::explode (str,2,string_length(str)-1);;
let rec explode = function
 | "" -> []
 | str -> sub_string(str,1,1)::explode (str,2,string_length(str)-1);;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (str,2,string_length(str)-1);;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (sub_string str 2 (string_length(str)-1));;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (sub_string str 2 (string_length(str)-1));;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (sub_string str 2 (string_length(str)-1));;
explode ("bonjour");;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (sub_string str 2 (string_length(str)-2));;
explode ("bonjour");;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 1 1)::explode (sub_string str 2 (string_length(str)-2));;
trace "explode";;
explode ("bonjour");;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 0 0)::explode (sub_string str 1 (string_length(str)-1));;
trace "explode";;
explode ("bonjour");;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 0 1)::explode (sub_string str 1 (string_length(str)-1));;
trace "explode";;
explode ("bonjour");;
let rec explode = function
 | "" -> []
 | str -> (sub_string str 0 1)::explode (sub_string str 1 (string_length(str)-1));;
explode ("bonjour");;
let rec implode = function
 | [] -> ""
 | t::q -> t^implode(q);;
implode (["b";"o";"n";"j";"o";"u";r"]);;
let rec implode = function
 | [] -> ""
 | t::q -> t^implode(q);;
implode (["b";"o";"n";"j";"o";"u";r"]);;
let rec implode = function
 | [] -> ""
 | t::q -> t^implode(q);;
implode (["b";"o";"n";"j";"o";"u";"r"]);;
let rec implode = function
 | [] -> ""
 | t::q -> t^implode(q);;
implode (["b";"o";"n";"j";"o";"u";"r"]);;
concat ["b";"o";"n";"j";"o";"u";"r"];;
let rec index = function
 | a [] -> -1
 | a t::q when (t=a) -> 1
 
let rec index = function
 | a [] -> -1
 | a t::q when (t=a) -> 1
 | a t::q -> let n = index a q 
   in if n=-1 then -1 else n+1;;
 
let rec index = function
 | a [] -> -1
 | a t::q when (t=a) -> 1
 | a t::q -> let n = index a q 
   in if n=-1 then -1 else n+1;;
 
let rec index = function
 | (a,[]) -> -1
 | (a,t::q) when (t=a) -> 1
 | (a,t::q) -> let n = index a q 
   in if n=-1 then -1 else n+1;;
 
let rec index = function
 | (a,[]) -> -1
 | (a,t::q) when (t=a) -> 1
 | (a,t::q) -> let n = index a q 
   in if n= (-1) then -1 else n+1;;
 
let rec index = function
 | (a,[]) -> -1
 | (a,t::q) when (t=a) -> 1
 | (a,t::q) -> let n = index(a,q) 
   in if n= (-1) then -1 else n+1;;
 
let appartient(t,x) = if index(t,x) = -1 then false else true;; 
 
appartient (1,[1;5;6;4;8;6;4]);
appartient (1,[1;5;6;4;8;6;4]);;
appartient (41,[1;5;6;4;8;6;4]);;
let rec intersect = function
 | [],b -> []
 | t::q,b when (appartient (t,b)=true) -> t::intersect(q,b)
 | t::q,b -> intersect(q,b)
 | _ -> failwith "zut";;
let rec intersect = function
 | [],b -> []
 | t::q,b when (appartient (t,b)=true) -> t::intersect(q,b)
 | t::q,b -> intersect(q,b);;
let rec intersect = function
 | [],b -> []
 | t::q,b when (appartient (t,b)=true) -> t::intersect(q,b)
 | t::q,b -> intersect(q,b);;
intersect ([1;2;3;4;5;6],[0;5;3;1]);;
let rec union = function
 | [],b -> b
 | t::q,b when (appartient (t,b)=true) -> union(q,b)
 | t::q,b -> t::union(q,b);;
union ([1;2;3;4;5;6],[0;5;3;1]);;
let rec union = function
 | b,[] -> b
 | b,t::q when (appartient (t,b)=true) -> union(q,b)
 | b,t::q -> t::union(q,b);;
union ([1;2;3;4;5;6],[0;5;3;1]);;
let rec union = function
 | b,[] -> b
 | b,t::q when (appartient (t,b)=true) -> union(b,q)
 | b,t::q -> t::union(b,q);;
union ([1;2;3;4;5;6],[0;5;3;1]);;
let sub_ens = function
 | ([],b) -> []
 | (t::q,b) when (appartient (t,b)=false) -> t::sub_ens (q,b)
 | (t::q,b) -> sub_ens (q,b);;
sub_ens ([1;2;3;4;5;6;7;8;9],[2;5;8]);;
let rec sub_ens = function
 | ([],b) -> []
 | (t::q,b) when (appartient (t,b)=false) -> t::sub_ens (q,b)
 | (t::q,b) -> sub_ens (q,b);;
sub_ens ([1;2;3;4;5;6;7;8;9],[2;5;8]);;

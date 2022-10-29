PROGRAM WinFont;
USES WinCrt,WinDOS,Strings,Win31;
VAR I : TSearchRec;
    Na1,Na2,Name, nom, nom2,style: String;
    t,PNa1, PNa2 : ARRAY [0..256] of char;
    FOT : file of byte;
    b,j,c,k : byte;
    D :Text;
    DirNameTTF, DirNameFOT, nomfic : String;
    dt : TDateTime;
CONST DirName = 'C:\PROGRAM\WPASCAL\FONT\';
CONST Title = 'POLICES V1.0 par Rémi Peyronnet 01/01/1998';
BEGIN
 clrscr;
 StrCopy (WindowTitle,'Recherche du nom des polices TTF.');
 Writeln ('POLICES Etat des lieux V 1.0 (RP1998).');
 Write ('Répertoire TTF (def c:\Windows\System\):'); Readln (DirNameTTF);
 If DirNameTTF = '' Then DirNameTTF := 'c:\windows\system\';
 Write ('Répertoire FOT temporaire (def c:\windows\temp\) :'); Readln (DirNameFOT);
 If DirNameFOT = '' Then DirNameFOT := 'c:\windows\temp\';
 Write ('Nom du fichier de dest (def c:\polices.lst) : '); Readln (nomfic);;
 If nomfic = '' Then nomfic := 'c:\polices.lst';
 Assign (D,nomfic);
 Rewrite (D);
 Writeln (D,'Nom du fichier ; Nom de la police ; Style de la police ; ',
         'Taille de la Police ; Date du fichier; Attributs');
 StrPCopy(t,DirNameTTF+'*.TTF');
 FindFirst(t, $FF, I);
 While DosError = 0 do
 Begin
  Name := Copy(I.Name,1,pos('.',I.Name)-1);
  Na1:=DirNameFOT+Name+'.FOT';
  Na2:=DirNameTTF+Name+'.TTF';
  StrPCopy(PNa1,Na1);
  StrPCopy(PNa2,Na2);
  CreateScalableFontResource (0,PNa1,PNa2,NIL);
  Assign (FOT, Na1);
  Reset (FOT);
  Seek (FOT, filesize (FOT)-1);
  b:=1; j:=1; c:=19;
  While not ((b=0) and (c=0)) do
   Begin
    seek (FOT, filesize(FOT)-j); Inc (j);
    read (FOT,b);
    nom[256-j]:=chr(b);
    if b = 0 then Dec (c);
   End;
  Close (FOT);
  Erase (FOT);
  nom2 :='';
  for k:=1 to j do
   nom2 :=nom2+nom[256-j+k];
  k := pos (#0,nom2);   nom2[k]:=#1;
  nom:=copy (nom2,1,k-1);
  style:='';
  style:=copy (nom2,k+1,pos(#0,nom2)-1-k);
  UnPackTime (I.Time,dt);
  Writeln (D,I.Name, ';', nom, ';',style,';',I.Size,';',dt.Day,'/',dt.Month,'/',dt.Year,';',I.Attr);
  Writeln (I.Name, ';', nom, ';',style,';',I.Size,';',dt.Day,'/',dt.Month,'/',dt.Year,';',I.Attr);
  FindNext(I);
 End;
 Close(D);
 Writeln('Opération achevée. Résultats dans: ',nomfic);
END.
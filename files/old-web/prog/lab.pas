PROGRAM Lab;
USES Dos, Crt;
CONST MaxX = 30;
      MaxY = 10;
CONST Trace = False;
CONST Dir1 : ARRAY [1..8] of shortint = (0, 1,1,0,0,-1,-1,0);
      Dir2 : ARRAY [1..8] of shortint = (0, 0,0,0,0,-1,-1,0);
CONST MurX = 1;
      MurY = 2;
      Fait = 4;
      Bord = 8;

VAR Laby 		        : ARRAY [1..MaxY+2,1..MaxX+2] of Byte;
    i, j, k, l, a, b, h ,g   	: Integer;
    Creuse		        : Boolean;

Procedure AffLab;
Begin
 ClrScr;
 For j := 1 To MaxX + 2 do
  For i := 1 To MaxY + 2 do
   Begin
    GotoXY (j*2+1,i*2+1); Write ('Û');
    GotoXY (j*2+1,i*2  ); If ((Laby [i,j] and MurY) <> 0) Then Write ('°');
    GotoXY (j*2  ,i*2+1); If ((Laby [i,j] and MurX) <> 0) Then Write ('°');
   End;
End;

Procedure GenLab;
Var Fin : Boolean;
Begin
 For i := 1 To MaxY+2 do For j := 1 To MaxX+2 do   Laby [i,j] := MurX or MurY;
 For i := 1 To MaxY+2 do Begin Laby [i,1] := 15; Laby [i, MaxX+2] := 15; End;
 For i := 2 To MaxX+1 do Begin Laby [1,i] := 15; Laby [MaxY+2, i] := 15; End;
 Laby [MaxY+1, MaxX+1] := MurX or MurY or Fait;
 Randomize;
 For a := MaxY+1 DownTo 2 do
  For b := MaxX+1 DownTo 2 do
   If (Laby [a,b] and Fait) = 0 Then
    Begin
     Laby [a, b] := Laby [a, b] or Fait;
{ ******** On relie a une case faite. ********* }
     K := Random (4); L := K;
     Repeat
      Inc (K); If K > 3 Then K := 0;
      G := Laby [a+Dir1[K*2+2],b+Dir1[K*2+1]];
     Until (((G and Fait) <> 0) and ((G and Bord) = 0));
     H := Laby [a+Dir2[K*2+2],b+Dir2[K*2+1]];
     If Frac (K/2) = 0 Then H := (H and not MurX);
     If Frac (K/2) <>0 Then H := (H and not MurY);
     Laby [a+Dir2[K*2+2],b+Dir2[K*2+1]] := H;
     If Trace Then Begin AffLab; Readln; End;
{ ******** On creuse ******** }
     i := a; j := b; Fin := False;
     Repeat
      Laby [i,j] := Laby [i,j] or Fait;
      K := Random (4); L := K;
      Repeat
       Inc (K); If K > 3 Then K := 0;
       G := Laby [i+Dir1[K*2+2],j+Dir1[K*2+1]];
      Until (((G and Fait) = 0) or (K = L));
      If ((G and Fait) = 0) Then
       Begin
	H := Laby [i+Dir2[K*2+2],j+Dir2[K*2+1]];
	If Frac (K/2) = 0 Then H := (H and not MurX);
	If Frac (K/2) <>0 Then H := (H and not MurY);
	Laby [i+Dir2[K*2+2],j+Dir2[K*2+1]] := H;
	i := i + Dir1 [K*2+2];
	j := j + Dir1 [K*2+1];
       End
	Else Fin := True;
     If Trace Then Begin AffLab; Readln; End;
     Until Fin;
{ ******** On passe a la suivante ******* }
    End;
End;

BEGIN
 GenLab;
 AffLab;
 Readln;
END.
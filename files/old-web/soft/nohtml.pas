PROGRAM NoHTML;
VAR S, C : FILE of Byte;
    Ch   : Byte;
    B	 : Boolean;
BEGIN
 Writeln ('NoHTML : Suppresseur des tags HTML. (c)1998 RPS.');
 If (ParamCount <> 2) Then
  Begin
   Writeln ('Usage : NoHTML <Entree> <Sortie>');
   Halt (1);
  End;
 Writeln ('En cours de traitement...');
 Assign (S,ParamStr (1));
 Assign (C,ParamStr (2));
 Reset (S);
 Rewrite (C);
 B := True;
 WHILE Not Eof (S) do
  Begin
   Read (S,ch);
   If (ch = 60) Then B := False;
   If B Then Write (C,ch);
   If (ch = 62) Then B := True;
  End;
 Close (S);
 Close (C);
 Writeln ('Termin‚.');
END.

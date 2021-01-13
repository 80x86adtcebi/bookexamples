Program Callasm (input, output);
{$F+}
{$L MOVECR }
Uses Crt;
Procedure Move_Cursor (Row: Integer; Col: Integer);External; 
Var
	trow, tcol: Integer;
Begin
	Clrscr;
	trow:= 12;
	tcol:= 39;
	Move_Cursor (trow, tcol);	
	Write (‘Cursor...’);
	Repeat Until Keypressed;
End.

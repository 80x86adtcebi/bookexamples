Program Sayi (input, output);
{$L CHECK }
Var
	Buffer: array [1..100] of integer;
	Count: integer;
Procedure RangeError (N:integer);
Begin
	Writeln (‘Sayı tanımlı aralığın dışında...’,N);
End;
Procedure CheckRange (min, max: integer); external;
Begin
	Count=0;
	While (not Eof and (count < 100)) do 
   	Begin
		Count:= Count +1
		Readln (Buffer [Count]);
	End;
	CheckRange (-10,10);
End.

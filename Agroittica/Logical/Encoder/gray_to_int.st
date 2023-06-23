
(* TODO: Add your comment here *)
FUNCTION_BLOCK gray_to_int

	bin[11] := gry[11];
	i := 0;
	x := 0;
	
	FOR i := 10 TO 0 BY -1 DO
	  
		bin[i] := ((bin[i+1]) XOR (gry[i]));

	END_FOR;
	
	FOR i := 11 TO 0 BY -1 DO
		
		x := x + (bin[i] * REAL_TO_DINT( pow(2, i)));
	  
	END_FOR;	
	
END_FUNCTION_BLOCK

FUNCTION_BLOCK Int_to_vel

	pos_b := Pos;
	Ton_0.IN := 1;		
	
	IF (Ton_0.Q) THEN
		Ton_0.IN := 0;
		IF (pos_b >= pos_a) THEN
			Vel := (pos_b - pos_a)/0.12;
		ELSIF (pos_a > pos_b) THEN
			Vel := (pos_b + (Maxim - pos_a))/0.12;
		END_IF
		pos_a := pos_b;
		
	END_IF
	
	Ton_0;
	Ton_0.PT := T#100ms;
	
	
END_FUNCTION_BLOCK


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
		
		Delta_pos := pos_b - pos_a;
		
		Delta_pos := SQRT(pow(Delta_pos, 2));
		
		IF (pos_a > pos_b) THEN
			
			Delta_pos := pos_b + (Maxim - pos_a);
		
			Delta_pos := SQRT(pow(Delta_pos, 2));
			
			Vel := (Delta_pos)/0.42;
		ELSE
			Vel := Delta_pos / 0.42;
		END_IF
		
		pos_a := pos_b;
		
	END_IF
	
	Ton_0;
	Ton_0.PT := T#400ms;
	
END_FUNCTION_BLOCK

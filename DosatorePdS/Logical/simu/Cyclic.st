
PROGRAM _CYCLIC
	(* Insert code here *)
	VelocitaValvola := (32767.0-6553.0)/700.0;
	
	IF (GlbIO.Ao.Valvola - GlbIO.Ai.Valvola) >= 500 THEN
		GlbIO.Ai.Valvola := GlbIO.Ai.Valvola + REAL_TO_INT(VelocitaValvola);
	ELSIF (GlbIO.Ao.Valvola - GlbIO.Ai.Valvola) < 500 THEN 
		GlbIO.Ai.Valvola := GlbIO.Ai.Valvola - REAL_TO_INT(VelocitaValvola);
	END_IF
	
	IF GlbIO.Ai.Valvola > 6660 THEN
		//PesoBilancia_G := PesoBilancia_G + (50.0 * INT_TO_REAL(GlbIO.Ai.Valvola) / 32767.0);
		peso := peso + (5.0 * INT_TO_REAL(GlbIO.Ai.Valvola) / 32767.0);
	END_IF
	 
	PesoBilancia_G := peso;
	
END_PROGRAM

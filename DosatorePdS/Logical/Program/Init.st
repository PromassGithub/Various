

PROGRAM _INIT
	(* Insert code here *)
	
	IF bCalibrazioneCompletata THEN
		// Applica i valori tarati al blocco funzione
		Dosatore.fPesoAnticipoChiusura := fAnticipoMisurato;
            
		// Applica le percentuali dalla curva di calibrazione:
		Dosatore.fPercentualeValvolaVeloce := (fPendenza_m * fPortataTargetVeloce) + fIntercetta_q;
		Dosatore.fPercentualeValvolaLenta := (fPendenza_m * fPortataTargetLenta) + fIntercetta_q;
		Dosatore.fPercentualeValvolaFine := (fPendenza_m * fPortataTargetFine) + fIntercetta_q;
            
		// Limitazioni di sicurezza
		IF Dosatore.fPercentualeValvolaVeloce > 100.0 THEN Dosatore.fPercentualeValvolaVeloce := 100.0; END_IF
		IF Dosatore.fPercentualeValvolaFine < 0.0 THEN Dosatore.fPercentualeValvolaFine := 0.0; END_IF
            
		// Ripristina l'auto-taratura continua
		Dosatore.fFattoreCorrezione := 0.1; 
	END_IF
	 
END_PROGRAM
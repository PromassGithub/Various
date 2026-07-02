
PROGRAM _CYCLIC
// #######################################################################
// --- LOGICA PRINCIPALE E CALIBRAZIONE ---
// #######################################################################
	
	
	IF PercentualeValvola > 0 THEN
		radialGauge := REAL_TO_INT(PercentualeValvola*10);
	ELSE 
		radialGauge := 0;
	END_IF
	
	// conversione segnale d'ingresso valvola
	
	PercentualeValvola := (((INT_TO_REAL(GlbIO.Ai.Valvola) - 6553.0) / (32767.0 - 6553.0)) * 100.0);

// --- ESECUZIONE TIMER ---
	TON_AttesaStabilizzazione(IN := bStartTimerCal, PT := REAL_TO_TIME(fDurataTestSec * 1000.0));
	TON_AttesaStabilizzazione;

	// --- MAPPATURA I/O e CHIAMATA AL BLOCCO FUNZIONE ---
	PesoBilancia_AI := GlbIO.Ai.Bilancia;
	GlbIO.Ao.Valvola := REAL_TO_INT(Valvola_AO);
	
	IF Pulsante_Tara THEN Pulsante_Tara := FALSE; PesoTara := PesoBilancia_G; END_IF
	PesoBilancia_G := PesoBilancia_G - PesoTara;
	
	IF Stop_HMI THEN Dosatore.bFermaDosaggo := 1; ELSE Dosatore.bFermaDosaggo := 0; END_IF
	TON_timerDosaggio;
	TON_timerDosaggio.PT := T#500s;
	
	IF NOT (Dosatore.eStatoDosaggio = eST_ERRORE OR Dosatore.eStatoDosaggio = eST_COMPLETATO OR Dosatore.eStatoDosaggio = eST_IDLE) THEN
		TON_timerDosaggio.IN := TRUE;
		tDosaggio_HMI := TIME_TO_REAL(TON_timerDosaggio.ET) / 1000;
	ELSE
		TON_timerDosaggio.IN := FALSE;
	END_IF
	
	
	Dosatore.fPesoAnticipoChiusura 			:= Recipe.fPesoAnticipoChiusura;
	Dosatore.fSogliaDosaggioLento 			:= Recipe.fSogliaDosaggioLento;
	Dosatore.fSogliaMicrodosaggio 			:= Recipe.fSogliaMicrodosaggio;
	Dosatore.fPercentualeValvolaVeloce 		:= Recipe.fPercentualeValvolaVeloce;
	Dosatore.fPercentualeValvolaLenta 		:= Recipe.fPercentualeValvolaLenta;
	Dosatore.fPercentualeValvolaFine 		:= Recipe.fPercentualeValvolaFine;
	Dosatore.fFattoreCorrezione 			:= Recipe.fFattoreCorrezione;
	Dosatore.fFeadbackValvolaProporzionale 	:= PercentualeValvola;
	PesoRichiesto_HMI						:= Recipe.PesoRichiesto;

	Dosatore(
		fPesoAttualeBilancia := PesoBilancia_G,
		fPesoRichiesto := PesoRichiesto_HMI,
		bAvviaDosaggio := StartDosaggio_HMI 
		);
	
	Recipe.fPesoAnticipoChiusura := Dosatore.fPesoAnticipoChiusura;
	
	BilanciaManager(
		iRawInput := PesoBilancia_AI,
		bComandoTare := Pulsante_Tara 
		// fCapacitaMaxG e iRawMax usano i valori di default (5000.0, 32767) se non specificati
		);
	
	// Mappa l'uscita
	// PesoBilancia_G := BilanciaManager.fPesoGrammi;

	Valvola_AO := (Dosatore.fUscitaValvolaProporzionale * (32767 - 6600) / 100) + 6600;

	// --- SEQUENZA DI MISURAZIONE DELLA PORTATA ---
	// Logica per eseguire il test di portata con Timer e chiusura valvola
	IF eStatoCalibrazione = eCAL_TEST_PUNTO1_BASSO OR eStatoCalibrazione = eCAL_TEST_PUNTO2_ALTO THEN
	(*	bStartTimerCal := FALSE;*)
		IF NOT TON_AttesaStabilizzazione.Q THEN
			// La variabile Veloce qui funge da variabile temporanea per l'apertura in test
			GlbIO.Ao.Valvola := REAL_TO_INT(Dosatore.fPercentualeValvolaVeloce * 32767 / 100); 
		ELSE
			GlbIO.Ao.Valvola := REAL_TO_INT(10000.0); 
		END_IF
    
		// Calcolo della portata dopo il timeout + 10s di stabilizzazione
		IF TON_AttesaStabilizzazione.Q AND TON_AttesaStabilizzazione.ET >= REAL_TO_TIME((fDurataTestSec) * 1000.0) THEN 
			fPortataMisurata := (PesoBilancia_G - fPesoIniziale) / fDurataTestSec; 
			bStartTimerCal := FALSE; // Termina il test
		END_IF
	END_IF

	// #######################################################################
	// --- MACCHINA A STATI DI CALIBRAZIONE ---
	// #######################################################################

	IF bStartCalibrazione AND NOT bCalibrazioneCompletata THEN
    
		CASE eStatoCalibrazione OF
        
			eCAL_IDLE:
				bStartTimerCal := FALSE;
				//Bilancia.Tare := TRUE; 
				Dosatore.fFattoreCorrezione := 0.0; // Disabilita l'auto-tuning
				eStatoCalibrazione := eCAL_PREPARA_TEST; 
            
			eCAL_PREPARA_TEST:
				fPortataMisurata := 0.0;
				fPesoIniziale := 0.0;
				eStatoCalibrazione := eCAL_TEST_PUNTO1_BASSO;
				
				fPesoIniziale := PesoBilancia_G;
				bStartTimerCal := TRUE;
            
			eCAL_TEST_PUNTO1_BASSO:
				// TEST 1: Misura della portata al punto P1 (20% apertura)
				Dosatore.fPercentualeValvolaVeloce := fPercentualeTestBasso; 
            
				
//					fPesoIniziale := PesoBilancia_G;
//					bStartTimerCal := TRUE; 
				IF NOT bStartTimerCal AND (fPortataMisurata > 0.0) THEN
					fPortataTestBasso := fPortataMisurata; 
					eStatoCalibrazione := eCAL_TEST_PUNTO2_ALTO;
					
					fPesoIniziale := PesoBilancia_G;
					fPortataMisurata := 0;
					bStartTimerCal := TRUE; 
				END_IF
            
			eCAL_TEST_PUNTO2_ALTO:
				// TEST 2: Misura della portata al punto P2 (80% apertura)
				Dosatore.fPercentualeValvolaVeloce := fPercentualeTestAlto; 
            
				
//					fPesoIniziale := PesoBilancia_G;
//					bStartTimerCal := TRUE; 
				IF NOT bStartTimerCal AND (fPortataMisurata > 0.0) THEN
					fPortataTestAlto := fPortataMisurata; 
					eStatoCalibrazione := eCAL_CALCOLA_CURVA;
				END_IF
            
			eCAL_CALCOLA_CURVA:
				// Calcolo dei coefficienti della curva lineare (Percentuale = m * Portata + q)
				IF (fPortataTestAlto - fPortataTestBasso) > 0.001 THEN 
					fPendenza_m := (fPercentualeTestAlto - fPercentualeTestBasso) / 
					(fPortataTestAlto - fPortataTestBasso);
					fIntercetta_q := fPercentualeTestBasso - (fPendenza_m * fPortataTestBasso);
                
					eStatoCalibrazione := eCAL_MISURA_VOLO;
				ELSE
					eStatoCalibrazione := eCAL_ERRORE; // Errore: Le portate sono uguali o zero
				END_IF
            
			eCAL_MISURA_VOLO:
				// CRUCIALE: Misura il peso in volo (forza Dosatore.fPesoAnticipoChiusura = 0.0)
				Dosatore.fPesoAnticipoChiusura := 0.0; 
				fSetPointTaratura := 2000.0;
				PesoRichiesto_HMI := fSetPointTaratura;

				StartDosaggio_HMI := TRUE; 
            
				IF Dosatore.bDosaggioCompletato THEN
					StartDosaggio_HMI := FALSE;
					bStartTimerCal := TRUE; 
					eStatoCalibrazione := eCAL_ATTESA_PESO;
				END_IF
            
			eCAL_ATTESA_PESO:
				// Attende stabilizzazione e calcola il volo
				IF TON_AttesaStabilizzazione.Q THEN
					bStartTimerCal := FALSE;
                
					fAnticipoMisurato := PesoBilancia_G - fSetPointTaratura; 
                
					IF fAnticipoMisurato < 0.5 THEN fAnticipoMisurato := 0.5; END_IF
                
					eStatoCalibrazione := eCAL_APPLICA_VALORI;
				END_IF
            
			eCAL_APPLICA_VALORI:
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
            
				eStatoCalibrazione := eCAL_COMPLETATO;
            
			eCAL_COMPLETATO:
				bCalibrazioneCompletata := TRUE;
				eStatoCalibrazione := eCAL_IDLE;
            
			eCAL_ERRORE:
			// ... Logica di errore
            
		END_CASE
    
	END_IF
	
	IF GlbIO.Ao.Valvola < 6500 THEN GlbIO.Ao.Valvola := 6500; END_IF
	 
END_PROGRAM

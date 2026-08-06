FUNCTION_BLOCK FB_DosaggioPolvere
	
	// --- CONTROLLO GUASTI DI SICUREZZA ---
	IF fPesoAttualeBilancia < -10.0 OR fPesoAttualeBilancia > C_CAPACITA_MAX_BILANCIA THEN
		eStatoDosaggio := eST_ERRORE;
	END_IF
	
	IF bFermaDosaggo THEN eStatoDosaggio := eST_IDLE; END_IF;

	// --- ESECUZIONE TIMER E CALCOLI PRELIMINARI ---
	TON_Stabilizzazione(IN := bStartTimer, PT := tTimeoutStabilizzazione);
	TON_AttesaMateriale(IN := bStartTimerAttesa, PT := T#10s);

	// CALCOLO DELL'ERRORE MASSIMO ASSOLUTO (basato sulla percentuale)
	fErroreAssolutoMax := fPesoRichiesto * fTolleranzaPercentuale;

	// Calcolo del Punto di Chiusura (Anticipo del Volo)
	//fPuntoDiChiusuraValvola := fPesoRichiesto - fPesoAnticipoChiusura;
	fTempoRitardoPrecedente := fPesoAnticipoChiusura;
	
	// Calcolo dei Target
	fPesoTargetVeloce := (fPesoRichiesto) * fSogliaDosaggioLento/100;
	fPesoTargetLento := (fPesoRichiesto) * fSogliaMicrodosaggio/100;
	
	// Calcolo dei Limiti di Tolleranza Finale
	fTolleranzaMinima := fPesoRichiesto - fErroreAssolutoMax;
	fTolleranzaMassima := fPesoRichiesto + fErroreAssolutoMax;

	IF i = 9 THEN
		fPortataAttuale := (bilanciaPortataArray[0] + bilanciaPortataArray[1] + bilanciaPortataArray[2] + bilanciaPortataArray[3] + bilanciaPortataArray[4] + bilanciaPortataArray[5] + bilanciaPortataArray[6] + bilanciaPortataArray[7] + bilanciaPortataArray[8] + bilanciaPortataArray[9])/0.1;
	END_IF
	
	
	bilanciaPortataArray[i] := fPesoAttualeBilancia - bilanciaPortataOld;

	i := i+1;
	IF i > 9 THEN i := 0; END_IF
	
	bilanciaPortataOld := fPesoAttualeBilancia;
	
	IF NOT TON_AttesaMateriale.Q THEN
		fOldWeight := fPesoAttualeBilancia;
	END_IF

	// Gestione degli stati
	CASE eStatoDosaggio OF
    
		eST_IDLE: // Stato di riposo, attende il comando di avvio
			bStartTimer := FALSE; // Timer disattivo
			bErroreStabilizzazione := FALSE;
			bDosaggioInCorso := FALSE;
			bDosaggioCompletato := FALSE;
			fUscitaValvolaProporzionale := 0.0; // Valvola chiusa
			fIncrementoPercentualeValvola:= 0;
        
			IF bAvviaDosaggio AND (fPesoRichiesto > 0.0) THEN
				eStatoDosaggio := eST_VELOCE;
				bDosaggioInCorso := TRUE;
			END_IF
        
		eST_VELOCE: // Dosaggio Veloce (fino al 90% del peso richiesto)
			bStartTimer := FALSE; // Timer disattivo
			fUscitaValvolaProporzionale := fPercentualeValvolaVeloce + fIncrementoPercentualeValvola; // Apertura valvola al valore veloce
        
			IF fUscitaValvolaProporzionale > 100 THEN 
				eStatoDosaggio := eST_ERRORE;
			END_IF
			
			
			IF ABS(fUscitaValvolaProporzionale - fFeadbackValvolaProporzionale) < 4 THEN
				bStartTimerAttesa := TRUE;
				IF TON_AttesaMateriale.Q AND (ABS(fOldWeight - fPesoAttualeBilancia) < 5) THEN
					fIncrementoPercentualeValvola := fIncrementoPercentualeValvola + 7;
				END_IF
			ELSE
				bStartTimerAttesa := FALSE;
			END_IF
			
			// Transizione allo stato successivo
			IF fPesoAttualeBilancia >= fPesoTargetVeloce THEN
				eStatoDosaggio := eST_LENTO;
				fIncrementoPercentualeValvola:= 0;
			END_IF
        
		eST_LENTO: // Dosaggio Lento (dal 90% al 99% del peso richiesto)
			bStartTimer := FALSE; // Timer disattivo
			fUscitaValvolaProporzionale := fPercentualeValvolaLenta + fIncrementoPercentualeValvola; // Apertura valvola al valore lento per maggiore precisione
			
			IF fUscitaValvolaProporzionale > 100 THEN 
				eStatoDosaggio := eST_ERRORE;
			END_IF
			
			IF ABS(fUscitaValvolaProporzionale - fFeadbackValvolaProporzionale) < 4 THEN
				bStartTimerAttesa := TRUE;
				IF TON_AttesaMateriale.Q AND (ABS(fOldWeight - fPesoAttualeBilancia) < 4) THEN
					fIncrementoPercentualeValvola := fIncrementoPercentualeValvola + 5;
				END_IF
			ELSE
				bStartTimerAttesa := FALSE;
			END_IF
        
			// Transizione allo stato successivo
			IF fPesoAttualeBilancia >= fPesoTargetLento THEN
				eStatoDosaggio := eST_FINE;
				fIncrementoPercentualeValvola:= 0;
			END_IF
			
			
			
		eST_FINE: // Microdosaggio (dal 99% fino al punto di chiusura anticipata)
			
			// --- 1. CALCOLO DINAMICO DEL PUNTO DI CHIUSURA ---
			IF fPercentualeValvolaPrec > 0.0 THEN
				fFattoreCorrezioneValvola := fFeadbackValvolaProporzionale / fPercentualeValvolaPrec;
			ELSE
				fFattoreCorrezioneValvola := 1.0; // Sicurezza per il primo ciclo assoluto
			END_IF
			
			// Stima del ritardo e del materiale in volo (Anticipo dinamico)
			fTempoRitardoStimato := fTempoRitardoPrecedente * fFattoreCorrezioneValvola;
			fMaterialeInVolo := fPortataAttuale * fTempoRitardoStimato;
			fPuntoDiChiusuraValvola := fPesoRichiesto - fMaterialeInVolo;
			// --------------------------------------------------

			fUscitaValvolaProporzionale := fPercentualeValvolaFine + fIncrementoPercentualeValvola; // Apertura minima della valvola (Microdosaggio)
			
			IF fUscitaValvolaProporzionale > 100 THEN 
				eStatoDosaggio := eST_ERRORE;
			END_IF
			
			IF ABS(fUscitaValvolaProporzionale - fFeadbackValvolaProporzionale) < 4 THEN
				bStartTimerAttesa := TRUE;
				IF TON_AttesaMateriale.Q AND (fPortataAttuale) < 2 THEN
					fIncrementoPercentualeValvola := fIncrementoPercentualeValvola + 3;
				END_IF
			ELSE
				bStartTimerAttesa := FALSE;
			END_IF
        
			// --- 2. CONDIZIONE DI CHIUSURA ANTICIPATA ---
			IF fPesoAttualeBilancia >= fPuntoDiChiusuraValvola THEN
				
				// SALVATAGGIO DATI PER L'AUTO-APPRENDIMENTO DEL CICLO SUCCESSIVO
				fPercentualeValvolaPrec := fFeadbackValvolaProporzionale;
				fPortataAlComandoChiusura := fPortataAttuale;
				fPesoAlComandoChiusura := fPesoAttualeBilancia;
			
				fUscitaValvolaProporzionale := 0.0;	// Chiusura IMMEDIATA della valvola
				bStartTimer := TRUE; // AVVIO DEL TIMER e transizione allo stato di attesa
				eStatoDosaggio := eST_ATTESA_STABILIZZAZIONE; // Passaggio ad uno stato di attesa per la stabilizzazione/volo
				fIncrementoPercentualeValvola:= 0;
			END_IF
			
		eST_ATTESA_STABILIZZAZIONE: // Stato di attesa: la valvola è chiusa (Output = 0.0), il timer è attivo
			bStartTimer := TRUE; // Mantiene attivo l'ingresso del TON
        
			// Controllo di successo: Peso stabilizzato nell'intervallo ACCETTABILE
			IF fPesoAttualeBilancia >= fTolleranzaMinima AND fPesoAttualeBilancia <= fTolleranzaMassima AND TON_Stabilizzazione.Q THEN
				bStartTimer := FALSE; 
				eStatoDosaggio := eST_COMPLETATO;
				
				// --- LOGICA DI AUTO-TARATURA (SUCCESSO) ---
				IF fPortataAlComandoChiusura > 0.0 THEN
					fMaterialeCadutoDopoChiusura := fPesoAttualeBilancia - fPesoAlComandoChiusura;
					fTempoRitardoPrecedente := fMaterialeCadutoDopoChiusura / fPortataAlComandoChiusura;
				END_IF
				
			ELSIF TON_Stabilizzazione.Q THEN
				// Controllo di errore: Timeout raggiunto e peso fuori tolleranza
			 
				bStartTimer := FALSE; // Spegne il timer
				bErroreStabilizzazione := TRUE; // Segnala l'errore specifico
				//eStatoDosaggio := eST_ERRORE;
				
				// --- LOGICA DI AUTO-TARATURA (ERRORE) ---
				// Anche se è in errore, calcoliamo il ritardo reale per correggere il prossimo ciclo
				IF fPortataAlComandoChiusura > 0.0 THEN
					fMaterialeCadutoDopoChiusura := fPesoAttualeBilancia - fPesoAlComandoChiusura;
					
					// Protezione per evitare calcoli errati se qualcuno ha toccato la bilancia
					IF fMaterialeCadutoDopoChiusura > 0.0 THEN
						fTempoRitardoPrecedente := fMaterialeCadutoDopoChiusura / fPortataAlComandoChiusura;
						eStatoDosaggio := eST_ERRORE;
					END_IF
				END_IF
				
				// Registra l'ultimo risultato per diagnostica o per HMI
				fUltimoPesoDosato := fPesoAttualeBilancia;
				fUltimoErroreAssoluto := fUltimoPesoDosato - fPesoRichiesto; 
			END_IF
        
			//		eST_FINE: // Microdosaggio (dal 99% fino al punto di chiusura anticipata)
			//			fUscitaValvolaProporzionale := fPercentualeValvolaFine + fIncrementoPercentualeValvola; // Apertura minima della valvola (Microdosaggio)
			//			
			//			IF fUscitaValvolaProporzionale > 100 THEN 
			//				eStatoDosaggio := eST_ERRORE;
			//			END_IF
			//			
			//			IF ABS(fUscitaValvolaProporzionale - fFeadbackValvolaProporzionale) < 2 THEN
			//				bStartTimerAttesa := TRUE;
			//				IF TON_AttesaMateriale.Q AND (ABS(fOldWeight - fPesoAttualeBilancia) < 2) THEN
			//					fIncrementoPercentualeValvola := fIncrementoPercentualeValvola + 3;
			//				END_IF
			//			ELSE
			//				bStartTimerAttesa := FALSE;
			//			END_IF
			//        
			//			// CONDIZIONE DI CHIUSURA ANTICIPATA:
			//			IF fPesoAttualeBilancia >= fPuntoDiChiusuraValvola THEN
			//			
			//				fUscitaValvolaProporzionale := 0.0;	// Chiusura IMMEDIATA della valvola
			//				bStartTimer := TRUE; // AVVIO DEL TIMER e transizione allo stato di attesa
			//				eStatoDosaggio := eST_ATTESA_STABILIZZAZIONE; // Passaggio ad uno stato di attesa per la stabilizzazione/volo
			//				fIncrementoPercentualeValvola:= 0;
			//			END_IF
			//			
			//		eST_ATTESA_STABILIZZAZIONE: // Stato di attesa: la valvola è chiusa (Output = 0.0), il timer è attivo
			//			bStartTimer := TRUE; // Mantiene attivo l'ingresso del TON
			//        
			//			// 1. Controllo di successo: Peso stabilizzato nell'intervallo ACCETTABILE (0.05% del setpoint)
			//			IF fPesoAttualeBilancia >= fTolleranzaMinima AND fPesoAttualeBilancia <= fTolleranzaMassima AND TON_Stabilizzazione.Q THEN
			//				bStartTimer := FALSE; 
			//				eStatoDosaggio := eST_COMPLETATO;
			//				
			//			ELSIF TON_Stabilizzazione.Q THEN
			//				// 2. Controllo di errore: Timeout raggiunto
			//			 
			//				bStartTimer := FALSE; // Spegne il timer
			//				bErroreStabilizzazione := TRUE; // Segnala l'errore specifico
			//				eStatoDosaggio := eST_ERRORE;
			//				
			//				// --- LOGICA DI AUTO-TARATURA ---
			//				// 1. Registra l'ultimo risultato e calcola l'errore
			//				fUltimoPesoDosato := fPesoAttualeBilancia;
			//				fUltimoErroreAssoluto := fUltimoPesoDosato - fPesoRichiesto; // Errore = (Finale - Richiesto)
			//            
			//				// 2. Aggiorna il peso di anticipo chiusura (fPesoAnticipoChiusura)
			//				// Se l'ultimo dosaggio ha superato il setpoint (sovradosaggio):
			//				// L'errore è positivo, quindi dobbiamo aumentare l'anticipo (chiudere prima).
			//				// Nuova anticipazione = Vecchia anticipazione + (Errore * Fattore di correzione)
			//				fPesoAnticipoChiusura := fPesoAnticipoChiusura + (fUltimoErroreAssoluto * fFattoreCorrezione);
			//			END_IF	
        
		eST_COMPLETATO: // Dosaggio terminato con successo
			bStartTimer := FALSE; // Timer disattivo
			bDosaggioCompletato := TRUE;
			bDosaggioInCorso := FALSE;
			fUscitaValvolaProporzionale := 0.0; // Valvola chiusa
			
			// --- LOGICA DI AUTO-TARATURA ---
			// 1. Registra l'ultimo risultato e calcola l'errore
			fUltimoPesoDosato := fPesoAttualeBilancia;
			fUltimoErroreAssoluto := fUltimoPesoDosato - fPesoRichiesto; // Errore = (Finale - Richiesto)
            
			// 2. Aggiorna il peso di anticipo chiusura (fPesoAnticipoChiusura)
			// Se l'ultimo dosaggio ha superato il setpoint (sovradosaggio):
			// L'errore è positivo, quindi dobbiamo aumentare l'anticipo (chiudere prima).
			// Nuova anticipazione = Vecchia anticipazione + (Errore * Fattore di correzione)
			fPesoAnticipoChiusura := fPesoAnticipoChiusura + (fUltimoErroreAssoluto * fFattoreCorrezione);
            
			// Limitare l'anticipo per evitare che diventi negativo o eccessivo (es. tra 1g e 100g)
			IF fPesoAnticipoChiusura < 1.0 THEN
				fPesoAnticipoChiusura := 1.0;
			END_IF
        
			// Ritorna in IDLE solo se il comando di avvio è disattivato
			IF NOT bAvviaDosaggio THEN
				eStatoDosaggio := eST_IDLE;
			END_IF
        
		eST_ERRORE: // Stato di errore (aggiungere logica di gestione errori più specifica)
			bStartTimer := FALSE; // Timer disattivo
			fUscitaValvolaProporzionale := 0.0;
			bDosaggioInCorso := FALSE;
			bStartTimerAttesa := FALSE;
		
			IF NOT bAvviaDosaggio THEN
				eStatoDosaggio := eST_IDLE;
			END_IF
        
	END_CASE
	
	fPesoAnticipoChiusura := fTempoRitardoPrecedente;

	// Calcolo e monitoraggio dell'errore (solo per info esterna/HMI)
	IF fPesoAttualeBilancia > 0.0 AND fPesoRichiesto > 0.0 THEN
		fErrorePercentuale := ABS((fPesoAttualeBilancia - fPesoRichiesto) / fPesoRichiesto) * 100.0;
	ELSE
		fErrorePercentuale := 0.0;
	END_IF
	
END_FUNCTION_BLOCK

FUNCTION_BLOCK FB_GestioneBilancia 
	// 1. Determinazione del Range Raw (Mapping Raw Minimo)
	CASE eTipoSegnale OF
		eST_0_20mA:
			iRawMin := 0; // 0mA corrisponde al minimo raw (0)
			bErroreSegnale := FALSE; // Non c'è errore di "live zero"
        
		eST_4_20mA:
			// Calcolo il valore raw corrispondente a 4mA
			// (4mA / 20mA) * RawMax = 0.2 * RawMax
			iRawMin := REAL_TO_INT(iRawMax * 0.2) ; 
        
			// Controllo errore segnale (Live Zero Check)
			IF iRawInput < iRawMin - 100 THEN // Sotto la soglia di 4mA (tolleranza 100 counts)
				bErroreSegnale := TRUE;
			ELSE
				bErroreSegnale := FALSE;
			END_IF
	END_CASE

	// 2. Calcolo del Fattore di Conversione e del Peso Lordo (fPesoLordoSenzaOffset)

	// Calcolo del range effettivo del segnale in Raw
	iRawRange := iRawMax - iRawMin;
	fRawAttualeNormalizzato := INT_TO_REAL(iRawInput) - INT_TO_REAL(iRawMin);

	// Se il range è valido
	IF iRawRange > 0 THEN
		// Fattore di conversione: Capacità / Range Raw
		fFattoreConversione := fCapacitaMaxG / INT_TO_REAL(iRawRange);
    
		// Peso Lordo = Raw Normalizzato * Fattore Conversione
		fPesoLordoSenzaOffset := fRawAttualeNormalizzato * fFattoreConversione;
	ELSE
		fPesoLordoSenzaOffset := 0.0;
	END_IF


	// 3. Gestione del Comando di Tara (Azzeramento)
	// La tara viene applicata al peso Lordo solo se il comando è attivo E non c'è errore di segnale
	IF bComandoTare AND NOT bErroreSegnale THEN
		fOffsetTara := fPesoLordoSenzaOffset;
	END_IF


	// 4. Calcolo del Peso Netto (Peso Lordo - Offset Tara)
	fPesoGrammi := fPesoLordoSenzaOffset - fOffsetTara;

	// Misure di sicurezza: Impedisci output troppo negativo
	IF fPesoGrammi < -15.0 THEN
		fPesoGrammi := 0.0; 
	END_IF
	
END_FUNCTION_BLOCK


FUNCTION_BLOCK FB_GestioneBilancia
	VAR_INPUT
		iRawInput : INT; (*// Ingresso: Valore raw (grezzo) letto dal modulo I/O (es. 0 a 32767)*)
		bComandoTare : BOOL; (*// Ingresso: Commuta a TRUE per eseguire l'azzeramento (Tara)*)
		eTipoSegnale : enSignalType := eST_4_20mA; (*/ NUOVO: Tipo di segnale (0-20mA o 4-20mA)*)
		fCapacitaMaxG : REAL := 6000.0; (*// Ingresso: Capacità massima della bilancia in grammi*)
		iRawMax : INT := 32767; (*// Ingresso: Valore massimo raw del modulo I/O*)
	END_VAR
	VAR_OUTPUT
		bErroreSegnale : BOOL;
		fPesoGrammi : REAL; (*// Uscita: Peso convertito e tarato in grammi (REAL)*)
	END_VAR
	VAR
		fFattoreConversione : REAL; (*// Fattore per convertire Raw in Grammi/Volt*)
		fOffsetTara : REAL := 0.0; (*// Offset di tara (peso memorizzato durante l'azzeramento)*)
		fPesoLordoSenzaOffset : REAL; (*// Peso convertito prima dell'applicazione della tara*)
		iRawMin : INT; (*// Valore raw minimo corrispondente a 0mA o 4mA*)
		iRawRange : INT; (*// RawMax - RawMin*)
		fRawAttualeNormalizzato : REAL; (*// Raw letto - RawMin*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK FB_DosaggioPolvere
	VAR_INPUT
		fPesoAttualeBilancia : REAL; (*// Ingresso: Peso letto dalla bilancia (es. in grammi)*)
		fPesoRichiesto : REAL; (*// Ingresso: Setpoint del peso desiderato (es. in grammi)*)
		bFermaDosaggo : BOOL; (*// Ingresso: Commuta a TRUE per iniziare il ciclo*) (*// --- PARAMETRI DI PRECISIONE ---*)
		bAvviaDosaggio : BOOL; (*// Ingresso: Commuta a TRUE per iniziare il ciclo*) (*// --- PARAMETRI DI PRECISIONE ---*)
		fTolleranzaPercentuale : REAL := 0.0005; (*Fattore per lo 0.05% (0.05 / 100)*)
		fPesoAnticipoChiusura : REAL := 5.0; (*Ingresso: Peso (in grammi) che è in volo dopo la chiusura della valvola (DEVE ESSERE CALIBRATO!)*) (*// --- PARAMETRI DI FASE ---*)
		fSogliaDosaggioLento : REAL := 0.90; (*// Ingresso: Percentuale del setpoint per passare a dosaggio lento (es. 90%)*)
		fSogliaMicrodosaggio : REAL := 0.97; (*// Ingresso: Percentuale del setpoint per passare a microdosaggio (es. 99%)*)
		fPercentualeValvolaVeloce : REAL := 70.0; (*// Ingresso: Apertura valvola per dosaggio veloce (0-100)*)
		fPercentualeValvolaLenta : REAL := 50; (*// Ingresso: Apertura valvola per dosaggio lento (0-100)*)
		fPercentualeValvolaFine : REAL := 47; (*// Ingresso: Apertura valvola per microdosaggio (0-100)*)
		tTimeoutStabilizzazione : TIME := T#5s; (*Tempo massimo di attesa per la stabilizzazione (es. 5 secondi)*)
		fFattoreCorrezione : REAL := 0.1; (*Fattore che determina la velocità di correzione (es. 0.1 = correggiamo il 10% dell'errore ad ogni ciclo)*)
		C_CAPACITA_MAX_BILANCIA : REAL := 3500;
		fFeadbackValvolaProporzionale : REAL; (*// Uscita: Comando alla valvola proporzionale (0.0 - 100.0)*)
	END_VAR
	VAR_OUTPUT
		fUscitaValvolaProporzionale : REAL; (*// Uscita: Comando alla valvola proporzionale (0.0 - 100.0)*)
		bDosaggioCompletato : BOOL; (*// Uscita: TRUE quando il dosaggio è finito e preciso*)
		bDosaggioInCorso : BOOL; (*// Uscita: TRUE durante il ciclo di dosaggio*)
		bErroreStabilizzazione : BOOL; (*TRUE se il dosaggio è fallito per timeout*)
		eStatoDosaggio : enStatoDosaggio; (*// Stato macchina*)
	END_VAR
	VAR
		fPesoTargetVeloce : REAL; (*// Peso limite per dosaggio veloce*)
		fPesoTargetLento : REAL; (*// Peso limite per dosaggio lento*)
		fErrorePercentuale : REAL; (*// Errore calcolato in %*)
		fSetPointErrore : REAL;
		fTolleranzaMinima : REAL; (*Limite inferiore accettabile*)
		fTolleranzaMassima : REAL; (*Limite superiore accettabile*)
		fPuntoDiChiusuraValvola : REAL; (*Nuovo punto di chiusura calcolato*) (*// VARIABILI TIMER*)
		bStartTimerAttesa : BOOL; (*Flag per attivare il timer*)
		bStartTimer : BOOL; (*Flag per attivare il timer*)
		TON_AttesaMateriale : TON; (*Istanza del Timer di Attesa, dopo questo tempo, se il materiale non passaaumento l'apertura della valvola*) (*// VARIABILI PER L'AUTO-TARATURA*)
		TON_Stabilizzazione : TON; (*Istanza del Timer On Delay*) (*// VARIABILI PER L'AUTO-TARATURA*)
		fUltimoPesoDosato : REAL; (*Peso finale registrato nel ciclo precedente*)
		fUltimoErroreAssoluto : REAL; (*Differenza tra fUltimoPesoDosato e fPesoRichiesto*)
		fErroreAssolutoMax : REAL; (*// Valore calcolato: Peso max di errore (es. 1.0g per 2000g)*)
		fOldWeight : REAL; (*vecchio valore bilancia per controllo flusso*)
		fIncrementoPercentualeValvola : REAL;
		fPercentualeValvolaPrec : REAL;
		fPortataAlComandoChiusura : REAL;
		fPortataAttuale : REAL;
		fFattoreCorrezioneValvola : REAL;
		fMaterialeInVolo : REAL;
		fTempoRitardoStimato : REAL;
		fPesoAlComandoChiusura : REAL;
		fMaterialeCadutoDopoChiusura : REAL;
		fTempoRitardoPrecedente : REAL;
		bilanciaPortataOld : REAL;
	END_VAR
END_FUNCTION_BLOCK

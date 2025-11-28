
TYPE
	enSignalType : 
		(
		eST_0_20mA,
		eST_4_20mA
		);
	enStatoDosaggio : 
		(
		eST_IDLE := 10,
		eST_VELOCE := 20,
		eST_LENTO := 30,
		eST_FINE := 40,
		eST_ATTESA_STABILIZZAZIONE := 50,
		eST_COMPLETATO := 60,
		eST_ERRORE := 0
		);
	enStatoCalibrazione : 
		( (*// Macchina a Stati per la Calibrazione*)
		eCAL_IDLE := 10,
		eCAL_PREPARA_TEST := 20,
		eCAL_TEST_PUNTO1_BASSO,
		eCAL_TEST_PUNTO2_ALTO,
		eCAL_CALCOLA_CURVA,
		eCAL_MISURA_VOLO := 30,
		eCAL_ATTESA_PESO := 40,
		eCAL_APPLICA_VALORI := 50,
		eCAL_COMPLETATO := 60,
		eCAL_ERRORE := 0
		);
END_TYPE

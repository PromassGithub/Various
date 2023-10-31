
PROGRAM _CYCLIC
	(* Insert code here *)
	
	
	DtSetTime_1.enable:=setta_orario;
	DtSetTime_1();
	//status:=DTGetTime_1.status;
	DtSetTime_1.DT1 := DT_attuale;
	
	DtGetTime_1.enable:=TRUE;
	DtGetTime_1();
	//status:=DTGetTime_1.status;
	DT_0:=DtGetTime_1.DT1;
	
	
	IF sim THEN 
		
		IF conteggio THEN 
			conteggio :=0;
			contatore.S_stellare:=0;
		ELSIF conteggio = 0 THEN
			conteggio := 1;
			contatore.S_stellare:=1;			
		END_IF;
	ELSE
		
		contatore.S_stellare := contatore.Inp_S_Stellare;
		
	END_IF
	
	IF NOT t_ok THEN	
		IF bool_1 = 1 THEN 
			bool_1:=0;
			DT_2 := DT_0;
			tempo_attuale:=DiffDT(DT_2,DT_1);
			StartGenerate := 1;
		END_IF;
	ELSE 
		IF bool_1 = 0 THEN 
			DT_1 := DT_0;
		END_IF;
		
		bool_1 := 1;
	END_IF;
	
	IF MpReportCore_0.CommandDone THEN CTU_1.RESET := 1; ELSE CTU_1.RESET := 0; END_IF;
	
	Ricetta.Giri_Parziali	:= contatore.giri_parziali;
	Ricetta.Giri_Totali		:= contatore.giri_totali;
	Ricetta.Ora_Fine		:= DT_2;
	Ricetta.Ora_Inizio		:= DT_1;
	Ricetta.Tempo_Attivita	:= tempo_attuale;
	
	contatore.nome_ricetta	:= DT_TO_STRING(DT_1);
//	contatore.nome_ricetta2 := contatore.nome_ricetta;
	
END_PROGRAM

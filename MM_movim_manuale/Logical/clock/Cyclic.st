PROGRAM _CYCLIC
	(* Insert code here *)
	DtSetTime_1.enable;
	DtSetTime_1();
	//status:=DTGetTime_1.status;
	DtSetTime_1.DT1 := DT_attuale;
	
	DtGetTime_1.enable:=TRUE;
	DtGetTime_1();
	//status:=DTGetTime_1.status;
	DT_0:=DtGetTime_1.DT1;
	
	//DT_String := DT_TO_STRING();
	
	
	
	IF P THEN
		dir_create.enable := 1;
		//		dir_create.pName := STRING_TO_UDINT( nome);
		dir_create.pName := ADR(nome);
		//		dir_create.pDevice := STRING_TO_UDINT(directory);
		dir_create.pDevice := ADR(directory);
		dir_create();
		P:=0;
	ELSE
		dir_create.enable := 0;
	END_IF
	
END_PROGRAM
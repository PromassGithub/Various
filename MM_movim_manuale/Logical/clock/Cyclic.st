
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
END_PROGRAM

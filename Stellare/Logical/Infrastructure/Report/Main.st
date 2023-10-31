
PROGRAM _CYCLIC
	
	//Call FBs:
	MpReportCore_0( 
		Enable := TRUE,
		MpLink := ADR(gReport),
		Name := ADR(REPORT_NAME),
		DeviceName := ADR(REPORT_DEVICE));
		MpFileManagerUI_0(Enable := TRUE);
	
	//Call Action 
	RefreshReport;
	
END_PROGRAM
PROGRAM _EXIT
 
	//Disable FBs
	MpReportCore_0(Enable := FALSE);
	MpFileManagerUI_0(Enable := FALSE);
	
END_PROGRAM
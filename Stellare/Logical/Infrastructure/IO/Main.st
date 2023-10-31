PROGRAM _INIT
	
	//Enable ImportAllowed
	MpIOImport_0.ImportAllowed := TRUE;
	
END_PROGRAM
PROGRAM _CYCLIC	
	
	FileName := MpIOImportUIConnect.FileList.Names[MpIOImportUIConnect.FileList.Scroll.SelectedIndex];
	ActiveConfiguration;
	
	//Set FB parameters
	MpIOImport_0(
		Enable := TRUE,
		MpLink := ADR(gIoConfig),	
		DeviceName := ADR('mappIO'),
		FileName := ADR(FileName));

	MpIOImportUI_0(
		Enable := TRUE,
		MpLink := ADR(gIoConfig),	
		UIConnect := ADR(MpIOImportUIConnect));

	//Reset Import command if import succeded
	IF MpIOImport_0.CommandDone = TRUE THEN 
		MpIOImport_0.Import := FALSE;
	END_IF
	
END_PROGRAM
PROGRAM _EXIT
	
	//Disable FBs
	MpIOImport_0(Enable := FALSE, ImportAllowed := FALSE);
	MpIOImportUI_0(Enable := FALSE);
	 
END_PROGRAM
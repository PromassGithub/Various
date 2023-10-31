
PROGRAM _CYCLIC

	//Set FB parameters
	MpAuditTrail_0(
		MpLink := ADR(gAuditTrail),
		Enable := TRUE, DeviceName := ADR('mappDir'), 
		ErrorReset := gCoffeeMainLogic.cmdClear,
		Language := ADR(gSetLanguage));

	MpAuditTrailUI_0(
		MpLink := ADR(gAuditTrail),
		Enable := TRUE, 
		UIConnect := ADR(MpAuditTrailUIConnect), 
		ErrorReset := gCoffeeMainLogic.cmdClear,
		Language := ADR(gSetLanguage));
	
	IF (MpAuditTrail_0.Export) AND (MpAuditTrail_0.CommandDone) THEN
		MpAuditTrail_0.Export := FALSE;
	END_IF
	
	
	IF MpAuditTrail_0.ArchiveAvailable THEN
		MpAuditTrail_0.ExportArchive := TRUE;
	ELSE
		MpAuditTrail_0.ExportArchive := FALSE;
	END_IF
	
	FilterConfiguration;
	SortConfiguraiton;
	

END_PROGRAM
PROGRAM _EXIT

	//Disable FBs
	MpAuditTrail_0(Enable := FALSE);
	MpAuditTrailUI_0(Enable := FALSE);
	 
END_PROGRAM
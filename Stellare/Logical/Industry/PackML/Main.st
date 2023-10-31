
PROGRAM _CYCLIC
	
	//Set FB parameters
	MpPackMLCore_0(
		MpLink := ADR(gPackMLCore),
		Enable := TRUE);
	
	MpPackMLMode_0(
		MpLink := ADR(gPackMLCore),
		Enable := TRUE,
		ModeID := PACKML_MODE_PRODUCTION,
		Start := gCoffeeMainLogic.cmdStart,
		Stop := gCoffeeMainLogic.cmdStop,
		Reset := MpPackMLStateIsActive(gPackMLCore,mpPACKML_STATE_STOPPED,PACKML_MODE_PRODUCTION),
		Abort := (gCoffeeMainLogic.cmdAbort AND MpPackMLMode_0.ModeActive), 
		Clear := gCoffeeMainLogic.cmdClear);

	MpPackMLMode_1(
		MpLink := ADR(gPackMLCore),
		Enable := TRUE,
		ModeID := PACKML_MODE_MAINTENANCE);
	
	MpPackMLBasicUI_0(
		MpLink := ADR(gPackMLCore),
		Enable := TRUE,
		UIConnect := ADR(MpPackMLBasicUIConnect));

	MpPackMLStatisticsUI_0(
		MpLink := ADR(gPackMLCore),
		Enable := TRUE,
		UIConnect := ADR(MpPackMLStatisticsUIConnect));
	

	//Check if you can refill the ingredients
	IF MpPackMLCore_0.Info.StateCurrent = 'Idle' OR MpPackMLCore_0.Info.StateCurrent = 'Aborted' THEN
		gCoffeeMainLogic.IdleState := TRUE;
	ELSE
		gCoffeeMainLogic.IdleState := FALSE;
	END_IF
	
END_PROGRAM
PROGRAM _EXIT
	
	//Disable FBs
	MpPackMLCore_0(Enable := FALSE);
	MpPackMLMode_0(Enable := FALSE);
	MpPackMLMode_1(Enable := FALSE);
	MpPackMLBasicUI_0(Enable := FALSE);
	MpPackMLStatisticsUI_0(Enable := FALSE);
	
	 
END_PROGRAM
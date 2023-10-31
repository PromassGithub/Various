
PROGRAM _CYCLIC
	
	//Set FB parameter:
	MpAlarmXCore_0(
		Enable := TRUE, 
		MpLink := ADR(gAlarmXCore));

	MpAlarmXListUI_0(
		MpLink := ADR(gAlarmXCore), 
		Enable := TRUE, 
		UIConnect := ADR(MpAlarmXListUIConnect));
	
	MpAlarmXHistory_0(
		MpLink := ADR(gAlarmXHistory), 
		Enable := TRUE, 
		DeviceName := ADR('mappDir'),
		Language := ADR(gSetLanguage));
	
	//Show Alarm-Button in Visualization
	IF MpAlarmXCore_0.ActiveAlarms <> 0 OR MpAlarmXCore_0.PendingAlarms <> 0 THEN
		AlarmButton := 1;
		gCoffeeMainLogic.cmdAbort := TRUE;
		gCoffeeMainLogic.cmdClear := FALSE;
	ELSE
		AlarmButton := 0;
		gCoffeeMainLogic.cmdClear := TRUE;
		gCoffeeMainLogic.cmdAbort := FALSE;
	END_IF
	
	IF gCoffeeMainLogic.IdleState AND AlarmButton = 0 THEN
		ChangeStyleAlarmButton := 1;
	ELSE
		ChangeStyleAlarmButton := 0;
	END_IF	
	
	IF MpAlarmXHistory_0.CommandDone = TRUE THEN
		MpAlarmXHistory_0.Export := FALSE;
	END_IF
	

	//Set Alarm-Video
	IF brsstrcmp(ADR(AlarmVideo), ADR("")) = 0 THEN
		AlarmInfo := FALSE;
	ELSE
		AlarmInfo := TRUE;
	END_IF
	
	FilterConfiguration;
	SortConfiguration;
	HistoryFilter;
	HistorySort;
	
	
END_PROGRAM

PROGRAM _EXIT
	
	//Disable FBs
	MpAlarmXCore_0(Enable := FALSE);
	MpAlarmXHistory_0(Enable := FALSE);
	MpAlarmXHistoryUI_0(Enable := FALSE);
	MpAlarmXListUI_0(Enable := FALSE);
	 
END_PROGRAM
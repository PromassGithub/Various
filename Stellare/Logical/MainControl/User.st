// use the MpUserLevel function to read the current user level so that a warning is displayed if too low for recipe changes
ACTION UserLevelCheck: 
	
	IF (MpUserXLevel(gUserXLogin) < 100) THEN
		MainCoffeeUIConnect.visShowUserLevelWarning := TRUE;
	ELSE	
		MainCoffeeUIConnect.visShowUserLevelWarning := FALSE;
	END_IF	
	
END_ACTION

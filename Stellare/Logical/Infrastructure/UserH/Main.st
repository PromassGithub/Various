PROGRAM _INIT

	LoginAsDefault := FALSE;
	
END_PROGRAM
PROGRAM _CYCLIC
		
	//Set FB parameters
	MpUserXLogin_0(
		Enable := TRUE,
		MpLink := ADR(gUserXLogin), 
		UserName := ADR(LOGIN_AS_DEFAULT_USERNAME),
		Password := ADR(LOGIN_AS_DEFAULT_PASSWORD));

	MpUserXManagerUI_0(
		Enable := TRUE,
		MpLink := ADR(gUserXLogin),
		UIConnect := ADR(MpUserXManagerUIConnect));
	
	MpUserXLoginUI_0(
		Enable := TRUE,
		UIConnect := ADR(MpUserXLoginUIConnect),
		MpLink := ADR(gUserXLogin));

	//Call Action
	mappViewConnection;
				 
END_PROGRAM
PROGRAM _EXIT

	//Disable FBs
	MpUserXLogin_0(Enable := FALSE, Login := FALSE); 	
	MpUserXManagerUI_0(Enable := FALSE);
	MpUserXLoginUI_0(Enable := FALSE);
	 
END_PROGRAM
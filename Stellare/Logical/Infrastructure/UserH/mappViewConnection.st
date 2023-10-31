
ACTION mappViewConnection: 

		//Set Login command to FALSE;
	IF MpUserXLogin_0.CommandDone = TRUE THEN
		MpUserXLogin_0.Login := FALSE;
		DeleteTextInput := TRUE ; 
	END_IF;
		
	
	//Log in as Anonymous
	IF MpUserXLogin_0.CurrentLevel = 0 THEN		
		TON_0(IN := TRUE, PT := T#1s5ms);
	ELSIF MpUserXLogin_0.CurrentLevel > 0 THEN
		TON_0(IN := FALSE, PT := T#1s5ms);
	END_IF
	
	IF ((MpUserXLogin_0.CurrentLevel = 0) AND (LoginAsDefault = TRUE)) OR TON_0.Q = TRUE THEN	
		TON_0(IN := FALSE, PT := T#1s5ms);
		MpUserXLogin_0.UserName := ADR(LOGIN_AS_DEFAULT_USERNAME);
		MpUserXLogin_0.Password := ADR(LOGIN_AS_DEFAULT_PASSWORD);
		MpUserXLogin_0.Login := TRUE;
		LoginAsDefault := FALSE;
	END_IF;
	
	//Set Role in Visualization
	IF MpUserXLogin_0.CurrentLevel = 100 THEN
		Role := 'Administrator';
		
	ELSIF MpUserXLogin_0.CurrentLevel = 50 THEN
		Role := 'Supervisor';
		
	ELSIF MpUserXLogin_0.CurrentLevel = 10 THEN
		Role := 'Operator';		
	ELSE
		Role := 'Anonymous';
	END_IF
	
	// Logout in mappView with valuechange in Eventbinding 
	IF MpUserXLoginUIConnect.MessageBox.ErrorNumber = 28672 OR MpUserXLoginUIConnect.MessageBox.ErrorNumber = 28673 OR MpUserXLoginUIConnect.MessageBox.ErrorNumber = 28680 THEN 
		MappViewLogout := 1;
	ELSIF MpUserXLoginUIConnect.MessageBox.ErrorNumber = 0 THEN
		MappViewLogout := 0;
	END_IF
	
	IF MpUserXLoginUIConnect.MessageBox.ErrorNumber <> 0 THEN
		ShowErrorLoginDialog := TRUE;
	ELSE
		ShowErrorLoginDialog := FALSE;
	END_IF


	
	
END_ACTION

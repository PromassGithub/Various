
PROGRAM _CYCLIC
	(* Insert code here *)
	
	CASE Status OF
		
		STOP:
			IF (glb_io.Di.Automatic AND (NOT glb_io.Di.Manual) AND glb_io.Di.Start) AND (glb_err.pending_alarms = 0) THEN 
				Status := AUTO;
				
			ELSIF ((NOT glb_io.Di.Automatic) AND glb_io.Di.Manual AND glb_io.Di.Start) AND (glb_err.pending_alarms = 0) THEN
				Status := MANUAL;
			ELSIF (glb_err.pending_alarms <> 0) THEN
				Status := ERR;
			END_IF
			
		AUTO: 
			IF glb_io.Di.Stop THEN 
				Status := STOP;
				last_cycle := 1;
			ELSIF (glb_err.pending_alarms <> 0) THEN
				Status := ERR;
			END_IF
			
		MANUAL:
			IF glb_io.Di.Stop THEN 
				Status := STOP;
			ELSIF (glb_err.pending_alarms <> 0) THEN
				Status := ERR;
			END_IF
		ERR:
			IF (glb_err.pending_alarms = 0) THEN 
				Status := STOP;
			END_IF
			
		  
	END_CASE;
	
	IF St_Gun = 0 THEN last_cycle := 0;	END_IF
	
	IF ((Status <> AUTO) AND (NOT last_cycle)) THEN St_Gun := 0; END_IF
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			IF glb_io.Di.Si_01 THEN St_Gun := 10; END_IF
		
		10:	//
			
			TON_01.IN := 1;
			
			IF TON_01.Q THEN St_Gun := 20; END_IF
			
		20:
			glb_io.Do.Piston_up := 1;
			IF glb_io.Di.Finecorsa THEN St_Gun := 30; END_IF
			
		30: //shoot
			glb_io.Do.Piston_gun_1 := 1;
			TON_02.IN := 1;
			
			IF TON_02.Q THEN St_Gun := 40; END_IF
		
		40: 
			IF NOT glb_io.Di.Si_01 THEN St_Gun := 50; END_IF
		
		50: // end & reset
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			glb_io.Do.Piston_gun_1 	:= 0;
			glb_io.Do.Piston_up		:= 0;
			St_Gun 					:= 0;
		
	END_CASE;
	
	
	TON_01;
	TON_02;
	TON_03;
	
	TON_01.PT := T#1s;
	TON_02.PT := T#50ms;
	TON_03.PT := T#1s;
	 
END_PROGRAM

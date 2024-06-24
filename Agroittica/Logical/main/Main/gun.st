
(* TODO: Add your comment here *)
FUNCTION_BLOCK gun
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			Ready := 1;
			
			
			IF (trigger_sensor) THEN St_Gun := 10;	END_IF;
		
		10:	// 
			Ready := 0;
			TON_01.IN := 1;
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
		20: // Piston up
			Ready := 0;
			Piston_out := 1;
			TON_08.IN := 1;
			
			IF (finecorsa AND (PT_piston_up = 0)) OR (TON_08.Q AND (PT_piston_up > 0)) THEN
				TON_08.IN 	:= 0;
				St_Gun 		:= 30; 
			END_IF;
			
		30: //shoot
			Ready := 0;
			IF Peso_ok THEN gun_out := 1; END_IF;
			
			TON_02.IN := 1;
			
			IF TON_02.Q THEN 				
				Piston_out 	:= 0;
				finecorsa		:= 0;
				St_Gun := 40; 
			END_IF;
		
		40: 
			Ready := 0;
			TON_03.IN := 1;
			end 	:= 1;
			IF((NOT trigger_sensor) AND TON_03.Q) THEN 
				St_Gun 	:= 50;
				end 	:= 0;
			END_IF;
		
		50: // end & reset
			Ready := 0;
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			TON_03.IN 				:= 0;
			TON_04.IN				:= 0;
			gun_out 				:= 0;
			Piston_out				:= 0;
			St_Gun 					:= 0;
			end 					:= 0;
		
	END_CASE;
	
	TON_01;
	TON_02;
	TON_03;
	TON_04;
	TON_08;
	
	TON_01.PT := PT_pist_Delay;		// tempo delay pistone sollevamento pesce
	IF (PT_trigger_gun > 0) THEN
		TON_02.PT := PT_trigger_gun;
	ELSE
		TON_02.PT := T#50ms; 			// tempo discesa pist soll
	END_IF
	TON_03.PT := PT_end_stop;		// tempo di attesa alla fine del ciclo
	TON_04.PT := T#1000ms;			// Sicurezza pistone soll
	TON_08.PT := PT_piston_up;		// Se imposto questo tempo il ritorno del pistone è comandato da questo timer + il tempo della pistola (ton_2)
	
	
END_FUNCTION_BLOCK

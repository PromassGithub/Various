FUNCTION_BLOCK gun
	
	CASE St_Gun OF
			
		0:	// idle/start
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			Ready 			:= 1;
			
			
			IF (trigger_sensor) THEN St_Gun := 10;	END_IF;
		
		10:	// start of TON_01 timer(timer that commands the main piston)
			Ready 		:= 0;
			TON_01.IN 	:= 1;
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
		20: // Main Piston up
			Ready 		:= 0;
			Piston_up 	:= 1;
			//start timer delays shot
			TON_08.IN 	:= 1;
			
			IF (finecorsa AND (PT_piston_up = 0)) OR (TON_08.Q AND (PT_piston_up > 0)) THEN
				TON_08.IN 	:= 0;
				St_Gun 		:= 30; 
			END_IF;
			
		30: //shoot
			Ready := 0;
			IF Peso_ok THEN gun_out := 1; END_IF;
			
			TON_02.IN := 1;
			
			IF TON_02.Q THEN 				
				Piston_up 		:= 0;
				Piston_down		:= 1;
				finecorsa		:= 0;
				St_Gun 			:= 40; 
			END_IF;
		
		40: 
			Ready 			:= 0;
			TON_03.IN 		:= 1;
			end 			:= 1;
			
			IF((NOT trigger_sensor) AND TON_03.Q) THEN 
				Clear_weight	:= 1;
				St_Gun 	:= 50;
				end 	:= 0;
			END_IF;
		
		50: // end & reset
			Ready := 0;
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			TON_03.IN 				:= 0;
			TON_04.IN				:= 0;
			TON_08.IN				:= 0;
			gun_out 				:= 0;
			Piston_out				:= 0;
			Piston_down				:= 0;
			Clear_weight			:= 0;
			St_Gun 					:= 0;
			end 					:= 0;
		
	END_CASE;
	
	TON_01;
	TON_02;
	TON_03;
	TON_04;
	TON_08;
	
	TON_01.PT := PT_pist_Delay;			//tempo delay pistone sollevamento pesce
	//PT_pist_Delay := T#1000ms;		//MOD FOR TEST 06/05/2025
	//TON_01.PT 		:= T#10000ms;	//MOD FOR TEST 10/12/2024
	IF (PT_trigger_gun > 0) THEN
		TON_02.PT 	:= PT_trigger_gun;
	ELSE
		TON_02.PT 	:= T#50ms; 			// tempo discesa pist soll
	END_IF
	TON_03.PT 		:= PT_end_stop;		// tempo di attesa alla fine del ciclo
	TON_04.PT 		:= T#1000ms;		// Sicurezza pistone soll
	TON_08.PT 		:= PT_piston_up;	// Se imposto questo tempo il ritorno del pistone è comandato da questo timer + il tempo della pistola (ton_2)
//	TON_08.PT 		:= T#10000ms;		//MOD FOR TEST 09/12/2024
	
END_FUNCTION_BLOCK


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
			END_IF;
			
		AUTO: 
			IF glb_io.Di.Stop THEN 
				Status := STOP;
				last_cycle := 1;
			ELSIF (glb_err.pending_alarms <> 0) THEN
				Status := ERR;
			END_IF;
			
		MANUAL:
			IF glb_io.Di.Stop THEN 
				Status := STOP;
			ELSIF (glb_err.pending_alarms <> 0) THEN
				Status := ERR;
			END_IF;
		ERR:
			IF (glb_err.pending_alarms = 0) THEN 
				Status := STOP;
			END_IF;
			
		  
	END_CASE;
	
	IF St_Gun = 0 THEN last_cycle := 0;	END_IF;
	
	IF ((Status <> AUTO) AND (NOT last_cycle)) THEN St_Gun := 0; END_IF;
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			IF glb_io.Di.Si_01 THEN St_Gun := 10; END_IF;
		
		10:	//
			
			TON_01.IN := 1;
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
		20:
			glb_io.Do.Piston_up := 1;
			
			IF (glb_io.Di.Finecorsa) THEN 
				St_Gun := 30; 
			END_IF;
			
		30: //shoot 
			IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active) AND Pesi_0.Cmd_Shoot) THEN
				glb_io.Do.Piston_gun_1 := 1;
			ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active) AND Pesi_0.Cmd_Shoot) THEN
				glb_io.Do.Piston_gun_2 :=1;
			END_IF;
			
			R_TRIG_01 (CLK := glb_io.Do.Piston_gun_1); 
			glb_cmd.sparo := R_TRIG_01.Q;
			
			R_TRIG_02 (CLK := glb_io.Do.Piston_gun_2);
			glb_cmd_2.sparo := R_TRIG_02.Q;
			
			TON_02.IN := 1;
			
			IF TON_02.Q THEN St_Gun := 40; END_IF;
		
		40: 
			IF NOT glb_io.Di.Si_01 THEN St_Gun := 50; END_IF;
		
		50: // end & reset
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			glb_io.Do.Piston_gun_1 	:= 0;
			glb_io.Do.Piston_gun_2 	:= 0;
			glb_io.Do.Piston_up		:= 0;
			St_Gun 					:= 0;
			R_TRIG_01.CLK 			:= 0;
			R_TRIG_02.CLK			:= 0;
		
	END_CASE;
	
	
	TON_01;
	TON_02;
	TON_03;
	
	TON_01.PT := Tempo_Delay;
	TON_02.PT := T#50ms;
	TON_03.PT := T#250ms;
	
	R_TRIG_01;
	R_TRIG_02;
	
//	CASE Manual_Gun_0.Gun_Status OF		//Gun Selection at boot up
//		
//		0:						//Start
//			IF (Status = STOP AND glb_err.pending_alarms = 0 AND (NOT Empty_Mag_1_0.Empty_Mag_Sensor) AND (NOT Empty_Mag_22.Empty_Mag_Sensor) AND (NOT glb_hmi.Inp.Gun_1_HMI) AND (NOT glb_hmi.Inp.Gun_2_HMI)) THEN
//				Manual_Gun_0.Gun_Status := 1;
//			END_IF;
//			
//			Manual_Gun_0.Gun_Pop_up := 1;
//			
//		1:						//Pop up
//			Manual_Gun_0.Gun_Pop_up := 0;
//			Manual_Gun_0.Gun_Status := 10;
//			
//		10:						//Choose gun
//			IF (glb_hmi.Inp.Gun_1_HMI OR glb_hmi.Inp.Gun_2_HMI) THEN
//				Manual_Gun_0.Gun_Pop_up := 1;
//				Manual_Gun_0.Gun_Status:= 20;
//			END_IF;
//			
//		20:						//Back to start
//			Manual_Gun_0.Gun_Status:= 0;
//			
//	END_CASE;
	
	//--------------------SWITCH PISTOLE-----------------------
	
	CASE Gun_Switch_0.Gun_Switch_Status OF
		
		0:									//Start
			IF ( Status = AUTO OR Status = MANUAL) AND (glb_err.pending_alarms = 0) THEN
				Gun_Switch_0.Gun_Switch_Status := 1;
			END_IF;
			
		1:									//Controllo sensori
			IF (NOT Empty_Mag_1_0.Empty_Mag_Sensor AND NOT Empty_Mag_22.Empty_Mag_Sensor) THEN
				Gun_Switch_0.Gun_Switch_Status := 10;
			END_IF;
		
		10:									//Gun_1 attiva
			Gun_Switch_0.Gun_1_Active := 1;
			Gun_Switch_0.Gun_2_Active := 0;
			
			IF Empty_Mag_1_0.Empty_Mag_Sensor THEN Gun_Switch_0.Gun_Switch_Status := 20; END_IF;
			
			IF ( Status <> AUTO AND Status <> MANUAL ) THEN Gun_Switch_0.Gun_Switch_Status := 30; END_IF;
		
		20:									//Gun_2 attiva
			Gun_Switch_0.Gun_2_Active := 1;
			Gun_Switch_0.Gun_1_Active := 0;
			
			IF Empty_Mag_22.Empty_Mag_Sensor THEN Gun_Switch_0.Gun_Switch_Status := 10; END_IF;
		
			IF ( Status <> AUTO AND Status <> MANUAL ) THEN Gun_Switch_0.Gun_Switch_Status := 30; END_IF;
		
		30:									//Reset & Back to start
			Gun_Switch_0.Gun_1_Active := 0;
			Gun_Switch_0.Gun_2_Active := 0;
			
			Gun_Switch_0.Gun_Switch_Status := 0;
			
	END_CASE;
	
	//--------------------FLAP DIRECTION-----------------------
	
	CASE Flap_MM_0.Flap_status OF									//sincronizzazione convogliatore con pistole
		
		0:									//Start
			IF ( Status = AUTO OR Status = MANUAL) AND ( glb_err.pending_alarms = 0) THEN
				Flap_MM_0.Flap_status := 10;
			END_IF;
			
		10:									//Gun Active check
			IF Gun_Switch_0.Gun_1_Active THEN
				Flap_MM_0.Flap_status := 20;
			ELSIF Gun_Switch_0.Gun_2_Active THEN
				Flap_MM_0.Flap_status := 30;
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		20:									//Convogliatore verso Gun_1
			Flap_MM_0.Flap_Right := 1;
			Flap_MM_0.Flap_Left := 0;
			
			IF Flap_MM_0.Flap_Right THEN
				glb_io.Do.Piston_Flap_Dx_Sx := 1;
			END_IF;
			
			IF Gun_Switch_0.Gun_2_Active THEN Flap_MM_0.Flap_status := 30; END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		30:									//Convogliatore verso Gun_2
			Flap_MM_0.Flap_Left := 1;
			Flap_MM_0.Flap_Right := 0;
			
			IF Flap_MM_0.Flap_Left THEN
				glb_io.Do.Piston_Flap_Dx_Sx := 0;
			END_IF;
			
			IF Gun_Switch_0.Gun_1_Active THEN Flap_MM_0.Flap_status := 20; END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		40:									//Reset & back to start
			Flap_MM_0.Flap_Left := 0;
			Flap_MM_0.Flap_Right := 0;
			
			Flap_MM_0.Flap_status := 0;
			
	END_CASE;
	
			
	
	//--------------------PESI---------------------------------
	
	CASE Pesi_0.Weight_Status OF							//Gestione peso pesci
		
		0: 							//Start
			IF ( Status = AUTO AND glb_err.pending_alarms = 0) THEN
				Pesi_0.Weight_Status := 10;
			END_IF;
		
		10:							//Controllo pesi
			IF (Pesi_0.Marel_Weight[0] <= Pesi_0.Max_Weight AND Pesi_0.Marel_Weight[0] >= Pesi_0.Min_Weight) THEN
				Pesi_0.Weight_Status := 20;
			ELSE
				Pesi_0.Weight_Status := 30;
			END_IF;
			
		20:							//Abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 1;
			Pesi_0.Weight_Status := 0;
		
		30:							//Non abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 0;
			Pesi_0.Weight_Status := 0;
				
			
	END_CASE;
	
	
	//--------------------AUTO-FISH-----------------------------
	
	CASE Auto_fish_0.Fish_status OF				//Simulatore Pesce per TEST binario caricatore
		
		0:
			TON_03.IN := 0;
			
			IF ( Status = AUTO AND Auto_fish_0.Fish_Start) THEN
				Auto_fish_0.Fish_status := 10;
			END_IF;
			
			
		10:
			glb_io.Di.Si_01 :=1;
			
			TON_03.IN := 1;
			
			IF TON_03.Q THEN
				Auto_fish_0.Fish_status := 20;
			END_IF;
	
			IF ( Status <> AUTO) THEN Auto_fish_0.Fish_status := 31; END_IF;
			
		20:
			glb_io.Di.Finecorsa := 1;
			Auto_fish_0.Fish_status := 30;
			
			IF ( Status <> AUTO) THEN Auto_fish_0.Fish_status := 31; END_IF;
			
		30:
			glb_io.Di.Si_01 := 0;
			glb_io.Di.Finecorsa := 0;
			
			Auto_fish_0.Fish_status := 0;
			
		31:
			glb_io.Di.Si_01 := 0;
			glb_io.Di.Finecorsa := 0;
			Auto_fish_0.Fish_Start := 0;
		
			Auto_fish_0.Fish_status := 0;
		
	END_CASE;
	
	
	
	//--------------------MATH-----------1-----------------------
	
	//Calcolo tempo delay sollevamento pesce
	
	Tempo := (Distanza_Sensore_Gun/STP_01_Vel)*1000;
	
	Tempo_Delay := REAL_TO_TIME (Tempo);
	
	//STP_01_Pos;
	
	//--------------------AIR------------------------------------
	
	//Feedback air supply
	
	IF (NOT Feedback_0.Feedback_Air) THEN
		glb_err.Air := TRUE;
	ELSE
		glb_err.Air := FALSE;
	END_IF;
	
	//--------------------PLC------------------------------------
	
	//Feedback fungo emergenza
	
	IF ( Feedback_0.Feedback_PLC ) THEN
		glb_err.PLC := TRUE;
	ELSE
		glb_err.PLC := FALSE;
	END_IF;
	
	 
END_PROGRAM

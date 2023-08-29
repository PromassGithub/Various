
PROGRAM _CYCLIC
	(* Insert code here *)
	(*glb_err.pending_alarms := 0;*)
	
	// stato generale STOP-AUTO-MANUAL-ERR
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
	
	// 2023 - FORZATURA SPEGNIMENTO PISTONE SOLLEVAMENTO
	IF (Piston_st) THEN
		TON_04.IN := 1;
	ELSE 
		TON_04.IN := 0;
	END_IF;
	
	IF TON_04.Q THEN
		Piston_st := 0;
		St_Gun := 50;
	END_IF;		

	

	
	//2023 - FORZATURA MAG2 POP UP
	
	Empty_Mag_22.Empty_Mag_Pop_Up := 1;
	
	//2023 - SICUREZZA PESCE INCASTRATO
	
//	CASE St_Fish OF
//		
//		0:
//			IF (Status = AUTO OR Status = MANUAL) THEN
//				St_Fish := 10;
//			END_IF;
//			
//		10:
//			
//			R_TRIG_03 (CLK := glb_io.Di.Si_01);
//			Start_Safety := R_TRIG_03.Q;
//		
//			R_TRIG_04 (CLK := glb_io.Di.Si_03);
//			Stop_Safety := R_TRIG_04.Q;
//		
//			IF (Start_Safety) THEN
//				TON_05.IN := 1;
//				St_Fish := 20;
//			END_IF;
//			
//			IF (Status <> AUTO AND Status <> MANUAL) THEN St_Fish := 30; END_IF;
//		
//		20:
//			IF (TON_05.Q) THEN
//				glb_err.Fish := 1;
//				glb_io.Do.MainAllarm:= 1;
//				R_TRIG_03.CLK := 0;
//			END_IF;
//			
//			IF (Stop_Safety) OR (Allarm_0.Ack) THEN
//				St_Fish := 30;
//				R_TRIG_04.CLK := 0;
//			END_IF;
//			
//			IF (Status <> AUTO AND Status <> MANUAL) THEN St_Fish := 30; END_IF;
//			
//		30:
//			TON_05.IN := 0;	
//			R_TRIG_03.CLK := 0;
//			R_TRIG_04.CLK := 0;
//			glb_io.Do.MainAllarm := 0;
//			St_Fish := 0;
//		
//	END_CASE;
	
	IF St_Gun = 0 THEN last_cycle := 0;	END_IF;
	
	IF ((Status <> AUTO) AND (NOT last_cycle)) THEN St_Gun := 0; END_IF;
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			
			IF (glb_io.Di.Si_01) THEN St_Gun := 10; END_IF;
		
		10:	//
			
			TON_01.IN := 1;
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
		20:
			Piston_st := 1;
			TON_08.IN := 1;
			
			IF (glb_io.Di.Finecorsa AND (Ricette.PT_piston_up = 0)) OR (TON_08.Q AND (Ricette.PT_piston_up > 0)) THEN
				TON_08.IN := 0;
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
			
			IF TON_02.Q THEN 
				Piston_st				:= 0;
				glb_io.Di.Finecorsa		:= 0;
				St_Gun := 40; 
			END_IF;
		
		40: 
			TON_03.IN := 1;
			IF(NOT glb_io.Di.Si_01 AND TON_03.Q) THEN 
				St_Gun := 50;
				glb_fish_shot_ons := 0;
			END_IF;
		
		50: // end & reset
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			TON_03.IN 		:= 0;
			TON_04.IN		:= 0;
			glb_io.Do.Piston_gun_1 	:= 0;
			glb_io.Do.Piston_gun_2 	:= 0;
			Piston_st				:= 0;
			St_Gun 					:= 0;
			R_TRIG_01.CLK 			:= 0;
			R_TRIG_02.CLK			:= 0;
		
	END_CASE;
	
	//--------------------SWITCH PISTOLE-----------------------
	
	CASE Gun_Switch_0.Gun_Switch_Status OF
		
		0:	//Start
			IF ( Status = AUTO OR Status = MANUAL) AND (glb_err.pending_alarms = 0) THEN
				Gun_Switch_0.Gun_Switch_Status := 1;
			END_IF;
			
		1:	//Controllo sensori
			IF (NOT Empty_Mag_1_0.Empty_Mag_Sensor AND NOT Empty_Mag_22.Empty_Mag_Sensor) THEN
				Gun_Switch_0.Gun_Switch_Status := 10;
			END_IF;
		
		10:	//Gun_1 attiva
			Gun_Switch_0.Gun_1_Active := 1;
			Gun_Switch_0.Gun_2_Active := 0;
			
			IF Empty_Mag_1_0.Empty_Mag_Sensor THEN 
				glb_cmd.Cartridge_loaded := 0;
				Gun_Switch_0.Gun_Switch_Status := 20;
			ELSIF (Empty_Mag_1_0.Empty_Mag_Sensor AND glb_hmi.Inp.Lock_Gun_2) THEN
				Gun_Switch_0.Gun_Switch_Status := 10;	
			END_IF;
			
			IF ( Status <> AUTO AND Status <> MANUAL ) THEN Gun_Switch_0.Gun_Switch_Status := 30; END_IF;
		
		20:	//Gun_2 attiva
			Gun_Switch_0.Gun_2_Active := 1;
			Gun_Switch_0.Gun_1_Active := 0;
			
			// 2023 - provvisorio quando la cartuccia è ricaricata torna a utilizzare la pistola 1
			IF (Empty_Mag_22.Empty_Mag_Sensor OR (glb_cmd.Cartridge_loaded = 1)) THEN 
				Gun_Switch_0.Gun_Switch_Status := 10;
			ELSIF (Empty_Mag_22.Empty_Mag_Sensor AND glb_hmi.Inp.Lock_Gun_1) THEN
				Gun_Switch_0.Gun_Switch_Status := 20;	
			END_IF;
		
			IF ( Status <> AUTO AND Status <> MANUAL ) THEN Gun_Switch_0.Gun_Switch_Status := 30; END_IF;
		
		30:	//Reset & Back to start
			Gun_Switch_0.Gun_1_Active := 0;
			Gun_Switch_0.Gun_2_Active := 0;
			
			Gun_Switch_0.Gun_Switch_Status := 0;
			
	END_CASE;
	
	//--------------------FLAP DIRECTION-----------------------
	
	CASE Flap_MM_0.Flap_status OF	//sincronizzazione convogliatore con pistole
		
		0:	//Start
			IF ( Status = AUTO OR Status = MANUAL) AND ( glb_err.pending_alarms = 0) THEN
				Flap_MM_0.Flap_status := 10;
			END_IF;
			
		10:	//Gun Active check
			IF Gun_Switch_0.Gun_1_Active THEN
				Flap_MM_0.Flap_status := 20;
			ELSIF Gun_Switch_0.Gun_2_Active THEN
				Flap_MM_0.Flap_status := 30;
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		20:	//Convogliatore verso Gun_1
			Flap_MM_0.Flap_Right := 0;
			Flap_MM_0.Flap_Left := 1;
			
			IF Flap_MM_0.Flap_Left THEN
				glb_io.Do.Piston_Flap_Dx_Sx := 0;
			END_IF;
			
			IF Gun_Switch_0.Gun_2_Active THEN Flap_MM_0.Flap_status := 30; END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		30:	//Convogliatore verso Gun_2
			Flap_MM_0.Flap_Left := 0;
			Flap_MM_0.Flap_Right := 1;
			
			IF Flap_MM_0.Flap_Right THEN
				glb_io.Do.Piston_Flap_Dx_Sx := 1;
			END_IF;
			
			IF Gun_Switch_0.Gun_1_Active THEN Flap_MM_0.Flap_status := 20; END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN Flap_MM_0.Flap_status := 40; END_IF;
			
		40:	//Reset & back to start
			Flap_MM_0.Flap_Left := 0;
			Flap_MM_0.Flap_Right := 0;
			
			Flap_MM_0.Flap_status := 0;
			
	END_CASE;
	
			
	
	//--------------------PESI---------------------------------
	
	CASE Pesi_0.Weight_Status OF	//Gestione peso pesci
		
		0: 	//Start
			IF ( Status = AUTO AND glb_err.pending_alarms = 0) THEN
				Pesi_0.Weight_Status := 10;
			END_IF;
		
		10:	//Controllo pesi
			IF (Pesi_0.Marel_Weight[0] <= Pesi_0.Max_Weight AND Pesi_0.Marel_Weight[0] >= Pesi_0.Min_Weight) THEN
				Pesi_0.Weight_Status := 20;
			ELSE
				Pesi_0.Weight_Status := 30;
			END_IF;
			
		20:	//Abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 1;
			Pesi_0.Weight_Status := 0;
		
		30:	//Non abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 0;
			Pesi_0.Weight_Status := 0;
				
			
	END_CASE;	
	
	//--------------------MATH-----------1-----------------------
	
	//Calcolo tempo delay sollevamento pesce
	IF (STP_01_Vel = 0) THEN STP_01_Vel:= 0.5; END_IF;
	Tempo := Ricette.D_Sens_Gun/STP_01_Vel*1000;
	
	Tempo_Delay := REAL_TO_TIME (Tempo);
	
	//--------------------AIR------------------------------------
	
	//Feedback air supply
	
	IF (NOT Feedback_0.Feedback_Air) THEN
		glb_err.Air := TRUE;
	ELSE
		glb_err.Air := FALSE;
	END_IF;
	
	//--------------------Emergenze------------------------------------
	
	//Feedback fungo emergenza
	
	IF (NOT Feedback_0.Feedback_Em_Bt) THEN
		glb_err.Em_Bt := TRUE;
	ELSE
		glb_err.Em_Bt:= FALSE;
	END_IF;	
	
	
	// ATTIVAZIONE/SPEGNIMENTO BOBINE PNEUMATICA
	IF (Status = AUTO) THEN
		IF (Piston_st) THEN
			glb_io.Do.Main_Piston_Up 	:= 1;
			glb_io.Do.Main_Piston_Down 	:= 0;
		ELSE
			glb_io.Do.Main_Piston_Up 	:= 0;
			glb_io.Do.Main_Piston_Down 	:= 1;
		END_IF;
		
	ELSIF ((Status = STOP) OR (Status = ERR)) THEN
		glb_io.Do.Main_Piston_Up 	:= 0;
		glb_io.Do.Main_Piston_Down 	:= 0;
	END_IF;
	
	
	// temporizzatori
	TON_01;
	TON_02;
	TON_03;
	TON_04;
	TON_05;
			
	TON_01.PT := Tempo_Delay;
	TON_02.PT := T#50ms; 					// tempo discesa pist soll
	TON_03.PT := Ricette.PT_end_stop;		// tempo di attesa alla fine del ciclo
	TON_04.PT := T#1000ms;					// Sicurezza pistone soll
	TON_05.PT := T#1500ms;					// Sicurezza pesci
	TON_08.PT := Ricette.PT_piston_up		// Se imposto questo tempo il ritorno del pistone è comandato da queto timer + il tempo della pistola (ton_2)
	
	R_TRIG_01;
	R_TRIG_02;
	R_TRIG_03;
	R_TRIG_04;
	 
END_PROGRAM

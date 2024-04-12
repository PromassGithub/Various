
PROGRAM _CYCLIC
	(* Insert code here *)
	(*glb_err.pending_alarms := 0;*)
	
	IF (SIMU.enable) THEN glb_err.pending_alarms := 0; END_IF
	
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
	
	(*Empty_Mag_22.Empty_Mag_Pop_Up := 1;*)
	
	// Main cycle
	IF St_Gun = 0 THEN last_cycle := 0;	END_IF;
	
	IF ((Status <> AUTO) AND (NOT last_cycle)) THEN St_Gun := 0; END_IF;
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			IF (glb_io.Di.Si_01 AND (NOT Ricette.use_weight)) THEN 
				St_Gun 			:= 10;
			ELSIF (Ricette.use_weight) THEN
				St_Gun 			:= 0;
			END_IF;
		
		10:	// 
			
			TON_01.IN := 1;	
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
			
		20: // Piston up
			IF (Pesi_0.Cmd_Shoot) THEN Piston_st := 1; END_IF
			TON_08.IN := 1;
			
			IF (glb_io.Di.Finecorsa AND (Ricette.PT_piston_up = 0)) OR (TON_08.Q AND (Ricette.PT_piston_up > 0)) THEN
				TON_08.IN := 0;
				St_Gun := 30; 
			END_IF;
			
		30: //shoot 
			IF (Pesi_0.Cmd_Shoot) THEN
				IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active) AND Pesi_0.Cmd_Shoot) THEN
					glb_io.Do.Piston_gun_1 := 1;
				ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active) AND Pesi_0.Cmd_Shoot) THEN
					glb_io.Do.Piston_gun_2 :=1;
				END_IF;
			END_IF
			
			R_TRIG_01 (CLK := glb_io.Do.Piston_gun_1); 
			glb_cmd.sparo := R_TRIG_01.Q;
			
			R_TRIG_02 (CLK := glb_io.Do.Piston_gun_2);
			glb_cmd_2.sparo := R_TRIG_02.Q;
			
			TON_02.IN := 1;
			
//			//............................................ modifica 17/01/24 .............................................//
//			Piston_st				:= 0;
//			//............................................ fine modifica 17/01/24 ........................................//
			
			IF TON_02.Q THEN 
				Piston_st				:= 0;
				glb_io.Di.Finecorsa		:= 0;
				St_Gun := 40; 
			END_IF;
		
		40: 
			TON_03.IN := 1;
			IF((NOT glb_io.Di.Si_01) AND TON_03.Q) THEN 
				St_Gun := 50;
				glb_fish_shot_ons := 0;
				glb_st_gun_wait := 1;
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
	
	//buffer_gun[1] = Gun_01
	//buffer_gun[2] = Gun_02
	//buffer_gun[3] = Gun_03
	//buffer_gun[4] = Gun_04
	//buffer_gun[5] = Gun_05
	
	CASE xxx OF
		0: 
//			IF (glb_registered AND Ricette.use_weight) THEN xxx := 10; END_IF
		10:
			glb_registered := 0;
			FOR i:=1 TO 5 DO
				IF (buffer_gun[i] = 0) THEN
					buffer_gun[i] := 1; 
					i := 10;
					xxx := 20;
				END_IF
			END_FOR;
		20:
			xxx := 0;
		
	END_CASE
	
	IF (glb_registered AND Ricette.use_weight) THEN
//		calcolatore := calcolatore+1;
		glb_registered := 0;
		IF ((buffer_gun[1] = 0) AND Gun_0x[1].Ready) THEN
//			calcolatore1 := calcolatore1+1;
			buffer_gun[1] := 1;
		ELSIF ((buffer_gun[2] = 0 AND Gun_0x[2].Ready)) THEN
			buffer_gun[2] := 1;   // ...........................................questo qui!...........................................
//			calcolatore1 := calcolatore1+1;
		ELSIF ((buffer_gun[3] = 0 AND Gun_0x[3].Ready)) THEN
			buffer_gun[3] := 1;
//			calcolatore1 := calcolatore1+1;
		ELSIF ((buffer_gun[4] = 0 AND Gun_0x[4].Ready)) THEN
			buffer_gun[4] := 1;
//			calcolatore1 := calcolatore1+1;
		ELSIF ((buffer_gun[5] = 0 AND Gun_0x[5].Ready)) THEN
			buffer_gun[5] := 1;
//			calcolatore1 := calcolatore1+1;
		END_IF
		
	END_IF
	
	IF ( Status = AUTO AND Ricette.use_weight) THEN
	
		Gun_0x[1].trigger_sensor := buffer_gun[1];
		Gun_0x[2].trigger_sensor := buffer_gun[2];
		Gun_0x[3].trigger_sensor := buffer_gun[3];
		Gun_0x[4].trigger_sensor := buffer_gun[4];
		Gun_0x[5].trigger_sensor := buffer_gun[5];
		Gun_0x[6].trigger_sensor := buffer_gun[6];
	
		IF (Gun_0x[1].end) THEN buffer_gun[1] := 0; END_IF;
		IF (Gun_0x[2].end) THEN buffer_gun[2] := 0; END_IF;
		IF (Gun_0x[3].end) THEN buffer_gun[3] := 0; END_IF;
		IF (Gun_0x[4].end) THEN buffer_gun[4] := 0; END_IF
		IF (Gun_0x[5].end) THEN buffer_gun[5] := 0; END_IF
		IF (Gun_0x[6].end) THEN buffer_gun[6] := 0; END_IF
	
		gun_0x_piston 	:= (Gun_0x[1].Piston_out OR Gun_0x[2].Piston_out OR Gun_0x[3].Piston_out OR Gun_0x[4].Piston_out OR Gun_0x[5].Piston_out);
		gun_0x_gun 		:= (Gun_0x[1].gun_out OR Gun_0x[2].gun_out OR Gun_0x[3].gun_out OR Gun_0x[4].gun_out OR Gun_0x[5].gun_out);
//		Lamp_02.Lamp2Bianco := gun_0x_gun;
		
		IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active)) THEN
			glb_io.Do.Piston_gun_1 := gun_0x_gun;
			IF gun_0x_gun THEN	glb_cmd.sparo := 1; END_IF
		ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active)) THEN
			glb_io.Do.Piston_gun_2 := gun_0x_gun;
			IF gun_0x_gun THEN	glb_cmd_2.sparo := 1; END_IF
		END_IF;
		
	ELSE
		
		Gun_0x[1].trigger_sensor := buffer_gun[1] := 0;
		Gun_0x[2].trigger_sensor := buffer_gun[2] := 0;
		Gun_0x[3].trigger_sensor := buffer_gun[3] := 0;
		Gun_0x[4].trigger_sensor := buffer_gun[4] := 0;
		Gun_0x[5].trigger_sensor := buffer_gun[5] := 0;
		Gun_0x[6].trigger_sensor := buffer_gun[6] := 0;
		
	
	END_IF
	
	
	
	//--------------------GUN SWITCH-------------------------
	
	CASE Gun_Switch_0.Gun_Switch_Status OF
		
		0:	//Start
			IF (Status = AUTO AND glb_err.pending_alarms = 0) THEN
				Gun_Switch_0.Gun_Switch_Status := 1;
			END_IF;
			
		1:	//Controllo sensori
			
			IF (NOT Empty_Mag_1_0.Empty_Mag_Sensor AND glb_cmd.Cartridge_loaded_Gun) THEN
				Gun_Switch_0.Gun_Switch_Status := 10;
			ELSIF (NOT Empty_Mag_22.Empty_Mag_Sensor AND glb_cmd_2.Cartridge_loaded_Gun) THEN
				Gun_Switch_0.Gun_Switch_Status := 20;
			ELSE
				Gun_Switch_0.Gun_Switch_Status := 0;
			END_IF
		
		10:	//Gun_1 attiva
			Gun_Switch_0.Gun_1_Active := 1;
			Gun_Switch_0.Gun_2_Active := 0;
			
			IF (Empty_Mag_1_0.Empty_Mag_Sensor OR (NOT glb_cmd.Cartridge_loaded_Gun)) THEN
				glb_cmd.Cartridge_loaded_Gun := 0;
				Gun_Switch_0.Gun_Switch_Status := 30;
			END_IF
			
			IF ( Status <> AUTO AND Status <> MANUAL ) THEN Gun_Switch_0.Gun_Switch_Status := 30; END_IF;
		
		20:	//Gun_2 attiva
			Gun_Switch_0.Gun_2_Active := 1;
			Gun_Switch_0.Gun_1_Active := 0;
			
			IF (Empty_Mag_22.Empty_Mag_Sensor OR (NOT glb_cmd_2.Cartridge_loaded_Gun)) THEN
				glb_cmd_2.Cartridge_loaded_Gun := 0;
				Gun_Switch_0.Gun_Switch_Status := 30;
			END_IF
		
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
	
	//Gestione peso pesci
	CASE Pesi_0.Weight_Status OF	
		
		0: 	//Start
			IF ( Status = AUTO AND glb_err.pending_alarms = 0) THEN
				Pesi_0.Weight_Status := 10;
			END_IF;
		
		10:	//Controllo pesi
			IF (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_A AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_A) OR (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_B AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_B) THEN
//				Pesi_0.Weight_Status := 20;
				Pesi_0.Cmd_Shoot := 1;
			ELSE
//				Pesi_0.Weight_Status := 30;
				Pesi_0.Cmd_Shoot := 0;
			END_IF;
			
		20:	//Abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 1;
			Pesi_0.Weight_Status := 0;
		
		30:	//Non abilitato allo sparo & back to start
			Pesi_0.Cmd_Shoot := 0;
			Pesi_0.Weight_Status := 0;
				
	END_CASE;
	
	IF (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_A AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_A) OR (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_B AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_B) THEN
		Pesi_0.Cmd_Shoot := 1;
	ELSE
		Pesi_0.Cmd_Shoot := 0;
	END_IF;
	
	//---------------VACUUM-CONTROL----------------------------
	
	CASE Vac_Status OF
		
		0:	//Start 
			glb_io.Do.Vacuum_On_Off := 0;
			IF ((Status = AUTO OR Status = MANUAL) AND glb_err.pending_alarms = 0) THEN
				Vac_Status := 1;
			END_IF;
			
		1:	//Vacuum ON
			glb_io.Do.Vacuum_On_Off := 1;
			
			IF ((Status <> AUTO) AND (Status <> MANUAL)) THEN Vac_Status := 0; END_IF;
		
	END_CASE;
				
	
	//--------------------MATH----------------------------------
	
	STP_01_Vel := 7000;
	
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
	
	//------------------ELETTROVALVOLE---------------------------------
	
	// ATTIVAZIONE/SPEGNIMENTO BOBINE PNEUMATICA
	IF (Status = AUTO AND glb_err.pending_alarms = 0 AND NOT(Status = MANUAL)) THEN
		IF (Piston_st OR gun_0x_piston) THEN
			glb_io.Do.Main_Piston_Up 	:= 1;
			glb_io.Do.Main_Piston_Down 	:= 0;
		ELSE
			glb_io.Do.Main_Piston_Up 	:= 0;
			glb_io.Do.Main_Piston_Down 	:= 1;
		END_IF;
		
	ELSIF (Status = MANUAL AND glb_err.pending_alarms = 0 AND NOT(Status = AUTO)) THEN
		IF (cmd_manu_Piston_st) THEN
			glb_io.Do.Main_Piston_Up 	:= 1;
			glb_io.Do.Main_Piston_Down 	:= 0;
		ELSE
			glb_io.Do.Main_Piston_Up 	:= 0;
			glb_io.Do.Main_Piston_Down 	:= 1;
		END_IF;
		
	ELSIF ((Status <> AUTO) OR (Status <> MANUAL) OR (glb_err.pending_alarms <> 0)) THEN
		glb_io.Do.Main_Piston_Up 	:= 0;
		glb_io.Do.Main_Piston_Down 	:= 0;
	END_IF;
	
	//Controllo manuale valvola pistone soll
	IF ( Status = MANUAL AND glb_err.pending_alarms = 0) THEN
		IF ( glb_hmi.Inp.Soll_Valve_HMI ) THEN 
			cmd_manu_Piston_st := 1; 
		ELSE 
			cmd_manu_Piston_st := 0; 
		END_IF;
		
	ELSIF ((Status <> MANUAL) OR (glb_err.pending_alarms <> 0)) THEN
		cmd_manu_Piston_st 	:= 0;
	END_IF;
	
	//Controllo manuale valvole pistoni grilletti pistole
	IF ( Status = MANUAL AND glb_err.pending_alarms = 0 ) THEN
		IF ( glb_hmi.Inp.Gun_1_HMI_Trig_Man ) THEN
			glb_io.Do.Piston_gun_1 := 1;
		ELSE
			glb_io.Do.Piston_gun_1 := 0;
		END_IF;
		IF (glb_hmi.Inp.Gun_2_HMI_Trig_Man) THEN
			glb_io.Do.Piston_gun_2 := 1;
		ELSE
			glb_io.Do.Piston_gun_2 := 0;
		END_IF;
		
	ELSIF ((Status <> MANUAL) AND (glb_err.pending_alarms <> 0)) THEN
		glb_io.Do.Piston_gun_1 := 0;
		glb_io.Do.Piston_gun_2 := 0;
	END_IF;
	
	
	// temporizzatori
	TON_01;
	TON_02;
	TON_03;
	TON_04;
	TON_05;
	TON_06;
	TON_08;
			
	Gun_0x[1].PT_pist_Delay := Gun_0x[2].PT_pist_Delay := Gun_0x[3].PT_pist_Delay := Gun_0x[4].PT_pist_Delay := Gun_0x[5].PT_pist_Delay := Gun_0x[6].PT_pist_Delay := Ricette.PT_ritardo;
	TON_01.PT := Tempo_Delay;				// tempo delay pistone sollevamento pesce
	TON_02.PT := Ricette.PT_gun; 					// tempo trigger pistola
	Gun_0x[1].PT_trigger_gun := Gun_0x[2].PT_trigger_gun := Gun_0x[3].PT_trigger_gun := Gun_0x[4].PT_trigger_gun := Gun_0x[5].PT_trigger_gun := Gun_0x[6].PT_trigger_gun := Ricette.PT_gun;
	Gun_0x[1].PT_end_stop := Gun_0x[2].PT_end_stop := Gun_0x[3].PT_end_stop := Gun_0x[4].PT_end_stop := Gun_0x[5].PT_end_stop := Gun_0x[6].PT_end_stop := TON_03.PT := Ricette.PT_end_stop;		// tempo di attesa alla fine del ciclo
	TON_04.PT := T#1000ms;					// Sicurezza pistone soll
	TON_05.PT := T#1500ms;					// Sicurezza pesci
	Gun_0x[1].PT_piston_up := Gun_0x[2].PT_piston_up := Gun_0x[3].PT_piston_up := Gun_0x[4].PT_piston_up := Gun_0x[5].PT_piston_up := Gun_0x[6].PT_piston_up := TON_08.PT := Ricette.PT_piston_up;		// Se imposto questo tempo il ritorno del pistone è comandato da queto timer + il tempo della pistola (ton_2)
	TON_06.PT := T#750ms;
	
	
	R_TRIG_01;
	R_TRIG_02;
	R_TRIG_03;
	R_TRIG_04;
	
	Gun_0x[0];
	Gun_0x[1];
	Gun_0x[2];
	Gun_0x[3];
	Gun_0x[4];
	Gun_0x[5];
	Gun_0x[6];
	Gun_0x[7];
	
	Gun_0x[1].Peso_ok := 1;
	Gun_0x[2].Peso_ok := 1;
	Gun_0x[3].Peso_ok := 1;
	Gun_0x[4].Peso_ok := 1;
	Gun_0x[5].Peso_ok := 1;
	Gun_0x[6].Peso_ok := 1;
	
END_PROGRAM

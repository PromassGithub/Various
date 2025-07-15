
PROGRAM _CYCLIC
	(*IF (SIMU.enable) THEN glb_err.pending_alarms := 0; END_IF*)
	
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
	IF (Piston_st_Up) THEN
		TON_04.IN := 1;
	ELSE 
		TON_04.IN := 0;
	END_IF;
	
	IF TON_04.Q THEN
		Piston_st_Up 	:= 0;
		Piston_st_Down 	:= 1;
		St_Gun := 50;
	END_IF;		
	
	//------------------------------------MAIN CYCLE----------------------------------------------------------------------------
	IF St_Gun = 0 THEN last_cycle := 0;	END_IF;
	
	IF ((Status <> AUTO) AND (NOT last_cycle)) THEN St_Gun := 0; END_IF;
	
	R_TRIG_09 (CLK := glb_io.Di.Si_01); 				//R_trig per sensor laser principale
	R_TRIG_10 (CLK := glb_data.WeightCmdCounter);		//R-trig per contatore pesi inviati da bilancia ad etichettatrice
	
	CASE St_Gun OF
			
		0:	// idle
			TON_01.IN 		:= 0;
			TON_02.IN 		:= 0;
			
			IF (R_TRIG_09.Q AND ((NOT Ricette.use_buffer) AND (NOT Ricette.use_weight))) THEN 
				St_Gun 			:= 10;
				Piston_st_Down 	:= 0;
			ELSIF (Ricette.use_weight) THEN
				St_Gun 			:= 0;
			ELSIF (Ricette.use_buffer) THEN
				St_Gun			:= 0;
			END_IF;
		
		10:	// start timer for main piston raise TIMER RITARDO SALITA PISTONE PESCE
			
			TON_01.IN := 1;	
			
			IF TON_01.Q THEN St_Gun := 20; END_IF;
			
			IF Pesi_0.Cmd_Shoot = 0 THEN St_Gun := 50; END_IF; 	//MOD 09/06/2025 Soluzione per evitare possibile problema di sovrapopolazione dell'array FIFO dei pesi
																//se peso non è nel range macchina a stati va subito allo stato di reset
			
		20: // Main piston up
			
			//MOD 09/06/2025 Modificato perchè controlo peso viene effettuato precedentemente-----------------------------------------
			//Sollevo pistone principale
//			IF (Pesi_0.Cmd_Shoot) THEN 
//				Piston_st_Up := 1;
//			END_IF;
			
			//Sollevo pistone principale
			Piston_st_Up := 1;
			
			//Delay ritardo per far si che il pistone principale salga prima dello sparo della pistola, ricette.pt_piston_up, Piston timer
			TON_08.IN := 1;
			
			//Quan
			IF (glb_io.Di.Finecorsa AND (Ricette.PT_piston_up = 0)) OR (TON_08.Q AND (Ricette.PT_piston_up > 0)) THEN
				TON_08.IN 		:= 0;
				St_Gun 			:= 30;
			END_IF;
			
		30: //control wich gun is active then shoot
			
			//MOD 09/06/2025 Modificato perchè controlo peso viene effettuato precedentemente--------------------------------------------
			//check if pistol is active and if wheight is within limits, then pistol shoots
//			IF (Pesi_0.Cmd_Shoot) THEN
//				IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active) AND Pesi_0.Cmd_Shoot) THEN
//					glb_io.Do.Piston_gun_1 := 1;
//				ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active) AND Pesi_0.Cmd_Shoot) THEN
//					glb_io.Do.Piston_gun_2 :=1;
//				END_IF;
//			END_IF;
			
			//Controllo quale gun è attiva e poi sparo
			IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active)) THEN
				glb_io.Do.Piston_gun_1 := 1;
			ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active)) THEN
				glb_io.Do.Piston_gun_2 :=1;
			END_IF;
			
			//command for magazine 1 stepforward when pistol shoots
			R_TRIG_01 (CLK := glb_io.Do.Piston_gun_1); 
			glb_cmd.sparo := R_TRIG_01.Q;
			
			//command for magazine 2 stepforward when pistol shoots
			R_TRIG_02 (CLK := glb_io.Do.Piston_gun_2);
			glb_cmd_2.sparo := R_TRIG_02.Q;
			
			//start delay timer for lowering main piston, ricette.pt_gun, t.pist.shoot
			TON_02.IN := 1;
			
			//change status to lower main piston
			IF TON_02.Q THEN 
				Piston_st_Up			:= 0;
				Piston_st_Down			:= 1;
				glb_io.Di.Finecorsa		:= 0;
				
				//MOD 04/06/2025 Reset macchina a stati bypassando stato 40 per velocizzare il ciclo
//				glb_st_gun_wait := 1;	//MOD 09/06/2025 Spostato sullo stato successivo(50)
				St_Gun			:= 50;		
			END_IF;
			
		40: //stato bypassato
			TON_03.IN := 1;
			TON_05.IN := 1;
			IF((NOT glb_io.Di.Si_01) AND TON_03.Q OR (TON_05.Q)) THEN 
				St_Gun := 50;
				glb_fish_shot_ons := 0;
				glb_st_gun_wait := 1;
			END_IF;
		
		50: // end & reset
			TON_01.IN 				:= 0;
			TON_02.IN 				:= 0;
			TON_03.IN 				:= 0;
			TON_04.IN				:= 0;
			TON_05.IN				:= 0;
			TON_07.IN				:= 0;
			glb_st_gun_wait 		:= 1;
			glb_io.Do.Piston_gun_1 	:= 0;
			glb_io.Do.Piston_gun_2 	:= 0;
			Piston_st				:= 0;
			Piston_st_Down			:= 1;
			St_Gun 					:= 0;
			R_TRIG_01.CLK 			:= 0;
			R_TRIG_02.CLK			:= 0;
		
	END_CASE;
	
	//Contatore pesci passati di fronte al sensore laser------------------
	IF R_TRIG_09.Q THEN
		glb_data.Fish_Counter := glb_data.Fish_Counter + 1;
	END_IF;
	
	IF glb_data.Fish_Counter = 1000000000 THEN glb_data.Fish_Counter := 0; END_IF;
	
	//Contatore pesi ricevuti da bilancia---------------------------------
	IF R_TRIG_10.Q THEN
		glb_data.WeightCmdCounter	:= 0;
		glb_data.Rcv_Weight_Counter := glb_data.Rcv_Weight_Counter +1;
	END_IF;
	
	IF glb_data.Rcv_Weight_Counter = 1000000000 THEN glb_data.Rcv_Weight_Counter := 0; END_IF;
	
	//Contatore pesci etichettati da nostro macchinario-------------------
	IF R_TRIG_01.Q THEN
		glb_data.Tagged_Fish_Counter := glb_data.Tagged_Fish_Counter + 1;
	END_IF;
	
	IF glb_data.Tagged_Fish_Counter = 1000000000 THEN glb_data.Tagged_Fish_Counter := 0; END_IF;
	
	
	//---------------BUFFER TEST--------11/10/24
	CASE Buffer_status OF
		0: 
			IF (Status = AUTO AND Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN
				buffer_index 	:= 0;
				Buffer_status 	:= 10; 
			END_IF

		10:
			R_TRIG_03 (CLK:= glb_io.Di.Si_01);
			glb_cmd.Main_Sensor := R_TRIG_03.Q;
			
			IF glb_cmd.Main_Sensor THEN
				
				IF buffer_index > 5 THEN
					buffer_index := 0;  
				END_IF;
            
				buffer_gun[buffer_index] := 1;
				buffer_index := buffer_index + 1;
				Buffer_status := 20;
				
			END_IF;
			
			IF (NOT Ricette.use_buffer) THEN
				Buffer_status := 20;
			ELSIF Status <> AUTO THEN
				Buffer_status := 20;
			END_IF;

		20:
			R_TRIG_03.CLK 	:= 0;
			Buffer_status 	:= 10;
		
			IF NOT Ricette.use_buffer THEN
				Buffer_status := 0;
			ELSIF Status <> AUTO THEN
				Buffer_status := 0;
			END_IF;
		
		
	END_CASE;

	// Trigger sensor assignments for each gun
	IF (Status = AUTO AND Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN
		IF glb_cmd.Main_Sensor THEN
			
			IF Gun_0x[0].Ready THEN Gun_0x[0].trigger_sensor := buffer_gun[0]; END_IF;
			IF Gun_0x[1].Ready THEN	Gun_0x[1].trigger_sensor := buffer_gun[1]; END_IF;
			IF Gun_0x[2].Ready THEN Gun_0x[2].trigger_sensor := buffer_gun[2]; END_IF;
			IF Gun_0x[3].Ready THEN Gun_0x[3].trigger_sensor := buffer_gun[3]; END_IF;
			IF Gun_0x[4].Ready THEN Gun_0x[4].trigger_sensor := buffer_gun[4]; END_IF;
			IF Gun_0x[5].Ready THEN Gun_0x[5].trigger_sensor := buffer_gun[5]; END_IF;
			IF Gun_0x[6].Ready THEN Gun_0x[6].trigger_sensor := buffer_gun[6]; END_IF;
			
		END_IF;
		
		IF (Gun_0x[0].end) THEN  buffer_gun[0] := 0; END_IF;
		IF (Gun_0x[1].end) THEN  buffer_gun[1] := 0; END_IF;
		IF (Gun_0x[2].end) THEN  buffer_gun[2] := 0; END_IF;
		IF (Gun_0x[3].end) THEN  buffer_gun[3] := 0; END_IF;
		IF (Gun_0x[4].end) THEN  buffer_gun[4] := 0; END_IF;
		IF (Gun_0x[5].end) THEN  buffer_gun[5] := 0; END_IF;
		IF (Gun_0x[6].end) THEN  buffer_gun[6] := 0; END_IF;
		

		// Piston and gun firing logic
		gun_0x_piston_up := (Gun_0x[0].Piston_up OR Gun_0x[1].Piston_up OR Gun_0x[2].Piston_up OR Gun_0x[3].Piston_up OR Gun_0x[4].Piston_up OR Gun_0x[5].Piston_up OR Gun_0x[6].Piston_up);
		gun_0x_piston_down := (Gun_0x[0].Piston_down OR Gun_0x[1].Piston_down OR Gun_0x[2].Piston_down OR Gun_0x[3].Piston_down OR Gun_0x[4].Piston_down OR Gun_0x[5].Piston_down OR Gun_0x[6].Piston_down);
		
		gun_0x_gun    := (Gun_0x[1].gun_out OR Gun_0x[2].gun_out OR Gun_0x[3].gun_out OR Gun_0x[4].gun_out OR Gun_0x[5].gun_out OR Gun_0x[6].gun_out);
		
		IF gun_0x_piston_up THEN DebugString1 := 'pistone su'; END_IF;
		
		IF gun_0x_piston_down THEN DebugString2 := 'pistone giu'; END_IF;
		
		IF gun_0x_gun THEN DebugString3 := 'sparo'; END_IF;

		// Gun firing logic
		IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active)) THEN
			glb_io.Do.Piston_gun_1 := gun_0x_gun;
		ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active)) THEN
			glb_io.Do.Piston_gun_2 := gun_0x_gun;
		END_IF;
		
		//command for magazine 1 stepforward when pistol shoots
		R_TRIG_04 (CLK := glb_io.Do.Piston_gun_1);
		glb_cmd.sparo := R_TRIG_04.Q;
			
		//command for magazine 2 stepforward when pistol shoots
		R_TRIG_05 (CLK := glb_io.Do.Piston_gun_2);
		glb_cmd_2.sparo := R_TRIG_05.Q;
		
		//pulizia valore peso array
		glb_cmd.Clear_weight := (Gun_0x[0].Clear_weight OR Gun_0x[1].Clear_weight OR Gun_0x[2].Clear_weight OR Gun_0x[3].Clear_weight OR Gun_0x[4].Clear_weight OR Gun_0x[5].Clear_weight OR Gun_0x[6].Clear_weight);

	ELSE
		// If buffer is not in use, reset the trigger sensor and buffer status
		FOR buffer_index := 0 TO 5 DO
			Gun_0x[buffer_index].trigger_sensor := 0;
			buffer_gun[buffer_index] := 0;
		END_FOR;
	END_IF;

	//---------------------END BUFFER TEST------11/10/24
	
//	//--------------------------------------Main cycle buffer----------------------------------------------
//	
////	buffer_gun[1] = Gun_01
////	buffer_gun[2] = Gun_02
////	buffer_gun[3] = Gun_03
////	buffer_gun[4] = Gun_04
////	buffer_gun[5] = Gun_05
//	
//	CASE Buffer_status OF
//		0: 
//			IF ((*glb_registered AND*) glb_io.Di.Si_01 AND Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN Buffer_status := 10; END_IF
//		10:
//			(*glb_registered := 0;*)
//			
//			FOR i:=1 TO 5 DO
//				IF (buffer_gun[i] = 0) THEN
//					buffer_gun[i] := 1;
//					Buffer_status := 20;
//					EXIT; // Stop checking once a gun is assigned
//					
//				END_IF
//			END_FOR;
//		20:
//			Debug := 6;
//			Buffer_status := 0;
//		
//	END_CASE
//	
//	FOR i := 1 TO 5 DO
//		IF (buffer_gun[i] = 0 AND Gun_0x[i].Ready AND Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN
//			buffer_gun[i] := 1;
//			EXIT;  // Stop checking once a gun is assigned
//		END_IF
//	END_FOR; 
//
//	
////	IF ((*glb_registered*) glb_io.Di.Si_01 AND Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN
////		//		calcolatore := calcolatore+1;
////		glb_registered := 0;
////		IF ((buffer_gun[1] = 0) AND Gun_0x[1].Ready) THEN
////			//			calcolatore1 := calcolatore1+1;
////			buffer_gun[1] := 1;
////		ELSIF ((buffer_gun[2] = 0 AND Gun_0x[2].Ready)) THEN
////			buffer_gun[2] := 1;   // ...........................................questo qui!...........................................
////			//			calcolatore1 := calcolatore1+1;
////		ELSIF ((buffer_gun[3] = 0 AND Gun_0x[3].Ready)) THEN
////			buffer_gun[3] := 1;
////			//			calcolatore1 := calcolatore1+1;
////		ELSIF ((buffer_gun[4] = 0 AND Gun_0x[4].Ready)) THENll
////			buffer_gun[4] := 1;
////			//			calcolatore1 := calcolatore1+1;
////		ELSIF ((buffer_gun[5] = 0 AND Gun_0x[5].Ready)) THEN
////			buffer_gun[5] := 1;
////			//			calcolatore1 := calcolatore1+1;
////		END_IF
////		
////	END_IFl
//	
//	IF (Ricette.use_buffer AND (NOT Ricette.use_weight)) THEN
//	
//		Gun_0x[1].trigger_sensor := buffer_gun[1];
//		Gun_0x[2].trigger_sensor := buffer_gun[2];
//		Gun_0x[3].trigger_sensor := buffer_gun[3];
//		Gun_0x[4].trigger_sensor := buffer_gun[4];
//		Gun_0x[5].trigger_sensor := buffer_gun[5];
//		Gun_0x[6].trigger_sensor := buffer_gun[6];
//	
//		IF (Gun_0x[1].end) THEN buffer_gun[1] := 0; END_IF;
//		IF (Gun_0x[2].end) THEN buffer_gun[2] := 0; END_IF;
//		IF (Gun_0x[3].end) THEN buffer_gun[3] := 0; END_IF;
//		IF (Gun_0x[4].end) THEN buffer_gun[4] := 0; END_IF;
//		IF (Gun_0x[5].end) THEN buffer_gun[5] := 0; END_IF;
//		IF (Gun_0x[6].end) THEN buffer_gun[6] := 0; END_IF;
//	
//		gun_0x_piston 	:= (Gun_0x[1].Piston_out OR Gun_0x[2].Piston_out OR Gun_0x[3].Piston_out OR Gun_0x[4].Piston_out OR Gun_0x[5].Piston_out);
//		gun_0x_gun 		:= (Gun_0x[1].gun_out OR Gun_0x[2].gun_out OR Gun_0x[3].gun_out OR Gun_0x[4].gun_out OR Gun_0x[5].gun_out);
//		
//		
//		IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active)) THEN
//			glb_io.Do.Piston_gun_1 := gun_0x_gun;
//			IF gun_0x_gun THEN	glb_cmd.sparo := 1; END_IF;
//		ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active)) THEN
//			glb_io.Do.Piston_gun_2 := gun_0x_gun;
//			IF gun_0x_gun THEN	glb_cmd_2.sparo := 1; END_IF;
//		END_IF;
//		
//	ELSE
//		
//		Gun_0x[1].trigger_sensor := buffer_gun[1] := 0;
//		Gun_0x[2].trigger_sensor := buffer_gun[2] := 0;
//		Gun_0x[3].trigger_sensor := buffer_gun[3] := 0;
//		Gun_0x[4].trigger_sensor := buffer_gun[4] := 0;
//		Gun_0x[5].trigger_sensor := buffer_gun[5] := 0;
//		Gun_0x[6].trigger_sensor := buffer_gun[6] := 0;
//		
//	
//	END_IF;
	
	//buffer_gun[1] = Gun_01
	//buffer_gun[2] = Gun_02
	//buffer_gun[3] = Gun_03
	//buffer_gun[4] = Gun_04
	//buffer_gun[5] = Gun_05
	
//	CASE xxx OF
//		0: 
////			IF (glb_registered AND Ricette.use_weight) THEN xxx := 10; END_IF
//		10:
//			glb_registered := 0;
//			FOR i:=1 TO 5 DO
//				IF (buffer_gun[i] = 0) THEN
//					buffer_gun[i] := 1; 
//					i := 10;
//					xxx := 20;
//				END_IF
//			END_FOR;
//		20:
//			xxx := 0;
//		
//	END_CASE
//	
//	IF (glb_registered AND Ricette.use_weight) THEN
////		calcolatore := calcolatore+1;
//		glb_registered := 0;
//		IF ((buffer_gun[1] = 0) AND Gun_0x[1].Ready) THEN
////			calcolatore1 := calcolatore1+1;
//			buffer_gun[1] := 1;
//		ELSIF ((buffer_gun[2] = 0 AND Gun_0x[2].Ready)) THEN
//			buffer_gun[2] := 1;   // ...........................................questo qui!...........................................
////			calcolatore1 := calcolatore1+1;
//		ELSIF ((buffer_gun[3] = 0 AND Gun_0x[3].Ready)) THEN
//			buffer_gun[3] := 1;
////			calcolatore1 := calcolatore1+1;
//		ELSIF ((buffer_gun[4] = 0 AND Gun_0x[4].Ready)) THEN
//			buffer_gun[4] := 1;
////			calcolatore1 := calcolatore1+1;
//		ELSIF ((buffer_gun[5] = 0 AND Gun_0x[5].Ready)) THEN
//			buffer_gun[5] := 1;
////			calcolatore1 := calcolatore1+1;
//		END_IF
//		
//	END_IF
//	
//	IF ( Status = AUTO AND Ricette.use_weight) THEN
//	
//		Gun_0x[1].trigger_sensor := buffer_gun[1];
//		Gun_0x[2].trigger_sensor := buffer_gun[2];
//		Gun_0x[3].trigger_sensor := buffer_gun[3];
//		Gun_0x[4].trigger_sensor := buffer_gun[4];
//		Gun_0x[5].trigger_sensor := buffer_gun[5];
//		Gun_0x[6].trigger_sensor := buffer_gun[6];
//	
//		IF (Gun_0x[1].end) THEN buffer_gun[1] := 0; END_IF;
//		IF (Gun_0x[2].end) THEN buffer_gun[2] := 0; END_IF;
//		IF (Gun_0x[3].end) THEN buffer_gun[3] := 0; END_IF;
//		IF (Gun_0x[4].end) THEN buffer_gun[4] := 0; END_IF;
//		IF (Gun_0x[5].end) THEN buffer_gun[5] := 0; END_IF;
//		IF (Gun_0x[6].end) THEN buffer_gun[6] := 0; END_IF;
//	
//		gun_0x_piston 	:= (Gun_0x[1].Piston_out OR Gun_0x[2].Piston_out OR Gun_0x[3].Piston_out OR Gun_0x[4].Piston_out OR Gun_0x[5].Piston_out);
//		gun_0x_gun 		:= (Gun_0x[1].gun_out OR Gun_0x[2].gun_out OR Gun_0x[3].gun_out OR Gun_0x[4].gun_out OR Gun_0x[5].gun_out);
////		Lamp_02.Lamp2Bianco := gun_0x_gun;
//		
//		IF (Gun_Switch_0.Gun_1_Active AND (NOT Gun_Switch_0.Gun_2_Active)) THEN
//			glb_io.Do.Piston_gun_1 := gun_0x_gun;
//			IF gun_0x_gun THEN	glb_cmd.sparo := 1; END_IF
//		ELSIF (Gun_Switch_0.Gun_2_Active AND (NOT Gun_Switch_0.Gun_1_Active)) THEN
//			glb_io.Do.Piston_gun_2 := gun_0x_gun;
//			IF gun_0x_gun THEN	glb_cmd_2.sparo := 1; END_IF
//		END_IF;
//		
//	ELSE
//		
//		Gun_0x[1].trigger_sensor := buffer_gun[1] := 0;
//		Gun_0x[2].trigger_sensor := buffer_gun[2] := 0;
//		Gun_0x[3].trigger_sensor := buffer_gun[3] := 0;
//		Gun_0x[4].trigger_sensor := buffer_gun[4] := 0;
//		Gun_0x[5].trigger_sensor := buffer_gun[5] := 0;
//		Gun_0x[6].trigger_sensor := buffer_gun[6] := 0;
//		
//	
//	END_IF
	
	
	
	//--------------------GUN SWITCH-------------------------
	
	CASE Gun_Switch_0.Gun_Switch_Status OF
		
		0:	//Start
			IF (Status = AUTO AND glb_err.pending_alarms = 0) THEN
				Gun_Switch_0.Gun_Switch_Status := 1;
			END_IF;
			
		1:	//Controllo sensori caricatori
			
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
	
	//--------------------PESI---------------------------------
	
	//Controllo che il peso del pesce sia nel range
	
	IF (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_A AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_A) OR (Pesi_0.Controlled_Weight <= Pesi_0.Max_Weight_B AND Pesi_0.Controlled_Weight >= Pesi_0.Min_Weight_B) THEN
		Gun_0x[buffer_index].Peso_ok := 1;
		Pesi_0.Cmd_Shoot := 1;
		glb_registered := 1;
	ELSE
		Gun_0x[buffer_index].Peso_ok := 0;
		Pesi_0.Cmd_Shoot := 0;
	END_IF;
	
	//---------------VACUUM-CONTROL----------------------------
	
	CASE Vac_Status OF
		
		0:	//Start 
			glb_io.Do.Vacuum_On_Off := 0;
			IF ((Status = AUTO (*OR Status = MANUAL //MOD FOR TESTING PURPOSES*)) AND glb_err.pending_alarms = 0) THEN
				//Vac_Status := 1; //MOD 09/06/2025 Disattivato per motivi di collaudo
			END_IF;
			
		1:	//Vacuum ON
			glb_io.Do.Vacuum_On_Off := 1;
			
			IF ((Status <> AUTO) OR (Status <> MANUAL)) THEN Vac_Status := 0; END_IF;
		
	END_CASE;
				
	
	//--------------------DELAY CALCULATION----------------------------------
	
	STP_01_Vel := 7000;
	
	//Calcolo tempo delay sollevamento pesce
	(*IF (STP_01_Vel = 0) THEN STP_01_Vel:= 0.5; END_IF;*)
	
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
	
	//-------------------------------MOD 14/04/2025---------------------------
	
	//ATTIVAZIONE/SPEGNIMENTO BOBINE PNEUMATICA
	IF (Status = AUTO AND glb_err.pending_alarms = 0 AND NOT(Status = MANUAL)) THEN
		IF Piston_st_Up OR gun_0x_piston_up THEN
			Piston_st_Down				:= 0;
			glb_io.Do.Main_Piston_Up 	:= 1;
			glb_io.Do.Main_Piston_Down 	:= 0;
		ELSIF Piston_st_Down OR gun_0x_piston_down THEN
			Piston_st_Up				:= 0;
			glb_io.Do.Main_Piston_Up 	:= 0;
			glb_io.Do.Main_Piston_Down 	:= 1;
		END_IF;
	
	//Bobine stato STOP	
	ELSIF ((Status <> AUTO) OR (Status <> MANUAL) OR (glb_err.pending_alarms <> 0)) THEN
		glb_io.Do.Main_Piston_Up 	:= 0;
		glb_io.Do.Main_Piston_Down 	:= 1;
		
		//Spegnimento bobina pistone principale giù quando macchina in STOP
		IF last_cycle = 0 THEN
			glb_io.Do.Main_Piston_Down := 0;
		END_IF;
		
	END_IF;
	
	//Controllo manuale valvola pistone soll
	IF (Status = MANUAL AND glb_err.pending_alarms = 0) THEN
		IF ( glb_hmi.Inp.Soll_Valve_HMI ) THEN
			glb_io.Do.Main_Piston_Up 	:= 1;
			glb_io.Do.Main_Piston_Down 	:= 0;
		ELSE
			glb_io.Do.Main_Piston_Up 	:= 0;
			glb_io.Do.Main_Piston_Down 	:= 1;
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
	TON_01;		// timer delay pistone sollevamento pesce
	TON_02;		// Timer che ritarda abbassamento del pistone principale dopo lo sparo, oppure anche senza sparo se peso non è ok
	TON_03;		// tempo di attesa alla fine del ciclo
	TON_04;		// Sicurezza pistone soll
	TON_05;
	TON_06;		
	TON_07;		
	TON_08;		// Se imposto questo tempo il ritorno del pistone è comandato da questo timer + il tempo della pistola (ton_2), timer che ritarda sparo dopo che pistone principale è stato sollevato
			
	// Timer per delay principale sollevamento pistone principale
	Gun_0x[0].PT_pist_Delay := Gun_0x[1].PT_pist_Delay := Gun_0x[2].PT_pist_Delay := Gun_0x[3].PT_pist_Delay := Gun_0x[4].PT_pist_Delay := Gun_0x[5].PT_pist_Delay := Gun_0x[6].PT_pist_Delay := Ricette.PT_ritardo := TON_01.PT := Tempo_Delay;
	// Timer che ritarda abbassamento del pistone principale dopo lo sparo
	Gun_0x[0].PT_trigger_gun := Gun_0x[1].PT_trigger_gun := Gun_0x[2].PT_trigger_gun := Gun_0x[3].PT_trigger_gun := Gun_0x[4].PT_trigger_gun := Gun_0x[5].PT_trigger_gun := Gun_0x[6].PT_trigger_gun := TON_02.PT := Ricette.PT_gun;
	// tempo di attesa alla fine del ciclo, BYPASSATO
	Gun_0x[0].PT_end_stop := Gun_0x[1].PT_end_stop := Gun_0x[2].PT_end_stop := Gun_0x[3].PT_end_stop := Gun_0x[4].PT_end_stop := Gun_0x[5].PT_end_stop := Gun_0x[6].PT_end_stop := TON_03.PT := Ricette.PT_end_stop;		
	// Se imposto questo tempo il ritorno del pistone è comandato da questo timer + il tempo della pistola (ton_2), timer che ritarda discesa pistone principale dopo lo sparo, necessario per dar tempo alla pneumatica di funzionare
	Gun_0x[0].PT_piston_up := Gun_0x[1].PT_piston_up := Gun_0x[2].PT_piston_up := Gun_0x[3].PT_piston_up := Gun_0x[4].PT_piston_up := Gun_0x[5].PT_piston_up := Gun_0x[6].PT_piston_up := TON_08.PT := Ricette.PT_piston_up;
	
	TON_04.PT := T#1000ms;					// Sicurezza pistone soll
	
	TON_05.PT := T#1s;
	
	TON_06.PT := T#50ms;
	
			
	
	
	R_TRIG_01;
	R_TRIG_02;
	R_TRIG_03;
	R_TRIG_04;
	R_TRIG_05;
	
	Gun_0x[0];
	Gun_0x[1];
	Gun_0x[2];
	Gun_0x[3];
	Gun_0x[4];
	Gun_0x[5];
	Gun_0x[6];
	Gun_0x[7];
	
END_PROGRAM


PROGRAM _CYCLIC
	
	//------------------------------KEYS PAIRING-------------------------------
	
	MM_0.MM_Avanti 		:= glb_io.Di.Forward_Mag_1;
	MM_0.MM_Indietro 	:= glb_io.Di.Backward_Mag_1;
	
	MM_2.MM_Avanti 		:= glb_io.Di.Forward_Mag_2;
	MM_2.MM_Indietro 	:= glb_io.Di.Backward_Mag_2;
	
	//---------------------------------TIMERS----------------------------------
	
	TON_01;
	TON_02;
	TON_03;
	TON_04;
	TON_05;
	TON_06;
	
	TON_01.PT := T#2s;
	TON_02.PT := T#2s;
	TON_05.PT := T#2s;
	TON_06.PT := T#2s;
	
	
	//------------------------------KEY COMBINATIONS----------------------------
	
	
	CASE Key_Status OF
		
		0://START
			IF (Status  = AUTO) THEN
				Key_Status := 10;
			END_IF;
			
			IF (Status = MANUAL) THEN
				Key_Status := 11;
			END_IF;
			
			
		10:	//IDLE IF STATUS AUTO
			
			//Magazine 1 command loaded
			IF (glb_io.Di.Forward_Mag_1 AND glb_io.Di.Backward_Mag_1) THEN
				TON_01.IN := 1;
				IF TON_01.Q THEN
					Key_Status := 20;
				END_IF;
			END_IF;
			
			//Magazine 2 command loaded
			IF (glb_io.Di.Forward_Mag_2 AND glb_io.Di.Backward_Mag_2) THEN
				TON_02.IN := 1;
				IF TON_02.Q THEN
					Key_Status := 30;
				END_IF;
			END_IF;
			
			//Auto homing mag_1 command start
			IF (glb_io.Di.Start AND glb_io.Di.Backward_Mag_1) THEN
				glb_cmd.Auto_Homing_Ack 	:= 0;
				TON_05.IN 					:= 1;
				IF TON_05.Q THEN
					Key_Status := 60;
				END_IF;
			END_IF;
			
			//Auto homing mag_2 command start
			IF (glb_io.Di.Start AND glb_io.Di.Backward_Mag_1) THEN
				glb_cmd_2.Auto_Homing_Ack 	:= 0;
				TON_06.IN 					:= 1;
				IF TON_06.Q THEN
					Key_Status := 61;
				END_IF;
			END_IF;
			
			
			IF (Status <> AUTO) THEN Key_Status := 100; END_IF;
			
		11://IDLE IF STATUS MANUAL
			
			//Manual homing Mag_1 start
			IF (glb_io.Di.Start AND glb_io.Di.Backward_Mag_1) THEN
				TON_01.IN := 1;
				IF TON_01.Q THEN
					Key_Status := 40;
				END_IF;
			END_IF;
			
			//Manua homing Mag_2 start
			IF (glb_io.Di.Start AND glb_io.Di.Backward_Mag_2) THEN
				TON_02.IN := 1;
				IF TON_02.Q THEN
					Key_Status := 50;
				END_IF;
			END_IF;
			
			IF (Status <> MANUAL) THEN Key_Status := 100; END_IF;
	
		20:// MAG_1 LOADED
			
			glb_cmd.Cartridge_loaded 	:= 1;
			Cartridge_loaded_control 	:= 1;
			TON_01.IN 					:= 0;
			Key_Status 					:= 0;
		
		30:// MAG_2 LOADED
			
			glb_cmd_2.Cartridge_loaded 	:= 1;
			Cartridge_loaded_control_2 	:= 1;
			TON_02.IN 					:= 0;
			Key_Status 					:= 0;
		
		40:// MANUAL HOMING MAG_1
			
			glb_cmd.btn_homing 			:= 1;
			Manual_Homing_Control 		:= 1;
			TON_01.IN 					:= 0;
			Key_Status 					:= 0;
		
		50:// MANUAL HOMING MAG_2
			
			glb_cmd_2.btn_homing 		:= 1;
			Manual_Homing_Control_2		:= 1;
			TON_02.IN 					:= 0;
			Key_Status 					:= 0;
		
		60:// AUTO HOMING MAG_1
			
			glb_cmd.Auto_Homing_Ack 	:= 1;
			Auto_Homing_Control			:= 1;
			TON_05.IN 					:= 0;
			Key_Status 					:= 0;
		
		61://AUTO HOMING MAG_2
			glb_cmd_2.Auto_Homing_Ack	:= 1;
			Auto_Homing_Control_2		:= 1;
			TON_06.IN					:= 0;
			Key_Status					:= 0;
		
	END_CASE;
	
	
//----------------------------LIGHT COMBINATIONS----------------------------------
	CASE Lights_Status OF
		
		0://START
			
			IF ( Status = AUTO AND Status = MANUAL) THEN
				glb_io.Do.Green_Light := 1;
				glb_io.Do.Red_Light := 0;
				Lights_Status := 10;
			ELSIF Status = STOP THEN
				glb_io.Do.Green_Light := 0;
				glb_io.Do.Red_Light := 1;
			
			END_IF;
				
			(*Lights_Status := 10;*)
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
		10://IDLE
			
			//MAG_1 LOADED ACK
			IF Cartridge_loaded_control THEN
				Lights_Status := 20;
			END_IF;
			
			//MAG_2 LOADED ACK
			IF Cartridge_loaded_control_2 THEN
				Lights_Status := 30;
			END_IF;
			
			//MAG_1 RELOAD NEEDED
			IF Empty_Mag_1_0.Empty_Mag_Sensor THEN
				Lights_Status := 40;
			END_IF;
			
			//MAG_2 RELOAD NEEDED
			IF Empty_Mag_22.Empty_Mag_Sensor THEN
				Lights_Status := 50;
			END_IF;
			
			//MAG_1 AUTO HOMING ACK
			IF Auto_Homing_Control THEN
				Lights_Status := 60;
			END_IF;
			
			//MAG_2 AUTO HOMING ACK
			IF Auto_Homing_Control_2 THEN
				Lights_Status := 70;
			END_IF;
			
			//MAG_1 MANUAL HOMING ACK
			IF Manual_Homing_Control THEN
				Lights_Status := 80;
			END_IF;
			
			//MAG_2 MANUAL HOMING ACK
			IF Manual_Homing_Control_2 THEN
				Lights_Status := 90;
			END_IF;
	
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
		
		20://MAG_1 LED BLINKING IN ACKNOWLEDGMENT TO COMPLETED RELOAD, BLINK 3 TIMES
			
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				glb_io.Do.Green_Light 	:= 1;
				glb_io.Do.Red_Light 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				glb_io.Do.Green_Light 	:= 0;
				glb_io.Do.Red_Light 	:= 0;
			END_IF;
			
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
					
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				Lights_Status := 21;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		21://GENERAL RESET MAG_1 & BACK TO START
			
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Cartridge_loaded_control 	:= 0;
			Lights_Status 				:= 0;
		
		30://MAG_2 LED BLINKING IN ACKNOWLEDGMENT TO COMPLETED RELOAD, BLINK 3 TIMES
			
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light := 1;
				glb_io.Do.Green_Light := 1;
				glb_io.Do.Red_Light := 1;
			ELSE
				glb_io.Do.Blue_Light := 0;
				glb_io.Do.Green_Light := 0;
				glb_io.Do.Red_Light := 0;
			END_IF;
					
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
			
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
				R_TRIG_08.CLK := 0;
			END_IF;
			
			IF Blink_Counter >= 3 THEN
				Lights_Status := 31;
			END_IF;
			
				
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		31://GENERAL RESET MAG_2 & BACK TO START
			
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Cartridge_loaded_control_2 	:= 0;
			Lights_Status 				:= 0;
			
		
		40://MAG_1 WHITE LED, BLUE LIGHT BLINKING & RELOAD BEEPER ON
			
			Lamp_02.Lamp2Verde := 0;
			TON_03(IN:=NOT TON_04.Q, PT:=T#1s);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#1s);
			
			IF TON_03_Pulse THEN
				Lamp_02.Lamp2Bianco 	:= 1;
				glb_io.Do.Blue_Light 	:= 1;
				Lamp_02.Lamp2Allarme 	:= 1;
			ELSE
				Lamp_02.Lamp2Bianco 	:= 0;
				glb_io.Do.Blue_Light 	:= 0;
				Lamp_02.Lamp2Allarme 	:= 0;
			END_IF;
			
			IF glb_io.Di.Reset THEN
				Lights_Status := 41;
			END_IF;
		
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		41:////RESET OF BLUE LED & RELOAD BEEPER, WHITE LED STILL BLINKING
			
			glb_io.Do.Blue_Light := 0;
			Lamp_02.Lamp2Allarme := 0;
			
			TON_03(IN:=NOT TON_04.Q, PT:=T#1s);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#1s);
			
			IF TON_03_Pulse THEN
				Lamp_02.Lamp2Bianco :=1;
			ELSE
				Lamp_02.Lamp2Bianco :=0;
			END_IF;
			
			IF glb_cmd.Cartridge_loaded THEN
				Lights_Status := 42;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		42://RESET OF WHITE LED, GREEN "LOADED" LED ON & BACK TO START
			
			Lamp_02.Lamp2Bianco 	:= 0;
			Lamp_02.Lamp2Verde 		:= 1;
			Lights_Status 			:= 0;
			
			
		50:////MAG_2 WHITE LED, BLUE LED BLINKING & RELOAD BEEPER ON
			
			TON_03(IN:=NOT TON_04.Q, PT:=T#1s);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#1s);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				Lamp_01.Lamp1Bianco 	:=1;
				Lamp_01.Lamp1Allarme 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				Lamp_01.Lamp1Bianco 	:=0;
				Lamp_01.Lamp1Allarme 	:= 0;
			END_IF;
			
			IF glb_io.Di.Reset THEN
				Lights_Status := 51;
			END_IF;
		
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		51://RESET OF BLUE LED & RELOAD BEEPER, WHITE LED STILL BLINKING
			
			glb_io.Do.Blue_Light := 0;
			Lamp_01.Lamp1Allarme := 0;
			
			TON_03(IN:=NOT TON_04.Q, PT:=T#1s);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#1s);
			
			IF TON_03_Pulse THEN
				Lamp_01.Lamp1Bianco :=1;
			ELSE
				Lamp_01.Lamp1Bianco :=0;
			END_IF;
			
			IF glb_cmd_2.Cartridge_loaded THEN
				Lights_Status := 52;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		52://RESET OF WHITE LED, GREEN "LOADED" LED ON & BACK TO START
			
			Lamp_01.Lamp1Bianco 	:= 0;
			Lamp_01.Lamp1Verde 		:= 1;
			Lights_Status 			:= 0;
			
		60://MAG_1 LED BLINKING IN ACKNOWLEDGMENT TO AUTO HOMING, BLINK 3 TIMES
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				glb_io.Do.Green_Light 	:= 1;
				glb_io.Do.Red_Light 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				glb_io.Do.Green_Light 	:= 0;
				glb_io.Do.Red_Light 	:= 0;
			END_IF;
			
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
					
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				Lights_Status := 61;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		61://GENERAL RESET MAG_1 & BACK TO START
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Auto_Homing_Control		 	:= 0;
			Lights_Status 				:= 0;
			
		70://MAG_2 LED BLINKING IN ACKNOWLEDGMENT TO AUTO HOMING, BLINK 3 TIMES
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				glb_io.Do.Green_Light 	:= 1;
				glb_io.Do.Red_Light 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				glb_io.Do.Green_Light 	:= 0;
				glb_io.Do.Red_Light 	:= 0;
			END_IF;
			
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
					
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				Lights_Status := 71;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		71://GENERAL RESET MAG_2 & BACK TO START
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Auto_Homing_Control_2	 	:= 0;
			Lights_Status 				:= 0;
			
		80://MAG_1 LED BLINKING IN ACKNOWLEDGMENT TO MANUAL HOMING, BLINK 3 TIMES
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				glb_io.Do.Green_Light 	:= 1;
				glb_io.Do.Red_Light 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				glb_io.Do.Green_Light 	:= 0;
				glb_io.Do.Red_Light 	:= 0;
			END_IF;
			
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
					
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				Lights_Status := 81;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		81://GENERAL RESET MAG_1 & BACK TO START
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Manual_Homing_Control	 	:= 0;
			Lights_Status 				:= 0;
			
		90://MAG_2 LED BLINKING IN ACKNOWLEDGMENT TO MANUAL HOMING, BLINK 3 TIMES
			TON_03(IN:=NOT TON_04.Q, PT:=T#500ms);
			TON_03_Pulse := TON_03.Q;
			
			TON_04 (IN:=TON_03.Q, PT:=T#500ms);
			
			IF TON_03_Pulse THEN
				glb_io.Do.Blue_Light 	:= 1;
				glb_io.Do.Green_Light 	:= 1;
				glb_io.Do.Red_Light 	:= 1;
			ELSE
				glb_io.Do.Blue_Light 	:= 0;
				glb_io.Do.Green_Light 	:= 0;
				glb_io.Do.Red_Light 	:= 0;
			END_IF;
			
			IF TON_04.Q THEN
				TON_03_Ctrl := 1;
			END_IF;
			
			IF TON_03.Q AND TON_03_Ctrl THEN
				Blink_Cmd := 1;
				TON_03_Ctrl := 0;
			END_IF;
					
			IF Blink_Cmd THEN
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				Lights_Status := 91;
			END_IF;
			
			IF Status = ERR THEN Lights_Status := 100; END_IF;
			
			
		91://GENERAL RESET MAG_2 & BACK TO START
			Blink_Counter 				:= 0;
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light 		:= 0;
			Manual_Homing_Control_2	 	:= 0;
			Lights_Status 				:= 0;
		
		100://BLUE LED BLINKING
			
			TON_03( IN:=NOT TON_04.Q, PT:=T#1s);
			TON_03_Pulse := TON_03.Q;

			TON_04( IN:=TON_03.Q, PT:= T#1s);

			IF (TON_03_Pulse) THEN
				glb_io.Do.Blue_Light := 1;
			ELSE
				glb_io.Do.Blue_Light := 0;
			END_IF;
		
			IF glb_io.Di.Reset THEN
				Lights_Status := 110;
			END_IF;
		
		110://RESET OF BLUE LED & BACK TO START
			
			glb_io.Do.Blue_Light 	:= 0;
			ERROr 					:= 0;
			glb_err.pending_alarms 	:= 0;
			Lights_Status 			:= 0;
		
		
		
			
	END_CASE;
	
END_PROGRAM


PROGRAM _CYCLIC
	
	//------------------------------MOVEMENT KEYs PAIRING-------------------------------
	
	//PAIRING OF HMI MOVEMENT VARIABLE WITH BUTTON MOVEMENT VARIABLE
	IF (NOT glb_io.Di.Start) AND (NOT glb_io.Di.Reset) AND (NOT glb_io.Di.Backward_Mag_1) AND (NOT glb_cmd.Movement_Lock) AND (NOT glb_cmd.Movement_Lock_Homing) THEN
		MM_0.MM_Avanti := glb_io.Di.Forward_Mag_1;
	END_IF;
	
	//PAIRING OF HMI MOVEMENT VARIABLE WITH BUTTON MOVEMENT VARIABLE
	IF (NOT glb_io.Di.Start) AND (NOT glb_io.Di.Reset) AND (NOT glb_io.Di.Forward_Mag_1) AND (NOT glb_cmd.Movement_Lock) AND (NOT glb_cmd.Movement_Lock_Homing) THEN
		MM_0.MM_Indietro := glb_io.Di.Backward_Mag_1;
	END_IF;
	
	//PAIRING OF HMI MOVEMENT VARIABLE WITH BUTTON MOVEMENT VARIABLE
	IF (NOT glb_io.Di.Start) AND (NOT glb_io.Di.Reset) AND (NOT glb_io.Di.Backward_Mag_2) AND (NOT glb_cmd_2.Movement_Lock) AND (NOT glb_cmd_2.Movement_Lock_Homing) THEN
		MM_2.MM_Avanti := glb_io.Di.Forward_Mag_2;
	END_IF;
	
	//PAIRING OF HMI MOVEMENT VARIABLE WITH BUTTON MOVEMENT VARIABLE
	IF (NOT glb_io.Di.Start) AND (NOT glb_io.Di.Reset) AND (NOT glb_io.Di.Forward_Mag_2) AND (NOT glb_cmd_2.Movement_Lock) AND (NOT glb_cmd_2.Movement_Lock_Homing) THEN
		MM_2.MM_Indietro := glb_io.Di.Backward_Mag_2;
	END_IF;
	
	//PAIRING OF HMI VARIABLE WITH BEACON ALARM VARIABLE
	glb_hmi.Inp.Beacon_Alarm_Lock_1 := glb_cmd.Beeper_Lock;
	
	glb_hmi.Inp.Beacon_Alarm_Lock_2 := glb_cmd_2.Beeper_Lock;
	
	//------------------------------KEY COMBINATIONS----------------------------
	
	//SEQUENCE TO CONFIRM BEGINNING OF RELOADING PROCEDURE, AFTER THIS THE AXIS WILL GO BACK TO HOME POSITION FOR RELOADING, AXIS 1
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Reset AND lights_status.Magazine_1 = 21 THEN
		glb_cmd.Start_Reload := 1;
	END_IF;
	
	//SEQUENCE TO CONFIRM BEGINNING OF RELOADING PROCEDURE, AFTER THIS THE AXIS WILL GO BACK TO HOME POSITION FOR RELOADING, AXIS 2
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Reset AND lights_status.Magazine_2 = 21  THEN
		glb_cmd_2.Start_Reload := 1;
	END_IF;
	
	//SEQUENCE TO CONFIRM THAT THE MAGAZINE IS LOADED AND THE RELOADING PROCEDURE IS COMPLETE, THE PISTOL IS READY TO SHOOT.
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Forward_Mag_1 AND glb_io.Di.Backward_Mag_1 THEN
		glb_cmd.Cartridge_loaded := 1;
	END_IF;
	
	//SEQUENCE TO CONFIRM THAT THE MAGAZINE IS LOADED AND THE RELOADING PROCEDURE IS COMPLETE, THE PISTOL IS READY TO SHOOT.
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Forward_Mag_2 AND glb_io.Di.Backward_Mag_2 THEN
		glb_cmd_2.Cartridge_loaded := 1;
	END_IF;
	
	//SEQUENCE TO SET THE MAGAZINE BACK TO UNLOADED, AXIS 1
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Reset AND glb_io.Di.Backward_Mag_1 AND glb_cmd.Cartridge_loaded_Gun THEN
		glb_cmd.Cartridge_loaded_Gun 	:= 0;
		Cartridge_Unloaded_control		:= 1;
	END_IF;
	
	//SEQUENCE TO SET THE MAGAZINE BACK TO UNLOADED, AXIS 2
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Reset AND glb_io.Di.Backward_Mag_2 AND glb_cmd_2.Cartridge_loaded_Gun THEN
		glb_cmd_2.Cartridge_loaded_Gun 	:= 0;
		Cartridge_Unloaded_control_2	:= 1;
	END_IF;
	
	//SEQUENCE TO BEGIN THE HOMING PROCEDURE, AXIS 1
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Start AND glb_io.Di.Backward_Mag_1 THEN
		glb_cmd.btn_homing := 1;
	END_IF;
	
	//SEQUENCE TO BEGIN THE HOMING PROCEDURE, AXIS 2
	IF (Status = AUTO OR Status = MANUAL) AND glb_io.Di.Start AND glb_io.Di.Backward_Mag_2 THEN
		glb_cmd_2.btn_homing := 1;
	END_IF;
	
	//
	IF glb_cmd.Cartridge_loaded THEN
		glb_cmd.Cartridge_loaded_Gun 	:= 1;
		Cartridge_loaded_control 		:= 1;
	END_IF;
	
	//
	IF glb_cmd_2.Cartridge_loaded THEN
		glb_cmd_2.Cartridge_loaded_Gun 	:= 1;
		Cartridge_loaded_control_2		:= 1;
	END_IF;
	
	//--------------------------------MOVEMENT LOCKING-------------------------------
	
	//LOCKING MANUAL MOVEMENT WHEN AXIS ARE HOMED, UNLOCKING WHEN THE AXIS MOVEMENT WHEN THEY ARE RELOADING
	
		//FIRST AXIS
		IF glb_cmd.Cartridge_loaded_Gun  THEN
			glb_cmd.Movement_Lock := 1;
		ELSE
			glb_cmd.Movement_Lock := 0;
		END_IF;
	
		//SECOND AXIS
		IF glb_cmd_2.Cartridge_loaded_Gun THEN
			glb_cmd_2.Movement_Lock := 1;
		ELSE
			glb_cmd_2.Movement_Lock := 0;
		END_IF;
	
	//LOCKING AXIS MANUAL MOVEMENTS WHILE AXIS ARE HOMING
	
		//FIRST AXIS
		IF glb_cmd.Homing_Lock THEN
			glb_cmd.Movement_Lock_Homing := 1;
		ELSE
			glb_cmd.Movement_Lock_Homing := 0;
		END_IF;
	
		//SECOND AXIS
		IF glb_cmd_2.Homing_Lock THEN
			glb_cmd_2.Movement_Lock_Homing := 1;
		ELSE
			glb_cmd_2.Movement_Lock_Homing := 0;
		END_IF;

	
	
	
	
	//----------------------------------------------------------------LIGHT COMBINATIONS----------------------------------------------------------
	
	
	//----------------------------------------------------MANAGMENT OF THE START, STOP AND RESET LEDS---------------------------------------------
	CASE lights_status.Bottom OF
		
		0: //START
			IF (Status = AUTO OR Status = MANUAL) THEN
				glb_io.Do.Green_Light	:= 1;
				glb_io.Do.Red_Light		:= 0;
				lights_status.Bottom 	:= 10;
			ELSIF Status = STOP THEN
				glb_io.Do.Green_Light	:= 0;
				glb_io.Do.Red_Light		:= 1;
			END_IF;
			
			IF Status = ERR THEN lights_status.Bottom := 100; END_IF;
		
		10://IDLE
			Blink_Cmd := 0;
		
			//MAG_1 LOADED ACKNOWLEDGE
			IF Cartridge_loaded_control THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_2 LOADED ACKNOWLEDGE
			IF Cartridge_loaded_control_2 THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_1 UNLOADED ACKNOWLEDGE
			IF Cartridge_Unloaded_control THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_2 UNLOADED ACKNOWLEDGE
			IF Cartridge_Unloaded_control_2 THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_1 HOMING ACKNOWLEDGE
			IF Homing_Control THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_2 HOMING ACKNOWLEDGE
			IF Homing_Control_2 THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_1 BEGIN RELOADING ACKNOWLEDGE
			IF glb_cmd.Start_Reload THEN
				lights_status.Bottom := 20;
			END_IF;
			
			//MAG_2 BEGIN RELOADING ACKNOWLEDGE
			IF glb_cmd_2.Start_Reload THEN
				lights_status.Bottom := 20;
			END_IF;
		
			IF Status = STOP THEN lights_status.Bottom := 0; END_IF;
			
			IF Status = ERR THEN lights_status.Bottom := 100; END_IF;
			
		20://BOTTOM LEDs BLINKING IN ACKNOWLEDGMENT OF SUCCESFULL INPUT
			glb_io.Do.Blue_Light 	:= TON_03_Pulse;
			glb_io.Do.Green_Light 	:= TON_03_Pulse;
			glb_io.Do.Red_Light 	:= TON_03_Pulse;
			
			IF (TON_03_Pulse AND (NOT Blink_Cmd)) THEN 
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 1;
			ELSIF ((NOT TON_03_Pulse) AND Blink_Cmd) THEN
				Blink_Cmd := 0;
			END_IF
				
			IF Blink_Counter >= 3 THEN
				lights_status.Bottom := 21;
			END_IF;
			
			IF Status = ERR THEN lights_status.Bottom := 100; END_IF;
		
		21://RESET OF BLINKING VARIABLES AND BACK TO START
			Blink_Counter 					:= 0;
			glb_io.Do.Blue_Light 			:= 0;
			glb_io.Do.Green_Light 			:= 0;
			glb_io.Do.Red_Light 			:= 0;
			Cartridge_loaded_control 		:= 0;
			Cartridge_loaded_control_2		:= 0;
			Cartridge_Unloaded_control		:= 0;
			Cartridge_Unloaded_control_2	:= 0;
			Homing_Control					:= 0;
			Homing_Control_2				:= 0;
			glb_cmd.Cartridge_loaded		:= 0;
			glb_cmd_2.Cartridge_loaded		:= 0;
			lights_status.Bottom 			:= 0;
		
		100://BLUE LED BLINKING WHEN THE MACHINE IS IN EMERGENCY
			glb_io.Do.Green_Light 		:= 0;
			glb_io.Do.Red_Light  		:= 1;
			
			Beacon_1.White				:= 0;
			Beacon_1.Green 				:= 0;
			Beacon_1.Beeper_Alarm		:= 0;
			Beacon_2.White				:= 0;
			Beacon_2.Green 				:= 0;
			Beacon_2.Beeper_Alarm		:= 0;

			glb_io.Do.Blue_Light 		:= TON_03_Pulse;
			
			//WHEN YOU PRESS RESET BUTTON IT RESETS ALL ACTIVE ALARMS
			IF glb_io.Di.Reset THEN
				lights_status.Bottom 	:= 110;
			END_IF;
		
		110://RESET OF BLUE LED & BACK TO START
			
			glb_io.Do.Blue_Light 		:= 0;
			glb_io.Do.Green_Light 		:= 0;
			glb_err.pending_alarms 		:= 0;
			lights_status.Bottom		:= 0;
		
	END_CASE;
	
	//---------------------------------------------MANAGMENT OF THE BEACON LIGHTS AND BEEPER, AXIS 1----------------------------------------------
	CASE lights_status.Magazine_1 OF
		
		0://START
			IF (Status = AUTO OR Status = MANUAL) THEN
				lights_status.Magazine_1 	:= 10;
			END_IF;
		
		10://IDLE
			
			//Set Magazine loaded at first start up	
			IF Cartridge_loaded_control THEN
				lights_status.Magazine_1 	:= 15;
			END_IF;
			
			//Set Magazine unloaded
			IF Cartridge_Unloaded_control THEN
				lights_status.Magazine_1 	:= 16;
			END_IF;
			
			//RELOAD NEEDED
			IF Empty_Mag_1_0.Empty_Mag_Sensor THEN
				lights_status.Magazine_1 	:= 20;
			END_IF;
			
			//AXIS NOT HOMED
			IF (NOT glb_axis_1_homed) THEN
				lights_status.Magazine_1 	:= 30;
			END_IF
			
			IF Status = STOP THEN lights_status.Magazine_1 := 0; END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_1 := 0; END_IF;
			
		15://Set Green Beacon on, magazine loaded
			Beacon_1.Green 				:= 1;
			Beacon_1.White 				:= 0;
			Beacon_1.Beeper_Alarm 		:= 0;
			Cartridge_loaded_control 	:= 0;
			lights_status.Magazine_1 	:= 0;
			
		16://Set White beacon flashing, magazine unloaded
			Beacon_1.Green 				:= 0;
			Beacon_1.White 				:= TON_03_Pulse;
			Beacon_1.Beeper_Alarm 		:= 0;
			(*lights_status.Magazine_1 	:= 0;*)
			
			IF glb_cmd.Cartridge_loaded THEN
				lights_status.Magazine_1 := 23;
			END_IF;
		
		
		20://REOAD LIGHTS PROCEDURE, WHITE BEACON AND BLUE LED BILNKING, BUZZER BEEPS ONLY 3 TIMES
			Beacon_1.Green 			:= 0;
		
			Beacon_1.White 			:= TON_03_Pulse;
			(*Beacon_1.Beeper_Alarm 	:= TON_03_Pulse;*) //IT DOESN'T FUCKING BEEP
			glb_io.Do.Blue_Light 	:= TON_03_Pulse;
			
			IF (TON_03_Pulse AND (NOT Blink_Cmd)) THEN 
				Blink_Counter := Blink_Counter + 1;
				Blink_Cmd := 1;
			ELSIF ((NOT TON_03_Pulse) AND Blink_Cmd) THEN
				Blink_Cmd := 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				lights_status.Magazine_1 := 21;
			END_IF;
			
			IF Status = STOP THEN Beacon_1.Beeper_Alarm := 0; lights_status.Magazine_1 := 0; END_IF;
			
			IF Status = ERR THEN Beacon_1.Beeper_Alarm := 0; lights_status.Magazine_1 := 0; END_IF;
			
		21://WHITE BEACON BLINKING AND BLUE LED BLINKING, BEACON BUZZER STOP
			
			Beacon_1.Beeper_Alarm 		:= 0;
			
			Beacon_1.White 				:= TON_03_Pulse;
			glb_io.Do.Blue_Light		:= TON_03_Pulse;
			
			//PRESS RESET TO SWITCH OFF BLUE BLINKING LED AND START RELOADING MOVEMENT
			IF glb_io.Di.Reset THEN
				lights_status.Magazine_1 := 22;
			END_IF;
			
			IF Status = STOP THEN lights_status.Magazine_1 := 0; END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_1 := 0; END_IF;
			
		22://ONLY WHITE BEACON FLASHING
			glb_io.Do.Blue_Light := 0;
			
			Beacon_1.White := TON_03_Pulse;
			
			IF glb_cmd.Cartridge_loaded THEN
				lights_status.Magazine_1 := 23;
			END_IF;
		
		23://RESET & BACK TO START, GREEN BEACON ON
			Beacon_1.Green 				:= 1;
			Beacon_1.White 				:= 0;
			Beacon_1.Beeper_Alarm 		:= 0;
			glb_cmd.Beeper_Lock			:= 0;
			lights_status.Magazine_1	:= 0;
		
		30://GREEN AND WHITE BEACON BLINKING IF AXIS IS NOT HOMED
			IF (NOT glb_axis_1_homed) THEN
				Beacon_1.White 			:= TON_03_Pulse;
				Beacon_1.Green			:= TON_03_Pulse;
			END_IF
			
			//AXIS HOMED
			IF glb_axis_1_homed THEN
				lights_status.Magazine_1 := 31;
			END_IF;
			
			IF Status = STOP THEN lights_status.Magazine_1 := 0; END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_1 := 0; END_IF;
		
		31://RESET AFTER AXIS HOMED
			Beacon_1.Green 				:= 0;
			Beacon_1.White 				:= 0;
			lights_status.Magazine_1 	:= 0;
			
		
	END_CASE;
	
	//----------------------------------------------MANAGMENT OF THE BEACON LIGHT AND BEEPER, AXIS 2------------------------------------------
	CASE lights_status.Magazine_2 OF
		
		0://START
			IF (Status = AUTO OR Status = MANUAL) THEN
				lights_status.Magazine_2 	:= 10;
			END_IF;
		
		10://IDLE
			
			//Set Magazine loaded at first start up	
			IF Cartridge_loaded_control_2 THEN
				lights_status.Magazine_2 	:= 15;
			END_IF;
			
			//Set Magazine unloaded
			IF Cartridge_Unloaded_control_2 THEN
				lights_status.Magazine_2 	:= 16;
			END_IF;
			
			//RELOAD NEEDED
			IF Empty_Mag_22.Empty_Mag_Sensor THEN
				lights_status.Magazine_2 	:= 20;
			END_IF;
			
			//AXIS NOT HOMED
			IF (NOT glb_axis_2_homed)	THEN
				lights_status.Magazine_2 	:= 30;
			END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_2 := 0; END_IF;
			
		15:
			Beacon_2.Green 				:= 1;
			Beacon_2.White 				:= 0;
			Beacon_2.Beeper_Alarm 		:= 0;
			lights_status.Magazine_2 	:= 0;
			
		16:
			Beacon_2.Green 				:= 0;
			Beacon_2.White 				:= TON_03_Pulse;
			Beacon_2.Beeper_Alarm 		:= 0;
			(*lights_status.Magazine_2 	:= 0;*)
			
			IF glb_cmd_2.Cartridge_loaded THEN
				lights_status.Magazine_2 := 23;
			END_IF;
			
		
		20://REOAD LIGHTS PROCEDURE, WHITE BEACON AND BLUE LED BILNKING, BEEPER BEEPS ONLY 3 TIMES
			Beacon_2.Green			:= 0;
		
			Beacon_2.White 			:= TON_03_Pulse;
			glb_io.Do.Blue_Light 	:= TON_03_Pulse;
			(*Beacon_2.Beeper_Alarm 	:= TON_03_Pulse;*) //IT DOESN'T FUCKING BEEP pt.2
			
			
			IF (TON_03_Pulse AND (NOT Blink_Cmd)) THEN 
				Blink_Counter 	:= Blink_Counter + 1;
				Blink_Cmd 		:= 1;
			ELSIF ((NOT Beacon_2.Beeper_Alarm) AND Blink_Cmd) THEN
				Blink_Cmd 		:= 0;
			END_IF;
				
			IF Blink_Counter >= 3 THEN
				lights_status.Magazine_2 := 21;
			END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_2 := 0; END_IF;
			
		21://WHITE BEACON BLINKING
			Beacon_2.Beeper_Alarm		:= 0;
			Beacon_1.White 				:= TON_03_Pulse;
			glb_io.Do.Blue_Light		:= TON_03_Pulse;
			
			//PRESS RESET TO SWITCH OFF BLUE BLINKING LED AND START RELOAD MOVEMENT
			IF glb_io.Di.Reset THEN
				lights_status.Magazine_1 := 22;
			END_IF;
			
			IF Status = STOP THEN lights_status.Magazine_2 := 0; END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_2 := 0; END_IF;
			
		22:
			Beacon_2.White				:= TON_03_Pulse;
			
			IF glb_cmd_2.Cartridge_loaded THEN
				lights_status.Magazine_1 := 23;
			END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_2 := 0; END_IF;
		
		23://RESET & BACK TO START, GREEN BEACON ON
			Beacon_2.Green 				:= 1;
			Beacon_2.White 				:= 0;
			Beacon_2.Beeper_Alarm 		:= 0;
			Cartridge_loaded_control_2 	:= 0;
			lights_status.Magazine_2	:= 0;
		
		30://GREEN AND WHITE BEACON BLINKING IF AXIS IS NOT HOMED
			IF (NOT glb_axis_2_homed) THEN
				Beacon_2.Green := TON_03_Pulse;
				Beacon_2.White := TON_03_Pulse;
			END_IF;
		
			//AXIS HOMED
			IF glb_axis_2_homed THEN
				lights_status.Magazine_2 := 31;
			END_IF;
			
			IF Status = ERR THEN lights_status.Magazine_2 := 0; END_IF;
		
		31://RESET AFTER AXIS HOMED
			Beacon_2.Green 				:= 0;
			Beacon_2.White 				:= 0;
			lights_status.Magazine_2 	:= 0;
		
		
	END_CASE;
	
	//---------------------------------TIMERS----------------------------------
	
	TON_03;
	TON_04;
	
	TON_03( IN:=NOT TON_04.Q, PT:=T#0.5s);
	TON_03_Pulse := TON_03.Q;

	TON_04( IN:=TON_03.Q, PT:= T#0.5s);
	
END_PROGRAM

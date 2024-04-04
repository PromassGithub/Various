(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: xsm_demo
 * File: xsm_demo.st
 * Author: leesa
 * Created: July 24, 2009
 ********************************************************************
 * Implementation of program xsm_demo
 ********************************************************************)

PROGRAM _INIT
	
	IF (posizione_salvata <> 0) THEN Actual_Position_0 := posizione_salvata; END_IF;

	(* Set up XSM Control parameters. *)
	XSM_Ctrl_0.IO_Mapping.DeviceName := 'IF6.ST2';					(* Location of SM module on X20 CPU. *)
	XSM_Ctrl_0.IO_Mapping.Channel := 1;								(* Channel number, motor 1 on the module. *)

	XSM_Ctrl_0.Parameters.Units_rev := 700;							(* User scaling, units per rev. *)
	XSM_Ctrl_0.Parameters.PosSWLimit := 100000;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_0.Parameters.NegSWLimit := -100;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_0.Parameters.HomePosition := 0;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_0.Parameters.HomeMode := 0;							(* Required homing mode, change to suit application. *)
	XSM_Ctrl_0.Parameters.Ignore_SWLimits := FALSE;					(* On. *)
	XSM_Ctrl_0.Parameters.Ignore_HWLimits := FALSE;					(* On. *)
	XSM_Ctrl_0.Parameters.HWLimits_Active_Low := FALSE;				(* Off. *)
	XSM_Ctrl_0.Parameters.StallDetectionEnable := FALSE;			(* Off. *)	
	XSM_Ctrl_0.Parameters.UnderCurrentDetectionEnable := FALSE;		(* Off. *)

	(* Set up I/O configuration - No need to defind in AS I/O Configuration for module. *)
	XSM_IO_Cfg_0.IO_Cfg.MixedDecayCfg := 15;							(* AS Default, change to suit application. *)

	XSM_IO_Cfg_0.IO_Cfg.Current.Holding := 0.8;						(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_0.IO_Cfg.Current.Rated := 1.5;							(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_0.IO_Cfg.Current.Maximum := 1.5;						(* A, Change to suit motor/application. *)

	XSM_IO_Cfg_0.IO_Cfg.FullStepThreshold := 0;							(* Also sets to AS Default of 65535, change to suit application. *)

	XSM_IO_Cfg_0.IO_Cfg.StallCfg.StallDetection := 0;					(* AS Default, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.StallCfg.StallDetection := FALSE;				(* AS Default, change to suit application. *)
	
	XSM_IO_Cfg_0.IO_Cfg.RefCfg.ReferencingConfiguration := 0;			(* AS Default (Positive edge 0 ), change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.RefCfg.StallRecongnitionDelay := 8;				(* AS Default units of 25ms, change to suit application. *)

	XSM_IO_Cfg_0.IO_Cfg.MPGen.MaxSpeed :=			1000;					(* Units/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.MaxAcc :=				5000;					(* Units/s/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.MaxDec :=				5000;					(* Units/s/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.RevLoop := 			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.FixedPos_a :=			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.FixedPos_b :=			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.RefSpeed :=			100;					(* Units/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_0.IO_Cfg.MPGen.JoltTimeLimitation:=	0;						(* AS Default, change to suit application. *)

	XSM_IO_Cfg_0.pIO_Mapping := ADR(XSM_Ctrl_0.IO_Mapping);				(* Pass IO mapping structure from XSM_Ctrl(). *)
	XSM_IO_Cfg_0.pParameters := ADR(XSM_Ctrl_0.Parameters);				(* Pass parameter structure from XSM_Ctrl(). *)

	(* Set up AcyclicRead(). *)
	XSM_AcyclicRead_0.pIO_Mapping :=	ADR(XSM_Ctrl_0.IO_Mapping);		(* Pass IO mapping structure from XSM_Ctrl(). *)
	
END_PROGRAM


PROGRAM _CYCLIC
	
	(* ONLY FOR DEMO PURPOSES WITH VCN & SG4 OR WATCH & SGC. *)
	(* You need to make required state machine and error handling for your application. *)
	
	//2023 - SET VARIABLES OF SECOND FUNCTION BLOCK
	
	Module_OK := XSM_Ctrl_0.IO_Mapping.ModuleOK;
	Module_ID := XSM_Ctrl_0.IO_Mapping.ModuleID;
	Input_Status := XSM_Ctrl_0.IO_Mapping.InputStatus;
	
	
	
	
	XSM_Ctrl_0(); (* Call function. *)
	XSM_IO_Cfg_0(); (* Call function. *)
	XSM_AcyclicRead_0(); (* Call function. *)
	
	XSM_Ctrl_0.Cmd.Reset := glb_hmi.Out.Reset;

	glb_err.Drive1 := XSM_Ctrl_0.Error;
	
	
	//---------------------------------KEY PAIRING---------------------------------
	
	//PAIRING OF AUTO HOMING ACK BUTTON
	
	Auto_Homing_Ack := glb_cmd.Auto_Homing_Ack;
	
	//PAIRING OF RESET BUTTON
	
	XSM_Ctrl_0.Cmd.Reset := glb_io.Di.Reset;
	
	//MOD FOR HOMING AND LIGHT CONTROL
	
	First_Homing := Homed;
	
	glb_axis_1_homed := Homed;
	
	//PAIRING FOR MOVEMENT KEY LOCKING WHILE ONGOING HOMING PROCEDURE
	
	glb_cmd.Homing_Lock := (XSM_Ctrl_0.Parameters.Ignore_SWLimits AND XSM_Ctrl_0.Parameters.Ignore_HWLimits);
	
	
	
	IF (Status <> ERR) THEN XSM_Ctrl_0.Enable := TRUE; END_IF
	
	CASE Init_motor_status OF
		
		0: IF (NOT motor_init) THEN motor_init := 1; Init_motor_status := 10; END_IF
			
		10: 
			XSM_IO_Cfg_0.Enable := TRUE;
			IF (XSM_IO_Cfg_0.Status = 0) THEN Init_motor_status := 20; END_IF
		
		20: 
			XSM_IO_Cfg_0.Config := TRUE;
			IF (XSM_IO_Cfg_0.Done) THEN Init_motor_status := 30; END_IF
			
		30:
			XSM_IO_Cfg_0.Config := FALSE;
			XSM_IO_Cfg_0.Enable := FALSE;
			init_motor_complete := TRUE;
			Init_motor_status := 0;
		
	END_CASE
	
	CASE Motor_state OF
		
		0: // idle stop
			IF (init_motor_complete AND Status = AUTO) THEN
				Motor_state := AUTO;
			ELSIF (init_motor_complete AND Status = MANUAL) THEN
				Motor_state := MANUAL;
			ELSIF (Status = ERR OR XSM_Ctrl_0.Error) THEN
				Motor_state := ERR;
			END_IF;
			
		10: // auto
			XSM_Ctrl_0.Power := TRUE;
			IF (Status = STOP) THEN
				Motor_state := STOP;
				XSM_Ctrl_0.Power := FALSE;
			ELSIF (Status = ERR OR XSM_Ctrl_0.Error) THEN
				Motor_state := ERR;
			END_IF
			
		20: // manual
			XSM_Ctrl_0.Power := TRUE;
			IF (Status = STOP) THEN
				Motor_state := STOP;
				XSM_Ctrl_0.Power := FALSE;
			ELSIF (Status = ERR OR XSM_Ctrl_0.Error) THEN
				Motor_state := ERR;
			END_IF
			
		30: // error
			XSM_Ctrl_0.Power := FALSE;
			IF (Status = STOP AND (NOT XSM_Ctrl_0.Error)) THEN
				glb_err.Drive1 := FALSE;
				Motor_state := STOP;
			END_IF

	END_CASE;
	
	//MARCIA MOTORE CARICATORE IN MANUALE
	CASE MM_0.MM_status OF		
		
		0:	//Safety check
			IF ((Status = MANUAL OR Status = AUTO) AND glb_err.pending_alarms = 0 AND Homed AND (NOT glb_err.Drive1)) THEN
				MM_0.MM_status := 1;
			END_IF;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			
		1:	//Wait for input
			IF (MM_0.MM_Avanti AND (NOT MM_0.MM_Indietro)) THEN
				MM_0.MM_status := 10;
			END_IF;
			
			IF (MM_0.MM_Indietro AND (NOT MM_0.MM_Avanti)) THEN
				MM_0.MM_status := 20;
			END_IF;
		
		10:	//Forward
			XSM_Ctrl_0.Cmd.Velocity := 200;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			
			IF (NOT MM_0.MM_Avanti) THEN
				MM_0.MM_status := 30;
			END_IF;
			
			IF (Empty_Mag_1_0.Empty_Mag_Sensor) THEN
				MM_0.MM_status := 40;
			END_IF;
		
		20:	//Backward
			XSM_Ctrl_0.Cmd.Velocity := -200;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			
			IF (NOT MM_0.MM_Indietro) THEN
				MM_0.MM_status := 30;
			END_IF;
			
			IF (XSM_Ctrl_0.Monitor.Actual_Position = XSM_Ctrl_0.Parameters.HomePosition) THEN
				MM_0.MM_status := 31;
			END_IF;
			
			IF (XSM_Ctrl_0.Monitor.Input_1) THEN
				MM_0.MM_status := 41;
			END_IF;
			
		30:	//Reset and back to safety
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Stop := TRUE;
			old_pos := XSM_Ctrl_0.Monitor.Actual_Position;
			MM_0.MM_status := 0;
					
		31:	//Left Stop
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			Status := STOP;
			MM_0.MM_status := 0;
		
		40:	//StepBack after sensor touch
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Velocity := -1000;
			XSM_Ctrl_0.Cmd.Stop := TRUE;
			MM_0.MM_status := 50;
			
		41:	//StepForward after sensor touch
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Velocity := 1000;
			XSM_Ctrl_0.Cmd.Stop := TRUE;
			MM_0.MM_status := 51;
		
		50:	//Stepback start move
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			MM_0.MM_status := 60;
			
		51:	//Stepforward start move
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			MM_0.MM_status := 61;
		
		60:	//Stepback reset & back to start
			IF (NOT Empty_Mag_1_0.Empty_Mag_Sensor) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
				Status := STOP;
				MM_0.MM_status := 0;
			END_IF;
			
		61:	//Stepforward reset, back to start
			IF (NOT XSM_Ctrl_0.Monitor.Input_1) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
				Status := STOP;
				MM_0.MM_status := 0;
			END_IF;
		
			
		
	END_CASE;
	
	//POP UP DI AUTO HOMING
//	CASE Auto_Homing_Ctrl_0.Auto_Homing_Status OF  
//		
//		0:	//Start
//			IF ((NOT Homed) AND Status = AUTO) THEN
//				Auto_Homing_Ctrl_0.Auto_Homing_Status := 1;
//			END_IF;
//			Auto_Homing_Ctrl_0.Pop_Up := 1;
//			Auto_Homing_Ack := 0;
//			Auto_Homing_Ctrl_0.Auto_Homing_Ack_Pop_Up := FALSE;
//			
//		1:	//Pop Up
//			Auto_Homing_Ctrl_0.Pop_Up := 0;
//			Auto_Homing_Ctrl_0.Auto_Homing_Status := 10;
//			
//			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_0.Auto_Homing_Status := 40; END_IF;
//			
//		10:	//Ack Pop Up
//			IF (Auto_Homing_Ack) THEN
//				Auto_Homing_Ctrl_0.Pop_Up := 1;
//				Auto_Homing_Ctrl_0.Auto_Homing_Status := 20;
//			END_IF;
//			
//			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_0.Auto_Homing_Status := 40; END_IF;
//		
//		20:	//Movement
//			Auto_Homing_Ctrl_0.Auto_Homing_Ack_Pop_Up := TRUE;
//			Auto_Homing_Ctrl_0.Auto_Homing_Status := 30;
//			
//			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_0.Auto_Homing_Status := 40; END_IF;
//		
//		30:	//Back to start
//			IF (Homed) THEN
//				Auto_Homing_Ctrl_0.Auto_Homing_Status := 40;
//			END_IF;
//			
//			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_0.Auto_Homing_Status := 40; END_IF;
//			
//		40:
//			Auto_Homing_Ctrl_0.Auto_Homing_Status := 0;
//		
//	END_CASE;
	
	//RICARICA
	CASE Empty_Mag_1_0.Empty_Mag_Status OF      
		
		0:	//Start
			IF (Status = AUTO AND Homed AND XSM_Ctrl_0.PowerOn AND Empty_Mag_1_0.Empty_Mag_Sensor AND glb_err.pending_alarms = 0) THEN
				glb_cmd.Cartridge_loaded_Gun := 0;
				Empty_Mag_1_0.Empty_Mag_Status := 10;
			END_IF;
			Empty_Mag_1_0.Empty_Mag_Pop_Up := 1;
			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
			
		10:	//Pop up Ack & Start Movement
			IF (glb_cmd.Start_Reload OR Empty_Mag_1_0.Empty_Mag_Ack) THEN
				glb_cmd.Start_Reload := 0;
				glb_cmd.Torna_a_casa := 1;
			END_IF;
			
			IF (XSM_Ctrl_0.Monitor.Actual_Position = XSM_Ctrl_0.Parameters.HomePosition OR glb_cmd.Cartridge_loaded) THEN
				Empty_Mag_1_0.Empty_Mag_Status := 11;
			END_IF;
			
			IF (Status <> AUTO) THEN Empty_Mag_1_0.Empty_Mag_Status := 30; END_IF;
			
		11:	//Cartidge loaded
			IF (glb_cmd.Cartridge_loaded) THEN
				Empty_Mag_1_0.Empty_Mag_Status := 20;
			END_IF;
			
			IF (Status <> AUTO) THEN Empty_Mag_1_0.Empty_Mag_Status := 30; END_IF;
					
		20:	//Back to start
			Empty_Mag_1_0.Empty_Mag_Ack := FALSE;
			Empty_Mag_1_0.Empty_Mag_Status := 0;
			
				
	END_CASE;

	//GESTIONE HOMING
	CASE Homing_status OF
		
		0: //Start
			IF (((glb_cmd.btn_homing OR Auto_Homing_Ctrl_0.Auto_Homing_Ack_Pop_Up) AND (Status = MANUAL OR Status = AUTO)) AND XSM_Ctrl_0.PowerOn) THEN
				Homing_status := 1; 
				glb_cmd.btn_homing := 0;
			END_IF;
		
		1:	//Set parameters for move
			XSM_Ctrl_0.Cmd.Velocity := -200;
			Homing_status := 10;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Parameters.Ignore_SWLimits := TRUE;	
			XSM_Ctrl_0.Parameters.Ignore_HWLimits := TRUE;
			
			IF ( Status <> MANUAL AND Status <> AUTO) THEN Homing_status:= 50; END_IF;
				
		10:	//Star move
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			Homing_status := 20;
			
			IF ( Status <> MANUAL AND Status <> AUTO) THEN Homing_status:= 50; END_IF;
			
		20:	//Stop when sensor touch
			IF ((XSM_Ctrl_0.IO_Mapping.InputStatus = 1) OR (XSM_Ctrl_0.IO_Mapping.InputStatus = 3)) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				XSM_Ctrl_0.Cmd.Velocity := 200;
				Homing_status := 30;
			END_IF;
			
			IF ( Status <> MANUAL AND Status <> AUTO) THEN Homing_status:= 50; END_IF;
			
		30:	//Step forward after sensor touch
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			Homing_status := 40;
			
			IF ( Status <> MANUAL AND Status <> AUTO) THEN Homing_status:= 50; END_IF;
			
		40: //Stop when sensor no trigger anymore
			IF (NOT (XSM_Ctrl_0.IO_Mapping.InputStatus = 1) AND NOT (XSM_Ctrl_0.IO_Mapping.InputStatus = 3)) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				Homing_status := 50;
			END_IF;
			
			IF ( Status <> MANUAL AND Status <> AUTO) THEN Homing_status:= 50; END_IF;
			
		50: //Reset & back to start
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Home := TRUE;
			IF (XSM_Ctrl_0.Monitor.Home_OK AND XSM_Ctrl_0.Monitor.Actual_Position = 0) THEN 
				XSM_Ctrl_0.Cmd.Home := FALSE;
				XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_0.Parameters.Ignore_SWLimits := FALSE;	
				XSM_Ctrl_0.Parameters.Ignore_HWLimits := FALSE;
				Homed := 1;
				Homing_status := 0;
				old_pos := 0;
				(*Status := STOP;*)
			END_IF;
		
	END_CASE;  
	
	//PASSO AUTOMATICO
	CASE FW_step_status OF
		
		0: // start
			IF (Status = AUTO AND (NOT Empty_Mag_1_0.Empty_Mag_Sensor)) THEN FW_step_status := 1; END_IF;
			
		1: // idle auto
			XSM_Ctrl_0.Cmd.Distance := Dim_etichetta;
			old_pos := XSM_Ctrl_0.Monitor.Actual_Position;
			IF ((glb_cmd.sparo) AND XSM_Ctrl_0.PowerOn AND Homed) THEN FW_step_status := 10; glb_cmd.sparo := 0; END_IF;
			
			IF (Empty_Mag_1_0.Empty_Mag_Sensor) THEN FW_step_status := 20; END_IF;
			
			IF (Status <> AUTO) THEN FW_step_status := 20; END_IF;
			
		10: //automatic forward step
			XSM_Ctrl_0.Cmd.Move_Additive := TRUE;
			IF (XSM_Ctrl_0.Monitor.Actual_Position >= (old_pos + Dim_etichetta)) THEN
				old_pos := XSM_Ctrl_0.Monitor.Actual_Position;
				FW_step_status := 20;
			END_IF;
			
			IF (Empty_Mag_1_0.Empty_Mag_Sensor) THEN FW_step_status := 20; END_IF;
			
			IF (Status <> AUTO) THEN FW_step_status := 20; END_IF;
			
		20://reset & back to start
			XSM_Ctrl_0.Cmd.Move_Additive := FALSE;
			FW_step_status := 0;
		  
	END_CASE;
		
	//RITORNO AUTOMATICO ALLA HOME
	CASE CMD_home_status OF
		0: // idle
			IF (Status = AUTO OR Status = MANUAL) THEN CMD_home_status := 1; END_IF
			
			IF (posizione_salvata <> 0) THEN Actual_Position_0 := posizione_salvata; END_IF;
			
		1: // idle auto
			
			IF (glb_cmd.Torna_a_casa AND XSM_Ctrl_0.PowerOn AND Homed) THEN 
				XSM_Ctrl_0.Cmd.Position := 0;
				CMD_home_status := 10; 
				glb_cmd.Torna_a_casa := 0; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status := 60; END_IF;
			
		10: //start move
			Disable_refresh_pos := 1;
			XSM_Ctrl_0.Cmd.Velocity := -200;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_0.Parameters.Ignore_HWLimits := TRUE;
			XSM_Ctrl_0.Parameters.Ignore_SWLimits := TRUE;
//			IF (XSM_Ctrl_0.Monitor.Actual_Position = 0) THEN 
//				CMD_home_status := 20;
			IF (XSM_Ctrl_0.Monitor.Input_1) THEN
				CMD_home_status := 30;
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status := 60; END_IF;
			
//		20:	//
//			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
//			(*XSM_Ctrl_0.Cmd.Stop := TRUE;*)
//			old_pos := 0;
//			CMD_home_status := 0;
			
		30:	//stop move
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Stop := TRUE;
			XSM_Ctrl_0.Cmd.Velocity := 1000;
			CMD_home_status := 40;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status := 60; END_IF;
			
		40: //step forward
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			IF (NOT XSM_Ctrl_0.Monitor.Input_1) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				CMD_home_status := 50;
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status := 60; END_IF;
			
		50: //reset & back to start
			XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Home := TRUE;
			IF (XSM_Ctrl_0.Monitor.Home_OK AND XSM_Ctrl_0.Monitor.Actual_Position = 0) THEN 
				XSM_Ctrl_0.Cmd.Home := FALSE;
				XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_0.Parameters.Ignore_SWLimits := FALSE;	
				XSM_Ctrl_0.Parameters.Ignore_HWLimits := FALSE;
				Homed := 1;
				CMD_home_status := 0;
				old_pos := 0;
				(*Status := STOP;*)
			END_IF;
				
		
		60:
			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
			CMD_home_status := 0;
		
	END_CASE;
	
	//REBOOT TO PREVIOUS POSITION
	CASE CMD_Reboot_pos_status OF
		0: // idle
			IF (Status = AUTO OR Status = MANUAL) AND (Homed) THEN 
				CMD_Reboot_pos_status := 1; 
			END_IF;
			
			IF (posizione_salvata <> 0) THEN Actual_Position_0 := posizione_salvata; END_IF;
			
		1:
			IF (glb_cmd.Reboot_pos) THEN 
				CMD_Reboot_pos_status := 2; 
			END_IF;
			
		2: // idle auto
			XSM_Ctrl_0.Cmd.Position := Actual_Position_0;
			IF (XSM_Ctrl_0.PowerOn AND Homed) THEN 
				CMD_Reboot_pos_status := 10; 
				glb_cmd.Reboot_pos := 0; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status := 20; END_IF;
			
		10:
			XSM_Ctrl_0.Cmd.Move_Absolute := TRUE;
			IF (XSM_Ctrl_0.Monitor.Actual_Position = Actual_Position_0) THEN 
				old_pos := XSM_Ctrl_0.Monitor.Actual_Position;
				Disable_refresh_pos := 0;
				CMD_Reboot_pos_status := 20; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status := 20; END_IF;
			
		20:
			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
			CMD_Reboot_pos_status := 0;
		
	END_CASE;
	
	IF ( glb_sim = 1) THEN
//		XSM_Ctrl_0.Monitor.Actual_Position := Stepper_1_position;
	END_IF;
	
		
	
	IF (XSM_Ctrl_0.Monitor.Home_OK AND (NOT Disable_refresh_pos)) THEN 	posizione_salvata := XSM_Ctrl_0.Monitor.Actual_Position; END_IF;
	
	
END_PROGRAM

PROGRAM _EXIT


(* TODO : Add your code here *)


END_PROGRAM

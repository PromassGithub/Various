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
	
	IF (posizione_salvata_2 <> 0) THEN Actual_Position_2 := posizione_salvata_2; END_IF

	(* Set up XSM Control parameters. *)
	XSM_Ctrl_2.IO_Mapping.DeviceName := 'IF6.ST2';					(* Location of SM module on X20 CPU. *)
	XSM_Ctrl_2.IO_Mapping.Channel := 2;								(* Channel number, motor 1 on the module. *)

	XSM_Ctrl_2.Parameters.Units_rev := 700;							(* User scaling, units per rev. *)
	XSM_Ctrl_2.Parameters.PosSWLimit := 19000;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_2.Parameters.NegSWLimit := -100;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_2.Parameters.HomePosition := 0;						(* Units based on user scaling, change to suit application. *)
	XSM_Ctrl_2.Parameters.HomeMode := 0;							(* Required homing mode, change to suit application. *)
	XSM_Ctrl_2.Parameters.Ignore_SWLimits := FALSE;					(* On. *)
	XSM_Ctrl_2.Parameters.Ignore_HWLimits := FALSE;					(* On. *)
	XSM_Ctrl_2.Parameters.HWLimits_Active_Low := FALSE;				(* Off. *)
	XSM_Ctrl_2.Parameters.StallDetectionEnable := FALSE;			(* Off. *)	
	XSM_Ctrl_2.Parameters.UnderCurrentDetectionEnable := FALSE;		(* Off. *)

	(* Set up I/O configuration - No need to defind in AS I/O Configuration for module. *)
	XSM_IO_Cfg_2.IO_Cfg.MixedDecayCfg := 15;							(* AS Default, change to suit application. *)

	XSM_IO_Cfg_2.IO_Cfg.Current.Holding := 0.20;						(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_2.IO_Cfg.Current.Rated := 1.20;							(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_2.IO_Cfg.Current.Maximum := 1.50;						(* A, Change to suit motor/application. *)

	XSM_IO_Cfg_2.IO_Cfg.FullStepThreshold := 0;							(* Also sets to AS Default of 65535, change to suit application. *)

	XSM_IO_Cfg_2.IO_Cfg.StallCfg.StallDetection := 0;					(* AS Default, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.StallCfg.StallDetection := FALSE;				(* AS Default, change to suit application. *)
	
	XSM_IO_Cfg_2.IO_Cfg.RefCfg.ReferencingConfiguration := 0;			(* AS Default (Positive edge 0 ), change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.RefCfg.StallRecongnitionDelay := 8;				(* AS Default units of 25ms, change to suit application. *)

	XSM_IO_Cfg_2.IO_Cfg.MPGen.MaxSpeed :=			1000;					(* Units/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.MaxAcc :=				5000;					(* Units/s/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.MaxDec :=				5000;					(* Units/s/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.RevLoop := 			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.FixedPos_a :=			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.FixedPos_b :=			0;						(* Units based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.RefSpeed :=			100;					(* Units/s based on user scaling, change to suit application. *)
	XSM_IO_Cfg_2.IO_Cfg.MPGen.JoltTimeLimitation:=	0;						(* AS Default, change to suit application. *)

	XSM_IO_Cfg_2.pIO_Mapping := ADR(XSM_Ctrl_2.IO_Mapping);				(* Pass IO mapping structure from XSM_Ctrl(). *)
	XSM_IO_Cfg_2.pParameters := ADR(XSM_Ctrl_2.Parameters);				(* Pass parameter structure from XSM_Ctrl(). *)

	(* Set up AcyclicRead(). *)
	XSM_AcyclicRead_2.pIO_Mapping :=	ADR(XSM_Ctrl_2.IO_Mapping);		(* Pass IO mapping structure from XSM_Ctrl(). *)
	
END_PROGRAM


PROGRAM _CYCLIC
	
	(* ONLY FOR DEMO PURPOSES WITH VCN & SG4 OR WATCH & SGC. *)
	(* You need to make required state machine and error handling for your application. *)
	
	//2023 - set variables of FB
	
	XSM_Ctrl_2.IO_Mapping.ModuleOK := Module_OK;
	XSM_Ctrl_2.IO_Mapping.ModuleID := Module_ID;
	XSM_Ctrl_2.IO_Mapping.InputStatus := Input_Status;
	
	
	//2023 - temporary to disable popup
	Empty_Mag_22.Empty_Mag_Pop_Up := 1;
	//2023 - end mod
	
	XSM_Ctrl_2(); (* Call function. *)
	XSM_IO_Cfg_2(); (* Call function. *)
	XSM_AcyclicRead_2(); (* Call function. *)
	
	XSM_Ctrl_2.Cmd.Reset := glb_hmi.Out.Reset;

	glb_err.Drive2 := XSM_Ctrl_2.Error;
	
	IF (Status <> ERR) THEN XSM_Ctrl_2.Enable := TRUE; END_IF;
	
	CASE Init_motor_status_2 OF
		
		0: IF (NOT motor_init_2) THEN motor_init_2 := 1; Init_motor_status_2 := 10; END_IF
			
		10: 
			XSM_IO_Cfg_2.Enable := TRUE;
			IF (XSM_IO_Cfg_2.Status = 0) THEN Init_motor_status_2 := 20; END_IF
		
		20: 
			XSM_IO_Cfg_2.Config := TRUE;
			IF (XSM_IO_Cfg_2.Done) THEN Init_motor_status_2 := 30; END_IF
			
		30:
			XSM_IO_Cfg_2.Config := FALSE;
			XSM_IO_Cfg_2.Enable := FALSE;
			init_motor_complete_2 := TRUE;
			Init_motor_status_2 := 0;
		
	END_CASE
	
	CASE Motor_state_2 OF
		
		0: // idle stop
			IF (init_motor_complete_2 AND Status = AUTO) THEN
				Motor_state_2 := AUTO;
			ELSIF (init_motor_complete_2 AND Status = MANUAL) THEN
				Motor_state_2 := MANUAL;
			ELSIF (Status = ERR OR XSM_Ctrl_2.Error) THEN
				Motor_state_2 := ERR;
			END_IF;
			
		10: // auto
			XSM_Ctrl_2.Power := TRUE;
			IF (Status = STOP) THEN
				Motor_state_2 := STOP;
				XSM_Ctrl_2.Power := FALSE;
			ELSIF (Status = ERR OR XSM_Ctrl_2.Error) THEN
				Motor_state_2 := ERR;
			END_IF
			
		20: // manual
			XSM_Ctrl_2.Power := TRUE;
			IF (Status = STOP) THEN
				Motor_state_2 := STOP;
				XSM_Ctrl_2.Power := FALSE;
			ELSIF (Status = ERR OR XSM_Ctrl_2.Error) THEN
				Motor_state_2 := ERR;
			END_IF
			
		30: // error
			XSM_Ctrl_2.Power := FALSE;
			IF (Status = STOP AND (NOT XSM_Ctrl_2.Error)) THEN
				glb_err.Drive2 := FALSE;
				Motor_state_2 := STOP;
			END_IF

	END_CASE;
	
	
	CASE MM_2.MM_status OF		//Marcia Motore in manuale
		
		0:	//Safety check
			IF (Status = MANUAL AND glb_err.pending_alarms = 0 AND Homed_2 AND (NOT glb_err.Drive2)) THEN
				MM_2.MM_status := 1;
			END_IF;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			
		1:	//Wait for input
			IF (MM_2.MM_Avanti AND (NOT MM_2.MM_Avanti_Vel) AND (NOT MM_2.MM_Indietro) AND ( NOT MM_2.MM_Indietro_Vel)) THEN
				MM_2.MM_status := 10;
			END_IF;
			
			IF (MM_2.MM_Indietro AND (NOT MM_2.MM_Avanti) AND (NOT MM_2.MM_Avanti_Vel) AND ( NOT MM_2.MM_Indietro_Vel)) THEN
				MM_2.MM_status := 20;
			END_IF;
			
			IF (MM_2.MM_Avanti_Vel AND (NOT MM_2.MM_Avanti) AND (NOT MM_2.MM_Indietro) AND ( NOT MM_2.MM_Indietro_Vel)) THEN
				MM_2.MM_status := 11;
			END_IF;
			
			IF (MM_2.MM_Indietro_Vel AND (NOT MM_2.MM_Avanti) AND (NOT MM_2.MM_Indietro) AND ( NOT MM_2.MM_Avanti_Vel)) THEN
				MM_2.MM_status := 21;
			END_IF;
		
		10:	//Forward
			XSM_Ctrl_2.Cmd.Velocity := 200;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			
			IF (NOT MM_2.MM_Avanti) THEN
				MM_2.MM_status := 30;
			END_IF;
			
			IF (Empty_Mag_22.Empty_Mag_Sensor) THEN
				MM_2.MM_status := 40;
			END_IF;
			
		11:	//Fast Forward
			XSM_Ctrl_2.Cmd.Velocity := 500;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			
			IF (NOT MM_2.MM_Avanti_Vel) THEN
				MM_2.MM_status := 30;
			END_IF;
			
			IF (Empty_Mag_22.Empty_Mag_Sensor) THEN
				MM_2.MM_status := 40;
			END_IF;
		
		20:	//Backward
			XSM_Ctrl_2.Cmd.Velocity := -200;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			
			IF (NOT MM_2.MM_Indietro) THEN
				MM_2.MM_status := 30;
			END_IF;
			
			IF (XSM_Ctrl_2.Monitor.Actual_Position = XSM_Ctrl_2.Parameters.HomePosition) THEN
				MM_2.MM_status := 31;
			END_IF;
			
			IF (XSM_Ctrl_2.Monitor.Input_1) THEN
				MM_2.MM_status := 41;
			END_IF;
			
		21:	//Fast Backward
			XSM_Ctrl_2.Cmd.Velocity := -500;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			
			IF (NOT MM_2.MM_Indietro_Vel) THEN
				MM_2.MM_status := 30;
			END_IF;
			
			IF (XSM_Ctrl_2.Monitor.Actual_Position = XSM_Ctrl_2.Parameters.HomePosition) THEN
				MM_2.MM_status := 31;
			END_IF;
			
		30:	//Reset and back to safety
			XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_2.Cmd.Velocity := 0;
			XSM_Ctrl_2.Cmd.Stop := TRUE;
			old_pos_2 := XSM_Ctrl_2.Monitor.Actual_Position;
			Status := STOP;
			MM_2.MM_status := 0;
					
		31:	//Left Stop
			XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Cmd.Velocity := 0;
			Status := STOP;
			MM_2.MM_status := 0;
		
		40:	//StepBack after sensor touch
			XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_2.Cmd.Velocity := -1000;
			XSM_Ctrl_2.Cmd.Stop := TRUE;
			MM_2.MM_status := 50;
			
		41:	//StepForward after sensor touch
			XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
			XSM_Ctrl_2.Cmd.Velocity := 1000;
			XSM_Ctrl_2.Cmd.Stop := TRUE;
			MM_2.MM_status := 51;
		
		50:	//Stepback start move
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			MM_2.MM_status := 60;
			
		51:	//Stepforward start move
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			MM_2.MM_status := 61;
		
		60:	//Stepback reset back to start
			IF (NOT Empty_Mag_22.Empty_Mag_Sensor) THEN
				XSM_Ctrl_2.Cmd.Stop := TRUE;
				XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_2.Cmd.Velocity := 0;
				Status := STOP;
				MM_2.MM_status := 0;
			END_IF;
			
		61:	//Stepforward reset back to start
			IF (NOT XSM_Ctrl_2.Monitor.Input_1) THEN
				XSM_Ctrl_2.Cmd.Stop := TRUE;
				XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_2.Cmd.Velocity := 0;
				Status := STOP;
				MM_2.MM_status := 0;
			END_IF;
		
	END_CASE;
	
	CASE Auto_Homing_Ctrl_2.Auto_Homing_Status OF  //Pop Up di Auto Homing
		
		0:	//Start
			IF ((NOT Homed_2) AND Status = AUTO) THEN
				Auto_Homing_Ctrl_2.Auto_Homing_Status := 1;
			END_IF;
			Auto_Homing_Ctrl_2.Pop_Up := 1;
			Auto_Homing_Ack_2 := 0;
			Auto_Homing_Ctrl_2.Auto_Homing_Ack_Pop_Up := FALSE;
			
		1:	//Pop Up
			Auto_Homing_Ctrl_2.Pop_Up := 0;
			Auto_Homing_Ctrl_2.Auto_Homing_Status := 10;
			
			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_2.Auto_Homing_Status := 40; END_IF;
			
		10:	//Ack Pop Up
			IF (Auto_Homing_Ack_2) THEN
				Auto_Homing_Ctrl_2.Pop_Up := 1;
				Auto_Homing_Ctrl_2.Auto_Homing_Status := 20;
			END_IF;
			
			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_2.Auto_Homing_Status := 40; END_IF;
		
		20:	//Movement
			Auto_Homing_Ctrl_2.Auto_Homing_Ack_Pop_Up := TRUE;
			Auto_Homing_Ctrl_2.Auto_Homing_Status := 30;
			
			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_2.Auto_Homing_Status := 40; END_IF;
		
		30:	//Back to start
			IF (Homed_2) THEN
				Auto_Homing_Ctrl_2.Auto_Homing_Status := 40;
			END_IF;
			
			IF (Status <> AUTO) THEN Auto_Homing_Ctrl_2.Auto_Homing_Status := 40; END_IF;
			
		40:
			Auto_Homing_Ctrl_2.Auto_Homing_Status := 0;
		
	END_CASE;
	
	CASE Empty_Mag_22.Empty_Mag_Status OF      //Ricarica
		
		0:	//Start
			IF (Status = AUTO AND Homed_2 AND XSM_Ctrl_2.PowerOn AND Empty_Mag_22.Empty_Mag_Sensor AND glb_err.pending_alarms = 0) THEN
				Empty_Mag_22.Empty_Mag_Status := 10;
			END_IF;
			Empty_Mag_22.Empty_Mag_Pop_Up := 1;
			XSM_Ctrl_2.Cmd.Move_Absolute := FALSE;
			
		10:	//Pop up
			Empty_Mag_22.Empty_Mag_Pop_Up := 0;
			Empty_Mag_22.Empty_Mag_Status := 20;
			
			IF (Status <> AUTO) THEN Empty_Mag_22.Empty_Mag_Status := 30; END_IF;
			
		20:	//Pop up Ack & Start Movement
			IF (Empty_Mag_22.Empty_Mag_Ack) THEN
				glb_cmd_2.Torna_a_casa := TRUE;
				Empty_Mag_22.Empty_Mag_Pop_Up := 1;
			END_IF;
			
			IF (XSM_Ctrl_2.Monitor.Actual_Position = XSM_Ctrl_2.Parameters.HomePosition) THEN
				Empty_Mag_22.Empty_Mag_Status := 30;
			END_IF;
			
			IF (Status <> AUTO) THEN Empty_Mag_22.Empty_Mag_Status := 30; END_IF;
			
		30:	//Back to start
			old_pos_2 := 0;
			Empty_Mag_22.Empty_Mag_Ack := FALSE;
			Empty_Mag_22.Empty_Mag_Status := 0;
			
				
	END_CASE;
	
		
	CASE Homing_status_2 OF
		
		0: 
			IF (((glb_cmd_2.btn_homing AND Status = MANUAL) OR ((NOT Homed_2) AND Status = AUTO AND Auto_Homing_Ctrl_2.Auto_Homing_Ack_Pop_Up)) AND XSM_Ctrl_2.PowerOn) THEN
				Homing_status_2 := 1; 
				glb_cmd_2.btn_homing := 0;
			END_IF;
		
		1:
			XSM_Ctrl_2.Cmd.Velocity := -200;
			Homing_status_2 := 10;
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Parameters.Ignore_SWLimits := TRUE;	
			XSM_Ctrl_2.Parameters.Ignore_HWLimits := TRUE;
				
		10:
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			Homing_status_2 := 20;
		20:
			IF (XSM_Ctrl_2.IO_Mapping.InputStatus = 1) THEN
				XSM_Ctrl_2.Cmd.Stop := TRUE;
				XSM_Ctrl_2.Cmd.Velocity := 200;
				Homing_status_2 := 30;
			END_IF;
		30:
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Cmd.Move_Velocity := TRUE;
			Homing_status_2 := 40;
		40:
			IF (NOT (XSM_Ctrl_2.IO_Mapping.InputStatus = 1)) THEN
				XSM_Ctrl_2.Cmd.Stop := TRUE;
				Homing_status_2 := 50;
			END_IF;
			
		50: 
			XSM_Ctrl_2.Cmd.Stop := FALSE;
			XSM_Ctrl_2.Cmd.Home := TRUE;
			IF XSM_Ctrl_2.Monitor.Home_OK THEN 
				XSM_Ctrl_2.Cmd.Home := FALSE;
				XSM_Ctrl_2.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_2.Parameters.Ignore_SWLimits := FALSE;	
				XSM_Ctrl_2.Parameters.Ignore_HWLimits := FALSE;
				Homed_2 := 1;
				Homing_status_2 := 0;
				old_pos_2 := 0;
				Status := STOP;
			END_IF;
		
	END_CASE;  
	
	
	CASE FW_step_status_2 OF
		
		0: // idle
			IF (Status = AUTO AND (NOT Empty_Mag_22.Empty_Mag_Sensor)) THEN FW_step_status_2 := 1; END_IF;
			
		1: // idle auto
			XSM_Ctrl_2.Cmd.Distance := Dim_etichetta;
			IF ((glb_cmd_2.sparo) AND XSM_Ctrl_2.PowerOn AND Homed_2) THEN FW_step_status_2 := 10; glb_cmd_2.sparo := 0; END_IF;
			
			IF (Empty_Mag_22.Empty_Mag_Sensor) THEN FW_step_status_2 := 20; END_IF;
			
			IF (Status <> AUTO) THEN FW_step_status_2 := 20; END_IF;
			
		10: // 
			XSM_Ctrl_2.Cmd.Move_Additive := TRUE;
			IF (XSM_Ctrl_2.Monitor.Actual_Position = (old_pos_2 + Dim_etichetta)) THEN
				old_pos_2 := XSM_Ctrl_2.Monitor.Actual_Position;
				FW_step_status_2 := 20;
			END_IF;
			
			IF (Empty_Mag_22.Empty_Mag_Sensor) THEN FW_step_status_2 := 20; END_IF;
			
			IF (Status <> AUTO) THEN FW_step_status_2 := 20; END_IF;
		20:
			XSM_Ctrl_2.Cmd.Move_Additive := FALSE;
			FW_step_status_2 := 0;
		  
	END_CASE;
	
	CASE CMD_home_status_2 OF
		0: // idle
			IF (Status = AUTO OR Status = MANUAL) THEN CMD_home_status_2 := 1; END_IF
			
		1: // idle auto
			
			IF (glb_cmd_2.Torna_a_casa AND XSM_Ctrl_2.PowerOn AND Homed_2) THEN 
				XSM_Ctrl_2.Cmd.Position := 0;
				CMD_home_status_2 := 10; 
				glb_cmd_2.Torna_a_casa := 0; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status_2 := 21; END_IF;
			
		10:
			XSM_Ctrl_2.Cmd.Move_Absolute := TRUE;
			IF (XSM_Ctrl_2.Monitor.Actual_Position = 0) THEN CMD_home_status_2 := 20; END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_home_status_2 := 21; END_IF;
			
		20:
			XSM_Ctrl_2.Cmd.Move_Absolute := FALSE;
			old_pos_2 := 0;
			//Status := STOP;
			CMD_home_status_2 := 0;
		
		21:
			XSM_Ctrl_2.Cmd.Move_Absolute := FALSE;
			CMD_home_status_2 := 0;
		
	END_CASE
	
	CASE CMD_Reboot_pos_status_2 OF
		0: // idle
			IF (Status = AUTO OR Status = MANUAL) THEN CMD_Reboot_pos_status_2 := 1; END_IF;
			
		1:
			IF (glb_cmd_2.Reboot_pos) THEN CMD_Reboot_pos_status_2 := 2; END_IF;
			
		2: // idle auto
			XSM_Ctrl_2.Cmd.Position := Actual_Position_2;
			IF (XSM_Ctrl_2.PowerOn AND Homed_2) THEN 
				CMD_Reboot_pos_status_2 := 10; 
				glb_cmd_2.Reboot_pos := 0; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status_2 := 20; END_IF;
		10:
			XSM_Ctrl_2.Cmd.Move_Absolute := TRUE;
			IF (XSM_Ctrl_2.Monitor.Actual_Position = Actual_Position_2) THEN 
				old_pos_2 := XSM_Ctrl_2.Monitor.Actual_Position;
				CMD_Reboot_pos_status_2 := 20; 
			END_IF;
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status_2 := 20; END_IF;
		20:
			XSM_Ctrl_2.Cmd.Move_Absolute := FALSE;
			CMD_Reboot_pos_status_2 := 0;
		
	END_CASE
	
	posizione_salvata_2 := XSM_Ctrl_2.Monitor.Actual_Position;
	
	
END_PROGRAM

PROGRAM _EXIT


(* TODO : Add your code here *)


END_PROGRAM

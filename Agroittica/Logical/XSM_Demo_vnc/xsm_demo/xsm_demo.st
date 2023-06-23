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
	
	IF (posizione_salvata <> 0) THEN Actual_Position_0 := posizione_salvata; END_IF

	(* Set up XSM Control parameters. *)
	XSM_Ctrl_0.IO_Mapping.DeviceName := 'IF6.ST2';					(* Location of SM module on X20 CPU. *)
	XSM_Ctrl_0.IO_Mapping.Channel := 1;								(* Channel number, motor 1 on the module. *)

	XSM_Ctrl_0.Parameters.Units_rev := 700;							(* User scaling, units per rev. *)
	XSM_Ctrl_0.Parameters.PosSWLimit := 19000;						(* Units based on user scaling, change to suit application. *)
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

	XSM_IO_Cfg_0.IO_Cfg.Current.Holding := 0.20;						(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_0.IO_Cfg.Current.Rated := 0.80;							(* A, Change to suit motor/application. *)
	XSM_IO_Cfg_0.IO_Cfg.Current.Maximum := 1.50;						(* A, Change to suit motor/application. *)

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
	
	
	
	XSM_Ctrl_0(); (* Call function. *)
	XSM_IO_Cfg_0(); (* Call function. *)
	XSM_AcyclicRead_0(); (* Call function. *)
	
	XSM_Ctrl_0.Cmd.Reset := glb_hmi.Out.Reset;

	glb_err.Drive1 := XSM_Ctrl_0.Error;
	
	
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
	
	
	
		
	CASE Homing_status OF
		
		0: 
			IF (((glb_cmd.btn_homing AND Status = MANUAL) OR ((NOT Homed) AND Status = AUTO)) AND XSM_Ctrl_0.PowerOn) THEN
				Homing_status := 1; 
				glb_cmd.btn_homing := 0;
			END_IF
		
		1:
			XSM_Ctrl_0.Cmd.Velocity := -200;
			Homing_status := 10;
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Parameters.Ignore_SWLimits := TRUE;	
			XSM_Ctrl_0.Parameters.Ignore_HWLimits := TRUE;
				
		10:
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			Homing_status := 20;
		20:
			IF (XSM_Ctrl_0.IO_Mapping.InputStatus = 1) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				XSM_Ctrl_0.Cmd.Velocity := 200;
				Homing_status := 30;
			END_IF
		30:
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Move_Velocity := TRUE;
			Homing_status := 40;
		40:
			IF (NOT (XSM_Ctrl_0.IO_Mapping.InputStatus = 1)) THEN
				XSM_Ctrl_0.Cmd.Stop := TRUE;
				Homing_status := 50;
			END_IF
			
		50: 
			XSM_Ctrl_0.Cmd.Stop := FALSE;
			XSM_Ctrl_0.Cmd.Home := TRUE;
			IF XSM_Ctrl_0.IO_Mapping.AbsPos = 0 THEN 
				XSM_Ctrl_0.Cmd.Home := FALSE;
				XSM_Ctrl_0.Cmd.Move_Velocity := FALSE;
				XSM_Ctrl_0.Parameters.Ignore_SWLimits := FALSE;	
				XSM_Ctrl_0.Parameters.Ignore_HWLimits := FALSE;
				Homed := 1;
				Homing_status := 0;
			END_IF	
	END_CASE;  
	
	
	CASE FW_step_status OF
		
		0: // idle
			IF (Status = AUTO) THEN FW_step_status := 1; END_IF
			
		1: // idle auto
			XSM_Ctrl_0.Cmd.Distance := Dim_etichetta;
			IF (glb_cmd.sparo AND XSM_Ctrl_0.PowerOn AND Homed) THEN FW_step_status := 10; glb_cmd.sparo := 0; END_IF
			
			IF (Status <> AUTO) THEN FW_step_status := 20; END_IF
			
		10: // 
			XSM_Ctrl_0.Cmd.Move_Additive := TRUE;
			IF (XSM_Ctrl_0.Monitor.Actual_Position = (old_pos + Dim_etichetta)) THEN
				old_pos := XSM_Ctrl_0.Monitor.Actual_Position;
				FW_step_status := 20;
			END_IF
			
			IF (Status <> AUTO) THEN FW_step_status := 20; END_IF
		20:
			XSM_Ctrl_0.Cmd.Move_Additive := FALSE;
			FW_step_status := 0;
		  
	END_CASE;
	
	CASE CMD_home_status OF
		0: // idle
			IF (Status = AUTO) THEN CMD_home_status := 1; END_IF
			
		1: // idle auto
			XSM_Ctrl_0.Cmd.Position := 0;
			IF (glb_cmd.Torna_a_casa AND XSM_Ctrl_0.PowerOn AND Homed) THEN 
				CMD_home_status := 10; 
				glb_cmd.Torna_a_casa := 0; 
			END_IF
			
			IF (Status <> AUTO) THEN CMD_home_status := 20; END_IF
		10:
			XSM_Ctrl_0.Cmd.Move_Absolute := TRUE;
			IF (XSM_Ctrl_0.Monitor.Actual_Position = 0) THEN CMD_home_status := 20; END_IF
			
			IF (Status <> AUTO) THEN CMD_home_status := 20; END_IF
		20:
			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
			CMD_home_status := 0;
		
	END_CASE
	
	CASE CMD_Reboot_pos_status OF
		0: // idle
			IF (Status = AUTO OR Status = MANUAL) THEN CMD_Reboot_pos_status := 1; END_IF
			
		1:
			IF (glb_cmd.Reboot_pos) THEN CMD_Reboot_pos_status := 2; END_IF
			
		2: // idle auto
			XSM_Ctrl_0.Cmd.Position := Actual_Position_0;
			IF (XSM_Ctrl_0.PowerOn AND Homed) THEN 
				CMD_Reboot_pos_status := 10; 
				glb_cmd.Reboot_pos := 0; 
			END_IF
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status := 20; END_IF
		10:
			XSM_Ctrl_0.Cmd.Move_Absolute := TRUE;
			IF (XSM_Ctrl_0.Monitor.Actual_Position = 0) THEN CMD_Reboot_pos_status := 20; END_IF
			
			IF (Status <> AUTO AND Status <> MANUAL) THEN CMD_Reboot_pos_status := 20; END_IF
		20:
			XSM_Ctrl_0.Cmd.Move_Absolute := FALSE;
			CMD_Reboot_pos_status := 0;
		
	END_CASE
	
	posizione_salvata := XSM_Ctrl_0.Monitor.Actual_Position;
	 


END_PROGRAM

PROGRAM _EXIT


(* TODO : Add your code here *)


END_PROGRAM

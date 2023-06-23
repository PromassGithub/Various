FUNCTION_BLOCK XSM_Ctrl
	(* Implementation of XSM_Ctrl *)
	(********************************************************************************************************************
		Filename		: XSM_Ctrl.scr
		Version			: 00.05
		Date				: 16th November 2011
		Written by	: Andy Lees at B&R Industrial Automation Ltd. (UK)
		Customer		: Sheepy.
		Application : .
		Description	:	Control the stepper motor modules in ramp control mode, simple control.
		
									Status from this function:-
	
										0				ERR_OK
										
										50100		XSM_ModuleNotOK
										50101		XSM_ModuleID_Invalid -	X20 ->	X20SM1426 = 9857,						1x Stepper motor module 1A, 4 DI 
																														X20SM1436 = 9858,						1x Stepper motor module 3A, 4 DI
	
																										X67 ->	X67SM2436 = 7627,						2x Stepper motor module 3A, 2x3 DI
																														X67SM4320 = 7628,						4x Stepper motor module 1A
																														
																						ACOPOSmicro ->	80SD100XD.C0XX-01 = 42148,	2x Stepper motor 10 A, X2X, 2 Trigger Inputs. 
																														80SD100XS.C0XX-01 = 42414,	1x Stepper motor 10 A, X2X, 2 DI (1 Trigger Input).
																														80SD100XS.C04X-01 = 42880,	1x Stepper motor 10 A, X2X, 2 DI (1 Trigger Input), 1x ABR.
																														80SD100XD.C044-01 = 42881,	2x Stepper motor 10 A, X2X, 2x ABR, 2 Trigger Inputs.
																														80SD100XS.C04X-13 = 42882,	1x Stepper motor 10 A, X2X, 1x ABR, 4 DI/2 DO
																														80SD100XD.C04X-13 = 42893,	2x Stepper motor 10 A, X2X, 1x ABR, 4 DI/2 DO.
																														80SD100XD.C0XX-21 = 42894,	2x Stepper motor 10 A, X2X, 2 Inputs ±10 V.
	
										50102		XSM_Warning
										50103		XSM_Fault
										50104		Both_HW_LimitSwitch_Active
										50105		Pos_SW_Limit_Invalid
										50106		Neg_SW_Limit_Invalid
										50107		CyclicTime_Invalid
										50108		Units_rev_Invalid.
										50109		XSM_Motor_Invalid.
										
										50110		IO_Configuration (Possible rated current = 0?)
										50111		Pos_HW_LimitSwitch_Active
										50112		Neg_HW_LimitSwitch_Active
										50113		Target_Exceeds_Pos_SW_Limit
										50114		Target_Exceeds_Neg_SW_Limit
										50115		Pos_SW_Limit_Exceeded
										50116		Neg_SW_Limit_Exceeded
										50117		Not Homed, Move not allowed.
										
										50120		IO Mapping output MpGenControl being over written.
										50121		IO Mapping output MpGenControl not linked correctly to module.
										50122		IO Mapping output MpGenMode being over written.
										
										50150		Error code 16#2300 : Warning - Over current.
										50151		Error code 16#3000 : Error - Voltage.
										50152		Error code 16#3100 : Error - Module supply voltage.
										50153		Error code 16#3210 : Error - Over voltage on DC Bus.
										50154		Error code 16#3220 : Error - Under voltage on DC bus.
										50155		Error code 16#4200 : Error - Over temperature.
										50156		Error code 16#FF00 : Warning - Under current (if under current detection is activated).
										50157		Error code 16#FF01 : Warning - Stall (if stall detection is activated).
										50158		Error code 16#FF02 : Error - Drive not enabled (enable input = 0).
										50159		Error code 16#FF02 : Warning - Encoder supply voltage.
										
																				
									intern.StateMan - State Machine
	
										0			Init.
										
										10		Wait FOR Switch on disabled.
										20		Power on module sequence - Wait for ready to switch on.
										30		Power on module sequence - Wait for switch on.
										40		Power on module sequence - Wait for operation enabled.
	
										100		XSM Operation enabled, wait for command request.
	
										200		Homing sequence - Waiting for non-standstill state.
										201		Homing sequence.
										202		Homing sequence - Waiting for non-standstill state.
										203		Homing sequence, Set actual position.
	
										300		Absolute move command request - Waiting for non-standstill state.
										301		Absolute move command request.
	
										400		Additive move command request - Waiting for non-standstill state.
										401		Additive move command request.
	
										500		Velocity speed command request.
	
										600		Stop move at set deceleration values.
	
										700		Two position mode, Move to FixedPos_a & b command request - Waiting for non-standstill state.
										701		Two position mode, Move to FixedPos_a & b command request.
	
										1000	Error handling - Check for XSM_Warning or XSM_Fault.
										1001	Error handling - Get error code from module.
										1002	Error handling - Decode error code.

										1010	Error handling - Check reset flag is OFF.
										1011	Error handling - Reset error on positve edge.
										1012	Error handling - Reset all state machine errors?
										
										ELSE	Should not get here, invalid state. Goto 1000
	
		History			: 16th November 2011	v00.05
									Corrected falsely reported error 50120 if stall detection or under current options are enabled.
									Improved error flag handling.
								: 27th May 2011				v00.04
									Increase the DeviceName STRING[20] to STRING[80] characters.
								: 24th July 2009			v00.03
									Merged XSM_GetErrorCode into this function to read automatically and generate required status.
								: 10th March 2009			v00.02
									Added ACOPOSmicro 80SD100XD.C0XX-01 module ID 42148.
								: 13th January 2009		v00.01
									First release - Tested on X20CP1486 N2.95 with X20SM1426 on X2X & Ethernet Power Link.
									
	*********************************************************************************************************************)
	
	(********************************************************************************************************************
		Update a XSM status.
	*********************************************************************************************************************)
	intern.XSM_StateMachine.NotReadyToSwitchOn					:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_STOP)		- XSM_RD_SM_NOT_READY_TO_SWITCH_ON));
	intern.XSM_StateMachine.SwitchOnDisabled					:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_STOP)		- XSM_RD_SM_SWITCH_ON_DISABLED));
	intern.XSM_StateMachine.ReadyToSwitchOn						:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_ACTIVE)	- XSM_RD_SM_READY_TO_SWITCH_ON));
	intern.XSM_StateMachine.SwitchedOn							:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_ACTIVE)	- XSM_RD_SM_SWITCHED_ON));
	intern.XSM_StateMachine.OperationEnabled					:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_ACTIVE)	- XSM_RD_SM_OPERATION_ENABLED));
	intern.XSM_StateMachine.QuickStopActive						:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_ACTIVE)	- XSM_RD_SM_QUICK_STOP_ACTIVE));
	intern.XSM_StateMachine.FaultReactionActive					:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_STOP)		- XSM_RD_SM_FAULT_REACTION_ACTIVE));
	intern.XSM_StateMachine.Fault								:= NOT(UINT_TO_BOOL((IO_Mapping.MpGenStatus AND XSM_RD_STATE_MACHINE_MASK_STOP)		- XSM_RD_SM_FAULT));
	
	IF NOT(Enable) THEN
		Active := FALSE;
		RETURN;
	ELSE
		IF intern.XSM_StateMachine.Fault THEN
			intern.AutoReset    := TRUE;
		END_IF;
	END_IF;
	Active := Enable AND NOT(intern.AutoReset);
	
	PowerOn									:= intern.XSM_StateMachine.OperationEnabled;																									(* Get opertion enabled status. *)
	Monitor.Target_Reached	:= BIT_TST(IO_Mapping.MpGenStatus, 10);																												(* Get in position/target reached status. *)
	
	(********************************************************************************************************************
		Check for errors.
				50100		XSM_ModuleNotOK
				50101		XSM_ModuleID_Invalid.
				50102		XSM_Warning
				50103		XSM_Fault
				50104		Both_HW_LimitSwitch_Active
				50105		Pos_SW_Limit_Invalid
				50106		Neg_SW_Limit_Invalid
				50107		CyclicTime_Invalid
				50108		Units_rev_Invalid.
				50109		XSM_Motor_Invalid.
	
				50150		Error code - 16#3000,	XSM_Error_Voltage 										
				50151		Error code - 16#4200,	XSM_Error_OverTemperature 						
				50152		Error code - 16#2300,	XSM_Warning_Over_Current 						
				50153		Error code - 16#FF00,	XSM_Warning_Under_Current 						
				50154		Error code - 16#FF01,	XSM_Warning_Stall
				50155		Invalid Error Code value.
	*********************************************************************************************************************)
	IF NOT(IO_Mapping.ModuleOK) THEN																																											(* XSM Module NOT OK? *)
		Status := 50100;																																																		(* Error - XSM_ModuleNotOK. *)
	
	ELSIF ((IO_Mapping.ModuleID <> 9857) AND (IO_Mapping.ModuleID <> 9858) AND																						(* Not X20SM1426, X20SM1436? *)
				 (IO_Mapping.ModuleID <> 7627) AND (IO_Mapping.ModuleID <> 7628) AND																						(* Not X67SM2436, X67SM4320? *)
				 (IO_Mapping.ModuleID <> 42148) AND (IO_Mapping.ModuleID <> 42414) AND																					(* Not 80SD100XD.C0XX-01, 80SD100XS.C0XX-01? *)
				 (IO_Mapping.ModuleID <> 42880) AND (IO_Mapping.ModuleID <> 42881) AND																					(* Not 80SD100XS.C04X-01, 80SD100XD.C044-01? *)
				 (IO_Mapping.ModuleID <> 42882) AND (IO_Mapping.ModuleID <> 42893) AND																					(* Not 80SD100XS.C04X-13, 80SD100XD.C04X-13? *)
				 (IO_Mapping.ModuleID <> 42894)) THEN																																						(* Not 80SD100XD.C0XX-21? *)							
		Status := 50101;																																																		(* Error - XSM_ModuleID_Invalid *)
	
//	ELSIF (BIT_TST(IO_Mapping.MpGenStatus, 7) AND (intern.StateMan < 1000)) THEN																					(* XSM Warning and not in error handling state already? *)
//		Status := 50102;																																																		(* Error - XSM_Warning. *)
	
	ELSIF ((intern.XSM_StateMachine.Fault) AND (intern.StateMan < 1000)) THEN																							(* XSM State machine faultand not in error handling state already? *)
		Status := 50103;																																																		(* Error - XSM_Fault. *)
	
	ELSIF (NOT(Parameters.Ignore_HWLimits) AND Monitor.Input_1 AND Monitor.Input_2) THEN																	(* Both limit switch active? *)
		Status := 50104;																																																		(* Error - Both_HW_LimitSwitch_Active. *)
	
	ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Parameters.PosSWLimit <= Parameters.NegSWLimit)) THEN											(* Positive SW limit not valid? *)
		Status := 50105;																																																		(* Error - Pos_SW_Limit_Invalid. *)
	
	ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Parameters.NegSWLimit >= Parameters.PosSWLimit)) THEN											(* Negative SW limit not valid? *)
		Status := 50106;																																																		(* Error - Neg_SW_Limit_Invalid. *)
	
	ELSIF (RTInfo_0.cycle_time = 0) THEN																																									(* Cyclic time not valid? *)
		RTInfo_0(enable := 1);																																															(* Call function. *)
		IF (RTInfo_0.status <> ERR_FUB_BUSY) THEN																																						(* Not busy? *)
			IF (RTInfo_0.status = ERR_OK) THEN																																								(* No Error? *)
				intern.TaskCyclicTime:= UDINT_TO_REAL(RTInfo_0.cycle_time) / 1000000;																						(* Convert micro seconds to seconds. *)
			ELSE																																																							(* Error? *)
				Status := 50107;																																																(* CyclicTime_Invalid. *)
			END_IF
		END_IF
	
	ELSIF ((Parameters.Units_rev <= 0) OR (Parameters.Units_rev > 51200)) THEN																						(* Units per rev invalid? *)
		Status := 50108;																																																		(* Units_rev_Invalid. *)
	
	ELSIF (((IO_Mapping.ModuleID = 9857) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 1))) OR										(* X20SM1426 - Only 1 motor possible. *)
			 ((IO_Mapping.ModuleID = 9858) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 1))) OR											(* X20SM1436 - Only 1 motor possible. *)
			 ((IO_Mapping.ModuleID = 7627) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 2))) OR											(* X67SM2436 - Only 2 motor possible. *)
			 ((IO_Mapping.ModuleID = 7628) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 4)))	OR										(* X67SM4320 - Only 4 motor possible. *)
			 ((IO_Mapping.ModuleID = 42148) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 2))) OR										(* 80SD100XD.C0XX-01 - Only 2 motor possible. *)
			 ((IO_Mapping.ModuleID = 42414) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 1))) OR										(* 80SD100XS.C0XX-01 - Only 1 motor possible. *)
			 ((IO_Mapping.ModuleID = 42880) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 1))) OR										(* 80SD100XS.C04X-01 - Only 1 motor possible. *)
			 ((IO_Mapping.ModuleID = 42881) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 2))) OR										(* 80SD100XD.C044-01 - Only 2 motor possible. *)
			 ((IO_Mapping.ModuleID = 42882) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 1))) OR										(* 80SD100XS.C04X-13 - Only 1 motor possible. *)
			 ((IO_Mapping.ModuleID = 42893) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 2))) OR										(* 80SD100XD.C04X-13 - Only 2 motor possible. *)
			 ((IO_Mapping.ModuleID = 42894) AND ((IO_Mapping.Channel < 0) OR (IO_Mapping.Channel > 2)))												(* 80SD100XD.C0XX-21 - Only 2 motor possible. *)
			) THEN																																																						(* Selected motor invalid? *)
		Status := 50109;																																																		(* XSM_Motor_Invalid? *)
	
	END_IF
	
	(********************************************************************************************************************
		Get input status from XSM module.
	*********************************************************************************************************************)
	IF ((IO_Mapping.ModuleID = 7627) AND (IO_Mapping.Channel <= 1)) THEN																									(* X67M2436 Module motor 1? *)
		Monitor.Input_1	:= BIT_TST(IO_Mapping.InputStatus, 0);																															(* Input 1 or negative limit status. *)
		Monitor.Input_2	:= BIT_TST(IO_Mapping.InputStatus, 1);																															(* Input 2 or positive limit status. *)
		Monitor.Input_3	:= BIT_TST(IO_Mapping.InputStatus, 2);																															(* Input 3 or reference status. *)
	
	ELSIF ((IO_Mapping.ModuleID = 7627) AND (IO_Mapping.Channel = 2)) THEN																								(* X67M2436 Module motor 2? *)
		Monitor.Input_1	:= BIT_TST(IO_Mapping.InputStatus, 3);																															(* Input 1 or negative limit status. *)
		Monitor.Input_2	:= BIT_TST(IO_Mapping.InputStatus, 4);																															(* Input 2 or positive limit status. *)
		Monitor.Input_3	:= BIT_TST(IO_Mapping.InputStatus, 5);																															(* Input 3 or reference status. *)
	
	ELSIF ((IO_Mapping.ModuleID = 9857) OR (IO_Mapping.ModuleID = 9858) OR (IO_Mapping.ModuleID = 42882)) THEN						(* X20SM module or ACOPOSmicro - 80SD100XS.C04X-13? *)
		Monitor.Input_1	:= BIT_TST(IO_Mapping.InputStatus, 0);																															(* Input 1 or negative limit status. *)
		Monitor.Input_2	:= BIT_TST(IO_Mapping.InputStatus, 1);																															(* Input 2 or positive limit status. *)
		Monitor.Input_3	:= BIT_TST(IO_Mapping.InputStatus, 2);																															(* Input 3 or reference status. *)
		Monitor.Input_4	:= BIT_TST(IO_Mapping.InputStatus, 3);																															(* Input 4 or trigger status. *)
	
	ELSIF ((IO_Mapping.ModuleID = 42148) OR (IO_Mapping.ModuleID = 42414) OR (IO_Mapping.ModuleID = 42880) OR							(* ACOPOSmicro - 80SD100XD.C0XX-01 or 80SD100XS.C0XX-01 or 80SD100XS.C04X-01-01? *)
				 (IO_Mapping.ModuleID = 42893) OR (IO_Mapping.ModuleID = 42881) (*OR (IO_Mapping.ModuleID = 42894) *)) THEN			(* ACOPOSmicro - 80SD100XD.C04X-13 or 80SD100XD.C044-01 or 80SD100XD.C0XX-21? *)
		Monitor.Input_1	:= BIT_TST(IO_Mapping.InputStatus, 0);																															(* Input 1 or trigger status. *)
		Monitor.Input_2	:= BIT_TST(IO_Mapping.InputStatus, 1);																															(* Input 2 or trigger status. *)
	
	END_IF
	
	IF (Parameters.HWLimits_Active_Low) THEN																																							(* Invert limits switches (Active low)? *)
		Monitor.Input_1	:= NOT(Monitor.Input_1);																																						(* Invert input 1 or negative limit status. *)
		Monitor.Input_2	:= NOT(Monitor.Input_2);																																						(* Invert input 1 or negative limit status. *)
	END_IF
	
	(********************************************************************************************************************
		Workout actual speed and set stand still state if in operational state.
		Position updated every 25ms from module.
	*********************************************************************************************************************)
	IF (intern.XSM_StateMachine.OperationEnabled) THEN																																			(* Ready for operation. *)
	
		intern.CyclicCounter := intern.CyclicCounter + intern.TaskCyclicTime;																									(* Increament cyclic counter by cyclic time. *)

		IF ((intern.OldAbsPosActVal <> IO_Mapping.AbsPosActVal) OR
			 ((intern.CyclicCounter >= 0.025) AND (intern.CyclicCounter >= intern.TaskCyclicTime))) THEN												(* New value or task cyclic time >25ms and passed? *)
	
			IF (intern.TaskCyclicTime <= 0.025) THEN																																						(* Task cyclic time <=25ms? *)
				Monitor.Actual_Velocity := (IO_Mapping.AbsPosActVal - intern.OldAbsPosActVal);																		(* Workout actual velocity uSteps/25ms . *)
			ELSE																																																								(* Task cyclic time >25ms? *)
				Monitor.Actual_Velocity := (IO_Mapping.AbsPosActVal - intern.OldAbsPosActVal) / REAL_TO_UINT(floor(intern.TaskCyclicTime/0.025));	(* Workout actual velocity uSteps/25ms to last whole 25ms. *)
			END_IF
			
			IF (Monitor.Actual_Velocity = 0) THEN																																								(* Stand still? *)
				Monitor.StandStill		:= 1;																																												(* Standstill status. *)
			ELSE																																																								(* Moving? *)
				Monitor.StandStill		:= 0;																																												(* Standstill status. *)
				Monitor.Actual_Velocity := REAL_TO_DINT((Monitor.Actual_Velocity * 40.0)/51200 * UINT_TO_REAL(Parameters.Units_rev));	(* Scale from uSteps/25ms to units/s. *)
			END_IF
	
			IF (Monitor.Actual_Velocity < 150) THEN
				Monitor.Actual_Velocity:= Monitor.Actual_Velocity;
			END_IF

			intern.OldAbsPosActVal	:= IO_Mapping.AbsPosActVal;																																	(* Update old actual position. *)
			intern.CyclicCounter 		:= 0.0;																																											(* Cyclic counter. *)

		END_IF

	ELSE																																																										(* Module not ready for operation? *)
		Monitor.Actual_Velocity:= 0;																																													(* Force speed to zero? *)
	END_IF
	
	(*Actual_Position	:= IO_Mapping.AbsPosActVal; 																																					(* Actual position with no scaling. *)
	Monitor.Actual_Position := REAL_TO_DINT((DINT_TO_REAL(IO_Mapping.AbsPosActVal)/51200.0) * UINT_TO_REAL(Parameters.Units_rev));	(* Scale from uSteps to units. *)
	
	(********************************************************************************************************************
		Command latch flags to produce + edge.
	*********************************************************************************************************************)
	intern.CmdHome			 									:= (intern.CmdHome AND Cmd.Home);																								(* Reset command latch flag. *)
	intern.CmdReset			 									:= (intern.CmdReset AND Cmd.Reset);																							(* Reset command latch flag. *)
	intern.CmdMove_Absolute 							:= (intern.CmdMove_Absolute AND Cmd.Move_Absolute);															(* Reset command latch flag. *)
	intern.CmdMove_Additive 							:= (intern.CmdMove_Additive AND Cmd.Move_Additive);															(* Reset command latch flag. *)
	intern.CmdMove_Velocity 							:= (intern.CmdMove_Velocity AND Cmd.Move_Velocity);															(* Reset command latch flag. *)
	intern.CmdMove_Adv_Two_Position_Mode	:= (intern.CmdMove_Adv_Two_Position_Mode AND Cmd.Advanced.Two_Position_Mode);		(* Reset command latch flag. *)
	intern.CmdMove_Adv_FixedPos_a					:= (intern.CmdMove_Adv_FixedPos_a AND Cmd.Advanced.Move_FixedPos_a);						(* Reset command latch flag. *)
	intern.CmdMove_Adv_FixedPos_b					:= (intern.CmdMove_Adv_FixedPos_b AND Cmd.Advanced.Move_FixedPos_b);						(* Reset command latch flag. *)
	
	(********************************************************************************************************************
		XSM Errors force stop and handle errors?
	*********************************************************************************************************************)
	IF ((Status <> 0) AND (intern.StateMan < 1000)) THEN																																	(* Error and not error handling state's? *)
		IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																																	(* Set XSM Control Word for internal state machine. *)
		IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																						(* Set XSM control mode. *)
		intern.StateMan := 1000;																																														(* Check for standstill and then Handle errors. *)
	ELSIF (Status = 0) THEN																																																(* No errors?  *)
		Error	:= 0; 																																																				(* Reset Error flag. *)
	END_IF
	
	(********************************************************************************************************************
		XSM Control state machine.
	*********************************************************************************************************************)
	CASE (intern.StateMan) OF
	
		(* Init. Get actual task class time that this function is been called in. *)
		0:
			IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																																(* Set XSM Control Word for internal state machine. *)
			IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																					(* Set XSM control mode. *)

			IF (((intern.XSM_StateMachine.NotReadyToSwitchOn) OR (intern.XSM_StateMachine.SwitchOnDisabled)) AND (Power)) THEN	(* XSM Module ready to power up & Request to power on? *)
	 			intern.StateMan := 10;
			END_IF
			
		(* Wait for Switch on disabled.  *)
		10:
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (intern.XSM_StateMachine.SwitchOnDisabled) THEN																															(* XSM Module ready to power up & Request to power on? *)
				IO_Mapping.MpGenControl := XSM_CW_SHUTDOWN;																																			(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.CyclicCounter		:= 0.0;																																									(* Cyclic counter. *)
				intern.StateMan := 20;
			END_IF
	
		(* Power on module sequence - Wait for ready to switch on.  *)
		20:
			intern.CyclicCounter := intern.CyclicCounter + intern.TaskCyclicTime;																							(* Increament cyclic counter by cyclic time. *)

			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF ((IO_Mapping.MpGenControl AND 16#00FF) <> XSM_CW_SHUTDOWN) THEN																							(* IO Mapping output MpGenControl bit 0-7 being over written? *)
				Status := 50120;																																																(* Error - IO Mapping output MpGenControl being over written. *)
			ELSIF (intern.XSM_StateMachine.ReadyToSwitchOn) THEN																															(* XSM Ready to be switched on? *)
				IO_Mapping.MpGenControl := XSM_CW_SWITCH_ON;																																		(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.CyclicCounter		:= 0.0;																																									(* Cyclic counter. *)
				intern.StateMan := 30;
			ELSIF (intern.CyclicCounter > 2.0) THEN																																						(* 2s error time?  *)
				Status := 50121;																																																(* Error - IO Mapping output MpGenControl not linked correctly to module. *)
			END_IF

		(* Power on module sequence - Wait for switch on. *)
		30:
			intern.CyclicCounter := intern.CyclicCounter + intern.TaskCyclicTime;																							(* Increament cyclic counter by cyclic time. *)

			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (intern.XSM_StateMachine.SwitchedOn) THEN																																		(* XSM switch on? *)
				IO_Mapping.MpGenControl := XSM_CW_ENABLE_OPERATION;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 40;
			ELSIF (intern.CyclicCounter > 2.0) THEN																																						(* 2s error time?  *)
				Status := 50110;																																																(* Error - IO_Configuration (Posible rated current = 0?) *)
			END_IF
	
		(* Power on module sequence - Wait for operation enabled.  *)
		40:
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (intern.XSM_StateMachine.OperationEnabled) THEN																															(* XSM operation enabled? *)
				intern.StateMan := 100;
			END_IF
	
		(* XSM Operation enabled, wait for command request. *)
		100:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			(* Stop *)
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			(* Home *)
			ELSIF ((Cmd.Home) AND NOT(intern.CmdHome)) THEN																																		(* Start homing, + edge? *)
	
				intern.CmdHome 	:= 1;																																														(* Set command latch flag. *)
	
				Cmd.Home				:= 0;																																														(* Reset start homing command request. *)
				Monitor.Home_OK	:= 0;																																														(* Set homed flag. *)
				intern.StateMan := 200;
	
			ELSIF (
							(((Cmd.Move_Absolute) AND NOT(intern.CmdMove_Absolute)) OR																								(* Start absolute when not homed? *)
						  ((Cmd.Move_Additive) AND NOT(intern.CmdMove_Additive)) OR																									(* Start additive when not homed? *)
						  ((Cmd.Advanced.Two_Position_Mode) AND NOT(intern.CmdMove_Adv_Two_Position_Mode)) OR												(* Start two position mode when not homed? *)
						  ((Cmd.Advanced.Move_FixedPos_a) AND NOT(intern.CmdMove_Adv_FixedPos_a)) OR																(* Start move to fixed position a when not homed? *)
						  ((Cmd.Advanced.Move_FixedPos_b) AND NOT(intern.CmdMove_Adv_FixedPos_b))) AND															(* Start move to fixed position b when not homed? *)
						  NOT(Monitor.Home_OK)
						 ) THEN
	
				intern.CmdMove_Absolute 							:= Cmd.Move_Absolute;																											(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Additive								:= Cmd.Move_Additive;																											(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Adv_Two_Position_Mode	:= Cmd.Advanced.Two_Position_Mode;																				(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Adv_FixedPos_a 				:= Cmd.Advanced.Move_FixedPos_a;																					(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Adv_FixedPos_b 				:= Cmd.Advanced.Move_FixedPos_b;																					(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Adv_Target_Mode				:= Cmd.Advanced.Target_Mode;																							(* Set internal flag to force positive edge of cmd. *)
				Status := 50117;																																																(* Not Homed, Move not allowed. *)
	
			(* Absolute move. *)
			ELSIF ((Cmd.Move_Absolute) AND NOT(intern.CmdMove_Absolute)) THEN																									(* Start absolute move, + edge? *)
	
				intern.CmdMove_Absolute := 1;																																										(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND ((Monitor.Input_2) AND (Cmd.Position > Monitor.Actual_Position))) THEN	(* Moving further in to limit?  *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND ((Monitor.Input_1) AND (Cmd.Position < Monitor.Actual_Position))) THEN	(* Moving further in to limit?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position > Parameters.PosSWLimit) AND (Cmd.Position > Monitor.Actual_Position)) THEN	(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position < Parameters.NegSWLimit) AND (Cmd.Position < Monitor.Actual_Position)) THEN	(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSIF (Cmd.Position <> Monitor.Actual_Position) THEN																														(* Start move if valid? *)
	
					intern.AbsPos := ((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Cmd.Position));										(* Scale from units to uSteps. *)
	
					IF ((intern.AbsPos > 2147483647.0) OR (intern.AbsPos < -2147483648.0) OR																			(* Overflow? *)
							((Cmd.Position > 0) AND (intern.AbsPos < 0)) OR																														(* Positive overflow? *)
							((Cmd.Position < 0) AND (intern.AbsPos > 0))) THEN																												(* Negative overflow? *)
	
						intern.OverflowWarning := intern.StateMan;																																	(* Recorded which step where overflow occured. *)
	
						IF (Cmd.Position > 0) THEN																																									(* Positive overflow? *)
							intern.AbsPos := 2147483647.0;																																						(* Set to maximum. *)
						ELSIF (Cmd.Position < 0) THEN																																								(* Negitive overflow? *)
							intern.AbsPos := -2147483648.0;																																						(* Set to maximum. *)
						END_IF
	
					END_IF
	
					IO_Mapping.AbsPos 		:= REAL_TO_UDINT(intern.AbsPos);																												(* Copy required write value. *)
					IO_Mapping.MpGenMode	:= XSM_MODE_POSITION;																																		(* Set XSM control mode. *)
					intern.Target					:= Cmd.Position;																																				(* Update temp target. *)
					intern.StateMan := 300;
				END_IF
	
				Cmd.Move_Absolute	:= 0;																																													(* Reset move absolute command request. *)
	
			(* Additive move. *)
			ELSIF ((Cmd.Move_Additive) AND NOT(intern.CmdMove_Additive)) THEN																									(* Start additive(relative) move on + edge? *)
	
				intern.CmdMove_Additive := 1;																																										(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Distance > 0)) THEN													(* Moving further in to limit?  *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Distance < 0)) THEN												(* Moving further in to limit?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND ((Monitor.Actual_Position + Cmd.Distance) > Parameters.PosSWLimit) AND
							((Monitor.Actual_Position + Cmd.Distance) > Monitor.Actual_Position)) THEN																(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND ((Monitor.Actual_Position + Cmd.Distance) < Parameters.NegSWLimit) AND
							((Monitor.Actual_Position + Cmd.Distance) < Monitor.Actual_Position)) THEN																(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSIF (Cmd.Distance <> 0) THEN																																									(* Start move if valid? *)
					IO_Mapping.AbsPos			:= REAL_TO_DINT((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Monitor.Actual_Position + Cmd.Distance));	(* Scale from units to uSteps. *)
					IO_Mapping.MpGenMode	:= XSM_MODE_POSITION;																																		(* Set XSM control mode. *)
					intern.StateMan := 400;
				END_IF
	
				Cmd.Move_Additive	:= 0;																																													(* Reset move additive command request. *)
	
			(* Velocity move. *)
			ELSIF ((Cmd.Move_Velocity) AND NOT(intern.CmdMove_Velocity)) THEN																									(* Start velocity move on +edge? *)
	
				intern.CmdMove_Velocity := 1;																																										(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Velocity > 0)) THEN													(* Moving further in to limit?  *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Velocity < 0)) THEN												(* Moving further in to limit?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit) AND (Cmd.Velocity > 0)) THEN		(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit) AND (Cmd.Velocity < 0)) THEN		(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSIF (Cmd.Velocity <> 0) THEN																																									(* Start move if valid? *)
	
					intern.AbsPos := (51200/UINT_TO_REAL(Parameters.Units_rev)) * (DINT_TO_REAL(Cmd.Velocity)/40.0);							(* Scale from units/s to uSteps/25ms. *)
	
					IF ((intern.AbsPos > 65535.0) OR (intern.AbsPos < -65535.0) OR																								(* Overflow? *)
							((Cmd.Velocity > 0) AND (intern.AbsPos < 0)) OR																														(* Positive overflow? *)
							((Cmd.Velocity < 0) AND (intern.AbsPos > 0))) THEN																												(* Negative overflow? *)
	
						intern.OverflowWarning := intern.StateMan;																																	(* Recorded which step where overflow occured. *)
	
						IF (Cmd.Velocity  > 0) THEN																																									(* Positive overflow? *)
							intern.AbsPos := 65535;																																										(* Set to maximum. *)
						ELSIF (Cmd.Velocity  < 0) THEN																																							(* Negitive overflow? *)
							intern.AbsPos := -65535;																																									(* Set to maximum. *)
						END_IF
	
					END_IF
	
					IO_Mapping.AbsPos 		:= REAL_TO_UDINT(intern.AbsPos);																												(* Copy required write value. *)
					IO_Mapping.MpGenMode	:= XSM_MODE_SPEED;																																			(* Set XSM control mode. *)
					intern.Target					:= Cmd.Velocity;																																				(* Update temp target. *)
					intern.StateMan := 500;
				END_IF
	
				Cmd.Move_Velocity	:= 0;																																													(* Reset move velocity command request. *)
	
			(* Two position mode, Input low move to fixed position a, input hight move to fixed position b. *)
			(* Move to fixed position a. NOTE - Unless passing MpGen structure into this function can't determine if moving further into SW/HW limits. *)
			ELSIF ((Cmd.Advanced.Two_Position_Mode) AND NOT(intern.CmdMove_Adv_Two_Position_Mode)) THEN												(* Enable two position mode? *)
	
				intern.CmdMove_Adv_Two_Position_Mode := 1;																																			(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2)) THEN																									(* Positive HW limit active? *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1)) THEN																							(* Negative HW limit active?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit)) THEN							(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit)) THEN							(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSE																																																						(* Start move if valid? *)
					IO_Mapping.MpGenMode	:= XSM_MODE_TWO_POSITION;																																(* Set XSM control mode. *)
					intern.StateMan := 700;
				END_IF
	
			(* Move to fixed position a. NOTE - Unless passing MpGen structure into this function can't determine if moving further into SW/HW limits. *)
			ELSIF ((Cmd.Advanced.Move_FixedPos_a) AND NOT(intern.CmdMove_Adv_FixedPos_a)) THEN																(* Start move to fixed position b, + edge? *)
	
				intern.CmdMove_Adv_FixedPos_a := 1;																																							(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2)) THEN																									(* Positive HW limit active? *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1)) THEN																							(* Negative HW limit active?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit)) THEN							(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit)) THEN							(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSE																																																						(* Start move if valid? *)
					IO_Mapping.MpGenMode	:= XSM_MODE_MOVE_FIXED_A;																																(* Set XSM control mode. *)
	(*				intern.StateMan := 700;*)
				END_IF
	
			(* Move to fixed position b. NOTE - Unless passing MpGen structure into this function can't determine if moving further into SW/HW limits. *)
			ELSIF ((Cmd.Advanced.Move_FixedPos_b) AND NOT(intern.CmdMove_Adv_FixedPos_b)) THEN																(* Start move to fixed position b, + edge? *)
	
				intern.CmdMove_Adv_FixedPos_b := 1;																																							(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2)) THEN																									(* Positive HW limit active? *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1)) THEN																							(* Negative HW limit active?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit)) THEN							(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit)) THEN							(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSE																																																						(* Start move if valid? *)
					IO_Mapping.MpGenMode	:= XSM_MODE_MOVE_FIXED_B;																																(* Set XSM control mode. *)
	(*				intern.StateMan := 700;*)
	
				END_IF
	
			(* Move to target position if external input is set. *)
			ELSIF ((Cmd.Advanced.Target_Mode) AND NOT(intern.CmdMove_Adv_Target_Mode)) THEN																		(* Start absolute move, + edge? *)
	
				intern.CmdMove_Adv_Target_Mode := 1;																																						(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_HWLimits) AND ((Monitor.Input_2) AND (Cmd.Advanced.Target_Position > Monitor.Actual_Position))) THEN	(* Moving further in to limit?  *)
					Status := 50111;																																															(* Error - Pos_HW_LimitSwitch_Active *)
				ELSIF (NOT(Parameters.Ignore_HWLimits) AND ((Monitor.Input_1) AND (Cmd.Advanced.Target_Position < Monitor.Actual_Position))) THEN	(* Moving further in to limit?  *)
					Status := 50112;																																															(* Error - Neg_HW_LimitSwitch_Active *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position > Parameters.PosSWLimit) AND (Cmd.Advanced.Target_Position > Monitor.Actual_Position)) THEN	(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
	
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position < Parameters.NegSWLimit) AND (Cmd.Advanced.Target_Position < Monitor.Actual_Position)) THEN	(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
	
				ELSE																																																						(* Start move if valid? *)
	
					intern.AbsPos := ((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Cmd.Advanced.Target_Position));		(* Scale from units to uSteps. *)
	
					IF ((intern.AbsPos > 2147483647.0) OR (intern.AbsPos < -2147483648.0) OR																			(* Overflow? *)
							((Cmd.Position > 0) AND (intern.AbsPos < 0)) OR																														(* Positive overflow? *)
							((Cmd.Position < 0) AND (intern.AbsPos > 0))) THEN																												(* Negative overflow? *)
	
						intern.OverflowWarning := intern.StateMan;																																	(* Recorded which step where overflow occured. *)
	
						IF (Cmd.Position > 0) THEN																																									(* Positive overflow? *)
							intern.AbsPos := 2147483647.0;																																						(* Set to maximum. *)
						ELSIF (Cmd.Position < 0) THEN																																								(* Negitive overflow? *)
							intern.AbsPos := -2147483648.0;																																						(* Set to maximum. *)
						END_IF
	
					END_IF
	
					IO_Mapping.AbsPos 		:= REAL_TO_UDINT(intern.AbsPos);																												(* Copy required write value. *)
					IO_Mapping.MpGenMode	:= XSM_MODE_TARGET;																																			(* Set XSM control mode. *)
					intern.Target					:= Cmd.Advanced.Target_Position;																												(* Update temp target. *)
					intern.StateMan := 800;
				END_IF
	
			END_IF
	
		(* Homing sequence - Waiting for non-standstill state. *)
		200:
	
			CASE (Parameters.HomeMode) OF																																											(* Set for required homing mode. *)
	
				1:	(* Homing in the negative direction. *)
					IF ((NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1))) THEN																							(* Negative limit switch active? *)
						IO_Mapping.MpGenMode	:= XSM_MODE_HOME_POSITIVE;																														(* Set XSM control mode. *)
					ELSE																																																					(* Homing OK to start. *)
						IO_Mapping.MpGenMode	:= XSM_MODE_HOME_NEGATIVE;																														(* Set XSM control mode. *)
					END_IF
	
				2:	(* Homing in the positive direction. *)
					IF ((NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2))) THEN																							(* Positive limit switch active? *)
						IO_Mapping.MpGenMode	:= XSM_MODE_HOME_NEGATIVE;																														(* Set XSM control mode. *)
					ELSE																																																					(* Homing OK to start. *)
						IO_Mapping.MpGenMode	:= XSM_MODE_HOME_POSITIVE;																														(* Set XSM control mode. *)
					END_IF
	
				(* Direct homing mode or Invalid homing mode. *)
				ELSE
					IO_Mapping.MpGenMode	:= XSM_MODE_SET_ACTUAL_POSITION;																												(* Set XSM control mode. *)
			END_CASE
	
			IO_Mapping.AbsPos	:= REAL_TO_DINT((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Parameters.HomePosition));	(* Scale from units to uSteps. *)
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF ((IO_Mapping.MpGenMode = XSM_MODE_SET_ACTUAL_POSITION) AND
							(Parameters.HomePosition = Monitor.Actual_Position)) THEN																									(* Direct homing? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			ELSIF NOT(Monitor.Target_Reached) THEN																																						(* Moving started? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			END_IF
	
		(* Homing sequence. *)
		201:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF ((Parameters.HomeMode = 1) AND (IO_Mapping.MpGenMode = XSM_MODE_HOME_POSITIVE) AND (NOT(Parameters.Ignore_HWLimits) AND NOT(Monitor.Input_1))) THEN	(* Detect -egde of negative limit switch? *)
				IO_Mapping.MpGenMode	:= XSM_MODE_HOME_NEGATIVE;																																(* Set XSM control mode. *)
			ELSIF ((Parameters.HomeMode = 2) AND (IO_Mapping.MpGenMode = XSM_MODE_HOME_NEGATIVE) AND (NOT(Parameters.Ignore_HWLimits) AND NOT(Monitor.Input_2))) THEN	(* Detect -egde of positive limit switch? *)
				IO_Mapping.MpGenMode	:= XSM_MODE_HOME_POSITIVE;																																(* Set XSM control mode. *)
			ELSIF ((Monitor.Target_Reached) OR
						((Parameters.HomeMode = 1) AND NOT(Parameters.Ignore_HWLimits) AND (IO_Mapping.MpGenMode = XSM_MODE_HOME_NEGATIVE) AND (Monitor.Input_1)) OR
						((Parameters.HomeMode = 2) AND NOT(Parameters.Ignore_HWLimits) AND (IO_Mapping.MpGenMode = XSM_MODE_HOME_POSITIVE) AND (Monitor.Input_2))) THEN																								(* Target reached or limit switches active? *)
				IF (IO_Mapping.MpGenMode = XSM_MODE_SET_ACTUAL_POSITION) THEN																										(* Direct homing mode? *)
					IO_Mapping.MpGenMode	:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
					Monitor.Home_OK				:= 1;																																										(* Set homed flag. *)
					intern.StateMan := 100;
				ELSE
					IO_Mapping.MpGenMode	:= XSM_MODE_SET_ACTUAL_POSITION;																												(* Set actual position. *)
					intern.StateMan := intern.StateMan + 1;																																				(* Next XSM step. *)
				END_IF
			
			ELSIF (((Parameters.HomeMode = 0) AND (IO_Mapping.MpGenMode <> XSM_MODE_SET_ACTUAL_POSITION)) OR
						 ((Parameters.HomeMode = 1) AND (IO_Mapping.MpGenMode <> XSM_MODE_HOME_POSITIVE)) OR
						 ((Parameters.HomeMode = 2) AND (IO_Mapping.MpGenMode <> XSM_MODE_HOME_NEGATIVE))) THEN											(* IO Mapping output MpGenMode being over written? *)
				Status := 50122;																																																(* Error - IO Mapping output MpGenMode being over written. *)

			END_IF
	
		(* Homing sequence - Waiting for non-standstill state. *)
		202:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF ((IO_Mapping.MpGenMode = XSM_MODE_SET_ACTUAL_POSITION) AND
							(Parameters.HomePosition = Monitor.Actual_Position)) THEN																									(* Direct homing? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			END_IF
	
		(* Homing sequence, Set actual position. *)
		203:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF (Monitor.Target_Reached) THEN																																								(* Target reached? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				Monitor.Home_OK					:= 1;																																										(* Set homed flag. *)
				intern.StateMan := 100;
			ELSIF ((IO_Mapping.MpGenMode = XSM_MODE_HOME_POSITIVE) OR (IO_Mapping.MpGenMode = XSM_MODE_HOME_NEGATIVE) AND
						  (Monitor.Actual_Velocity = 0)) THEN													(* IO Mapping output MpGenMode not linked correctly? *)
				Status := 50123;																																																(* Error - IO Mapping output MpGenMode being over written. *)
			END_IF
	
		(* Absolute move command request - Waiting for non-standstill state. *)
		300:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF NOT(Monitor.Target_Reached) THEN																																						(* Move started? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			END_IF
	
		(* Absolute move command request. *)
		301:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Position > Monitor.Actual_Position)) THEN		(* Moving further in to limit?  *)
				Status := 50111;																																																(* Error - Pos_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl 					:= XSM_CW_DISABLE_VOLTAGE;																										(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode							:= XSM_MODE_OFF;																															(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Position < Monitor.Actual_Position)) THEN		(* Moving further in to limit?  *)
				Status := 50112;																																																(* Error - Neg_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl 					:= XSM_CW_DISABLE_VOLTAGE;																										(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode							:= XSM_MODE_OFF;																															(* Set XSM control mode. *)
	
			ELSIF (((Cmd.Move_Absolute) AND NOT(intern.CmdMove_Absolute)) AND (Cmd.Position <> intern.Target)) THEN						(* Start absolute move, + edge? *)
	
				intern.CmdMove_Absolute := 1;																																										(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position > Parameters.PosSWLimit) AND (Cmd.Position > Monitor.Actual_Position)) THEN	(* Beyond positive SW limit? *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position < Parameters.NegSWLimit) AND (Cmd.Position < Monitor.Actual_Position)) THEN	(* Beyond negative SW limit? *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
				ELSE																																																						(* Move valid. *)
	
					intern.AbsPos := ((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Cmd.Position));										(* Scale from units to uSteps. *)
	
					IF ((intern.AbsPos > 2147483647.0) OR (intern.AbsPos < -2147483648.0) OR																			(* Overflow? *)
							((Cmd.Position > 0) AND (intern.AbsPos < 0)) OR																														(* Positive overflow? *)
							((Cmd.Position < 0) AND (intern.AbsPos > 0))) THEN																												(* Negative overflow? *)
	
						intern.OverflowWarning := intern.StateMan;																																	(* Recorded which step where overflow occured. *)
	
						IF (Cmd.Position > 0) THEN																																									(* Positive overflow? *)
							intern.AbsPos := 2147483647.0;																																						(* Set to maximum. (16#7FFF_FFFF = 2,147,483,647) *)
						ELSIF (Cmd.Position < 0) THEN																																								(* Negitive overflow? *)
							intern.AbsPos := -2147483648.0;																																						(* Set to maximum. (16#8000_0000 = -2,147,483,648) *)
						END_IF
	
					END_IF
	
					IO_Mapping.AbsPos := REAL_TO_UDINT(intern.AbsPos);																														(* Copy required write value. *)
					intern.Target			:= Cmd.Position;																																						(* Update temp target. *)
					Cmd.Move_Absolute	:= 0;																																												(* Reset move absolute command request. *)
				END_IF
	
			ELSIF (Monitor.Target_Reached) THEN																																								(* Reached target? *)
				intern.StateMan := 100;
			END_IF
	
		(* Additive move command request - Waiting for non-standstill state. *)
		400:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
			ELSIF NOT(Monitor.Target_Reached) THEN																																						(* Move started? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			END_IF
	
		(* Additive move command request. *)
		401:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Distance > 0)) THEN													(* Moving further in to limit?  *)
				Status := 50111;																																																(* Error - Pos_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Distance < 0)) THEN													(* Moving further in to limit?  *)
				Status := 50112;																																																(* Error - Neg_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (((Cmd.Move_Additive) AND NOT(intern.CmdMove_Additive)) AND (Cmd.Distance <> 0)) THEN												(* Start additive(relative) move on + edge? *)
	
				intern.CmdMove_Additive := 1;																																										(* Set command latch flag. *)
	
				IF (NOT(Parameters.Ignore_SWLimits) AND ((Monitor.Actual_Position + Cmd.Distance) > Parameters.PosSWLimit) AND
					 ((Monitor.Actual_Position + Cmd.Distance) > Monitor.Actual_Position)) THEN																	(* Beyond positive SW limit?  *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND ((Monitor.Actual_Position + Cmd.Distance) < Parameters.NegSWLimit) AND
							((Monitor.Actual_Position + Cmd.Distance) < Monitor.Actual_Position)) THEN																(* Beyond negative SW limit?  *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
				ELSE																																																						(* Move valid. *)
					IO_Mapping.AbsPos	:= REAL_TO_DINT((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Monitor.Actual_Position + Cmd.Distance));	(* Scale from units to uSteps. *)
					Cmd.Move_Additive	:= 0;																																												(* Reset move additive command request. *)
				END_IF
	
			ELSIF (Monitor.Target_Reached) THEN																																								(* Reached target? *)
				intern.StateMan := 100;
			END_IF
	
		(* Velocity speed command request. *)
		500:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Velocity > 0)) THEN													(* Moving further in to limit?  *)
				Status := 50111;																																																(* Error - Pos_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Velocity < 0)) THEN													(* Moving further in to limit?  *)
				Status := 50112;																																																(* Error - Neg_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit) AND (Cmd.Velocity > 0)) THEN	(* Beyond positive SW limit?  *)
				Status := 50115;																																																(* Error - Pos_SW_Limit_Exceeded *)
	
			ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit) AND (Cmd.Velocity < 0)) THEN	(* Beyond negative SW limit?  *)
				Status := 50116;																																																(* Error - Neg_SW_Limit_Exceeded *)
	
			ELSIF (((Cmd.Move_Velocity) AND NOT(intern.CmdMove_Velocity)) AND (Cmd.Velocity <> intern.Target))THEN						(* Start velocity move on + edge? *)
	
				intern.CmdMove_Velocity := 1;																																										(* Set command latch flag. *)
	
				intern.AbsPos := (51200/UINT_TO_REAL(Parameters.Units_rev)) * (DINT_TO_REAL(Cmd.Velocity)/40.0);								(* Scale from units/s to uSteps/25ms. *)
	
				IF ((intern.AbsPos > 65535.0) OR (intern.AbsPos < -65535.0) OR																									(* Overflow? *)
						((Cmd.Velocity > 0) AND (intern.AbsPos < 0)) OR																															(* Positive overflow? *)
						((Cmd.Velocity < 0) AND (intern.AbsPos > 0))) THEN																													(* Negative overflow? *)
	
					intern.OverflowWarning := intern.StateMan;																																		(* Recorded which step where overflow occured. *)
	
					IF (Cmd.Velocity  > 0) THEN																																										(* Positive overflow? *)
						intern.AbsPos := 65535;																																											(* Set to maximum. *)
					ELSIF (Cmd.Velocity  < 0) THEN																																								(* Negitive overflow? *)
						intern.AbsPos := -65535;																																										(* Set to maximum. *)
					END_IF
	
				END_IF
	
				IO_Mapping.AbsPos := REAL_TO_UDINT(intern.AbsPos);																															(* Copy required write value. *)
				intern.Target	:= Cmd.Velocity;																																									(* Update temp target. *)
				Cmd.Move_Velocity	:= 0;																																													(* Reset move velocity command request. *)
	
			ELSIF (((Cmd.Move_Velocity) AND NOT(intern.CmdMove_Velocity)) AND (Cmd.Velocity = intern.Target)) THEN						(* Same target speed? *)
				Cmd.Move_Velocity	:= 0;																																													(* Reset move velocity command request. *)
	
			END_IF
	
	
		(* Stop move at set deceleration valves. *)
		600:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
			ELSIF ((Monitor.StandStill) AND NOT(Cmd.Stop)) THEN																																(* Stand still? *)
				intern.StateMan := 100;
			END_IF
	
		(* Two position mode command request. *)
		700:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2)) THEN																								(* Moving further in to limit?  *)
				Status := 50111;																																																(* Error - Pos_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1)) THEN																								(* Moving further in to limit?  *)
				Status := 50112;																																																(* Error - Neg_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position > Parameters.PosSWLimit)) THEN								(* Beyond positive SW limit?  *)
				Status := 50115;																																																(* Error - Pos_SW_Limit_Exceeded *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Monitor.Actual_Position < Parameters.NegSWLimit)) THEN								(* Beyond negative SW limit?  *)
				Status := 50116;																																																(* Error - Neg_SW_Limit_Exceeded *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
	
			ELSIF ((Monitor.Target_Reached) AND NOT(Cmd.Advanced.Two_Position_Mode)) THEN																			(* Target reached and not in two position mode? *)
				intern.CmdMove_Adv_FixedPos_a := 1;																																							(* Set internal flag to force positive edge of cmd. *)
				intern.CmdMove_Adv_FixedPos_b	:= 1;																																							(* Set internal flag to force positive edge of cmd. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan					:= 100;
	
			END_IF
	
		(* Target position mode. *)
		800:
	
			IF NOT(Power) THEN																																																(* Power off XSM module? *)
				IO_Mapping.MpGenControl := XSM_CW_DISABLE_VOLTAGE;																															(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 0;
	
			ELSIF (Cmd.Stop) THEN																																															(* Stop movement? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 600;
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_2) AND (Cmd.Advanced.Target_Position > Monitor.Actual_Position)) THEN	(* Moving further in to limit?  *)
				Status := 50111;																																																(* Error - Pos_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl 					:= XSM_CW_DISABLE_VOLTAGE;																										(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode							:= XSM_MODE_OFF;																															(* Set XSM control mode. *)
	
			ELSIF (NOT(Parameters.Ignore_HWLimits) AND (Monitor.Input_1) AND (Cmd.Advanced.Target_Position < Monitor.Actual_Position)) THEN	(* Moving further in to limit?  *)
				Status := 50112;																																																(* Error - Neg_HW_LimitSwitch_Active *)
				IO_Mapping.MpGenControl 					:= XSM_CW_DISABLE_VOLTAGE;																										(* Set XSM Control Word for internal state machine. *)
				IO_Mapping.MpGenMode							:= XSM_MODE_OFF;																															(* Set XSM control mode. *)
	
			ELSIF (Cmd.Advanced.Target_Position <> intern.Target) THEN																												(* Target position changed? *)
	
				IF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position > Parameters.PosSWLimit) AND (Cmd.Advanced.Target_Position > Monitor.Actual_Position)) THEN	(* Beyond positive SW limit? *)
					Status := 50113;																																															(* Error - Target_Exceeds_Pos_SW_Limit *)
				ELSIF (NOT(Parameters.Ignore_SWLimits) AND (Cmd.Position < Parameters.NegSWLimit) AND (Cmd.Advanced.Target_Position < Monitor.Actual_Position)) THEN	(* Beyond negative SW limit? *)
					Status := 50114;																																															(* Error - Target_Exceeds_Neg_SW_Limit *)
				ELSE																																																						(* Move valid. *)
	
					intern.AbsPos := ((51200/UINT_TO_REAL(Parameters.Units_rev)) * DINT_TO_REAL(Cmd.Advanced.Target_Position));		(* Scale from units to uSteps. *)
	
					IF ((intern.AbsPos > 2147483647.0) OR (intern.AbsPos < -2147483648.0) OR																			(* Overflow? *)
							((Cmd.Position > 0) AND (intern.AbsPos < 0)) OR																														(* Positive overflow? *)
							((Cmd.Position < 0) AND (intern.AbsPos > 0))) THEN																												(* Negative overflow? *)
	
						intern.OverflowWarning := intern.StateMan;																																	(* Recorded which step where overflow occured. *)
	
						IF (Cmd.Position > 0) THEN																																									(* Positive overflow? *)
							intern.AbsPos := 2147483647.0;																																						(* Set to maximum. (16#7FFF_FFFF = 2,147,483,647) *)
						ELSIF (Cmd.Position < 0) THEN																																								(* Negitive overflow? *)
							intern.AbsPos := -2147483648.0;																																						(* Set to maximum. (16#8000_0000 = -2,147,483,648) *)
						END_IF
	
					END_IF
	
					IO_Mapping.AbsPos := REAL_TO_UDINT(intern.AbsPos);																														(* Copy required write value. *)
					intern.Target			:= Cmd.Advanced.Target_Position;																														(* Update temp target. *)
				END_IF
	
			ELSIF (NOT(Cmd.Advanced.Target_Mode) AND Monitor.Target_Reached) THEN																							(* Reached target and target mode not required anymore? *)
				IO_Mapping.MpGenMode		:= XSM_MODE_OFF;																																				(* Set XSM control mode. *)
				intern.StateMan := 100;
			END_IF
	
		(* Error handling - Check for XSM_Warning or XSM_Fault. *)
		1000:
			IF ((Status = 50102) OR (Status = 50103)) THEN																																		(* Error - XSM_Warning or fault? *)
				intern.ErrorCode := 0;																																													(* Reset error code. *)	
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			ELSE
				intern.StateMan := 1010;																																												(* Wait for reset. *)
			END_IF	

		(* Error handling - Get error code from module. *)
		1001:
			#ifdef _SG4
				CASE (IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'ErrorCode01';																																	(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 98)*)
					2:			intern.ChannelName := 'ErrorCode02';																																	(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 162)*)
					3:			intern.ChannelName := 'ErrorCode03';																																	(* X67SM4320 3rd motor selected. (Reg 226)*)
					4:			intern.ChannelName := 'ErrorCode04';																																	(* X67SM4320 4th motor selected. (Reg 290)*)
				END_CASE

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName)); 			(* Read ErrorCode01, Reg 98. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						intern.ErrorCode := UDINT_TO_UINT(AsIOAccRead_0.value);																														(* Update error code. *)
					ELSE																																																					(* AsIOAccRead Error? *)
						Status := AsIOAccRead_0.status;																																							(* Copy AsIOAccRead status. *)
					END_IF
					intern.StateMan := 1002;																																											(* Decode error code. *)
				END_IF
			#endif	
			#ifdef _SGC
				AsIOAccReadReg_0.nodeNr:= DINT_TO_USINT(atoi(ADR(IO_Mapping.DeviceName) + FIND(IO_Mapping.DeviceName, 'ST') + 1));	(* Get node number on X2X. *)

				CASE (IO_Mapping.Channel) OF
					0..1:		AsIOAccReadReg_0.registerNr:= 98;																																			(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 98)*)
					2:			AsIOAccReadReg_0.registerNr:= 162;																																		(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 162)*)
					3:			AsIOAccReadReg_0.registerNr:= 226;																																		(* X67SM4320 3rd motor selected. (Reg 226)*)
					4:			AsIOAccReadReg_0.registerNr:= 290;																																		(* X67SM4320 4th motor selected. (Reg 290)*)
				END_CASE
					
				AsIOAccReadReg_0(enable:= 1, size:= 2);

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						intern.ErrorCode := UDINT_TO_UINT(AsIOAccReadReg_0.value);																									(* Update error code. *)
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status := AsIOAccReadReg_0.status;																																					(* Copy AsIOAccReadReg status. *)
					END_IF
					intern.StateMan := 1002;																																											(* Decode error code. *)
				END_IF
			#endif	

		(* Error handling - Decode error code. *)
		1002:
			CASE intern.ErrorCode OF																																													(* Format status value. *)
				16#2300:	Status:= 50150;																																												(* Error code 16#2300 : Warning - Over current. *)
				16#3000:	Status:= 50151;																																												(* Error code 16#3000 : Error - Voltage. *)
				16#3100:	Status:= 50152;																																												(* Error code 16#3100 : Error - Module supply voltage. *)
				16#3210:	Status:= 50153;																																												(* Error code 16#3210 : Error - Over voltage on DC Bus. *)
				16#3220:	Status:= 50154;																																												(* Error code 16#3220 : Error - Under voltage on DC bus. *)
				16#4200:	Status:= 50155;																																												(* Error code 16#4200 : Error - Over temperature. *)
				16#FF00:	Status:= 50156;																																												(* Error code 16#FF00 : Warning - Under current (IF under current detection is activated). *)
				16#FF01:	Status:= 50157;																																												(* Error code 16#FF01 : Warning - Stall (IF stall detection is activated). *)
				16#FF02:	Status:= 50158;																																												(* Error code 16#FF02 : Error - Drive NOT enabled (enable input = 0). *)
				16#FF10:	Status:= 50159;																																												(* Error code 16#FF02 : Warning - Encoder supply voltage. *)
			END_CASE
				
			intern.StateMan := 1010;																																													(* Wait for reset. *)
			
		(* Error handling - Check reset flag is OFF. *)
		1010:
		
			Error := 1;																																																				(* Set Error flag. *)
		
			IF NOT(Cmd.Reset) THEN																																														(* Reset OFF? *)
				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
			END_IF
	
		(* Error handling - Reset error on positve edge. *)
		1011:
	
			IO_Mapping.MpGenMode := XSM_MODE_OFF;																																							(* Set XSM control mode. *)
	
			(*IF (Cmd.Reset) THEN				*)
			IF (Cmd.Reset) OR ( intern.AutoReset AND Status = 50158)  THEN    														(* Reset / Error acknownledge? *)
	
				IF ((Status = 50102) OR (Status = 50150) OR (Status = 50156) OR (Status = 50157) OR (Status = 50159)) THEN			(* XSM Warning? *)
					IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 12);																							(* Warning reset. *)
				
				ELSIF ((Status = 50103) OR (Status = 50151) OR (Status = 50152) OR (Status = 50153) OR (Status = 50154) OR
							 (Status = 50155) OR (Status = 50158)) THEN																																(* XSM state machine fault? *)
					IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 7);																								(* Fault reset. *)
				
				ELSIF (intern.ErrorCode <> 0) THEN																																							(* XSM_Warning or fault unknown? *)
					IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 12);																							(* Warning reset. *)
					IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 7);																								(* Fault reset. *)

				END_IF
				
				intern.CmdReset         := TRUE;
				intern.CyclicCounter := 0.0;                                                                                                                                                                        (* Cyclic counter. *)
				intern.StateMan := intern.StateMan + 1;                                                                                                                                                    (* Next XSM step. *)
			END_IF
			IF NOT(Status = 50158) THEN
				intern.AutoReset        := FALSE;
			END_IF
	
//				intern.CyclicCounter := 0.0;																																										(* Cyclic counter. *)
//				intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
//			END_IF
	
		(* Error handling - Reset all state machine errors? *)
		1012:
	
			IF NOT(intern.XSM_StateMachine.OperationEnabled) THEN																															(* Ready for operation. *)
				intern.CyclicCounter := intern.CyclicCounter + intern.TaskCyclicTime;																						(* Increament cyclic counter by cyclic time. *)
			END_IF
			
			IF (((intern.XSM_StateMachine.SwitchOnDisabled) AND (Status <> 50102) AND (Status <> 50103)) OR										(* Ready to start again and not XSM Warning or fault? *)
					(intern.CyclicCounter > 0.500) OR																																							(* XSM Warning or fault needs 200ms for reset allow for 500ms?  *)
					((Cmd.Reset) AND NOT(intern.CmdReset))) THEN																																	(* Auto reset or force reset on + edge? *)
				Cmd.Reset := 0;																																																	(* Reset reset. *)
				Status		:= 0;																																																	(* Reset error status. *)
				intern.StateMan 	:= 0;
				intern.AutoReset    := FALSE;
			END_IF
	
		(* Should not get here, invalid state. *)
		ELSE
				intern.StateMan := 1000;
	
	END_CASE
	
	(********************************************************************************************************************
		Activate stall ,under current detection.
	*********************************************************************************************************************)
	IF (Parameters.StallDetectionEnable) THEN																																							(* Activate stall detection? *)
		IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 15);																										(* Set bit to activate stall detection. *)
	END_IF
	
	IF (Parameters.UnderCurrentDetectionEnable) THEN																																			(* Activate under current detection? *)
		IO_Mapping.MpGenControl := BIT_SET(IO_Mapping.MpGenControl, 13);																										(* Set bit to activate under current detection. *)
	END_IF
	
	
	
	(********************************************************************************************************************
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NO MORE CODE BEYOND THIS POINT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*********************************************************************************************************************)
	
END_FUNCTION_BLOCK
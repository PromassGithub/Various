FUNCTION_BLOCK XSM_AcyclicRead
	(* Implementation of XSM_AcyclicRead *)
	(********************************************************************************************************************
		Filename		: XSM_AcyclicRead.scr
		Version			: 00.01
		Date				: 14th July 2009
		Written by	: Andy Lees at B&R Industrial Automation Ltd. (UK)
		Customer		: Sheepy.
		Application : .
		Description	:	Provide alarm detail in form of BOOLEAN array for VC & User.
		
									Status:-
	
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
										50109		XSM_Motor_Invalid.
										
										50202		pIO_Mapping_Invalid.

										50200		Read acyclic mode invalid.

										30190 - 30199 AsIOAcc
										
										65534		ERR_FUB_ENABLE_FALSE
	
									Mode:-
									
										1				Read DC bus voltage in V.
										2				Read Module temperature of the power output stage in °C.
										3				Read Module temperature in °C.
																				 
										4				Read Referenced zero position of the cyclic counter.
										5				Read Current position acyclic.
										6				Read Referenced zero position of the acyclic counter.
	

		History			: 14th July 2009		v00.01
									First release - Tested on X20CP1486 N2.95 with X20SM1426 on X2X & Ethernet Power Link.
									
	*********************************************************************************************************************)
	IF (Enable) THEN																																																			(* Function block enabled? *)

		(******************************************************************************************************************
			Errors force to handle errors?
		*******************************************************************************************************************)
		IF ((Status <> ERR_OK) AND (Status <> ERR_FUB_ENABLE_FALSE) AND (Status <> ERR_FUB_BUSY) AND (intern.StateMan < 1000)) THEN	(* Error and not error handling state's? *)
			intern.StateMan := 1000;																																														(* Handle errors. *)
		END_IF

		(******************************************************************************************************************
			SXM IO Configuratin state machine.
		*******************************************************************************************************************)
		CASE (intern.StateMan) OF																																															(* State machine. *)
	
			(* Init - Wait for command. *)
			0:
				IF ((Status = ERR_FUB_ENABLE_FALSE) OR (Status = ERR_FUB_BUSY)) THEN																							(* Clear function not enable or busy status? *)
					Status := ERR_OK;																																																(* Function OK. *)
				END_IF
	
				IF (pIO_Mapping <> 0) THEN																																												(* Address non-Zero? *)
					memcpy(ADR(intern.IO_Mapping), pIO_Mapping, SIZEOF(intern.IO_Mapping));																					(* Get update intern.IO_Mapping data. *)
				ELSE																																																							(* Error? *)
					Status := 50202;																																																(* pIO_Mapping_Invalid. *)
				END_IF
	
				IF ((intern.IO_Mapping.ModuleID <> 9857) AND (intern.IO_Mapping.ModuleID <> 9858) AND															(* Not X20SM1426, X20SM1436? *)
						(intern.IO_Mapping.ModuleID <> 7627) AND (intern.IO_Mapping.ModuleID <> 7628) AND															(* Not X67SM2436, X67SM4320? *)
						(intern.IO_Mapping.ModuleID <> 42148) AND (intern.IO_Mapping.ModuleID <> 42414) AND														(* Not 80SD100XD.C0XX-01, 80SD100XS.C0XX-01? *)
						(intern.IO_Mapping.ModuleID <> 42880) AND (intern.IO_Mapping.ModuleID <> 42881) AND														(* Not 80SD100XS.C04X-01, 80SD100XD.C044-01? *)
						(intern.IO_Mapping.ModuleID <> 42882) AND (intern.IO_Mapping.ModuleID <> 42893) AND														(* Not 80SD100XS.C04X-13, 80SD100XD.C04X-13? *)
						(intern.IO_Mapping.ModuleID <> 42894)) THEN																																		(* Not 80SD100XD.C0XX-21? *)							
					Status := 50101;																																																(* Error - XSM_ModuleID_Invalid *)
				ELSIF (((intern.IO_Mapping.ModuleID = 9857) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 1))) OR	(* X20SM1426 - Only 1 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 9858) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 1))) OR	(* X20SM1436 - Only 1 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 7627) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 2))) OR	(* X67SM2436 - Only 2 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 7628) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 4)))	OR	(* X67SM4320 - Only 4 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42148) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 2))) OR	(* 80SD100XD.C0XX-01 - Only 2 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42414) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 1))) OR	(* 80SD100XS.C0XX-01 - Only 1 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42880) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 1))) OR	(* 80SD100XS.C04X-01 - Only 1 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42881) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 2))) OR	(* 80SD100XD.C044-01 - Only 2 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42882) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 1))) OR	(* 80SD100XS.C04X-13 - Only 1 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42893) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 2))) OR	(* 80SD100XD.C04X-13 - Only 2 motor possible. *)
							 ((intern.IO_Mapping.ModuleID = 42894) AND ((intern.IO_Mapping.Channel < 0) OR (intern.IO_Mapping.Channel > 2)))		(* 80SD100XD.C0XX-21 - Only 2 motor possible. *)
							) THEN																																																				(* Selected motor invalid? *)
					Status := 50109;																																																	(* XSM_Motor_Invalid? *)
				END_IF

			#ifdef _SGC 
				AsIOAccReadReg_0.nodeNr:= DINT_TO_USINT(atoi(ADR(intern.IO_Mapping.DeviceName) + FIND(intern.IO_Mapping.DeviceName, 'ST') + 1));	(* Get node number on X2X. *)
			#endif
				
				intern.ReadOK:= (intern.ReadOK AND Read);																																				(* Detect +edge of Read. *)
				
				IF ((Status = ERR_OK) AND NOT(intern.ReadOK) AND (Read)) THEN																										(* Read acyclic data? *)
					intern.Retries:= 0;																																														(* Reset retries. *)
					Status := ERR_FUB_BUSY;																																												(* Function busy status. *)
					CASE (Mode) OF
						1:			intern.StateMan		:= 10;																																						(* Read DC bus voltage in V. *)
						2:			intern.StateMan 	:= 20;																																						(* Read Module temperature of the power output stage in °C. *)
						3:			intern.StateMan 	:= 30;																																						(* Read Module temperature in °C. *)
						4:			intern.StateMan 	:= 40;																																						(* Read Referenced zero position of the cyclic counter. *)
						5:			intern.StateMan 	:= 50;																																						(* Read Current position acyclic. *)
						6:			intern.StateMan 	:= 60;																																						(* Read Referenced zero position of the acyclic counter. *)
						ELSE	Status := 50400;																																											(* Read acyclic mode invalid. *)
					END_CASE
				END_IF

			(* Read DC bus voltage in V. *)
			10:
			#ifdef _SG4
				intern.ChannelName := 'UZKVoltage';																																							(* Read DC bus voltage in V. (Reg 42) *)

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.DC_BusVoltage:= UDINT_TO_UINT(AsIOAccRead_0.value);																								(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				AsIOAccReadReg_0.registerNr:= 42;																																								(* Read DC bus voltage in V. (Reg 42) *)
					
				AsIOAccReadReg_0(enable:= 1, size:= 2);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.DC_BusVoltage:= UDINT_TO_UINT(AsIOAccReadReg_0.value);																							(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Read Module temperature of the power output stage in °C. *)
			20:
			#ifdef _SG4
				intern.ChannelName := 'CoolerTemperature';																																			(* Read Module temperature of the power output stage in °C. (Reg 44) *)

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.PowerStage_Temperature:= UDINT_TO_SINT(AsIOAccRead_0.value);																				(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				AsIOAccReadReg_0.registerNr:= 44;																																								(* Read Module temperature of the power output stage in °C. (Reg 44). *)
					
				AsIOAccReadReg_0(enable:= 1, size:= 1);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.PowerStage_Temperature:= UDINT_TO_SINT(AsIOAccReadReg_0.value);																		(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Read Module temperature in °C. *)
			30:
			#ifdef _SG4
				intern.ChannelName := 'Temperature';																																						(* Read Module temperature in °C. (Reg 46) *)

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.Module_Temperature:= UDINT_TO_SINT(AsIOAccRead_0.value);																						(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				AsIOAccReadReg_0.registerNr:= 46;																																								(* Read Module temperature in °C. (Reg 46). *)
					
				AsIOAccReadReg_0(enable:= 1, size:= 1);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.Module_Temperature:= UDINT_TO_SINT(AsIOAccReadReg_0.value);																				(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Read Referenced zero position of the cyclic counter. *)
			40:
			#ifdef _SG4
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'RefPos01CyclicCounter';																												(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 86)*)
					2:			intern.ChannelName := 'RefPos02CyclicCounter';																												(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 150)*)
					3:			intern.ChannelName := 'RefPos03CyclicCounter';																												(* 3rd motor channel selected. (Reg 214) *)
					4:			intern.ChannelName := 'RefPos04CyclicCounter';																												(* 4th motor channel selected. (Reg 278) *)
				END_CASE

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.Encoder_RefPosCyclicCounter:= UDINT_TO_DINT(AsIOAccRead_0.value);																	(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		AsIOAccReadReg_0.registerNr:= 86;																																			(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 86)*)
					2:			AsIOAccReadReg_0.registerNr:= 150;																																		(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 150)*)
					3:			AsIOAccReadReg_0.registerNr:= 214;																																		(* 3rd motor channel selected. (Reg 214) *)
					4:			AsIOAccReadReg_0.registerNr:= 278;																																		(* 4th motor channel selected. (Reg 278) *)
				END_CASE
					
				AsIOAccReadReg_0(enable:= 1, size:= 4);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.Encoder_RefPosCyclicCounter:= UDINT_TO_DINT(AsIOAccReadReg_0.value);																(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Read Current position acyclic. *)
			50:
			#ifdef _SG4
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'AbsPos1ActValAcyclic';																												(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 90)*)
					2:			intern.ChannelName := 'AbsPos2ActValAcyclic';																												(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 154)*)
(*					3:			intern.ChannelName := 'AbsPos3ActValAcyclic';	- Not used yet *)																											(* 3rd motor channel selected. (Reg ???) *)
(*					4:			intern.ChannelName := 'AbsPos4ActValAcyclic';	- Not used yet *)																												(* 4th motor channel selected. (Reg ???) *)
				END_CASE

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.Encoder_ActualValue:= UDINT_TO_DINT(AsIOAccRead_0.value);																					(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		AsIOAccReadReg_0.registerNr:= 90;																																			(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 90)*)
					2:			AsIOAccReadReg_0.registerNr:= 154;																																		(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 150)*)
(*					3:			AsIOAccReadReg_0.registerNr:= ???;	- Not used yet *)																																		(* 3rd motor channel selected. (Reg ???) *)
(*					4:			AsIOAccReadReg_0.registerNr:= ???;	- NOT used yet *)																																		(* 4th motor channel selected. (Reg ???) *)
				END_CASE
					
				AsIOAccReadReg_0(enable:= 1, size:= 4);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.Encoder_ActualValue:= UDINT_TO_DINT(AsIOAccReadReg_0.value);																				(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Read Referenced zero position of the acyclic counter. *)
			60:
			#ifdef _SG4
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'RefPos01AcyclicCounter';																												(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 94)*)
					2:			intern.ChannelName := 'RefPos02AcyclicCounter';																												(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 158)*)
(*					3:			intern.ChannelName := 'RefPos03AcyclicCounter';	- Not used yet *)																											(* 3rd motor channel selected. (Reg ???) *)
(*					4:			intern.ChannelName := 'RefPos04AcyclicCounter';	- Not used yet *)																												(* 4th motor channel selected. (Reg ???) *)
				END_CASE

				AsIOAccRead_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Read acyclic data. *)

				IF (AsIOAccRead_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
					IF (AsIOAccRead_0.status = ERR_OK) THEN																																				(* No error? *)
						ReadData.Encoder_RefPosAcyclicCounter:= UDINT_TO_DINT(AsIOAccRead_0.value);																	(* Copy data. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSE																																																					(* AsIOAccRead Error? *)
						Status:= AsIOAccRead_0.status;
					END_IF
				END_IF
			#endif	
			#ifdef _SGC
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		AsIOAccReadReg_0.registerNr:= 94;																																			(* X20SM/X67SM/ACOPOSmicro 1st motor selected.(Reg 94)*)
					2:			AsIOAccReadReg_0.registerNr:= 158;																																		(* X67SM/ACOPOSmicro 2nd motor selected. (Reg 158)*)
(*					3:			AsIOAccReadReg_0.registerNr:= ???;	- Not used yet *)																																		(* 3rd motor channel selected. (Reg ???) *)
(*					4:			AsIOAccReadReg_0.registerNr:= ???;	- NOT used yet *)																																		(* 4th motor channel selected. (Reg ???) *)
				END_CASE
					
				AsIOAccReadReg_0(enable:= 1, size:= 4);																																					(* Read acyclic data. *)

				IF (AsIOAccReadReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccReadReg_0.status = ERR_OK) THEN																																		(* No error? *)
						ReadData.Encoder_RefPosAcyclicCounter:= UDINT_TO_DINT(AsIOAccReadReg_0.value);															(* Update error code. *)
						intern.ReadOK:= 	TRUE;																																											(* Read OK. *)
						intern.StateMan:= 0;
					ELSIF ((AsIOAccReadReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
					ELSE																																																					(* AsIOAccReadReg Error? *)
						Status:= AsIOAccReadReg_0.status;																																						(* Copy AsIOAccReadReg status. *)
					END_IF
				END_IF
			#endif	

			(* Check for error reset false. *)
			1000:

				IF NOT(Reset) THEN																																															(* Reset false? *)
					intern.StateMan:= 1001;																																												(* Error ack. *)
				END_IF			

			(* Check for Reset & not read data request for single read only. *)
			1001:
				IF ((Status <> ERR_OK) AND (Reset)) THEN																																				(* Error? *)
					Status:= ERR_OK;																																															(* Reset set status. *)
				END_IF
				
				IF (NOT(Read) AND (Status = ERR_OK)) THEN																																				(* All reset? *)
					intern.StateMan:= 0;
				END_IF			


		END_CASE
	
	ELSE
		Status := ERR_FUB_ENABLE_FALSE;																																											(* Function not enabled status. *)
	END_IF
	
	(********************************************************************************************************************
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NO MORE CODE BEYOND THIS POINT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*********************************************************************************************************************)
END_FUNCTION_BLOCK

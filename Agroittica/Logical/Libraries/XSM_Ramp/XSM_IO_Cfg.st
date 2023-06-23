FUNCTION_BLOCK XSM_IO_Cfg
	(* Implementation of XSM_IO_Cfg *)
	(********************************************************************************************************************
		Filename		: XSM_IO_Cfg.scr
		Version			: 00.02
		Date				: 18th June 2013
		Written by	: Andy Lees at B&R Industrial Automation Ltd. (UK)
		Customer		: Sheepy.
		Application : .
		Description	:	Provide IO configuration for SG4 CPu targets only.
		
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
	
										50108		Units_rev_Invalid.
										50109		XSM_Motor_Invalid.
										
										50201		pParameters_Invalid.
										
										50210		MixedDecay_Invalid
										50211		StallDetection_Invalid
	
										50220		HoldingCurrent	Invalid (> Rated, > Maximum)
										50221		RatedCurrent		Invalid (< Holding, > Maximum)
										50222		MaximumCurrent	Invalid (< Holding, < Rated)
										
										50300		HoldingCurrent_Zero
										50301		RatedCurrent_Zero
										50302		MaximumCurrent_Zero
	
										50303		HoldingCurrent	> 1.2A
										50304		RatedCurrent		> 1.2A
										50305		MaximumCurrent	> 1.2A
	
										50306		HoldingCurrent	> 3.5A
										50307		RatedCurrent 		> 3.5A
										50308		MaximumCurrent	> 3.5A
										
										50309		HoldingCurrent	> 5A
										50310		RatedCurrent		> 5A
										50311		MaximumCurrent	> 5A
	
										50312		HoldingCurrent	> 1.5A
										50313		RatedCurrent		> 1.5A
										50314		MaximumCurrent	> 1.5A
				
										50315		HoldingCurrent	> 15A
										50316		RatedCurrent		> 15A
										50317		MaximumCurrent	> 15A
	
										50250		Invalid homing mode.
										50251		Stall homing mode not supported.
																			
										50260		MaxSpeed_Invalid
										50261		MaxAcc_Invalid
										50262		MaxDec_Invalid
										50267		JoltTimeLimitation_Invalid
										
										30190 - 30199 AsIOAcc
	
										65534		ERR_FUB_ENABLE_FALSE
										65535		ERR_FUB_BUSY
	
									Mode:-
									
										0				Configure all.
	
										20			Configure motor currents only.
	
										50			Referencing Configuration only.
	
										60			Configure all MPGen only.
										61			Configure MPGen Speed only.
										62			Configure MPGen Speed & Acc/Dec only.
										63			Configure MPGen RevLoop only.
										64			Configure MPGen FixedPos_a only.
										65			Configure MPGen FixedPos_b only.
										66			Configure MPGen RefSpeed only.
										67			Configure MPGen JoltTimeLimiation only.
	
									intern.StateMan - State Machine:-
	
										0			Init - Wait for command.
										
										10		XSM IO_Cfg - Mixed decay configuration/Stall Detection/Display motor load value.	USINT	StallDetectConfig01
										
										20		XSM IO_Cfg - Holding current [%].											USINT	ConfigOutput03a
										21		XSM IO_Cfg - Rated current [%].												USINT	ConfigOutput04a
										22		XSM IO_Cfg - Maximum current [%].											USINT	ConfigOutput05a
	
										30		XSM IO_Cfg - Full Step Threshold.											UINT	FullStepThreshold01
	
										50		XSM IO_Cfg - Referencing Configuration.								SINT	RefConfig01
										51		XSM IO_Cfg - Stall Detection Delay.										USINT	StallRecognitionDelay01
	
										60		XSM IO_Cfg - Maximum speed.														UINT	MaxSpeed01pos
										61		XSM IO_Cfg - Maximum acceleration.										UINT	MaxAcc01
										62		XSM IO_Cfg - Maximum deceleration.										UINT	MaxDec01
										63		XSM IO_Cfg - RevLoop (Turn-around loop).							INT		RevLoop01
										64		XSM IO_Cfg - FixedPos_a (Set position 1).							DINT	FixedPos01a
										65		XSM IO_Cfg - FixedPos_b (Set position 2).							DINT	FixedPos01b
										66		XSM IO_Cfg - Referencing Speed.												UINT	RefSpeed01
										67		XSM IO_Cfg - Jolt time limitation.										USINT	JoltTime01
	
										1000	Error handling - Check reset flag is OFF.
										1001	Error handling - Reset error on positve edge.
	
										ELSE	Should not get here, invalid state. Goto 1000
	
	
									intern.Overflow		
										-xx_xx_xx_xx_xx
											:  :  :  :  :-- 4th Overflow state number.
											:  :  :  :----- 3rd Overflow state number.
											:  :  :-------- 2nd Overflow state number.
											:  :----------- 1st Overflow state number.
											:-------------- Move than 4 overflow's occured, set negative and count number of extra overflows that have occured.
	
										i.e. 
										
										 -5_50_61_62_70 
											:  :  :  :  :-- 4th Overflow recorded state number 70.
											:  :  :  :----- 3rd Overflow recorded state number 62.
											:  :  :-------- 2nd Overflow recorded state number 61.
											:  :----------- 1st Overflow recorded state number 50.
											:-------------- Total overflow that occured = ABS(-5) + 4 = 9.
																												
																												
		History			: 18th June 2013			v00.03
									Corrected Acc/Dec scaling (uSteps/25ms to uSteps/25ms²)
								: 10th March 2009			v00.02
									Added ACOPOSmicro 80SD100XD.C0XX-01 module ID 42148.
								: 14th January 2009		v00.01
									First release - Tested on X20CP1486 N2.95 with X20SM1426 on X2X & Ethernet Power Link.
									
	*********************************************************************************************************************)
	IF (Enable) THEN																																																				(* Function block enabled? *)
	
		(******************************************************************************************************************
			Errors force to handle errors if not includeing XSM_Warning and XSM_Error?
		*******************************************************************************************************************)
(*		IF ((Status <> ERR_OK) AND (Status <> ERR_FUB_ENABLE_FALSE) AND (Status <> ERR_FUB_BUSY) AND
				(Status <> 50102) AND (Status <> 50103) AND (intern.StateMan < 1000)) THEN																				(* Error and not error handling state's? *)
		IF ((Status <> ERR_OK) AND (Status <> ERR_FUB_ENABLE_FALSE) AND (Status <> ERR_FUB_BUSY) AND (intern.StateMan < 1000)) THEN																				(* Error and not error handling state's? *)
			intern.StateMan := 1000;																																														(* Handle errors. *)
		END_IF
	
		(******************************************************************************************************************
			SXM IO Configuratin state machine.
		*******************************************************************************************************************)
		CASE (intern.StateMan) OF																																															(* State machine. *)
	
			(* Init - Wait for command. *)
			0:
	
				Status:= 0;																																																				(* Reset status. *)
	
				IF (pParameters <> 0) THEN																																												(* Address non-Zero? *)
					memcpy(ADR(intern.Parameters), pParameters, SIZEOF(intern.Parameters));																					(* Get Parameters data. *)
				ELSE																																																							(* Error? *)
					Status := 50201;																																																(* pParameters_Invalid. *)
				END_IF
	
				IF (pIO_Mapping <> 0) THEN																																												(* Address non-Zero? *)
					memcpy(ADR(intern.IO_Mapping), pIO_Mapping, SIZEOF(intern.IO_Mapping));																					(* Get update intern.IO_Mapping data. *)
				ELSE																																																							(* Error? *)
					Status := 50202;																																																(* pintern.IO_Mapping_Invalid. *)
				END_IF
	
				IF NOT(intern.IO_Mapping.ModuleOK) THEN																																						(* XSM Module NOT OK? *)
					IF (intern.Cfg_State = 1) THEN																																									(* Congfiguration done before? *)
						intern.Cfg_State	:= 255;																																											(* Set auto reconfigure when ModuleOk. *)
					END_IF
					Status := 50100;																																																(* Error - XSM_ModuleNotOK. *)
	
				ELSIF ((intern.IO_Mapping.ModuleID <> 9857) AND (intern.IO_Mapping.ModuleID <> 9858) AND													(* Not X20SM1426, X20SM1436? *)
							 (intern.IO_Mapping.ModuleID <> 7627) AND (intern.IO_Mapping.ModuleID <> 7628) AND													(* Not X67SM2436, X67SM4320? *)
							 (intern.IO_Mapping.ModuleID <> 42148) AND (intern.IO_Mapping.ModuleID <> 42414) AND												(* Not 80SD100XD.C0XX-01, 80SD100XS.C0XX-01? *)
							 (intern.IO_Mapping.ModuleID <> 42880) AND (intern.IO_Mapping.ModuleID <> 42881) AND												(* Not 80SD100XS.C04X-01, 80SD100XD.C044-01? *)
							 (intern.IO_Mapping.ModuleID <> 42882) AND (intern.IO_Mapping.ModuleID <> 42893) AND												(* Not 80SD100XS.C04X-13, 80SD100XD.C04X-13? *)
							 (intern.IO_Mapping.ModuleID <> 42894)) THEN																																(* Not 80SD100XD.C0XX-21? *)							
					Status := 50101;																																																(* Error - XSM_ModuleID_Invalid *)
	
				ELSIF ((Status = 0) AND ((intern.Parameters.Units_rev <= 0) OR (intern.Parameters.Units_rev > 51200))) THEN				(* Units per rev invalid? *)
					Status := 50108;																																																(* Units_rev_Invalid. *)
	
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
							) THEN																																																			(* Selected motor invalid? *)
					Status := 50109;																																																(* XSM_Motor_Invalid? *)
	
				END_IF
	
				Done := (Done AND Config);																																												(* Detect +edge of Config. *)

			#ifdef _SGC 
				AsIOAccWriteReg_0.nodeNr:= DINT_TO_USINT(atoi(ADR(intern.IO_Mapping.DeviceName) + FIND(intern.IO_Mapping.DeviceName, 'ST') + 1));				(* Get node number on X2X. *)
			#endif
	
				IF ((Status = 0) AND (intern.Cfg_State = 255)) THEN																																(* Start auto configuration? *)
					intern.Retries:= 0;																																														(* Reset retries. *)
					intern.OverflowWarning := 0;																																										(* Clear overflow occured record. *)
					Status := ERR_FUB_BUSY;																																													(* Function busy status. *)
					intern.StateMan		:= 10;																																												(* Configure all. *)
				ELSIF ((Status = 0) AND (Config) AND NOT(Done)) THEN																															(* Start configuration on +edge? *)
					intern.Retries:= 0;																																														(* Reset retries. *)
					intern.OverflowWarning := 0;																																										(* Clear overflow occured record. *)
					Status := ERR_FUB_BUSY;																																													(* Function busy status. *)
					CASE (Mode) OF
						0:			intern.StateMan		:= 10;																																							(* Configure all. *)
						20:			intern.StateMan 	:= 20;																																							(* Configure motor currents only. *)
						50:			intern.StateMan 	:= 50;																																							(* Configure Referencing Configuration only. *)
						60..62:	intern.StateMan 	:= 60;																																							(* Configure all MPGen, Speed & Speed/Acc/Dec. *)
						63:			intern.StateMan 	:= 63;																																							(* Configure MPGen RevLoop only. *)
						64:			intern.StateMan 	:= 64;																																							(* Configure MPGen FixedPos_a only. *)
						65:			intern.StateMan 	:= 65;																																							(* Configure MPGen FixedPos_b only. *)
						66:			intern.StateMan 	:= 66;																																							(* Configure MPGen RefSpeed only. *)
						67:			intern.StateMan 	:= 67;																																							(* Configure MPGen RevLoop only. *)
						ELSE	Status := 50200;																																												(* ConfigurationMode_Invalid. *)
					END_CASE
				END_IF
	
			(* IO Configuration - Mixed decay configuration/Stall Detection/Display motor load value *)
			10:
				IF ((intern.IO_Mapping.ModuleID = 42148) OR (intern.IO_Mapping.ModuleID = 42414) OR (intern.IO_Mapping.ModuleID = 42880) OR
					  (intern.IO_Mapping.ModuleID = 42881) OR (intern.IO_Mapping.ModuleID = 42882) OR (intern.IO_Mapping.ModuleID = 42893) OR
						(intern.IO_Mapping.ModuleID = 42894)) THEN																																		(* Not supported on ACOPOSmicro. *)
					intern.StateMan := 20;																																													(* Next XSM step. *)
	
				ELSIF (IO_Cfg.MixedDecayCfg > 15) THEN																																						(* Invalid value? *)																																							(*  *)
					Status := 50210;																																																(* MixedDecay_Invalid *)
	
				ELSIF (IO_Cfg.StallCfg.StallDetection > 7)	THEN																																	(* Stall detection configuration valide? *)
					Status := 50211;																																																(* StallDetection_Invalid *)
	
				ELSE																																																							(* Valid data? *)
				
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'StallDetectConfig01';																													(* 1st motor channel selected. (Reg 51) *)
						2:			intern.ChannelName := 'StallDetectConfig02';																													(* 2nd motor channel selected. (Reg 115) *)
						3:			intern.ChannelName := 'StallDetectConfig03';																													(* 3rd motor channel selected. (Reg 179) *)
						4:			intern.ChannelName := 'StallDetectConfig04';																													(* 4th motor channel selected. (Reg 243) *)
					END_CASE
	
					AsIOAccWrite_0.value := USINT_TO_UDINT(IO_Cfg.StallCfg.StallDetection * 16);																		(* Convert required IIO_Cfg.StallConfig.StallDetection to bit 4-6. *)
					AsIOAccWrite_0.value := AsIOAccWrite_0.value + USINT_TO_UDINT(IO_Cfg.MixedDecayCfg);														(* Convert required IO_Cfg.MixedDecayConfig to bit 0-3. *)
	
					IF (IO_Cfg.StallCfg.DisplayMotorLoadValues) THEN																																(* Display motor load value? *)
						AsIOAccWrite_0.value := BIT_SET(AsIOAccWrite_0.value, 7);																											(* Set bit to activate display motor load value. *)
					END_IF
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							intern.StateMan := 20;																																											(* Next XSM step. *)
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 51;																																		(* 1st motor channel selected. (Reg 51) *)
						2:			AsIOAccWriteReg_0.registerNr:= 115;																																		(* 2nd motor channel selected. (Reg 115) *)
						3:			AsIOAccWriteReg_0.registerNr:= 179;																																		(* 3rd motor channel selected. (Reg 179) *)
						4:			AsIOAccWriteReg_0.registerNr:= 243;																																		(* 4th motor channel selected. (Reg 243) *)
					END_CASE
	
					AsIOAccWriteReg_0.value:= USINT_TO_UDINT(IO_Cfg.StallCfg.StallDetection * 16);																	(* Convert required IIO_Cfg.StallConfig.StallDetection to bit 4-6. *)
					AsIOAccWriteReg_0.value:= AsIOAccWriteReg_0.value + USINT_TO_UDINT(IO_Cfg.MixedDecayCfg);												(* Convert required IO_Cfg.MixedDecayConfig to bit 0-3. *)
	
					IF (IO_Cfg.StallCfg.DisplayMotorLoadValues) THEN																																(* Display motor load value? *)
						AsIOAccWriteReg_0.value:= BIT_SET(AsIOAccWriteReg_0.value, 7);																								(* Set bit to activate display motor load value. *)
					END_IF
	
					AsIOAccWriteReg_0(enable:=1, size:=4);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							intern.StateMan := 20;																																											(* Next XSM step. *)
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status:= AsIOAccWriteReg_0.status;																																					(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				
				END_IF
	
			(* IO Configuration - XSM IO_Cfg - Holding current [%]. *)
			20:
	
				IF ((IO_Cfg.Current.Holding > IO_Cfg.Current.Rated) OR (IO_Cfg.Current.Holding > IO_Cfg.Current.Maximum)) THEN		(* Invalid value? *)																																							(*  *)
					Status := 50220;																																																(* HoldingCurrent_Invalid *)
	
				ELSIF (IO_Cfg.Current.Holding < 0) THEN																																						(* Zero? *)
					Status := 50300;																																																(* HoldingCurrent_Zero *)
	
				END_IF
	
				CASE (intern.IO_Mapping.ModuleID) OF
	
					9857:	(* X20SM1426 *)
						IF (IO_Cfg.Current.Holding > 1.20) THEN																																				(* > 1.20A? *)
							Status := 50303;																																														(* HoldingCurrent > 1.2A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Holding);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Holding);																(* Convert required A to %. *)
						#endif
						END_IF
	
					9858:	(* X20SM1436 *)
						IF (IO_Cfg.Current.Holding > 3.50) THEN																																				(* > 3.50A? *)
							Status := 50306;																																														(* HoldingCurrent > 3.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Holding);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Holding);																(* Convert required A to %. *)
						#endif
						END_IF
	
					7627:	(* X67SM2436 *)
						IF (IO_Cfg.Current.Holding > 5.00) THEN																																				(* > 5.00A? *)
							Status := 50309;																																														(* HoldingCurrent > 5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Holding);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Holding);																(* Convert required A to %. *)
						#endif
						END_IF
	
					7628:	(* X67SM4320 *)
						IF (IO_Cfg.Current.Holding > 1.50) THEN																																				(* > 1.50A? *)
							Status := 50312;																																														(* HoldingCurrent > 1.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Holding);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Holding);																(* Convert required A to %. *)
						#endif
						END_IF
	
					42148, 42414, 42880, 42881, 42882, 42893, 42894:																																(* ACOPOSmicro *)
						IF (IO_Cfg.Current.Holding > 15.0) THEN																																				(* > 15.0A? *)
							Status := 50315;																																														(* HoldingCurrent > 10.0A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Holding);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Holding);															(* Convert required A to %. *)
						#endif
						END_IF

				END_CASE
	
				IF (Status = ERR_FUB_BUSY) THEN																																										(* Holding current valid? *)
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'ConfigOutput03a';																															(* 1st motor channel selected. (Reg 48) *)
						2:			intern.ChannelName := 'ConfigOutput06a';																															(* 2nd motor channel selected. (Reg 112) *)
						3:			intern.ChannelName := 'ConfigOutput09a';																															(* 3rd motor channel selected. (Reg 176) *)
						4:			intern.ChannelName := 'ConfigOutput12a';																															(* 4th motor channel selected. (Reg 240) *)
					END_CASE
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 48;																																		(* 1st motor channel selected. (Reg 48) *)
						2:			AsIOAccWriteReg_0.registerNr:= 112;																																		(* 2nd motor channel selected. (Reg 112) *)
						3:			AsIOAccWriteReg_0.registerNr:= 176;																																		(* 3rd motor channel selected. (Reg 176) *)
						4:			AsIOAccWriteReg_0.registerNr:= 240;																																		(* 4th motor channel selected. (Reg 240) *)
					END_CASE
	
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
	
				END_IF
	
			(* IO Configuration - XSM IO_Cfg - Rated current [%]. *)
			21:
	
				IF ((IO_Cfg.Current.Rated < IO_Cfg.Current.Holding) OR (IO_Cfg.Current.Rated > IO_Cfg.Current.Maximum)) THEN			(* Invalid value? *)																																							(*  *)
					Status := 50221;																																																(* RatedCurrent_Invalid *)
	
				ELSIF (IO_Cfg.Current.Rated <= 0) THEN																																						(* Zero? *)
					Status := 50301;																																																(* HoldingCurrent_Zero *)
	
				END_IF
	
				CASE (intern.IO_Mapping.ModuleID) OF
	
					9857:	(* X20SM1426 *)
						IF (IO_Cfg.Current.Holding > 1.20) THEN																																				(* > 1.20A? *)
							Status := 50303;																																														(* HoldingCurrent > 1.2A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Rated);																		(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Rated);																	(* Convert required A to %. *)
						#endif
						END_IF
	
					9858:	(* X20SM1436 *)
						IF (IO_Cfg.Current.Holding > 3.50) THEN																																				(* > 3.50A? *)
							Status := 50306;																																														(* HoldingCurrent > 3.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Rated);																		(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Rated);																	(* Convert required A to %. *)
						#endif
						END_IF
	
					7627:	(* X67SM2436 *)
						IF (IO_Cfg.Current.Holding > 5.00) THEN																																				(* > 5.00A? *)
							Status := 50309;																																														(* HoldingCurrent > 5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Rated);																		(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Rated);																	(* Convert required A to %. *)
						#endif
						END_IF
	
					7628:	(* X67SM4320 *)
						IF (IO_Cfg.Current.Holding > 1.50) THEN																																				(* > 1.50A? *)
							Status := 50312;																																														(* HoldingCurrent > 1.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Rated);																		(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Rated);																	(* Convert required A to %. *)
						#endif
						END_IF
	
					42148, 42414, 42880, 42881, 42882, 42893, 42894:																																(* ACOPOSmicro *)
						IF (IO_Cfg.Current.Holding > 15.0) THEN																																				(* > 15.0A? *)
							Status := 50315;																																														(* HoldingCurrent > 10.0A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Rated);																		(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Rated);																(* Convert required A to %. *)
						#endif
						END_IF

				END_CASE
	
				IF (Status = ERR_FUB_BUSY) THEN																																										(* Rated current valid? *)

				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'ConfigOutput04a';																															(* 1st motor channel selected. (Reg 49) *)
						2:			intern.ChannelName := 'ConfigOutput07a';																															(* 2nd motor channel selected. (Reg 113) *)
						3:			intern.ChannelName := 'ConfigOutput10a';																															(* 3rd motor channel selected. (Reg 177) *)
						4:			intern.ChannelName := 'ConfigOutput13a';																															(* 4th motor channel selected. (Reg 241) *)
					END_CASE
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 49;																																		(* 1st motor channel selected. (Reg 49) *)
						2:			AsIOAccWriteReg_0.registerNr:= 113;																																		(* 2nd motor channel selected. (Reg 113) *)
						3:			AsIOAccWriteReg_0.registerNr:= 177;																																		(* 3rd motor channel selected. (Reg 177) *)
						4:			AsIOAccWriteReg_0.registerNr:= 241;																																		(* 4th motor channel selected. (Reg 241) *)
					END_CASE
	
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				
				END_IF
	
			(* IO Configuration - XSM IO_Cfg - Maximum current [%]. *)
			22:
	
				IF ((IO_Cfg.Current.Maximum < IO_Cfg.Current.Holding) OR (IO_Cfg.Current.Maximum < IO_Cfg.Current.Rated)) THEN		(* Invalid value? *)																																							(*  *)
					Status := 50222;																																																(* MaximumCurrent_Invalid *)
	
				ELSIF (IO_Cfg.Current.Maximum <= 0) THEN																																					(* Zero? *)
					Status := 50302;																																																(* MaximumCurrent_Zero *)
	
				END_IF
	
				CASE (intern.IO_Mapping.ModuleID) OF
	
					9857:	(* X20SM1426 *)
						IF (IO_Cfg.Current.Holding > 1.20) THEN																																				(* > 1.20A? *)
							Status := 50303;																																														(* HoldingCurrent > 1.2A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Maximum);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Maximum);																(* Convert required A to %. *)
						#endif
						END_IF
	
					9858:	(* X20SM1436 *)
						IF (IO_Cfg.Current.Holding > 3.50) THEN																																				(* > 3.50A? *)
							Status := 50306;																																														(* HoldingCurrent > 3.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Maximum);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Maximum);																(* Convert required A to %. *)
						#endif
						END_IF
	
					7627:	(* X67SM2436 *)
						IF (IO_Cfg.Current.Holding > 5.00) THEN																																				(* > 5.00A? *)
							Status := 50309;																																														(* HoldingCurrent > 5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Maximum);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/3.0) * IO_Cfg.Current.Maximum);																(* Convert required A to %. *)
						#endif
						END_IF
	
					7628:	(* X67SM4320 *)
						IF (IO_Cfg.Current.Holding > 1.50) THEN																																				(* > 1.50A? *)
							Status := 50312;																																														(* HoldingCurrent > 1.5A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Maximum);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/1.0) * IO_Cfg.Current.Maximum);																(* Convert required A to %. *)
						#endif
						END_IF
	
					42148, 42414, 42880, 42881, 42882, 42893, 42894:																																(* ACOPOSmicro *)
						IF (IO_Cfg.Current.Holding > 15.0) THEN																																				(* > 15.0A? *)
							Status := 50315;																																														(* HoldingCurrent > 10.0A *)
						ELSE																																																					(* Valid, workout required % *)
						#ifdef _SG4
							AsIOAccWrite_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Maximum);																	(* Convert required A to %. *)
						#endif
						#ifdef _SGC
							AsIOAccWriteReg_0.value := REAL_TO_UDINT((100/10.0) * IO_Cfg.Current.Maximum);															(* Convert required A to %. *)
						#endif
						END_IF

				END_CASE
	
				IF (Status = ERR_FUB_BUSY) THEN																																										(* Maximum current valid? *)
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'ConfigOutput05a';																															(* 1st motor channel selected. (Reg 50) *)
						2:			intern.ChannelName := 'ConfigOutput08a';																															(* 2nd motor channel selected. (Reg 114) *)
						3:			intern.ChannelName := 'ConfigOutput11a';																															(* 3rd motor channel selected. (Reg 178) *)
						4:			intern.ChannelName := 'ConfigOutput14a';																															(* 4th motor channel selected. (Reg 242) *)
					END_CASE
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 30;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 50;																																		(* 1st motor channel selected. (Reg 50) *)
						2:			AsIOAccWriteReg_0.registerNr:= 114;																																		(* 2nd motor channel selected. (Reg 114) *)
						3:			AsIOAccWriteReg_0.registerNr:= 178;																																		(* 3rd motor channel selected. (Reg 178) *)
						4:			AsIOAccWriteReg_0.registerNr:= 242;																																		(* 4th motor channel selected. (Reg 242) *)
					END_CASE
	
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							intern.StateMan := 30;																																											(* Next XSM step. *)
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	

				END_IF
	
			(* IO Configuration - Full Step Threshold. *)
			30:
	
				IF (intern.IO_Mapping.ModuleID = 7628) THEN																																				(* X67SM4320 not supported. *)
					intern.StateMan := 50;																																													(* Next XSM step. *)
	
				ELSE
				
				IF (IO_Cfg.FullStepThreshold = 0) THEN																																						(* Default? *)
					IO_Cfg.FullStepThreshold := 65535;																																							(* Set to 256 micro stepping mode. *)
				END_IF

				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'FullStepThreshold01';																													(* 1st motor channel selected. (Reg 72) *)
						2:			intern.ChannelName := 'FullStepThreshold02';																													(* 2nd motor channel selected. (Reg 136) *)
(*						3:			intern.ChannelName := 'FullStepThreshold03'; - not used yet *)																				(* 3rd motor channel selected. (Reg ???) *)
(*						4:			intern.ChannelName := 'FullStepThreshold04'; - not used yet *)																				(* 4th motor channel selected. (Reg ???) *)
					END_CASE
	
					AsIOAccWrite_0.value := UINT_TO_UDINT(IO_Cfg.FullStepThreshold);																								(* Convert required value for full step threshold. *)
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 50;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 72;																																		(* 1st motor channel selected. (Reg 72) *)
						2:			AsIOAccWriteReg_0.registerNr:= 136;																																		(* 2nd motor channel selected. (Reg 136) *)
(*						3:			AsIOAccWriteReg_0.registerNr:= ???; - not used yet *)																								(* 3rd motor channel selected. (Reg ???) *)
(*						4:			AsIOAccWriteReg_0.registerNr:= ???; - not used yet *)																								(* 4th motor channel selected. (Reg ???) *)
					END_CASE
	
					AsIOAccWriteReg_0.value := UINT_TO_UDINT(IO_Cfg.FullStepThreshold);																							(* Convert required value for full step threshold. *)
					AsIOAccWriteReg_0(enable:=1, size:=2);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							intern.StateMan := 50;																																											(* Next XSM step. *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 50;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				
				END_IF
	
			(* IO Configuration - Referencing Configuration. *)
			50:
	
				CASE (IO_Cfg.RefCfg.ReferencingConfiguration) OF
	
					0:	(* Positive edge. *)
						#ifdef _SG4
						AsIOAccWrite_0.value := SINT_TO_UDINT(-125);																																	(* Convert required value for positive edge detection. *)
						#endif
						#ifdef _SGC
						AsIOAccWriteReg_0.value := SINT_TO_UDINT(-125);																																(* Convert required value for positive edge detection. *)
						#endif
					1:	(* Negative edge. *)
						#ifdef _SG4
						AsIOAccWrite_0.value := SINT_TO_UDINT(-126);																																	(* Convert required value for negative edge detection. *)
						#endif
						#ifdef _SGC
						AsIOAccWriteReg_0.value := SINT_TO_UDINT(-126);																																(* Convert required value for positive edge detection. *)
						#endif
	
					2:	(* Homed when stall detected. *)
						IF ((intern.IO_Mapping.ModuleID = 42148) OR (intern.IO_Mapping.ModuleID = 42414) OR (intern.IO_Mapping.ModuleID = 42880) OR
							  (intern.IO_Mapping.ModuleID = 42881) OR (intern.IO_Mapping.ModuleID = 42882) OR (intern.IO_Mapping.ModuleID = 42893) OR
								(intern.IO_Mapping.ModuleID = 42894)) THEN																																(* Not supported on ACOPOSmicro. *)
							Status := 50251;																																														(* Stall homing mode not supported. *)
						ELSE
							#ifdef _SG4
							AsIOAccWrite_0.value := SINT_TO_UDINT(-127);																																(* Convert required value for stall detection. *)
							#endif
							#ifdef _SGC
							AsIOAccWriteReg_0.value := SINT_TO_UDINT(-127);																																(* Convert required value for positive edge detection. *)
							#endif
						END_IF
					3:	(* Immediate/Direct homing. *)
						#ifdef _SG4
						AsIOAccWrite_0.value := SINT_TO_UDINT(-128);																																	(* Convert required value for immediate/direct homing.. *)
						#endif
						#ifdef _SGC
						AsIOAccWriteReg_0.value := SINT_TO_UDINT(-128);																																(* Convert required value for positive edge detection. *)
						#endif
	
					ELSE
						Status := 50250;																																															(* Invalid homing mode. *)
	
				END_CASE
	
				IF (Status = ERR_FUB_BUSY) THEN																																										(* Maximum current valid? *)
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'RefConfig01';																																	(* 1st motor channel selected. (Reg 70) *)
						2:			intern.ChannelName := 'RefConfig02';																																	(* 2nd motor channel selected. (Reg 134) *)
						3:			intern.ChannelName := 'RefConfig03';																																	(* 3rd motor channel selected. (Reg 198) *)
						4:			intern.ChannelName := 'RefConfig04';																																	(* 4th motor channel selected. (Reg 262) *)
					END_CASE
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 51;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 70;																																		(* 1st motor channel selected. (Reg 70) *)
						2:			AsIOAccWriteReg_0.registerNr:= 134;																																		(* 2nd motor channel selected. (Reg 134) *)
						3:			AsIOAccWriteReg_0.registerNr:= 198;																																		(* 3rd motor channel selected. (Reg 198) *)
						4:			AsIOAccWriteReg_0.registerNr:= 262;																																		(* 4th motor channel selected. (Reg 262) *)
					END_CASE
	
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 51;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	

				END_IF
	
			(* IO Configuration - StallRecognitionDelay01 Stall Detection Delay (units of 25ms). *)
			51:
				IF ((intern.IO_Mapping.ModuleID = 42148) OR (intern.IO_Mapping.ModuleID = 42414) OR (intern.IO_Mapping.ModuleID = 42880) OR
					  (intern.IO_Mapping.ModuleID = 42881) OR (intern.IO_Mapping.ModuleID = 42882) OR (intern.IO_Mapping.ModuleID = 42893) OR
						(intern.IO_Mapping.ModuleID = 42894)) THEN																																		(* Not supported on ACOPOSmicro. *)
					intern.StateMan := 60;																																													(* Next XSM step. *)
	
				ELSE
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'StallRecognitionDelay01';																											(* 1st motor channel selected. (Reg 74) *)
						2:			intern.ChannelName := 'StallRecognitionDelay02';																											(* 2nd motor channel selected. (Reg 138) *)
						3:			intern.ChannelName := 'StallRecognitionDelay03';																											(* 3rd motor channel selected. (Reg 202) *)
						4:			intern.ChannelName := 'StallRecognitionDelay04';																											(* 4th motor channel selected. (Reg 266) *)
					END_CASE
	
					AsIOAccWrite_0.value := USINT_TO_UDINT(IO_Cfg.RefCfg.StallRecongnitionDelay);																		(* Convert required value for stall detection delayfor homing.. *)
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 60;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 74;																																		(* 1st motor channel selected. (Reg 74) *)
						2:			AsIOAccWriteReg_0.registerNr:= 138;																																		(* 2nd motor channel selected. (Reg 138) *)
						3:			AsIOAccWriteReg_0.registerNr:= 202;																																		(* 3rd motor channel selected. (Reg 202) *)
						4:			AsIOAccWriteReg_0.registerNr:= 266;																																		(* 4th motor channel selected. (Reg 266) *)
					END_CASE
	
					AsIOAccWriteReg_0.value := USINT_TO_UDINT(IO_Cfg.RefCfg.StallRecongnitionDelay);																(* Convert required value for stall detection delayfor homing.. *)
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							IF ((Mode = 0) OR (intern.Cfg_State = 255)) THEN																														(* Write all configuration values to XMS module? *)
								intern.StateMan := 60;																																										(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
					
				END_IF
	
			(* IO Configuration - Maximum speed. *)
			60:
				IF (IO_Cfg.MPGen.MaxSpeed <= 0) THEN																																							(* Maximum speed invalid? *)
	
					Status := 50260;																																																(* MaximumSpeed_Invalid *)
	
				ELSE
	
				#ifdef _SG4	
					IF (intern.IO_Mapping.ModuleID = 7628) THEN																																			(* X67SM4320 fitted? *)
						CASE (intern.IO_Mapping.Channel) OF
							1:			intern.ChannelName := 'MaxSpeed01';																																	(* X67SM4320 1st motor channel selected.*)
							2:			intern.ChannelName := 'MaxSpeed02';																																	(* X67SM4320 2nd motor channel selected.*)
							3:			intern.ChannelName := 'MaxSpeed03';																																	(* X67SM4320 3rd motor channel selected.*)
							4:			intern.ChannelName := 'MaxSpeed04';																																	(* X67SM4320 4th motor channel selected.*)
						END_CASE
					ELSE
						CASE (intern.IO_Mapping.Channel) OF
							0..1:		intern.ChannelName := 'MaxSpeed01pos';																															(* 1st motor channel selected. (Reg 52) *)
							2:			intern.ChannelName := 'MaxSpeed02pos';																															(* 2nd motor channel selected. (Reg 116) *)
							3:			intern.ChannelName := 'MaxSpeed03pos';																															(* 3rd motor channel selected. (Reg 180) *)
							4:			intern.ChannelName := 'MaxSpeed03pos';																															(* 4th motor channel selected. (Reg 244) *)
						END_CASE
					END_IF
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxSpeed)/40.0);	(* Scale from units/s to uSteps/25ms. *)
	
					IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWrite_0.value := 65535;																																								(* Set to maximum. (16#FFFF = 65535) *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
					END_IF
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
	
							IF ((Mode = 0) OR (Mode = 60) OR (Mode = 62) OR (intern.Cfg_State = 255)) THEN															(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
	
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 52;																																		(* 1st motor channel selected. (Reg 52) *)
						2:			AsIOAccWriteReg_0.registerNr:= 116;																																		(* 2nd motor channel selected. (Reg 116) *)
						3:			AsIOAccWriteReg_0.registerNr:= 180;																																		(* 3rd motor channel selected. (Reg 180) *)
						4:			AsIOAccWriteReg_0.registerNr:= 244;																																		(* 4th motor channel selected. (Reg 244) *)
					END_CASE
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxSpeed)/40.0);	(* Scale from units/s to uSteps/25ms. *)
	
					IF ((AsIOAccWriteReg_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWriteReg_0.value := 65535;																																							(* Set to maximum. (16#FFFF = 65535) *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																						(* Copy required write value. *)
					END_IF

					AsIOAccWriteReg_0(enable:=1, size:=2);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)

							IF ((Mode = 0) OR (Mode = 60) OR (Mode = 62) OR (intern.Cfg_State = 255)) THEN															(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF

						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
	
				END_IF
	
			(* IO Configuration - Maximum acceleration. *)
			61:
				IF (IO_Cfg.MPGen.MaxAcc <= 0) THEN																																								(* Maximum acceleration invalid? *)
	
					Status := 50261;																																																(* MaxAcc_Invalid *)
	
				ELSE
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'MaxAcc01';																																			(* 1st motor channel selected. (Reg 54) *)
						2:			intern.ChannelName := 'MaxAcc02';																																			(* 2nd motor channel selected. (Reg 118) *)
						3:			intern.ChannelName := 'MaxAcc03';																																			(* 3rd motor channel selected. (Reg 182) *)
						4:			intern.ChannelName := 'MaxAcc04';																																			(* 4th motor channel selected. (Reg 246) *)
					END_CASE
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxAcc)/1600.0);	(* Scale from units/s/s to uSteps/25ms². *)
					IF (intern.AsIOAccWriteValue < 1) THEN																																					(* Acc less than 1 unit? *)
						intern.AsIOAccWriteValue := 1;																																								(* Set Acc to 1 unit? *)
					END_IF

					IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWrite_0.value := 65535;																																								(* Set to maximum. *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
					END_IF
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
	
							IF ((Mode = 0) OR (Mode = 60) OR (Mode = 62) OR (intern.Cfg_State = 255)) THEN															(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
	
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 54;																																		(* 1st motor channel selected. (Reg 54) *)
						2:			AsIOAccWriteReg_0.registerNr:= 118;																																		(* 2nd motor channel selected. (Reg 118) *)
						3:			AsIOAccWriteReg_0.registerNr:= 182;																																		(* 3rd motor channel selected. (Reg 182) *)
						4:			AsIOAccWriteReg_0.registerNr:= 246;																																		(* 4th motor channel selected. (Reg 246) *)
					END_CASE
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxAcc)/1600.0);	(* Scale from units/s/s to uSteps/25ms². *)
					IF (intern.AsIOAccWriteValue < 1) THEN																																					(* Acc less than 1 unit? *)
						intern.AsIOAccWriteValue := 1;																																								(* Set Acc to 1 unit? *)
					END_IF
	
					IF ((AsIOAccWriteReg_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWriteReg_0.value := 65535;																																							(* Set to maximum. (16#FFFF = 65535) *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																						(* Copy required write value. *)
					END_IF

					AsIOAccWriteReg_0(enable:=1, size:=2);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)

							IF ((Mode = 0) OR (Mode = 60) OR (Mode = 62) OR (intern.Cfg_State = 255)) THEN															(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF

						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
	
				END_IF
	
			(* IO Configuration - Maximum deceleration. *)
			62:
				IF (IO_Cfg.MPGen.MaxDec <= 0) THEN																																								(* Maximum acceleration invalid? *)
	
					Status := 50262;																																																(* MaxDec_Invalid *)
	
				ELSE
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'MaxDec01';																																			(* 1st motor channel selected. (Reg 56) *)
						2:			intern.ChannelName := 'MaxDec02';																																			(* 2nd motor channel selected. (Reg 120) *)
						3:			intern.ChannelName := 'MaxDec03';																																			(* 3rd motor channel selected. (Reg 184) *)
						4:			intern.ChannelName := 'MaxDec04';																																			(* 4th motor channel selected. (Reg 248) *)
					END_CASE
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxDec)/1600.0);	(* Scale from units/s to uSteps/25ms². *)
					IF (intern.AsIOAccWriteValue < 1) THEN																																					(* Dec less than 1 unit? *)
						intern.AsIOAccWriteValue := 1;																																								(* Set Dec to 1 unit? *)
					END_IF
	
					IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWrite_0.value := 65535;																																								(* Set to maximum. *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
					END_IF
	
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
	
							IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																							(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF
	
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		AsIOAccWriteReg_0.registerNr:= 56;																																		(* 1st motor channel selected. (Reg 56) *)
						2:			AsIOAccWriteReg_0.registerNr:= 120;																																		(* 2nd motor channel selected. (Reg 120) *)
						3:			AsIOAccWriteReg_0.registerNr:= 184;																																		(* 3rd motor channel selected. (Reg 184) *)
						4:			AsIOAccWriteReg_0.registerNr:= 248;																																		(* 4th motor channel selected. (Reg 248) *)
					END_CASE
	
					intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (UINT_TO_REAL(IO_Cfg.MPGen.MaxDec)/1600.0);	(* Scale from units/s to uSteps/25ms². *)
					IF (intern.AsIOAccWriteValue < 1) THEN																																					(* Dec less than 1 unit? *)
						intern.AsIOAccWriteValue := 1;																																								(* Set Dec to 1 unit? *)
					END_IF
	
					IF ((AsIOAccWriteReg_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535) OR (intern.AsIOAccWriteValue < 0))) THEN	 (* Overflow? *)
						IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																(* Already recorded 4 overflow states? *)
							intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);															(* Make number negative and show number of overflow's occured + 4 recorded. *)
						ELSE
							intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																	(* Recorded which step where overflow occured. *)
						END_IF
						AsIOAccWriteReg_0.value := 65535;																																							(* Set to maximum. (16#FFFF = 65535) *)
					ELSE																																																						(* Write value not overflowed. *)
						AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																						(* Copy required write value. *)
					END_IF

					AsIOAccWriteReg_0(enable:=1, size:=2);																																					(* Write to register. *)
	
					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)

							IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																							(* Write all configuration values to XMS module? *)
								intern.StateMan := intern.StateMan + 1;																																		(* Next XSM step. *)
							ELSE
								Done						:= 1;																																											(* Set Done flag. *)
								intern.StateMan := 0;																																											(* Wait for new command. *)
							END_IF

						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWriteReg_0.status;																																(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif
	
				END_IF
	
			(* IO Configuration - RevLoop (Turn-around loop). *)
			63:
			#ifdef _SG4	
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'RevLoop01';																																			(* 1st motor channel selected. (Reg 58) *)
					2:			intern.ChannelName := 'RevLoop02';																																			(* 2nd motor channel selected. (Reg 122) *)
					3:			intern.ChannelName := 'RevLoop03';																																			(* 3rd motor channel selected. (Reg 186) *)
					4:			intern.ChannelName := 'RevLoop04';																																			(* 4th motor channel selected. (Reg 250) *)
				END_CASE
	
				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.RevLoop));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 32767) OR (intern.AsIOAccWriteValue < -32768) OR (* Overflow *)
	 					((IO_Cfg.MPGen.RevLoop > 0) AND (intern.AsIOAccWriteValue < 0))) OR																						(* Positive overflow? *)
						((IO_Cfg.MPGen.RevLoop < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																					(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.RevLoop > 0) THEN																																							(* Positive overflow? *)
						AsIOAccWrite_0.value := 32767;																																								(* Set to maximum. *)
					ELSIF (IO_Cfg.MPGen.RevLoop < 0) THEN																																						(* Negitive overflow? *)
						AsIOAccWrite_0.value := 32768;																																								(* Set to maximum. *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																								(* Copy required write value. *)
				END_IF
	
				AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
				IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																		(* Function done? *)
					IF (AsIOAccWrite_0.status = ERR_OK) THEN																																				(* No error? *)
						intern.StateMan := intern.StateMan + 1;																																				(* Next XSM step. *)
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWrite_0.status;																																			(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
			#ifdef _SGC	
				CASE (intern.IO_Mapping.Channel) OF			
					0..1:		AsIOAccWriteReg_0.registerNr:= 58;																																			(* 1st motor channel selected. (Reg 58) *)
					2:			AsIOAccWriteReg_0.registerNr:= 122;																																			(* 2nd motor channel selected. (Reg 122) *)
					3:			AsIOAccWriteReg_0.registerNr:= 186;																																			(* 3rd motor channel selected. (Reg 186) *)
					4:			AsIOAccWriteReg_0.registerNr:= 250;																																			(* 4th motor channel selected. (Reg 250) *)
				END_CASE

				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.RevLoop));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 32767) OR (intern.AsIOAccWriteValue < -32768) OR (* Overflow *)
	 					((IO_Cfg.MPGen.RevLoop > 0) AND (intern.AsIOAccWriteValue < 0))) OR																						(* Positive overflow? *)
						((IO_Cfg.MPGen.RevLoop < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																					(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF

					IF (IO_Cfg.MPGen.RevLoop > 0) THEN																																							(* Positive overflow? *)
						AsIOAccWriteReg_0.value := 32767;																																							(* Set to maximum. *)
					ELSIF (IO_Cfg.MPGen.RevLoop < 0) THEN																																						(* Negitive overflow? *)
						AsIOAccWriteReg_0.value := 32768;																																							(* Set to maximum. *)
					END_IF

				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
				END_IF
	
				AsIOAccWriteReg_0(enable:=1, size:=2);																																						(* Write to register. *)

				IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																			(* No error? *)
						intern.StateMan := intern.StateMan + 1;																																				(* Next XSM step. *)
					ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN																(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																					(* Increament retries counter. *)					
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWriteReg_0.status;																																	(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
	
			(* IO Configuration - FixedPos_a (Set position 1). *)
			64:
			#ifdef _SG4	
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'FixedPos01a';																																		(* 1st motor channel selected. (Reg 60) *)
					2:			intern.ChannelName := 'FixedPos02a';																																		(* 2nd motor channel selected. (Reg 124) *)
					3:			intern.ChannelName := 'FixedPos03a';																																		(* 3rd motor channel selected. (Reg 188) *)
					4:			intern.ChannelName := 'FixedPos04a';																																		(* 4th motor channel selected. (Reg 252) *)
				END_CASE
	
				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.FixedPos_a));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 2147483647.0) OR (intern.AsIOAccWriteValue < -2147483648.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.FixedPos_a > 0) AND (intern.AsIOAccWriteValue < 0))) OR																				(* Positive overflow? *)
						((IO_Cfg.MPGen.FixedPos_a < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																			(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.FixedPos_a > 0) THEN																																						(* Positive overflow? *)
						AsIOAccWrite_0.value := 2147483647;																																						(* Set to maximum. *)
					ELSIF (IO_Cfg.MPGen.FixedPos_a < 0) THEN																																				(* Negitive overflow? *)
						AsIOAccWrite_0.value := -2147483648;																																					(* Set to maximum. *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																								(* Copy required write value. *)
				END_IF
	
				AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
				IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																		(* Function done? *)
					IF (AsIOAccWrite_0.status = ERR_OK) THEN																																				(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWrite_0.status;																																			(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
			#ifdef _SGC	
				CASE (intern.IO_Mapping.Channel) OF			
					0..1:		AsIOAccWriteReg_0.registerNr:= 60;																																			(* 1st motor channel selected. (Reg 60) *)
					2:			AsIOAccWriteReg_0.registerNr:= 124;																																			(* 2nd motor channel selected. (Reg 124) *)
					3:			AsIOAccWriteReg_0.registerNr:= 188;																																			(* 3rd motor channel selected. (Reg 188) *)
					4:			AsIOAccWriteReg_0.registerNr:= 252;																																			(* 4th motor channel selected. (Reg 252) *)
				END_CASE

				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.FixedPos_a));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 2147483647.0) OR (intern.AsIOAccWriteValue < -2147483648.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.FixedPos_a > 0) AND (intern.AsIOAccWriteValue < 0))) OR																				(* Positive overflow? *)
						((IO_Cfg.MPGen.FixedPos_a < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																			(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.FixedPos_a > 0) THEN																																						(* Positive overflow? *)
						AsIOAccWriteReg_0.value := 2147483647;																																				(* Set to maximum. *)
					ELSIF (IO_Cfg.MPGen.FixedPos_a < 0) THEN																																				(* Negitive overflow? *)
						AsIOAccWriteReg_0.value := -2147483648;																																				(* Set to maximum. *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
				END_IF

				AsIOAccWriteReg_0(enable:=1, size:=4);																																						(* Write to register. *)
	
				IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																			(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN																(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																					(* Increament retries counter. *)					
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWriteReg_0.status;																																	(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
	
			(* IO Configuration - FixedPos_b (Set position 2). *)
			65:
			#ifdef _SG4	
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'FixedPos01b';																																		(* 1st motor channel selected. (Reg 64) *)
					2:			intern.ChannelName := 'FixedPos02b';																																		(* 2nd motor channel selected. (Reg 128) *)
					3:			intern.ChannelName := 'FixedPos03b';																																		(* 3rd motor channel selected. (Reg 192) *)
					4:			intern.ChannelName := 'FixedPos04b';																																		(* 4th motor channel selected. (Reg 256) *)
				END_CASE
	
				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.FixedPos_b));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 2147483647.0) OR (intern.AsIOAccWriteValue < -2147483648.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.FixedPos_b > 0) AND (intern.AsIOAccWriteValue < 0))) OR																				(* Positive overflow? *)
						((IO_Cfg.MPGen.FixedPos_b < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																			(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.FixedPos_b > 0) THEN																																						(* Positive overflow? *)
						AsIOAccWrite_0.value := 2147483647;																																						(* Set to maximum. (16#7FFF_FFFF = 2,147,483,647) *)
					ELSIF (IO_Cfg.MPGen.FixedPos_b < 0) THEN																																				(* Negitive overflow? *)
						AsIOAccWrite_0.value := -2147483648;																																					(* Set to maximum. (16#8000_0000 = -2,147,483,648) *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																								(* Copy required write value. *)
				END_IF
	
				AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
				IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																		(* Function done? *)
					IF (AsIOAccWrite_0.status = ERR_OK) THEN																																				(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWrite_0.status;																																			(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
			#ifdef _SGC	
				CASE (intern.IO_Mapping.Channel) OF			
					0..1:		AsIOAccWriteReg_0.registerNr:= 64;																																			(* 1st motor channel selected. (Reg 64) *)
					2:			AsIOAccWriteReg_0.registerNr:= 128;																																			(* 2nd motor channel selected. (Reg 128) *)
					3:			AsIOAccWriteReg_0.registerNr:= 192;																																			(* 3rd motor channel selected. (Reg 192) *)
					4:			AsIOAccWriteReg_0.registerNr:= 256;																																			(* 4th motor channel selected. (Reg 256) *)
				END_CASE

				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.FixedPos_b));	(* Scale from units to uSteps. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 2147483647.0) OR (intern.AsIOAccWriteValue < -2147483648.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.FixedPos_b > 0) AND (intern.AsIOAccWriteValue < 0))) OR																				(* Positive overflow? *)
						((IO_Cfg.MPGen.FixedPos_b < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																			(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.FixedPos_b > 0) THEN																																						(* Positive overflow? *)
						AsIOAccWrite_0.value := 2147483647;																																						(* Set to maximum. (16#7FFF_FFFF = 2,147,483,647) *)
					ELSIF (IO_Cfg.MPGen.FixedPos_b < 0) THEN																																				(* Negitive overflow? *)
						AsIOAccWrite_0.value := -2147483648;																																					(* Set to maximum. (16#8000_0000 = -2,147,483,648) *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
				END_IF

				AsIOAccWriteReg_0(enable:=1, size:=4);																																						(* Write to register. *)
	
				IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																			(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN																(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																					(* Increament retries counter. *)					
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWriteReg_0.status;																																	(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
	
			(* IO Configuration - Referencing Speed. *)
			66:
			#ifdef _SG4	
				CASE (intern.IO_Mapping.Channel) OF
					0..1:		intern.ChannelName := 'RefSpeed01';																																			(* 1st motor channel selected. (Reg 68) *)
					2:			intern.ChannelName := 'RefSpeed02';																																			(* 2nd motor channel selected. (Reg 132) *)
					3:			intern.ChannelName := 'RefSpeed03';																																			(* 3rd motor channel selected. (Reg 196) *)
					4:			intern.ChannelName := 'RefSpeed04';																																			(* 4th motor channel selected. (Reg 260) *)
				END_CASE
	
				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.RefSpeed)/40.0);	(* Scale from units/s to uSteps/25ms. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535.0) OR (intern.AsIOAccWriteValue < -65535.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.RefSpeed > 0) AND (intern.AsIOAccWriteValue < 0))) OR																					(* Positive overflow? *)
						((IO_Cfg.MPGen.RefSpeed < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																				(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.RefSpeed > 0) THEN																																							(* Positive overflow? *)
						AsIOAccWrite_0.value := 65535;																																								(* Set to maximum. (16#FFFF = 65535) *)
					ELSIF (IO_Cfg.MPGen.RefSpeed < 0) THEN																																					(* Negitive overflow? *)
						AsIOAccWrite_0.value := -65535;																																								(* Set to maximum. (16# = -65535) *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWrite_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																								(* Copy required write value. *)
				END_IF
	
				AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
				IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																		(* Function done? *)
					IF (AsIOAccWrite_0.status = ERR_OK) THEN																																				(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWrite_0.status;																																			(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
			#ifdef _SGC	
				CASE (intern.IO_Mapping.Channel) OF			
					0..1:		AsIOAccWriteReg_0.registerNr:= 68;																																			(* 1st motor channel selected. (Reg 68) *)
					2:			AsIOAccWriteReg_0.registerNr:= 132;																																			(* 2nd motor channel selected. (Reg 132) *)
					3:			AsIOAccWriteReg_0.registerNr:= 196;																																			(* 3rd motor channel selected. (Reg 196) *)
					4:			AsIOAccWriteReg_0.registerNr:= 260;																																			(* 4th motor channel selected. (Reg 260) *)
				END_CASE

				intern.AsIOAccWriteValue := (51200/UINT_TO_REAL(intern.Parameters.Units_rev)) * (DINT_TO_REAL(IO_Cfg.MPGen.RefSpeed)/40.0);	(* Scale from units/s to uSteps/25ms. *)
	
				IF ((AsIOAccWrite_0.status = ERR_OK) AND ((intern.AsIOAccWriteValue > 65535.0) OR (intern.AsIOAccWriteValue < -65535.0) OR (* Overflow *)
	 					((IO_Cfg.MPGen.RefSpeed > 0) AND (intern.AsIOAccWriteValue < 0))) OR																					(* Positive overflow? *)
						((IO_Cfg.MPGen.RefSpeed < 0) AND (intern.AsIOAccWriteValue > 0))) THEN																				(* Negative overflow? *)
	
					IF ((intern.OverflowWarning > 1_00_00_00) OR (intern.OverflowWarning < 0)) THEN																	(* Already recorded 4 overflow states? *)
						intern.OverflowWarning := ((ABS(intern.OverflowWarning) + 1_00_00_00_00) * -1);																(* Make number negative and show number of overflow's occured + 4 recorded. *)
					ELSE
						intern.OverflowWarning := (intern.OverflowWarning * 100) + intern.StateMan;																		(* Recorded which step where overflow occured. *)
					END_IF
	
					IF (IO_Cfg.MPGen.RefSpeed > 0) THEN																																							(* Positive overflow? *)
						AsIOAccWriteReg_0.value := 65535;																																							(* Set to maximum. (16#FFFF = 65535) *)
					ELSIF (IO_Cfg.MPGen.RefSpeed < 0) THEN																																					(* Negitive overflow? *)
						AsIOAccWriteReg_0.value := -65535;																																						(* Set to maximum. (16# = -65535) *)
					END_IF
	
				ELSE																																																							(* Write value not overflowed. *)
					AsIOAccWriteReg_0.value := REAL_TO_UDINT(intern.AsIOAccWriteValue);																							(* Copy required write value. *)
				END_IF

				AsIOAccWriteReg_0(enable:=1, size:=2);																																						(* Write to register. *)
	
				IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																																(* Function done? *)
					IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																			(* No error? *)
	
						IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																								(* Write all configuration values to XMS module? *)
							intern.StateMan := intern.StateMan + 1;																																			(* Next XSM step. *)
						ELSE
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						END_IF
	
					ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN																(* Access error? try again upto 2 times. *)
						intern.Retries:= intern.Retries + 1;																																					(* Increament retries counter. *)					
					ELSE																																																						(* AsIOAccRead Error? *)
						Status					:= AsIOAccWriteReg_0.status;																																	(* Copy AsIOAccWrite status. *)
					END_IF
				END_IF
			#endif	
	
			(* IO Configuration - Jolt time limitation. *)
			67:
				IF (IO_Cfg.MPGen.JoltTimeLimitation > 16) THEN																																		(* Jolt Time Limitation invalid? *)
	
					Status := 50267;																																																(* JoltTimeLimitation_Invalid *)
	
				ELSE
	
				#ifdef _SG4	
					CASE (intern.IO_Mapping.Channel) OF
						0..1:		intern.ChannelName := 'JoltTime01';																																		(* 1st motor channel selected. (Reg 75) *)
						2:			intern.ChannelName := 'JoltTime02';																																		(* 2nd motor channel selected. (Reg 139) *)
						3:			intern.ChannelName := 'JoltTime03';																																		(* 3rd motor channel selected. (Reg 203) *)
						4:			intern.ChannelName := 'JoltTime04';																																		(* 4th motor channel selected. (Reg 267) *)
					END_CASE
	
					AsIOAccWrite_0.value := SINT_TO_UDINT(IO_Cfg.MPGen.JoltTimeLimitation);																					(* Required value. *)
					AsIOAccWrite_0(enable:=1, pDeviceName:=ADR(intern.IO_Mapping.DeviceName), pChannelName:=ADR(intern.ChannelName));	(* Write to register. *)
	
					IF (AsIOAccWrite_0.status <> ERR_FUB_BUSY) THEN																																	(* Function done? *)
						IF (AsIOAccWrite_0.status = ERR_OK) THEN																																			(* No error? *)
							IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																							(* Module power back on? *)
								intern.Cfg_State := 1;																																										(* Reset IO Cfg Done flag. *)
							END_IF
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
				#ifdef _SGC	
					CASE (intern.IO_Mapping.Channel) OF			
						0..1:		AsIOAccWriteReg_0.registerNr:= 75;																																		(* 1st motor channel selected. (Reg 75) *)
						2:			AsIOAccWriteReg_0.registerNr:= 139;																																		(* 2nd motor channel selected. (Reg 139) *)
						3:			AsIOAccWriteReg_0.registerNr:= 203;																																		(* 3rd motor channel selected. (Reg 203) *)
						4:			AsIOAccWriteReg_0.registerNr:= 267;																																		(* 4th motor channel selected. (Reg 267) *)
					END_CASE

					AsIOAccWriteReg_0.value := SINT_TO_UDINT(IO_Cfg.MPGen.JoltTimeLimitation);																			(* Required value. *)
					AsIOAccWriteReg_0(enable:=1, size:=1);																																					(* Write to register. *)

					IF (AsIOAccWriteReg_0.status <> ERR_FUB_BUSY) THEN																															(* Function done? *)
						IF (AsIOAccWriteReg_0.status = ERR_OK) THEN																																		(* No error? *)
							IF ((Mode = 0) OR (Mode = 60) OR (intern.Cfg_State = 255)) THEN																							(* Module power back on? *)
								intern.Cfg_State := 1;																																										(* Reset IO Cfg Done flag. *)
							END_IF
							Done						:= 1;																																												(* Set Done flag. *)
							intern.StateMan := 0;																																												(* Wait for new command. *)
						ELSIF ((AsIOAccWriteReg_0.status = ioacERR_ACCESS) AND (intern.Retries < 2)) THEN															(* Access error? try again upto 2 times. *)
							intern.Retries:= intern.Retries + 1;																																				(* Increament retries counter. *)					
						ELSE																																																					(* AsIOAccRead Error? *)
							Status					:= AsIOAccWrite_0.status;																																		(* Copy AsIOAccWrite status. *)
						END_IF
					END_IF
				#endif	
	
				END_IF
	
			(* Error handling - Check reset flag is OFF. *)
			1000:
	
				IF (pIO_Mapping <> 0) THEN																																												(* Address non-Zero? *)
					memcpy(ADR(intern.IO_Mapping), pIO_Mapping, SIZEOF(intern.IO_Mapping));																					(* Get update intern.IO_Mapping data. *)
				ELSE																																																							(* Error? *)
					Status := 50202;																																																(* pintern.IO_Mapping_Invalid. *)
				END_IF
	
				IF ((intern.Cfg_State = 255) AND (intern.IO_Mapping.ModuleOK)) THEN																								(* Module power back on? *)
					Status						:= 0;																																													(* Reset status. *)
					intern.StateMan 	:= 0;																																													(* Wait for new command. *)
				ELSIF (NOT(Reset) AND (intern.Cfg_State <> 255))THEN																															(* Reset OFF? *)
					intern.StateMan := intern.StateMan + 1;																																					(* Next XSM step. *)
				END_IF
	
			(* Error handling - Reset error on positve edge. *)
			1001:
	
				IF (Reset) THEN																																																		(* Reset / Error acknownledge? *)
					Reset							:= 0;																																													(* Reset reset. *)
					Status						:= 0;																																													(* Reset status. *)
				END_IF
	
				IF (NOT(Config) AND (Status = 0)) THEN																																						(* Start new configuration reset? *)
					intern.StateMan 	:= 0;																																													(* Wait for new command. *)
				END_IF
	
			(* Should not get here, invalid state. *)
			ELSE
				intern.StateMan := 1000;
	
		END_CASE
	
	ELSE
		intern.StateMan 	:= 0;																																																(* Wait for new command. *)
		Status := ERR_FUB_ENABLE_FALSE;																																												(* Function not enabled status. *)
	END_IF
	
	(********************************************************************************************************************
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NO MORE CODE BEYOND THIS POINT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*********************************************************************************************************************)
END_FUNCTION_BLOCK


TYPE
	XSM_Ctrl_IOMappingType : 	STRUCT 
		DeviceName : STRING[80];
		Channel : INT;
		ModuleOK : BOOL;
		ModuleID : UINT;
		AbsPos : DINT;
		MpGenControl : UINT;
		MpGenMode : SINT;
		AbsPosActVal : DINT;
		MpGenStatus : UINT;
		InputStatus : USINT;
	END_STRUCT;
	XSM_Ctrl_ParametersType : 	STRUCT 
		Units_rev : UINT;
		PosSWLimit : DINT;
		NegSWLimit : DINT;
		HomePosition : DINT;
		HomeMode : USINT;
		Ignore_SWLimits : BOOL;
		Ignore_HWLimits : BOOL;
		HWLimits_Active_Low : BOOL;
		StallDetectionEnable : BOOL;
		UnderCurrentDetectionEnable : BOOL;
	END_STRUCT;
	XSM_IO_Cfg_internType : 	STRUCT 
		StateMan : UINT;
		Cfg_State : USINT;
		OverflowWarning : DINT;
		AsIOAccWriteValue : REAL;
		ChannelName : STRING[30];
		Retries : USINT;
		IO_Mapping : XSM_Ctrl_IOMappingType;
		Parameters : XSM_Ctrl_ParametersType;
	END_STRUCT;
	XSM_IOCfg_CurrentType : 	STRUCT 
		Holding : REAL;
		Rated : REAL;
		Maximum : REAL;
	END_STRUCT;
	XSM_IOCfg_StallType : 	STRUCT 
		StallDetection : USINT;
		DisplayMotorLoadValues : BOOL;
	END_STRUCT;
	XSM_IOCfg_ReferencingType : 	STRUCT 
		ReferencingConfiguration : SINT;
		StallRecongnitionDelay : USINT;
	END_STRUCT;
	XSM_IOCfg_MPGenType : 	STRUCT 
		MaxSpeed : UINT;
		MaxAcc : UINT;
		MaxDec : UINT;
		RevLoop : INT;
		FixedPos_a : DINT;
		FixedPos_b : DINT;
		RefSpeed : DINT;
		JoltTimeLimitation : SINT;
	END_STRUCT;
	XSM_IO_ConfigurationType : 	STRUCT 
		MixedDecayCfg : USINT;
		Current : XSM_IOCfg_CurrentType;
		FullStepThreshold : UINT;
		StallCfg : XSM_IOCfg_StallType;
		RefCfg : XSM_IOCfg_ReferencingType;
		MPGen : XSM_IOCfg_MPGenType;
	END_STRUCT;
	XSM_Ctrl_StateMachineType : 	STRUCT 
		NotReadyToSwitchOn : BOOL;
		SwitchOnDisabled : BOOL;
		ReadyToSwitchOn : BOOL;
		SwitchedOn : BOOL;
		OperationEnabled : BOOL;
		QuickStopActive : BOOL;
		FaultReactionActive : BOOL;
		Fault : BOOL;
	END_STRUCT;
	XSM_Ctrl_internType : 	STRUCT 
		StateMan : UINT;
		TaskCyclicTime : REAL;
		CyclicCounter : REAL;
		OldAbsPosActVal : DINT;
		Target : DINT;
		AbsPos : REAL;
		CmdHome : BOOL;
		CmdReset : BOOL;
		AutoReset : BOOL;
		CmdMove_Absolute : BOOL;
		CmdMove_Additive : BOOL;
		CmdMove_Velocity : BOOL;
		CmdMove_Adv_Two_Position_Mode : BOOL;
		CmdMove_Adv_FixedPos_a : BOOL;
		CmdMove_Adv_FixedPos_b : BOOL;
		CmdMove_Adv_Target_Mode : BOOL;
		OverflowWarning : UINT;
		ErrorCode : UINT;
		ChannelName : STRING[30];
		XSM_StateMachine : XSM_Ctrl_StateMachineType;
	END_STRUCT;
	XSM_Ctrl_AdvancedType : 	STRUCT 
		Target_Mode : BOOL;
		Target_Position : DINT;
		Two_Position_Mode : BOOL;
		Move_FixedPos_a : BOOL;
		Move_FixedPos_b : BOOL;
	END_STRUCT;
	XSM_Ctrl_CmdType : 	STRUCT 
		Move_Absolute : BOOL;
		Position : DINT;
		Move_Additive : BOOL;
		Distance : DINT;
		Move_Velocity : BOOL;
		Velocity : DINT;
		Stop : BOOL;
		Home : BOOL;
		Reset : BOOL;
		Advanced : XSM_Ctrl_AdvancedType;
	END_STRUCT;
	XSM_Ctrl_MonitorType : 	STRUCT 
		Actual_Position : DINT;
		Actual_Velocity : DINT;
		StandStill : BOOL;
		Target_Reached : BOOL;
		Home_OK : BOOL;
		Input_1 : BOOL;
		Input_2 : BOOL;
		Input_3 : BOOL;
		Input_4 : BOOL;
	END_STRUCT;
	XSM_AcyclicReadDataType : 	STRUCT 
		DC_BusVoltage : UINT;
		PowerStage_Temperature : SINT;
		Module_Temperature : SINT;
		Encoder_RefPosCyclicCounter : DINT;
		Encoder_ActualValue : DINT;
		Encoder_RefPosAcyclicCounter : DINT;
	END_STRUCT;
	XSM_AcyclicRead_internType : 	STRUCT 
		StateMan : UINT;
		ChannelName : STRING[30];
		ReadOK : BOOL;
		Retries : USINT;
		IO_Mapping : XSM_Ctrl_IOMappingType;
	END_STRUCT;
END_TYPE


FUNCTION_BLOCK XSM_Ctrl (*Stepper motor control*)
	VAR_INPUT
		Enable : BOOL;
		Power : BOOL;
		Cmd : XSM_Ctrl_CmdType;
		IO_Mapping : XSM_Ctrl_IOMappingType;
		Parameters : XSM_Ctrl_ParametersType;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		PowerOn : BOOL;
		Error : BOOL;
		Status : UINT;
		Monitor : XSM_Ctrl_MonitorType;
	END_VAR
	VAR
		intern : XSM_Ctrl_internType;
		RTInfo_0 : RTInfo;
		AsIOAccRead_0 : AsIOAccRead;
		AsIOAccReadReg_0 : AsIOAccReadReg;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK XSM_IO_Cfg (*Configure stepper motor IO configuration.*)
	VAR_INPUT
		Enable : BOOL;
		Config : BOOL;
		Mode : USINT;
		Reset : BOOL;
		IO_Cfg : XSM_IO_ConfigurationType;
		pIO_Mapping : UDINT;
		pParameters : UDINT;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Status : UINT;
	END_VAR
	VAR
		intern : XSM_IO_Cfg_internType;
		AsIOAccWrite_0 : AsIOAccWrite;
		AsIOAccWriteReg_0 : AsIOAccWriteReg;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK XSM_AcyclicRead (*Stepper motor acyclic reads.*)
	VAR_INPUT
		Enable : BOOL;
		Read : BOOL;
		Mode : USINT;
		Reset : BOOL;
		pIO_Mapping : UDINT;
	END_VAR
	VAR_OUTPUT
		ReadData : XSM_AcyclicReadDataType;
		Status : UINT;
	END_VAR
	VAR
		intern : XSM_AcyclicRead_internType;
		AsIOAccRead_0 : AsIOAccRead;
		AsIOAccReadReg_0 : AsIOAccReadReg;
	END_VAR
END_FUNCTION_BLOCK

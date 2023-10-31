
TYPE
	MpCodeBoxProgramStateEnum : 
		(
		mpCODEBOX_STATE_UNDEFINED, (*Program state is undefined (inactive)*)
		mpCODEBOX_STATE_LOADING, (*Program is loading (compiling)*)
		mpCODEBOX_STATE_INIT_UP, (*Program INIT_UP is excuted*)
		mpCODEBOX_STATE_RUNNING, (*Program executed cyclically*)
		mpCODEBOX_STATE_SUSPENDED, (*Program is suspended (stopped)*)
		mpCODEBOX_STATE_ERROR (*Program is stopped due to error*)
		);
	MpCodeBoxItemEnum : 
		(
		mpCODEBOX_ITEM_PROGRAM, (*Item-Type: Program (LD or ST)*)
		mpCODEBOX_ITEM_MACRO (*Item-Type: Macro*)
		);
	MpCodeBoxCodeEnum : 
		(
		mpCODEBOX_CODE_LD_SIMPLE, (*Code-Type: LD (simple)*)
		mpCODEBOX_CODE_ST (*Code-Type: ST (structured text)*)
		);
	MpCodeBoxCoreProgramsType : 	STRUCT  (*Parameter structure*)
		Name : ARRAY[0..9]OF STRING[100]; (*Program#1 to start*)
	END_STRUCT;
	MpCodeBoxStatusIDType : 	STRUCT 
		ID : MpCodeBoxErrorEnum; (*StatusID as enumerator*)
		Severity : MpComSeveritiesEnum; (*Severity of the error*)
		Code : UINT; (*Error code*)
	END_STRUCT;
	MpCodeBoxDiagType : 	STRUCT 
		StatusID : MpCodeBoxStatusIDType; (*Segmented StatusID output*)
	END_STRUCT;
	MpCodeBoxProgramInfoType : 	STRUCT 
		Name : STRING[100];
		State : MpCodeBoxProgramStateEnum;
		Error : DINT;
	END_STRUCT;
	MpCodeBoxCoreInfoType : 	STRUCT 
		NumberOfActivePrograms : UINT; (*Number of active programs*)
		Program : ARRAY[0..9]OF MpCodeBoxProgramInfoType; (*Overview of running programs*)
		Diag : MpCodeBoxDiagType;
	END_STRUCT;
	MpCodeBoxBasicSandboxType : 	STRUCT 
		DigIn : ARRAY[0..11]OF BOOL;
		DigOut : ARRAY[0..11]OF BOOL;
	END_STRUCT;
	MpCodeBoxInfoType : 	STRUCT 
		Diag : MpCodeBoxDiagType;
	END_STRUCT;
	MpCodeBoxManagerInternalType : 	STRUCT 
		Data : ARRAY[0..5]OF UDINT;
	END_STRUCT;
END_TYPE

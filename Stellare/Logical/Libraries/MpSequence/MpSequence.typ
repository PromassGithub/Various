(*Enumerators*)

TYPE
	MpSequenceModeEnum : 
		( (*Sequence execution modes*)
		mpSEQUENCE_MODE_AUTOMATIC := 0, (*Automatic mode*)
		mpSEQUENCE_MODE_SINGLE_CYCLE := 1, (*Semi-automatic mode (wait after end of cycle)*)
		mpSEQUENCE_MODE_SINGLE_STEP := 2, (*Single step mode (only one step at a time)*)
		mpSEQUENCE_MODE_SINGLE_COMMAND := 3, (*Single command mode (only one command, no relation to a sequence)*)
		mpSEQUENCE_MODE_MANUAL := 5 (*Manual mode; command from the parameter structure, but the command will be looked up inside the currently loaded sequence*)
		);
	MpSequenceStartModeEnum : 
		( (*Start modes for sequence execution*)
		mpSEQUENCE_START_NORMAL := 0, (*Start from sequence start point*)
		mpSEQUENCE_START_SELECT_STEP := 1, (*Start from selected step (input)*)
		mpSEQUENCE_START_AUTO_STEP := 2, (*Start from automatically detected step (based on machine state)*)
		mpSEQUENCE_RESUME_EXECUTION := 3 (*Resume from the last active steps before interruption (e.g. by interlock error)*)
		);
	MpSequenceStopModeEnum : 
		( (*Stop modes for sequence stop*)
		mpSEQUENCE_STOP_IMMEDIATE := 0, (*Stop the execution immediately*)
		mpSEQUENCE_STOP_END_OF_STEP := 1, (*Stop the execution after all currently active steps have ended*)
		mpSEQUENCE_STOP_END_OF_CYCLE := 2 (*Stop the execution after the sequence end (like semi-automatic mode)*)
		);
	MpSequenceSuspendModeEnum : 
		( (*Suspend modes for sequence halt*)
		mpSEQUENCE_SUSPEND_IMMEDIATE := 0, (*Suspend the execution immediately*)
		mpSEQUENCE_SUSPEND_END_OF_STEP := 1 (*Suspend the execution after all active steps have ended*)
		);
	MpSequenceMovementStateEnum : 
		( (*Movement state of the current movement*)
		mpSEQUENCE_MOVEMENT_IDLE := 0, (*Idle: No movement is currently active*)
		mpSEQUENCE_MOVEMENT_ACTIVE := 1, (*Active: A movement is currently active*)
		mpSEQUENCE_MOVEMENT_DONE := 2, (*Done: A movement command has finished*)
		mpSEQUENCE_MOVEMENT_ERROR := 99 (*Error: A movement is in error state*)
		);
	MpSequenceCommandTypeEnum : 
		( (*Command type*)
		mpSEQUENCE_COMMAND_MOVEMENT := 0, (*Movement*)
		mpSEQUENCE_COMMAND_SET_PV := 1, (*Set PV*)
		mpSEQUENCE_COMMAND_WAIT_FOR_TIME := 2, (*Wait for time*)
		mpSEQUENCE_COMMAND_WAIT_FOR_PV := 3, (*Wait for PV*)
		mpSEQUENCE_COMMAND_SET_ALARM := 4, (*Set alarm*)
		mpSEQUENCE_COMMAND_COND_EXEC := 5, (*Conditional execution*)
		mpSEQUENCE_COMMAND_END_COND_EXEC := 6, (*End conditional execution*)
		mpSEQUENCE_COMMAND_LOOP_EXEC := 7, (*Loop execution*)
		mpSEQUENCE_COMMAND_END_LOOP_EXEC := 8 (*End loop execution*)
		);
	MpSequenceActuatorAccessTypeEnum : 
		( (*Actuator access type*)
		mpSEQUENCE_ACCESS_SINGLE := 0, (*Single access (only one axis can access this actuator at a time)*)
		mpSEQUENCE_ACCESS_MULTIPLE := 1 (*Multiple access (multiple axes can access this actuator at the same time)*)
		);
	MpSequenceActuatorTypeEnum : 
		( (*Actuator type*)
		mpSEQUENCE_ACTUATOR_SINGLE := 0, (*Single actuator*)
		mpSEQUENCE_ACTUATOR_MULTIPLE := 1 (*Multiple Actuators*)
		);
	MpSequenceCondCheckReactionEnum : 
		( (*Reaction type when the condition is not fulfilled*)
		mpSEQUENCE_CONDITION_REACT_WAIT := 1, (*The sequencer will wait until the condition is fulfilled*)
		mpSEQUENCE_CONDITION_REACT_STOP := 2 (*The sequence execution will stop with an error when the condition is not fulfilled*)
		);
	MpSequenceConditionTypeEnum : 
		( (*Condition for movement start condition*)
		mpSEQUENCE_CONDITION_AXIS_STATE := 0, (*State of an axis*)
		mpSEQUENCE_CONDITION_GENERIC := 1 (*Generic condition*)
		);
	MpSequenceConditionEnum : 
		( (*Condition compare operator type*)
		mpSEQUENCE_CONDITION_EQUAL := 0,
		mpSEQUENCE_CONDITION_NOT_EQUAL := 1,
		mpSEQUENCE_CONDITION_LESS := 2,
		mpSEQUENCE_CONDITION_LESS_EQ := 3,
		mpSEQUENCE_CONDITION_GREATER := 4,
		mpSEQUENCE_CONDITION_GREATER_EQ := 5
		);
	MpSequenceWaitForTimeTypeEnum : 
		( (*Wait for time type (Duration from PV or Parameter)*)
		mpSEQUENCE_TIME_FROM_PARAMETER := 0, (*Wait duration is read from parameters*)
		mpSEQUENCE_TIME_FROM_PV := 1 (*Wait duration is read from PV*)
		);
	MpSequenceLoopTypeEnum : 
		( (*Loop type (Loop count from PV or Parameter)*)
		mpSEQUENCE_COUNT_FROM_PARAMETER := 0, (*Loop count is read from parameters*)
		mpSEQUENCE_COUNT_FROM_PV := 1 (*Loop count is read from PV*)
		);
END_TYPE

(*Parameters*)

TYPE
	MpSequenceCoreParType : 	STRUCT  (*Parameter structure*)
		Sequence : STRING[255]; (*Name of the sequence to be executed*)
		InitSequence : STRING[255]; (*Name of the init sequence to be executed*)
		ExitSequence : STRING[255]; (*Name of the exit sequence to be executed*)
		Start : MpSequenceCoreStartType; (*Start parameters*)
		Stop : MpSequenceCoreStopType; (*Stop parameters*)
		Suspend : MpSequenceSuspendType; (*Suspend parameters*)
		Manual : MpSequenceManualType; (*Manual mode parameters*)
		SingleCommand : MpSequenceSingleCommandType; (*Single command parameters*)
	END_STRUCT;
	MpSequenceCoreStartType : 	STRUCT  (*Start parameters*)
		Mode : MpSequenceStartModeEnum := mpSEQUENCE_START_NORMAL; (*Sequence Start Mode*)
		Step : STRING[255] := ''; (*Sequence start step (only used with start mode select step)*)
	END_STRUCT;
	MpSequenceCoreStopType : 	STRUCT  (*Stop parameters*)
		Mode : MpSequenceStopModeEnum := mpSEQUENCE_STOP_IMMEDIATE; (*Sequence stop mode*)
	END_STRUCT;
	MpSequenceSuspendType : 	STRUCT  (*Suspend parameters*)
		Mode : MpSequenceSuspendModeEnum := mpSEQUENCE_SUSPEND_IMMEDIATE; (*Sequence suspend mode*)
	END_STRUCT;
	MpSequenceManualType : 	STRUCT 
		Command : {REDUND_UNREPLICABLE} STRING[255]; (*Command name for manual mode*)
	END_STRUCT;
	MpSequenceSingleCommandType : 	STRUCT 
		Command : {REDUND_UNREPLICABLE} STRING[255]; (*Command name for manual mode*)
		ParametersArraySize : UDINT; (*Number of elements in Parameters array*)
		Parameters : UDINT; (*Parameter list for the command: pointer to an array of MpSequenceManualParType; the array size must not be smaller than defined with ParameterArraySize*)
	END_STRUCT;
	MpSequenceManualParType : 	STRUCT 
		Name : {REDUND_UNREPLICABLE} STRING[255]; (*Parameter name*)
		Value : {REDUND_UNREPLICABLE} LREAL; (*Parameter value*)
	END_STRUCT;
END_TYPE

(*Info*)

TYPE
	MpSequenceCoreInfoType : 	STRUCT  (*Sequence core info structure*)
		ReadyToStart : BOOL; (*A sequence has been loaded or transferred from the HMI and is ready to start*)
		ReadyToResume : BOOL; (*A sequence has been suspended and is ready to be resumed*)
		ActiveSteps : ARRAY[0..9]OF STRING[255]; (*Currently active steps (first 10 layers)*)
		ActiveCommands : ARRAY[0..9]OF STRING[255]; (*Currently active commands (first 10 layers)*)
		ElapsedTime : ARRAY[0..9]OF REAL; (*Currently active step elapsed time [s]*)
		Cycle : MpSequenceCycleType; (*Cycle information*)
		Diag : MpSequenceDiagType; (*Diagnostic structure for the function block*)
	END_STRUCT;
	MpSequenceInfoType : 	STRUCT  (*Library info structure*)
		Diag : MpSequenceDiagType; (*Diagnostic structure for the function block*)
	END_STRUCT;
	MpSequenceDiagType : 	STRUCT 
		StatusID : MpSequenceStatusIDType; (*StatusID diagnostic structure *)
	END_STRUCT;
	MpSequenceStatusIDType : 	STRUCT 
		ID : MpSequenceErrorEnum; (*Error code for mapp component*)
		Severity : MpComSeveritiesEnum; (*Describes the type of information supplied by the status ID (success, information, warning, error)*)
		Code : UINT; (*Code for the status ID. This error number can be used to search for additional information in the help system*)
	END_STRUCT;
	MpSequenceCycleType : 	STRUCT  (*Cycle information*)
		Count : UDINT; (*Number of cycles passed since last boot*)
		CurrentTime : REAL; (*Time of currently running cycle [s]*)
		LastTime : REAL; (*Time of last run cycle [s]*)
	END_STRUCT;
END_TYPE

(*Command structure*)

TYPE
	MpSequencerCommandType : 	STRUCT  (*Command structure for axis movements*)
		Start : BOOL; (*Start command*)
		Stop : BOOL; (*Stop command*)
		Actuator : STRING[255]; (*Actuator used for the movement*)
		CurrentMode : MpSequenceModeEnum; (*Current active mode*)
		MovementState : MpSequenceMovementStateEnum; (*Feedback: Current state of the movement*)
		CurrentRunTime : REAL; (*Duration of the running movement [s]*)
		LastRunTime : REAL; (*Duration of the last movement [s]*)
	END_STRUCT;
END_TYPE

(*Configuration Types*)

TYPE
	MpSequenceConditionType : 	STRUCT  (*Configuration structure for a condition check entry in a movement command*)
		ConditionAxis : STRING[255]; (*Axis name of the checked axis in case of axis state condition*)
		ConditionProcessVariable : STRING[255]; (*PV name of the checked PV in case of generic condition*)
		ConditionType : MpSequenceConditionTypeEnum; (*Enumerator for selection of a generic condition or axis state condition*)
		ExpectedState : DINT; (*Expected state of the axis (can be an enum)*)
		Reaction : MpSequenceCondCheckReactionEnum; (*Reaction type when the condition is not fulfilled*)
		ConditionID : STRING[255]; (*ID used for generic conditions*)
	END_STRUCT;
	MpSequenceMovementConfigType : 	STRUCT  (*Configuration structure for the movement command*)
		Axis : STRING[255]; (*Axis name*)
		CommandStructure : STRING[255]; (*String ref to command structure*)
		ParameterStructure : STRING[255]; (*String ref to parameter structure*)
		Actuator : STRING[255]; (*Actuator name*)
		Priority : UINT; (*Priority*)
		FallbackActuator : STRING[255]; (*Primary fallback actuator*)
		SecondFallbackActuator : STRING[255]; (*Secondary fallback actuator*)
		ParameterArraySize : UDINT; (*Number of elements in Parameter array*)
		Parameter : UDINT; (*Pointer to an array of STRING[255], the array size must not be smaller than defined with ParameterArraySize*)
		FinalState : DINT; (*State the assigned axis will have once the movement has been completed (can be an enum)*)
		ConditionsArraySize : UDINT; (*Number of elements in CondCheck array*)
		Conditions : UDINT; (*Pointer to an array of MpSequenceCondCheckType*)
		DisplayTimeout : BOOL := TRUE; (*Display timeout parameter on widget*)
	END_STRUCT;
	MpSequenceSetPvConfigType : 	STRUCT  (*Configuration structure for the SetPv command*)
		Pv : STRING[255]; (*String ref to PV*)
		Text : STRING[255]; (*Text ID for PV name on widget (needs to be in widget name space)*)
	END_STRUCT;
	MpSequenceWaitForTimeConfigType : 	STRUCT  (*Configuration structure for the WaitForTime command*)
		Text : STRING[255]; (*Text ID for duration name on widget (needs to be in widget name space)*)
		Type : MpSequenceWaitForTimeTypeEnum; (*Wait for time command type*)
		ProcessVariable : STRING[255]; (*PV that contains the wait duration in seconds*)
	END_STRUCT;
	MpSequenceLoopConfigType : 	STRUCT  (*Configuration structure for the Loop command*)
		Type : MpSequenceLoopTypeEnum; (*Loop command type*)
		ProcessVariable : STRING[255]; (*PV that contains the loop count*)
	END_STRUCT;
	MpSequenceWaitForPvConfigType : 	STRUCT  (*Configuration structure for the WaitForPv command*)
		ProcessVariable : STRING[255]; (*PV to check*)
		Condition : MpSequenceConditionEnum; (*Condition for variable check*)
		Text : STRING[255]; (*Text ID for PV name on widget (needs to be in widget name space)*)
		DisplayTimeout : BOOL := TRUE; (*Display timeout parameter on widget*)
	END_STRUCT;
	MpSequenceSetAlarmConfigType : 	STRUCT  (*Configuration structure for the SetAlarm command*)
		Name : STRING[255]; (*Alarm to set*)
	END_STRUCT;
	MpSequenceCondExecConfigType : 	STRUCT  (*Configuration structure for the CondExec command*)
		ConditionPv : STRING[255]; (*PV used in the conditional expression*)
		ConditionType : MpSequenceConditionEnum; (*Conditional expression type*)
		Text : STRING[255]; (*Text ID for PV name on widget (needs to be in widget name space)*)
	END_STRUCT;
	MpSequenceCommandConfigType : 	STRUCT  (*Configuration structure for the MpSequenceCommandConfig FB*)
		Text : STRING[255]; (*Text ID for command name on widget (needs to be in widget name space)*)
		Hierarchy : STRING[255]; (*Hierarchy of the command for grouping*)
		Type : MpSequenceCommandTypeEnum; (*Command type*)
		Movement : MpSequenceMovementConfigType; (*Configuration structure for a movement command*)
		SetPv : MpSequenceSetPvConfigType; (*Configuration structure for a SetPV command*)
		WaitForTime : MpSequenceWaitForTimeConfigType; (*Configuration structure for a WaitForTime command*)
		WaitForPv : MpSequenceWaitForPvConfigType; (*Configuration structure for a WaitForPV command*)
		SetAlarm : MpSequenceSetAlarmConfigType; (*Configuration structure for a SetAlarm command*)
		ConditionalExecution : MpSequenceCondExecConfigType; (*Configuration structure for a ConditionalExecution command*)
		Loop : MpSequenceLoopConfigType; (*Configuration structure for a Loop command*)
		DisplayCommand : BOOL; (*Display the command on the widget*)
	END_STRUCT;
	MpSequenceActuatorConfigType : 	STRUCT  (*Configuration structure for the MpSequenceActuatorConfig FB*)
		Type : MpSequenceActuatorTypeEnum; (*Actuator type (single or combination)*)
		Access : MpSequenceActuatorAccessTypeEnum; (*Actuator access type (can be accessed by one movement at a time or multiple movements)*)
		UsedActuatorArraySize : UDINT; (*Number of elements in UsedActuator array*)
		UsedActuator : UDINT; (*Pointer to an array of STRING[255], the array size must not be smaller than defined with UsedActuatorArraySize*)
	END_STRUCT;
	MpSequenceAxisConfigType : 	STRUCT  (*Configuration structure for the MpSequenceActuatorConfig FB*)
		AxisState : STRING[255]; (*Actuator access type (can be accessed by one movement at a time or multiple movements)*)
	END_STRUCT;
END_TYPE

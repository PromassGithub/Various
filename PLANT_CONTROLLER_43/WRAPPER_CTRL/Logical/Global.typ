
TYPE
	typOmronMachine : 	STRUCT 
		MCH_on : BOOL;
		Stop : BOOL;
		Run : BOOL;
		NewCycle : BOOL;
		CommitEnd : BOOL;
		Alarm : BOOL;
		AutoMode : BOOL; (*Automatic Mode*)
		ManMode : BOOL; (*Manual Mode*)
		LiveSignal : BOOL; (*Live Signal*)
		LastCycleTime : DINT;
		ActualCycleTime : DINT;
		PcsPerHour : DINT;
		ActualCycleNr : DINT;
		LifeCycles : DINT;
	END_STRUCT;
	typDI : 	STRUCT 
		Alarm : BOOL;
		Manual : BOOL;
		Run : BOOL;
		NewCycleSignal : BOOL; (*When Omron Cycle Counter is equal to 1*)
		NewCycleTrigger : BOOL; (*When Omron Cycle Counter is equal to 1*)
		MoldChange : BOOL;
		CommitEnd : BOOL;
	END_STRUCT;
	typAI : 	STRUCT 
		DummyAI : REAL;
	END_STRUCT;
	typAO : 	STRUCT 
		DummiAO : REAL;
	END_STRUCT;
	typDO : 	STRUCT 
		DummyDO : BOOL;
	END_STRUCT;
	typIO : 	STRUCT 
		Di : typDI;
		Do : typDO;
		Ai : typAI;
		Ao : typAO;
	END_STRUCT;
	tLocClock : 	STRUCT 
		rtcStartUp : DATE_AND_TIME;
		rtcShutDown : DATE_AND_TIME;
		rtcRuntime : DATE_AND_TIME;
		rtcSetTime : DATE_AND_TIME;
		ulTimePlcOff : UDINT;
		myTime : TIME;
	END_STRUCT;
	tCmdClock : 	STRUCT 
		bSetClock : BOOL;
		bOkSet : BOOL;
		bErSet : BOOL;
		calSetTime : DTStructure;
	END_STRUCT;
	tGlbClock : 	STRUCT 
		alRamData : BOOL;
		alRtcStartUp : BOOL;
		alRtcShutDown : BOOL;
		alRtcRuntime : BOOL;
		rtcRuntime : DATE_AND_TIME;
		calStartUp : DTStructure;
		calShutDown : DTStructure;
		ulTimePlcOff : UDINT;
		cpu_time : UDINT;
		cpu_time_uSec : UDINT;
	END_STRUCT;
END_TYPE

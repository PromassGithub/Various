/* Automation Studio generated header file */
/* Do not edit ! */
/* MpSequence 5.12.1 */

#ifndef _MPSEQUENCE_
#define _MPSEQUENCE_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MpSequence_VERSION
#define _MpSequence_VERSION 5.12.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MpBase.h"
#endif

#ifdef _SG4
		#include "MpBase.h"
#endif

#ifdef _SGC
		#include "MpBase.h"
#endif



/* Datatypes and datatypes of function blocks */
typedef enum MpSequenceModeEnum
{	mpSEQUENCE_MODE_AUTOMATIC = 0,
	mpSEQUENCE_MODE_SINGLE_CYCLE = 1,
	mpSEQUENCE_MODE_SINGLE_STEP = 2,
	mpSEQUENCE_MODE_SINGLE_COMMAND = 3,
	mpSEQUENCE_MODE_MANUAL = 5
} MpSequenceModeEnum;

typedef enum MpSequenceStartModeEnum
{	mpSEQUENCE_START_NORMAL = 0,
	mpSEQUENCE_START_SELECT_STEP = 1,
	mpSEQUENCE_START_AUTO_STEP = 2,
	mpSEQUENCE_RESUME_EXECUTION = 3
} MpSequenceStartModeEnum;

typedef enum MpSequenceStopModeEnum
{	mpSEQUENCE_STOP_IMMEDIATE = 0,
	mpSEQUENCE_STOP_END_OF_STEP = 1,
	mpSEQUENCE_STOP_END_OF_CYCLE = 2
} MpSequenceStopModeEnum;

typedef enum MpSequenceSuspendModeEnum
{	mpSEQUENCE_SUSPEND_IMMEDIATE = 0,
	mpSEQUENCE_SUSPEND_END_OF_STEP = 1
} MpSequenceSuspendModeEnum;

typedef enum MpSequenceMovementStateEnum
{	mpSEQUENCE_MOVEMENT_IDLE = 0,
	mpSEQUENCE_MOVEMENT_ACTIVE = 1,
	mpSEQUENCE_MOVEMENT_DONE = 2,
	mpSEQUENCE_MOVEMENT_ERROR = 99
} MpSequenceMovementStateEnum;

typedef enum MpSequenceCommandTypeEnum
{	mpSEQUENCE_COMMAND_MOVEMENT = 0,
	mpSEQUENCE_COMMAND_SET_PV = 1,
	mpSEQUENCE_COMMAND_WAIT_FOR_TIME = 2,
	mpSEQUENCE_COMMAND_WAIT_FOR_PV = 3,
	mpSEQUENCE_COMMAND_SET_ALARM = 4,
	mpSEQUENCE_COMMAND_COND_EXEC = 5,
	mpSEQUENCE_COMMAND_END_COND_EXEC = 6,
	mpSEQUENCE_COMMAND_LOOP_EXEC = 7,
	mpSEQUENCE_COMMAND_END_LOOP_EXEC = 8
} MpSequenceCommandTypeEnum;

typedef enum MpSequenceActuatorAccessTypeEnum
{	mpSEQUENCE_ACCESS_SINGLE = 0,
	mpSEQUENCE_ACCESS_MULTIPLE = 1
} MpSequenceActuatorAccessTypeEnum;

typedef enum MpSequenceActuatorTypeEnum
{	mpSEQUENCE_ACTUATOR_SINGLE = 0,
	mpSEQUENCE_ACTUATOR_MULTIPLE = 1
} MpSequenceActuatorTypeEnum;

typedef enum MpSequenceCondCheckReactionEnum
{	mpSEQUENCE_CONDITION_REACT_WAIT = 1,
	mpSEQUENCE_CONDITION_REACT_STOP = 2
} MpSequenceCondCheckReactionEnum;

typedef enum MpSequenceConditionTypeEnum
{	mpSEQUENCE_CONDITION_AXIS_STATE = 0,
	mpSEQUENCE_CONDITION_GENERIC = 1
} MpSequenceConditionTypeEnum;

typedef enum MpSequenceConditionEnum
{	mpSEQUENCE_CONDITION_EQUAL = 0,
	mpSEQUENCE_CONDITION_NOT_EQUAL = 1,
	mpSEQUENCE_CONDITION_LESS = 2,
	mpSEQUENCE_CONDITION_LESS_EQ = 3,
	mpSEQUENCE_CONDITION_GREATER = 4,
	mpSEQUENCE_CONDITION_GREATER_EQ = 5
} MpSequenceConditionEnum;

typedef enum MpSequenceWaitForTimeTypeEnum
{	mpSEQUENCE_TIME_FROM_PARAMETER = 0,
	mpSEQUENCE_TIME_FROM_PV = 1
} MpSequenceWaitForTimeTypeEnum;

typedef enum MpSequenceLoopTypeEnum
{	mpSEQUENCE_COUNT_FROM_PARAMETER = 0,
	mpSEQUENCE_COUNT_FROM_PV = 1
} MpSequenceLoopTypeEnum;

typedef enum MpSequenceErrorEnum
{	mpSEQUENCE_NO_ERROR = 0,
	mpSEQUENCE_ERR_ACTIVATION = -1064239103,
	mpSEQUENCE_ERR_MPLINK_NULL = -1064239102,
	mpSEQUENCE_ERR_MPLINK_INVALID = -1064239101,
	mpSEQUENCE_ERR_MPLINK_CHANGED = -1064239100,
	mpSEQUENCE_ERR_MPLINK_CORRUPT = -1064239099,
	mpSEQUENCE_ERR_MPLINK_IN_USE = -1064239098,
	mpSEQUENCE_ERR_PAR_NULL = -1064239097,
	mpSEQUENCE_ERR_CONFIG_NULL = -1064239096,
	mpSEQUENCE_ERR_CONFIG_NO_PV = -1064239095,
	mpSEQUENCE_ERR_CONFIG_LOAD = -1064239094,
	mpSEQUENCE_WRN_CONFIG_LOAD = -2137980917,
	mpSEQUENCE_ERR_CONFIG_SAVE = -1064239092,
	mpSEQUENCE_ERR_CONFIG_INVALID = -1064239091,
	mpSEQUENCE_ERR_NAME_EMPTY = -1064004608,
	mpSEQUENCE_ERR_IMPORT = -1064004607,
	mpSEQUENCE_ERR_EXPORT = -1064004606,
	mpSEQUENCE_ERR_NO_SEQUENCE_DEF = -1064004605,
	mpSEQUENCE_ERR_PV_NOT_FOUND = -1064004604,
	mpSEQUENCE_ERR_INTERLOCK = -1064004603,
	mpSEQUENCE_ERR_STEP_TIMEOUT = -1064004602,
	mpSEQUENCE_ERR_CONDITION_INVALID = -1064004601,
	mpSEQUENCE_ERR_NAME_NOT_FOUND = -1064004600,
	mpSEQUENCE_ERR_ARRAY_NULL = -1064004599,
	mpSEQUENCE_ERR_NAME_NULL = -1064004598,
	mpSEQUENCE_WRN_ARRAY_SHORT = -2137746421,
	mpSEQUENCE_ERR_ACTUATOR_MISSING = -1064004596,
	mpSEQUENCE_ERR_ACTUATOR_COUNT = -1064004595,
	mpSEQUENCE_ERR_PAR_MISSING = -1064004594,
	mpSEQUENCE_ERR_STEP_NOT_FOUND = -1064004593,
	mpSEQUENCE_ERR_NO_SEQ_IMPORTED = -1064004592,
	mpSEQUENCE_ERR_AXIS_MISSING = -1064004591,
	mpSEQUENCE_ERR_COMMAND_NOT_FOUND = -1064004590,
	mpSEQUENCE_ERR_NO_STEPS_PREVIOUS = -1064004589,
	mpSEQUENCE_ERR_NO_STEPS_DEFINED = -1064004588,
	mpSEQUENCE_ERR_COMMAND_STATE_ERR = -1064004587,
	mpSEQUENCE_ERR_SEQUENCE_INVALID = -1064004586
} MpSequenceErrorEnum;

typedef enum MpSequenceAlarmEnum
{	mpSEQUENCE_ALM_IMPORT_SEQUENCE = 0,
	mpSEQUENCE_ALM_EXPORT_SEQUENCE = 1,
	mpSEQUENCE_ALM_TIMEOUT = 2,
	mpSEQUENCE_ALM_INTERLOCK = 3,
	mpSEQUENCE_ALM_ACTUATOR_BLOCKED = 4
} MpSequenceAlarmEnum;

typedef struct MpSequenceCoreStartType
{	enum MpSequenceStartModeEnum Mode;
	plcstring Step[256];
} MpSequenceCoreStartType;

typedef struct MpSequenceCoreStopType
{	enum MpSequenceStopModeEnum Mode;
} MpSequenceCoreStopType;

typedef struct MpSequenceSuspendType
{	enum MpSequenceSuspendModeEnum Mode;
} MpSequenceSuspendType;

typedef struct MpSequenceManualType
{	plcstring Command[256];
} MpSequenceManualType;

typedef struct MpSequenceSingleCommandType
{	plcstring Command[256];
	unsigned long ParametersArraySize;
	unsigned long Parameters;
} MpSequenceSingleCommandType;

typedef struct MpSequenceCoreParType
{	plcstring Sequence[256];
	plcstring InitSequence[256];
	plcstring ExitSequence[256];
	struct MpSequenceCoreStartType Start;
	struct MpSequenceCoreStopType Stop;
	struct MpSequenceSuspendType Suspend;
	struct MpSequenceManualType Manual;
	struct MpSequenceSingleCommandType SingleCommand;
} MpSequenceCoreParType;

typedef struct MpSequenceManualParType
{	plcstring Name[256];
	double Value;
} MpSequenceManualParType;

typedef struct MpSequenceCycleType
{	unsigned long Count;
	float CurrentTime;
	float LastTime;
} MpSequenceCycleType;

typedef struct MpSequenceStatusIDType
{	enum MpSequenceErrorEnum ID;
	MpComSeveritiesEnum Severity;
	unsigned short Code;
} MpSequenceStatusIDType;

typedef struct MpSequenceDiagType
{	struct MpSequenceStatusIDType StatusID;
} MpSequenceDiagType;

typedef struct MpSequenceCoreInfoType
{	plcbit ReadyToStart;
	plcbit ReadyToResume;
	plcstring ActiveSteps[10][256];
	plcstring ActiveCommands[10][256];
	float ElapsedTime[10];
	struct MpSequenceCycleType Cycle;
	struct MpSequenceDiagType Diag;
} MpSequenceCoreInfoType;

typedef struct MpSequenceInfoType
{	struct MpSequenceDiagType Diag;
} MpSequenceInfoType;

typedef struct MpSequencerCommandType
{	plcbit Start;
	plcbit Stop;
	plcstring Actuator[256];
	enum MpSequenceModeEnum CurrentMode;
	enum MpSequenceMovementStateEnum MovementState;
	float CurrentRunTime;
	float LastRunTime;
} MpSequencerCommandType;

typedef struct MpSequenceConditionType
{	plcstring ConditionAxis[256];
	plcstring ConditionProcessVariable[256];
	enum MpSequenceConditionTypeEnum ConditionType;
	signed long ExpectedState;
	enum MpSequenceCondCheckReactionEnum Reaction;
	plcstring ConditionID[256];
} MpSequenceConditionType;

typedef struct MpSequenceMovementConfigType
{	plcstring Axis[256];
	plcstring CommandStructure[256];
	plcstring ParameterStructure[256];
	plcstring Actuator[256];
	unsigned short Priority;
	plcstring FallbackActuator[256];
	plcstring SecondFallbackActuator[256];
	unsigned long ParameterArraySize;
	unsigned long Parameter;
	signed long FinalState;
	unsigned long ConditionsArraySize;
	unsigned long Conditions;
	plcbit DisplayTimeout;
} MpSequenceMovementConfigType;

typedef struct MpSequenceSetPvConfigType
{	plcstring Pv[256];
	plcstring Text[256];
} MpSequenceSetPvConfigType;

typedef struct MpSequenceWaitForTimeConfigType
{	plcstring Text[256];
	enum MpSequenceWaitForTimeTypeEnum Type;
	plcstring ProcessVariable[256];
} MpSequenceWaitForTimeConfigType;

typedef struct MpSequenceLoopConfigType
{	enum MpSequenceLoopTypeEnum Type;
	plcstring ProcessVariable[256];
} MpSequenceLoopConfigType;

typedef struct MpSequenceWaitForPvConfigType
{	plcstring ProcessVariable[256];
	enum MpSequenceConditionEnum Condition;
	plcstring Text[256];
	plcbit DisplayTimeout;
} MpSequenceWaitForPvConfigType;

typedef struct MpSequenceSetAlarmConfigType
{	plcstring Name[256];
} MpSequenceSetAlarmConfigType;

typedef struct MpSequenceCondExecConfigType
{	plcstring ConditionPv[256];
	enum MpSequenceConditionEnum ConditionType;
	plcstring Text[256];
} MpSequenceCondExecConfigType;

typedef struct MpSequenceCommandConfigType
{	plcstring Text[256];
	plcstring Hierarchy[256];
	enum MpSequenceCommandTypeEnum Type;
	struct MpSequenceMovementConfigType Movement;
	struct MpSequenceSetPvConfigType SetPv;
	struct MpSequenceWaitForTimeConfigType WaitForTime;
	struct MpSequenceWaitForPvConfigType WaitForPv;
	struct MpSequenceSetAlarmConfigType SetAlarm;
	struct MpSequenceCondExecConfigType ConditionalExecution;
	struct MpSequenceLoopConfigType Loop;
	plcbit DisplayCommand;
} MpSequenceCommandConfigType;

typedef struct MpSequenceActuatorConfigType
{	enum MpSequenceActuatorTypeEnum Type;
	enum MpSequenceActuatorAccessTypeEnum Access;
	unsigned long UsedActuatorArraySize;
	unsigned long UsedActuator;
} MpSequenceActuatorConfigType;

typedef struct MpSequenceAxisConfigType
{	plcstring AxisState[256];
} MpSequenceAxisConfigType;

typedef struct MpSequenceCore
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpSequenceCoreParType* Parameters;
	enum MpSequenceModeEnum Mode;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpSequenceCoreInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Update;
	plcbit Start;
	plcbit Stop;
	plcbit Suspend;
	plcbit Resume;
	plcbit Import;
	plcbit Export;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit UpdateDone;
	plcbit Running;
	plcbit Suspended;
	plcbit Stopped;
	plcbit ImportDone;
	plcbit ExportDone;
} MpSequenceCore_typ;

typedef struct MpSequenceCommandConfig
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*Name);
	struct MpSequenceCommandConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpSequenceInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Load;
	plcbit Save;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpSequenceCommandConfig_typ;

typedef struct MpSequenceActuatorConfig
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*Name);
	struct MpSequenceActuatorConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpSequenceInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Load;
	plcbit Save;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpSequenceActuatorConfig_typ;

typedef struct MpSequenceAxisConfig
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*Name);
	struct MpSequenceAxisConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpSequenceInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Load;
	plcbit Save;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpSequenceAxisConfig_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MpSequenceCore(struct MpSequenceCore* inst);
_BUR_PUBLIC void MpSequenceCommandConfig(struct MpSequenceCommandConfig* inst);
_BUR_PUBLIC void MpSequenceActuatorConfig(struct MpSequenceActuatorConfig* inst);
_BUR_PUBLIC void MpSequenceAxisConfig(struct MpSequenceAxisConfig* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MPSEQUENCE_ */


/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1660058014_1_
#define _BUR_1660058014_1_

#include <bur/plctypes.h>

/* Datatypes and datatypes of function blocks */
typedef struct typOmronMachine
{	plcbit MCH_on;
	plcbit Stop;
	plcbit Run;
	plcbit NewCycle;
	plcbit CommitEnd;
	plcbit Alarm;
	plcbit AutoMode;
	plcbit ManMode;
	plcbit LiveSignal;
	signed long LastCycleTime;
	signed long ActualCycleTime;
	signed long PcsPerHour;
	signed long ActualCycleNr;
	signed long LifeCycles;
} typOmronMachine;

typedef struct typDI
{	plcbit Alarm;
	plcbit Manual;
	plcbit Run;
	plcbit NewCycleSignal;
	plcbit NewCycleTrigger;
	plcbit MoldChange;
	plcbit CommitEnd;
} typDI;

typedef struct typAI
{	float DummyAI;
} typAI;

typedef struct typAO
{	float DummiAO;
} typAO;

typedef struct typDO
{	plcbit DummyDO;
} typDO;

typedef struct typIO
{	struct typDI Di;
	struct typDO Do;
	struct typAI Ai;
	struct typAO Ao;
} typIO;

typedef struct tLocClock
{	plcdt rtcStartUp;
	plcdt rtcShutDown;
	plcdt rtcRuntime;
	plcdt rtcSetTime;
	unsigned long ulTimePlcOff;
	plctime myTime;
} tLocClock;

typedef struct tCmdClock
{	plcbit bSetClock;
	plcbit bOkSet;
	plcbit bErSet;
	struct DTStructure calSetTime;
} tCmdClock;

typedef struct tGlbClock
{	plcbit alRamData;
	plcbit alRtcStartUp;
	plcbit alRtcShutDown;
	plcbit alRtcRuntime;
	plcdt rtcRuntime;
	struct DTStructure calStartUp;
	struct DTStructure calShutDown;
	unsigned long ulTimePlcOff;
	unsigned long cpu_time;
	unsigned long cpu_time_uSec;
} tGlbClock;






__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/Global.typ\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1660058014_1_ */


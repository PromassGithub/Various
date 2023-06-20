/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1660058014_2_
#define _BUR_1660058014_2_

#include <bur/plctypes.h>

/* Constants */
#ifdef _REPLACE_CONST
#else
#endif


/* Variables */
_GLOBAL_RETAIN plcstring glb_mac_name[11];
_GLOBAL struct tCmdClock cmdClock;
_GLOBAL unsigned long cpu_time_start_mac01;
_GLOBAL unsigned long cpu_time_start_mac02;
_GLOBAL unsigned long cpu_time_start_mac03;
_GLOBAL plcbit g1secTick01;
_GLOBAL plcbit gCounter01;
_GLOBAL plcbit gCounter02;
_GLOBAL plcbit gCounter03;
_GLOBAL_RETAIN struct tGlbClock glbClock;
_GLOBAL plcbit glbMac01On;
_GLOBAL plcbit glbMac02On;
_GLOBAL struct typOmronMachine gMAC01;
_GLOBAL_RETAIN signed long gMac01CounterOffset;
_GLOBAL_RETAIN signed long gMac01LifeCounter;
_GLOBAL struct typIO gMAC01raw;
_GLOBAL struct typOmronMachine gMAC02;
_GLOBAL_RETAIN signed long gMac02CounterOffset;
_GLOBAL_RETAIN signed long gMac02LifeCounter;
_GLOBAL struct typIO gMAC02raw;
_GLOBAL struct typOmronMachine gMAC03;
_GLOBAL_RETAIN signed long gMac03CounterOffset;
_GLOBAL_RETAIN signed long gMac03LifeCounter;
_GLOBAL struct typIO gMAC03raw;
_GLOBAL plcbit gPulse_100;
_GLOBAL plcbit gPulse_500;
_GLOBAL plcbit gPWL01_ok;
_GLOBAL plcbit gPWL02_ok;
_GLOBAL plcbit gPWL03_ok;
_GLOBAL struct TON M1_AUTO_1s;
_GLOBAL struct TON M1_NewCycle;
_GLOBAL struct TON M2_NewCycle;
_GLOBAL struct TON M3_NewCycle;





__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/Global.var\\\" scope \\\"global\\\"\\n\"");
__asm__(".ascii \"iecfile \\\"Logical/Libraries/standard/standard.fun\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1660058014_2_ */


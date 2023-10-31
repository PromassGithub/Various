/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1644935100_1_
#define _BUR_1644935100_1_

#include <bur/plctypes.h>

/* Datatypes and datatypes of function blocks */
typedef enum PackMLModes
{	PACKML_MODE_PRODUCTION = 1,
	PACKML_MODE_MAINTENANCE = 2
} PackMLModes;

typedef enum CoffeeStateEnum
{	COFFEE_WAIT = 0,
	COFFEE_TAKEWATER = 1,
	COFFEE_TAKECOFFEE = 2,
	COFFEE_TAKECOFFEEMILK = 3,
	COFFEE_RELEASE = 4,
	COFFEE_FINISH = 5
} CoffeeStateEnum;

typedef struct typ_ricetta
{	plcdt Ora_Inizio;
	plcdt Ora_Fine;
	unsigned long Tempo_Attivita;
	unsigned long Giri_Parziali;
	unsigned long Giri_Totali;
} typ_ricetta;

typedef struct typ_cont
{	plcbit Inp_S_Stellare;
	plcbit S_stellare;
	unsigned long giri_parziali;
	unsigned long giri_totali;
	unsigned long giri_instant;
	unsigned long frequenza;
	unsigned long nome_ricetta1;
	plcstring nome_ricetta2[81];
	unsigned long nome_ricetta3;
	plcstring nome_ricetta[81];
} typ_cont;

typedef struct ReportCoffeeType
{	plcstring Name[256];
	signed short Water;
	signed short Sugar;
	signed short Coffee;
	signed short Milk;
} ReportCoffeeType;

typedef struct RefillAlarmType
{	plcbit Water;
	plcbit Sugar;
	plcbit Milk;
	plcbit Coffee;
} RefillAlarmType;

typedef struct RefillType
{	signed short Water;
	signed short Sugar;
	signed short Milk;
	signed short Coffee;
} RefillType;

typedef struct CoffeeAxisLogicType
{	plcbit Active;
	plcbit Power;
	plcbit PowerOn;
	plcbit Home;
	plcbit MoveAdditive;
	plcbit MoveActive;
	plcbit InPosition;
	double Position;
} CoffeeAxisLogicType;

typedef struct CoffeeMainLogicType
{	struct CoffeeAxisLogicType AxisCupFeeder;
	struct CoffeeAxisLogicType AxisTakeout;
	plcbit cmdAbort;
	plcbit cmdStop;
	plcbit cmdClear;
	plcbit cmdStart;
	plcbit TemperatureWithinLimit;
	plcbit CreateFirstRecipe;
	unsigned char visPictureIndex;
	plcbit cmdTakeout;
	struct RefillType Refill;
	struct RefillAlarmType AlarmRefill;
	enum CoffeeStateEnum CoffeeState;
	struct ReportCoffeeType ReportCoffee[200];
	plcstring PackMLState[81];
	plcbit IdleState;
} CoffeeMainLogicType;






__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/Global.typ\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1644935100_1_ */


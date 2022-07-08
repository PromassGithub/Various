/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _BUR_1657286364_1_
#define _BUR_1657286364_1_

#include <bur/plctypes.h>

/* Datatypes and datatypes of function blocks */
typedef struct Rep_typ
{	signed short oil_pressure;
	signed short p_chiusura;
	signed short p_apertura;
} Rep_typ;

typedef struct out_typ
{	plcbit chiusura;
	plcbit apertura;
	plcbit alta_pressione;
	plcbit cut_pessure;
	plcbit Scarico_ap;
	plcbit Scarico_ch;
	plcbit alta_velocita;
} out_typ;

typedef struct inp_typ
{	unsigned char New_Member;
} inp_typ;

typedef struct cmd_typ
{	plcbit hmi_oil_control_hide;
	plcbit hmi_oil_control_en;
	plcbit lame_fisse_close;
	plcbit lame_fisse_open;
	plcbit lame_mobili_close;
	plcbit lame_mobili_open;
	plcbit martinetti_close;
	plcbit martinetti_open;
	plcbit pedana_dw;
	plcbit pedana_up;
	plcbit scarico_ch;
	plcbit scarico_ap;
	plcbit chiusura;
	plcbit apertura;
	plcbit alta_velocita;
} cmd_typ;

typedef struct config_typ
{	plcbit martinetti_epp;
	plcbit cambiostampo_aut;
} config_typ;

typedef struct Ai_typ
{	signed short oil_pressure_conv;
	signed short oil_pressure;
	signed short p_chiusura_conv;
	signed short p_apertura_conv;
	signed short p_chiusura;
	signed short p_apertura;
} Ai_typ;

typedef struct inp_value_typ
{	signed short MAX_OIL_MOV_BLADE_C;
	signed short MAX_OIL_FIX_BLADE_C;
	signed short MAX_OIL_JACK_C;
	signed short MAX_OIL_PEDANA_UP;
	signed short MAX_OIL_PEDANA_DW;
	signed short MAX_OIL_PRESSURE;
} inp_value_typ;

typedef struct hmi_typ
{	struct config_typ configurazione;
	struct cmd_typ cmd;
	struct inp_value_typ inp;
} hmi_typ;

typedef struct glb_typ
{	struct inp_typ inp;
	struct out_typ out;
	struct Ai_typ Ai;
} glb_typ;






__asm__(".section \".plc\"");

/* Used IEC files */
__asm__(".ascii \"iecfile \\\"Logical/Global.typ\\\" scope \\\"global\\\"\\n\"");

/* Exported library functions and function blocks */

__asm__(".previous");


#endif /* _BUR_1657286364_1_ */


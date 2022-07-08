
TYPE
	Rep_typ : 	STRUCT 
		oil_pressure : INT;
		p_chiusura : INT;
		p_apertura : INT;
	END_STRUCT;
	out_typ : 	STRUCT 
		chiusura : BOOL;
		apertura : BOOL;
		alta_pressione : BOOL; (*41*)
		cut_pessure : BOOL;
		Scarico_ap : BOOL; (*96*)
		Scarico_ch : BOOL; (*95*)
		alta_velocita : BOOL; (*42*)
	END_STRUCT;
	inp_typ : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	cmd_typ : 	STRUCT 
		hmi_oil_control_hide : BOOL;
		hmi_oil_control_en : BOOL;
		lame_fisse_close : BOOL;
		lame_fisse_open : BOOL;
		lame_mobili_close : BOOL;
		lame_mobili_open : BOOL;
		martinetti_close : BOOL;
		martinetti_open : BOOL;
		pedana_dw : BOOL;
		pedana_up : BOOL;
		scarico_ch : BOOL;
		scarico_ap : BOOL;
		chiusura : BOOL;
		apertura : BOOL;
		alta_velocita : BOOL; (*42*)
	END_STRUCT;
	config_typ : 	STRUCT 
		martinetti_epp : BOOL;
		cambiostampo_aut : BOOL;
	END_STRUCT;
	Ai_typ : 	STRUCT 
		oil_pressure_conv : INT;
		oil_pressure : INT;
		p_chiusura_conv : INT;
		p_apertura_conv : INT;
		p_chiusura : INT;
		p_apertura : INT;
	END_STRUCT;
	inp_value_typ : 	STRUCT 
		MAX_OIL_MOV_BLADE_C : INT := 50;
		MAX_OIL_FIX_BLADE_C : INT := 70;
		MAX_OIL_JACK_C : INT := 100;
		MAX_OIL_PEDANA_UP : INT := 100;
		MAX_OIL_PEDANA_DW : INT := 100;
		MAX_OIL_PRESSURE : INT := 150;
	END_STRUCT;
	hmi_typ : 	STRUCT 
		configurazione : config_typ;
		cmd : cmd_typ;
		inp : inp_value_typ;
	END_STRUCT;
	glb_typ : 	STRUCT 
		inp : inp_typ;
		out : out_typ;
		Ai : Ai_typ;
	END_STRUCT;
END_TYPE

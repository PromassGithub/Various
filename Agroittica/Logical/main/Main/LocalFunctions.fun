
{REDUND_ERROR} FUNCTION_BLOCK gun (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Peso_ok : BOOL;
		trigger_sensor : BOOL;
		finecorsa : BOOL;
		PT_pist_Delay : TIME;
		PT_end_stop : TIME;
		PT_piston_up : TIME;
		PT_trigger_gun : TIME;
	END_VAR
	VAR_OUTPUT
		end : BOOL;
		gun_out : BOOL;
		Ready : BOOL;
		Piston_out : BOOL;
	END_VAR
	VAR
		TON_08 : TON;
		TON_04 : TON;
		TON_03 : TON;
		TON_02 : TON;
		TON_01 : TON;
		St_Gun : USINT;
	END_VAR
END_FUNCTION_BLOCK

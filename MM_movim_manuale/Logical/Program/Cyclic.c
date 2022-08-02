
#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

#define CONVERT_INT_TO_ANA_1(x, x1, y1, x2, y2)  ( y1 + ( (y2 - y1) / (REAL) (x2 - x1) ) * (x - x1) )

void _CYCLIC ProgramCyclic(void)
{
	glb_io.Ai.oil_pressure_conv           		= (CONVERT_INT_TO_ANA_1(glb_io.Ai.oil_pressure,           		0,  0, 32767, 250));
	glb_io.Ai.p_apertura_conv           		= (CONVERT_INT_TO_ANA_1(glb_io.Ai.p_apertura,           		0,  0, 32767, 250));
	glb_io.Ai.p_chiusura_conv           		= (CONVERT_INT_TO_ANA_1(glb_io.Ai.p_chiusura,           		0,  0, 32767, 250));
	
	Report.oil_pressure		= glb_io.Ai.oil_pressure_conv;
	Report.p_apertura		= glb_io.Ai.p_apertura_conv; 
	Report.p_apertura		= glb_io.Ai.p_chiusura_conv;  
	
	// ritardo attivazione alta velocità //
	if (hmi.cmd.alta_velocita){
		Alta_V_TON.IN = (hmi.cmd.apertura || hmi.cmd.chiusura);
		Alta_V_TON.PT = 1500;
		TON(&Alta_V_TON);
		Alta_velocita_T = Alta_V_TON.Q;
	} else { 
		Alta_velocita_T = 0;
	}
	glb_io.out.alta_velocita = Alta_velocita_T;
	
	// ritardo attivazione apertura //
	Ap_TON.IN = hmi.cmd.apertura;
	Ap_TON.PT = 500;
	TON(&Ap_TON);
	Apertura_T = Ap_TON.Q;

	// ritardo attivazione chiusura //
	Ch_TON.IN = hmi.cmd.chiusura;
	Ch_TON.PT = 500;
	TON(&Ch_TON);
	Chiusura_T = Ch_TON.Q;
	
	// COMANDI //
	// SCARICO PRESSIONE //
	if (hmi.cmd.chiusura || hmi.cmd.scarico_ap) glb_io.out.Scarico_ap = 1; else glb_io.out.Scarico_ap = 0;
	if (hmi.cmd.apertura || hmi.cmd.scarico_ch) glb_io.out.Scarico_ch = 1; else glb_io.out.Scarico_ch = 0;
	
	// ALTA PRESSIONE //
	if (Apertura_T || Chiusura_T || hmi.cmd.lame_fisse_close || hmi.cmd.lame_fisse_open || hmi.cmd.lame_mobili_close 
		|| hmi.cmd.lame_mobili_open || hmi.cmd.martinetti_close || hmi.cmd.martinetti_open || hmi.cmd.pedana_dw || hmi.cmd.pedana_up)
	{
		glb_io.out.alta_pressione	= 1;
	} else {
		glb_io.out.alta_pressione	= 0;
	}
	// APERTURA //
	if ((Apertura_T || hmi.cmd.lame_fisse_open || hmi.cmd.lame_mobili_open || hmi.cmd.martinetti_open || hmi.cmd.pedana_up) && (!glb_io.out.chiusura))
	{
		glb_io.out.apertura			= 1;
	} else {
		glb_io.out.apertura			= 0;
	}
	// CHIUSURA //
	if ((Chiusura_T || hmi.cmd.lame_fisse_close || hmi.cmd.lame_mobili_close || hmi.cmd.martinetti_close || hmi.cmd.pedana_dw) && (!glb_io.out.apertura))
	{
		glb_io.out.chiusura			= 1;
	} else {
		glb_io.out.chiusura			= 0;
	}
	
	// HMI //
	
	if (hmi.cmd.hmi_oil_control_en){
		oil_control_enable		= 1;
		hmi.cmd.hmi_oil_control_hide	= 0; 
	}else {
		oil_control_enable		= 0;
		hmi.cmd.hmi_oil_control_hide 	= 1;
	}
	
	// CONTROLLO PRESSIONI //
	if (oil_control_enable == 1) {
		
		// stacco le valvole 41 e 42 se la pressione è troppo alta
		if (glb_io.Ai.oil_pressure_conv >= hmi.inp.MAX_OIL_PRESSURE) {
			glb_io.out.cut_pessure = 1;
		} else if (glb_io.Ai.oil_pressure_conv < hmi.inp.MAX_OIL_PRESSURE - 5) {
			glb_io.out.cut_pessure = 0;
		}
		// stacco pressione se il trasduttore non legge
		if (glb_io.Ai.oil_pressure_conv <= -1) glb_io.out.cut_pessure = 1;
		
		if (glb_io.out.cut_pessure){
			glb_io.out.alta_pressione	= 0;
			glb_io.out.alta_velocita	= 0;
		}
		

		if(hmi.cmd.lame_fisse_close){
			if (glb_io.Ai.p_chiusura_conv >= hmi.inp.MAX_OIL_FIX_BLADE_C) {
				glb_io.out.chiusura			= 0;
				glb_io.out.alta_pressione	= 0;
			} else if (glb_io.Ai.p_chiusura_conv < hmi.inp.MAX_OIL_FIX_BLADE_C - 5) {
				//				glb_io.out.chiusura			= 0;
			}
			
		}else if(hmi.cmd.lame_mobili_close){
			if (glb_io.Ai.p_chiusura_conv >= hmi.inp.MAX_OIL_MOV_BLADE_C) {
				glb_io.out.chiusura			= 0;
				glb_io.out.alta_pressione	= 0;
			} else if (glb_io.Ai.p_chiusura_conv < hmi.inp.MAX_OIL_MOV_BLADE_C - 5) {
				//				glb_io.out.chiusura			= 0;
			}
	
		}else if(hmi.cmd.martinetti_close){
			if (glb_io.Ai.p_chiusura_conv >= hmi.inp.MAX_OIL_JACK_C) {
				glb_io.out.chiusura			= 0;
				glb_io.out.alta_pressione	= 0;
			} else if (glb_io.Ai.p_chiusura_conv < hmi.inp.MAX_OIL_JACK_C - 5) {
				//				glb_io.out.chiusura			= 0;
			}
		
		}else if(hmi.cmd.pedana_dw){
			if (glb_io.Ai.p_chiusura_conv >= hmi.inp.MAX_OIL_PEDANA_DW) {
				glb_io.out.chiusura			= 0;
				glb_io.out.alta_pressione	= 0;
			} else if (glb_io.Ai.p_chiusura_conv < hmi.inp.MAX_OIL_PEDANA_DW - 5) {
				//				glb_io.out.chiusura			= 0;
			}
			
		}else if(hmi.cmd.pedana_up){
			if (glb_io.Ai.p_apertura_conv >= hmi.inp.MAX_OIL_PEDANA_UP) {
				glb_io.out.apertura			= 0;
				glb_io.out.alta_pressione	= 0;
			} else if (glb_io.Ai.p_apertura_conv < hmi.inp.MAX_OIL_PEDANA_UP - 5) {
				//				glb_io.out.chiusura			= 0;
			}
		}
	}
	
	REPORT;
}

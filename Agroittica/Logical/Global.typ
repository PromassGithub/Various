(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * File: Global.typ
 * Author: leesa
 * Created: March 27, 2009
 ********************************************************************
 * Global data types of project as3_xsm_ramp
 ********************************************************************)

TYPE
	typ_glb_enc_sta : 	STRUCT 
		range : REAL;
		pinion_diam : REAL;
		enc_rev : UINT;
		bit_res : INT;
		gry : ARRAY[0..11]OF BOOL;
		b_enable : BOOL;
		calib : BOOL;
		words : DINT;
		enc_range : REAL;
		res : REAL;
		act_quote : REAL;
		x : DINT;
		x1 : DINT;
		error : BOOL;
	END_STRUCT;
	typ_cmd : 	STRUCT 
		Reboot_pos : BOOL;
		btn_homing : BOOL;
		Torna_a_casa : BOOL;
		sparo : BOOL;
	END_STRUCT;
	typ_err : 	STRUCT 
		Drive2 : BOOL;
		Drive1 : BOOL;
		pending_alarms : UDINT;
	END_STRUCT;
	typ_hmi_out : 	STRUCT 
		Reset : BOOL;
	END_STRUCT;
	typ_hmi_inp : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	typ_hmi : 	STRUCT 
		Inp : typ_hmi_inp;
		Out : typ_hmi_out;
	END_STRUCT;
	En_AcpMicro_Err : 
		(
		no_error := 0,
		Module_not_enable := 65282,
		Overvoltage_on_dc_bus := 12560,
		Module_power_supply_voltage := 12544,
		Overtemperature := 16896,
		Overtemperature_encoder := 65302,
		Negative_limit_switch_reached := 65312,
		Positive_limit_switch_reached := 65313,
		Overcurrent := 8960,
		Undervoltage_on_the_dc_bus := 12832,
		Undercurrent := 65280,
		Encoder_power_supply := 65296,
		Encoder_open_circuit := 65297
		);
	typ_AcoposMicro_err : 	STRUCT 
		Error : En_AcpMicro_Err;
	END_STRUCT;
	typ_tcp_protocol_state : 	STRUCT 
		place_older : BOOL;
	END_STRUCT;
	typ_eth_connect : 	STRUCT 
		machine_in_auto : BOOL;
		machine_in_man : BOOL;
		machine_stopped : BOOL;
		machine_in_error : BOOL;
		stop_request : BOOL; (*Richiesta di stop*)
		last_cycle_request : BOOL; (*Richiesta di fermarsi dopo il ciclo attuale*)
		step : USINT;
		counter : UINT; (*Contatore*)
		no_comunication : BOOL; (*No comunication with master device*)
		protocol_state : typ_tcp_protocol_state; (*Stato della sincronizzazione*)
		tcp_state : typ_tcp_state; (*Stato della comunicazione tcp*)
		disable : BOOL; (*Disabilito il protocollo di comunicazione*)
		Server_Ip_Add : STRING[15] := '192.168.250.15';
	END_STRUCT;
	typ_tcp_state : 	STRUCT 
		tcpopen : BOOL;
		tcpioctl : BOOL;
		tcpclient : BOOL;
		tcpsend : BOOL;
		tcprecv : BOOL;
		tcpclose : BOOL;
		tcperror : BOOL;
	END_STRUCT;
	typ_Do : 	STRUCT 
		Piston_up : BOOL;
		Piston_gun_2 : BOOL;
		Piston_gun_1 : BOOL;
	END_STRUCT;
	typ_Di : 	STRUCT 
		Finecorsa : BOOL;
		Si_01 : BOOL;
		Si_02 : BOOL;
		Start : BOOL;
		Stop : BOOL;
		Manual : BOOL;
		Automatic : BOOL;
		enc_sta_bit_00 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_01 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_02 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_03 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_04 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_05 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_06 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_07 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_08 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_09 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_10 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
		enc_sta_bit_11 : BOOL; (*Bit encoder movimentazione prelevatore pezzi*)
	END_STRUCT;
	typ_io : 	STRUCT 
		Do : typ_Do;
		Di : typ_Di;
	END_STRUCT;
	En_status : 
		(
		STOP := 0,
		AUTO := 10,
		MANUAL := 20,
		ERR := 30
		);
END_TYPE
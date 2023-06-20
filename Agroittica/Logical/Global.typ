
TYPE
	typ_tcp_state : 	STRUCT 
		tcpopen : BOOL;
		tcpioctl : BOOL;
		tcpclient : BOOL;
		tcpsend : BOOL;
		tcprecv : BOOL;
		tcpclose : BOOL;
		tcperror : BOOL;
	END_STRUCT;
	typ_tcp_protocol_state : 	STRUCT 
		place_older : BOOL;
	END_STRUCT;
	typ_io : 	STRUCT 
		Do : typ_Do;
		Di : typ_Di;
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
	typ_drv_out : 	STRUCT 
		ContolWord6040 : UINT;
		ModesOfOperation_6060 : SINT;
		TargetTorque_6071 : INT;
		TargetPosition607A : DINT;
		FollowingErrorWindow6065 : DINT;
		PositionWindow6067 : DINT;
		PositionWindowTime6068 : INT;
		ProfileVelocity6081 : UDINT;
		ProfileAcceleration6083 : UDINT;
		ProfileDeceleration6084 : UDINT;
		PositonFactor6093_sub1 : UDINT;
		PositonFactor6093_sub2 : UDINT;
		TorqueSlope_6087 : UDINT;
		HomingMethod6098 : SINT;
		HomeOffset607C : DINT;
		HomeHighSpeed6099_sub1 : UDINT;
		HomeLowSpeed6099_sub2 : UDINT;
		HomingAcceleration609A : UDINT;
		TargetVelocity60FF : DINT;
		FeedConstantFeed6092_sub1 : UDINT;
		FeedConstantShaftRev6092_sub2 : UDINT;
		DRV_ON_CMD : BOOL; (*BIT 0 DELLA CONTROL WORD 6040*)
		DRV_ENABLE_VOLT_CMD : BOOL; (*BIT 1 DELLA CONTROL WORD 6040*)
		DRV_QUICK_STOP_CMD : BOOL; (*BIT 2 DELLA CONTROL WORD 6040*)
		DRV_EN_OP_CMD : BOOL; (*BIT 3 DELLA CONTROL WORD 6040*)
		DRV_START_HM_NEW_PP_CMD : BOOL; (*BIT 4 DELLA CONTROL WORD 6040 (NOTA BENE: IN HM VALE HOMING OPERATION START POSITIVE TRIGGER; IN PROFILE POSITION MODE VALE "NEW SETPOINT [POSITIVE TRIGGER]"*)
		DRV_CHANGE_SET_IMM : BOOL; (*BIT 5 DELLA CONTROL WORD 6040-FUNZIONA SOLO CON IL PROFILE POSITION E SERVE PER SETTARE IMMEDIATAMENTE LA POSIZIONE*)
		DRV_TOGGLE_ABS_REL : BOOL; (*BIT 6 DELLA CONTROL WORD 6040- 0=ASSOLUTO; 1=RELATIVO (ENCODER?)*)
		DRV_FAULT_RESET_CMD : BOOL; (*BIT 7 DELLA CONTROL WORD 6040*)
		DRV_HALT_CMD : BOOL; (*BIT 8 DELLA CONTROL WORD 6040*)
	END_STRUCT;
	typ_drv_inp : 	STRUCT 
		DRV_READY : BOOL;
		DRV_ON : BOOL;
		DRV_OPERATION_ENABLED : BOOL;
		DRV_FAULT : BOOL;
		DRV_VOLT_ENABLE : BOOL;
		DRV_SWITCH_ON_DISABLED : BOOL;
		DRV_WARNING : BOOL;
		DRV_REMOTE : BOOL;
		DRV_TARGET_REACHED : BOOL;
		DRV_TARGET_STATUS : BOOL;
		DRV_MOVE_ERROR : BOOL;
		DRV_QUICK_STOP : BOOL;
		StatusWord6041 : UINT;
		ModesOfOperationDisplay_6061 : SINT;
		PositionActualValue6064 : DINT;
		VelocityActualValue606C : DINT;
		TorqueDemandValue_6074 : INT;
		MotorRatedCurrent_6075 : UDINT;
		TorqueActualValue_6077 : INT;
		CurrentActualValue_6078 : INT;
		ErrorCode_603f : UINT;
	END_STRUCT;
	typ_drv : 	STRUCT 
		inp : typ_drv_inp;
		out : typ_drv_out;
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
		Automatic : BOOL;
	END_STRUCT;
	En_status : 
		(
		STOP := 0,
		AUTO := 10,
		MANUAL := 20,
		ERR := 30
		);
END_TYPE

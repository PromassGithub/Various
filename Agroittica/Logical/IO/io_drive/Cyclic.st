
PROGRAM _CYCLIC
	(* Insert code here *)
	
//	
//	Ctr_Fasatore.inp.posizione_mst							=		glb_fas_mst.inp.PositionActualValue6064;
//	Ctr_Fasatore.inp.velocity_mst 							=  		glb_fas_mst.inp.VelocityActualValue606C;
//	Ctr_Fasatore.inp.torque_mst 							= 		glb_fas_mst.inp.TorqueActualValue_6077;
//	Ctr_Fasatore.inp.stato_mst								=  		glb_fas_mst.inp.StatusWord6041;
	
	glb_drv.inp.DRV_READY 								:= 		(glb_drv.inp.StatusWord6041 AND bit_0) > 0;
	glb_drv.inp.DRV_ON 									:= 		(glb_drv.inp.StatusWord6041 AND bit_1) > 0;
	glb_drv.inp.DRV_OPERATION_ENABLED 					:= 		(glb_drv.inp.StatusWord6041 AND bit_2) > 0;
	glb_drv.inp.DRV_FAULT 								:= 		(glb_drv.inp.StatusWord6041 AND bit_3) > 0;
	glb_drv.inp.DRV_VOLT_ENABLE 						:= 		(glb_drv.inp.StatusWord6041 AND bit_4) > 0;
	glb_drv.inp.DRV_QUICK_STOP 							:= 		(glb_drv.inp.StatusWord6041 AND bit_5) > 0;
	glb_drv.inp.DRV_SWITCH_ON_DISABLED 					:= 		(glb_drv.inp.StatusWord6041 AND bit_6) > 0;
	glb_drv.inp.DRV_WARNING 							:= 		(glb_drv.inp.StatusWord6041 AND bit_7) > 0;
	glb_drv.inp.DRV_REMOTE 								:= 		(glb_drv.inp.StatusWord6041 AND bit_9) > 0;
	glb_drv.inp.DRV_TARGET_REACHED 						:= 		(glb_drv.inp.StatusWord6041 AND bit_10) > 0;
	glb_drv.inp.DRV_TARGET_STATUS 						:= 		(glb_drv.inp.StatusWord6041 AND bit_11) > 0;
	glb_drv.inp.DRV_MOVE_ERROR 							:= 		(glb_drv.inp.StatusWord6041 AND bit_12) > 0;
	
	IF (glb_drv.out.DRV_ON_CMD) 				THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_0; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_0; END_IF
	IF (glb_drv.out.DRV_ENABLE_VOLT_CMD) 		THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_1; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_1; END_IF
	IF (glb_drv.out.DRV_QUICK_STOP_CMD) 		THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_2; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_2; END_IF
	IF (glb_drv.out.DRV_EN_OP_CMD) 				THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_3; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_3; END_IF
	IF (glb_drv.out.DRV_START_HM_NEW_PP_CMD)	THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_4; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_4; END_IF
	IF (glb_drv.out.DRV_CHANGE_SET_IMM) 		THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_5; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_5; END_IF
	IF (glb_drv.out.DRV_TOGGLE_ABS_REL) 		THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_6; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_6; END_IF
	IF (glb_drv.out.DRV_FAULT_RESET_CMD) 		THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_7; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_7; END_IF
	IF (glb_drv.out.DRV_HALT_CMD) 				THEN	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 OR bit_8; 		ELSE 	glb_drv.out.ContolWord6040 := glb_drv.out.ContolWord6040 AND UINT_negato_8; END_IF
	
	

	 
END_PROGRAM

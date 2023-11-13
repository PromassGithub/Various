
PROGRAM _CYCLIC
	
//	FIFO_0.INOutStatus := 1;
//	FIFO_0.DataIn := Result_String_Real;
//	
//	IF (Del_Var_Sens) OR (Del_Var_Shoot) THEN
//		FIFO_0.INOutStatus := 2;
//		OutData := FIFO_0.DataOut;
//	END_IF;

	CASE glb_FIFO.FIFO_Status OF
		
		0:
			IF (Control_Var) THEN
				glb_FIFO.FIFO_Status := 10;
			END_IF;
			
		10:
			FIFO_0.INOutStatus := 0;
			
			R_TRIG_05 (CLK := IN_Var);
			IN_Var_Out := R_TRIG_05.Q;
			
			R_TRIG_06 (CLK := Del_Var_Sens);
			Del_Var_Sens_Out := R_TRIG_06.Q;
			
			R_TRIG_07 (CLK := Del_Var_Shoot);
			Del_Var_Shoot_Out := R_TRIG_07.Q;
			
			IF (IN_Var_Out) THEN
				glb_FIFO.FIFO_Status := 20;
			END_IF;
			
			IF (Del_Var_Shoot_Out) OR (Del_Var_Sens_Out) THEN
				glb_FIFO.FIFO_Status := 30;
			END_IF;
			
			IF (NOT Control_Var) THEN glb_FIFO.FIFO_Status := 40; END_IF;
			
		20:
			FIFO_0.INOutStatus := 1;
			FIFO_0.DataIn := glb_String.Result_Real;
			IN_Var := 0;
			glb_FIFO.FIFO_Status := 40;
					
			IF (NOT Control_Var) THEN glb_FIFO.FIFO_Status := 40; END_IF;
			
		30:
			FIFO_0.INOutStatus := 2;
			OutData := FIFO_0.DataOut;
			Del_Var_Shoot := 0;
			Del_Var_Sens := 0;
			glb_FIFO.FIFO_Status := 40;
			
			IF (NOT Control_Var) THEN glb_FIFO.FIFO_Status := 40; END_IF;
		
		40:
			R_TRIG_05.CLK := 0;
			R_TRIG_06.CLK := 0;
			R_TRIG_07.CLK := 0;
			glb_FIFO.FIFO_Status := 0;
			
	END_CASE;
	
	FIFO_0;
	
	R_TRIG_05;
	R_TRIG_06;
	R_TRIG_07;
	
END_PROGRAM

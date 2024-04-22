
PROGRAM _CYCLIC
	
//	FIFO_0.INOutStatus := 1;
//	FIFO_0.DataIn := Result_String_Real;
//	
//	IF (Del_Var_Sens) OR (Del_Var_Shoot) THEN
//		FIFO_0.INOutStatus := 2;
//		OutData := FIFO_0.DataOut;
//	END_IF;
	
	
//	TON_clear.IN := 1;
//	IF (Status <> AUTO) THEN 
//		glb_data.received_data := 0;
//		FIFO_0.clear_data := 1;
//	ELSE
//		FIFO_0.clear_data := 0;
//	END_IF
	
	IF (glb_io.Di.Si_01) THEN glb_pesce_passato := 1; END_IF
	
	IF (glb_data.received_data) THEN TON_clear.IN := 0; END_IF
	
	IF (TON_clear.Q) THEN FIFO_0.clear_data := 1; END_IF
	
	CASE in OF
		0:
			IF (glb_data.received_data) THEN
				in := 10;
				glb_data.received_data := 0;
				
				glb_String.Raw_Length := LEN(Eth_connect.Marel_Weight);
				glb_String.Length := glb_String.Raw_Length - 2;
				glb_String.Result := MID(Eth_connect.Marel_Weight, glb_String.Length, 2); 
				glb_String.Result_Real := (STRING_TO_REAL(glb_String.Result));
				glb_String.Result_Real := (glb_String.Result_Real * INT_TO_REAL(1000));
				
				FIFO_0.INWrite := 1;
				FIFO_0.DataIn := glb_String.Result_Real;
				
			END_IF
		10:
			FIFO_0.INWrite := 0;
			in := 0;
		
	END_CASE
	
	CASE out OF
		0: 
			OutData := FIFO_0.DataOut;
			IF (glb_st_gun_wait) THEN
				out := 10;
				glb_st_gun_wait := 0;
				FIFO_0.INRead := 1;
			END_IF
		10:
			FIFO_0.INRead := 0;
			out := 0;
		
	END_CASE
	

//	CASE glb_FIFO.FIFO_Status OF
//		
//		0:	//START
//			IF (Status = AUTO AND glb_err.pending_alarms = 0) THEN
//				glb_FIFO.FIFO_Status := 10;
//			END_IF;
//			
//		10:	//AUTO IDLE
//			FIFO_0.INWrite := 0;
//
//			
//			IF (glb_data.received_data) THEN
//				glb_FIFO.FIFO_Status := 20;
//				glb_data.received_data := 0;
//			END_IF;
//			
//			IF ((Status <> AUTO) OR (glb_err.pending_alarms <> 0)) THEN glb_FIFO.FIFO_Status := 40; END_IF;
//			
//		20:	//INSERT DATA INTO BUFFER & STRING SEPARATION
//			
//			//string separation	
//			glb_String.Raw_Length := LEN(Eth_connect.Marel_Weight);
//			
//			glb_String.Length := glb_String.Raw_Length - 2;
//	
//			glb_String.Result := MID(Eth_connect.Marel_Weight, glb_String.Length, 2); 
//	
//			glb_String.Result_Real := (STRING_TO_REAL(glb_String.Result));
//			glb_String.Result_Real := (glb_String.Result_Real * INT_TO_REAL(1000));
//			
//			IF (Ricette.use_weight AND (glb_String.Result_Real = -1000)) THEN
//				FIFO_0.INWrite := 0;
//			ELSIF (Ricette.use_weight AND ((glb_String.Result_Real <= Pesi_0.Max_Weight_A AND glb_String.Result_Real >= Pesi_0.Min_Weight_A) OR (glb_String.Result_Real <= Pesi_0.Max_Weight_B AND glb_String.Result_Real >= Pesi_0.Min_Weight_B)))THEN
//				FIFO_0.INWrite := 1;
//				glb_registered := 1;
//			ELSE
//				FIFO_0.INWrite := 1;
//			END_IF
//			
//			// Insert data into buffer
////			FIFO_0.INWrite := 1;
//			FIFO_0.DataIn := glb_String.Result_Real;
//			glb_FIFO.FIFO_Status := 40;
//			
//		30:	//DELETE DATA FROM BUFFER			
//			FIFO_0.INRead := 1;
//			glb_FIFO.FIFO_Status := 40;
//		
//		40:	//RESET & BACK TO START
//			
//			glb_FIFO.FIFO_Status := 0;
//			FIFO_0.INWrite := 0;
//			
//	END_CASE;
	
//	CASE glb_FIFO.FIFO_Status_read OF
//		
//		0: glb_FIFO.FIFO_Status_read := 10;
//		
//		10:	//AUTO IDLE			
//			OutData := FIFO_0.DataOut;
//			FIFO_0.INRead := 0;
//			TON_sens_in.IN := 0;
//			
////			IF glb_io.Di.Si_01 AND (NOT Ricette.use_weight) THEN
//			glb_FIFO.FIFO_Status_read := 30;
//				
////			END_IF;
//		
//		30:	//DELETE DATA FROM BUFFER
//			
//			FIFO_0.INRead := 1;
//			TON_sens_in.IN := 1;
//			glb_FIFO.FIFO_Status_read := 40;
//		
//		40:	//RESET & BACK TO START
//			FIFO_0.INRead := 0;
//			//			IF ((NOT glb_io.Di.Si_01) AND TON_sens_in.Q) THEN
//			IF (glb_st_gun_wait) AND (NOT Ricette.use_weight) THEN
//				glb_FIFO.FIFO_Status_read := 0;
//				glb_st_gun_wait := 0;
//				TON_sens_in.IN := 0;
//			END_IF
//		
//		
//	END_CASE
	
	FIFO_0;
	
	TON_sens_in;
	TON_sens_in.PT := tempo_scans;
	
	TON_clear;
	TON_clear.PT := T#1s;
	
	R_TRIG_05;
	R_TRIG_06;
	R_TRIG_07;
	
	Pesi_0.Controlled_Weight := FIFO_0.DataOut;
	IF test_buff THEN 
		glb_FIFO.FIFO_Status := 20;
		glb_FIFO.FIFO_Status_read := 30;
		test_buff := 0;
	END_IF
	
	
END_PROGRAM

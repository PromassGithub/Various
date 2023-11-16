
PROGRAM _CYCLIC
	
//	FIFO_0.INOutStatus := 1;
//	FIFO_0.DataIn := Result_String_Real;
//	
//	IF (Del_Var_Sens) OR (Del_Var_Shoot) THEN
//		FIFO_0.INOutStatus := 2;
//		OutData := FIFO_0.DataOut;
//	END_IF;
	
	IF (glb_io.Di.Si_01) THEN glb_pesce_passato := 1; END_IF

	CASE glb_FIFO.FIFO_Status OF
		
		0:
			//IF (Control_Var) THEN
				glb_FIFO.FIFO_Status := 10;
			//END_IF;
			
		10:
			FIFO_0.INOutStatus := 0;
			
			OutData := FIFO_0.DataOut;
			
			IF (glb_dato_arrivato) THEN
				glb_FIFO.FIFO_Status := 20;
				glb_dato_arrivato := 0;
			END_IF;
			
			IF glb_pesce_passato THEN
				glb_FIFO.FIFO_Status := 30;
				glb_pesce_passato := 0;
			END_IF;
			
			//IF (NOT Control_Var) THEN glb_FIFO.FIFO_Status := 40; END_IF;
			
		20:
			//string separation	
			glb_String.Raw_Length := LEN(Eth_connect.Marel_Weight);
	
			IF glb_String.Raw_Length = 6 THEN
				glb_String.Length := 4;
			ELSIF glb_String.Raw_Length = 5 THEN
				glb_String.Length := 3;
			END_IF;
	
			glb_String.Result := MID(Eth_connect.Marel_Weight, glb_String.Length, 2); 
	
			glb_String.Result_Real := STRING_TO_REAL(glb_String.Result);
			
			FIFO_0.INOutStatus := 1;
			FIFO_0.DataIn := glb_String.Result_Real;
			glb_FIFO.FIFO_Status := 40;
			
		30:
			FIFO_0.INOutStatus := 2;
			
			glb_FIFO.FIFO_Status := 40;
		
		40:
			R_TRIG_05.CLK := 0;
			R_TRIG_06.CLK := 0;
			R_TRIG_07.CLK := 0;
			glb_FIFO.FIFO_Status := 0;
			FIFO_0.INOutStatus := 0;
			
	END_CASE;
	
	FIFO_0;
	
	R_TRIG_05;
	R_TRIG_06;
	R_TRIG_07;
	
END_PROGRAM

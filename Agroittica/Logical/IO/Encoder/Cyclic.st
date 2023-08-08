PROGRAM _CYCLIC
	(* Insert code here *)
	
	glb_enc_sta.b_enable     := 1;
	
	glb_enc_sta.bit_res := 12; 		//Risoluzione encoder
	glb_enc_sta.pinion_diam := 130; //Diametro pignone encoder
	glb_enc_sta.enc_rev := 1; 		//Rapporto riduzione tra albero ed encoder
	

	glb_enc_sta.words        := REAL_TO_DINT( pow(2, glb_enc_sta.bit_res));
	glb_enc_sta.enc_range    := (glb_enc_sta.pinion_diam * 3.14 * glb_enc_sta.enc_rev); (*/* 7 is the motor reduction */*)
	glb_enc_sta.res          := glb_enc_sta.enc_range / glb_enc_sta.words;    (*/* Resol. in [U] is worked out  */*)
	
	IF (glb_enc_sta.b_enable = 1) THEN

		(*/* Reads the data from the GRAY ABSOLUTE ENCODER */*)
		glb_enc_sta.gry[0]  := glb_io.Di.enc_sta_bit_00;
		glb_enc_sta.gry[1]  := glb_io.Di.enc_sta_bit_01;
		glb_enc_sta.gry[2]  := glb_io.Di.enc_sta_bit_02;
		glb_enc_sta.gry[3]  := glb_io.Di.enc_sta_bit_03;
		glb_enc_sta.gry[4]  := glb_io.Di.enc_sta_bit_04;
		glb_enc_sta.gry[5]  := glb_io.Di.enc_sta_bit_05;
		glb_enc_sta.gry[6]  := glb_io.Di.enc_sta_bit_06;
		glb_enc_sta.gry[7]  := glb_io.Di.enc_sta_bit_07;
		glb_enc_sta.gry[8]  := glb_io.Di.enc_sta_bit_08;
		glb_enc_sta.gry[9]  := glb_io.Di.enc_sta_bit_09;
		glb_enc_sta.gry[10] := glb_io.Di.enc_sta_bit_10;
		glb_enc_sta.gry[11] := glb_io.Di.enc_sta_bit_11;
		

		
		
		gray_to_int_0.gry := glb_enc_sta.gry;
		glb_enc_sta.x := gray_to_int_0.x;
		gray_to_int_0;
		
		IF (glb_sim = 1) THEN
			
			glb_enc_sta.x := glb_enc_sim.x;
			
		END_IF;
		
		Int_to_vel_0.Maxim := glb_enc_sta.words;
		Int_to_vel_0.Pos := glb_enc_sta.x;
		Int_to_vel_0;

		IF ((glb_enc_sta.x < 0) OR (glb_enc_sta.x >= glb_enc_sta.words)) THEN
			glb_enc_sta.error := 1;
		ELSE												             
			glb_enc_sta.error := 0;
		END_IF
	END_IF
	
	STP_01_Vel := Int_to_vel_0.Vel;
	STP_01_Pos := Int_to_vel_0.Pos;
		
		
END_PROGRAM

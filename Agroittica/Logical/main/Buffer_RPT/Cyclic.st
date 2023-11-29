
PROGRAM _CYCLIC
	(* Insert code here *)
	Str_Length 	:= LEN(Eth_connect.Marel_Weight);	
	Str_weight 	:= MID(Eth_connect.Marel_Weight, (Str_Length-2), 2); 
	
	
	
	
	// .......................... sensore pistola ..........................
	IF(glb_io.Di.Si_01 AND (NOT s01_b))THEN
		//rpt
		RPT_Buffer.sensore_pistola[indice] := glb_io.Di.Si_01;
		RPT_Buffer.time_stamp[indice] := glb_time;
		// hmi
		sensore_pistola := 80;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		
		s01_b := TRUE;
	ELSIF((NOT glb_io.Di.Si_01) AND s01_b) THEN
		//rpt
		RPT_Buffer.sensore_pistola[indice] := glb_io.Di.Si_01;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		sensore_pistola := 0;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		
		s01_b := FALSE;
	END_IF
	
	// .......................... pistone sollevamento principale ..........................
	IF(glb_io.Do.Main_Piston_Up AND (NOT Piston_Up_b))THEN
		//rpt
		RPT_Buffer.pistone_soll_su[indice] := glb_io.Do.Main_Piston_Up;
		RPT_Buffer.pistone_soll_giu[indice] := glb_io.Do.Main_Piston_Down;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_soll_su := 110;
		pistone_soll_giu := 0;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		
		Piston_Up_b := TRUE;
	ELSIF((NOT glb_io.Do.Main_Piston_Up) AND Piston_Up_b) THEN
		//rpt
		RPT_Buffer.pistone_soll_su[indice] := glb_io.Do.Main_Piston_Up;
		RPT_Buffer.pistone_soll_giu[indice] := glb_io.Do.Main_Piston_Down;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_soll_su := 0;
		pistone_soll_giu := 110;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		
		Piston_Up_b := FALSE;
	END_IF
	
	// .......................... pistone pistola 1 ..........................
	IF(glb_io.Do.Piston_gun_1 AND (NOT gun_1_b))THEN
		//rpt
		RPT_Buffer.pistone_pistola_1[indice] := glb_io.Do.Piston_gun_1;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_pistola_1 := 140;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		
		gun_1_b := TRUE;
	ELSIF((NOT glb_io.Do.Piston_gun_1) AND gun_1_b) THEN
		//rpt
		RPT_Buffer.pistone_pistola_1[indice] := glb_io.Do.Piston_gun_1;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_pistola_1 := 0;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		gun_1_b := FALSE;
	END_IF
	
	// .......................... pistone pistola 2 ..........................
	IF(glb_io.Do.Piston_gun_2 AND (NOT gun_2_b))THEN
		//rpt
		RPT_Buffer.pistone_pistola_2[indice] := glb_io.Do.Piston_gun_2;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_pistola_2 := 140;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		gun_2_b := TRUE;
	ELSIF((NOT glb_io.Do.Piston_gun_2) AND gun_2_b) THEN
		//rpt
		RPT_Buffer.pistone_pistola_2[indice] := glb_io.Do.Piston_gun_2;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		pistone_pistola_2 := 0;
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		gun_2_b := FALSE;
	END_IF
	
	// .......................... bilancia ..........................
	IF(glb_rpt)THEN
		//rpt
		RPT_Buffer.bilancia[indice] := Eth_connect.Marel_Weight;
		RPT_Buffer.time_stamp[indice] := glb_time;
		//hmi
		Bilancia := (STRING_TO_REAL(Str_weight));
		Bilancia := (Bilancia * INT_TO_REAL(1000));
		
		
		indice := indice + 1; 
		updt_hmi_trend := 1;
		glb_rpt := FALSE;
	END_IF
	
	// .......................... passo i dasi al RPT_CSV ..........................
	IF (indice >= 200) THEN
		FOR i := 0 TO 199 DO
			glb_data.bilancia[i]			:= RPT_Buffer.bilancia[i];
			glb_data.pistone_pistola_1[i]	:= RPT_Buffer.pistone_pistola_1[i];
			glb_data.pistone_pistola_2[i]	:= RPT_Buffer.pistone_pistola_2[i];
			glb_data.pistone_soll_giu[i]	:= RPT_Buffer.pistone_soll_giu[i];
			glb_data.pistone_soll_su[i]		:= RPT_Buffer.pistone_soll_su[i];
			glb_data.sensore_pistola[i]		:= RPT_Buffer.sensore_pistola[i];
			glb_data.time_stamp[i]			:= RPT_Buffer.time_stamp[i];
			
			RPT_Buffer.bilancia[i] 			:= '0';
			RPT_Buffer.pistone_pistola_1[i]	:= 255;
			RPT_Buffer.pistone_pistola_2[i]	:= 255;
			RPT_Buffer.pistone_soll_giu[i]	:= 255;
			RPT_Buffer.pistone_soll_su[i]	:= 255;
			RPT_Buffer.sensore_pistola[i]	:= 255;
			RPT_Buffer.time_stamp[i]		:= DT#1970-01-01-00:00:00;
		END_FOR;
		
		FOR i := 200 TO 249 DO
			IF (RPT_Buffer.time_stamp[i] <> DT#1970-01-01-00:00:00) THEN
				RPT_Buffer.bilancia[i-200] 			:= RPT_Buffer.bilancia[i];
				RPT_Buffer.pistone_pistola_1[i-200]	:= RPT_Buffer.pistone_pistola_1[i];
				RPT_Buffer.pistone_pistola_2[i-200]	:= RPT_Buffer.pistone_pistola_2[i];
				RPT_Buffer.pistone_soll_giu[i-200]	:= RPT_Buffer.pistone_soll_giu[i];
				RPT_Buffer.pistone_soll_su[i-200]	:= RPT_Buffer.pistone_soll_su[i];
				RPT_Buffer.sensore_pistola[i-200]	:= RPT_Buffer.sensore_pistola[i];
				RPT_Buffer.time_stamp[i-200]		:= RPT_Buffer.time_stamp[i];
				
				RPT_Buffer.bilancia[i] 			:= '0';
				RPT_Buffer.pistone_pistola_1[i]	:= 255;
				RPT_Buffer.pistone_pistola_2[i]	:= 255;
				RPT_Buffer.pistone_soll_giu[i]	:= 255;
				RPT_Buffer.pistone_soll_su[i]	:= 255;
				RPT_Buffer.sensore_pistola[i]	:= 255;
				RPT_Buffer.time_stamp[i]		:= DT#1970-01-01-00:00:00;
			END_IF
		END_FOR
		
		glb_data.Trigger := 1;
		indice := 0;
	END_IF	
	
	IF (updt_hmi_trend) THEN 
		Hmi_trend_01.INWrite := 1;
		Hmi_trend_02.INWrite := 1;
		Hmi_trend_03.INWrite := 1;
		Hmi_trend_04.INWrite := 1;
		Hmi_trend_05.INWrite := 1;
		Hmi_trend_06.INWrite := 1;
	ELSE
		Hmi_trend_01.INWrite := 0;
		Hmi_trend_02.INWrite := 0;
		Hmi_trend_03.INWrite := 0;
		Hmi_trend_04.INWrite := 0;
		Hmi_trend_05.INWrite := 0;
		Hmi_trend_06.INWrite := 0;
	END_IF
	
	updt_hmi_trend := 0;
		
		
	Hmi_trend_01.DataIn := Bilancia;
	Hmi_trend_02.DataIn := pistone_pistola_1;
	Hmi_trend_03.DataIn := pistone_pistola_2;
	Hmi_trend_04.DataIn := pistone_soll_su;
	Hmi_trend_05.DataIn := pistone_soll_giu;
	Hmi_trend_06.DataIn := sensore_pistola;
	
	Hmi_trend_01;
	Hmi_trend_02;
	Hmi_trend_03;
	Hmi_trend_04;
	Hmi_trend_05;
	Hmi_trend_06;
	
	RPT_Buffer_hmi.bilancia 			:= Hmi_trend_01.Buffer;
	RPT_Buffer_hmi.pistone_pistola_1 	:= Hmi_trend_02.Buffer;
	RPT_Buffer_hmi.pistone_pistola_2 	:= Hmi_trend_03.Buffer;
	RPT_Buffer_hmi.pistone_soll_su 		:= Hmi_trend_04.Buffer;
	RPT_Buffer_hmi.pistone_soll_giu 	:= Hmi_trend_05.Buffer;
	RPT_Buffer_hmi.sensore_pistola 		:= Hmi_trend_06.Buffer;
	
	RPT_Buffer_hmi.bilancia[200] 			:= RPT_Buffer_hmi.bilancia[199];
	RPT_Buffer_hmi.pistone_pistola_1[200] 	:= RPT_Buffer_hmi.pistone_pistola_1[199];
	RPT_Buffer_hmi.pistone_pistola_2[200] 	:= RPT_Buffer_hmi.pistone_pistola_2[199];
	RPT_Buffer_hmi.pistone_soll_su[200] 	:= RPT_Buffer_hmi.pistone_soll_su[199];
	RPT_Buffer_hmi.pistone_soll_giu[200] 	:= RPT_Buffer_hmi.pistone_soll_giu[199];
	RPT_Buffer_hmi.sensore_pistola[200] 	:= RPT_Buffer_hmi.sensore_pistola[199];
	 
END_PROGRAM

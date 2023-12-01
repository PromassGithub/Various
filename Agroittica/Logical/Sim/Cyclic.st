
PROGRAM _CYCLIC
	(* Insert code here *)
//	Feedback_0.Feedback_Em_Bt := 1;
//	Feedback_0.Feedback_Air := 1;
//	glb_sim := 1;
//	glb_enc_sim.x := glb_enc_sim.x + 1;
//	IF (glb_enc_sim.x > 4096) THEN
//		glb_enc_sim.x := 0;
//	END_IF;
//	
//	IF (Second_Scan = 0) THEN
//		Second_Scan := 1;
//		Auto_Homing_Ctrl_0.Auto_Homing_Status := 0;
//	END_IF;
	time_ms := clock_ms();
		
	CASE tempo_del_cazzo OF
		0: IF (glb_data.received_data) THEN tempo_del_cazzo := 1; END_IF
			
		1:
			ton_0.IN := 1;
			IF ton_0.Q THEN
				ton_0.IN := 0;
				glb_io.Di.Si_01 := 1;
				tempo_del_cazzo := 2;
			END_IF
			
		2:
			ton_1.IN := 1;
			IF ton_1.Q THEN
				ton_1.IN := 0;
				glb_io.Di.Si_01 := 0;
				tempo_del_cazzo := 0;
			END_IF
	END_CASE
	
	ton_0;
	ton_0.PT := T#500ms;
	ton_1;
	ton_1.PT := T#100ms;
	
	IF (SIMU.enable)THEN 
	
		IF ((NOT diminuisci)) THEN 
			bilancia_simulata := bilancia_simulata + 0.00199;
		ELSIF (diminuisci) THEN
			bilancia_simulata := bilancia_simulata - 0.00301;
		END_IF
		
		IF(bilancia_simulata >= 2)THEN
			diminuisci := 1;
		ELSIF ((bilancia_simulata <= 0.250)) THEN
			diminuisci := 0;
		END_IF
		
		random := random +1;
		IF random >= 2000 THEN random := 0; END_IF
		
		random := DT_TO_UDINT(glb_time);
		random := (random * 1103515245 + 12345) AND 2147483647;
		random := (random / 65536) MOD 100;

		IF ((random < 99 AND random > 90)  AND (random <> random1)) THEN 
			memset (ADR(Eth_connect.Marel_Weight), 0, SIZEOF(Eth_connect.Marel_Weight));
			memset (ADR(support_str), 0, SIZEOF(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR('$02'));
			ftoa(-1, ADR(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR('$03'));
			time_0 := time_ms;
			time_0 := time_ms;
			time_1 := time_ms - T#500ms;
			time_2 := time_1;
			glb_data.received_data 				:= 1;
			glb_rpt								:= 1;
			random1 := random;
		ELSE
			memset (ADR(Eth_connect.Marel_Weight), 0, SIZEOF(Eth_connect.Marel_Weight));
			memset (ADR(support_str), 0, SIZEOF(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR('$02'));
			ftoa(bilancia_simulata, ADR(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR(support_str));
			strcat(ADR(Eth_connect.Marel_Weight), ADR('$03'));
		END_IF
		
		IF (DiffT(time_ms,time_0) > 750 ) THEN
			time_0 := time_ms;
			glb_data.received_data 				:= 1;
			glb_rpt								:= 1;
		END_IF
		
		IF (DiffT(time_ms,time_1) > 750 ) THEN
			time_1 := time_ms;
			time_2 := time_1;
			glb_io.Di.Si_01 := 1;
		END_IF
		
		IF ((DiffT(time_ms,time_2) > 100 ) AND (glb_io.Di.Si_01)) THEN
			glb_io.Di.Si_01 := 0;
		END_IF
		
	ELSE
//		time_ms := clock_ms();
//		time_0 := time_ms;
//		time_1 := time_ms - T#500ms;
//		time_2 := time_1;
		
	END_IF
END_PROGRAM

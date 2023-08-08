
PROGRAM _CYCLIC
	(* Insert code here *)
	Feedback_0.Feedback_Em_Bt := 1;
	Feedback_0.Feedback_Air := 1;
	glb_sim := 1;
	glb_enc_sim.x := glb_enc_sim.x + 1;
	IF (glb_enc_sim.x > 4096) THEN
		glb_enc_sim.x := 0;
	END_IF;
	
	IF (Second_Scan = 0) THEN
		Second_Scan := 1;
		Auto_Homing_Ctrl_0.Auto_Homing_Status := 0;
	END_IF;
	

		
	
END_PROGRAM

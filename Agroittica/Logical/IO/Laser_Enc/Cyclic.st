
PROGRAM _CYCLIC
	(* Insert code here *)
	
//	Enc_laser_dist_raw;
	
	m_laser_enc := (2150);
	m_laser_enc := m_laser_enc / (32767-3277);
	
	glb_io.Ai.Enc_laser_dist_conv := ((m_laser_enc*(INT_TO_REAL (glb_io.Ai.Enc_laser_dist_raw-3277))) + Enc_laser_offset);
	
	glb_io.Ai.Enc_laser_dist_conv1 := ((m_laser_enc*(INT_TO_REAL (glb_io.Ai.Enc_laser_dist_raw-3277))) + Enc_laser_offset);
	
//	Enc_laser_dist_conv := ((2300-150)/(32767 - 3277))*((INT_TO_REAL (Enc_laser_dist_raw)) - 3277);
	
	IF (((glb_io.Ai.Enc_laser_dist_conv - 2) < Ricette.Laser_trigger) AND (NOT(glb_fish_shot_ons)))  THEN
		glb_io.Di.Finecorsa  := 1;
		glb_fish_shot_ons    := 1;
	END_IF;
	
	IF ((glb_io.Ai.Enc_laser_dist_conv > 390) AND (glb_fish_shot_ons)) THEN
		glb_fish_shot_ons := 0;
		glb_io.Di.Finecorsa  := 0;
	END_IF;
	
	
END_PROGRAM

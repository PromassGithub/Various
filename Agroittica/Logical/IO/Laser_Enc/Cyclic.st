
PROGRAM _CYCLIC
	(* Insert code here *)
	
	Enc_laser_dist_raw;
	
	m_laser_enc := (2150);
	m_laser_enc := m_laser_enc / 32767;
	
	Enc_laser_dist_conv := ((m_laser_enc*(INT_TO_REAL (Enc_laser_dist_raw))) + Enc_laser_offset);
	
	IF (((Enc_laser_dist_conv -2) < glb_fish_pos_trigger) AND (NOT(glb_fish_shot_ons)))  THEN
		glb_io.Di.Finecorsa  := 1;
		glb_fish_shot_ons    := 1;
	END_IF;
	
	IF ((Enc_laser_dist_conv > 350) AND (glb_fish_shot_ons)) THEN
		glb_fish_shot_ons := 0;
		glb_io.Di.Finecorsa  := 0;
	END_IF;
	
	
END_PROGRAM

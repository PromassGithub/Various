
PROGRAM _CYCLIC
	(* Insert code here *)
	
	Enc_laser_dist_raw;
	
	m_laser_enc := (2150);
	m_laser_enc := m_laser_enc / 32767;
	
	Enc_laser_dist_conv := ((m_laser_enc*(INT_TO_REAL (Enc_laser_dist_raw))) + Enc_laser_offset);
	
END_PROGRAM

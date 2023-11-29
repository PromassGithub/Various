
PROGRAM _CYCLIC
	(* Insert code here *)
		// ..........................          ..........................
	
	IF (change_scale) THEN
		Trend_min_value := -20;
		Trend_max_value := 150;
	ELSE
		Trend_min_value := -1100;
		Trend_max_value := 4000;
	END_IF
	
	CASE Trend_show_value OF
		
		0:
			IF (Trend_reduce_n_d_value) THEN 
				Trend_show_value 		:= 10;
				Trend_reduce_n_d_value 	:= 0;
			END_IF
			
			Trend_max_n_disp_value := 200;
			Trend_zoom := 1;
			Trend_scroll := 1-(0.9/Trend_zoom);
			
		10:
			IF (Trend_reduce_n_d_value) THEN 
				Trend_show_value 		:= 20;
				Trend_reduce_n_d_value 	:= 0;
			END_IF
			
			Trend_max_n_disp_value := 200;
			
			Trend_zoom := 1.5;
			Trend_scroll := 1-(0.9/Trend_zoom);
			
		20:
			IF (Trend_reduce_n_d_value) THEN 
				Trend_show_value 		:= 30;
				Trend_reduce_n_d_value 	:= 0;
			END_IF
			
			Trend_max_n_disp_value := 200;
			
			Trend_zoom := 2;
			Trend_scroll := 1-(0.9/Trend_zoom);
		  
		30:
			IF (Trend_reduce_n_d_value) THEN 
				Trend_show_value 		:= 40;
				Trend_reduce_n_d_value 	:= 0;
			END_IF
		
			Trend_max_n_disp_value := 200;
			
			Trend_zoom := 4;
			Trend_scroll := 1-(0.9/Trend_zoom);
		
		40:
			IF (Trend_reduce_n_d_value) THEN 
				Trend_show_value 		:= 0;
				Trend_reduce_n_d_value 	:= 0;
			END_IF
		
			Trend_max_n_disp_value := 200;
			
			Trend_zoom := 6;
			Trend_scroll := 1-(0.9/Trend_zoom);

	END_CASE;  
	 
END_PROGRAM

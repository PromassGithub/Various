
TYPE
	typ_rpt_buffer_hmi : 	STRUCT 
		bilancia : ARRAY[1..200]OF REAL := [200(0.0)];
		sensore_pistola : ARRAY[1..200]OF REAL := [200(0.0)];
		pistone_soll_giu : ARRAY[1..200]OF REAL := [200(0.0)];
		pistone_soll_su : ARRAY[1..200]OF REAL := [200(0.0)];
		pistone_pistola_2 : ARRAY[1..200]OF REAL := [200(0.0)];
		pistone_pistola_1 : ARRAY[1..200]OF REAL := [200(0.0)];
		time_stamp : ARRAY[0..249]OF DATE_AND_TIME;
	END_STRUCT;
	typ_rpt_buffer : 	STRUCT 
		bilancia : ARRAY[0..249]OF STRING[50] := [250('0')];
		sensore_pistola : ARRAY[0..249]OF USINT := [250(255)];
		pistone_soll_giu : ARRAY[0..249]OF USINT := [250(255)];
		pistone_soll_su : ARRAY[0..249]OF USINT := [250(255)];
		pistone_pistola_2 : ARRAY[0..249]OF USINT := [250(255)];
		pistone_pistola_1 : ARRAY[0..249]OF USINT := [250(255)];
		time_stamp : ARRAY[0..249]OF DATE_AND_TIME;
	END_STRUCT;
END_TYPE

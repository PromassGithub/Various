
TYPE
	gs_typ : 	STRUCT 
		st_ninfo : UINT;
		name : ARRAY[0..79] OF USINT;
		data_typ : UDINT;
		var_len : UDINT;
		dim : ARRAY[0..14] OF UINT;
		st_item : UINT;
		cnt_dim : ARRAY[0..14] OF UINT;
		field : ARRAY[0..32] OF USINT;
		idx_lev : INT;
		len : INT;
		flag_arr_str : ARRAY[0..14] OF BOOL;
		cnt_arr_str : ARRAY[0..14] OF UINT;
		ascii_value : STRING[25];
		var_addr : UDINT;
		var_dim : UINT;
		ret_pvixgetadr : UINT;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK Rec_get_comm
VAR
		step	:USINT;	
		k	:UDINT;	
		j	:UDINT;	
		start	:UDINT;	
		do_info	:DatObjInfo;	
		count_comm	:UDINT;	
		prevstep	:USINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
	END_VAR
	VAR_OUTPUT
		comm	:STRING[45];	
		status	:UINT;	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Write
VAR
		overw	:USINT;	
		recipecsv	:STRING[24];	
		chr_separ	:USINT;	
		firstrow_written	:BOOL;	
		step	:USINT;	
		k	:UDINT;	
		fileio_id	:UDINT;	
		offset	:UDINT;	
		gs	:gs_typ;	
		get_comm	:Rec_get_comm;	
		FOpen	:FileOpen;	
		FCreate	:FileCreate;	
		FClose	:FileClose;	
		FWrite	:FileWrite;	
		FDelete	:FileDelete;	
		get_sys_err	:UINT;	
		prevstep	:USINT;	
		repeat_switch	:USINT;	
		mem_part_all	:AsMemPartAlloc;	
		mem_allocated	:BOOL;	
		mem_part_free	:AsMemPartFree;	
		limit_repeat_cntr	:USINT;	
		tmp_status	:UINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
		structure	:STRING[15];	
		recipe	:STRING[20];	
		ident	:UDINT;	
		speed_option	:BOOL;	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_NameRead
VAR
		step	:USINT;	
		set_device	:USINT;	
		DInfo	:DirInfo;	
		DRead	:DirRead;	
		ReadData	:fiDIR_READ_DATA;	
		get_sys_err	:UINT;	
		prevstep	:USINT;	
		len_name	:UINT;	
		file_counter	:UDINT;	
		tot_files	:UDINT;	
		not_valid_csv	:USINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
		recipe	:STRING[20];	
		nr_csv_read	:UDINT;	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Import
VAR
		step	:USINT;	
		get_sys_err	:UINT;	
		prevstep	:UINT;	
		recipecsv	:STRING[24];	
		FCopy	:FileCopy;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
		recipe	:STRING[20];	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Imp_All
VAR
		recipe	:STRING[260];	
		read_name	:Rec_NameRead;	
		rec_imp	:Rec_Import;	
		step	:USINT;	
		get_sys_err	:UINT;	
		prevstep	:USINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
		nr_csv_imported	:UDINT;	
		recipe_imp	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Export
VAR
		step	:USINT;	
		get_sys_err	:UINT;	
		prevstep	:UINT;	
		recipecsv	:STRING[24];	
		FCopy	:FileCopy;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
		recipe	:STRING[20];	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Exp_All
VAR
		recipe	:STRING[260];	
		read_name	:Rec_NameRead;	
		rec_exp	:Rec_Export;	
		step	:USINT;	
		get_sys_err	:UINT;	
		prevstep	:USINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Upload
VAR
		recipecsv	:STRING[24];	
		step	:USINT;	
		offset	:UDINT;	
		k	:UDINT;	
		j	:UDINT;	
		ascii_infile	:ARRAY [0..21] OF USINT;	
		gs	:gs_typ;	
		FOpen	:FileOpen;	
		FRead	:FileRead;	
		FClose	:FileClose;	
		get_sys_err	:UINT;	
		repeat_switch	:USINT;	
		prevstep	:USINT;	
		mem_part_all	:AsMemPartAlloc;	
		mem_allocated	:BOOL;	
		mem_part_free	:AsMemPartFree;	
		limit	:USINT;	
		tmp_status	:UINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
		structure	:STRING[15];	
		recipe	:STRING[20];	
		ident	:UDINT;	
		speed_option	:BOOL;	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Delete
VAR
		recipecsv	:STRING[24];	
		step	:USINT;	
		FDelete	:FileDelete;	
		get_sys_err	:UINT;	
		prevstep	:USINT;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
		recipe	:STRING[20];	
	END_VAR
	VAR_OUTPUT
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK
FUNCTION_BLOCK Rec_Init
VAR
		step	:USINT;	
		dir_create	:DirCreate;	
		prevstep	:USINT;	
		mem_part_create	:AsMemPartCreate;	
	END_VAR
	VAR_INPUT
		enable	:BOOL;	
	END_VAR
	VAR_OUTPUT
		ident	:UDINT;	
		status	:UINT;	
		msg_err	:STRING[80];	
	END_VAR
END_FUNCTION_BLOCK

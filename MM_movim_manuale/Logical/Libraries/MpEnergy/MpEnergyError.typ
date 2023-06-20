
TYPE
	MpEnergyErrorEnum : 
		( (* Error numbers of library MpEnergy *)
		mpENERGY_NO_ERROR := 0, (* No error *)
		mpENERGY_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
		mpENERGY_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
		mpENERGY_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
		mpENERGY_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
		mpENERGY_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
		mpENERGY_ERR_MPLINK_IN_USE := -1064239098, (* MpLink already in use [Error: 6, 0xc0910006] *)
		mpENERGY_INF_WAIT_CORE_FB := 1083330560, (* Waiting for parent component [Informational: 20480, 0x40925000] *)
		mpENERGY_ERR_FILE_SYSTEM := -1064153087, (* File-system related error (ErrorCause: {1:ErrorNumber}) [Error: 20481, 0xc0925001] *)
		mpENERGY_ERR_INVALID_FILE_DEV := -1064153086, (* Invalid file device [Error: 20482, 0xc0925002] *)
		mpENERGY_WRN_VALUE_OUT_OF_RANGE := -2137894909, (* Given value is out of range for {2:Parameter} [Warning: 20483, 0x80925003] *)
		mpENERGY_ERR_INVALID_MODULE_NAME := -1064153084, (* Invalid module name {2:ModuleName} [Error: 20484, 0xc0925004] *)
		mpENERGY_ERR_MODULE_EXISTS := -1064153083, (* Module with name {2:ModuleName} already registered [Error: 20485, 0xc0925005] *)
		mpENERGY_ERR_BUFFER_CREATE := -1064153082, (* Could not allocate memory (ErrorCause: {1:ErrorNumber}) [Error: 20486, 0xc0925006] *)
		mpENERGY_ERR_MISSING_UICONNECT := -1064153081, (* Invalid value for "UIConnect" [Error: 20487, 0xc0925007] *)
		mpENERGY_ERR_RECORDING_SIZE := -1064153080 (* The allocated memory for registering the module: {2:ModuleName} is no longer sufficient [Error: 20488, 0xc0925008] *)
		);
END_TYPE


TYPE
    MpAssetIntErrorEnum : 
        ( (* Error numbers of library MpAssetInt *)
        mpASSETINT_NO_ERROR := 0, (* No error *)
        mpASSETINT_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
        mpASSETINT_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
        mpASSETINT_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
        mpASSETINT_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
        mpASSETINT_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
        mpASSETINT_ERR_MPLINK_IN_USE := -1064239098, (* MpLink already in use [Error: 6, 0xc0910006] *)
        mpASSETINT_ERR_PAR_NULL := -1064239097, (* Parameters structure is a null pointer [Error: 7, 0xc0910007] *)
        mpASSETINT_ERR_CONFIG_NULL := -1064239096, (* Configuration structure is null pointer [Error: 8, 0xc0910008] *)
        mpASSETINT_ERR_CONFIG_NO_PV := -1064239095, (* Configuration pointer not PV [Error: 9, 0xc0910009] *)
        mpASSETINT_ERR_CONFIG_LOAD := -1064239094, (* Error loading configuration {2:ConfigName} (ErrorCause: {1:ErrorNumber}) [Error: 10, 0xc091000a] *)
        mpASSETINT_WRN_CONFIG_LOAD := -2137980917, (* Warning loading configuration [Warning: 11, 0x8091000b] *)
        mpASSETINT_ERR_CONFIG_SAVE := -1064239092, (* Error saving configuration {2:ConfigName} (ErrorCause: {1:ErrorNumber}) [Error: 12, 0xc091000c] *)
        mpASSETINT_ERR_CONFIG_INVALID := -1064239091, (* Invalid Configuration [Error: 13, 0xc091000d] *)
        mpASSETINT_ERR_BUFFER_CREATE := -1064136704, (* Could not allocate memory (ErrorCause: {1:ErrorNumber}) [Error: 36864, 0xc0929000] *)
        mpASSETINT_ERR_WRITE_EXPORT_FILE := -1064136703, (* Error writing export-file {2:FileName} at {3:DeviceName} (ErrorCause: {1:ErrorNumber}) [Error: 36865, 0xc0929001] *)
        mpASSETINT_ERR_READ_BUFFER_ENTRY := -1064136702, (* Error reading event entries from {2:BufferName} (ErrorCause: {1:ErrorNumber}) [Error: 36866, 0xc0929002] *)
        mpASSETINT_ERR_INVALID_FILE_DEV := -1064136701, (* Invalid file-device [Error: 36867, 0xc0929003] *)
        mpASSETINT_ERR_MISSING_UICONNECT := -1064136700, (* Missing value on UIConnect [Error: 36868, 0xc0929004] *)
        mpASSETINT_INF_WAIT_CORE_FB := 1083346949, (* Core is not active [Informational: 36869, 0x40929005] *)
        mpASSETINT_ERR_EVENT_RECORDER := -1064136698, (* Event not recorded (ErrorCause: {1:ErrorNumber}) [Error: 36870, 0xc0929006] *)
        mpASSETINT_ERR_INVALID_SHIFT := -1064136697 (* Invalid shift {2:ShiftName} in configuration: {3:Cause} [Error: 36871, 0xc0929007] *)
        );
END_TYPE


TYPE
    MpFileErrorEnum : 
        ( (* Error numbers of library MpFile *)
        mpFILE_NO_ERROR := 0, (* No error *)
        mpFILE_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
        mpFILE_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
        mpFILE_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
        mpFILE_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
        mpFILE_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
        mpFILE_ERR_MPLINK_IN_USE := -1064239098, (* MpLink already in use [Error: 6, 0xc0910006] *)
        mpFILE_ERR_MISSING_UICONNECT := -1064165376, (* Missing value on UIConnect [Error: 8192, 0xc0922000] *)
        mpFILE_ERR_CMD_NOT_ALLOWED := -1064165375, (* Command {2:Command} not allowed [Error: 8193, 0xc0922001] *)
        mpFILE_ERR_NOTHING_TO_PASTE := -1064165374, (* No element to paste [Error: 8194, 0xc0922002] *)
        mpFILE_ERR_NOTHING_SELECTED := -1064165373, (* Nothing selected [Error: 8195, 0xc0922003] *)
        mpFILE_ERR_DIR_ALREADY_EXISTS := -1064165372, (* Folder {2:PathName} already exists in {3:DeviceName} [Error: 8196, 0xc0922004] *)
        mpFILE_ERR_INVALID_FILE_DEV := -1064165371, (* Invalid file device {2:DeviceName} [Error: 8197, 0xc0922005] *)
        mpFILE_ERR_NAME_EMPTY := -1064165370, (* New name not entered [Error: 8198, 0xc0922006] *)
        mpFILE_ERR_INVALID_NAME := -1064165369, (* Invaild name (ErrorCause: {1:ErrorNumber}) [Error: 8199, 0xc0922007] *)
        mpFILE_ERR_PASTE_NOT_ALLOWED := -1064165368, (* Paste not allowed (ErrorCause: {1:ErrorNumber}) [Error: 8200, 0xc0922008] *)
        mpFILE_ERR_FILE_SYSTEM := -1064165367 (* General error from file system (ErrorCause: {1:ErrorNumber}) [Error: 8201, 0xc0922009] *)
        );
END_TYPE

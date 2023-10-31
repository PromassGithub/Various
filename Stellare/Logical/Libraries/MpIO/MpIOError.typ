
TYPE
    MpIOErrorEnum : 
        ( (* Error numbers of library MpIO *)
        mpIO_NO_ERROR := 0, (* No error *)
        mpIO_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
        mpIO_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
        mpIO_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
        mpIO_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
        mpIO_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
        mpIO_ERR_MPLINK_IN_USE := -1064239098, (* MpLink already in use [Error: 6, 0xc0910006] *)
        mpIO_ERR_CONFIG_INVALID := -1064239091, (* Invalid Configuration [Error: 13, 0xc091000d] *)
        mpIO_ERR_INVALID_FILE_DEV := -1064120320, (* Given File Device is invalid [Error: 53248, 0xc092d000] *)
        mpIO_ERR_INVALID_FILE_NAME := -1064120319, (* Given File Name is invalid [Error: 53249, 0xc092d001] *)
        mpIO_ERR_BUILD_IMPORT_DATA := -1064120318, (* Error building import-data [Error: 53250, 0xc092d002] *)
        mpIO_ERR_ACTIVATE_IMPORT_DATA := -1064120317, (* Error activating import-data [Error: 53251, 0xc092d003] *)
        mpIO_ERR_CREATE_BACKUP := -1064120316, (* Error creating backup [Error: 53252, 0xc092d004] *)
        mpIO_ERR_MISSING_UICONNECT := -1064120315, (* Error creating backup [Error: 53253, 0xc092d005] *)
        mpIO_ERR_MISSING_IMPORT := -1064120314, (* Missing import (core) service) [Error: 53254, 0xc092d006] *)
        mpIO_INF_WAIT_IMPORT_FB := 1083363335, (* Waiting for import-FB [Informational: 53255, 0x4092d007] *)
        mpIO_ERR_IMPORT_NOT_ALLOWED := -1064120312 (* Import is not allowed (locked). See "ImportAllowed"-pin on FB [Error: 53256, 0xc092d008] *)
        );
END_TYPE

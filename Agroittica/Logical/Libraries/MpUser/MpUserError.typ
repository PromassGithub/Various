
TYPE
	MpUserErrorEnum : 
		( (* Error numbers of library MpUser *)
		mpUSER_NO_ERROR := 0, (* No error *)
		mpUSER_ERR_ACTIVATION := -1064239103, (* Could not create component [Error: 1, 0xc0910001] *)
		mpUSER_ERR_MPLINK_NULL := -1064239102, (* MpLink is NULL pointer [Error: 2, 0xc0910002] *)
		mpUSER_ERR_MPLINK_INVALID := -1064239101, (* MpLink connection not allowed [Error: 3, 0xc0910003] *)
		mpUSER_ERR_MPLINK_CHANGED := -1064239100, (* MpLink modified [Error: 4, 0xc0910004] *)
		mpUSER_ERR_MPLINK_CORRUPT := -1064239099, (* Invalid MpLink contents [Error: 5, 0xc0910005] *)
		mpUSER_ERR_MPLINK_IN_USE := -1064239098, (* MpLink already in use [Error: 6, 0xc0910006] *)
		mpUSER_ERR_PAR_NULL := -1064239097, (* Parameters structure is a null pointer [Error: 7, 0xc0910007] *)
		mpUSER_ERR_CONFIG_NULL := -1064239096, (* Configuration structure is null pointer [Error: 8, 0xc0910008] *)
		mpUSER_ERR_CONFIG_NO_PV := -1064239095, (* Configuration pointer not PV [Error: 9, 0xc0910009] *)
		mpUSER_ERR_CONFIG_LOAD := -1064239094, (* Error loading configuration {2:ConfigName} (ErrorCause: {1:ErrorNumber}) [Error: 10, 0xc091000a] *)
		mpUSER_WRN_CONFIG_LOAD := -2137980917, (* Warning loading configuration [Warning: 11, 0x8091000b] *)
		mpUSER_ERR_CONFIG_SAVE := -1064239092, (* Error saving configuration {2:ConfigName} (ErrorCause: {1:ErrorNumber}) [Error: 12, 0xc091000c] *)
		mpUSER_ERR_CONFIG_INVALID := -1064239091, (* Invalid Configuration [Error: 13, 0xc091000d] *)
		mpUSER_ERR_PASSWORD_INCORRECT := -1064148992, (* Invalid password [Error: 24576, 0xc0926000] *)
		mpUSER_ERR_USER_NOT_EXISTING := -1064148991, (* User does not exist [Error: 24577, 0xc0926001] *)
		mpUSER_ERR_USER_EXISTS := -1064148990, (* User already exists [Error: 24578, 0xc0926002] *)
		mpUSER_ERR_LOGIN_ID_INVALID := -1064148989, (* Invalid login token [Error: 24579, 0xc0926003] *)
		mpUSER_ERR_ADMIN_INVALID := -1064148988, (* No administrator rights [Error: 24580, 0xc0926004] *)
		mpUSER_ERR_INSUFFICIENT_RIGHTS := -1064148987, (* Insufficient access rights [Error: 24581, 0xc0926005] *)
		mpUSER_ERR_GROUP_NOT_PRESENT := -1064148986, (* User group does not exist [Error: 24582, 0xc0926006] *)
		mpUSER_ERR_PASSWORD_WEAK := -1064148985, (* Password not strong enough [Error: 24583, 0xc0926007] *)
		mpUSER_ERR_USER_IS_LOCKED := -1064148984, (* User blocked [Error: 24584, 0xc0926008] *)
		mpUSER_ERR_PASSWORD_CHANGE_REQ := -1064148983, (* Password change required [Error: 24585, 0xc0926009] *)
		mpUSER_ERR_TOO_MANY_LOGINS := -1064148982, (* Too many login attempts, login no longer possible [Error: 24586, 0xc092600a] *)
		mpUSER_ERR_NO_ADMIN_RIGHTS := -1064148981, (* User has no administrator rights [Error: 24587, 0xc092600b] *)
		mpUSER_ERR_LOGIN_INST_EXISTS := -1064148980, (* A MpUserLogin-instance already exists ({1:ErrorNumber}) [Error: 24588, 0xc092600c] *)
		mpUSER_ERR_NOT_LOGGED_IN := -1064148979, (* No user logged in [Error: 24589, 0xc092600d] *)
		mpUSER_ERR_PASSWORD_IDENTICAL := -1064148977, (* Identical passwords [Error: 24591, 0xc092600f] *)
		mpUSER_ERR_LOGIN_ID_EXISTS := -1064148976, (* Username already exists [Error: 24592, 0xc0926010] *)
		mpUSER_WRN_PASSWORD_CHANGE_REQ := -2137890798, (* Password change required [Warning: 24594, 0x80926012] *)
		mpUSER_ERR_GROUP_INDEX_NOT_OK := -1064148973, (* Invalid user group index [Error: 24595, 0xc0926013] *)
		mpUSER_ERR_NO_GROUPNAME := -1064148972, (* Invalid user group name [Error: 24596, 0xc0926014] *)
		mpUSER_ERR_LOGGED_IN := -1064148971, (* User already logged in [Error: 24597, 0xc0926015] *)
		mpUSER_ERR_MISSING_UICONNECT := -1064148970, (* Missing value on UIConnect [Error: 24598, 0xc0926016] *)
		mpUSER_ERR_NO_USERNAME := -1064148969, (* Invalid username [Error: 24599, 0xc0926017] *)
		mpUSER_ERR_NO_PASSWORD := -1064148968, (* Missing password [Error: 24600, 0xc0926018] *)
		mpUSER_ERR_MISSING_LOGIN := -1064148967, (* MpUserLogin missing [Error: 24601, 0xc0926019] *)
		mpUSER_ERR_PASSWORD_CONFIRM := -1064148966, (* Confirmation password incorrect [Error: 24602, 0xc092601a] *)
		mpUSER_ERR_NO_SUCH_SYSRIGHT := -1064148965, (* Specified system right does not exist [Error: 24603, 0xc092601b] *)
		mpUSER_ERR_IMPORT_DATA := -1064148964, (* Import failed [Error: 24604, 0xc092601c] *)
		mpUSER_ERR_LOAD_IMPORT_FILE := -1064148963, (* Error loading import file {2:FileName} from {3:DeviceName} ({1:ErrorNumber}) [Error: 24605, 0xc092601d] *)
		mpUSER_ERR_SAVE_EXPORT_FILE := -1064148962, (* Error saving export file {2:FileName} to {3:DeviceName} ({1:ErrorNumber}) [Error: 24606, 0xc092601e] *)
		mpUSER_ERR_GROUPNAME_TOO_LONG := -1064148961, (* Given group-name is to long (>20 characters) [Error: 24607, 0xc092601f] *)
		mpUSER_ERR_USERNAME_TOO_LONG := -1064148960, (* Given user-name is too long (>20 characters) [Error: 24608, 0xc0926020] *)
		mpUSER_ERR_PASSWORD_TOO_LONG := -1064148959, (* Given password is too long (>20 characters [Error: 24609, 0xc0926021] *)
		mpUSER_INF_WAIT_LOGIN_FB := 1083334690, (* Wating for login-FB to get active [Informational: 24610, 0x40926022] *)
		mpUSER_ERR_USERNAME_TOO_SHORT := -1064148957, (* Given User-Name is too short [Error: 24611, 0xc0926023] *)
		mpUSER_ERR_GROUP_EXISTS := -1064148956, (* Group with same name already exists [Error: 24612, 0xc0926024] *)
		mpUSER_ERR_GROUP_DEFAULT := -1064148955, (* Group cannot be deleted (default) [Error: 24613, 0xc0926025] *)
		mpUSER_ERR_MAX_FAILED_SIGNATURES := -1064148954, (* Max. number of failed signatures exceeded (signature is aborted) [Error: 24614, 0xc0926026] *)
		mpUSER_ERR_SIGNATURE_BUSY := -1064148953, (* The last signed action was not checked yet (no new signature possible) [Error: 24615, 0xc0926027] *)
		mpUSER_ERR_PASSWORD_REPEAT := -1064148952, (* Password was already used and cannot be reused [Error: 24616, 0xc0926028] *)
		mpUSER_ERR_IMPORT_FILE_FORMAT := -1064148951, (* Invalid Import File Format [Error: 24617, 0xc0926029] *)
		mpUSER_WRN_KEY_DUPLICATE := -2137890774, (*The key {2: Key} is already in use. The value {3: Value} will be ignored. ({1: ErrorNumber}) [Error: 24618, 0x8092602A]*)
		mpUSER_ERR_INFO_NOT_FOUND := -1064148949, (*The requested user information was not found. [Error: 24619, 0x8092602B]*)
		mpUSER_ERR_EMPTY_KEY := -1064148948, (*The provided key is empty. [Error: 24620, 0x8092602C]*)
		mpUSER_ERR_BUFFER_TOO_SMALL := -1064148947 (*The provided output-buffer is too small. [Error: 24621, 0x8092602D]*)
		);
END_TYPE
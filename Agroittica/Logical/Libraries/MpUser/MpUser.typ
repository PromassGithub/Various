
TYPE
	MpUserAccessRightEnum : 
		(
		mpUSER_ACCESS_UNDEFINED := 0, (*Access right undefined*)
		mpUSER_ACCESS_NONE := 1, (*No access rights*)
		mpUSER_ACCESS_VIEW := 2, (*Read access*)
		mpUSER_ACCESS_ACTUATE := 3, (*Processes can be started/stopped but not edited*)
		mpUSER_ACCESS_FULL := 4 (*Full access (read-write access)*)
		);
	MpUserUIMessageEnum : 
		(
		mpUSER_MSG_NONE := 0, (*No dialog box*)
		mpUSER_MSG_ERROR := 1, (*Dialog box: Errors*)
		mpUSER_MSG_CONFIRM_DELETE := 2, (*Dialog box: Confirmation of user deletion*)
		mpUSER_MSG_CONFIRM_LOCK := 3, (*Dialog box: Confirmation of user block*)
		mpUSER_MSG_CONFIRM_UNLOCK := 4, (*Dialog box: Confirmation of user unblock*)
		mpUSER_MSG_CONFIRM_GROUP_DELETE := 5 (*Dialog box: Confirmation of group deletion*)
		);
	MpUserMgrUIImportConfirmEnum : 
		(
		mpUSER_CONFIRM_USER := 0, (*Confirm overwrite of existing user*)
		mpUSER_CONFIRM_GROUP := 1 (*Confirm overwrite of existing group*)
		);
	MpUserUIStatusEnum : 
		(
		mpUSER_UI_STATUS_IDLE := 0, (*Indicates that no process is currently active*)
		mpUSER_UI_STATUS_WAIT_DLG := 1, (*Waiting for confirmation or cancelation*)
		mpUSER_UI_STATUS_EXECUTE := 2, (*Executing a command*)
		mpUSER_UI_STATUS_ERROR := 99 (*The last operation generated an error*)
		);
	MpUserImportModeEnum : 
		(
		mpUSER_IMPORT_SKIP := 0, (*Do not import*)
		mpUSER_IMPORT_IGNORE_EXISITNG := 1, (*Ignore existing items*)
		mpUSER_IMPORT_OVERWRITE := 2, (*Overwrite existing items*)
		mpUSER_IMPORT_IGNORE_DEFAULT := 3, (*Ignore default items (created in AS)*)
		mpUSER_IMPORT_OVERWRITE_ONLY := 4, (*Only overwrite items*)
		mpUSER_IMPORT_REMOVE_EXISTING := 5 (*Remove existing items before import*)
		);
	MpUserUIMessageBoxType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box *)
		Type : MpUserUIMessageEnum; (*Type of dialog box*)
		ErrorNumber : UINT; (*Current error number to be displayed *)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
	END_STRUCT;
	MpUserMgrUIUserListType : 	STRUCT 
		UserNames : ARRAY[0..19]OF WSTRING[20]; (*List of all available users*)
		UserOptions : ARRAY[0..19]OF USINT; (*Controls the display of elements in the list*)
		MaxSelection : UINT; (*Index of the entry currently selected in the list*)
		SelectedIndex : UINT; (*Index of the last entry in the list*)
		PageUp : BOOL; (*Jumps to the start of the current page and then scrolls up one page at a time*)
		StepUp : BOOL; (* Selects the previous entry in the list*)
		PageDown : BOOL; (*Jumps to the end of the current page and then scrolls down one page at a time*)
		StepDown : BOOL; (*Selects the next entry in the list*)
		RangeStart : REAL; (*Shows a bar indicating which part of the list is currently being displayed-Start [%]*)
		RangeEnd : REAL; (*Shows a bar indicating which part of the list is currently being displayed-End[%]*)
	END_STRUCT;
	MpUserMgrUIUserInfoType : 	STRUCT 
		UserName : WSTRING[20]; (*Username for logging in*)
		FullName : WSTRING[100]; (*Complete username*)
		GroupIndex : UINT; (*Group to which the user should be assigned*)
		Locked : BOOL; (*User is blocked*)
		Expired : BOOL; (*User password expired*)
		RemainingAttempts : USINT; (*Number of login attempts left before the user is blocked*)
		Language : UINT; (*Preferred language*)
		DisplayUnit : UINT; (*Preferred unit*)
		LoginToken : ARRAY[0..4]OF STRING[20]; (*Identifies login tokens assigned to a user- Reserved for future-use*)
		Creation : DATE_AND_TIME; (*Date and time this user was created*)
		FirstLogin : DATE_AND_TIME; (*Date and time of the first login*)
		LastLogin : DATE_AND_TIME; (*Date and time of the last login*)
		PasswordExpired : DATE_AND_TIME; (*Date and time of password expiration*)
		AdditionalData : ARRAY[0..9]OF MpUserMgrUIAdditionalDataType; (*Additional user data*)
	END_STRUCT;
	MpUserMgrUIAdditionalDataType : 	STRUCT 
		Key : WSTRING[20]; (*Value identifier*)
		Value : WSTRING[255]; (*Value*)
	END_STRUCT;
	MpUserMgrUIGroupListType : 	STRUCT 
		Names : ARRAY[0..9]OF WSTRING[20]; (*List of all available user groups (scrollable)*)
		SelectedIndex : UINT; (*Index of the entry currently selected in the list*)
		MaxSelection : UINT; (*Index of the last entry in the list*)
		PageUp : BOOL; (*Jumps to the start of the current page and then scrolls up one page at a time*)
		StepUp : BOOL; (*Selects the previous entry in the list*)
		PageDown : BOOL; (*Jumps to the end of the current page and then scrolls down one page at a time*)
		StepDown : BOOL; (*Selects the next entry in the list*)
		RangeStart : REAL; (*Shows a bar indicating which part of the list is currently being displayed-Start [%]*)
		RangeEnd : REAL; (*Shows a bar indicating which part of the list is currently being displayed-End[%]*)
	END_STRUCT;
	MpUserMgrUIGroupInfoType : 	STRUCT 
		Name : WSTRING[20]; (*Name of the user group*)
		Index : UINT; (*Index of the user group*)
		Level : DINT; (*Level of the user group*)
		Admin : BOOL; (*Indicates whether this group has administrator rights*)
		AccessRights : ARRAY[0..19]OF MpUserAccessRightEnum; (*List with the access rights for individual actions*)
	END_STRUCT;
	MpUserMgrUIGroupDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		Name : WSTRING[20]; (*Name of the user group*)
		Index : UINT; (*Index of the user group*)
		Level : DINT; (*Level of the user group*)
		Admin : BOOL; (*Defines whether this group has administrator rights*)
		AccessRights : ARRAY[0..19]OF MpUserAccessRightEnum; (*List with the access rights for individual actions*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
		LevelLimit : DINT; (*Max. Level allowed to set*)
		AccessRightsLimit : ARRAY[0..19]OF MpUserAccessRightEnum; (*Limit-values for the access-rights*)
	END_STRUCT;
	MpUserMgrUIGroupCreateDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		Name : WSTRING[20]; (*Name of the user group*)
		Level : DINT; (*Level of the user group*)
		Admin : BOOL; (*Defines whether this group has administrator rights*)
		AccessRights : ARRAY[0..19]OF MpUserAccessRightEnum; (*List with the access rights for individual actions*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
		LevelLimit : DINT; (*Max. Level allowed to set*)
		AccessRightsLimit : ARRAY[0..19]OF MpUserAccessRightEnum; (*Limit-values for the access-rights*)
	END_STRUCT;
	MpUserMgrUIGroupCreateType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Lock : BOOL; (*Blocks the function for editing user groups*)
		Dialog : MpUserMgrUIGroupCreateDlgType; (*Dialog box for editing a user group*)
	END_STRUCT;
	MpUserMgrUIGroupEditType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Lock : BOOL; (*Blocks the function for editing user groups*)
		Dialog : MpUserMgrUIGroupDlgType; (*Dialog box for editing a user group*)
	END_STRUCT;
	MpUserMgrUICreateDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		UserName : WSTRING[20]; (*Username*)
		FullName : WSTRING[100]; (*Full name of the new user*)
		GroupIndex : UINT; (*User group to which the user should be assigned.Connected via drop-down list that displays a text group with the user groups.*)
		GroupOption : ARRAY[0..19]OF USINT; (*Sorts and removes user groups in the drop-down list that cannot be selected*)
		NewPassword : WSTRING[20]; (*New password*)
		ConfirmPassword : WSTRING[20]; (*Password confirmation*)
		Language : UINT; (*Preferred language of the new user*)
		DisplayUnit : UINT; (*Preferred unit of the new user*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
		CriteriaNotMet : MpUserUIPasswordCriteriaEnum; (*Password criterion not met by new password*)
		NewPasswordOk : UINT; (*New password OK (all criterions met)*)
		ConfirmPasswordOk : UINT; (*Password-confirmation OK*)
		UserNameOk : UINT; (*UserName OK*)
		AdditionalData : ARRAY[0..9]OF MpUserMgrUIAdditionalDataType; (*Additional user data*)
	END_STRUCT;
	MpUserMgrUICreateType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Lock : BOOL; (*Blocks the function for editing/creating users*)
		Dialog : MpUserMgrUICreateDlgType; (*Dialog box for creating a user*)
	END_STRUCT;
	MpUserMgrUIExportDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		FileName : STRING[255]; (*Name of the file to be exported*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
	END_STRUCT;
	MpUserMgrUIExportType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Dialog : MpUserMgrUIExportDlgType; (*Dialog box for exporting user data*)
	END_STRUCT;
	MpUserMgrUIImportListType : 	STRUCT 
		FileNames : ARRAY[0..4]OF STRING[255]; (*List of all files available for import*)
		SelectedIndex : UINT; (*Index of the entry currently selected in the list*)
		MaxSelection : UINT; (*Index of the last entry in the list*)
	END_STRUCT;
	MpUserMgrUIImportDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		List : MpUserMgrUIImportListType; (*List of all files available for import, as well as the navigation of the list*)
		FileName : STRING[255]; (*Name of the file to be imported*)
		Users : BOOL; (*Options that specifies whether user data should be applied*)
		GroupSettings : BOOL; (*Options that specifies whether user group settings should be applied*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
	END_STRUCT;
	MpUserMgrUIImportConfirmType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box*)
		Type : MpUserMgrUIImportConfirmEnum; (*Confirmation type (user or group)*)
		Name : WSTRING[20]; (*Name of user / group*)
		NumberOfConflicts : UINT; (*Number of remaining conflicts*)
		ApplyForAll : BOOL; (*Apply selection for all remaining conflicts*)
		Confirm : BOOL; (*Confirm overwrite of item*)
		Cancel : BOOL; (*Reject overwrite of item (ignore)*)
	END_STRUCT;
	MpUserMgrUIImportType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Dialog : MpUserMgrUIImportDlgType; (*Dialog box for importing user data*)
		ConfirmDialog : MpUserMgrUIImportConfirmType; (*Import confirmation dialog*)
	END_STRUCT;
	MpUserMgrUISetupConfirmType : 	STRUCT 
		OverwriteUser : BOOL; (*Confirmation by operator for overwriting existing users required*)
		OverwriteGroup : BOOL; (*Confirmation by operator for overwriting existing groups required*)
	END_STRUCT;
	MpUserMgrUISetupType : 	STRUCT 
		UserListSize : UINT := 20; (*Number of users to be displayed on one page of the list in the HMI application*)
		ScrollWindow : USINT := 1; (*Determines how many entries from the list are displayed in advance when scrolling up and down*)
		FileDevice : STRING[20] := 'HD'; (*File device (data storage medium) for exporting/importing user data*)
		FileExtension : STRING[20] := 'usr'; (*File extension for export/import file*)
		GroupListSize : UINT := 10; (*Number of users to be displayed on one page of the list in the HMI application*)
		Confirmation : MpUserMgrUISetupConfirmType; (*Displaying the confirmation window*)
	END_STRUCT;
	MpUserMgrUIUserType : 	STRUCT 
		List : MpUserMgrUIUserListType; (*List of all users, as well as the navigation of the list*)
		Info : MpUserMgrUIUserInfoType; (*Contains detailed information about users*)
		Create : MpUserMgrUICreateType; (*Contains the data necessary to create a user*)
		Edit : MpUserMgrUICreateType; (*Contains the data necessary to edit a user*)
		Remove : BOOL; (*Deletes the selected user*)
		Lock : BOOL; (*Blocks the selected user*)
	END_STRUCT;
	MpUserMgrUIGroupSelectType : 	STRUCT 
		Names : ARRAY[0..19]OF WSTRING[20]; (*List of all available user groups (not scrollable)*)
		MaxSelection : UINT; (*Index of the last entry in the list*)
	END_STRUCT;
	MpUserMgrUIGroupType : 	STRUCT 
		List : MpUserMgrUIGroupListType; (*List of all user groups, as well as the navigation of the list*)
		Info : MpUserMgrUIGroupInfoType; (*Contains detailed information about user groups*)
		Edit : MpUserMgrUIGroupEditType; (*Contains the data necessary to edit a user group*)
		Create : MpUserMgrUIGroupCreateType; (*Contains the data necessary to create a user-group*)
		Remove : BOOL; (*Deletes the selected group*)
		SelectList : MpUserMgrUIGroupSelectType; (*List for selecting groups from dropdown*)
	END_STRUCT;
	MpUserMgrUIConnectType : 	STRUCT 
		Status : MpUserUIStatusEnum; (*Current operation*)
		User : MpUserMgrUIUserType; (*User information*)
		Group : MpUserMgrUIGroupType; (*User group information*)
		Export : MpUserMgrUIExportType; (*Exports the user and user group settings*)
		Import : MpUserMgrUIImportType; (*Imports the user and user group settings*)
		MessageBox : MpUserUIMessageBoxType; (*Controls dialog boxes*)
		DefaultLayerStatus : UINT; (*Status data point for the default layer of the visualization page where the user management system is being displayed*)
	END_STRUCT;
	MpUserUIPasswordCriteriaEnum : 
		(
		mpUSER_PASSWORD_CRIT_NONE := 0, (*None*)
		mpUSER_PASSWORD_CRIT_LENGTH := 1, (*Password length*)
		mpUSER_PASSWORD_CRIT_ALPHA := 2, (*Password alpha-numeric*)
		mpUSER_PASSWORD_CRIT_CASE := 3, (*Password case-sensitive (upper- and lower-case characters)*)
		mpUSER_PASSWORD_CRIT_SPECIAL := 4 (*Password must contain special characters*)
		);
	MpUserLoginUIPwdDlgType : 	STRUCT 
		OldPassword : WSTRING[20]; (*Old password*)
		NewPassword : WSTRING[20]; (*New password*)
		ConfirmPassword : WSTRING[20]; (*Confirmation of the new password*)
		LayerStatus : UINT; (*Visibility of the dialog box (status data point for the dialog box layer)*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
		CriteriaNotMet : MpUserUIPasswordCriteriaEnum; (*Password criterion not met by new password*)
		NewPasswordOk : UINT; (*New password OK (all criterions met)*)
		ConfirmPasswordOk : UINT; (*Password-confirmation OK*)
	END_STRUCT;
	MpUserLoginUIPwdType : 	STRUCT 
		ShowDialog : BOOL; (*Command that opens the dialog box*)
		Dialog : MpUserLoginUIPwdDlgType; (*Dialog box for changing the password*)
	END_STRUCT;
	MpUserLoginUILoginType : 	STRUCT 
		Login : BOOL; (*Command for logging in*)
		Logout : BOOL; (*Command for logging out*)
		UserName : WSTRING[20]; (*Username*)
		Password : WSTRING[20]; (*Password*)
	END_STRUCT;
	MpUserLoginUIConnectType : 	STRUCT 
		Status : MpUserUIStatusEnum; (*Current operation*)
		CurrentUser : WSTRING[20]; (*Currently logged in user*)
		Language : UINT; (*Preferred language of the current (or previous) active user*)
		DisplayUnit : UINT; (*Preferred unit of the current (or previous) active user*)
		LoggedIn : BOOL; (*User is logged in*)
		UserLevel : DINT; (*Current user-level*)
		Login : MpUserLoginUILoginType; (*Basic login information*)
		ChangePassword : MpUserLoginUIPwdType; (*Used to change the password*)
		MessageBox : MpUserUIMessageBoxType; (*Controls dialog boxes*)
		DefaultLayerStatus : UINT; (*Status data point for the default layer of the visualization page where logging in and out takes place*)
	END_STRUCT;
	MpUserConfigType : 	STRUCT 
		NoDelete : BOOL := TRUE; (*Deletion of users not allowed*)
		PasswordChangeReq : BOOL := FALSE; (*Requires password change on first login*)
		PasswordCase : BOOL := FALSE; (*Requires password to have both upper- and lowercase letters*)
		PasswordAlpha : BOOL := TRUE; (*Requires password to have alphanumeric characters*)
		PasswordLength : UINT := 5; (*Minimum password length*)
		LoginAttempts : UINT := 3; (*Maximum number of failed login attempts until the user is blocked*)
		PasswordChangeInterval : DINT := 0; (*Interval in which the password must be changed*)
		UserExpirationTime : DINT := 0; (*Expiration time for the validity of the user account*)
		UserNameLength : UINT := 1; (*Minimum user-name length*)
		SignAttempts : UINT := 3; (*Maximum number of signature attempts before the signature procedure is aborted*)
		PasswordHistory : UINT := 0; (*Length of password-history to prohibit reuse of passwords*)
		PasswordSpecial : BOOL := FALSE; (*Requires password to contain special characters*)
		EditSameLevel : BOOL := FALSE; (*Allow admin-user to edit users (create, change, remove) with same user-level (within same group)*)
		ImportUser : MpUserImportModeEnum := mpUSER_IMPORT_IGNORE_DEFAULT; (*Import mode for users*)
		ImportGroup : MpUserImportModeEnum := mpUSER_IMPORT_OVERWRITE_ONLY; (*Import mode for groups / roles*)
		ImportUnchecked : BOOL := FALSE; (*Ignore check-sum in input file*)
		AdminUnlockTime : DINT := 3600; (*Automatic Unlock Time for Administrators (0=disabled)*)
	END_STRUCT;
	MpUserLoginConfigType : 	STRUCT 
		AutoLogout : DINT := 600; (*Automatic logout time (for inactive users) [s]*)
	END_STRUCT;
	MpUserSignatureUIDlgType : 	STRUCT 
		LayerStatus : UINT; (*Visibility of the dialog box (status data point for the dialog box layer)*)
		UserName : WSTRING[20]; (*Username*)
		Password : WSTRING[20]; (*Password*)
		Comment : WSTRING[100]; (*Optional comment added by signing operator*)
		Confirm : BOOL; (*Confirms the operation*)
		Cancel : BOOL; (*Cancels the operation*)
	END_STRUCT;
	MpUserSignatureUIConnectType : 	STRUCT 
		Status : MpUserUIStatusEnum; (*Current status of the signature-procedure*)
		SignAction : DINT; (*Start signature procedure by setting this to a value not equal to 0. The value will be available on the CheckAction-FB.*)
		Dialog : MpUserSignatureUIDlgType;
		MessageBox : MpUserUIMessageBoxType; (*Controls dialog boxes*)
		DefaultLayerStatus : UINT; (*Status data point for the default layer of the visualization page where logging in and out takes place*)
	END_STRUCT;
END_TYPE

(*FB Info Types*)

TYPE
	MpUserLoginInfoType : 	STRUCT 
		AutoLogoutRemain : TIME; (*Time remaining before automatic logout [s]*)
		Diag : MpUserDiagType; (*Diagnostic structure for the status ID*)
	END_STRUCT;
	MpUserInfoType : 	STRUCT 
		Diag : MpUserDiagType; (*Diagnostic structure for the status ID*)
	END_STRUCT;
	MpUserDiagType : 	STRUCT 
		StatusID : MpUserStatusIDType; (*StatusID diagnostic structure*)
	END_STRUCT;
	MpUserStatusIDType : 	STRUCT 
		ID : MpUserErrorEnum; (*Error code for mapp component*)
		Severity : MpComSeveritiesEnum; (*Describes the type of information supplied by the status ID (success, information, warning, error)*)
		Code : UINT; (*Code for the status ID. This error number can be used to search for additional information in the help system*)
	END_STRUCT;
END_TYPE

(*FB Internal Types*)

TYPE
	MpUserInternalType : 	STRUCT 
		pObject : UDINT;
		pInstance : UDINT; (*Marker for FB-instance (overload detection)*)
		State : DINT; (*State for internal life-time management*)
	END_STRUCT;
END_TYPE

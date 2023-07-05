
FUNCTION_BLOCK MpUserLogin (*Login and logout users (via the application)*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		LifeSign : DINT; (*Used to determine if the logged in user has been inactive for a long time. The inactivity time is reset when this input changes*) (* *) (*#CYC#;*)
		Login : BOOL; (*Command used to log in*) (* *) (*#CMD#;*)
		Logout : BOOL; (*Command used to log out*) (* *) (*#CMD#;*)
		UserName : REFERENCE TO WSTRING[20]; (*Username to be used for logging in*) (* *) (*#CMD#;*)
		Password : REFERENCE TO WSTRING[20]; (*Password to be used for logging in*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		CommandBusy : BOOL; (*Function block currently executing command*) (* *) (*#CMD#;*)
		CommandDone : BOOL; (*Command successfully executed by function block*) (* *) (*#CMD#;*)
		CurrentUser : WSTRING[20]; (*Username of the logged in user*) (* *) (*#CMD#;*)
		CurrentLevel : DINT; (*Level of the logged in user*) (* *) (*#CMD#;*)
		AccessRights : ARRAY[0..19] OF MpUserAccessRightEnum; (*Access rights of the logged in user*) (* *) (*#CMD#;*)
		Info : MpUserLoginInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpUserInternalType; (*Internal stucture*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpUserManagerUI (*UI connection for VC4 user management page*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		UISetup : MpUserMgrUISetupType := (UserListSize:=20); (*Used to configure the elements connected to the HMI application*) (* *) (*#PAR#;*)
		UIConnect : REFERENCE TO MpUserMgrUIConnectType; (*This structure contains the parameters needed for the connection to the HMI application*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpUserInternalType; (*Internal stucture*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpUserLoginUI (*UI connection for VC4 login/logout page*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		UIConnect : REFERENCE TO MpUserLoginUIConnectType; (*This structure contains the parameters needed for the connection to the HMI application*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpUserInternalType; (*Internal stucture*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MpUserCreateUser : DINT (*Add a default user (via the application)*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		UserName : WSTRING[20]; (*Username for logging in*) (* *) (*#PAR#;*)
		Password : WSTRING[20]; (*Password for logging in*) (* *) (*#PAR#;*)
		FullName : WSTRING[100]; (*Complete name*) (* *) (*#PAR#;*)
		GroupName : WSTRING[20]; (*Group to which the user should be assigned*) (* *) (*#PAR#;*)
		Language : UINT; (*Preferred language*) (* *) (*#PAR#;*)
		DisplayUnit : UINT; (*Preferred system of units*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION MpUserCreateGroup : DINT (*Add a group (via the application)*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		Name : WSTRING[20]; (*Name of the user group*) (* *) (*#PAR#;*)
		Index : UINT; (*Index of the user group (must be in ascending order)*) (* *) (*#PAR#;*)
		Admin : BOOL; (*Defines whether the group has administrator rights*) (* *) (*#PAR#;*)
		Level : DINT; (*Level of the user group*) (* *) (*#PAR#;*)
		AccessRights : ARRAY[0..19] OF MpUserAccessRightEnum; (*List that defines the rights for individual functions*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION MpUserLevel : DINT (*Returns the level of the user who is currently logged in*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION MpUserAccessRight : MpUserAccessRightEnum (*Returns the access rights of the user who is currently logged in*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Right : UINT; (*Function for which the access right should be checked*) (* *) (*#CMD#;*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK MpUserConfig (*Configuration for user management*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		Configuration : REFERENCE TO MpUserConfigType; (*Structure used to specify the configuration*) (* *) (*#PAR#;*)
		Load : BOOL; (*Loads the configuration of the component*) (* *) (*#CMD#;*)
		Save : BOOL; (*Saves the configuration of the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		CommandBusy : BOOL; (*Function block currently executing command*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Command successfully executed by function block*) (* *) (*#CMD#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal information *)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpUserLoginConfig (*Configuration for the login/logout behavior*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		Configuration : REFERENCE TO MpUserLoginConfigType; (*Structure used to specify the configuration*) (* *) (*#PAR#;*)
		Load : BOOL; (*Loads the configuration of the component*) (* *) (*#CMD#;*)
		Save : BOOL; (*Saves the configuration of the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		CommandBusy : BOOL; (*Function block currently executing command*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Command successfully executed by function block*) (* *) (*#CMD#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal information *)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MpUserChangePassword : DINT (*Change the password of a existing user*)
	VAR_INPUT
		UserName : WSTRING[20]; (*Name of the user group*) (* *) (*#PAR#;*)
		Password : WSTRING[20]; (*Password for logging in*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION_BLOCK MpUserSignatureUI (*UI-Interface for electronic signature*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		SignAction : DINT; (*Triggers for application to start signature-procedure*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
		UIConnect : REFERENCE TO MpUserSignatureUIConnectType; (*This structure contains the parameters needed for the connection to the HMI application*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpUserInternalType; (*Internal stucture*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpUserSignature (*Check electronic signature*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets function block errors*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block*) (* *) (*#PAR#;*)
		ActionID : DINT; (*Optional ActionID set by the SignatureUI*) (* *) (*#CMD#;*)
		Released : BOOL; (*Action is released (Active for 1 call only!)*) (* *) (*#CMD#;*)
		Rejected : BOOL; (*Action is rejected (Active for 1 call only!)*) (* *) (*#CMD#;*)
		Info : MpUserInfoType; (*Additional information about the component*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpUserInternalType; (*Internal stucture*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MpUserCheckPassword : DINT (*Check user/password-credentials*)
	VAR_INPUT
		UserName : WSTRING[20]; (*Username for logging in*) (* *) (*#PAR#;*)
		Password : WSTRING[20]; (*Password for logging in*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

FUNCTION MpUserGetData : DINT (*Get additional user-data for a given user*) (* $GROUP=mapp Services,$CAT=User Manager,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpUser.png *)
	VAR_INPUT
		UserName : WSTRING[50]; (*Username to be used for logging in*) (* *) (*#PAR#;*)
		Key : WSTRING[20]; (*Key to identify value to query (case-sensitive)*) (* *) (*#PAR#;*)
		Value : WSTRING[255]; (*Buffer to write value to*) (* *) (*#PAR#;*)
		ValueSize : UDINT; (*Max. size of write-buffer*) (* *) (*#PAR#;*)
	END_VAR
END_FUNCTION

/* Automation Studio generated header file */
/* Do not edit ! */
/* MpUser 5.22.1 */

#ifndef _MPUSER_
#define _MPUSER_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MpUser_VERSION
#define _MpUser_VERSION 5.22.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MpBase.h"
#endif

#ifdef _SG4
		#include "MpBase.h"
#endif

#ifdef _SGC
		#include "MpBase.h"
#endif



/* Datatypes and datatypes of function blocks */
typedef enum MpUserAccessRightEnum
{	mpUSER_ACCESS_UNDEFINED = 0,
	mpUSER_ACCESS_NONE = 1,
	mpUSER_ACCESS_VIEW = 2,
	mpUSER_ACCESS_ACTUATE = 3,
	mpUSER_ACCESS_FULL = 4
} MpUserAccessRightEnum;

typedef enum MpUserUIMessageEnum
{	mpUSER_MSG_NONE = 0,
	mpUSER_MSG_ERROR = 1,
	mpUSER_MSG_CONFIRM_DELETE = 2,
	mpUSER_MSG_CONFIRM_LOCK = 3,
	mpUSER_MSG_CONFIRM_UNLOCK = 4,
	mpUSER_MSG_CONFIRM_GROUP_DELETE = 5
} MpUserUIMessageEnum;

typedef enum MpUserMgrUIImportConfirmEnum
{	mpUSER_CONFIRM_USER = 0,
	mpUSER_CONFIRM_GROUP = 1
} MpUserMgrUIImportConfirmEnum;

typedef enum MpUserUIStatusEnum
{	mpUSER_UI_STATUS_IDLE = 0,
	mpUSER_UI_STATUS_WAIT_DLG = 1,
	mpUSER_UI_STATUS_EXECUTE = 2,
	mpUSER_UI_STATUS_ERROR = 99
} MpUserUIStatusEnum;

typedef enum MpUserImportModeEnum
{	mpUSER_IMPORT_SKIP = 0,
	mpUSER_IMPORT_IGNORE_EXISITNG = 1,
	mpUSER_IMPORT_OVERWRITE = 2,
	mpUSER_IMPORT_IGNORE_DEFAULT = 3,
	mpUSER_IMPORT_OVERWRITE_ONLY = 4,
	mpUSER_IMPORT_REMOVE_EXISTING = 5
} MpUserImportModeEnum;

typedef enum MpUserUIPasswordCriteriaEnum
{	mpUSER_PASSWORD_CRIT_NONE = 0,
	mpUSER_PASSWORD_CRIT_LENGTH = 1,
	mpUSER_PASSWORD_CRIT_ALPHA = 2,
	mpUSER_PASSWORD_CRIT_CASE = 3,
	mpUSER_PASSWORD_CRIT_SPECIAL = 4
} MpUserUIPasswordCriteriaEnum;

typedef enum MpUserErrorEnum
{	mpUSER_NO_ERROR = 0,
	mpUSER_ERR_ACTIVATION = -1064239103,
	mpUSER_ERR_MPLINK_NULL = -1064239102,
	mpUSER_ERR_MPLINK_INVALID = -1064239101,
	mpUSER_ERR_MPLINK_CHANGED = -1064239100,
	mpUSER_ERR_MPLINK_CORRUPT = -1064239099,
	mpUSER_ERR_MPLINK_IN_USE = -1064239098,
	mpUSER_ERR_PAR_NULL = -1064239097,
	mpUSER_ERR_CONFIG_NULL = -1064239096,
	mpUSER_ERR_CONFIG_NO_PV = -1064239095,
	mpUSER_ERR_CONFIG_LOAD = -1064239094,
	mpUSER_WRN_CONFIG_LOAD = -2137980917,
	mpUSER_ERR_CONFIG_SAVE = -1064239092,
	mpUSER_ERR_CONFIG_INVALID = -1064239091,
	mpUSER_ERR_PASSWORD_INCORRECT = -1064148992,
	mpUSER_ERR_USER_NOT_EXISTING = -1064148991,
	mpUSER_ERR_USER_EXISTS = -1064148990,
	mpUSER_ERR_LOGIN_ID_INVALID = -1064148989,
	mpUSER_ERR_ADMIN_INVALID = -1064148988,
	mpUSER_ERR_INSUFFICIENT_RIGHTS = -1064148987,
	mpUSER_ERR_GROUP_NOT_PRESENT = -1064148986,
	mpUSER_ERR_PASSWORD_WEAK = -1064148985,
	mpUSER_ERR_USER_IS_LOCKED = -1064148984,
	mpUSER_ERR_PASSWORD_CHANGE_REQ = -1064148983,
	mpUSER_ERR_TOO_MANY_LOGINS = -1064148982,
	mpUSER_ERR_NO_ADMIN_RIGHTS = -1064148981,
	mpUSER_ERR_LOGIN_INST_EXISTS = -1064148980,
	mpUSER_ERR_NOT_LOGGED_IN = -1064148979,
	mpUSER_ERR_PASSWORD_IDENTICAL = -1064148977,
	mpUSER_ERR_LOGIN_ID_EXISTS = -1064148976,
	mpUSER_WRN_PASSWORD_CHANGE_REQ = -2137890798,
	mpUSER_ERR_GROUP_INDEX_NOT_OK = -1064148973,
	mpUSER_ERR_NO_GROUPNAME = -1064148972,
	mpUSER_ERR_LOGGED_IN = -1064148971,
	mpUSER_ERR_MISSING_UICONNECT = -1064148970,
	mpUSER_ERR_NO_USERNAME = -1064148969,
	mpUSER_ERR_NO_PASSWORD = -1064148968,
	mpUSER_ERR_MISSING_LOGIN = -1064148967,
	mpUSER_ERR_PASSWORD_CONFIRM = -1064148966,
	mpUSER_ERR_NO_SUCH_SYSRIGHT = -1064148965,
	mpUSER_ERR_IMPORT_DATA = -1064148964,
	mpUSER_ERR_LOAD_IMPORT_FILE = -1064148963,
	mpUSER_ERR_SAVE_EXPORT_FILE = -1064148962,
	mpUSER_ERR_GROUPNAME_TOO_LONG = -1064148961,
	mpUSER_ERR_USERNAME_TOO_LONG = -1064148960,
	mpUSER_ERR_PASSWORD_TOO_LONG = -1064148959,
	mpUSER_INF_WAIT_LOGIN_FB = 1083334690,
	mpUSER_ERR_USERNAME_TOO_SHORT = -1064148957,
	mpUSER_ERR_GROUP_EXISTS = -1064148956,
	mpUSER_ERR_GROUP_DEFAULT = -1064148955,
	mpUSER_ERR_MAX_FAILED_SIGNATURES = -1064148954,
	mpUSER_ERR_SIGNATURE_BUSY = -1064148953,
	mpUSER_ERR_PASSWORD_REPEAT = -1064148952,
	mpUSER_ERR_IMPORT_FILE_FORMAT = -1064148951,
	mpUSER_WRN_KEY_DUPLICATE = -2137890774,
	mpUSER_ERR_INFO_NOT_FOUND = -1064148949,
	mpUSER_ERR_EMPTY_KEY = -1064148948,
	mpUSER_ERR_BUFFER_TOO_SMALL = -1064148947
} MpUserErrorEnum;

typedef enum MpUserLoginAlarmEnum
{	mpUSER_ALM_USER_LOCKED = 0
} MpUserLoginAlarmEnum;

typedef struct MpUserUIMessageBoxType
{	unsigned short LayerStatus;
	enum MpUserUIMessageEnum Type;
	unsigned short ErrorNumber;
	plcbit Confirm;
	plcbit Cancel;
} MpUserUIMessageBoxType;

typedef struct MpUserMgrUIUserListType
{	plcwstring UserNames[20][21];
	unsigned char UserOptions[20];
	unsigned short MaxSelection;
	unsigned short SelectedIndex;
	plcbit PageUp;
	plcbit StepUp;
	plcbit PageDown;
	plcbit StepDown;
	float RangeStart;
	float RangeEnd;
} MpUserMgrUIUserListType;

typedef struct MpUserMgrUIAdditionalDataType
{	plcwstring Key[21];
	plcwstring Value[256];
} MpUserMgrUIAdditionalDataType;

typedef struct MpUserMgrUIUserInfoType
{	plcwstring UserName[21];
	plcwstring FullName[101];
	unsigned short GroupIndex;
	plcbit Locked;
	plcbit Expired;
	unsigned char RemainingAttempts;
	unsigned short Language;
	unsigned short DisplayUnit;
	plcstring LoginToken[5][21];
	plcdt Creation;
	plcdt FirstLogin;
	plcdt LastLogin;
	plcdt PasswordExpired;
	struct MpUserMgrUIAdditionalDataType AdditionalData[10];
} MpUserMgrUIUserInfoType;

typedef struct MpUserMgrUIGroupListType
{	plcwstring Names[10][21];
	unsigned short SelectedIndex;
	unsigned short MaxSelection;
	plcbit PageUp;
	plcbit StepUp;
	plcbit PageDown;
	plcbit StepDown;
	float RangeStart;
	float RangeEnd;
} MpUserMgrUIGroupListType;

typedef struct MpUserMgrUIGroupInfoType
{	plcwstring Name[21];
	unsigned short Index;
	signed long Level;
	plcbit Admin;
	enum MpUserAccessRightEnum AccessRights[20];
} MpUserMgrUIGroupInfoType;

typedef struct MpUserMgrUIGroupDlgType
{	unsigned short LayerStatus;
	plcwstring Name[21];
	unsigned short Index;
	signed long Level;
	plcbit Admin;
	enum MpUserAccessRightEnum AccessRights[20];
	plcbit Confirm;
	plcbit Cancel;
	signed long LevelLimit;
	enum MpUserAccessRightEnum AccessRightsLimit[20];
} MpUserMgrUIGroupDlgType;

typedef struct MpUserMgrUIGroupCreateDlgType
{	unsigned short LayerStatus;
	plcwstring Name[21];
	signed long Level;
	plcbit Admin;
	enum MpUserAccessRightEnum AccessRights[20];
	plcbit Confirm;
	plcbit Cancel;
	signed long LevelLimit;
	enum MpUserAccessRightEnum AccessRightsLimit[20];
} MpUserMgrUIGroupCreateDlgType;

typedef struct MpUserMgrUIGroupCreateType
{	plcbit ShowDialog;
	plcbit Lock;
	struct MpUserMgrUIGroupCreateDlgType Dialog;
} MpUserMgrUIGroupCreateType;

typedef struct MpUserMgrUIGroupEditType
{	plcbit ShowDialog;
	plcbit Lock;
	struct MpUserMgrUIGroupDlgType Dialog;
} MpUserMgrUIGroupEditType;

typedef struct MpUserMgrUICreateDlgType
{	unsigned short LayerStatus;
	plcwstring UserName[21];
	plcwstring FullName[101];
	unsigned short GroupIndex;
	unsigned char GroupOption[20];
	plcwstring NewPassword[21];
	plcwstring ConfirmPassword[21];
	unsigned short Language;
	unsigned short DisplayUnit;
	plcbit Confirm;
	plcbit Cancel;
	enum MpUserUIPasswordCriteriaEnum CriteriaNotMet;
	unsigned short NewPasswordOk;
	unsigned short ConfirmPasswordOk;
	unsigned short UserNameOk;
	struct MpUserMgrUIAdditionalDataType AdditionalData[10];
} MpUserMgrUICreateDlgType;

typedef struct MpUserMgrUICreateType
{	plcbit ShowDialog;
	plcbit Lock;
	struct MpUserMgrUICreateDlgType Dialog;
} MpUserMgrUICreateType;

typedef struct MpUserMgrUIExportDlgType
{	unsigned short LayerStatus;
	plcstring FileName[256];
	plcbit Confirm;
	plcbit Cancel;
} MpUserMgrUIExportDlgType;

typedef struct MpUserMgrUIExportType
{	plcbit ShowDialog;
	struct MpUserMgrUIExportDlgType Dialog;
} MpUserMgrUIExportType;

typedef struct MpUserMgrUIImportListType
{	plcstring FileNames[5][256];
	unsigned short SelectedIndex;
	unsigned short MaxSelection;
} MpUserMgrUIImportListType;

typedef struct MpUserMgrUIImportDlgType
{	unsigned short LayerStatus;
	struct MpUserMgrUIImportListType List;
	plcstring FileName[256];
	plcbit Users;
	plcbit GroupSettings;
	plcbit Confirm;
	plcbit Cancel;
} MpUserMgrUIImportDlgType;

typedef struct MpUserMgrUIImportConfirmType
{	unsigned short LayerStatus;
	enum MpUserMgrUIImportConfirmEnum Type;
	plcwstring Name[21];
	unsigned short NumberOfConflicts;
	plcbit ApplyForAll;
	plcbit Confirm;
	plcbit Cancel;
} MpUserMgrUIImportConfirmType;

typedef struct MpUserMgrUIImportType
{	plcbit ShowDialog;
	struct MpUserMgrUIImportDlgType Dialog;
	struct MpUserMgrUIImportConfirmType ConfirmDialog;
} MpUserMgrUIImportType;

typedef struct MpUserMgrUISetupConfirmType
{	plcbit OverwriteUser;
	plcbit OverwriteGroup;
} MpUserMgrUISetupConfirmType;

typedef struct MpUserMgrUISetupType
{	unsigned short UserListSize;
	unsigned char ScrollWindow;
	plcstring FileDevice[21];
	plcstring FileExtension[21];
	unsigned short GroupListSize;
	struct MpUserMgrUISetupConfirmType Confirmation;
} MpUserMgrUISetupType;

typedef struct MpUserMgrUIUserType
{	struct MpUserMgrUIUserListType List;
	struct MpUserMgrUIUserInfoType Info;
	struct MpUserMgrUICreateType Create;
	struct MpUserMgrUICreateType Edit;
	plcbit Remove;
	plcbit Lock;
} MpUserMgrUIUserType;

typedef struct MpUserMgrUIGroupSelectType
{	plcwstring Names[20][21];
	unsigned short MaxSelection;
} MpUserMgrUIGroupSelectType;

typedef struct MpUserMgrUIGroupType
{	struct MpUserMgrUIGroupListType List;
	struct MpUserMgrUIGroupInfoType Info;
	struct MpUserMgrUIGroupEditType Edit;
	struct MpUserMgrUIGroupCreateType Create;
	plcbit Remove;
	struct MpUserMgrUIGroupSelectType SelectList;
} MpUserMgrUIGroupType;

typedef struct MpUserMgrUIConnectType
{	enum MpUserUIStatusEnum Status;
	struct MpUserMgrUIUserType User;
	struct MpUserMgrUIGroupType Group;
	struct MpUserMgrUIExportType Export;
	struct MpUserMgrUIImportType Import;
	struct MpUserUIMessageBoxType MessageBox;
	unsigned short DefaultLayerStatus;
} MpUserMgrUIConnectType;

typedef struct MpUserLoginUIPwdDlgType
{	plcwstring OldPassword[21];
	plcwstring NewPassword[21];
	plcwstring ConfirmPassword[21];
	unsigned short LayerStatus;
	plcbit Confirm;
	plcbit Cancel;
	enum MpUserUIPasswordCriteriaEnum CriteriaNotMet;
	unsigned short NewPasswordOk;
	unsigned short ConfirmPasswordOk;
} MpUserLoginUIPwdDlgType;

typedef struct MpUserLoginUIPwdType
{	plcbit ShowDialog;
	struct MpUserLoginUIPwdDlgType Dialog;
} MpUserLoginUIPwdType;

typedef struct MpUserLoginUILoginType
{	plcbit Login;
	plcbit Logout;
	plcwstring UserName[21];
	plcwstring Password[21];
} MpUserLoginUILoginType;

typedef struct MpUserLoginUIConnectType
{	enum MpUserUIStatusEnum Status;
	plcwstring CurrentUser[21];
	unsigned short Language;
	unsigned short DisplayUnit;
	plcbit LoggedIn;
	signed long UserLevel;
	struct MpUserLoginUILoginType Login;
	struct MpUserLoginUIPwdType ChangePassword;
	struct MpUserUIMessageBoxType MessageBox;
	unsigned short DefaultLayerStatus;
} MpUserLoginUIConnectType;

typedef struct MpUserConfigType
{	plcbit NoDelete;
	plcbit PasswordChangeReq;
	plcbit PasswordCase;
	plcbit PasswordAlpha;
	unsigned short PasswordLength;
	unsigned short LoginAttempts;
	signed long PasswordChangeInterval;
	signed long UserExpirationTime;
	unsigned short UserNameLength;
	unsigned short SignAttempts;
	unsigned short PasswordHistory;
	plcbit PasswordSpecial;
	plcbit EditSameLevel;
	enum MpUserImportModeEnum ImportUser;
	enum MpUserImportModeEnum ImportGroup;
	plcbit ImportUnchecked;
	signed long AdminUnlockTime;
} MpUserConfigType;

typedef struct MpUserLoginConfigType
{	signed long AutoLogout;
} MpUserLoginConfigType;

typedef struct MpUserSignatureUIDlgType
{	unsigned short LayerStatus;
	plcwstring UserName[21];
	plcwstring Password[21];
	plcwstring Comment[101];
	plcbit Confirm;
	plcbit Cancel;
} MpUserSignatureUIDlgType;

typedef struct MpUserSignatureUIConnectType
{	enum MpUserUIStatusEnum Status;
	signed long SignAction;
	struct MpUserSignatureUIDlgType Dialog;
	struct MpUserUIMessageBoxType MessageBox;
	unsigned short DefaultLayerStatus;
} MpUserSignatureUIConnectType;

typedef struct MpUserStatusIDType
{	enum MpUserErrorEnum ID;
	MpComSeveritiesEnum Severity;
	unsigned short Code;
} MpUserStatusIDType;

typedef struct MpUserDiagType
{	struct MpUserStatusIDType StatusID;
} MpUserDiagType;

typedef struct MpUserLoginInfoType
{	plctime AutoLogoutRemain;
	struct MpUserDiagType Diag;
} MpUserLoginInfoType;

typedef struct MpUserInfoType
{	struct MpUserDiagType Diag;
} MpUserInfoType;

typedef struct MpUserInternalType
{	unsigned long pObject;
	unsigned long pInstance;
	signed long State;
} MpUserInternalType;

typedef struct MpUserLogin
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	signed long LifeSign;
	plcwstring (*UserName);
	plcwstring (*Password);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	plcwstring CurrentUser[21];
	signed long CurrentLevel;
	enum MpUserAccessRightEnum AccessRights[20];
	struct MpUserLoginInfoType Info;
	/* VAR (analog) */
	struct MpUserInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Login;
	plcbit Logout;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpUserLogin_typ;

typedef struct MpUserManagerUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpUserMgrUISetupType UISetup;
	struct MpUserMgrUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpUserInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpUserManagerUI_typ;

typedef struct MpUserLoginUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpUserLoginUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpUserInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpUserLoginUI_typ;

typedef struct MpUserConfig
{
	/* VAR_INPUT (analog) */
	struct MpUserConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Load;
	plcbit Save;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpUserConfig_typ;

typedef struct MpUserLoginConfig
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpUserLoginConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Load;
	plcbit Save;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpUserLoginConfig_typ;

typedef struct MpUserSignatureUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	signed long SignAction;
	struct MpUserSignatureUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpUserInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpUserSignatureUI_typ;

typedef struct MpUserSignature
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	signed long ActionID;
	struct MpUserInfoType Info;
	/* VAR (analog) */
	struct MpUserInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit Released;
	plcbit Rejected;
} MpUserSignature_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MpUserLogin(struct MpUserLogin* inst);
_BUR_PUBLIC void MpUserManagerUI(struct MpUserManagerUI* inst);
_BUR_PUBLIC void MpUserLoginUI(struct MpUserLoginUI* inst);
_BUR_PUBLIC void MpUserConfig(struct MpUserConfig* inst);
_BUR_PUBLIC void MpUserLoginConfig(struct MpUserLoginConfig* inst);
_BUR_PUBLIC void MpUserSignatureUI(struct MpUserSignatureUI* inst);
_BUR_PUBLIC void MpUserSignature(struct MpUserSignature* inst);
_BUR_PUBLIC signed long MpUserCreateUser(plcwstring* UserName, plcwstring* Password, plcwstring* FullName, plcwstring* GroupName, unsigned short Language, unsigned short DisplayUnit);
_BUR_PUBLIC signed long MpUserCreateGroup(plcwstring* Name, unsigned short Index, plcbit Admin, signed long Level, enum MpUserAccessRightEnum AccessRights[20]);
_BUR_PUBLIC signed long MpUserLevel(struct MpComIdentType* MpLink);
_BUR_PUBLIC MpUserAccessRightEnum MpUserAccessRight(struct MpComIdentType* MpLink, unsigned short Right);
_BUR_PUBLIC signed long MpUserChangePassword(plcwstring* UserName, plcwstring* Password);
_BUR_PUBLIC signed long MpUserCheckPassword(plcwstring* UserName, plcwstring* Password);
_BUR_PUBLIC signed long MpUserGetData(plcwstring* UserName, plcwstring* Key, plcwstring* Value, unsigned long ValueSize);


#ifdef __cplusplus
};
#endif
#endif /* _MPUSER_ */


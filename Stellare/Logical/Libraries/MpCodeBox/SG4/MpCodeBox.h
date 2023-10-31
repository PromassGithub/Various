/* Automation Studio generated header file */
/* Do not edit ! */
/* MpCodeBox 5.12.1 */

#ifndef _MPCODEBOX_
#define _MPCODEBOX_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MpCodeBox_VERSION
#define _MpCodeBox_VERSION 5.12.1
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MpBase.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsArLog.h"
		#include "AsArProf.h"
		#include "AsMem.h"
#endif

#ifdef _SG4
		#include "MpBase.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsArLog.h"
		#include "AsArProf.h"
		#include "AsMem.h"
#endif

#ifdef _SGC
		#include "MpBase.h"
		#include "astime.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsArLog.h"
		#include "AsArProf.h"
		#include "AsMem.h"
#endif



/* Datatypes and datatypes of function blocks */
typedef enum MpCodeBoxProgramStateEnum
{	mpCODEBOX_STATE_UNDEFINED,
	mpCODEBOX_STATE_LOADING,
	mpCODEBOX_STATE_INIT_UP,
	mpCODEBOX_STATE_RUNNING,
	mpCODEBOX_STATE_SUSPENDED,
	mpCODEBOX_STATE_ERROR
} MpCodeBoxProgramStateEnum;

typedef enum MpCodeBoxItemEnum
{	mpCODEBOX_ITEM_PROGRAM,
	mpCODEBOX_ITEM_MACRO
} MpCodeBoxItemEnum;

typedef enum MpCodeBoxCodeEnum
{	mpCODEBOX_CODE_LD_SIMPLE,
	mpCODEBOX_CODE_ST
} MpCodeBoxCodeEnum;

typedef enum MpCodeBoxErrorEnum
{	mpCODEBOX_NO_ERROR = 0,
	mpCODEBOX_ERR_ACTIVATION = -1064239103,
	mpCODEBOX_ERR_MPLINK_NULL = -1064239102,
	mpCODEBOX_ERR_MPLINK_INVALID = -1064239101,
	mpCODEBOX_ERR_MPLINK_CHANGED = -1064239100,
	mpCODEBOX_ERR_MPLINK_CORRUPT = -1064239099,
	mpCODEBOX_ERR_MPLINK_IN_USE = -1064239098,
	mpCODEBOX_ERR_CONFIG_INVALID = -1064239091,
	mpCODEBOX_ERR_PROGRAM_EXISTS = -1064169472,
	mpCODEBOX_ERR_PROGRAM_MISSING = -1064169471,
	mpCODEBOX_ERR_PROGRAM_ERROR = -1064169470,
	mpCODEBOX_ERR_PROGRAM_NOT_LOADED = -1064169469,
	mpCODEBOX_ERR_PROGRAM_TYPE = -1064169468,
	mpCODEBOX_ERR_INVALID_PROGRAM = -1064169467,
	mpCODEBOX_ERR_COMMAND_ACTIVE = -1064169466,
	mpCODEBOX_ERR_INVALID_FILE_NAME = -1064169465,
	mpCODEBOX_ERR_INVALID_FILE_DEV = -1064169464,
	mpCODEBOX_ERR_FILE_SYSTEM = -1064169463,
	mpCODEBOX_ERR_INVALID_ITEM_NAME = -1064169462,
	mpCODEBOX_ERR_MACRO_MISSING = -1064169461,
	mpCODEBOX_ERR_MACRO_EXISTS = -1064169460,
	mpCODEBOX_ERR_MACRO_ERROR = -1064169459,
	mpCODEBOX_ERR_SIGNATURE = -1064169458,
	mpCODEBOX_ERR_START_PROGRAM = -1064169457,
	mpCODEBOX_ERR_PROGRAM_EXECUTION = -1064169456,
	mpCODEBOX_INF_WAIT_CORE_FB = 1083314193,
	mpCODEBOX_ERR_STOP_PROGRAM = -1064169453,
	mpCODEBOX_ERR_CONVERT_PROGRAM = -1064169452,
	mpCODEBOX_ERR_ITEM_TYPE = -1064169451
} MpCodeBoxErrorEnum;

typedef enum MpCodeboxAlarmEnum
{	mpCODEBOX_ALM_IMPORT_FAILED = 0,
	mpCODEBOX_ALM_START_FAILED = 1
} MpCodeboxAlarmEnum;

typedef struct MpCodeBoxCoreProgramsType
{	plcstring Name[10][101];
} MpCodeBoxCoreProgramsType;

typedef struct MpCodeBoxStatusIDType
{	enum MpCodeBoxErrorEnum ID;
	MpComSeveritiesEnum Severity;
	unsigned short Code;
} MpCodeBoxStatusIDType;

typedef struct MpCodeBoxDiagType
{	struct MpCodeBoxStatusIDType StatusID;
} MpCodeBoxDiagType;

typedef struct MpCodeBoxProgramInfoType
{	plcstring Name[101];
	enum MpCodeBoxProgramStateEnum State;
	signed long Error;
} MpCodeBoxProgramInfoType;

typedef struct MpCodeBoxCoreInfoType
{	unsigned short NumberOfActivePrograms;
	struct MpCodeBoxProgramInfoType Program[10];
	struct MpCodeBoxDiagType Diag;
} MpCodeBoxCoreInfoType;

typedef struct MpCodeBoxBasicSandboxType
{	plcbit DigIn[12];
	plcbit DigOut[12];
} MpCodeBoxBasicSandboxType;

typedef struct MpCodeBoxInfoType
{	struct MpCodeBoxDiagType Diag;
} MpCodeBoxInfoType;

typedef struct MpCodeBoxManagerInternalType
{	unsigned long Data[6];
} MpCodeBoxManagerInternalType;

typedef struct MpCodeBoxCore
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpCodeBoxCoreProgramsType Programs;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpCodeBoxCoreInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Start;
	plcbit Stop;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit Running;
	plcbit CommandBusy;
} MpCodeBoxCore_typ;

typedef struct MpCodeBoxProgramControl
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*Name);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpCodeBoxInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Start;
	plcbit Suspend;
	plcbit Reload;
	plcbit Resume;
	plcbit Stop;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpCodeBoxProgramControl_typ;

typedef struct MpCodeBoxManager
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	enum MpCodeBoxItemEnum ItemType;
	plcstring (*ItemName);
	plcstring (*DeviceName);
	plcstring (*FileName);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpCodeBoxInfoType Info;
	/* VAR (analog) */
	struct MpCodeBoxManagerInternalType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Overwrite;
	plcbit Export;
	plcbit Import;
	plcbit Delete;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit CommandDone;
} MpCodeBoxManager_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MpCodeBoxCore(struct MpCodeBoxCore* inst);
_BUR_PUBLIC void MpCodeBoxProgramControl(struct MpCodeBoxProgramControl* inst);
_BUR_PUBLIC void MpCodeBoxManager(struct MpCodeBoxManager* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MPCODEBOX_ */


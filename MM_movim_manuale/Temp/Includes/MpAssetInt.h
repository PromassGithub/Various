/* Automation Studio generated header file */
/* Do not edit ! */
/* MpAssetInt 5.18.0 */

#ifndef _MPASSETINT_
#define _MPASSETINT_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MpAssetInt_VERSION
#define _MpAssetInt_VERSION 5.18.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "MpBase.h"
		#include "sys_lib.h"
#endif

#ifdef _SG4
		#include "MpBase.h"
		#include "sys_lib.h"
#endif

#ifdef _SGC
		#include "MpBase.h"
		#include "sys_lib.h"
#endif



/* Datatypes and datatypes of function blocks */
typedef enum MpAssetIntErrorEnum
{	mpASSETINT_NO_ERROR = 0,
	mpASSETINT_ERR_ACTIVATION = -1064239103,
	mpASSETINT_ERR_MPLINK_NULL = -1064239102,
	mpASSETINT_ERR_MPLINK_INVALID = -1064239101,
	mpASSETINT_ERR_MPLINK_CHANGED = -1064239100,
	mpASSETINT_ERR_MPLINK_CORRUPT = -1064239099,
	mpASSETINT_ERR_MPLINK_IN_USE = -1064239098,
	mpASSETINT_ERR_PAR_NULL = -1064239097,
	mpASSETINT_ERR_CONFIG_NULL = -1064239096,
	mpASSETINT_ERR_CONFIG_NO_PV = -1064239095,
	mpASSETINT_ERR_CONFIG_LOAD = -1064239094,
	mpASSETINT_WRN_CONFIG_LOAD = -2137980917,
	mpASSETINT_ERR_CONFIG_SAVE = -1064239092,
	mpASSETINT_ERR_CONFIG_INVALID = -1064239091,
	mpASSETINT_ERR_BUFFER_CREATE = -1064136704,
	mpASSETINT_ERR_WRITE_EXPORT_FILE = -1064136703,
	mpASSETINT_ERR_READ_BUFFER_ENTRY = -1064136702,
	mpASSETINT_ERR_INVALID_FILE_DEV = -1064136701,
	mpASSETINT_ERR_MISSING_UICONNECT = -1064136700,
	mpASSETINT_INF_WAIT_CORE_FB = 1083346949,
	mpASSETINT_ERR_EVENT_RECORDER = -1064136698,
	mpASSETINT_ERR_INVALID_SHIFT = -1064136697,
	mpASSETINT_ERR_BUFFER_RESET = -1064136696
} MpAssetIntErrorEnum;

typedef enum MpAssetIntCoreAlarmEnum
{	mpASSETINT_ALM_EXPORT_STATISTICS = 0,
	mpASSETINT_ALM_EXPORT_TIMELINE = 1,
	mpASSETINT_ALM_EXPORT_JOB = 2,
	mpASSETINT_ALM_UNSCH_DOWNTIME = 3
} MpAssetIntCoreAlarmEnum;

typedef enum MpAssetIntUIStatusEnum
{	mpASSETINT_UI_STATUS_IDLE = 0,
	mpASSETINT_UI_STATUS_UPDATE = 1,
	mpASSETINT_UI_STATUS_FILTER = 2
} MpAssetIntUIStatusEnum;

typedef enum MpAssetIntMemoryEnum
{	mpASSETINT_MEM_TEMP = 0,
	mpASSETINT_MEM_ROM = 1,
	mpASSETINT_MEM_SRAM = 2
} MpAssetIntMemoryEnum;

typedef enum MpAssetIntDowntimeEnum
{	mpASSETINT_NO_DOWNTIME = 0,
	mpASSETINT_SCHEDULED_DOWNTIME = 1,
	mpASSETINT_UNSCHEDULED_DOWNTIME = 2
} MpAssetIntDowntimeEnum;

typedef enum MpAssetIntUIProductionStateEnum
{	mpASSETINT_STATE_NO_SHIFT_ACTIVE = 0,
	mpASSETINT_STATE_UPTIME = 1,
	mpASSETINT_STATE_SCHDL_DOWNTIME = 2,
	mpASSETINT_STATE_UNSCH_DOWNTIME = 3
} MpAssetIntUIProductionStateEnum;

typedef struct MpAssetIntTimeSlotType
{	plctod Start;
	plctod End;
} MpAssetIntTimeSlotType;

typedef struct MpAssetIntScheduledDowntimeType
{	plcstring Reason[51];
	plctod Start;
	plctod End;
} MpAssetIntScheduledDowntimeType;

typedef struct MpAssetIntShiftParType
{	plcstring Name[21];
	struct MpAssetIntTimeSlotType TotalTime;
	struct MpAssetIntScheduledDowntimeType ScheduledDowntime[10];
} MpAssetIntShiftParType;

typedef struct MpAssetIntExportType
{	plcbit JobStatistics;
	plcstring JobStatisticsFileNamePattern[51];
	plcbit ShiftStatistics;
	plcstring ShiftStatisticsFileNamePattern[51];
	plcbit Timeline;
	plcstring TimelineFileNamePattern[51];
	plcstring TimeStampPattern[51];
	unsigned short DecimalDigits;
	plcstring ColumnSeparator[2];
	plcstring DecimalMark[2];
} MpAssetIntExportType;

typedef struct MpAssetIntCoreConfigType
{	plcbit EnableFileBackup;
	unsigned long RecordingSizeJobStatistics;
	unsigned long RecordingSizeShiftStatistics;
	unsigned long RecordingSizeTimeline;
	unsigned long CalculationTimeBase;
	enum MpAssetIntMemoryEnum RecordMemory;
	float SaveInterval;
	struct MpAssetIntShiftParType Shifts[5];
	struct MpAssetIntExportType Export;
} MpAssetIntCoreConfigType;

typedef struct MpAssetIntParType
{	float NominalProductionRate;
	plcstring Job[21];
	plcstring CurrentUser[51];
	plcstring AdditionalData[256];
} MpAssetIntParType;

typedef struct MpAssetIntUITrendType
{	float SampleData[366];
	unsigned long SampleRate;
	unsigned long SampleCount;
	plcdt SampleDateTime;
	float MinValue;
	float MaxValue;
	signed short HideCurve;
	float TimeZoom;
	float TimeScroll;
} MpAssetIntUITrendType;

typedef struct MpAssetIntUIShiftListType
{	plcstring ShiftNames[6][21];
	unsigned short SelectedIndex;
	unsigned char MaxSelection;
} MpAssetIntUIShiftListType;

typedef struct MpAssetIntUISetDTFilterType
{	plcbit Enable;
	unsigned short Year;
	unsigned char Month;
	unsigned char Day;
	unsigned char Hour;
	unsigned char Minute;
} MpAssetIntUISetDTFilterType;

typedef struct MpAssetIntUIFilterDialogType
{	unsigned short LayerStatus;
	struct MpAssetIntUISetDTFilterType From;
	struct MpAssetIntUISetDTFilterType Until;
	plcbit Confirm;
	plcbit Cancel;
} MpAssetIntUIFilterDialogType;

typedef struct MpAssetIntUICurrDTFilterType
{	plcbit Enable;
	plcdt DateTime;
} MpAssetIntUICurrDTFilterType;

typedef struct MpAssetIntUICurrentFilterType
{	struct MpAssetIntUICurrDTFilterType From;
	struct MpAssetIntUICurrDTFilterType Until;
} MpAssetIntUICurrentFilterType;

typedef struct MpAssetIntUIFilterType
{	plcbit ShowDialog;
	struct MpAssetIntUIFilterDialogType Dialog;
	struct MpAssetIntUICurrentFilterType Current;
	unsigned short DefaultLayerStatus;
} MpAssetIntUIFilterType;

typedef struct MpAssetIntTrendUIConnectType
{	enum MpAssetIntUIStatusEnum Status;
	struct MpAssetIntUITrendType ScheduledDowntimeRate;
	struct MpAssetIntUITrendType UnscheduledDowntimeRate;
	struct MpAssetIntUITrendType NominalProductionRate;
	struct MpAssetIntUITrendType BadPieceRate;
	struct MpAssetIntUIShiftListType ShiftList;
	struct MpAssetIntUIFilterType Filter;
} MpAssetIntTrendUIConnectType;

typedef struct MpAssetIntTimeType
{	unsigned long Hours;
	unsigned char Minutes;
	unsigned char Seconds;
} MpAssetIntTimeType;

typedef struct MpAssetIntUITimeBargraphType
{	unsigned long Duration;
	unsigned long Color;
} MpAssetIntUITimeBargraphType;

typedef struct MpAssetIntUITimelineLineType
{	plcdt StartTime;
	plcstring ShiftName[21];
	plcstring JobName[21];
	enum MpAssetIntUIProductionStateEnum ProductionState;
	plcstring Reason[51];
	struct MpAssetIntTimeType Duration;
	struct MpAssetIntUITimeBargraphType DurationBar;
} MpAssetIntUITimelineLineType;

typedef struct MpAssetIntUITimelineOutputType
{	struct MpAssetIntUITimelineLineType Display[20];
	float RangeStart;
	float RangeEnd;
	plcbit PageUp;
	plcbit StepUp;
	plcbit StepDown;
	plcbit PageDown;
} MpAssetIntUITimelineOutputType;

typedef struct MpAssetIntTimelineUISetupType
{	unsigned short TimelineListSize;
	unsigned char ScrollWindow;
} MpAssetIntTimelineUISetupType;

typedef struct MpAssetIntTimelineUIConnectType
{	enum MpAssetIntUIStatusEnum Status;
	struct MpAssetIntUITimelineOutputType Output;
	struct MpAssetIntUIFilterType Filter;
} MpAssetIntTimelineUIConnectType;

typedef struct MpAssetIntUIShiftListOutputType
{	plcdt StartTime[20];
	plcdt EndTime[20];
	plcstring ShiftName[20][21];
	plcstring CurrentUser[20][51];
	plcstring AdditionalData[20][256];
	unsigned long TargetPieces[20];
	unsigned long TotalPieces[20];
	unsigned long GoodPieces[20];
	unsigned long RejectPieces[20];
	float BadPieceRate[20];
	struct MpAssetIntTimeType TotalTime[20];
	struct MpAssetIntTimeType ScheduledDowntime[20];
	struct MpAssetIntTimeType UnscheduledDowntime[20];
	struct MpAssetIntTimeType Uptime[20];
	struct MpAssetIntTimeType GoodProductionTime[20];
	struct MpAssetIntTimeType NominalProductionTime[20];
	float NominalProductionRate[20];
	float ShiftProductionRate[20];
	float ScheduledDowntimeRate[20];
	float UnscheduledDowntimeRate[20];
	float ProductionRate[20];
	float RangeStart;
	float RangeEnd;
	plcbit PageUp;
	plcbit StepUp;
	plcbit StepDown;
	plcbit PageDown;
	float IdealProductionRate[20];
	plcstring JobName[20][21];
} MpAssetIntUIShiftListOutputType;

typedef struct MpAssetIntShiftListUIConnectType
{	enum MpAssetIntUIStatusEnum Status;
	struct MpAssetIntUIShiftListOutputType Output;
	struct MpAssetIntUIFilterType Filter;
} MpAssetIntShiftListUIConnectType;

typedef struct MpAssetIntUIShiftListJobType
{	plcstring Name[10][21];
} MpAssetIntUIShiftListJobType;

typedef struct MpAssetIntShiftListUISetupType
{	unsigned short OutputListSize;
	unsigned char ScrollWindow;
} MpAssetIntShiftListUISetupType;

typedef struct MpAssetIntUIJobListOutputType
{	plcdt JobStartTime[20];
	plcdt JobEndTime[20];
	plcstring JobName[20][21];
	plcstring CurrentUser[20][51];
	plcstring AdditionalData[20][256];
	unsigned long TotalPieces[20];
	unsigned long GoodPieces[20];
	unsigned long RejectPieces[20];
	float BadPieceRate[20];
	struct MpAssetIntTimeType TotalTime[20];
	struct MpAssetIntTimeType ScheduledDowntime[20];
	struct MpAssetIntTimeType UnscheduledDowntime[20];
	struct MpAssetIntTimeType Uptime[20];
	struct MpAssetIntTimeType GoodProductionTime[20];
	struct MpAssetIntTimeType NominalProductionTime[20];
	float NominalProductionRate[20];
	float ScheduledDowntimeRate[20];
	float UnscheduledDowntimeRate[20];
	float ProductionRate[20];
	float RangeStart;
	float RangeEnd;
	plcbit PageUp;
	plcbit StepUp;
	plcbit StepDown;
	plcbit PageDown;
	plcstring ShiftName[20][21];
} MpAssetIntUIJobListOutputType;

typedef struct MpAssetIntJobListUIConnectType
{	enum MpAssetIntUIStatusEnum Status;
	struct MpAssetIntUIJobListOutputType Output;
	struct MpAssetIntUIFilterType Filter;
} MpAssetIntJobListUIConnectType;

typedef struct MpAssetIntJobListUISetupType
{	unsigned short OutputListSize;
	unsigned char ScrollWindow;
} MpAssetIntJobListUISetupType;

typedef struct MpAssetIntJobStatisticsType
{	plcstring JobName[21];
	struct MpAssetIntTimeType TotalTime;
	struct MpAssetIntTimeType ScheduledDowntime;
	struct MpAssetIntTimeType UnscheduledDowntime;
	struct MpAssetIntTimeType Uptime;
	struct MpAssetIntTimeType NominalProductionTime;
	struct MpAssetIntTimeType GoodProductionTime;
	float ScheduledDowntimeRate;
	float UnscheduledDowntimeRate;
	float NominalProductionTimeRate;
	unsigned long TotalPieces;
	unsigned long GoodPieces;
	unsigned long RejectPieces;
	float BadPieceRate;
	float CurrentProductionRate;
	plcstring CurrentUser[51];
	plcstring AdditionalData[256];
} MpAssetIntJobStatisticsType;

typedef struct MpAssetIntShiftStatisticsType
{	plcstring ShiftName[21];
	struct MpAssetIntTimeType TotalTime;
	struct MpAssetIntTimeType ScheduledDowntime;
	struct MpAssetIntTimeType UnscheduledDowntime;
	struct MpAssetIntTimeType Uptime;
	struct MpAssetIntTimeType GoodProductionTime;
	struct MpAssetIntTimeType NominalProductionTime;
	float ScheduledDowntimeRate;
	float UnscheduledDowntimeRate;
	float NominalProductionTimeRate;
	unsigned long TargetPieces;
	unsigned long TotalPieces;
	unsigned long GoodPieces;
	unsigned long RejectPieces;
	float BadPieceRate;
	float CurrentProductionRate;
	plcstring CurrentUser[51];
	plcstring AdditionalData[256];
	float IdealProductionRate;
} MpAssetIntShiftStatisticsType;

typedef struct MpAssetIntStatusIDType
{	enum MpAssetIntErrorEnum ID;
	MpComSeveritiesEnum Severity;
	unsigned short Code;
} MpAssetIntStatusIDType;

typedef struct MpAssetIntDiagType
{	struct MpAssetIntStatusIDType StatusID;
} MpAssetIntDiagType;

typedef struct MpAssetIntCoreInfoType
{	struct MpAssetIntShiftStatisticsType ShiftStatistics;
	struct MpAssetIntJobStatisticsType JobStatistics;
	struct MpAssetIntDiagType Diag;
} MpAssetIntCoreInfoType;

typedef struct MpAssetIntInfoType
{	struct MpAssetIntDiagType Diag;
} MpAssetIntInfoType;

typedef struct MpAssetIntCore
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntParType* Parameters;
	enum MpAssetIntDowntimeEnum Downtime;
	plcstring (*DowntimeReason);
	unsigned long PieceCounter;
	unsigned long RejectCounter;
	plcstring (*DeviceName);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	float CurrentProductionRate;
	float ScheduledDowntimeRate;
	float UnscheduledDowntimeRate;
	float NominalProductionTimeRate;
	float BadPieceRate;
	struct MpAssetIntCoreInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit Update;
	plcbit Export;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit UpdateDone;
	plcbit CommandBusy;
	plcbit CommandDone;
	plcbit ExportDone;
} MpAssetIntCore_typ;

typedef struct MpAssetIntCoreConfig
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntCoreConfigType* Configuration;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpAssetIntInfoType Info;
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
} MpAssetIntCoreConfig_typ;

typedef struct MpAssetIntTimelineUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntTimelineUISetupType UISetup;
	struct MpAssetIntTimelineUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpAssetIntInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpAssetIntTimelineUI_typ;

typedef struct MpAssetIntTrendUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntTrendUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpAssetIntInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpAssetIntTrendUI_typ;

typedef struct MpAssetIntJobListUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntJobListUISetupType UISetup;
	struct MpAssetIntJobListUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpAssetIntInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpAssetIntJobListUI_typ;

typedef struct MpAssetIntShiftListUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpAssetIntShiftListUISetupType UISetup;
	struct MpAssetIntShiftListUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpAssetIntInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpAssetIntShiftListUI_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MpAssetIntCore(struct MpAssetIntCore* inst);
_BUR_PUBLIC void MpAssetIntCoreConfig(struct MpAssetIntCoreConfig* inst);
_BUR_PUBLIC void MpAssetIntTimelineUI(struct MpAssetIntTimelineUI* inst);
_BUR_PUBLIC void MpAssetIntTrendUI(struct MpAssetIntTrendUI* inst);
_BUR_PUBLIC void MpAssetIntJobListUI(struct MpAssetIntJobListUI* inst);
_BUR_PUBLIC void MpAssetIntShiftListUI(struct MpAssetIntShiftListUI* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MPASSETINT_ */


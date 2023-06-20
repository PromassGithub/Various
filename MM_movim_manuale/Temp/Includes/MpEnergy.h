/* Automation Studio generated header file */
/* Do not edit ! */
/* MpEnergy 5.18.0 */

#ifndef _MPENERGY_
#define _MPENERGY_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MpEnergy_VERSION
#define _MpEnergy_VERSION 5.18.0
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
typedef enum MpEnergyRegModeEnum
{	mpENERGY_REG_MODE_COLLECT = 0,
	mpENERGY_REG_MODE_MONITOR_ONLY = 1
} MpEnergyRegModeEnum;

typedef enum MpEnergyRegPowerUnitsEnum
{	mpENERGY_POWER_UNIT_KW = 0,
	mpENERGY_POWER_UNIT_W = 1
} MpEnergyRegPowerUnitsEnum;

typedef enum MpEnergyRegEnergyUnitsEnum
{	mpENERGY_ENERGY_UNIT_KWH = 0,
	mpENERGY_ENERGY_UNIT_WS = 1,
	mpENERGY_ENERGY_UNIT_WH = 2
} MpEnergyRegEnergyUnitsEnum;

typedef enum MpEnergyCoreUIStatusEnum
{	mpENERGY_CORE_UI_IDLE = 0,
	mpENERGY_CORE_UI_ACTIVE = 1,
	mpENERGY_CORE_UI_ERROR = 99
} MpEnergyCoreUIStatusEnum;

typedef enum MpEnergyErrorEnum
{	mpENERGY_NO_ERROR = 0,
	mpENERGY_ERR_ACTIVATION = -1064239103,
	mpENERGY_ERR_MPLINK_NULL = -1064239102,
	mpENERGY_ERR_MPLINK_INVALID = -1064239101,
	mpENERGY_ERR_MPLINK_CHANGED = -1064239100,
	mpENERGY_ERR_MPLINK_CORRUPT = -1064239099,
	mpENERGY_ERR_MPLINK_IN_USE = -1064239098,
	mpENERGY_INF_WAIT_CORE_FB = 1083330560,
	mpENERGY_ERR_FILE_SYSTEM = -1064153087,
	mpENERGY_ERR_INVALID_FILE_DEV = -1064153086,
	mpENERGY_WRN_VALUE_OUT_OF_RANGE = -2137894909,
	mpENERGY_ERR_INVALID_MODULE_NAME = -1064153084,
	mpENERGY_ERR_MODULE_EXISTS = -1064153083,
	mpENERGY_ERR_BUFFER_CREATE = -1064153082,
	mpENERGY_ERR_MISSING_UICONNECT = -1064153081,
	mpENERGY_ERR_RECORDING_SIZE = -1064153080
} MpEnergyErrorEnum;

typedef struct MpEnergyStatusIDType
{	enum MpEnergyErrorEnum ID;
	MpComSeveritiesEnum Severity;
	unsigned short Code;
} MpEnergyStatusIDType;

typedef struct MpEnergyDiagType
{	struct MpEnergyStatusIDType StatusID;
} MpEnergyDiagType;

typedef struct MpEnergyInfoType
{	struct MpEnergyDiagType Diag;
} MpEnergyInfoType;

typedef struct MpEnergyEnergiesType
{	double ForwardActive;
	double ForwardReactive;
	double ReverseActive;
	double ReverseReactive;
	double Apparent;
} MpEnergyEnergiesType;

typedef struct MpEnergyTemporaryRecordType
{	double CombinedActiveEnergy;
	double CombinedReactiveEnergy;
	struct MpEnergyEnergiesType TotalEnergy;
	double PeakActivePower;
	double PeakReactivePower;
	plctime Duration;
} MpEnergyTemporaryRecordType;

typedef struct MpEnergyCoreInfoType
{	struct MpEnergyEnergiesType TotalEnergy;
	double PeakActivePower;
	double PeakReactivePower;
	double PowerFactor;
	unsigned long RegisteredModules;
	struct MpEnergyTemporaryRecordType TemporaryRecord;
	struct MpEnergyDiagType Diag;
} MpEnergyCoreInfoType;

typedef struct MpEnergyRegPowerInfoType
{	struct MpEnergyEnergiesType TotalEnergy;
	double PowerFactor;
	double PeakActivePower;
	double PeakReactivePower;
	struct MpEnergyDiagType Diag;
} MpEnergyRegPowerInfoType;

typedef struct MpEnergyCoreUISetupType
{	unsigned short ModuleListSize;
	unsigned char ModuleScrollWindow;
} MpEnergyCoreUISetupType;

typedef struct MpEnergyCoreUIModuleListType
{	unsigned short SelectedIndex;
	unsigned short MaxSelection;
	plcbit PageUp;
	plcbit PageDown;
	plcbit StepUp;
	plcbit StepDown;
	float RangeStart;
	float RangeEnd;
	plcstring Names[20][101];
	double ForwardActiveEnergy[20];
	double ReverseActiveEnergy[20];
} MpEnergyCoreUIModuleListType;

typedef struct MpEnergyCoreUIChartType
{	double Data[5];
	plcbit ShowLayer;
	unsigned short LayerStatus;
} MpEnergyCoreUIChartType;

typedef struct MpEnergyCoreUIDetailsType
{	struct MpEnergyEnergiesType Energy;
	double ActivePower;
	double ReactivePower;
	double PeakActivePower;
	double PeakReactivePower;
	double PowerFactor;
	plcbit ShowLayer;
	unsigned short LayerStatus;
} MpEnergyCoreUIDetailsType;

typedef struct MpEnergyCoreUISelectedModuleType
{	struct MpEnergyCoreUIChartType CombinedEnergyChart;
	struct MpEnergyCoreUIChartType ForwardEnergyChart;
	struct MpEnergyCoreUIChartType ReverseEnergyChart;
	struct MpEnergyCoreUIDetailsType Details;
} MpEnergyCoreUISelectedModuleType;

typedef struct MpEnergyCoreUIOverallDetailsType
{	struct MpEnergyEnergiesType Energy;
	double ActivePower;
	double ReactivePower;
	double PeakActivePower;
	double PowerFactor;
	double PeakReactivePower;
} MpEnergyCoreUIOverallDetailsType;

typedef struct MpEnergyCoreUIByModuleChartType
{	double Data[20];
	plcstring ModuleNames[20][101];
	plcbit ShowLayer;
	unsigned short LayerStatus;
} MpEnergyCoreUIByModuleChartType;

typedef struct MpEnergyCoreUIOverallChartsType
{	struct MpEnergyCoreUIChartType CombinedEnergyChart;
	struct MpEnergyCoreUIChartType ForwardEnergyChart;
	struct MpEnergyCoreUIChartType ReverseEnergyChart;
	struct MpEnergyCoreUIByModuleChartType ForwardActiveEnergyByModuleChart;
} MpEnergyCoreUIOverallChartsType;

typedef struct MpEnergyCoreUIConnectType
{	enum MpEnergyCoreUIStatusEnum Status;
	plcbit ShowTemporaryRecord;
	struct MpEnergyCoreUIModuleListType ModuleList;
	struct MpEnergyCoreUISelectedModuleType SelectedModule;
	struct MpEnergyCoreUIOverallDetailsType OverallDetails;
	struct MpEnergyCoreUIOverallChartsType OverallCharts;
} MpEnergyCoreUIConnectType;

typedef struct MpEnergyCore
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*DeviceName);
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	double CombinedActiveEnergy;
	double CombinedReactiveEnergy;
	double ActivePower;
	double ReactivePower;
	struct MpEnergyCoreInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	plcbit TemporaryRecord;
	plcbit Export;
	plcbit Reset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
	plcbit CommandBusy;
	plcbit TemporaryRecording;
	plcbit ExportDone;
	plcbit ResetDone;
} MpEnergyCore_typ;

typedef struct MpEnergyRegPower
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*ModuleName);
	enum MpEnergyRegModeEnum Mode;
	enum MpEnergyRegPowerUnitsEnum Units;
	double ActivePower;
	double ReactivePower;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpEnergyRegPowerInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpEnergyRegPower_typ;

typedef struct MpEnergyRegEnergy
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	plcstring (*ModuleName);
	enum MpEnergyRegModeEnum Mode;
	enum MpEnergyRegEnergyUnitsEnum Units;
	double ForwardActiveEnergy;
	double ForwardReactiveEnergy;
	double ReverseActiveEnergy;
	double ReverseReactiveEnergy;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpEnergyRegPowerInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpEnergyRegEnergy_typ;

typedef struct MpEnergyCoreUI
{
	/* VAR_INPUT (analog) */
	struct MpComIdentType* MpLink;
	struct MpEnergyCoreUISetupType UISetup;
	struct MpEnergyCoreUIConnectType* UIConnect;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct MpEnergyInfoType Info;
	/* VAR (analog) */
	struct MpComInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit ErrorReset;
	/* VAR_OUTPUT (digital) */
	plcbit Active;
	plcbit Error;
} MpEnergyCoreUI_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void MpEnergyCore(struct MpEnergyCore* inst);
_BUR_PUBLIC void MpEnergyRegPower(struct MpEnergyRegPower* inst);
_BUR_PUBLIC void MpEnergyRegEnergy(struct MpEnergyRegEnergy* inst);
_BUR_PUBLIC void MpEnergyCoreUI(struct MpEnergyCoreUI* inst);


#ifdef __cplusplus
};
#endif
#endif /* _MPENERGY_ */


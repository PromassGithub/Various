(*Enum type*)

TYPE
	MpAssetIntUIStatusEnum : 
		(
		mpASSETINT_UI_STATUS_IDLE := 0, (*Status: Idle, Waiting for command*)
		mpASSETINT_UI_STATUS_UPDATE := 1, (*Status: Updating UIConnect structer*)
		mpASSETINT_UI_STATUS_FILTER := 2 (*Status: Showing filter-dialog*)
		);
	MpAssetIntMemoryEnum : 
		(
		mpASSETINT_MEM_TEMP := 0, (*Memory location: DRAM (temporary)*)
		mpASSETINT_MEM_ROM := 1, (*Memory location: USER ROM (memory card)*)
		mpASSETINT_MEM_SRAM := 2 (*Memory location: SRAM (battery-backed)*)
		);
	MpAssetIntDowntimeEnum : 
		(
		mpASSETINT_NO_DOWNTIME := 0, (*No downtime active = uptime*)
		mpASSETINT_SCHEDULED_DOWNTIME := 1, (*Additional scheduled downtime (e.g. monthly maintenance)*)
		mpASSETINT_UNSCHEDULED_DOWNTIME := 2 (*Unscheduled downtime (e.g. machine fault)*)
		);
END_TYPE

(*Config type*)

TYPE
	MpAssetIntCoreConfigType : 	STRUCT 
		EnableFileBackup : BOOL := FALSE; (*Enable file backup functionality or not.*)
		RecordingSizeJobStatistics : UDINT := 20; (*Size of the jobstatistics-Buffer [kBytes]. *)
		RecordingSizeShiftStatistics : UDINT := 20; (*Size of the shiftstatistics-Buffer [kBytes]. *)
		RecordingSizeTimeline : UDINT := 20; (*Size of the timeline-Buffer [kBytes]. *)
		CalculationTimeBase : UDINT := 1000; (*Calculation cycle time for current production rate [ms]*)
		RecordMemory : MpAssetIntMemoryEnum := (0); (*Memory where logging is stored while active. This value is only read when the component is initialized (Disabled -> Enabled).*)
		SaveInterval : REAL := 60.0; (*Defines how often buffer is saved for data protection*)
		Shifts : ARRAY[0..4]OF MpAssetIntShiftParType := [5(0)]; (*Shift schedule in detailed*)
		Export : MpAssetIntExportType; (*Configuration for export*)
	END_STRUCT;
	MpAssetIntExportType : 	STRUCT 
		JobStatistics : BOOL := TRUE; (*Export the job statistics or not.*)
		JobStatisticsFileNamePattern : STRING[50] := 'JobStatistics_%Y_%m_%d_%H_%M.csv'; (*Pattern for export job statistics file.*)
		ShiftStatistics : BOOL := TRUE; (*Export the shift statistics or not.*)
		ShiftStatisticsFileNamePattern : STRING[50] := 'ShiftStatistics_%Y_%m_%d_%H_%M.csv'; (*Pattern for export shift statistics file.*)
		Timeline : BOOL := TRUE; (*Export the timeline statistics or not.*)
		TimelineFileNamePattern : STRING[50] := 'Timeline_%Y_%m_%d_%H_%M.csv'; (*Pattern for export timeline  file.*)
		TimeStampPattern : STRING[50] := '%Y-%m-%d %H:%M:%S'; (*Time stamp pattern in exported file.*)
		DecimalDigits : UINT := 2; (*Specifies how many decimal positions are saved*)
		ColumnSeparator : STRING[1] := ','; (*Delimiter used to split up PVs in the .csv file*)
		DecimalMark : STRING[1] := '.'; (*Character to be used for the decimal separator*)
	END_STRUCT;
	MpAssetIntShiftParType : 	STRUCT 
		Name : STRING[20]; (*Shift name*)
		TotalTime : MpAssetIntTimeSlotType; (*Total time of one shift*)
		ScheduledDowntime : ARRAY[0..9]OF MpAssetIntScheduledDowntimeType; (*Scheduled downtime in one shift*)
	END_STRUCT;
	MpAssetIntTimeSlotType : 	STRUCT 
		Start : TIME_OF_DAY; (*Start time.*)
		End : TIME_OF_DAY; (*End time*)
	END_STRUCT;
	MpAssetIntScheduledDowntimeType : 	STRUCT 
		Reason : STRING[50]; (*Downtime reason*)
		Start : TIME_OF_DAY; (*Start time.*)
		End : TIME_OF_DAY; (*End time*)
	END_STRUCT;
END_TYPE

(*Parameter type*)

TYPE
	MpAssetIntParType : 	STRUCT 
		NominalProductionRate : REAL := 0.0; (*Nominal production rate [products / h]*)
		Job : STRING[20] := 'Job1'; (*Currently active production job*)
		CurrentUser : STRING[50]; (*Currently logged in user*)
		AdditionalData : STRING[255]; (*Additional data to be logged*)
	END_STRUCT;
END_TYPE

(*UI type*)

TYPE
	MpAssetIntUITrendType : 	STRUCT 
		SampleData : ARRAY[0..365]OF REAL; (*FB->VC:Sample data for trend data*)
		SampleRate : UDINT; (*FB->VC:Sample rate datapoint for trend data*)
		SampleCount : UDINT; (*FB->VC:Sample count datapoint for trend data*)
		SampleDateTime : DATE_AND_TIME; (*FB->VC:Sample DataTime datapoint for trend data*)
		MinValue : REAL; (*FB->VC:Min.value datapoint for trend data*)
		MaxValue : REAL; (*FB->VC:Max.value datapoint for trend data*)
		HideCurve : INT; (*FB->VC:Hide the curve if set to 1, status datapoint for trend curve*)
		TimeZoom : REAL; (*FB->VC:Zoom datapoint for trend time scale.*)
		TimeScroll : REAL; (*FB->VC:Scoll datapoint for trend time scale.*)
	END_STRUCT;
	MpAssetIntUIShiftListType : 	STRUCT 
		ShiftNames : ARRAY[0..5]OF STRING[20]; (*FB->VC: Shift names, *)
		SelectedIndex : UINT; (*VC->FB: Selection index for ShiftList.*)
		MaxSelection : USINT;
	END_STRUCT;
	MpAssetIntTrendUIConnectType : 	STRUCT 
		Status : MpAssetIntUIStatusEnum; (*Status of UI function block*)
		ScheduledDowntimeRate : MpAssetIntUITrendType; (*Trend for scheduled downtime rate*)
		UnscheduledDowntimeRate : MpAssetIntUITrendType; (*Trend for unscheduled downtime rate*)
		NominalProductionRate : MpAssetIntUITrendType; (*Trend for nominal production rate*)
		BadPieceRate : MpAssetIntUITrendType; (*Trend for bad piece rate*)
		ShiftList : MpAssetIntUIShiftListType; (*Determine which shift in the day is shown in the trend*)
		Filter : MpAssetIntUIFilterType; (*Output filter.*)
	END_STRUCT;
	MpAssetIntUITimelineOutputType : 	STRUCT 
		Display : ARRAY[0..19]OF MpAssetIntUITimelineLineType; (*States display*)
		RangeStart : REAL; (*Displayed range: Start %*)
		RangeEnd : REAL; (*Displayed range: End %*)
		PageUp : BOOL; (*Command: Page Up (Scroll Up)*)
		StepUp : BOOL; (*Command: Line Up (Scroll Up)*)
		StepDown : BOOL; (*Command: Line Down (Scroll Down)*)
		PageDown : BOOL; (*Command: Page Down (Scroll Down)*)
	END_STRUCT;
	MpAssetIntUITimelineLineType : 	STRUCT 
		StartTime : DATE_AND_TIME; (*FB->VC:Start time of this state*)
		ShiftName : STRING[20]; (*FB->VC:Shift name*)
		JobName : STRING[20]; (*FB->VC:Job name*)
		ProductionState : MpAssetIntUIProductionStateEnum; (*FB->VC:Production state*)
		Reason : STRING[50]; (*FB->VC:Reason of this state*)
		Duration : MpAssetIntTimeType; (*FB->VC:Duration of this state*)
		DurationBar : MpAssetIntUITimeBargraphType; (*FB->VC:Duration of this state in a graphic way*)
	END_STRUCT;
	MpAssetIntUITimeBargraphType : 	STRUCT 
		Duration : UDINT; (*FB->VC:EndValue(lenth) of the scale*)
		Color : UDINT; (*FB->VC:ColorDatapoint of the scale*)
	END_STRUCT;
	MpAssetIntTimelineUISetupType : 	STRUCT 
		TimelineListSize : UINT := 10; (*Output list size*)
		ScrollWindow : USINT := 0; (*Scroll Window (overlap for PageUp/Down)*)
	END_STRUCT;
	MpAssetIntTimelineUIConnectType : 	STRUCT 
		Status : MpAssetIntUIStatusEnum; (*Status of UI function block*)
		Output : MpAssetIntUITimelineOutputType; (*Output information.*)
		Filter : MpAssetIntUIFilterType; (*Output filter.*)
	END_STRUCT;
	MpAssetIntTimeType : 	STRUCT 
		Hours : UDINT; (*Numbers of hours*)
		Minutes : USINT; (*Numbers of minutes within an hour*)
		Seconds : USINT; (*Numbers of seconds within a minute*)
	END_STRUCT;
	MpAssetIntShiftListUIConnectType : 	STRUCT 
		Status : MpAssetIntUIStatusEnum; (*Status of UI function block*)
		Output : MpAssetIntUIShiftListOutputType; (*Output information.*)
		Filter : MpAssetIntUIFilterType; (*Output filter.*)
	END_STRUCT;
	MpAssetIntUIShiftListOutputType : 	STRUCT 
		StartTime : ARRAY[0..19]OF DATE_AND_TIME; (*Start time list*)
		EndTime : ARRAY[0..19]OF DATE_AND_TIME; (*End time list*)
		ShiftName : ARRAY[0..19]OF STRING[20]; (*Shift ID list*)
		CurrentUser : ARRAY[0..19]OF STRING[50]; (*Currently active user*)
		AdditionalData : ARRAY[0..19]OF STRING[255]; (*Additional data information*)
		TargetPieces : ARRAY[0..19]OF UDINT; (*Target pieces list*)
		TotalPieces : ARRAY[0..19]OF UDINT; (*Total pieces list*)
		GoodPieces : ARRAY[0..19]OF UDINT; (*Good pieces list*)
		RejectPieces : ARRAY[0..19]OF UDINT; (*Reject pieces list*)
		BadPieceRate : ARRAY[0..19]OF REAL; (*bad piece rate list*)
		TotalTime : ARRAY[0..19]OF MpAssetIntTimeType; (*Total time list*)
		ScheduledDowntime : ARRAY[0..19]OF MpAssetIntTimeType; (*Scheduled Downtime list*)
		UnscheduledDowntime : ARRAY[0..19]OF MpAssetIntTimeType; (*Unscheduled Downtime list*)
		Uptime : ARRAY[0..19]OF MpAssetIntTimeType; (*Uptime list*)
		GoodProductionTime : ARRAY[0..19]OF MpAssetIntTimeType; (*Good production time list*)
		NominalProductionTime : ARRAY[0..19]OF MpAssetIntTimeType; (*nominal production time list*)
		NominalProductionRate : ARRAY[0..19]OF REAL; (*nominal production rate list*)
		ShiftProductionRate : ARRAY[0..19]OF REAL; (*Shift production rate list*)
		ScheduledDowntimeRate : ARRAY[0..19]OF REAL; (*scheduled downtime rate list*)
		UnscheduledDowntimeRate : ARRAY[0..19]OF REAL; (*unscheduled downtime rate list*)
		ProductionRate : ARRAY[0..19]OF REAL; (*current production rate list*)
		RangeStart : REAL; (*Displayed range: Start %*)
		RangeEnd : REAL; (*Displayed range: End %*)
		PageUp : BOOL; (*Command: Page Up (Scroll Up)*)
		StepUp : BOOL; (*Command: Line Up (Scroll Up)*)
		StepDown : BOOL; (*Command: Line Down (Scroll Down)*)
		PageDown : BOOL; (*Command: Page Down (Scroll Down)*)
		IdealProductionRate : ARRAY[0..19]OF REAL; (*ideal production rate list*)
		JobName : ARRAY[0..19]OF STRING[20]; (*Job name list*)
	END_STRUCT;
	MpAssetIntUIShiftListJobType : 	STRUCT  (*Jobs within one shift*)
		Name : ARRAY[0..9]OF STRING[20]; (*Name of the job*)
	END_STRUCT;
	MpAssetIntShiftListUISetupType : 	STRUCT 
		OutputListSize : UINT := 10; (*Output list size*)
		ScrollWindow : USINT := 0; (*Scroll Window (overlap for PageUp/Down)*)
	END_STRUCT;
	MpAssetIntJobListUIConnectType : 	STRUCT 
		Status : MpAssetIntUIStatusEnum; (*Status of UI function block*)
		Output : MpAssetIntUIJobListOutputType; (*Output information.*)
		Filter : MpAssetIntUIFilterType; (*Output filter.*)
	END_STRUCT;
	MpAssetIntUIJobListOutputType : 	STRUCT 
		JobStartTime : ARRAY[0..19]OF DATE_AND_TIME; (*Job start time list*)
		JobEndTime : ARRAY[0..19]OF DATE_AND_TIME; (*Job end time list*)
		JobName : ARRAY[0..19]OF STRING[20]; (*Job name list*)
		CurrentUser : ARRAY[0..19]OF STRING[50]; (*Currently active user*)
		AdditionalData : ARRAY[0..19]OF STRING[255]; (*Additional data information*)
		TotalPieces : ARRAY[0..19]OF UDINT; (*Total pieces list*)
		GoodPieces : ARRAY[0..19]OF UDINT; (*Good pieces list*)
		RejectPieces : ARRAY[0..19]OF UDINT; (*Reject pieces list*)
		BadPieceRate : ARRAY[0..19]OF REAL; (*bad piece rate list*)
		TotalTime : ARRAY[0..19]OF MpAssetIntTimeType; (*Total time list*)
		ScheduledDowntime : ARRAY[0..19]OF MpAssetIntTimeType; (*Scheduled Downtime list*)
		UnscheduledDowntime : ARRAY[0..19]OF MpAssetIntTimeType; (*Unscheduled Downtime list*)
		Uptime : ARRAY[0..19]OF MpAssetIntTimeType; (*Uptime list*)
		GoodProductionTime : ARRAY[0..19]OF MpAssetIntTimeType; (*Good production time list*)
		NominalProductionTime : ARRAY[0..19]OF MpAssetIntTimeType; (*nominal production time list*)
		NominalProductionRate : ARRAY[0..19]OF REAL; (*nominal production rate list*)
		ScheduledDowntimeRate : ARRAY[0..19]OF REAL; (*scheduled downtime rate list*)
		UnscheduledDowntimeRate : ARRAY[0..19]OF REAL; (*unscheduled downtime rate list*)
		ProductionRate : ARRAY[0..19]OF REAL; (*current production rate list*)
		RangeStart : REAL; (*Displayed range: Start %*)
		RangeEnd : REAL; (*Displayed range: End %*)
		PageUp : BOOL; (*Command: Page Up (Scroll Up)*)
		StepUp : BOOL; (*Command: Line Up (Scroll Up)*)
		StepDown : BOOL; (*Command: Line Down (Scroll Down)*)
		PageDown : BOOL; (*Command: Page Down (Scroll Down)*)
		ShiftName : ARRAY[0..19]OF STRING[20]; (*Shift ID list*)
	END_STRUCT;
	MpAssetIntJobListUISetupType : 	STRUCT 
		OutputListSize : UINT := 10; (*Output list size*)
		ScrollWindow : USINT := 0; (*Scroll Window (overlap for PageUp/Down)*)
	END_STRUCT;
	MpAssetIntUIProductionStateEnum : 
		(
		mpASSETINT_STATE_NO_SHIFT_ACTIVE := 0, (*Inactive state*)
		mpASSETINT_STATE_UPTIME := 1, (*Uptime state*)
		mpASSETINT_STATE_SCHDL_DOWNTIME := 2, (*Scheduled downtime state*)
		mpASSETINT_STATE_UNSCH_DOWNTIME := 3 (*Unscheduled downtime state*)
		);
	MpAssetIntUICurrDTFilterType : 	STRUCT 
		Enable : BOOL; (*Enable Filter*)
		DateTime : DATE_AND_TIME; (*Date and time of filter*)
	END_STRUCT;
	MpAssetIntUISetDTFilterType : 	STRUCT 
		Enable : BOOL; (*Enable Filter*)
		Year : UINT; (*Date&Time: Year*)
		Month : USINT; (*Date&Time: Month*)
		Day : USINT; (*Date&Time: Day*)
		Hour : USINT; (*Date&Time: Hour*)
		Minute : USINT; (*Date&Time: Minute*)
	END_STRUCT;
	MpAssetIntUIFilterDialogType : 	STRUCT 
		LayerStatus : UINT;
		From : MpAssetIntUISetDTFilterType; (*Display entries from given date&time*)
		Until : MpAssetIntUISetDTFilterType; (*Display entries until given date&time*)
		Confirm : BOOL;
		Cancel : BOOL;
	END_STRUCT;
	MpAssetIntUIFilterType : 	STRUCT 
		ShowDialog : BOOL;
		Dialog : MpAssetIntUIFilterDialogType; (*Dialog-data to change filter-settings*)
		Current : MpAssetIntUICurrentFilterType; (*Currently active filter settings*)
		DefaultLayerStatus : UINT;
	END_STRUCT;
	MpAssetIntUICurrentFilterType : 	STRUCT 
		From : MpAssetIntUICurrDTFilterType; (*Starting time of current filter*)
		Until : MpAssetIntUICurrDTFilterType; (*End time of current filter*)
	END_STRUCT;
END_TYPE

(*Info type*)

TYPE
	MpAssetIntJobStatisticsType : 	STRUCT 
		JobName : STRING[20]; (*Job name.*)
		TotalTime : MpAssetIntTimeType; (*Total time since this job started*)
		ScheduledDowntime : MpAssetIntTimeType; (*Scheduled downtime since this job started*)
		UnscheduledDowntime : MpAssetIntTimeType; (*Unsheduled downtime since this job started*)
		Uptime : MpAssetIntTimeType; (*Uptime since this job started*)
		NominalProductionTime : MpAssetIntTimeType; (*Time of production at nominal speed since this job started*)
		GoodProductionTime : MpAssetIntTimeType; (*Time of good production since this job started*)
		ScheduledDowntimeRate : REAL; (*Percentage of scheduled downtime [%] since this job started*)
		UnscheduledDowntimeRate : REAL; (*Percentage of unscheduled downtime [%] since this job started*)
		NominalProductionTimeRate : REAL; (*Percentage of nominal speed running time[%] since this job started*)
		TotalPieces : UDINT; (*Counter for total products since this job started*)
		GoodPieces : UDINT; (*Counter for good products since this job started*)
		RejectPieces : UDINT; (*Counter for reject products since this job started*)
		BadPieceRate : REAL; (*Percentage of bad products [%] since this job started*)
		CurrentProductionRate : REAL; (*Production rate since this job started [products / h]*)
		CurrentUser : STRING[50]; (*Currently active user*)
		AdditionalData : STRING[255]; (*Additional data information*)
	END_STRUCT;
	MpAssetIntShiftStatisticsType : 	STRUCT 
		ShiftName : STRING[20]; (*Shift name.*)
		TotalTime : MpAssetIntTimeType; (*Total time since this shift started*)
		ScheduledDowntime : MpAssetIntTimeType; (*Scheduled downtime since this shift started*)
		UnscheduledDowntime : MpAssetIntTimeType; (*Unsheduled downtime since this shift started*)
		Uptime : MpAssetIntTimeType; (*Uptime since this shift started*)
		GoodProductionTime : MpAssetIntTimeType; (*Time of good production since this shift started*)
		NominalProductionTime : MpAssetIntTimeType; (*Time of production at nominal speed since this shift started*)
		ScheduledDowntimeRate : REAL; (*Percentage of scheduled downtime [%] since this shift started*)
		UnscheduledDowntimeRate : REAL; (*Percentage of unscheduled downtime [%] since this shift started*)
		NominalProductionTimeRate : REAL; (*Percentage of nominal speed running time[%] since this shift started*)
		TargetPieces : UDINT; (*Counter for target products since this shift started*)
		TotalPieces : UDINT; (*Counter for total products since this shift started*)
		GoodPieces : UDINT; (*Counter for good products since this shift started*)
		RejectPieces : UDINT; (*Counter for reject products since this shift started*)
		BadPieceRate : REAL; (*Percentage of bad products [%] since this shift started*)
		CurrentProductionRate : REAL; (*Production rate since this shift started [products / h]*)
		CurrentUser : STRING[50]; (*Currently active user*)
		AdditionalData : STRING[255]; (*Additional data information*)
		IdealProductionRate : REAL; (*Ideal production rate*)
	END_STRUCT;
	MpAssetIntCoreInfoType : 	STRUCT 
		ShiftStatistics : MpAssetIntShiftStatisticsType; (*Shift statistics*)
		JobStatistics : MpAssetIntJobStatisticsType; (*Job statistics*)
		Diag : MpAssetIntDiagType; (*Additional diagnostic information*)
	END_STRUCT;
	MpAssetIntInfoType : 	STRUCT 
		Diag : MpAssetIntDiagType; (*Additional diagnostic information*)
	END_STRUCT;
	MpAssetIntDiagType : 	STRUCT 
		StatusID : MpAssetIntStatusIDType; (*Segmented StatusID output*)
	END_STRUCT;
	MpAssetIntStatusIDType : 	STRUCT 
		ID : MpAssetIntErrorEnum; (*StatusID as enumerator*)
		Severity : MpComSeveritiesEnum; (*Severity of the error*)
		Code : UINT; (*Error code*)
	END_STRUCT;
END_TYPE

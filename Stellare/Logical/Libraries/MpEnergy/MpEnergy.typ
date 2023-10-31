
TYPE
	MpEnergyRegModeEnum : 
		(
		mpENERGY_REG_MODE_COLLECT := 0, (*The information from this module is actively considered for total calculation*)
		mpENERGY_REG_MODE_MONITOR_ONLY := 1 (*The information from this module not consodered for total calculation, only for analysis purpose*)
		);
	MpEnergyRegPowerUnitsEnum : 
		(
		mpENERGY_POWER_UNIT_KW := 0, (*Power values is in Kw*)
		mpENERGY_POWER_UNIT_W := 1 (*Power values is in W*)
		);
	MpEnergyRegEnergyUnitsEnum : 
		(
		mpENERGY_ENERGY_UNIT_KWH := 0, (*Energy values is in kWh (kiloWatt hours)*)
		mpENERGY_ENERGY_UNIT_WS := 1, (*Energy values is in Ws (Watt seconds)*)
		mpENERGY_ENERGY_UNIT_WH := 2 (*Energy values is in Wh (Watt hours)*)
		);
	MpEnergyInfoType : 	STRUCT 
		Diag : MpEnergyDiagType; (*Diagnostic structure for the function block*)
	END_STRUCT;
	MpEnergyCoreInfoType : 	STRUCT 
		TotalEnergy : MpEnergyEnergiesType; (* Total energy for all modules *)
		PeakActivePower : LREAL; (*Peak of active power [kW]*)
		PeakReactivePower : LREAL; (*Peak of reactive power [kW]*)
		PowerFactor : LREAL; (*Cos phi of the power*)
		RegisteredModules : UDINT; (*Number of registered modules*)
		TemporaryRecord : MpEnergyTemporaryRecordType; (*Output values related to interval time*)
		Diag : MpEnergyDiagType; (*Diagnostic structure for the function block*)
	END_STRUCT;
	MpEnergyTemporaryRecordType : 	STRUCT  (*Output values related to interval time*)
		CombinedActiveEnergy : LREAL; (* Total active energy for all modules [kWh]*)
		CombinedReactiveEnergy : LREAL; (* Total reactive energy for all modules [kWh]*)
		TotalEnergy : MpEnergyEnergiesType; (* Total energy for all modules *)
		PeakActivePower : LREAL; (*Peak of active power [kW]*)
		PeakReactivePower : LREAL; (*Peak of reactive power [kW]*)
		Duration : TIME; (*Time related to interval recorded [sec]*)
	END_STRUCT;
	MpEnergyRegPowerInfoType : 	STRUCT 
		TotalEnergy : MpEnergyEnergiesType; (* Total energy values of this device *)
		PowerFactor : LREAL; (*Cos phi of the power*)
		PeakActivePower : LREAL; (*Peak of active power [kW]*)
		PeakReactivePower : LREAL; (*Peak of reactive power [kW]*)
		Diag : MpEnergyDiagType; (*Diagnostic structure for the function block*)
	END_STRUCT;
	MpEnergyDiagType : 	STRUCT 
		StatusID : MpEnergyStatusIDType; (*StatusID diagnostic structure *)
	END_STRUCT;
	MpEnergyStatusIDType : 	STRUCT 
		ID : MpEnergyErrorEnum; (*Error code for mapp component*)
		Severity : MpComSeveritiesEnum; (*Describes the type of information supplied by the status ID (success, information, warning, error)*)
		Code : UINT; (*Code for the status ID. This error number can be used to search for additional information in the help system*)
	END_STRUCT;
	MpEnergyEnergiesType : 	STRUCT 
		ForwardActive : LREAL; (* Forward active energy [kWh] *)
		ForwardReactive : LREAL; (* Forward reactive energy [kWh] *)
		ReverseActive : LREAL; (* Reverse active energy [kWh] *)
		ReverseReactive : LREAL; (* Reverce reactive energy [kWh] *)
		Apparent : LREAL; (* Calculatedf apparent energy [kWh] *)
	END_STRUCT;
END_TYPE

(*MpEnergyCoreUI datatypes*)

TYPE
	MpEnergyCoreUISetupType : 	STRUCT 
		ModuleListSize : UINT := 20; (*Number of modules to be displayed on one page of the list in the HMI application*)
		ModuleScrollWindow : USINT := 0; (*Determines how many modules from the list are displayed in advance when scrolling up and down*)
	END_STRUCT;
	MpEnergyCoreUIConnectType : 	STRUCT 
		Status : MpEnergyCoreUIStatusEnum; (*Status of last operation*)
		ShowTemporaryRecord : BOOL; (*Switch between total and temporary recording*)
		ModuleList : MpEnergyCoreUIModuleListType; (*List of modules*)
		SelectedModule : MpEnergyCoreUISelectedModuleType; (*Details related to selected module*)
		OverallDetails : MpEnergyCoreUIOverallDetailsType; (*Overview of overall consumption*)
		OverallCharts : MpEnergyCoreUIOverallChartsType; (*Overview of overall energy and power values in chart format*)
	END_STRUCT;
	MpEnergyCoreUIStatusEnum : 
		(
		mpENERGY_CORE_UI_IDLE := 0,
		mpENERGY_CORE_UI_ACTIVE := 1,
		mpENERGY_CORE_UI_ERROR := 99
		);
	MpEnergyCoreUIModuleListType : 	STRUCT  (*List of modules*)
		SelectedIndex : UINT; (*FB->VC: Index of selected device in the list*)
		MaxSelection : UINT; (*Index of the entry currently selected in the list*)
		PageUp : BOOL; (*VC->FB: Jumps to the start of the current page and then scrolls up one page at a time *)
		PageDown : BOOL; (*VC->FB: Jumps to the end of the current page and then scrolls down one page at a time *)
		StepUp : BOOL; (*VC->FB: Selects the previous entry in the list*)
		StepDown : BOOL; (*VC->FB: Selects the next entry in the list*)
		RangeStart : REAL; (*VC->FB: Shows a bar indicating which part of the list is currently being displayed-Start [%]*)
		RangeEnd : REAL; (*FB->VC: Shows a bar indicating which part of the list is currently being displayed-End [%]*)
		Names : ARRAY[0..19]OF STRING[100]; (*FB->VC: List of modules: device name*)
		ForwardActiveEnergy : ARRAY[0..19]OF LREAL; (*FB->VC: Forward active energy [kWh] *)
		ReverseActiveEnergy : ARRAY[0..19]OF LREAL; (*FB->VC: Reverse active energy [kWh] *)
	END_STRUCT;
	MpEnergyCoreUISelectedModuleType : 	STRUCT  (*Details related to selected module*)
		CombinedEnergyChart : MpEnergyCoreUIChartType;
		ForwardEnergyChart : MpEnergyCoreUIChartType;
		ReverseEnergyChart : MpEnergyCoreUIChartType;
		Details : MpEnergyCoreUIDetailsType;
	END_STRUCT;
	MpEnergyCoreUIDetailsType : 	STRUCT 
		Energy : MpEnergyEnergiesType; (*All energy types*)
		ActivePower : LREAL; (*FB->VC: Active Power [kW]*)
		ReactivePower : LREAL; (*FB->VC: Reactive Power [kW]*)
		PeakActivePower : LREAL; (*FB->VC: Peak of active power [kW]*)
		PeakReactivePower : LREAL; (*FB->VC: Peak of reactive power [kW]*)
		PowerFactor : LREAL; (*FB->VC: Cos phi of power*)
		ShowLayer : BOOL; (*VC->FB: Show Edit-dialog*)
		LayerStatus : UINT; (*FB->VC: Status-DP for dialog layer*)
	END_STRUCT;
	MpEnergyCoreUIOverallDetailsType : 	STRUCT  (*Overview of overall consumption*)
		Energy : MpEnergyEnergiesType; (*All energy types*)
		ActivePower : LREAL; (*FB->VC: Active Power [kW]*)
		ReactivePower : LREAL; (*FB->VC: Reactive Power [kW]*)
		PeakActivePower : LREAL; (*FB->VC: Peak of active power [kW]*)
		PowerFactor : LREAL; (*FB->VC: Cos phi of power*)
		PeakReactivePower : LREAL; (*FB->VC: Peak of reactive power [kW]*)
	END_STRUCT;
	MpEnergyCoreUIOverallChartsType : 	STRUCT  (*Overview of overall energy and power values in chart format*)
		CombinedEnergyChart : MpEnergyCoreUIChartType;
		ForwardEnergyChart : MpEnergyCoreUIChartType;
		ReverseEnergyChart : MpEnergyCoreUIChartType;
		ForwardActiveEnergyByModuleChart : MpEnergyCoreUIByModuleChartType;
	END_STRUCT;
	MpEnergyCoreUIChartType : 	STRUCT 
		Data : ARRAY[0..4]OF LREAL; (*FB->VC: Energy types. 0: Forward active; 1: Forward reactive; 2: Reverse active; 3: Reverse reactive; 4: Apparent*)
		ShowLayer : BOOL; (*VC->FB: Show Edit-dialog*)
		LayerStatus : UINT; (*FB->VC: Status-DP for dialog layer*)
	END_STRUCT;
	MpEnergyCoreUIByModuleChartType : 	STRUCT 
		Data : ARRAY[0..19]OF LREAL; (*FB->VC: Energy by module*)
		ModuleNames : ARRAY[0..19]OF STRING[100]; (*FB->VC: List of module names*)
		ShowLayer : BOOL; (*VC->FB: Show Edit-dialog*)
		LayerStatus : UINT; (*FB->VC: Status-DP for dialog layer*)
	END_STRUCT;
END_TYPE

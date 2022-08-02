
FUNCTION_BLOCK MpEnergyCore (*mapp component for Energy consumption handling*) (* $GROUP=mapp Services,$CAT=Energy monitoring,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpEnergy.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets  function block errors*) (* *) (*#PAR#;*)
		TemporaryRecord : BOOL; (*Activate Energy monitoring for a limited interval: the interval is defined by rising edge of this command and falling edge of same pin*) (* *) (*#CMD#OPT#; *)
		DeviceName : REFERENCE TO STRING[50]; (*Device name where the File that should be Imported/Exported is located*) (* *) (*#CMD#OPT#;*)
		Export : BOOL; (*Export the current data*) (* *) (*#CMD#OPT#;*)
		Reset : BOOL; (*Reset counters about energy and power*) (* *) (*#CMD#OPT#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly *) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block *) (* *) (*#PAR#; *)
		CombinedActiveEnergy : LREAL; (* Total active energy for all devices [kWh]*) (* *) (*#CYC#;*)
		CombinedReactiveEnergy : LREAL; (* Total reactive energy for all devices [kWh]*) (* *) (*#CYC#;*)
		ActivePower : LREAL; (*Current active power [kW]*) (* *) (*#CYC#;*)
		ReactivePower : LREAL; (*Current reactive power [kW]*) (* *) (*#CYC#;*)
		CommandBusy : BOOL; (*Function block currently executing command*) (* *) (*#CMD#OPT#;*)
		TemporaryRecording : BOOL; (*Energy monitoring active*) (* *) (*#CMD#OPT#; *)
		ExportDone : BOOL; (*File exported correclty*) (* *) (*#CMD#OPT#;*)
		ResetDone : BOOL; (*Reset counters executed correclty*) (* *) (*#CMD#OPT#;*)
		Info : MpEnergyCoreInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpEnergyRegPower (*mapp component to add power consumption info from external device*) (* $GROUP=mapp Services,$CAT=Energy monitoring,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpEnergy.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets  function block errors*) (* *) (*#PAR#;*)
		ModuleName : REFERENCE TO STRING[100]; (*Name of the module*) (* *) (*#PAR#;*)
		Mode : MpEnergyRegModeEnum; (*Recording mode: it specifies if the input should be considered for the total counter of just for analysis*) (* *) (*#PAR#;*)
		Units : MpEnergyRegPowerUnitsEnum; (*Measurement units for inputs*) (* *) (*#PAR#;*)
		ActivePower : LREAL; (*Active power input*) (* *) (*#CYC#; *)
		ReactivePower : LREAL; (*Reactive power input*) (* *) (*#CYC#; *)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly *) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block *) (* *) (*#PAR#; *)
		Info : MpEnergyRegPowerInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpEnergyRegEnergy (*mapp component to add energy consumption info from external device*) (* $GROUP=mapp Services,$CAT=Energy monitoring,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpEnergy.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets  function block errors*) (* *) (*#PAR#;*)
		ModuleName : REFERENCE TO STRING[100]; (*Name of the module*) (* *) (*#PAR#;*)
		Mode : MpEnergyRegModeEnum; (*Recording mode: it specifies if the input should be considered for the total counter of just for analysis*) (* *) (*#PAR#;*)
		Units : MpEnergyRegEnergyUnitsEnum; (*Measurement units for inputs*) (* *) (*#PAR#;*)
		ForwardActiveEnergy : LREAL; (*Forward active energy*) (* *) (*#CYC#;*)
		ForwardReactiveEnergy : LREAL; (*Forward reactive energy*) (* *) (*#CYC#OPT#;*)
		ReverseActiveEnergy : LREAL; (*Reverse active energy*) (* *) (*#CYC#;*)
		ReverseReactiveEnergy : LREAL; (*Reverse reactive energy*) (* *) (*#CYC#OPT#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly *) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block *) (* *) (*#PAR#; *)
		Info : MpEnergyRegPowerInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpEnergyCoreUI (*mapp component for Energy consumption analysis*) (* $GROUP=mapp Services,$CAT=Energy monitoring,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpEnergy.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets  function block errors*) (* *) (*#PAR#;*)
		UISetup : MpEnergyCoreUISetupType; (*Used to configure the elements connected to the HMI application*) (* *) (*#PAR#;*)
		UIConnect : REFERENCE TO MpEnergyCoreUIConnectType; (*This structure contains the parameters needed for the connection to the HMI application*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly *) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block *) (* *) (*#PAR#; *)
		Info : MpEnergyInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

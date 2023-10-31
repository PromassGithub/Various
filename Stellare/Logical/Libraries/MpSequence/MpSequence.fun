
FUNCTION_BLOCK MpSequenceCore (*Machine sequence execution*) (* $GROUP=mapp Services,$CAT=Programmable Machine Sequence,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpSequence.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Connection to mapp*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets  function block errors*) (* *) (*#PAR#;*)
		Parameters : REFERENCE TO MpSequenceCoreParType; (*Function block parameters*) (* *) (*#PAR#; *)
		Update : BOOL; (*Applies changed parameters*) (* *) (*#PAR#; *)
		Mode : MpSequenceModeEnum; (*Sequence execution mode*) (* *) (*#CMD#;*)
		Start : BOOL; (*Start command*) (* *) (*#CMD#; *)
		Stop : BOOL; (*Stop command*) (* *) (*#CMD#; *)
		Suspend : BOOL; (*Suspend command*) (* *) (*#CMD#OPT#;*)
		Resume : BOOL; (*Resume command*) (* *) (*#CMD#OPT#;*)
		Import : BOOL; (*Import a sequence*) (* *) (*#CMD#;*)
		Export : BOOL; (*Export a sequence*) (* *) (*#CMD#;*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Indicates whether the function block is active*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates that the function block is in an error state or a command was not executed correctly *) (* *) (*#PAR#;*)
		StatusID : DINT; (*Status information about the function block *) (* *) (*#PAR#; *)
		UpdateDone : BOOL; (*Parameter update completed*) (* *) (*#PAR#; *)
		Running : BOOL; (*A sequence is currently running*) (* *) (*#CMD#; *)
		Suspended : BOOL; (*Sequence execution is suspended*) (* *) (*#CMD#OPT#; *)
		Stopped : BOOL; (*Sequence execution is stopped*) (* *) (*#CMD#; *)
		ImportDone : BOOL; (*Import of a sequence has been done*) (* *) (*#CMD#; *)
		ExportDone : BOOL; (*Export of a sequence has been done*) (* *) (*#CMD#; *)
		Info : MpSequenceCoreInfoType; (*Additional information about the component*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpSequenceCommandConfig (*add-on function block that allows to load and save command configurations *) (* $GROUP=mapp Services,$CAT=Programmable Machine Sequence,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpSequence.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		Name : REFERENCE TO STRING[255]; (*Unique Identifier of the command*) (* *) (*#PAR#;*)
		Configuration : REFERENCE TO MpSequenceCommandConfigType; (*Configuration parameters (mapp standard interface)*) (* *) (*#PAR#;*)
		Load : BOOL; (*Read configuration from AR into the config structure*) (* *) (*#CMD#*)
		Save : BOOL; (*Write configuration from config structure to AR*) (* *) (*#CMD#*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		CommandBusy : BOOL; (*Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Command has finished and was successful.*) (* *) (*#CMD#*)
		Info : MpSequenceInfoType; (*Additional information*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpSequenceActuatorConfig (*add-on function block that allows to load and save actuator configurations *) (* $GROUP=mapp Services,$CAT=Programmable Machine Sequence,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpSequence.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		Name : REFERENCE TO STRING[255]; (*Unique Identifier of the command*) (* *) (*#PAR#;*)
		Configuration : REFERENCE TO MpSequenceActuatorConfigType; (*Configuration parameters (mapp standard interface)*) (* *) (*#PAR#;*)
		Load : BOOL; (*Read configuration from AR into the config structure*) (* *) (*#CMD#*)
		Save : BOOL; (*Write configuration from config structure to AR*) (* *) (*#CMD#*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		CommandBusy : BOOL; (*Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Command has finished and was successful.*) (* *) (*#CMD#*)
		Info : MpSequenceInfoType; (*Additional information*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpSequenceAxisConfig (*add-on function block that allows to load and save actuator configurations *) (* $GROUP=mapp Services,$CAT=Programmable Machine Sequence,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpSequence.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		Name : REFERENCE TO STRING[255]; (*Unique Identifier of the Axis*) (* *) (*#PAR#;*)
		Configuration : REFERENCE TO MpSequenceAxisConfigType; (*Configuration parameters (mapp standard interface)*) (* *) (*#PAR#;*)
		Load : BOOL; (*Read configuration from AR into the config structure*) (* *) (*#CMD#*)
		Save : BOOL; (*Write configuration from config structure to AR*) (* *) (*#CMD#*)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		CommandBusy : BOOL; (*Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Command has finished and was successful.*) (* *) (*#CMD#*)
		Info : MpSequenceInfoType; (*Additional information*) (* *) (*#CMD#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

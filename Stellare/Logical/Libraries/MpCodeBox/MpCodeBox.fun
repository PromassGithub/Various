
FUNCTION_BLOCK MpCodeBoxCore (*mapp component which can execute/interpret free programmable code during runtime*) (* $GROUP=mapp Services,$CAT=Embedded Interpreter,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpCodeBox.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		Programs : MpCodeBoxCoreProgramsType; (*Function block parameters (mapp standard interface)*) (* *) (*#CMD#; *)
		Start : BOOL; (*Start Execution of programming (pos. edge)*) (* *) (*#CMD#; *)
		Stop : BOOL; (*Stop Execution of programming (pos. edge)*) (* *) (*#CMD#; *)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		Running : BOOL; (*Program is running*) (* *) (*#CMD#; *)
		CommandBusy : BOOL; (*Optional: Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		Info : MpCodeBoxCoreInfoType; (*Provide any further useful information as function block output.*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpCodeBoxProgramControl (*Control execution of a single program in a interpreter-FB*) (* $GROUP=mapp Services,$CAT=Embedded Interpreter,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpCodeBox.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		Start : BOOL; (*Start the given program*) (* *) (*#CMD#; *)
		Suspend : BOOL; (*Suspend the given program*) (* *) (*#CMD#; *)
		Reload : BOOL; (*Reload the given program*) (* *) (*#CMD#; *)
		Resume : BOOL; (*Resume the given program*) (* *) (*#CMD#; *)
		Stop : BOOL; (*Stop the given program*) (* *) (*#CMD#; *)
		Name : REFERENCE TO STRING[255]; (*Program to start*) (* *) (*#PAR#; *)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		CommandBusy : BOOL; (*Optional: Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Optional: Command has finished and was successful. Can be used as general answer to the Command inputs.*) (* *) (*#CMD#; *)
		Info : MpCodeBoxInfoType; (*Provide any further useful information as function block output.*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : MpComInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MpCodeBoxManager (*Import / Export programs / macros*) (* $GROUP=mapp Services,$CAT=Embedded Interpreter,$GROUPICON=Icon_mapp.png,$CATICON=Icon_MpCodeBox.png *)
	VAR_INPUT
		MpLink : REFERENCE TO MpComIdentType; (*Incoming communication handle (mapp standard interface)*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block (mapp standard interface)*) (* *) (*#PAR#;*)
		ErrorReset : BOOL; (*Resets all function block errors (mapp standard interface)*) (* *) (*#PAR#;*)
		ItemType : MpCodeBoxItemEnum; (*Type of program to export / import (program, action, condition)*) (* *) (*#PAR#;*)
		ItemName : REFERENCE TO STRING[255]; (*Name of program to export / import*) (* *) (*#PAR#; *)
		DeviceName : REFERENCE TO STRING[50]; (*Name of device where file is stored*) (* *) (*#PAR#; *)
		FileName : REFERENCE TO STRING[255]; (*Name of file to export / import*) (* *) (*#PAR#; *)
		Overwrite : BOOL; (*Overwrite existing programs / macros when writing / importing*) (* *) (*#PAR#OPT#; *)
		Export : BOOL; (*Export program / macro*) (* *) (*#CMD#; *)
		Import : BOOL; (*Import program / macro*) (* *) (*#CMD#; *)
		Delete : BOOL; (*Delete program*) (* *) (*#CMD#; *)
	END_VAR
	VAR_OUTPUT
		Active : BOOL; (*Function block is active (mapp standard interface)*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error (mapp standard interface)*) (* *) (*#PAR#;*)
		StatusID : DINT; (*Error/Status information (mapp standard interface)*) (* *) (*#PAR#; *)
		CommandBusy : BOOL; (*Optional: Function block is busy processing a command.*) (* *) (*#CMD#OPT#;*)
		CommandDone : BOOL; (*Optional: Command has finished and was successful. Can be used as general answer to the Command inputs.*) (* *) (*#CMD#; *)
		Info : MpCodeBoxInfoType; (*Provide any further useful information as function block output.*) (* *) (*#CMD#; *)
	END_VAR
	VAR
		Internal : MpCodeBoxManagerInternalType;
	END_VAR
END_FUNCTION_BLOCK

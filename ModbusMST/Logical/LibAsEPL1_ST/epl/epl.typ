(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: epl
 * File: epl.typ
 * Author: Bernecker + Rainer

 * Created: August 04, 2009
 ********************************************************************
 * Local data types of program epl
 ********************************************************************)

TYPE
	epl_typ : 	STRUCT  (*datatype for AsEPL Library*)
		cmd : eplCmd_typ; (*variable with commands*)
		para : eplPara_typ; (*variable with parameters*)
		fub : eplFUB_typ; (*variable with Function Blocks*)
		state : state_enum; (*variable with actual state*)
	END_STRUCT;
	Acyclic_variable : 	STRUCT 
		Index : UINT;
		Subindex : USINT;
		Lenght : USINT;
		Node_ID : USINT;
		Read_Data : ARRAY[0..39]OF USINT;
		Data_To_Be_Send : ARRAY[0..39]OF USINT;
	END_STRUCT;
	eplCmd_typ : 	STRUCT  (*datatype with commands*)
		readNode : BOOL; (*command to read the Node Number of the Powerlink interface*)
		readThresholdCnt : BOOL; (*command to read an Object Entry*)
		writeX2X : BOOL; (*command to write an Object Entry*)
	END_STRUCT;
	eplPara_typ : 	STRUCT  (*datatype with parameters*)
		nodeNr : USINT; (*Node number of the Powerling interface*)
		readData : UDINT; (*Read Data*)
		writeData : UDINT; (*Data to be written*)
		x2xCycle : UDINT; (*X2X Cycle time*)
	END_STRUCT;
	eplFUB_typ : 	STRUCT  (*datatype with Function Blocks*)
		EplGetLocalNodeID_0 : EplGetLocalNodeID; (*FUB to get Node Number of local Powerlink interface*)
		EplSDOWrite_0 : EplSDOWrite; (*FUB to write a node's object entries*)
		EplSDORead_0 : EplSDORead; (*FUB to read a node's object entries*)
		EplReadX2X : EplSDORead; (*FUB to read the X2X cycle time of the BusController*)
	END_STRUCT;
	state_enum : 
		( (*enumerators for the state in the task*)
		EPL_WAIT, (*state to wait for any commands*)
		EPL_READ_NODE, (*state to read powerlink node number*)
		EPL_READ_OE, (*state to read object entry*)
		EPL_WRITE_OE, (*state to write object entry*)
		EPL_ERROR (*state when an error occured*)
		);
END_TYPE

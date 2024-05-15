(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: epl
 * File: eplCyclic.st
 * Author: Bernecker + Rainer
 * Created: August 04, 2009
 ********************************************************************
 * Implementation of program epl
 ********************************************************************)

PROGRAM _CYCLIC

	CASE epl.state OF 	
	
		EPL_WAIT:  (*state to wait for user Commands*)
		
			IF (epl.cmd.readNode = 1) THEN  (*check for command to read node number*)
   				epl.cmd.readNode := 0;  (*reset command*)
				epl.state := EPL_READ_NODE;  (*jump to READ_NODE state*)
			
			ELSIF (epl.cmd.readThresholdCnt = 1) THEN  (*check for command to read object entry*)
   				epl.cmd.readThresholdCnt := 0;  (*reset command*)
				epl.state := EPL_READ_OE;  (*jump to READ_OE state*)
			
			ELSIF (epl.cmd.writeX2X = 1) THEN  (*check for command to write object entry*)
   				epl.cmd.writeX2X := 0;  (*reset command*)
				epl.state := EPL_WRITE_OE;  (*jump to WRITE_OE state*)
			END_IF
		
		
		EPL_READ_NODE:  (*state to read the local Powerlink node number*)

			epl.fub.EplGetLocalNodeID_0.enable := 1;  (*enable the FUB*)
			epl.fub.EplGetLocalNodeID_0.pDevice	:= ADR('IF3');  (*Device Name of Powerlink interface*)
  		
			IF epl.fub.EplGetLocalNodeID_0.status = 0 THEN  (*reading successful*)	
				epl.state := EPL_WAIT;
				epl.fub.EplGetLocalNodeID_0.enable := 0;  (*disable the FUB*)
				epl.para.nodeNr := epl.fub.EplGetLocalNodeID_0.nodeid;  (*copy node number on the variable*)				
			ELSIF epl.fub.EplGetLocalNodeID_0.status = ERR_FUB_BUSY THEN  (*creating not finished --> do again*)
				(*Busy*)
			ELSIF epl.fub.EplGetLocalNodeID_0.status = ERR_FUB_ENABLE_FALSE THEN  (*FUB is disabled*)
				(*Disabled*)				
   			ELSE  (*Go to error Step*)
				epl.state := EPL_ERROR;				
			END_IF


		EPL_READ_OE:  (*state to read an object entry*)

			epl.fub.EplSDORead_0.enable := 1;  (*enable the FUB*)
			epl.fub.EplSDORead_0.pDevice := ADR('IF3');  (*Device Name of Powerlink interface*)
  			epl.fub.EplSDORead_0.node := Acyclic.Node_ID;  (*Node Number of the Station to be read*)
			epl.fub.EplSDORead_0.index := Acyclic.Index;  (*Read Index 16#1C0B : CNLoss SoC*)
			epl.fub.EplSDORead_0.subindex := Acyclic.Subindex;  (*Subindex 2 that is the Threshold Counter*)
			epl.fub.EplSDORead_0.pData := ADR(Acyclic.Read_Data);  (*Pointer to the variable for the read Data*)
   			epl.fub.EplSDORead_0.datalen := Acyclic.Lenght;  (*Length of the Data to be read*)
			
			IF epl.fub.EplSDORead_0.status = 0 THEN  (*reading successful*)	
				epl.state := EPL_WAIT;
				epl.fub.EplSDORead_0.enable := 0;  (*disable the FUB*)			
			ELSIF epl.fub.EplSDORead_0.status = ERR_FUB_BUSY THEN  (*reading not finished --> do again*)
				(*Busy*)
			ELSIF epl.fub.EplSDORead_0.status = ERR_FUB_ENABLE_FALSE THEN  (*FUB is disabled*)
				(*Disabled*)				
   			ELSE  (*Go to error Step*)
				epl.state := EPL_ERROR;				
			END_IF


		EPL_WRITE_OE:  (*state to write an object entry*)
					
   			epl.para.writeData := 3000;  (*New cycle time of the X2X Bus*)
			
			epl.fub.EplSDOWrite_0.enable := 1;  (*enable the FUB*)
			epl.fub.EplSDOWrite_0.pDevice := ADR('IF3');  (*Device Name of Powerlink interface*)
  			epl.fub.EplSDOWrite_0.node := Acyclic.Node_ID;  (*Node Number of the Station to be read*)
			epl.fub.EplSDOWrite_0.index := Acyclic.Index;  (*Write index 16#20F0 : BC_Internal_Rec*)
			epl.fub.EplSDOWrite_0.subindex := Acyclic.Subindex;  (*Subindex 9 that is LED test*)
			epl.fub.EplSDOWrite_0.pData := ADR(Acyclic.Data_To_Be_Send);  (*pointer to the Datas to be written*)
   			epl.fub.EplSDOWrite_0.datalen := Acyclic.Lenght;  (*size of the Datas to be written*)			
			
			IF epl.fub.EplSDOWrite_0.status = 0 THEN  (*writing successful*)	
				epl.state := EPL_WAIT;
				epl.fub.EplSDOWrite_0.enable := 0;  (*disable the FUB*)			
			ELSIF epl.fub.EplSDOWrite_0.status = ERR_FUB_BUSY THEN  (*writing not finished --> do again*)
				(*Busy*)
			ELSIF epl.fub.EplSDOWrite_0.status = ERR_FUB_ENABLE_FALSE THEN  (*FUB is disabled*)
				(*Disabled*)				
   			ELSE  (*Go to error Step*)
				epl.state := EPL_ERROR;				
			END_IF


		EPL_ERROR:  (*State when an error occured*)
			(* Here some error Handling has to be implemented *)
	
	
	END_CASE;
	
	epl.fub.EplReadX2X.enable := 1;  (*enable the FUB*)	
	epl.fub.EplReadX2X.pDevice := ADR('IF3.ST4');  (*Device Name of Powerlink interface*)
	epl.fub.EplReadX2X.node := 4;  (*Node Number of the Station to be read*)
	epl.fub.EplReadX2X.index := 8192;  (*Read index 16#2000 : X2X_Config_REC*)
	epl.fub.EplReadX2X.subindex := 3;  (*Subindex 3 that is the X2X Cycle time*)
	epl.fub.EplReadX2X.pData := ADR(epl.para.x2xCycle);  (*pointer to the Datas to be written*)
	epl.fub.EplReadX2X.datalen := SIZEOF(epl.para.x2xCycle);  (*size of the Datas to be written*)			
	
	epl.fub.EplReadX2X();  (*Call the EplReadX2X FUB*)	
 	epl.fub.EplGetLocalNodeID_0();  (*Call the EplGetLocalNodeID_0 FUB*)
	epl.fub.EplSDORead_0();  (*Call the EplSDORead_0 FUB*)
	epl.fub.EplSDOWrite_0();  (*Call the EplSDOWrite_0 FUB*)
	
END_PROGRAM

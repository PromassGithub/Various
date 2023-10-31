PROGRAM _INIT
	
	//Enable FBs and set parameters
	MpSequenceCore_0.Enable := TRUE;
	MpSequenceCore_0.Import := TRUE;
	MpSequenceCore_0.Mode := mpSEQUENCE_MODE_SINGLE_CYCLE;
	ParametersCore.Sequence := 'CoffeeSequence.xml';

	Timer.AxisLeft.PT := T#03s;
	Timer.AxisRight.PT := T#03s;
	Timer.Coffee.PT := T#03s;
	Timer.ExecuteWait.PT := T#03s;
	Timer.Start.PT := T#500ms;
	Timer.Stop.PT := T#01s;
	Timer.TakeOutCup.PT := T#01s;
	Timer.Wait.PT := T#03s;
	Timer.StopButton.PT := T#02s;
	Timer.CoffeeWait.PT := T#01s;
 
END_PROGRAM
PROGRAM _CYCLIC

	//Set FB parameters
	MpSequenceCore_0.MpLink := ADR(gSequenceCore);
	MpSequenceCore_0.Parameters := ADR(ParametersCore);

	IF MpSequenceCore_0.ImportDone THEN
		MpSequenceCore_0.Import := FALSE;
	END_IF
	
	//Start if Start-Button is pressed
	IF SequenceStart AND MpSequenceCore_0.Info.ReadyToStart THEN
		MpSequenceCore_0.Start := TRUE;
		EditSequence := FALSE;
		MpSequenceCore_0.ErrorReset := FALSE;
	ELSE
		
		MpSequenceCore_0.Start := FALSE;
		CmdSeq.Start.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.AxisLeft.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.AxisRight.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.Coffee.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.End.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.TakeOutCup.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		CmdSeq.Wait.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
		Timer.AxisLeft.IN := FALSE;
		Timer.AxisRight.IN := FALSE;
		Timer.Coffee.IN := FALSE;
		Timer.ExecuteWait.IN := FALSE;
		Timer.Start.IN := FALSE;
		Timer.Stop.IN := FALSE;
		Timer.TakeOutCup.IN := FALSE;
		Timer.Wait.IN := FALSE;
		Timer.StopButton.IN := TRUE;
		
		Transform := '[{"select":"#g83","duration":1000,"translate":[3.497,-208.81101],"display":true}
		,{"select":"#rect999-9-2","duration":1000,"display":false}
		,{"select":"#rect999-1","duration":1000,"display":false}
		,{"select":"#path49","duration":2000,"fill":7}
		,{"select":"#path39","duration":2000,"fill":0}
		,{"select":"#path41","duration":2000,"fill":2}
		,{"select":"#path3","duration":2000,"fill":3}
		,{"select":"#gLamp1","duration":2000,"fill":7}
		,{"select":"#gLamp2","duration":2000,"fill":7}
		,{"select":"#gLamp3","duration":2000,"fill":7}
		,{"select":"#gLamp4","duration":2000,"fill":7}
		,{"select":"#gLamp5","duration":2000,"fill":7}
		,{"select":"#gLamp6","duration":2000,"fill":7}]';
		
		IF Timer.StopButton.Q THEN
			Timer.StopButton.IN := FALSE;	
		END_IF
		
		EditSequence := TRUE;
		
	END_IF
	
	
	(****************************************************************START*********************************************************************)	
	IF CmdSeq.Start.Start THEN
			
		CmdSeq.Start.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.Start.IN := TRUE;
		Transform := '[{"select":"#g83","duration":500,"display":true}]';
		IF Timer.Start.Q THEN
			Timer.Start.IN := FALSE;
			CmdSeq.Start.MovementState := mpSEQUENCE_MOVEMENT_DONE;
		END_IF
		
	ELSE
		CmdSeq.Start.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
	END_IF
	
	

	(****************************************************************AXIS LEFT*********************************************************************)
	IF CmdSeq.AxisLeft.Start THEN
			
		CmdSeq.AxisLeft.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.AxisLeft.IN := TRUE;
		Transform := '[{"select":"#g83","duration":3000,"translate":[440,-208.81101]},{"select":"#gLamp1","duration":2000,"fill":8},{"select":"#gLamp4","duration":2000,"fill":8}]';	
		IF Timer.AxisLeft.Q THEN
			Timer.AxisLeft.IN := FALSE;
			CmdSeq.AxisLeft.MovementState := mpSEQUENCE_MOVEMENT_DONE;
		END_IF
	ELSE
		CmdSeq.AxisLeft.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
	END_IF
	
	(****************************************************************AXIS RIGHT*********************************************************************)	
	IF CmdSeq.AxisRight.Start THEN

		
		CmdSeq.AxisRight.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.AxisRight.IN := TRUE;
		Transform := '[{"select":"#g83","duration":3000,"translate":[560,-208.81101]},{"select":"#gLamp3","duration":2000,"fill":10},{"select":"#gLamp6","duration":2000,"fill":10}]';
		IF Timer.AxisRight.Q THEN
			Timer.AxisRight.IN := FALSE;
			CmdSeq.AxisRight.MovementState := mpSEQUENCE_MOVEMENT_DONE;
		END_IF
	ELSE
		CmdSeq.AxisRight.MovementState := mpSEQUENCE_MOVEMENT_IDLE;		
	END_IF
		
	(****************************************************************COFFEE*********************************************************************)	
	IF CmdSeq.Coffee.Start THEN
		
		CmdSeq.Coffee.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.Coffee.IN := TRUE;
		Transform :='[{"select":"#path39","duration":2000,"fill":7}
		,{"select":"#path41","duration":2000,"fill":7}
		,{"select":"#path3","duration":2000,"fill":7}
		,{"select":"#gLamp2","duration":2000,"fill":9},
		{"select":"#gLamp5","duration":2000,"fill":9}]';	
		IF Timer.Coffee.Q THEN
			
			Timer.ExecuteWait.IN := TRUE;
			
			Transform := '[{"select":"#rect999-9-2","duration":2000,"display":true,"fill":1}
			,{"select":"#rect999-1","duration":2000,"display":true,"fill":1}
			,{"select":"#path49","duration":2000,"fill":0}
			,{"select":"#path39","duration":2000,"fill":0}
			,{"select":"#path41","duration":2000,"fill":2}
			,{"select":"#path3","duration":2000,"fill":3}]';
			IF Timer.ExecuteWait.Q THEN
				
				Timer.CoffeeWait.IN := TRUE;
				Transform := '[{"select":"#rect999-1","duration":1000,"display":false},
				{"select":"#rect999-9-2","duration":1000,"display":false},
				{"select":"#path49","duration":1000,"fill":7}]';
				IF Timer.CoffeeWait.Q THEN
					Timer.CoffeeWait.IN := FALSE;
					Timer.Coffee.IN := FALSE;
					Timer.ExecuteWait.IN := FALSE;
					CmdSeq.Coffee.MovementState := mpSEQUENCE_MOVEMENT_DONE;
				END_IF
			END_IF
		END_IF
		
	ELSE
		CmdSeq.Coffee.MovementState := mpSEQUENCE_MOVEMENT_IDLE;		
	END_IF
	
	(****************************************************************TAKEOUT*********************************************************************)	
	IF CmdSeq.TakeOutCup.Start THEN
		
		CmdSeq.TakeOutCup.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.TakeOutCup.IN := TRUE;	
		Transform := '[{"select":"#g83","duration":500,"display":false}]';	
		IF Timer.TakeOutCup.Q THEN
			Timer.TakeOutCup.IN := FALSE;
			CmdSeq.TakeOutCup.MovementState := mpSEQUENCE_MOVEMENT_DONE;
		END_IF
	ELSE
		CmdSeq.TakeOutCup.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
	END_IF
		
	
	(****************************************************************WAIT*********************************************************************)
	IF CmdSeq.Wait.Start THEN
		CmdSeq.Wait.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.Wait.IN := TRUE;
		
		IF Timer.Wait.Q THEN
			Timer.Wait.IN := FALSE;
			CmdSeq.Wait.MovementState := mpSEQUENCE_MOVEMENT_DONE;
		END_IF
	ELSE
		CmdSeq.Wait.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
	END_IF

	
	(****************************************************************STOP*********************************************************************)	
	IF CmdSeq.Stop.Start THEN
		CmdSeq.Stop.MovementState := mpSEQUENCE_MOVEMENT_ACTIVE;
		Timer.Stop.IN := TRUE;
		Transform := '[{"select":"#g83","duration":1000,"translate":[3.497,-208.81101]}
		]';	
			
		IF Timer.Stop.Q THEN
			Timer.Stop.IN := FALSE;
			CmdSeq.Stop.MovementState := mpSEQUENCE_MOVEMENT_DONE;
			Transform := '[{"select":"#g83","duration":500,"display":true}]';
			SequenceStart := FALSE;
		END_IF
	ELSE
		CmdSeq.Stop.MovementState := mpSEQUENCE_MOVEMENT_IDLE;
	END_IF
		
	(****************************************************************ERROR*********************************************************************)	
	IF MpSequenceCore_0.Error THEN
		SequenceStart := FALSE;
		MpSequenceCore_0.Import := FALSE;
		MpSequenceCore_0.ErrorReset := gCoffeeMainLogic.cmdClear;
	END_IF
	
	IF SavePressed THEN
		MpSequenceCore_0.Import := TRUE;
		SavePressed := FALSE;
	END_IF
	
	//Call FB
	MpSequenceCore_0();
	Timer.AxisLeft();
	Timer.AxisRight();
	Timer.Coffee();
	Timer.Start();
	Timer.Stop();
	Timer.TakeOutCup();
	Timer.Wait();
	Timer.ExecuteWait();
	Timer.StopButton();	
	Timer.CoffeeWait();
	
END_PROGRAM
PROGRAM _EXIT
	
	//Disable FB
	MpSequenceCore_0(Enable := FALSE);
	
END_PROGRAM
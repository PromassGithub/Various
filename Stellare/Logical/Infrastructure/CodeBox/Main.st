
PROGRAM _INIT
	
	State := WAIT;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	//Set FB parameter
	MpCodeBoxCore_0(
	MpLink := ADR(gCodeBoxCore), 
	Enable := TRUE, 
	ErrorReset := gCoffeeMainLogic.cmdClear);
	
	Cup;
	Lamp;
	
	
	
	CodeBoxTransform;
	
	CASE State OF
		WAIT:
			CodeBoxTransform := '[{"select":"#gLamp1","duration":200,"fill":7}
			,{"select":"#gLamp2","duration":200,"fill":7}
			,{"select":"#gLamp3","duration":200,"fill":7}
			,{"select":"#gLamp4","duration":200,"fill":7}
			,{"select":"#gLamp5","duration":200,"fill":7}
			,{"select":"#gLamp6","duration":200,"fill":7}]';
		
			IF gCoffeeMainLogic.PackMLState = 'Idle' THEN
				State := CUP_START_POS;
				
			END_IF
		
		
		CUP_START_POS:
			Cup.StartPosition := TRUE;
			IF Lamp.Green THEN
			
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":10}
					,{"select":"#gLamp2","duration":1000,"fill":7}
					,{"select":"#gLamp3","duration":1000,"fill":7}
					,{"select":"#gLamp4","duration":1000,"fill":10}
					,{"select":"#gLamp5","duration":1000,"fill":7}
					,{"select":"#gLamp6","duration":1000,"fill":7}]';
					
	
			ELSIF Lamp.Red THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":8}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":8}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
				
			ELSIF Lamp.Yellow THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":9}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":9}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
			ELSE
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
			END_IF

			IF gCoffeeMainLogic.PackMLState = 'Execute' THEN
				State := CUP_COFFEE;
				Cup.StartPosition := FALSE;
			END_IF
		
		
		CUP_COFFEE:
			Cup.CoffeePosition := TRUE;
			IF gCoffeeMainLogic.PackMLState = 'Completing' THEN
				State := CUP_END_POS;
				Cup.CoffeePosition := FALSE;
			END_IF
			
			IF Lamp.Green THEN
			
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":10}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":10}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
					
	
			ELSIF Lamp.Red THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":8}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":8}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
				
			ELSIF Lamp.Yellow THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":9}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":9}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
			ELSE
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
			END_IF
		CUP_END_POS:
			Cup.EndPosition := TRUE;
			IF Lamp.Green THEN
			
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":10}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":10}]';
					
	
			ELSIF Lamp.Red THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":8}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":8}]';
				
			ELSIF Lamp.Yellow THEN
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":9}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":9}]';
			ELSE
				CodeBoxTransform := '[{"select":"#gLamp1","duration":1000,"fill":7}
				,{"select":"#gLamp2","duration":1000,"fill":7}
				,{"select":"#gLamp3","duration":1000,"fill":7}
				,{"select":"#gLamp4","duration":1000,"fill":7}
				,{"select":"#gLamp5","duration":1000,"fill":7}
				,{"select":"#gLamp6","duration":1000,"fill":7}]';
			END_IF
			IF gCoffeeMainLogic.PackMLState = 'Idle' THEN
				State := WAIT;
				Cup.EndPosition := FALSE;
			END_IF
			
	END_CASE
	

	 
END_PROGRAM

PROGRAM _EXIT
	
	MpCodeBoxCore_0(Enable := FALSE);
	 
END_PROGRAM


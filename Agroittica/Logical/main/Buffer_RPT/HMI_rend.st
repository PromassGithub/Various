
(* TODO: Add your comment here *)
FUNCTION_BLOCK HMI_trend
	
	IF (pIn = 0) 	THEN pIn	:= BufferMin; END_IF
	IF (pOut = 0) 	THEN pOut	:= BufferMin; END_IF
	
	// input
	IF (INWrite) THEN
		Buffer[BufferMax] := DataIn; //insert
		
		IF (Buffer[BufferMax-1] <> -1) THEN
			Buffer[BufferMin] := -1;
			FOR pIn:=BufferMin TO BufferMax-1 DO
				IF (Buffer[pIn] = -1) THEN
					Buffer[pIn] := Buffer[pIn+1];
					Buffer[pIn+1] := -1;
				END_IF
			END_FOR;			
		END_IF
		
		FOR pIn:=BufferMax-1 TO BufferMin BY -1 DO
			IF (Buffer[pIn] = -1) THEN
				Buffer[pIn] := Buffer[pIn+1];
				Buffer[pIn+1] := -1;
			END_IF
		END_FOR;
	END_IF
	
	// output
	
	IF (INRead) THEN
		Buffer[BufferMin] := 0;
		FOR pOut:=BufferMin TO BufferMax-1 DO
			IF (Buffer[pOut] = 0) THEN
				Buffer[pOut] := Buffer[pOut+1];
				Buffer[pOut+1] := 0;
			END_IF
		END_FOR;
	END_IF
	
	DataOut := Buffer[BufferMin]; // out
	
	IF (clear_data) THEN
		FOR p:=BufferMin TO BufferMax-1 DO
			Buffer[p] := 0;
		END_FOR;
	END_IF
	
	
//	//take out data from buffer
//	IF INOutStatus = 2 THEN
//		IF NoOfDataPoints > 0 THEN //there must be data in buffer
//			DataOut := Buffer[pOut];
//			Buffer[pOut] := 0; //set to 0 to show that the value is removed
//			NoOfDataPoints := NoOfDataPoints -1;
//			IF pOut < BufferMax-1 THEN
//				pOut := pOut +1;
//			ELSE
//				pOut := BufferMin;
//			END_IF;
//		END_IF;
//	END_IF;
	
	//buffer full. last value overwritten, move pIn pointer
//	IF NoOfDataPoints >= BufferMax-1 THEN
////		pIn := pOut;
//		pIn := 6;
//	END_IF;
	
END_FUNCTION_BLOCK

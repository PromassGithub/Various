
(* TODO: Add your comment here *)
FUNCTION_BLOCK FIFO
	
	IF (pIn = 0) 	THEN pIn	:= BufferMin; END_IF
	IF (pOut = 0) 	THEN pOut	:= BufferMin; END_IF
	//IF (NoOfDataPoints > BufferMax) THEN NoOfDataPoints := BufferMax; END_IF
	
//	//insert data into buffer
//	IF INOutStatus = 1 THEN
//		IF pIn <= BufferMax THEN
//			Buffer[pIn] := DataIn; //insert
//			IF NoOfDataPoints < BufferMax THEN
//				NoOfDataPoints := NoOfDataPoints +1;
//			END_IF;
//			pIn := pIn +1; //set to next element
//		ELSE //buffer full, insert into first element
//			pIn := BufferMin;
//			Buffer[pIn] := DataIn;
//			IF NoOfDataPoints < BufferMax THEN
//				NoOfDataPoints := NoOfDataPoints +1;
//			END_IF;
//			//move pointer to next element
//			pIn := pIn + 1;
//		END_IF;
	//	END_IF;
	
	// input
	IF (INOutStatus = 1) THEN
		Buffer[6] := DataIn; //insert
		
		IF (Buffer[BufferMax] <> 0) THEN
			Buffer[BufferMin] := 0;
			FOR pIn:=BufferMin TO BufferMax DO
				IF (Buffer[pIn] = 0) THEN
					Buffer[pIn] := Buffer[pIn+1];
					Buffer[pIn+1] := 0;
				END_IF
			END_FOR;			
		END_IF
		
		FOR pIn:=BufferMax TO BufferMin BY -1 DO
			IF (Buffer[pIn] = 0) THEN
				Buffer[pIn] := Buffer[pIn+1];
				Buffer[pIn+1] := 0;
			END_IF
		END_FOR;
	END_IF
	
	// output
	
	IF (INOutStatus = 2) THEN
		DataOut := Buffer[BufferMin]; // out
		Buffer[BufferMin] := 0;
		FOR pOut:=BufferMin TO BufferMax DO
			IF (Buffer[pOut] = 0) THEN
				Buffer[pOut] := Buffer[pOut+1];
				Buffer[pOut+1] := 0;
			END_IF
		END_FOR;
	END_IF
	
		
//	//take out data from buffer
//	IF INOutStatus = 2 THEN
//		IF NoOfDataPoints > 0 THEN //there must be data in buffer
//			DataOut := Buffer[pOut];
//			Buffer[pOut] := 0; //set to 0 to show that the value is removed
//			NoOfDataPoints := NoOfDataPoints -1;
//			IF pOut < BufferMax THEN
//				pOut := pOut +1;
//			ELSE
//				pOut := BufferMin;
//			END_IF;
//		END_IF;
//	END_IF;
	
	//buffer full. last value overwritten, move pIn pointer
//	IF NoOfDataPoints >= BufferMax THEN
////		pIn := pOut;
//		pIn := 6;
//	END_IF;
	
END_FUNCTION_BLOCK

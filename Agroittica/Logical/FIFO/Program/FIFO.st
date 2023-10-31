
(* TODO: Add your comment here *)
FUNCTION_BLOCK FIFO
	//insert data into buffer
	IF INOutStatus = 1 THEN
		IF pIn <= BufferMax THEN
			Buffer[pIn] := DataIn; //insert
			IF NoOfDataPoints < BufferMax THEN
				NoOfDataPoints := NoOfDataPoints +1;
			END_IF;
			pIn := pIn +1; //set to next element
		ELSE //buffer full, insert into first element
			pIn := BufferMin;
			Buffer[pIn] := DataIn;
			//move pointer to next element
			pIn := pIn + 1;
		END_IF;
	END_IF;
	
	//take out data from buffer
	IF INOutStatus = 2 THEN
		IF NoOfDataPoints > 0 THEN //there must be data in buffer
			DataOut := Buffer[pOut];
			Buffer[pOut] := 0; //set to 0 to show that the value is removed
			NoOfDataPoints := NoOfDataPoints -1;
			IF pOut < BufferMax THEN
				pOut := pOut +1;
			ELSE
				pOut := BufferMin;
			END_IF;
		END_IF;
	END_IF;
	
	//buffer full. last value overwritten, move pIn pointer
	IF NoOfDataPoints >= BufferMax THEN
		pIn := pOut;
	END_IF;
	
	
END_FUNCTION_BLOCK

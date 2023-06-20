

PROGRAM _INIT
	(* Insert code here *)
	bOK := FALSE;
	byStep := 1;
	byErrorLevel := 0;
	strDevice       := 'HARDDISK';
	strFile         := 'TestFile';
	(* Initialize read and write data *)
	FOR i := 0 TO 99 DO
		byWriteData[i]  := i + 1;
		byReadData[i]   := 0;
	END_FOR
	 
END_PROGRAM
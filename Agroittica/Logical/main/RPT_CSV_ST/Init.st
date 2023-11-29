

PROGRAM _INIT
	(*/* Pulisco la memoria */*)

	memset (ADR(DirCreate_03),			 0, SIZEOF(DirCreate_03)   	 );
	memset (ADR(DirCreate_05),			 0, SIZEOF(DirCreate_05)   	 );
	memset (ADR(FileCreate_01),          0, SIZEOF(FileCreate_01)  	 );
	memset (ADR(FileCreate_03),          0, SIZEOF(FileCreate_03)  	 );
	memset (ADR(FileOpen_03),            0, SIZEOF(FileOpen_03)    	 );
	memset (ADR(FileWrite_01),           0, SIZEOF(FileWrite_01)   	 );
	memset (ADR(FileWrite_03),           0, SIZEOF(FileWrite_03)   	 );
	memset (ADR(FileClose_01),           0, SIZEOF(FileClose_01)	 );
	memset (ADR(FileClose_03),           0, SIZEOF(FileClose_03)	 );
	memset (ADR(string_rpt),			 0, SIZEOF(string_rpt)	 	 );
	memset (ADR(support_str),			 0, SIZEOF(support_str)  	 );
	
	step_rpt 			 := WAIT;
	RowCounterFile		 := 0;

	DirCreate_03.enable  := 1;
	DirCreate_03.pDevice := ADR(CF);
	DirCreate_03.pName   := ADR(DATA);

	DirCreate_03;

	IF ((DirCreate_03.status = 0) OR  (DirCreate_03.status = 20725)) THEN	    (*/* IF status ok (0) OR dir already exists (20725)			*/*)
		
		//DirCreate_03.status := 0;												(*/* set status ok											*/*)
	END_IF	
	
	
	DirCreate_05.enable  := 1;
	DirCreate_05.pDevice := ADR(CF);
	DirCreate_05.pName   := ADR(CFG);

	DirCreate_05;

	IF ((DirCreate_05.status = 0) OR  (DirCreate_05.status = 20725)) THEN	    (*/* IF status ok (0) OR dir already exists (20725)	 		*/*)
		
		//DirCreate_05.status := 0;												(*/* set status ok											*/*)
	END_IF
	 
END_PROGRAM
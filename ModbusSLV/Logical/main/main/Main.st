
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	HREG[0] := 44;
	//	FOR I := 1 TO 100  BY 1 DO
	I:=I+1;
	IF (I>250) THEN I:=0; END_IF;
	
	HREG[0]:=I;
	HREG[1]:=I+1;
	HREG[2]:=I+2;
	HREG[3]:=I+3;
//	END_FOR;
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


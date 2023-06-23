(********************************************************************
 * COPYRIGHT (C) BERNECKER + RAINER, AUSTRIA, A-5142 EGGELSBERG
 ********************************************************************
 * Library: AsIOAcc
 * File: AsIOAcc.typ
 * Created: 15.02.2005
 ********************************************************************
 * Global data types of library AsIOAcc
 ********************************************************************)
TYPE
	IOAC_I_TYPE : STRUCT			(*internal use*)
		StateMan	: UINT ;
		ErrMan	: UINT ;
		Init	: UDINT ;
		Taskhandle	: UDINT ;
		Semaphore	: UDINT ;
		Requestsize	: UDINT ;
		Answersize	: UDINT ;
		pAccessObj	: UDINT ;
		Offset	: UDINT ;
		flags	: UDINT ;
	END_STRUCT;
END_TYPE
(********************************************************************
COPYRIGHT: July 21, 2009 Bernecker + Rainer
=====================================================================

*********************************************************************)

PROGRAM _INIT

	CfgGetIPAddr_0.pDevice:= ADR('IF2');		(* X20 CPU *)

END_PROGRAM


PROGRAM _CYCLIC
	
	(* Get IP Address via watch required for VNC. *)
	IF (GetIPAddress = 1) THEN
		CfgGetIPAddr_0(enable := 1, pIPAddr := ADR(IP_Address), Len := 20);
		IF (CfgGetIPAddr_0.status <> ERR_FUB_BUSY) THEN
			GetIPAddress:= 0;
		END_IF
	END_IF	


END_PROGRAM

PROGRAM _EXIT


(* TODO : Add your code here *)


END_PROGRAM


TYPE
	History_Buffer_typ : 	STRUCT 
		state_not_changed : BOOL;
		state_name_19 : STRING[31];
		state_name_18 : STRING[31];
		state_name_17 : STRING[31];
		state_name_16 : STRING[31];
		state_name_15 : STRING[31];
		state_name_14 : STRING[31];
		state_name_13 : STRING[31];
		state_name_12 : STRING[31];
		state_name_11 : STRING[31];
		state_name_10 : STRING[31];
		state_name_9 : STRING[31];
		state_name_8 : STRING[31];
		state_name_7 : STRING[31];
		state_name_6 : STRING[31];
		state_name_5 : STRING[31];
		state_name_4 : STRING[31];
		state_name_3 : STRING[31];
		state_name_2 : STRING[31];
		state_name_1 : STRING[31];
		state_name_0 : STRING[31];
	END_STRUCT;
	Client_typ : 	STRUCT  (*TCP Client Variables*)
		sStep : UINT; (*TCP Client Step Variable*)
		TcpOpen_0 : TcpOpen; (*AsTCP.TcpOpen FUB*)
		TcpClient_0 : TcpClient; (*AsTCP.TcpClient FUB*)
		TcpRecv_0 : TcpRecv; (*AsTCP.TcpRecv FUB*)
		TcpSend_0 : TcpSend; (*AsTCP.TcpSend FUB*)
		TcpIoctl_0 : TcpIoctl; (*AsTCP.TcpIoctl FUB*)
		TcpClose_0 : TcpClose; (*AsTCP.TcpClose FUB*)
		linger_opt : tcpLINGER_typ; (*AsTCP.tcpLINGER_typ*)
		recv_timeout : UDINT; (*receive timeout*)
		connected : BOOL; (*a 1 se connesso*)
	END_STRUCT;
	Buffer_typ : 	STRUCT 
		Marel_Weight : STRING[50];
		Belt_Speed : STRING[50];
		keep_alive : UDINT;
	END_STRUCT;
	TCP_typ : 	STRUCT  (*Datatyp for global Variables*)
		receive_data : Buffer_typ; (*Data which has been received*)
		send_data : Buffer_typ; (*Data which should be sent*)
		bisAlive : BOOL;
	END_STRUCT;
END_TYPE

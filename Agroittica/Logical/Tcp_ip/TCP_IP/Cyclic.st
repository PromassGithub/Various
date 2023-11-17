
PROGRAM _CYCLIC
	HMI := 1;
		
	IF (Eth_connect.disable = 1) THEN Client.sStep := 40; RETURN;	
	END_IF	


	(* DATA TO SEND*)
	buffer.send_data.keep_alive 		:= buffer.send_data.keep_alive + 1; 								(* Generate a "running" variable for Data transfer *)
	IF (buffer.send_data.keep_alive > 1000000) THEN buffer.send_data.keep_alive := 0; END_IF
				
	(* DATA RECEIVED *)
	Eth_connect.Marel_Weight			:= buffer.receive_data.Marel_Weight;		
//	Eth_connect.stop_request 			:= buffer.receive_data.stop_request;
//	Eth_connect.last_cycle_request 		:= buffer.receive_data.last_cycle_request;
	
	

	

	(* AZZERO GLI STATI DEL PROTOCOLLO DI COMUNICAZIONE E DELLA LIBRERIA TCP *)
	Eth_connect.protocol_state.place_older      := 1;
	
	Eth_connect.tcp_state.tcpclient 			:= 1;
	Eth_connect.tcp_state.tcpclose  			:= 1;
	Eth_connect.tcp_state.tcperror 				:= 1;
	Eth_connect.tcp_state.tcpioctl  			:= 1;
	Eth_connect.tcp_state.tcpopen   			:= 1;
	Eth_connect.tcp_state.tcprecv   			:= 1;
	Eth_connect.tcp_state.tcpsend   			:= 1;

	(* TCP COMUNICATION PROGRAM *)		
	CASE Client.sStep OF
 	
		0: (* Open Ethernet Interface *)
			Eth_connect.tcp_state.tcpopen := 0;
			Client.TcpOpen_0.enable := 1;	
			Client.TcpOpen_0.pIfAddr := 0;  (* Which Interface to open *)
			Client.TcpOpen_0.port := 12001;  (* Port on client side to use *)
			Client.TcpOpen_0.options := 0;	
			Client.TcpOpen_0;  (* Call the Function *)
			Eth_connect.no_comunication := 1;
			
			IF Client.TcpOpen_0.status = 0 THEN  (* TcpOpen successfull *)
				Client.sStep := 5;											
			ELSIF Client.TcpOpen_0.status = ERR_FUB_BUSY THEN  (* TcpOpen not finished -> redo *)				
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Client.sStep := 100;
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF
		
		5: 		 
			Eth_connect.tcp_state.tcpioctl := 0;
			Client.linger_opt.lLinger := 0; (* linger Time = 0 *)
			Client.linger_opt.lOnOff := 1; (* linger Option ON *)
				 
			Client.TcpIoctl_0.enable := 1;
			Client.TcpIoctl_0.ident := Client.TcpOpen_0.ident; (* Connection Ident from AsTP.TCP_Open *)
			Client.TcpIoctl_0.ioctl := tcpSO_LINGER_SET; (* Set Linger Options *)
			Client.TcpIoctl_0.pData := ADR(Client.linger_opt);
			Client.TcpIoctl_0.datalen := SIZEOF(Client.linger_opt);
			Client.TcpIoctl_0;	    
		
			IF Client.TcpIoctl_0.status = 0 THEN  (* TcpIoctl successfull *)
				Client.sStep := 10;											
			ELSIF Client.TcpIoctl_0.status = ERR_FUB_BUSY THEN  (* TcpIoctl not finished -> redo *)				
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Client.sStep := 100;
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF
		
		
		10: (* Connect to the other Station *)					
			Eth_connect.tcp_state.tcpclient := 0;
			Client.TcpClient_0.enable := 1;
			Client.TcpClient_0.ident := Client.TcpOpen_0.ident;  (* Connection Ident from AsTCP.TCP_Open *)
			Client.TcpClient_0.portserv := 5555;  (* Port on server side to use *)
			Client.TcpClient_0.pServer := (*ADR('127.0.0.1');*) ADR(Eth_connect.Server_Ip_Add);  (* Server Address *)
			Client.TcpClient_0;  (* Call the Function*)
			
			IF Client.TcpClient_0.status = 0 THEN  (* Open ok -> Send Data *)
				Client.sStep := 20;	
			ELSIF Client.TcpClient_0.status = ERR_FUB_BUSY THEN  (* TcpClient not finished -> redo *)	
				(* Busy *)
			ELSIF Client.TcpClient_0.status = tcpERR_INVALID THEN  (* Port error -> Close actual connection, and reopen a new one *)
				Client.sStep := 40;
			ELSE  (* Goto Error Step *)
				Client.sStep := 100;
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF
		
		20: (* Send Data to the Server *)
			Eth_connect.tcp_state.tcpsend := 0;
			Client.TcpSend_0.enable := 1;				
			Client.TcpSend_0.ident := Client.TcpOpen_0.ident;  (* Connection Ident from AsTCP.TCP_Open *)
			Client.TcpSend_0.pData := ADR(buffer.send_data);  (* Which data to send *)
			Client.TcpSend_0.datalen := SIZEOF(buffer.send_data);  (* Lenght of data to send *)											
			Client.TcpSend_0.flags := 0;
			Client.TcpSend_0; (*call finction*)
			Eth_connect.no_comunication := 0;
			
			IF Client.TcpSend_0.status = 0 THEN  (* Data was sent sucessfully -> receive data *)
				IF (glb_data.received_data = 0) THEN	Client.sStep := 30; END_IF
			ELSIF Client.TcpSend_0.status = ERR_FUB_BUSY THEN  (* TcpSend not finished -> redo *)	
				(* Busy *)
			ELSIF (Client.TcpSend_0.status = tcpERR_SENTLEN) OR (Client.TcpSend_0.status = tcpERR_NOT_CONNECTED) THEN (* Connection Lost *)
				Client.sStep := 40;
			ELSE  (* Goto Error Step *)
				Client.sStep := 100;
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF				
					
		30: (* Receive Data from the Server *)
			memset(ADR(buffer.receive_data),0,SIZEOF(buffer.receive_data));
			
			Eth_connect.tcp_state.tcprecv := 0;
			Client.TcpRecv_0.enable := 1;
			Client.TcpRecv_0.ident := Client.TcpOpen_0.ident;  (* Connection Ident from AsTCP.TCP_Open *)
			Client.TcpRecv_0.pData	:= ADR(buffer.receive_data);  (* Where to store the incoming data *)
			Client.TcpRecv_0.datamax := SIZEOF(buffer.receive_data);  (* Lenght of data buffer *)
			Client.TcpRecv_0.flags := 0;
			Client.TcpRecv_0;  (* Call the Function*)
			Eth_connect.no_comunication := 0;
			
			IF Client.TcpRecv_0.status = 0 THEN  (* Data was received sucessfully -> Send next packet *)
				Client.sStep := 20;
				glb_data.received_data := 1;
				Client.recv_timeout := 0;
			ELSIF Client.TcpRecv_0.status = tcpERR_NO_DATA THEN  (* No data received - wait *)
				//Client.recv_timeout := Client.recv_timeout + 1;
				IF Client.recv_timeout > 50 THEN
					Client.sStep := 40;
					Client.recv_timeout := 0;
				END_IF
				(* No Data received *)
			ELSIF Client.TcpRecv_0.status = ERR_FUB_BUSY THEN  (* TcpRecv not finished -> redo *)		
				(* Busy *)
			ELSIF Client.TcpRecv_0.status = tcpERR_NOT_CONNECTED THEN (* Connection Lost *)			
				Client.sStep := 40;
			ELSE  (* Goto Error Step *)
				Client.sStep := 100;
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF
		
		40: (* Close connection *)
			Eth_connect.tcp_state.tcpclose := 0;
			Client.TcpClose_0.enable := 1;
			Client.TcpClose_0.ident := Client.TcpOpen_0.ident;  (* Connection Ident from AsTCP.TCP_Open *)
			Client.TcpClose_0.how := 0;
			Client.TcpClose_0;  (* Call the Function*)
	
			IF Client.TcpClose_0.status = 0 THEN  (* Close sucessfull -> Reopen the interface *)
				Client.sStep := 0;
			ELSIF Client.TcpClose_0.status = ERR_FUB_BUSY THEN  (* TcpClose not finished -> redo *)	
				(* Busy *)			
			ELSE  (* Goto Error Step *)
				Client.sStep := 0; // era 100
				buffer.send_data.keep_alive := 0; (* Reset the counter *)
			END_IF
		
		100: (* Here some error Handling has to be implemented *)
			Eth_connect.tcp_state.tcperror := 0;
			Eth_connect.no_comunication := 1;
			IF buffer.send_data.keep_alive >  50 THEN 	(* 1250 * 4ms = 5 seconds *)
				IF (Client.TcpOpen_0.status = 32602)  THEN
					Client.sStep := 40;
				ELSE
					Client.sStep := 40; // was 0
				END_IF
			END_IF			
	END_CASE		


END_PROGRAM


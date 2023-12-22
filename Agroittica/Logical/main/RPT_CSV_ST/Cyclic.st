
PROGRAM _CYCLIC

	//data to write
	kgb:=0;
	
	FOR kgb := 0 TO kgb < 30 DO
		rpt_row[kgb]:= 1;
	END_FOR;


	IF (NOT glb_data.Trigger) THEN  rpt_write_req := 0; END_IF
	
	IF (fucking_debug) THEN step_rpt := step_force; END_IF
		
	CASE step_rpt OF (* Stato di idle *)
		WAIT:
			TP_01.IN := 0;
			IF (glb_data.Trigger AND (NOT rpt_write_req))THEN
				
				xxx 				:= 0;
				step_rpt 			:= CHECK_FILES_NAME;
				rpt_write_req 		:= 1;				// Resetto la richiesta di scrittura del report
				glb_data.Trigger 	:= 0;			// Machine Cycle done Trigger reset;
				
				TP_01.IN := 1;
					
			END_IF
		ERROR:
			
			IF (glb_data.Trigger AND (NOT rpt_write_req))THEN
				
				xxx 				:= 0;
				step_rpt 			:= CHECK_FILES_NAME;
				rpt_write_req 		:= 1;				// Resetto la richiesta di scrittura del report
				glb_data.Trigger 	:= 0;			// Machine Cycle done Trigger reset;
					
			END_IF
			
		CHECK_FILES_NAME:	// GUARDO SE IL FILE CREATO E' LO STESSO DEL MASTER
			
			step_rpt := CREATE_FILE_NAME;
			
		CREATE_FILE_NAME: 	// CREO IL NOME DEI FILE

			memset (ADR(FileCreate_01),         0, SIZEOF(FileCreate_01)	);
			memset (ADR(FileWrite_01),          0, SIZEOF(FileWrite_01) 	);
			memset (ADR(FileClose_01),          0, SIZEOF(FileClose_01) 	);
			memset (ADR(FileCreate_03),         0, SIZEOF(FileCreate_03)    );
			memset (ADR(FileOpen_03),           0, SIZEOF(FileOpen_03)      );
			memset (ADR(FileWrite_03),          0, SIZEOF(FileWrite_03)     );
			memset (ADR(FileClose_03),          0, SIZEOF(FileClose_03)		);
			memset (ADR(string_rpt),			0, SIZEOF(string_rpt)		);
			memset (ADR(nome_file_doc),			0, SIZEOF(nome_file_doc)	);
			memset (ADR(nome_file_csv),			0, SIZEOF(nome_file_csv)	);
			memset (ADR(support_str),			0, SIZEOF(support_str)		);
			offset 		:= 0;			


			(* Trasferisco nella struttura support_str l'orario attuale *)
			DT_TO_DTStructure(glb_time, ADR(struct_time));

			(* Genero il nome del file con la data odierna formato YYYY-MM-DD *)
			
			// inserimento anno nel nome del file
			memset (ADR(support_str), 0, SIZEOF(support_str));
			itoa(struct_time.year, ADR(support_str));
			strcpy(ADR(nome_file_doc), ADR(support_str));
			strcat(ADR(nome_file_doc), ADR(space));
			
			// inserimento mese nel nome del file
			memset (ADR(support_str), 0, SIZEOF(support_str));
			itoa(struct_time.month, ADR(support_str));
			IF (strlen(ADR(support_str)) = 1) THEN strcat(ADR(nome_file_doc), ADR("0")); END_IF;
			strcat(ADR(nome_file_doc), ADR(support_str));
			strcat(ADR(nome_file_doc), ADR(space));

			// inserimento giorno nel nome del file
			memset (ADR(support_str), 0, SIZEOF(support_str));
			itoa(struct_time.day, ADR(support_str));
			IF (strlen(ADR(support_str)) = 1) THEN strcat(ADR(nome_file_doc), ADR("0")); END_IF;
			strcat(ADR(nome_file_doc), ADR(support_str));
			strcat(ADR(nome_file_doc), ADR(space));
			
			Saved_day := struct_time.day;
			
			(*Reset del progresivo quando il cambia il giorno*)
			IF (struct_time.day <> Saved_day) THEN
				Progr_num := 0;
			END_IF;
			
			(*Gestione numero progressivo, ogni 50000 elementi il progressivo avanza*)
			
			IF Progr_num = 0 THEN
				Progr_num := 1;
			END_IF;
			
			IF (filelen >= 50000) THEN
				New_CSV := 1;
			ELSE
				New_CSV := 0;
			END_IF;
			
			IF New_CSV THEN
				Progr_num := Progr_num +1;
				
			END_IF;
			
			memset (ADR(support_str), 0, SIZEOF(support_str));
			itoa(Progr_num, ADR(support_str));
			IF (strlen(ADR(support_str)) = 1) THEN strcat(ADR(nome_file_doc), ADR("0")); END_IF;
			strcat(ADR(nome_file_doc), ADR(support_str));
			
		
			
			
			
			
		
			strcpy(ADR(nome_file_csv), ADR(nome_file_doc));		
			strcat(ADR(nome_file_csv), ADR(estensione));				// creo il file YYYY-MM-DD.csv

			step_rpt := CREATE_CSV_FILE;
		
		CREATE_CSV_FILE: // CREO IL FILE .CSV

			FileCreate_03.enable  := 1;
			FileCreate_03.pDevice := ADR(DATA);
			FileCreate_03.pFile   := ADR(nome_file_csv);

			FileCreate_03;

			IF (FileCreate_03.status = 0) THEN
				
				offset 					:= 0;
				step_rpt   				:= OPEN_CSV_FILE;
				FileCreate_03.enable 	:= 0;
				RowCounterFile			:= 0;
				
			ELSIF (FileCreate_03.status = 20705) THEN (* file già esistente *)
				step_rpt 				:= OPEN_CSV_FILE;
				FileCreate_03.enable 	:= 0;
			END_IF
		
		OPEN_CSV_FILE: // APRO IL FILE CSV

			FileOpen_03.enable    := 1;
			FileOpen_03.pDevice   := ADR(DATA);
			FileOpen_03.pFile     := ADR(nome_file_csv);
			FileOpen_03.mode      := FILE_RW;

			FileOpen_03;

			IF (FileOpen_03.status = 0) THEN
				
				step_rpt := CREATE_HEADER_CSV_FILE;  		

				memset (ADR(string_rpt), 	0, SIZEOF(string_rpt)	);
				memset (ADR(support_str),   0, SIZEOF(support_str)  );

				ident_csv			:= FileOpen_03.ident;
				FileOpen_03.enable 	:= 0;
				filelen := FileOpen_03.filelen;
				
			ELSIF (FileOpen_03.status <> 65535) THEN
				
				step_rpt	 		:= ERROR;
				numero_errore   	:= FileIoGetSysError();
				FileOpen_03.enable 	:= 0;
			END_IF
		
		CREATE_HEADER_CSV_FILE:	
			
			// Il file è vuoto
			IF (filelen < 101) THEN //lunghezza della intestazione
				
				memset (ADR(string_rpt), 0, SIZEOF(string_rpt));
				// HEADER CDV FILE -------------------------------------------------------------------
				// Salvo l'intestazione di 120 caratteri
				
				//	sep:=;
				//	Report
				//	Dati misurazione particolari
				//	Mould Code := jhgfdsasdfghj;
				//
				//	Timestamp;Recipe Name;QRCode;Dato 1;Dato 2;Dato 3;Dato 4;Dato 5;Dato 6;Dato 7;Dato 8;Code;Material type;Material Color;Mould Code;Density;Volume;Peso;Temperature;Peso inserto;\n
				//  Timestamp;Recipe Name;QRCode;Dato 1;Dato 2;Dato 3;Dato 4;Dato 5;Dato 6;Dato 7;Dato 8;Code;Material type;Material Color;Mould Code;Density;Volume;Peso;Temperature;Peso inserto;\n
				//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				//	0_________1_________2_________3_________4_________5_________6_________7_________8_________9_________10________11________
				
				strcpy(ADR(string_rpt), ADR('sep:=;$r$nReport$r$nDati misurazione particolari$r$n$r$n'));				
				strcat(ADR(string_rpt), ADR('$r$n'));
				strcat(ADR(string_rpt), ADR('TIMESTAMP;BILANCIA;SENSORE PISTOLA;PISTONE SOLLEVAMENTO SU;PISTONE SOLLEVAMENTO GIU;PISTOLA 1;PISTOLA 2;'));
				strcat(ADR(string_rpt), ADR('$r$n'));
				// END HEADER ------------------------------------------------------------------------
				
				// TIMESTAMP				
				memset (ADR(support_str), 0, SIZEOF(support_str));
				ascDT(glb_data.time_stamp[xxx],ADR(support_str),SIZEOF(support_str));
				IF (strlen(ADR(support_str)) = 1) THEN strcat(ADR(string_rpt), ADR('0')); END_IF
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// BILANCIA
				memset (ADR(support_str), 0, SIZEOF(support_str));			
				strcat(ADR(string_rpt), ADR(glb_data.bilancia[xxx]));
				strcat(ADR(string_rpt), ADR(';'));
				
				// SENSORE PISTOLA
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.sensore_pistola[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTONE SOLLEVAMENTO SU
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_soll_su[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTONE SOLLEVAMENTO GIU
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_soll_giu[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTOLA 1
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
								
				// PISTOLA 2
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_pistola_2[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				strcat(ADR(string_rpt), ADR('$r$n'));

			
				filelen := 0;
				str_lenght := strlen(ADR(string_rpt)); (* restituisce la lunghezza della stringa senza terminatore nullo *)

				(* Preparo la struttura per la funzione di scrittura *)
				FileWrite_03.enable   := 1;
				FileWrite_03.ident    := ident_csv;
				FileWrite_03.offset   := filelen;
				FileWrite_03.pSrc     := ADR(string_rpt);
				FileWrite_03.len      := str_lenght;
				offset                := SIZEOF(USINT) * 240;
				
				RowCounterFile		  := 2; //2 ROWS * 110 BYTES
				filelen := filelen + str_lenght;

				step_rpt := WRITE_CSV_FILE;
				
			ELSIF (filelen > 102) THEN // Il file è già stato scritto
				
				memset (ADR(string_rpt), 0, SIZEOF(string_rpt));
				
				// TIMESTAMP				
				memset (ADR(support_str), 0, SIZEOF(support_str));
				ascDT(glb_data.time_stamp[xxx],ADR(support_str),SIZEOF(support_str));
				IF (strlen(ADR(support_str)) = 1) THEN strcat(ADR(string_rpt), ADR('0')); END_IF
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// BILANCIA
				memset (ADR(support_str), 0, SIZEOF(support_str));			
				strcat(ADR(string_rpt), ADR(glb_data.bilancia[xxx]));
				strcat(ADR(string_rpt), ADR(';'));
				
				// SENSORE PISTOLA
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.sensore_pistola[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTONE SOLLEVAMENTO SU 1
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_soll_su[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTONE SOLLEVAMENTO GIU 1
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_soll_giu[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTOLA 1
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				// PISTOLA 2
				memset (ADR(support_str), 0, SIZEOF(support_str));
				itoa(glb_data.pistone_pistola_2[xxx], ADR(support_str));
				strcat(ADR(string_rpt), ADR(support_str));
				strcat(ADR(string_rpt), ADR(';'));
				
				strcat(ADR(string_rpt), ADR('$r$n'));

			
				RowCounterFile := RowCounterFile + 1;
//				filelen := RowCounterFile * 120;
//				filelen := FileOpen_03.filelen;

				str_lenght := strlen(ADR(string_rpt)); (* restituisce la lunghezza della stringa senza terminatore nullo *)
				
				(* Preparo la struttura per la funzione di scrittura *)
				FileWrite_03.enable   := 1;
				FileWrite_03.ident    := ident_csv;
				FileWrite_03.offset   := filelen;
				FileWrite_03.pSrc     := ADR(string_rpt);
				FileWrite_03.len      := str_lenght;
				offset                := offset + (SIZEOF(USINT) * 120);

				filelen := filelen + str_lenght;
				
				step_rpt := WRITE_CSV_FILE;
				
			ELSE  // Chiamato dal controllo densità con numero di ciclo a 0
				
				step_rpt := CLOSE_CSV_FILE;
			END_IF
		
		WRITE_CSV_FILE:

			FileWrite_03;

			IF (FileWrite_03.status = 0) THEN
				glb_data.Report_recorded 		:= 1;
				step_rpt 						:= CLOSE_CSV_FILE;
				FileWrite_03.enable 		  	:= 0;
				
				IF (xxx < 199) THEN 
					xxx := xxx + 1;
					step_rpt 			:= CREATE_HEADER_CSV_FILE;
									
					//					glb_data.Trigger := 0;
				END_IF
				
			ELSIF (FileWrite_03.status <> 65535) THEN
				
				step_rpt	 		:= CLOSE_CSV_FILE;
				numero_errore   	:= FileIoGetSysError();
				FileWrite_03.enable := 0;
			END_IF
		
		CLOSE_CSV_FILE:

			FileClose_03.enable := 1;
			FileClose_03.ident  := ident_csv;
			FileClose_03;

			IF (FileClose_03.status = 0) THEN
				
//				step_rpt 				:= WAIT;
				FileClose_03.enable := 0;
				
			ELSIF (FileClose_03.status = 20721) THEN
				step_rpt 				:= WAIT;
				FileClose_03.enable := 0;
				
//				glb_data.Trigger := 1;
				
//				IF (xxx < 199) THEN 
//					xxx := xxx + 1;
//					step_rpt 			:= OPEN_CSV_FILE;
//					
////					glb_data.Trigger := 0;
//				END_IF

			ELSIF (FileClose_03.status <> 65535 AND FileClose_03.status <> 65534) THEN
				
				step_rpt	 		:= ERROR;
				
				numero_errore   	:= FileIoGetSysError();
				FileClose_03.enable := 0;
			END_IF

	END_CASE;

	
	(*********************************************** CREATE DIR WHERE SAVE THE CAVITIES INFO LINKE TO THE RECIPES **************************************************)	

	IF ((DirCreate_05.status = 0) OR (DirCreate_05.status = 20725)) THEN	    (* IF status ok (0) OR dir already exists (20725)		 	*)								
		DirCreate_05.enable 	:= 0;
	END_IF
	

	TP_01;
	 
END_PROGRAM

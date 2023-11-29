/********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: RPT_CSV
 * File: Scrittura_ReportCyclic.c
 * Author: Stefano
 * Created: January 20, 2021
 ********************************************************************
 * CUSTOM CSV REPORT MADE FOR HOUSTON FOAM
 ********************************************************************/

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
#include <AsDefault.h>
#endif
#include <asstring.h>
#include <string.h>

#define DENSITA	1
#define MASTER	0

void _CYCLIC RPT_CSV_Cyclic(void)
{
	//data to write
	kgb=0;
	
	for (kgb = 0; kgb < 30; kgb++)
	{
		rpt_row[kgb]= 1;
		
	}


	if (!glb_data.Trigger) rpt_write_req = 0;
	
	if (fucking_debug) step_rpt = step_force;
	switch (step_rpt) /* Stato di idle */
	{
		case WAIT:
		case ERROR:
			
			if 		(glb_data.Trigger && !rpt_write_req)
			{
				step_rpt = CHECK_FILES_NAME;
				rpt_write_req = 1;				// Resetto la richiesta di scrittura del report
				glb_data.Trigger = 0;			// Machine Cycle done Trigger reset;
			}
			break;;
		
		case CHECK_FILES_NAME:	// GUARDO SE IL FILE CREATO E' LO STESSO DEL MASTER
			
			step_rpt = CREATE_FILE_NAME;
	
			break;;
		
		case CREATE_FILE_NAME: 	// CREO IL NOME DEI FILE

			memset (&FileCreate_01,          0, sizeof(FileCreate_typ)		);
			memset (&FileWrite_01,           0, sizeof(FileWrite_typ) 		);
			memset (&FileClose_01,           0, sizeof(FileClose_typ) 		);
			memset (&FileCreate_03,          0, sizeof(FileCreate_typ)      );
			memset (&FileOpen_03,            0, sizeof(FileOpen_typ)        );
			memset (&FileWrite_03,           0, sizeof(FileWrite_typ)       );
			memset (&FileClose_03,           0, sizeof(FileClose_typ)		);
			memset (string_rpt,				 '\0', sizeof(string_rpt)		);
			memset (nome_file_doc,			 '\0', sizeof(nome_file_doc)	);
			memset (nome_file_csv,			 '\0', sizeof(nome_file_csv)	);
			memset (support_str,			 '\0', sizeof(support_str)		);
			offset 		= 0;			


			/* Trasferisco nella struttura support_str l'orario attuale */
			DT_TO_DTStructure(glb_time, (UDINT)&struct_time);

			/* Genero il nome del file con la data odierna formato YYYY-MM-DD */
			
			// inserimento anno nel nome del file
			memset (support_str, '\0', sizeof(support_str));
			itoa(struct_time.year, (UDINT)&support_str);
			strcpy(nome_file_doc, support_str);
			strcat(nome_file_doc, "-");
			
			// inserimento mese nel nome del file
			memset (support_str, '\0', sizeof(support_str));
			itoa(struct_time.month, (UDINT)&support_str);
			if (strlen(support_str) == 1) strcat(nome_file_doc, "0");
			strcat(nome_file_doc, support_str);
			strcat(nome_file_doc, "-");

			// inserimento giorno nel nome del file
			memset (support_str, '\0', sizeof(support_str));
			itoa(struct_time.day, (UDINT)&support_str);
			if (strlen(support_str) == 1) strcat(nome_file_doc, "0");
			strcat(nome_file_doc, support_str);
			strcat(nome_file_doc, "-");
			
//			// inserimento nome ricetta nel nome del file
//			memset (support_str, '\0', sizeof(support_str));			
//			strcat(support_str, glb_ultima_ricetta);
//			if (strlen(support_str) == 1) strcat(nome_file_doc, "0");
//			strcat(nome_file_doc, support_str);
		
			strcpy(nome_file_csv, nome_file_doc);		
			strcat(nome_file_csv, ".csv");				// creo il file YYYY-MM-DD.csv

			step_rpt = CREATE_CSV_FILE;

			break;;
		


		case CREATE_CSV_FILE: // CREO IL FILE .CSV

			FileCreate_03.enable  = 1;
			FileCreate_03.pDevice = (UDINT) "DATA";
			FileCreate_03.pFile   = (UDINT) &nome_file_csv;

			FileCreate(&FileCreate_03);

			if (FileCreate_03.status == 0)
			{
				offset 					= 0;
				step_rpt   					= OPEN_CSV_FILE;
				FileCreate_03.enable 	= 0;
				RowCounterFile			= 0;
			}
			else if (FileCreate_03.status == 20705) /* file già esistente */
			{
				step_rpt 					= OPEN_CSV_FILE;
				FileCreate_03.status 	= 0;
				FileCreate_03.enable 	= 0;
			}

			break;;


		case OPEN_CSV_FILE: // APRO IL FILE CSV

			FileOpen_03.enable    = 1;
			FileOpen_03.pDevice   = (UDINT) "DATA";
			FileOpen_03.pFile     = (UDINT) &nome_file_csv;
			FileOpen_03.mode      = FILE_RW;

			FileOpen(&FileOpen_03);

			if (FileOpen_03.status == 0)
			{
				step_rpt = CREATE_HEADER_CSV_FILE;  		

				memset (string_rpt, '\0', sizeof(string_rpt));
				memset (support_str,   '\0', sizeof(support_str)  );

				FileOpen_03.status 	= 0;
				ident_csv			= FileOpen_03.ident;
				FileOpen_03.enable 	= 0;
			}
			else if (FileOpen_03.status != 65535)
			{
				step_rpt	 			= ERROR;
				numero_errore   	= FileIoGetSysError();
				FileOpen_03.enable = 0;
			}

			break;;


		// Chiamato dal master
		case CREATE_HEADER_CSV_FILE:	
			
			// Il file è vuoto
			if (FileOpen_03.filelen < 101) //lunghezza della intestazione
			{
				// HEADER CDV FILE -------------------------------------------------------------------
				// Salvo l'intestazione di 120 caratteri
				
				//	sep=;
				//	Report
				//	Dati misurazione particolari
				//	Mould Code = jhgfdsasdfghj;
				//
				//	Timestamp;Recipe Name;QRCode;Dato 1;Dato 2;Dato 3;Dato 4;Dato 5;Dato 6;Dato 7;Dato 8;Code;Material type;Material Color;Mould Code;Density;Volume;Peso;Temperature;Peso inserto;\n
				//  Timestamp;Recipe Name;QRCode;Dato 1;Dato 2;Dato 3;Dato 4;Dato 5;Dato 6;Dato 7;Dato 8;Code;Material type;Material Color;Mould Code;Density;Volume;Peso;Temperature;Peso inserto;\n
				//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				//	0_________1_________2_________3_________4_________5_________6_________7_________8_________9_________10________11________
				
				strcpy(string_rpt, "sep=;\nReport\nDati misurazione particolari\n\n");				
				strcat(string_rpt, "\n");
//				strcat(string_rpt, "Timestamp;Recipe Name;QRCode;Dato 1;Dato 2;Dato 3;Dato 4;Dato 5;Dato 6;Dato 7;Dato 8;Code;Material type;Material Color;Mould Code;Density;Volume;Peso;Temperature;Peso inserto;");
				strcat(string_rpt, "Timestamp;Recipe Name;QRCode;");
				
				strcat(string_rpt, "\n");
				// END HEADER ------------------------------------------------------------------------
				
				// TIMESTAMP				
				memset (support_str, '\0', sizeof(support_str));
				ascDT(glb_data.time_stamp[xxx],(UDINT)&support_str,sizeof(support_str));
				if (strlen(support_str) == 1) strcat(string_rpt, "0");
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// BILANCIA
				memset (support_str, '\0', sizeof(support_str));			
				strcat(string_rpt, glb_data.bilancia[xxx]);
				strcat(string_rpt, ";");
				
				// SENSORE PISTOLA
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.sensore_pistola[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTONE SOLLEVAMENTO SU 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_soll_su[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTONE SOLLEVAMENTO GIU 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_soll_giu[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 2
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_2[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				strcat(string_rpt, "\n");

			
				filelen = 0;
				str_lenght = strlen(string_rpt); /* restituisce la lunghezza della stringa senza terminatore nullo */

				/* Preparo la struttura per la funzione di scrittura */
				FileWrite_03.enable   = 1;
				FileWrite_03.ident    = ident_csv;
				FileWrite_03.offset   = filelen;
				FileWrite_03.pSrc     = (UDINT) &string_rpt[0];
				//FileWrite_03.len      =	sizeof(USINT) * 240;
				FileWrite_03.len      =	str_lenght;
				offset                = sizeof(USINT) * 240;
				
				RowCounterFile		  = 2; //2 ROWS * 110 BYTES

				step_rpt = WRITE_CSV_FILE;
			}
			else if (FileOpen_03.filelen > 120) // Il file è già stato scritto
			{
				
				// TIMESTAMP				
				memset (support_str, '\0', sizeof(support_str));
				ascDT(glb_data.time_stamp[xxx],(UDINT)&support_str,sizeof(support_str));
				if (strlen(support_str) == 1) strcat(string_rpt, "0");
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// BILANCIA
				memset (support_str, '\0', sizeof(support_str));			
				strcat(string_rpt, glb_data.bilancia[xxx]);
				strcat(string_rpt, ";");
				
				// SENSORE PISTOLA
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.sensore_pistola[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTONE SOLLEVAMENTO SU 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_soll_su[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTONE SOLLEVAMENTO GIU 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_soll_giu[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 1
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_1[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				// PISTOLA 2
				memset (support_str, '\0', sizeof(support_str));
				itoa(glb_data.pistone_pistola_2[xxx], (UDINT)&support_str);
				strcat(string_rpt, support_str);
				strcat(string_rpt, ";");
				
				strcat(string_rpt, "\n");

			
				RowCounterFile++;
				filelen = RowCounterFile * 120;
				filelen = FileOpen_03.filelen;

				str_lenght = strlen(string_rpt); /* restituisce la lunghezza della stringa senza terminatore nullo */
				
				/* Preparo la struttura per la funzione di scrittura */
				FileWrite_03.enable   = 1;
				FileWrite_03.ident    = ident_csv;
				FileWrite_03.offset   = filelen;
				FileWrite_03.pSrc     = (UDINT) &string_rpt[0];
				//FileWrite_03.len      =	sizeof(USINT) * 120;
				FileWrite_03.len      =	str_lenght;
				offset               += sizeof(USINT) * 120;

				step_rpt = WRITE_CSV_FILE;
			}
			else  // Chiamato dal controllo densità con numero di ciclo a 0
			{
				step_rpt = CLOSE_CSV_FILE;
			}

			break;


		case WRITE_CSV_FILE:

			FileWrite(&FileWrite_03);

			if (FileWrite_03.status == 0)
			{
				//glb_comandi.cmd_scrivi_report 	= 0;					// Resetto la richiesta di scrittura del report
				//rpt_write_req				 	= 0;
				glb_data.Report_recorded 		= 1;
				step_rpt 						  	= CLOSE_CSV_FILE;
				FileWrite_03.enable 		  	= 0;
			}
			else if (FileWrite_03.status != 65535)
			{
				step_rpt	 			= CLOSE_CSV_FILE;
				numero_errore   	= FileIoGetSysError();
				FileWrite_03.enable = 0;
			}

			break;;


		case CLOSE_CSV_FILE:

			FileClose_03.enable = 1;
			FileClose_03.ident  = ident_csv;
			//rpt_write_req				 	= 0;

			FileClose(&FileClose_03);

			if (FileClose_03.status == 0)
			{
				step_rpt 				= WAIT;
				FileClose_03.enable = 0;
			}
			else if (FileClose_03.status != 65535)
			{
				step_rpt	 			= WAIT;
				numero_errore   	= FileIoGetSysError();
				FileClose_03.enable = 0;
			}

			break;;
	}
	
	
	
	/*********************************************** CREATE DIR WHERE SAVE THE CAVITIES INFO LINKE TO THE RECIPES **************************************************/	
	
	

	if ((DirCreate_05.status == 0) ||  (DirCreate_05.status == 20725))	    /* if status ok (0) or dir already exists (20725)		 	*/
	{										
		DirCreate_05.enable 	= 0;
	}
	


}

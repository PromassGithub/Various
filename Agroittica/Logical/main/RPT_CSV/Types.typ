
TYPE
	Enum_Step : 
		(
		WAIT := 0, (*ATTESA*)
		CHECK_FILES_NAME := 1, (*CONTROLLO_NOMI_FILES*)
		CREATE_FILE_NAME := 2, (*CREO_NOMI_FILE*)
		DELETE_DOC_FILE := 3, (*ELIMINO_FILE_DOC*)
		CREATE_DOC_FILE := 4, (*CREO_FILE_DOC*)
		PREPARE_DOC_FILE := 5, (*PREPARO_FILE_DOC*)
		WRITE_DOC_FILE := 6, (*SCRIVO_FILE_DOC*)
		CLOSE_DOC_FILE := 7, (*CHIUDO_FILE_DOC*)
		CREATE_CSV_FILE := 8, (*CREO_FILE_CSV*)
		OPEN_CSV_FILE := 9, (*APRO_FILE_CSV*)
		CREATE_HEADER_CSV_FILE := 10, (*PREPARO_FILE_CSV*)
		WRITE_CSV_FILE := 11, (*SCRIVO_FILE_CSV*)
		CLOSE_CSV_FILE := 12, (*CHIUDO_FILE_CSV*)
		ERROR := 13 (*ERRORE*)
		);
	typAlarmHistory : 	STRUCT 
		id : UDINT;
		description : STRING[80];
	END_STRUCT;
END_TYPE
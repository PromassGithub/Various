
TYPE
	TypDo : 	STRUCT 
		PompaAspirazione : BOOL;
	END_STRUCT;
	TypAi : 	STRUCT 
		Bilancia : INT;
	END_STRUCT;
	TypAo : 	STRUCT 
		Valvola : INT;
	END_STRUCT;
	TypIO : 	STRUCT 
		Ai : TypAi;
		Ao : TypAo;
		Do : TypDo;
	END_STRUCT;
END_TYPE

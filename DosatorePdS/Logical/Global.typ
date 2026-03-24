
TYPE
	TypDo : 	STRUCT 
		PompaAspirazione : BOOL;
	END_STRUCT;
	TypAi : 	STRUCT 
		Valvola : INT;
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
	Typ_recipe : 	STRUCT 
		PesoRichiesto : REAL;
		fPesoAnticipoChiusura : REAL;
		fSogliaDosaggioLento : REAL;
		fSogliaMicrodosaggio : REAL;
		fPercentualeValvolaVeloce : REAL;
		fPercentualeValvolaLenta : REAL;
		fPercentualeValvolaFine : REAL;
		fFattoreCorrezione : REAL;
	END_STRUCT;
END_TYPE

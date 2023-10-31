
TYPE
	CodeBox_State : 
		(
		WAIT := 0,
		CUP_COFFEE := 1,
		CUP_END_POS := 2,
		CUP_START_POS := 3
		);
	Cup_Type : 	STRUCT 
		StartPosition : BOOL;
		EndPosition : BOOL;
		CoffeePosition : BOOL;
	END_STRUCT;
	Lamp_type : 	STRUCT 
		Red : BOOL;
		Yellow : BOOL;
		Green : BOOL;
	END_STRUCT;
END_TYPE

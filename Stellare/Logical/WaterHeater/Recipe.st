// registering the water temperature as additional parameter to be saved with the recipe parameters
ACTION RecipeRegister: 
	
	MpRecipeRegPar_0(MpLink := ADR(gRecipeXml), 
	Enable := TRUE, 
	PVName := ADR('WaterHeater:WaterTemp'));
	
END_ACTION

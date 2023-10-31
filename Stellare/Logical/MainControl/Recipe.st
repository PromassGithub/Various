// registering the PictureIndex variable as additional parameter to be saved with the recipe parameters
ACTION RecipeRegister: 
	
	MpRecipeRegPar_0(MpLink := ADR(gRecipeXml), 
	Enable := TRUE, 
	PVName := ADR('gCoffeeMainLogic.visPictureIndex'));
	
END_ACTION

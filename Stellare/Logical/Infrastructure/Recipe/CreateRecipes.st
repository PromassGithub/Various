
ACTION CreateRecipes: 

	// create default recipes in case they don't exist yet on the target
	// recipes are created by using the the MpRecipeXml instance interface
	
	CASE RecipeCreateStep OF
		IDLE:	// check for load error > triggers the default creation > if no error everything is ready to go
			IF (MpRecipeUIConnect.Recipe.List.Names[0] = '') THEN
				MpRecipeXml_0.Load 			:= FALSE;
				MpRecipeXml_0.ErrorReset 	:= TRUE;
				RecipeCreateStep 			:= CREATE_1;
			ELSE
				MpRecipeUIConnect.Recipe.Load := TRUE;
			END_IF
			
				
			
			// reset the load command from the init when recipe was loaded successfully
			IF (MpRecipeXml_0.CommandDone) AND (MpRecipeXml_0.Load = TRUE) THEN
				MpRecipeXml_0.Load 				:= FALSE;			
			END_IF
		
		CREATE_1:	// create the first recipe with default values, file name and a known picture index (Bitmap Group in the HMI) 
			MpRecipeXml_0.ErrorReset 			:= FALSE;
			
			gCoffeeMainLogic.CreateFirstRecipe 	:= TRUE;
			gCoffeeMainLogic.visPictureIndex	:= 1;
			CoffeeIngredients.Milk 				:= 0;
			CoffeeIngredients.Water 			:= 150;
			CoffeeIngredients.Sugar 			:= 0;
			CoffeeIngredients.Coffee 			:= 60;
			MpRecipeXml_0.FileName 				:= ADR('mappRegular.xml');
			MpRecipeXml_0.Save					:= TRUE;
			RecipeCreateStep 					:= DONE_1;
		
		DONE_1:	// when CommandDone GoTo next step
			IF(MpRecipeXml_0.CommandDone) THEN
				RecipeCreateStep 			:= CREATE_2;
				MpRecipeXml_0.Save			:= FALSE;
			END_IF;
		
		CREATE_2:	// create the next recipe with default values, file name and a known picture index (Bitmap Group in the HMI) 
			
			gCoffeeMainLogic.visPictureIndex	:= 2;
			CoffeeIngredients.Milk 				:= 0;
			CoffeeIngredients.Water 			:= 75;
			CoffeeIngredients.Sugar 			:= 0;
			CoffeeIngredients.Coffee 			:= 120;
			MpRecipeXml_0.FileName 				:= ADR('mappEspresso.xml');
			MpRecipeXml_0.Save					:= TRUE;
			RecipeCreateStep 					:= DONE_2;
		
		DONE_2:	// when CommandDone GoTo next step
			IF (MpRecipeXml_0.CommandDone) THEN
				RecipeCreateStep 			:= CREATE_3;
				MpRecipeXml_0.Save			:= FALSE;
			END_IF;
		
		CREATE_3:	// create the next recipe with default values, file name and a known picture index (Bitmap Group in the HMI)
			
			gCoffeeMainLogic.visPictureIndex	:= 3;
			CoffeeIngredients.Milk 				:= 75;
			CoffeeIngredients.Water 			:= 75;
			CoffeeIngredients.Sugar 			:= 20;
			CoffeeIngredients.Coffee 			:= 120;
			MpRecipeXml_0.FileName 				:= ADR('mappCappuccino.xml');
			MpRecipeXml_0.Save					:= TRUE;
			RecipeCreateStep 					:= DONE_3;
		
		DONE_3:	// when CommandDone creating recipes is done
			IF(MpRecipeXml_0.CommandDone) THEN
				RecipeCreateStep 					:= CREATE_4;
				MpRecipeXml_0.Save					:= FALSE;
			END_IF;
		CREATE_4:	// create the next recipe with default values, file name and a known picture index (Bitmap Group in the HMI)
			
			gCoffeeMainLogic.visPictureIndex	:= 3;
			CoffeeIngredients.Milk 				:= 100;
			CoffeeIngredients.Water 			:= 50;
			CoffeeIngredients.Sugar 			:= 0;
			CoffeeIngredients.Coffee 			:= 60;
			MpRecipeXml_0.FileName 				:= ADR('mappMilkCoffee.xml');
			MpRecipeXml_0.Save					:= TRUE;
			MpRecipeUIConnect.Recipe.Refresh 	:= TRUE;
			RecipeCreateStep 					:= DONE_4;
		
		DONE_4:	// when CommandDone creating recipes is done
			IF(MpRecipeXml_0.CommandDone) THEN
				RecipeCreateStep 					:= ALL_DONE;
				MpRecipeXml_0.Save					:= FALSE;
				gCoffeeMainLogic.CreateFirstRecipe 	:= FALSE;
				MpRecipeUIConnect.Recipe.Refresh 	:= FALSE;
			END_IF;
	END_CASE;

END_ACTION
